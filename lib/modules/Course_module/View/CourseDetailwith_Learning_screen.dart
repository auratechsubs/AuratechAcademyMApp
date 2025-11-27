import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../../../constant/constant_colors.dart';
import '../Controller/Learning_Module_Controller.dart';
import '../Model/Course_Master_Model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

import '../Model/Learning_Module_Model.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseMaster course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  final Learning_Module_Controller learningCtrl = Get.find();
  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      learningCtrl.fetchLearningModules(courseId: widget.course.id);
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _fullUrl(String path) {
    if (path.isEmpty) return '';
    final p = path.toLowerCase();
    if (p.startsWith('http://') || p.startsWith('https://')) return path;
    return 'https://api.auratechacademy.com/${path.replaceFirst(RegExp(r"^/+"), "")}';
  }

  /// ----------------- BUILD VIDEO MODULES FROM API -----------------

  List<CourseModule> _buildVideoModules(List<CourseVideoModel> items) {
    final videos =
        items.where((v) => (v.course_video ?? '').isNotEmpty).toList();

    debugPrint('🎬 Total video items from API: ${videos.length}');

    final Map<String, List<CourseVideoModel>> byModule = {};

    for (final v in videos) {
      final moduleTitle = learningCtrl.getModuleTitle(v).isNotEmpty
          ? learningCtrl.getModuleTitle(v)
          : 'Module';

      debugPrint(
          '📦 Grouping video id=${v.id} under module="$moduleTitle" title="${learningCtrl.getVideoTitle(v)}"');

      byModule.putIfAbsent(moduleTitle, () => []).add(v);
    }

    return byModule.entries.map((entry) {
      final moduleTitle = entry.key;
      final lessonList = entry.value.map((cv) {
        final videoUrl = learningCtrl.buildFullVideoUrl(cv);
        final pdfUrl = learningCtrl.buildFullPdfUrl(cv);
        final hasPdf = (cv.pdf_file ?? '').isNotEmpty;
        final hasNotes = cv.description.trim().isNotEmpty;

        debugPrint(
            '  ➜ Lesson from video id=${cv.id}, title="${learningCtrl.getVideoTitle(cv)}", hasPdf=$hasPdf, hasNotes=$hasNotes');

        return LessonData(
          source: cv,
          title: learningCtrl.getVideoTitle(cv),
          url: videoUrl,
          duration:
              '08:00', // TODO: API se actual duration aaye to yaha bind karo
          hasPdf: hasPdf,
          pdfTitle: hasPdf ? learningCtrl.getPdfTitle(cv) : null,
          pdfUrl: hasPdf ? pdfUrl : null,
          hasNotes: hasNotes,
          notes: hasNotes ? learningCtrl.getNotes(cv) : null,
          videoId: cv.id,
        );
      }).toList();

      debugPrint(
          '📚 Built module "$moduleTitle" with ${lessonList.length} lessons');

      return CourseModule(
        title: moduleTitle,
        lessons: lessonList,
      );
    }).toList();
  }

  /// ----------------- BUILD NOTES / PDF MODULES FROM API -----------------
  List<NotesModule> _buildNotesModules(List<CourseVideoModel> items) {
    final pdfItems = items.where((v) => (v.pdf_file ?? '').isNotEmpty).toList();

    final Map<String, List<CourseVideoModel>> byModule = {};

    for (final v in pdfItems) {
      final title = learningCtrl.getModuleTitle(v).isNotEmpty
          ? learningCtrl.getModuleTitle(v)
          : 'Module';
      byModule.putIfAbsent(title, () => []).add(v);
    }

    return byModule.entries.map((entry) {
      final moduleTitle = entry.key;
      final notes = entry.value.map((cv) {
        return PdfItem(
          title: learningCtrl.getPdfTitle(cv),
          url: learningCtrl.buildFullPdfUrl(cv),
        );
      }).toList();

      return NotesModule(
        title: moduleTitle,
        notes: notes,
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.course;
    final heroUrl = c.courseImage.isNotEmpty
        ? c.courseImage
        : (c.courseThumbImage.isNotEmpty
            ? c.courseThumbImage
            : 'https://picsum.photos/1200/800?blur=2');

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Obx(() {
        // 👉 state from controller
        final isLoading = learningCtrl.isLoading.value;
        final error = learningCtrl.errorMessage.value;
        final videos = learningCtrl.courseVideos;

        // Build dynamic lists
        final videoModules = _buildVideoModules(videos);
        final notesModules = _buildNotesModules(videos);
        final allQuizzes = learningCtrl.allQuizzes;

        final totalVideos = learningCtrl.videoItems.length;
        final totalAssessments = allQuizzes.length;
        final totalResources = learningCtrl.pdfItems.length;

        if (isLoading && videos.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (error.isNotEmpty && videos.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
          );
        }

        return CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              stretch: true,
              expandedHeight: 280,
              backgroundColor: AppColors.primary,
              title: Text(
                c.courseTitle,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis,
              ),
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(_fullUrl(heroUrl), fit: BoxFit.cover),
                    Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.transparent, Colors.black54],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: [
                  _TabsHeader(tabController: _tabController),
                  _TabViews(tabController: _tabController, course: c),
                  const SizedBox(height: 20),
                  _LearningHub(
                    course: c,
                    totalVideos: totalVideos,
                    totalAssessments: totalAssessments,
                    totalResources: totalResources,
                    onOpenVideos: () {
                      if (videoModules.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('Videos will be available soon.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LearningVideosPage(
                            title: c.courseTitle,
                            modules: videoModules,
                            quizzes: allQuizzes,
                          ),
                        ),
                      );
                    },
                    onOpenMaterials: () {
                      if (notesModules.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Notes / PDFs will be available soon.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LearningMaterialsPage(
                            title: c.courseTitle,
                            modules: notesModules,
                          ),
                        ),
                      );
                    },
                    onOpenQuiz: () {
                      if (allQuizzes.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content:
                                  Text('Quiz coming soon for this course.')),
                        );
                        return;
                      }
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => QuizPage(
                            title: c.courseTitle,
                            quizzes: allQuizzes,
                          ),
                        ),
                      );
                    },
                    onOpenCertificate: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CertificatePage(
                            courseTitle: c.courseTitle,
                            userName: 'Sohil Khan',
                            completedOn: DateTime.now(),
                            priceText: '₹349 (Inc. GST)',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            )
          ],
        );
      }),
    );
  }
}

class _TabsHeader extends StatelessWidget {
  final TabController tabController;
  const _TabsHeader({required this.tabController});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Card(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: TabBar(
            //indicatorColor: Colors.transparent,
            dividerColor: Colors.transparent,
            controller: tabController,
            labelStyle: const TextStyle(fontWeight: FontWeight.w700),
            indicator: BoxDecoration(
              color: AppColors.primary.withOpacity(.08),
              border: Border.all(color: AppColors.primary.withOpacity(.25)),
              borderRadius: BorderRadius.circular(12),
            ),
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textPrimary,
            tabs: const [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Tab(text: 'Overview'),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Tab(text: 'Curriculum'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabViews extends StatelessWidget {
  final TabController tabController;
  final CourseMaster course;
  const _TabViews({required this.tabController, required this.course});

  // Turn HTML-ish text into bullet/numbered lines for Overview learnings
  List<_Line> _parseLearn(String html) => _HtmlText.toLines(html);

  // Curriculum may also be HTML; parse the same way
  List<_Line> _parseCurriculum(String html) => _HtmlText.toLines(html);

  @override
  Widget build(BuildContext context) {
    final detail = course.courseDetail;
    final learnLines = _parseLearn(detail?.whatYouLearn ?? '');
    final curriculumLines = _parseCurriculum(detail?.curriculum ?? '');
    final theme = Theme.of(context);

    // Bound the TabBarView height to avoid layout exceptions in slivers
    final double tabViewHeight = 340;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: SizedBox(
        height: tabViewHeight,
        child: TabBarView(
          controller: tabController,
          children: [
            // Overview
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  if (detail?.certification.isNotEmpty == true)
                    Text(
                      'Certification',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        fontSize: 20,
                      ),
                    ),
                  const SizedBox(height: 6),
                  Text(
                    _HtmlText.inline(detail!.certification),
                    style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  if (learnLines.isNotEmpty)
                    Text(
                      'What you\'ll learn',
                      style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                          fontSize: 20),
                    ),
                  const SizedBox(height: 6),
                  ...learnLines.map((line) => _BulletOrNumber(line)),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 12,
                    runSpacing: 6,
                    children: [
                      if (course.courseLesson.isNotEmpty)
                        _KVChip(
                            k: 'Lessons',
                            v: _HtmlText.inline(course.courseLesson)),
                      if (course.quizzes.isNotEmpty)
                        _KVChip(
                            k: 'Quizzes', v: _HtmlText.inline(course.quizzes)),
                    ],
                  ),
                ],
              ),
            ),

            // Curriculum
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: curriculumLines.isEmpty
                  ? Text('Curriculum will be available soon.',
                      style: theme.textTheme.bodyMedium
                          ?.copyWith(color: AppColors.textSecondary))
                  : ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: curriculumLines.length,
                      itemBuilder: (context, i) {
                        final ln = curriculumLines[i];
                        return ListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          leading: CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.background,
                            child: Text(
                              '${i + 1}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary),
                            ),
                          ),
                          title: Text(
                            ln.text,
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style:
                                const TextStyle(color: AppColors.textPrimary),
                          ),
                          subtitle: const Text('Lecture • Preview',
                              style: TextStyle(color: AppColors.textSecondary)),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LearningHub extends StatelessWidget {
  final CourseMaster course;
  final VoidCallback onOpenVideos;
  final VoidCallback onOpenMaterials;
  final VoidCallback onOpenQuiz;
  final VoidCallback onOpenCertificate;

  final int totalVideos;
  final int totalAssessments;
  final int totalResources;

  const _LearningHub({
    required this.course,
    required this.onOpenVideos,
    required this.onOpenMaterials,
    required this.onOpenQuiz,
    required this.onOpenCertificate,
    required this.totalVideos,
    required this.totalAssessments,
    required this.totalResources,
  });

  @override
  Widget build(BuildContext context) {
    final progress = 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          Card(
              color: AppColors.surface,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${0} / $totalVideos Videos  •  ${0} / $totalAssessments Assessments  •  ${0} / $totalResources Resources',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 10),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        minHeight: 8,
                        value: progress,
                        backgroundColor: AppColors.background,
                        valueColor:
                            const AlwaysStoppedAnimation(AppColors.primary),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // certificate banner card
                    Card(
                      color: AppColors.surface,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: AppColors.primary),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(14),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.asset(
                                "assets/images/Cirtificate_Preview_Image.png",
                                width: 100,
                                height: 80,
                                fit: BoxFit.contain,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'Buy the certificate to showcase your skills\n₹349 Inc. of GST',
                                style: TextStyle(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w600,
                                  height: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: onOpenCertificate,
                        child: const Text('Get Certificate',
                            style: TextStyle(fontWeight: FontWeight.w800)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Tabs like screenshot
                    DefaultTabController(
                      length: 3,
                      child: Column(
                        children: [
                          Card(
                            color: AppColors.surface,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                              side: const BorderSide(color: AppColors.border),
                            ),
                            child: const TabBar(
                              labelStyle:
                                  TextStyle(fontWeight: FontWeight.w700),
                              labelColor: AppColors.primary,
                              unselectedLabelColor: AppColors.textPrimary,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicatorColor: Colors.transparent,
                              tabs: [
                                Tab(text: 'Learning'),
                                Tab(text: 'Notes'),
                                Tab(text: 'Related Courses'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Tab content cards
                          SizedBox(
                            height: 160,
                            child: TabBarView(
                              children: [
                                // Learning tab
                                ListView(
                                  padding: EdgeInsets.zero,
                                  children: [
                                    _NavTile(
                                      title: 'Learning Videos',
                                      subtitle: '$totalVideos Videos',
                                      icon: Icons.play_circle_fill_rounded,
                                      onTap: onOpenVideos,
                                    ),
                                    // _NavTileLock(
                                    //   title: 'Quiz',
                                    //   subtitle: '1 Assessment',
                                    //   isLocked: false, // set true if gated
                                    //   onTap: onOpenQuiz,
                                    // ),
                                    _NavTileLock(
                                      title: 'Claim your certificate',
                                      subtitle: '1 Assessment',
                                      isLocked: false, // set true if gated
                                      onTap: onOpenCertificate,
                                    ),
                                    // _NavTile(
                                    //   title: 'Learning Materials',
                                    //   subtitle: '$totalResources Resources',
                                    //   icon: Icons.menu_book_rounded,
                                    //   onTap: onOpenMaterials,
                                    // ),
                                  ],
                                ),

                                // Notes tab
                                _InfoPlaceholder(
                                  title: 'Notes',
                                  message:
                                      'Your saved notes will appear here once you start learning.',
                                ),

                                // Related courses
                                _InfoPlaceholder(
                                  title: 'Related Courses',
                                  message:
                                      'We’ll recommend related courses here. (Coming soon)',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
        ],
      ),
    );
  }
}

///certificate  page
class CertificatePage extends StatelessWidget {
  final String courseTitle;
  final String userName;
  final DateTime completedOn;
  final String priceText;

  const CertificatePage({
    super.key,
    required this.courseTitle,
    required this.userName,
    required this.completedOn,
    this.priceText = '',
  });

  // ---------------------- UI ----------------------
  @override
  Widget build(BuildContext context) {
    // UI me dd/MM/yyyy jaise reference image
    final dateStr = DateFormat('dd/MM/yyyy').format(completedOn);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title:
            Text('$courseTitle • Certificate', overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.background,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Auratech Academy',
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.08),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text(
                          'Verified Certificate',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    ],
                  ),
                  if (priceText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(
                      priceText,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  ],

                  const SizedBox(height: 12),

                  AspectRatio(
                    aspectRatio: 6 / 7,
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: SizedBox(
                        width: 400,
                        height: 520,
                        child: _CertificatePreview(
                          userName: userName,
                          courseTitle: courseTitle,
                          completedOn: dateStr,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.picture_as_pdf_rounded),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _downloadPdf(context),
                          label: const Text(
                            'Download PDF',
                            style: TextStyle(fontSize: 12.5),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.share_rounded),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () => _sharePdf(context),
                          label: const Text('Share'),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------- PDF GEN (new design like image) ----------------------
  Future<pw.Document> _buildPdf() async {
    final pdf = pw.Document();

    // same dd/MM/yyyy
    final dateStr = DateFormat('dd/MM/yyyy').format(completedOn);

    final gold = const PdfColor.fromInt(0xFFD0A95A);
    final textPrimary = const PdfColor.fromInt(0xFF111111);
    final textSecondary = const PdfColor.fromInt(0xFF666666);
    final bg = const PdfColor.fromInt(0xFFF9FAFB);
    final navy = const PdfColor.fromInt(0xFF1F3B5C);

    // 🔥 custom page: approx 400×520 ratio
    // (points: 1pt ≈ 1/72 inch, exact pixels matter nahi, ratio important hai)
    const pageFormat = PdfPageFormat(400, 520); // same feel as UI
    final logoBytes = await rootBundle.load('assets/icons/applogo.png');
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        margin: const pw.EdgeInsets.all(24),
        build: (context) {
          return pw.Center(
              child: pw.Container(
            color: PdfColors.white,
            child: pw.Container(
              decoration: pw.BoxDecoration(
                color: PdfColors.white,
                boxShadow: [
                  pw.BoxShadow(
                    color: PdfColor.fromInt(0x22000000),
                    blurRadius: 8,
                    offset: const PdfPoint(0, -2),
                  ),
                ],
              ),
              child: pw.Padding(
                padding: const pw.EdgeInsets.all(18),
                child: pw.Container(
                  decoration: pw.BoxDecoration(
                    color: bg,
                    border: pw.Border.all(color: PdfColors.white, width: 0),
                  ),
                  child: pw.Padding(
                    padding: const pw.EdgeInsets.all(12),
                    child: pw.Container(
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: gold, width: 2),
                      ),
                      child: pw.Padding(
                        padding: const pw.EdgeInsets.all(18),
                        child: pw.Container(
                          decoration: pw.BoxDecoration(
                            border: pw.Border.all(color: gold, width: 0.7),
                          ),
                          child: pw.Padding(
                            padding: const pw.EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 24,
                            ),
                            child: pw.Column(
                              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                              children: [
                                // ===== top logo + academy text =====
                                pw.Column(
                                  mainAxisSize: pw.MainAxisSize.min,
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Container(
                                      width: 100,
                                      height: 40,
                                      decoration: pw.BoxDecoration(
                                        color: PdfColors.white,
                                        borderRadius:
                                            pw.BorderRadius.circular(6),
                                        border: pw.Border.all(color: navy)
                                      ),
                                      child: pw.Center(
                                        child: pw.Image(
                                          logoImage,

                                         fit: pw.BoxFit.contain // optional
                                        ),
                                      ),

                                    ),
                                    pw.SizedBox(height: 8),
                                    pw.Text(
                                      'AURATECH',
                                      style: pw.TextStyle(
                                        color: textPrimary,
                                        fontSize: 14,
                                        letterSpacing: 3,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    pw.Text(
                                      'ACADEMY',
                                      style: pw.TextStyle(
                                        color: textSecondary,
                                        fontSize: 10,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                  ],
                                ),

                                pw.SizedBox(height: 20),

                                // ===== main heading =====
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      'CERTIFICATE',
                                      style: pw.TextStyle(
                                        color: textPrimary,
                                        fontSize: 22,
                                        fontWeight: pw.FontWeight.bold,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                    pw.Text(
                                      'OF COMPLETION',
                                      style: pw.TextStyle(
                                        color: textPrimary,
                                        fontSize: 16,
                                        fontWeight: pw.FontWeight.bold,
                                        letterSpacing: 3,
                                      ),
                                    ),
                                  ],
                                ),

                                pw.SizedBox(height: 24),

                                // ===== presented to + name + course + date =====
                                pw.Column(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.center,
                                  children: [
                                    pw.Text(
                                      'PRESENTED TO',
                                      style: pw.TextStyle(
                                        color: textSecondary,
                                        fontSize: 9,
                                        letterSpacing: 2,
                                      ),
                                    ),
                                    pw.SizedBox(height: 8),
                                    pw.Text(
                                      userName,
                                      style: pw.TextStyle(
                                        color: textPrimary,
                                        fontSize: 20,
                                        fontWeight: pw.FontWeight.bold,
                                      ),
                                    ),
                                    pw.SizedBox(height: 10),
                                    pw.Text(
                                      courseTitle,
                                      style: pw.TextStyle(
                                        color: textPrimary,
                                        fontSize: 13,
                                      ),
                                    ),
                                    pw.SizedBox(height: 12),
                                    pw.Text(
                                      dateStr,
                                      style: pw.TextStyle(
                                        color: textSecondary,
                                        fontSize: 10,
                                      ),
                                    ),
                                  ],
                                ),

                                pw.Spacer(),

                                // ===== bottom row: signature + QR =====
                                pw.Row(
                                  mainAxisAlignment:
                                      pw.MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: pw.CrossAxisAlignment.end,
                                  children: [
                                    pw.Column(
                                      crossAxisAlignment:
                                          pw.CrossAxisAlignment.start,
                                      children: [
                                        pw.SizedBox(height: 4),
                                        pw.Text(
                                          'Sona sharma',
                                          style: pw.TextStyle(
                                            color: textPrimary,
                                            fontSize: 14,
                                            fontStyle: pw.FontStyle.italic,
                                          ),
                                        ),
                                        pw.Container(
                                          height: 0.8,
                                          width: 120,
                                          color: textPrimary,
                                        ),
                                        pw.SizedBox(height: 4),
                                        pw.Text(
                                          'Sona Sharma',
                                          style: pw.TextStyle(
                                            color: textSecondary,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ],
                                    ),
                                    pw.BarcodeWidget(
                                      data:
                                          'AURATECH|$userName|$courseTitle|$dateStr',
                                      barcode: pw.Barcode.qrCode(),
                                      width: 60,
                                      height: 60,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );

    return pdf;
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final doc = await _buildPdf();
    await Printing.layoutPdf(onLayout: (_) => doc.save());
  }

  Future<void> _sharePdf(BuildContext context) async {
    final doc = await _buildPdf();
    await Printing.sharePdf(
      bytes: await doc.save(),
      filename: 'Auratech_Certificate_$userName.pdf',
    );
  }
}

/// =======================
/// NEW CERTIFICATE PREVIEW
/// =======================
class _CertificatePreview extends StatelessWidget {
  final String userName;
  final String courseTitle;
  final String completedOn;

  const _CertificatePreview({
    required this.userName,
    required this.courseTitle,
    required this.completedOn,
  });

  @override
  Widget build(BuildContext context) {
    const gold = Color(0xFFD0A95A);
    const navy = Color(0xFF1F3B5C);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF9FAFB),
            border: Border.all(color: Colors.white, width: 0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: gold, width: 2),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: gold, width: 0.8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // top logo + title
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 100,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: navy, width: 1)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5.0),
                                child: Image.asset(
                                  "assets/icons/applogo.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'AURATECH',
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'ACADEMY',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                letterSpacing: 3,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 22),

                        // main heading
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: const [
                            Text(
                              'CERTIFICATE',
                              style: TextStyle(
                                fontSize: 24,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'OF COMPLETION',
                              style: TextStyle(
                                fontSize: 18,
                                letterSpacing: 3,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 26),

                        // presented to + name + course + date
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              'PRESENTED TO',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 10,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              userName,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              courseTitle,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              completedOn,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),

                        const Spacer(),

                        // bottom signature + QR
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                SizedBox(height: 4),
                                Text(
                                  'Sona sharma',
                                  style: TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                                SizedBox(height: 2),
                                SizedBox(
                                  width: 120,
                                  child: Divider(
                                    thickness: 0.8,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Sona Sharma',
                                  style: TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                            const Icon(
                              Icons.qr_code_2_rounded,
                              size: 48,
                              color: AppColors.textPrimary,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;
  const _NavTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.textSecondary)),
        trailing: const Icon(Icons.chevron_right_rounded),
        leading: CircleAvatar(
          backgroundColor: AppColors.background,
          child: Icon(icon, color: AppColors.primary),
        ),
      ),
    );
  }
}

class _NavTileLock extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isLocked;
  final VoidCallback onTap;
  const _NavTileLock({
    required this.title,
    required this.subtitle,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
        subtitle: Text(subtitle,
            style: const TextStyle(color: AppColors.textSecondary)),
        trailing: isLocked
            ? const Icon(Icons.lock_outline_rounded,
                color: AppColors.textSecondary)
            : const Icon(Icons.chevron_right_rounded),
        leading: const CircleAvatar(
          backgroundColor: AppColors.background,
          child: Icon(Icons.assignment_turned_in_rounded,
              color: AppColors.primary),
        ),
      ),
    );
  }
}

class _InfoPlaceholder extends StatelessWidget {
  final String title;
  final String message;
  const _InfoPlaceholder({required this.title, required this.message});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.background,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: AppColors.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.background,
              child: Icon(Icons.info_outline_rounded, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                '$title\n$message',
                style: const TextStyle(
                    color: AppColors.textSecondary, height: 1.3),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KVChip extends StatelessWidget {
  final String k;
  final String v;
  const _KVChip({required this.k, required this.v});
  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 0,
      side: const BorderSide(color: AppColors.border),
      backgroundColor: AppColors.background,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      label:
          Text('$k: $v', style: const TextStyle(color: AppColors.textPrimary)),
    );
  }
}

class _BulletOrNumber extends StatelessWidget {
  final _Line line;
  const _BulletOrNumber(this.line);

  @override
  Widget build(BuildContext context) {
    if (line.kind == _LineKind.paragraph) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Text(line.text,
            style: const TextStyle(color: AppColors.textPrimary)),
      );
    }
    // Bullet or numbered
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (line.kind == _LineKind.ordered)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text('${line.index}.',
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  )),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 8, top: 4),
              child: Icon(Icons.circle, size: 6, color: AppColors.textPrimary),
            ),
          Expanded(
              child: Text(line.text,
                  style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                      height: 1.6))),
        ],
      ),
    );
  }
}

enum _LineKind { ordered, bullet, paragraph }

class _Line {
  final _LineKind kind;
  final String text;
  final int index; // for ordered items
  const _Line._(this.kind, this.text, this.index);
  factory _Line.ordered(int i, String t) => _Line._(_LineKind.ordered, t, i);
  factory _Line.bullet(String t) => _Line._(_LineKind.bullet, t, 0);
  factory _Line.paragraph(String t) => _Line._(_LineKind.paragraph, t, 0);
}

class _HtmlText {
  static String inline(String html) {
    if (html.isEmpty) return '';
    var s = html;

    s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ');
    s = s.replaceAll(RegExp(r'</p>', caseSensitive: false), ' ');
    s = s.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), ' ');

    // remove all tags
    s = s.replaceAll(RegExp(r'<[^>]+>'), '');

    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    return s.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  static List<String> blocks(String html) {
    if (html.trim().isEmpty) return const [];
    var s = html;

    s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '');

    s = s.replaceAll(
        RegExp(r'</?(ol|ul|li)[^>]*>', caseSensitive: false), '\n');

    s = s.replaceAll(RegExp(r'<[^>]+>'), '');

    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    final parts =
        s.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return parts;
  }

  static List<_Line> toLines(String html) {
    if (html.trim().isEmpty) return const [];

    final olRegex =
        RegExp(r'<ol[^>]*>(.*?)</ol>', caseSensitive: false, dotAll: true);
    final ulRegex =
        RegExp(r'<ul[^>]*>(.*?)</ul>', caseSensitive: false, dotAll: true);
    final liRegex =
        RegExp(r'<li[^>]*>(.*?)</li>', caseSensitive: false, dotAll: true);

    final lines = <_Line>[];

    // Ordered lists
    for (final m in olRegex.allMatches(html)) {
      final body = m.group(1) ?? '';
      final items = liRegex
          .allMatches(body)
          .map((l) => inline(l.group(1) ?? ''))
          .where((t) => t.isNotEmpty)
          .toList();
      for (int i = 0; i < items.length; i++) {
        lines.add(_Line.ordered(i + 1, items[i]));
      }
    }

    // Bulleted lists
    for (final m in ulRegex.allMatches(html)) {
      final body = m.group(1) ?? '';
      final items = liRegex
          .allMatches(body)
          .map((l) => inline(l.group(1) ?? ''))
          .where((t) => t.isNotEmpty)
          .toList();
      for (final t in items) {
        lines.add(_Line.bullet(t));
      }
    }

    if (lines.isEmpty) {
      for (final p in blocks(html)) {
        lines.add(_Line.paragraph(p));
      }
    }

    return lines;
  }
}

class LessonData {
  final CourseVideoModel source;
  final String title;
  final String url;
  final String duration;

  final bool hasPdf;
  final String? pdfTitle;
  final String? pdfUrl;

  final bool hasNotes;
  final String? notes;
  final int? videoId;
  LessonData(
      {required this.source,
      required this.title,
      required this.url,
      required this.duration,
      this.hasPdf = false,
      this.pdfTitle,
      this.pdfUrl,
      this.hasNotes = false,
      this.notes,
      this.videoId});
}

class CourseModule {
  final String title;
  final List<LessonData> lessons;

  CourseModule({
    required this.title,
    required this.lessons,
  });
}

class LearningVideosPage extends StatefulWidget {
  final String title;
  final List<CourseModule> modules;
  final List<QuizModel> quizzes;

  const LearningVideosPage({
    super.key,
    required this.title,
    required this.modules,
    required this.quizzes,
  });

  @override
  State<LearningVideosPage> createState() => _LearningVideosPageState();
}

class _LearningVideosPageState extends State<LearningVideosPage> {
  VideoPlayerController? _vc;
  ChewieController? _cc;

  int _currentModuleIndex = 0;
  int _currentLessonIndex = 0;

  late List<List<bool>> _videoUnlocked; // kaun sa video unlock hai
  late List<List<bool>> _videoCompleted; // kaun sa video done hai
  late List<List<bool>> _quizUnlocked; // kaun sa quiz button unlock hai

  @override
  void initState() {
    super.initState();

    final mCount = widget.modules.length;
    _videoUnlocked = [];
    _videoCompleted = [];
    _quizUnlocked = [];

    for (int mi = 0; mi < mCount; mi++) {
      final lCount = widget.modules[mi].lessons.length;
      _videoUnlocked.add(List<bool>.filled(lCount, false));
      _videoCompleted.add(List<bool>.filled(lCount, false));
      _quizUnlocked.add(List<bool>.filled(lCount, false));
    }

    // 🔓 by default: Module 0, Lesson 0 unlocked + auto-load
    if (mCount > 0 && widget.modules[0].lessons.isNotEmpty) {
      _videoUnlocked[0][0] = true;
      debugPrint('🚀 Unlocking first lesson [0][0]');
      _load(0, 0);
    }
  }

  @override
  void dispose() {
    _disposeControllers();
    super.dispose();
  }

  Future<void> _disposeControllers() async {
    try {
      await _cc?.pause();
    } catch (_) {}
    _cc?.dispose();
    await _vc?.dispose();
  }

  Future<void> _load(int moduleIndex, int lessonIndex) async {
    final lesson = widget.modules[moduleIndex].lessons[lessonIndex];

    debugPrint(
        '▶️ Playing video: module=$moduleIndex, lesson=$lessonIndex, title="${lesson.title}"');

    await _disposeControllers();

    _vc = VideoPlayerController.networkUrl(Uri.parse(lesson.url));
    await _vc!.initialize();

    _cc = ChewieController(
      videoPlayerController: _vc!,
      autoPlay: false,
      showControls: true,
    );

    setState(() {
      _currentModuleIndex = moduleIndex;
      _currentLessonIndex = lessonIndex;
    });
  }

  Future<void> _downloadFile(String url, String name) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');

      final client = http.Client();
      final req = await client.send(http.Request('GET', Uri.parse(url)));
      final total = req.contentLength ?? 0;
      var downloaded = 0;

      final sink = file.openWrite();

      await for (final chunk in req.stream) {
        downloaded += chunk.length;
        sink.add(chunk);

        if (!mounted) continue;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Downloading ${((downloaded / total) * 100).toStringAsFixed(0)}%',
            ),
            duration: const Duration(milliseconds: 300),
          ),
        );
      }

      await sink.close();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download complete! Opening...')),
      );

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        await launchUrl(Uri.file(file.path));
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
  }

  List<QuizModel> _quizzesForLesson(LessonData lesson) {
    // Yahi pe direct source se quizzes le lo
    final list = lesson.source.quizzes;

    debugPrint(
      '🔍 Quizzes for lesson videoId=${lesson.videoId} ("${lesson.title}") => ${list.length} found (from source)',
    );

    return list;
  }

  /// Quiz ke baad next video unlock karna
  void _unlockNextVideo(int moduleIndex, int lessonIndex) {
    int mi = moduleIndex;
    int li = lessonIndex + 1;

    if (li >= widget.modules[mi].lessons.length) {
      mi += 1;
      li = 0;
    }
    if (mi >= widget.modules.length) {
      debugPrint('✅ No more videos to unlock. Course complete (UI side).');
      return;
    }

    setState(() {
      _videoUnlocked[mi][li] = true;
    });

    debugPrint(
        '🔓 Next video unlocked: module=$mi, lesson=$li, title="${widget.modules[mi].lessons[li].title}"');
  }

  @override
  Widget build(BuildContext context) {
    final modules = widget.modules;

    debugPrint(
        '📺 Building LearningVideosPage: modules=${modules.length}, totalQuizzes=${widget.quizzes.length}');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          // === TOP VIDEO PLAYER ===
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Card(
              margin: const EdgeInsets.all(12),
              color: Colors.black,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: _cc != null && _vc != null && _vc!.value.isInitialized
                  ? Chewie(controller: _cc!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),

          // === MODULE + CHAPTER LIST (COLLAPSIBLE) ===
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: ListView.builder(
                itemCount: modules.length,
                itemBuilder: (context, moduleIndex) {
                  final module = modules[moduleIndex];

                  return Card(
                    elevation: 0,
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: const BorderSide(color: AppColors.border),
                    ),
                    child: Theme(
                      data: Theme.of(context).copyWith(
                        dividerColor: Colors.transparent,
                      ),
                      child: ExpansionTile(
                        tilePadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        title: Text(
                          module.title,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        leading: CircleAvatar(
                          backgroundColor: AppColors.background,
                          child: Text(
                            '${moduleIndex + 1}',
                            style: const TextStyle(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        children: List.generate(
                          module.lessons.length,
                          (lessonIndex) {
                            final lesson = module.lessons[lessonIndex];

                            final bool isActive =
                                moduleIndex == _currentModuleIndex &&
                                    lessonIndex == _currentLessonIndex;
                            final bool isUnlocked =
                                _videoUnlocked[moduleIndex][lessonIndex];
                            final bool isDone =
                                _videoCompleted[moduleIndex][lessonIndex];
                            final bool quizUnlocked =
                                _quizUnlocked[moduleIndex][lessonIndex];

                            final lessonQuizzes = _quizzesForLesson(lesson);
                            final hasQuizForThisLesson =
                                lessonQuizzes.isNotEmpty;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // ==== VIDEO ROW ====
                                ListTile(
                                  onTap: isUnlocked
                                      ? () => _load(moduleIndex, lessonIndex)
                                      : null, // lock if not unlocked
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: isActive
                                        ? AppColors.primary.withOpacity(.1)
                                        : AppColors.background,
                                    child: isUnlocked
                                        ? (isActive
                                            ? const Icon(
                                                Icons.play_arrow_rounded,
                                                color: AppColors.primary,
                                              )
                                            : Text(
                                                '${lessonIndex + 1}',
                                                style: const TextStyle(
                                                  color: AppColors.textPrimary,
                                                ),
                                              ))
                                        : const Icon(
                                            Icons.lock_outline_rounded,
                                            color: AppColors.textSecondary,
                                          ),
                                  ),
                                  title: Text(
                                    lesson.title,
                                    style: TextStyle(
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
                                      color: isUnlocked
                                          ? AppColors.textPrimary
                                          : AppColors.textSecondary,
                                    ),
                                  ),
                                  subtitle: Text(
                                    lesson.duration,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (isUnlocked)
                                        Icon(
                                          isDone
                                              ? Icons.check_circle_rounded
                                              : Icons.radio_button_unchecked,
                                          color: isDone
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                          size: 20,
                                        ),
                                    ],
                                  ),
                                ),

                                // ==== PDF BUTTON (if available) ====
                                if (lesson.hasPdf &&
                                    lesson.pdfUrl != null &&
                                    lesson.pdfTitle != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: OutlinedButton.icon(
                                      onPressed: () {
                                        debugPrint(
                                            '📄 Opening PDF for lesson="${lesson.title}" url=${lesson.pdfUrl}');
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => PdfWebViewPage(
                                              title: lesson.pdfTitle!,
                                              url: lesson.pdfUrl!,
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                        Icons.picture_as_pdf_rounded,
                                        size: 18,
                                      ),
                                      label: Text(
                                        lesson.pdfTitle!,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: AppColors.primary,
                                        side: const BorderSide(
                                            color: AppColors.primary),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),

                                // ==== QUIZ BUTTON (per chapter, but same quiz set) ====

                                // ==== QUIZ BUTTON (sirf us lesson ke liye jisme quiz hai) ====
                                if (hasQuizForThisLesson)
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                    child: ElevatedButton.icon(
                                      onPressed: quizUnlocked
                                          ? () async {
                                              debugPrint(
                                                  '❓ Opening quiz for module=$moduleIndex, lesson=$lessonIndex, quizzes=${lessonQuizzes.length}');

                                              await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => QuizPage(
                                                    title: lesson.title,
                                                    quizzes:
                                                        lessonQuizzes, // 👈 sirf iss lesson ka quiz list
                                                    onCompleted: () {
                                                      debugPrint(
                                                          '🏁 Quiz completed for module=$moduleIndex, lesson=$lessonIndex');
                                                      _unlockNextVideo(
                                                          moduleIndex,
                                                          lessonIndex);
                                                    },
                                                  ),
                                                ),
                                              );
                                            }
                                          : null,
                                      icon: Icon(
                                        quizUnlocked
                                            ? Icons.quiz_rounded
                                            : Icons.lock_outline_rounded,
                                        size: 18,
                                      ),
                                      label: Text(
                                        quizUnlocked
                                            ? 'Start Quiz'
                                            : 'Complete lesson to unlock quiz',
                                      ),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: quizUnlocked
                                            ? AppColors.primary
                                            : AppColors.background,
                                        foregroundColor: quizUnlocked
                                            ? Colors.white
                                            : AppColors.textSecondary,
                                        elevation: 0,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12, vertical: 8),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    ),
                                  ),

                                // if (hasAnyQuiz)
                                //   Padding(
                                //     padding:
                                //         const EdgeInsets.fromLTRB(16, 4, 16, 4),
                                //     child: ElevatedButton.icon(
                                //       onPressed: quizUnlocked
                                //           ? () async {
                                //               debugPrint(
                                //                   '❓ Opening quiz for module=$moduleIndex, lesson=$lessonIndex');
                                //
                                //               await Navigator.push(
                                //                 context,
                                //                 MaterialPageRoute(
                                //                   builder: (_) => QuizPage(
                                //                     title: lesson.title,
                                //                     quizzes: quizzes,
                                //                     onCompleted: () {
                                //                       debugPrint(
                                //                           '🏁 Quiz completed for module=$moduleIndex, lesson=$lessonIndex');
                                //                       _unlockNextVideo(
                                //                           moduleIndex,
                                //                           lessonIndex);
                                //                     },
                                //                   ),
                                //                 ),
                                //               );
                                //             }
                                //           : null,
                                //       icon: Icon(
                                //         quizUnlocked
                                //             ? Icons.quiz_rounded
                                //             : Icons.lock_outline_rounded,
                                //         size: 18,
                                //       ),
                                //       label: Text(
                                //         quizUnlocked
                                //             ? 'Start Quiz'
                                //             : 'Complete lesson to unlock quiz',
                                //       ),
                                //       style: ElevatedButton.styleFrom(
                                //         backgroundColor: quizUnlocked
                                //             ? AppColors.primary
                                //             : AppColors.background,
                                //         foregroundColor: quizUnlocked
                                //             ? Colors.white
                                //             : AppColors.textSecondary,
                                //         elevation: 0,
                                //         padding: const EdgeInsets.symmetric(
                                //             horizontal: 12, vertical: 8),
                                //         shape: RoundedRectangleBorder(
                                //           borderRadius:
                                //               BorderRadius.circular(10),
                                //         ),
                                //       ),
                                //     ),
                                //   ),

                                // ==== MARK AS DONE BUTTON ====
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.fromLTRB(16, 4, 16, 8),
                                //   child: Align(
                                //     alignment: Alignment.centerRight,
                                //     child: TextButton.icon(
                                //       onPressed: isUnlocked && !isDone
                                //           ? () {
                                //               setState(() {
                                //                 _videoCompleted[moduleIndex]
                                //                     [lessonIndex] = true;
                                //                 if (hasAnyQuiz) {
                                //                   _quizUnlocked[moduleIndex]
                                //                       [lessonIndex] = true;
                                //                 }
                                //               });
                                //               debugPrint(
                                //                   '✅ Marked done: module=$moduleIndex, lesson=$lessonIndex. Quiz unlocked=$hasAnyQuiz');
                                //             }
                                //           : null,
                                //       icon: Icon(
                                //         isDone
                                //             ? Icons.check_circle_rounded
                                //             : Icons.check_circle_outline,
                                //         color: isDone
                                //             ? AppColors.primary
                                //             : AppColors.textSecondary,
                                //       ),
                                //       label: Text(
                                //         isDone ? 'Completed' : 'Mark as done',
                                //         style: TextStyle(
                                //           color: isDone
                                //               ? AppColors.primary
                                //               : AppColors.textSecondary,
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
// ==== MARK AS DONE BUTTON ====
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(16, 4, 16, 8),
                                  child: Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton.icon(
                                      onPressed: isUnlocked && !isDone
                                          ? () {
                                              setState(() {
                                                _videoCompleted[moduleIndex]
                                                    [lessonIndex] = true;

                                                if (hasQuizForThisLesson) {
                                                  // 🔓 iss lesson ke liye quiz unlock karo
                                                  _quizUnlocked[moduleIndex]
                                                      [lessonIndex] = true;
                                                  debugPrint(
                                                      '✅ Marked done (quiz available) → quiz unlocked for module=$moduleIndex, lesson=$lessonIndex');
                                                } else {
                                                  // ❌ quiz nahi hai → direct next video unlock karo
                                                  debugPrint(
                                                      '✅ Marked done (no quiz) → directly unlocking next video from module=$moduleIndex, lesson=$lessonIndex');
                                                  _unlockNextVideo(
                                                      moduleIndex, lessonIndex);
                                                }
                                              });
                                            }
                                          : null,
                                      icon: Icon(
                                        isDone
                                            ? Icons.check_circle_rounded
                                            : Icons.check_circle_outline,
                                        color: isDone
                                            ? AppColors.primary
                                            : AppColors.textSecondary,
                                      ),
                                      label: Text(
                                        isDone ? 'Completed' : 'Mark as done',
                                        style: TextStyle(
                                          color: isDone
                                              ? AppColors.primary
                                              : AppColors.textSecondary,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                if (lessonIndex != module.lessons.length - 1)
                                  const Divider(
                                    height: 1,
                                    color: AppColors.border,
                                  ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PdfItem {
  final String title;
  final String url;

  const PdfItem({
    required this.title,
    required this.url,
  });
}

class NotesModule {
  final String title;
  final List<PdfItem> notes;

  const NotesModule({
    required this.title,
    required this.notes,
  });
}

class LearningMaterialsPage extends StatelessWidget {
  final String title;
  final List<NotesModule> modules;

  const LearningMaterialsPage({
    super.key,
    required this.title,
    required this.modules,
  });

  Future<void> _downloadFile(
    BuildContext context,
    String url,
    String name,
  ) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');

      final res = await http.get(Uri.parse(url));
      await file.writeAsBytes(res.bodyBytes);

      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('PDF downloaded!')),
      );

      final result = await OpenFilex.open(file.path);
      if (result.type != ResultType.done) {
        await launchUrl(Uri.file(file.path));
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('$title • Notes'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: modules.length,
        itemBuilder: (_, moduleIndex) {
          final module = modules[moduleIndex];

          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            margin: const EdgeInsets.only(bottom: 12),
            child: Theme(
              data: Theme.of(context).copyWith(
                dividerColor: Colors.transparent,
              ),
              child: ExpansionTile(
                tilePadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Text(
                  module.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: AppColors.textPrimary,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: AppColors.background,
                  child: Text(
                    // Module numbering: 1, 2, 3...
                    '${moduleIndex + 1}',
                    style: const TextStyle(color: AppColors.textPrimary),
                  ),
                ),
                children: List.generate(module.notes.length, (chapterIndex) {
                  final note = module.notes[chapterIndex];

                  // A, B, C, D…
                  final chapterLetter =
                      String.fromCharCode(65 + chapterIndex); // 65 = 'A'

                  return Column(
                    children: [
                      ListTile(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => PdfWebViewPage(
                                title: note.title, url: note.url),
                          ),
                        ),
                        leading: const CircleAvatar(
                          backgroundColor: AppColors.background,
                          child: Icon(
                            Icons.picture_as_pdf,
                            color: AppColors.primary,
                          ),
                        ),
                        title: Text(
                          // Example:
                          // "A. Chapter 1: Chapter1Notes.pdf"
                          '$chapterLetter. ${note.title}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                        ),
                        subtitle: const Text(
                          'Tap to view or download',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        // trailing: IconButton(
                        //   icon: const Icon(
                        //     Icons.download_rounded,
                        //     color: AppColors.primary,
                        //   ),
                        //   onPressed: () => _downloadFile(
                        //     context,
                        //     note.url,
                        //     '${note.title}.pdf',
                        //   ),
                        // ),
                      ),
                      if (chapterIndex != module.notes.length - 1)
                        const Divider(
                          height: 1,
                          color: AppColors.border,
                        ),
                    ],
                  );
                }),
              ),
            ),
          );
        },
      ),
    );
  }
}

class PdfWebViewPage extends StatefulWidget {
  final String title;
  final String url;

  const PdfWebViewPage({
    super.key,
    required this.title,
    required this.url,
  });

  @override
  State<PdfWebViewPage> createState() => _PdfWebViewPageState();
}

class _PdfWebViewPageState extends State<PdfWebViewPage> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    final viewUrl = Uri.encodeFull(
      'https://docs.google.com/gview?embedded=1&url=${widget.url}',
    );

    print("Geting  PDF URL: ${widget.url}");
    print("Viewing PDF URL: $viewUrl");
    final params = const PlatformWebViewControllerCreationParams();
    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) {
            if (mounted) {
              setState(() => _loading = false);
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(viewUrl));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            const LinearProgressIndicator(
              minHeight: 2,
              color: AppColors.primary,
            ),
        ],
      ),
    );
  }
}

class QuizPage extends StatefulWidget {
  final String title;
  final List<QuizModel> quizzes;
  final VoidCallback? onCompleted; // NEW

  const QuizPage({
    super.key,
    required this.title,
    required this.quizzes,
    this.onCompleted,
  });

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;

  QuizModel get _currentQuiz => widget.quizzes[_currentIndex];

  // options list
  List<String> _optionsFor(QuizModel q) => [
        q.option1,
        q.option2,
        q.option3,
        q.option4,
      ];

  int _correctIndexFor(QuizModel q) {
    if (q.option1_correct) return 0;
    if (q.option2_correct) return 1;
    if (q.option3_correct) return 2;
    if (q.option4_correct) return 3;
    return -1;
  }

  void _onNext() {
    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an answer before continuing.'),
        ),
      );
      return;
    }

    final correctIndex = _correctIndexFor(_currentQuiz);
    if (_selectedIndex == correctIndex) {
      _score++;
    }

    if (_currentIndex < widget.quizzes.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final total = widget.quizzes.length;
    final percent = (_score / total * 100).toStringAsFixed(1);

    String message;
    if (_score == total) {
      message = 'Full power! 🔥 Perfect score!';
    } else if (_score >= (0.7 * total)) {
      message = 'Solid work! You\'re getting strong in the basics. 💪';
    } else if (_score >= (0.5 * total)) {
      message = 'Not bad! Thoda aur practice and you\'ll be pro. 🚀';
    } else {
      message = 'Chill, sab hota hai. Revise once more & attempt again. 💡';
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Quiz Completed!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Score: $_score / $total',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Percentage: $percent%',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _resetQuiz();
              widget.onCompleted?.call(); // 🔔 notify parent
            },
            child: const Text('Retry Quiz'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);

              Future.delayed(const Duration(milliseconds: 100), () {
                Get.back();
                widget.onCompleted?.call();
              });
            },
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _resetQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.quizzes.length;
    final current = _currentIndex + 1;
    final progress = current / total;

    final q = _currentQuiz;
    final questionText = _HtmlText.inline(q.question_text);
    final options = _optionsFor(q);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('${widget.title} • Quiz'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Top: Question counter + progress bar
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question $current of $total',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${(progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.border,
                valueColor:
                    const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),

            // Question card
            Card(
              elevation: 0,
              color: AppColors.background,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  questionText,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Options
            Expanded(
              child: ListView.separated(
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final optionText = options[index];

                  return Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: _selectedIndex == index
                            ? AppColors.primary
                            : AppColors.border,
                      ),
                    ),
                    child: RadioListTile<int>(
                      value: index,
                      groupValue: _selectedIndex,
                      activeColor: AppColors.primary,
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      title: Text(
                        optionText,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: _selectedIndex == index
                              ? FontWeight.w600
                              : FontWeight.w400,
                        ),
                      ),
                      onChanged: (val) {
                        setState(() {
                          _selectedIndex = val;
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _onNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
                child: Text(
                  _currentIndex == total - 1 ? 'Submit Quiz' : 'Next',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class CertificatePage extends StatelessWidget {
//   final String courseTitle;
//   final String userName;
//   final DateTime completedOn;
//   final String priceText;
//
//   const CertificatePage({
//     super.key,
//     required this.courseTitle,
//     required this.userName,
//     required this.completedOn,
//     this.priceText = '',
//   });
//
//   // ---------------------- UI ----------------------
//   @override
//   Widget build(BuildContext context) {
//     final dateStr = DateFormat.yMMMMd().format(completedOn);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         foregroundColor: Colors.white,
//         title:
//             Text('$courseTitle • Certificate', overflow: TextOverflow.ellipsis),
//       ),
//       backgroundColor: AppColors.background,
//       body: ListView(
//         padding: const EdgeInsets.all(16),
//         children: [
//           Card(
//             color: AppColors.background,
//             elevation: 0,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(16),
//               side: const BorderSide(color: AppColors.border),
//             ),
//             child: Padding(
//               padding: const EdgeInsets.all(14),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // header
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       const Text('Auratech Academy',
//                           style: TextStyle(
//                             fontWeight: FontWeight.w800,
//                             fontSize: 18,
//                             color: AppColors.textPrimary,
//                           )),
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 10, vertical: 6),
//                         decoration: BoxDecoration(
//                           color: AppColors.primary.withOpacity(.08),
//                           borderRadius: BorderRadius.circular(24),
//                         ),
//                         child: const Text('Verified Certificate',
//                             style: TextStyle(
//                               color: AppColors.primary,
//                               fontWeight: FontWeight.w600,
//                             )),
//                       )
//                     ],
//                   ),
//                   if (priceText.isNotEmpty) ...[
//                     const SizedBox(height: 6),
//                     Text(priceText,
//                         style: const TextStyle(color: AppColors.textSecondary)),
//                   ],
//
//                   const SizedBox(height: 12),
//
//                   // live preview (vector UI, not a network image)
//                   AspectRatio(
//                     aspectRatio: 6 / 7,
//                     child: _CertificatePreview(
//                       userName: userName,
//                       courseTitle: courseTitle,
//                       completedOn: dateStr,
//                     ),
//                   ),
//
//                   const SizedBox(height: 14),
//
//                   Row(
//                     children: [
//                       Expanded(
//                         child: ElevatedButton.icon(
//                           icon: const Icon(Icons.picture_as_pdf_rounded),
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primary,
//                             foregroundColor: Colors.white,
//                             elevation: 0,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           onPressed: () => _downloadPdf(context),
//                           label: const Text(
//                             'Download PDF',
//                             style: TextStyle(fontSize: 12.5),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: OutlinedButton.icon(
//                           icon: const Icon(Icons.share_rounded),
//                           style: OutlinedButton.styleFrom(
//                             side: const BorderSide(color: AppColors.primary),
//                             foregroundColor: AppColors.primary,
//                             shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12)),
//                           ),
//                           onPressed: () => _sharePdf(context),
//                           label: const Text('Share'),
//                         ),
//                       ),
//                     ],
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   // ---------------------- PDF GEN ----------------------
//   Future<pw.Document> _buildPdf() async {
//     final pdf = pw.Document();
//
//     final dateStr = DateFormat.yMMMMd().format(completedOn);
//
//     final primary = const PdfColor.fromInt(0xFF2962FF); // tweak to your theme
//     final textPrimary = const PdfColor.fromInt(0xFF111827);
//     final textSecondary = const PdfColor.fromInt(0xFF6B7280);
//     final border = const PdfColor.fromInt(0xFFE5E7EB);
//
//     pdf.addPage(
//       pw.Page(
//         pageFormat: PdfPageFormat.a4.landscape,
//         margin: const pw.EdgeInsets.all(24),
//         build: (context) => pw.Container(
//           decoration: pw.BoxDecoration(
//             border: pw.Border.all(color: border, width: 2),
//           ),
//           child: pw.Stack(
//             children: [
//               // subtle watermark
//               pw.Positioned.fill(
//                 child: pw.Center(
//                   child: pw.Transform.rotate(
//                     angle: -0.35,
//                     child: pw.Text(
//                       'AURATECH ACADEMY',
//                       style: pw.TextStyle(
//                         color: primary,
//                         fontSize: 60,
//                         fontWeight: pw.FontWeight.bold,
//                         letterSpacing: 2,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//
//               pw.Padding(
//                 padding: const pw.EdgeInsets.all(28),
//                 child: pw.Column(
//                   crossAxisAlignment: pw.CrossAxisAlignment.start,
//                   children: [
//                     // header row
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       crossAxisAlignment: pw.CrossAxisAlignment.center,
//                       children: [
//                         pw.Text('Auratech Academy',
//                             style: pw.TextStyle(
//                               color: textPrimary,
//                               fontWeight: pw.FontWeight.bold,
//                               fontSize: 20,
//                             )),
//                         pw.Container(
//                           padding: const pw.EdgeInsets.symmetric(
//                               horizontal: 12, vertical: 6),
//                           decoration: pw.BoxDecoration(
//                             color: primary,
//                             borderRadius: pw.BorderRadius.circular(16),
//                           ),
//                           child: pw.Text('Verified Certificate',
//                               style: pw.TextStyle(
//                                 color: primary,
//                                 fontWeight: pw.FontWeight.bold,
//                               )),
//                         ),
//                       ],
//                     ),
//                     pw.SizedBox(height: 24),
//
//                     // title block
//                     pw.Text('CERTIFICATE',
//                         style: pw.TextStyle(
//                           fontSize: 38,
//                           letterSpacing: 2,
//                           color: textPrimary,
//                           fontWeight: pw.FontWeight.bold,
//                         )),
//                     pw.SizedBox(height: 4),
//                     pw.Text('OF COMPLETION',
//                         style: pw.TextStyle(
//                           fontSize: 16,
//                           letterSpacing: 3,
//                           color: textSecondary,
//                         )),
//                     pw.SizedBox(height: 28),
//
//                     pw.Text('Presented to',
//                         style: pw.TextStyle(
//                           color: textSecondary,
//                           fontSize: 12,
//                         )),
//                     pw.SizedBox(height: 4),
//                     pw.Text(userName,
//                         style: pw.TextStyle(
//                           color: textPrimary,
//                           fontSize: 28,
//                           fontWeight: pw.FontWeight.bold,
//                         )),
//                     pw.SizedBox(height: 14),
//
//                     pw.Text(
//                       'For successfully completing the online course',
//                       style: pw.TextStyle(color: textSecondary, fontSize: 12),
//                     ),
//                     pw.SizedBox(height: 6),
//
//                     pw.Text(
//                       courseTitle,
//                       style: pw.TextStyle(
//                         color: textPrimary,
//                         fontSize: 18,
//                         fontWeight: pw.FontWeight.bold,
//                       ),
//                     ),
//                     pw.SizedBox(height: 8),
//                     pw.Text('Course completed on $dateStr',
//                         style:
//                             pw.TextStyle(color: textSecondary, fontSize: 12)),
//                     pw.Spacer(),
//
//                     // footer row
//                     pw.Row(
//                       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
//                       children: [
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.start,
//                           children: [
//                             pw.Container(height: 1, width: 200, color: border),
//                             pw.SizedBox(height: 4),
//                             pw.Text('Harish Subramanian',
//                                 style: pw.TextStyle(
//                                     color: textPrimary,
//                                     fontWeight: pw.FontWeight.bold)),
//                             pw.Text('Academic Director, Auratech Academy',
//                                 style: pw.TextStyle(
//                                     color: textSecondary, fontSize: 10)),
//                           ],
//                         ),
//                         pw.Column(
//                           crossAxisAlignment: pw.CrossAxisAlignment.end,
//                           children: [
//                             pw.Text('Verify Authenticity',
//                                 style: pw.TextStyle(
//                                   color: textSecondary,
//                                   fontSize: 10,
//                                 )),
//                             pw.SizedBox(height: 4),
//                             pw.BarcodeWidget(
//                               data:
//                                   'AURATECH|$userName|$courseTitle|$dateStr', // simple verifiable payload
//                               barcode: pw.Barcode.qrCode(),
//                               width: 64,
//                               height: 64,
//                             ),
//                           ],
//                         ),
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//
//     return pdf;
//   }
//
//   Future<void> _downloadPdf(BuildContext context) async {
//     final doc = await _buildPdf();
//     await Printing.layoutPdf(onLayout: (_) => doc.save());
//   }
//
//   Future<void> _sharePdf(BuildContext context) async {
//     final doc = await _buildPdf();
//     await Printing.sharePdf(
//       bytes: await doc.save(),
//       filename: 'Auratech_Certificate_$userName.pdf',
//     );
//   }
// }
//
// class _CertificatePreview extends StatelessWidget {
//   final String userName;
//   final String courseTitle;
//   final String completedOn;
//
//   const _CertificatePreview({
//     required this.userName,
//     required this.courseTitle,
//     required this.completedOn,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: Colors.white,
//         border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Stack(
//         fit: StackFit.expand,
//         children: [
//           // watermark
//           Center(
//             child: Transform.rotate(
//               angle: -0.35,
//               child: Text(
//                 'AURATECH ACADEMY',
//                 style: TextStyle(
//                   color: AppColors.primary.withOpacity(0.05),
//                   fontSize: 40,
//                   fontWeight: FontWeight.w800,
//                   letterSpacing: 2,
//                 ),
//               ),
//             ),
//           ),
//           Padding(
//             padding: const EdgeInsets.all(18),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // header row
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Auratech Academy',
//                         style: TextStyle(
//                           fontWeight: FontWeight.w600,
//                           fontSize: 14,
//                           color: AppColors.textPrimary,
//                         )),
//                     Container(
//                       padding: const EdgeInsets.symmetric(
//                           horizontal: 10, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: AppColors.primary.withOpacity(.08),
//                         borderRadius: BorderRadius.circular(16),
//                       ),
//                       child: const Text(
//                         'Verified Certificate',
//                         style: TextStyle(
//                           color: AppColors.primary,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     )
//                   ],
//                 ),
//                 const SizedBox(height: 14),
//                 const Text(
//                   'CERTIFICATE',
//                   style: TextStyle(
//                     fontSize: 28,
//                     letterSpacing: 2,
//                     fontWeight: FontWeight.w800,
//                     color: AppColors.textPrimary,
//                   ),
//                 ),
//                 const SizedBox(height: 2),
//                 const Text(
//                   'OF COMPLETION',
//                   style: TextStyle(
//                     fontSize: 12,
//                     letterSpacing: 3,
//                     color: AppColors.textSecondary,
//                   ),
//                 ),
//                 const SizedBox(height: 18),
//
//                 const Text('Presented to',
//                     style: TextStyle(
//                         color: AppColors.textSecondary, fontSize: 12)),
//                 const SizedBox(height: 4),
//                 Text(
//                   userName,
//                   style: const TextStyle(
//                     color: AppColors.textPrimary,
//                     fontSize: 22,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 const Text(
//                   'For successfully completing the online course',
//                   style:
//                       TextStyle(color: AppColors.textSecondary, fontSize: 12),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(courseTitle,
//                     style: const TextStyle(
//                         color: AppColors.textPrimary,
//                         fontWeight: FontWeight.w700,
//                         fontSize: 14)),
//                 const SizedBox(height: 4),
//                 Text('Course completed on $completedOn',
//                     style: const TextStyle(
//                         color: AppColors.textSecondary, fontSize: 12)),
//                 const Spacer(),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: const [
//                         SizedBox(
//                           height: 1,
//                           width: 160,
//                           child: DecoratedBox(
//                             decoration: BoxDecoration(color: Color(0xFFE5E7EB)),
//                           ),
//                         ),
//                         SizedBox(height: 4),
//                         Text('Sona Sharma',
//                             style: TextStyle(
//                                 color: AppColors.textPrimary,
//                                 fontWeight: FontWeight.w700,
//                                 fontSize: 12)),
//                         Text('Academic Director, Auratech Academy',
//                             style: TextStyle(
//                                 color: AppColors.textSecondary, fontSize: 10)),
//                       ],
//                     ),
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.end,
//                       children: const [
//                         Text('Verify Authenticity',
//                             style: TextStyle(
//                                 color: AppColors.textSecondary, fontSize: 10)),
//                         SizedBox(height: 6),
//                         Icon(Icons.qr_code_2_rounded,
//                             size: 40, color: AppColors.textSecondary),
//                       ],
//                     ),
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
