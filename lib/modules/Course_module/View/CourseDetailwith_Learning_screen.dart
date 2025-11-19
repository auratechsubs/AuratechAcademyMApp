import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:printing/printing.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../../../constant/constant_colors.dart';
import '../Model/Course_Master_Model.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class CourseDetailPage extends StatefulWidget {
  final CourseMaster course;
  const CourseDetailPage({super.key, required this.course});

  @override
  State<CourseDetailPage> createState() => _CourseDetailPageState();
}

class _CourseDetailPageState extends State<CourseDetailPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  late final List<_LessonItem> _lessons;
  final int _currentIndex = 0;
  late List<CourseModule> _modules;

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  final notesModules = [
    NotesModule(
      title: 'Module 1: Introduction of Machine Learning',
      notes: const [
        PdfItem(
          title: 'Chapter 1: Chapter1Notes.pdf',
          url:
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        ),
        PdfItem(
          title: 'Chapter 2: Chapter2Notes.pdf',
          url:
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        ),
        PdfItem(
          title: 'Chapter 3: Chapter3Notes.pdf',
          url:
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        ),
        PdfItem(
          title: 'Chapter 4: Chapter4Notes.pdf',
          url:
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        ),
      ],
    ),
    NotesModule(
      title: 'Module 2: Supervised Learning Basics',
      notes: const [
        PdfItem(
          title: 'Chapter 1: RegressionNotes.pdf',
          url:
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        ),
        PdfItem(
          title: 'Chapter 2: ClassificationNotes.pdf',
          url:
              'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
        ),
      ],
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // 🔹 yaha pe _modules ko set karo (local final nahi)
    _modules = [
      CourseModule(
        title: 'Module 1: Introduction to Machine Learning',
        lessons: [
          LessonData(
            title: 'Chapter 1: What is Machine Learning?',
            url:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
            duration: '08:32',
            isFree: true,
          ),
          LessonData(
            title: 'Chapter 2: Types of ML',
            url:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            duration: '12:10',
          ),
          LessonData(
            title: 'Chapter 3: Real Life Use Cases',
            url:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
            duration: '09:45',
          ),
        ],
      ),
      CourseModule(
        title: 'Module 2: Supervised Learning Basics',
        lessons: [
          LessonData(
            title: 'Chapter 1: Regression',
            url:
                'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
            duration: '11:02',
          ),
          // ...
        ],
      ),
    ];

    // 🔹 ye tumhara existing flat list hai (agar kahin aur UI me use kar rahe ho)
    _lessons = [
      _LessonItem(
        title: 'Introduction to AI & Course Overview',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        durationLabel: '4:20',
        isFree: true,
      ),
      _LessonItem(
        title: 'Setting up Python Environment',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        durationLabel: '7:10',
        isFree: true,
      ),
      _LessonItem(
        title: 'Machine Learning Basics',
        url:
            'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4',
        durationLabel: '12:03',
        isFree: false,
      ),
    ];

    _initializePlayer(_lessons[_currentIndex].url);
  }

  Future<void> _initializePlayer(String url) async {
    await _disposePlayer();
    _videoController = VideoPlayerController.networkUrl(Uri.parse(url));
    await _videoController!.initialize();
    _chewieController = ChewieController(
      videoPlayerController: _videoController!,
      autoPlay: false,
      showControls: true,
      allowMuting: true,
      allowPlaybackSpeedChanging: true,
    );
    setState(() {});
  }

  Future<void> _disposePlayer() async {
    await _chewieController?.pause();
    _chewieController?.dispose();
    await _videoController?.dispose();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _disposePlayer();
    super.dispose();
  }

  String _fullUrl(String path) {
    if (path.isEmpty) return '';
    final p = path.toLowerCase();
    if (p.startsWith('http://') || p.startsWith('https://')) return path;
    return 'https://api.auratechacademy.com/${path.replaceFirst(RegExp(r"^/+"), "")}';
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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            stretch: true,
            expandedHeight: 280,
            backgroundColor: AppColors.primary,
            title: Text(c.courseTitle,
                style: const TextStyle(color: Colors.white),
                overflow: TextOverflow.ellipsis),
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
                const SizedBox(height: 12),
                // _TopMetaCard(course: c),
                // const SizedBox(height: 12),
                _TabsHeader(tabController: _tabController),
                _TabViews(tabController: _tabController, course: c),
                const SizedBox(height: 20),
                _LearningHub(
                  course: c,
                  onOpenVideos: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningVideosPage(
                        title: 'Machine Learning Crash Course',
                        modules: _modules,
                      ),
                    ),
                  ),
                  onOpenMaterials: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningMaterialsPage(
                        title: 'Machine Learning Crash Course',
                        modules: notesModules,
                      ),
                    ),
                  ),
                  onOpenQuiz: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => QuizPage(title: c.courseTitle)),
                  ),
                  onOpenCertificate: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CertificatePage(
                        courseTitle: 'Flutter App Development',
                        userName: 'Saru Khan',
                        completedOn: DateTime.now(),
                        priceText: '₹349 (Inc. GST)',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// =================================================================
/// LEARNING VIDEOS PAGE WITH DOWNLOAD
/// =================================================================
///

class _TopMetaCard extends StatelessWidget {
  final CourseMaster course;
  const _TopMetaCard({required this.course});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final chips = <Widget>[
      _MetaChip(
        icon: Icons.schedule_rounded,
        label: '${course.courseDuration} ${course.courseDurationUnit}',
      ),
      if (course.courseLevel.isNotEmpty)
        _MetaChip(
            icon: Icons.stacked_bar_chart_rounded, label: course.courseLevel),
      if (course.language.isNotEmpty)
        _MetaChip(icon: Icons.language_rounded, label: course.language),
      if (course.courseRating.isNotEmpty)
        _MetaChip(
            icon: Icons.star_rate_rounded, label: '${course.courseRating} ★'),
      if (course.numberOfStudents.isNotEmpty)
        _MetaChip(
            icon: Icons.group_rounded,
            label: '${course.numberOfStudents} learners'),
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Card(
        color: AppColors.surface,
        shadowColor: AppColors.shadow,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              course.courseTitle,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
                height: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: -6, children: chips),
            const SizedBox(height: 12),
            ..._HtmlText.blocks(course.description).map(
              (p) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(
                  p,
                  style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                      fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                if (course.courseCategory?.categoryName.isNotEmpty == true)
                  Text(
                    course.courseCategory!.categoryName,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                Spacer(),
                _PricePill(amount: course.courseFee),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _MetaChip({required this.icon, required this.label});
  @override
  Widget build(BuildContext context) {
    return Chip(
      elevation: 0,
      backgroundColor: AppColors.background,
      side: const BorderSide(color: AppColors.border),
      padding: const EdgeInsets.symmetric(horizontal: 8),
      avatar: Icon(icon, size: 16, color: AppColors.primary),
      label: Text(label, style: const TextStyle(color: AppColors.textPrimary)),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      visualDensity: const VisualDensity(horizontal: -2, vertical: -2),
    );
  }
}

class _PricePill extends StatelessWidget {
  final double amount;
  const _PricePill({required this.amount});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.primary.withOpacity(.25)),
      ),
      child: Text(
        '₹ ${amount.toStringAsFixed(0)}',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w800,
          fontSize: 14,
        ),
      ),
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

                  // _BulletOrNumber(detail!.certification),
                  // _KVRow(
                  //       k: 'Certification',
                  //       v: _HtmlText.inline(detail!.certification)),
                  // const SizedBox(height: 10),
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

  const _LearningHub({
    required this.course,
    required this.onOpenVideos,
    required this.onOpenMaterials,
    required this.onOpenQuiz,
    required this.onOpenCertificate,
  });

  @override
  Widget build(BuildContext context) {
    // Mock counts (wire with backend later)
    final totalVideos = int.tryParse(
            course.courseLesson.isEmpty ? '12' : course.courseLesson) ??
        12;
    final totalAssess = 2;
    final totalResources = 4;
    final progress = 0.0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: [
          // top counts strip + progress
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
                    '${0} / $totalVideos Videos  •  ${0} / $totalAssess Assessments  •  ${0} / $totalResources Resources',
                    style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: progress,
                      backgroundColor: AppColors.background,
                      valueColor: AlwaysStoppedAnimation(AppColors.primary),
                    ),
                  ),
                ],
              ),
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
                    child: Image.network(
                      'https://i.imgur.com/9KQxR9v.png',
                      width: 92,
                      height: 64,
                      fit: BoxFit.cover,
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
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onOpenCertificate,
            child: const Text('Get Certificate',
                style: TextStyle(fontWeight: FontWeight.w800)),
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
                    labelStyle: TextStyle(fontWeight: FontWeight.w700),
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
                  height: 360,
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
                          _NavTileLock(
                            title: 'Quiz',
                            subtitle: '1 Assessment',
                            isLocked: false, // set true if gated
                            onTap: onOpenQuiz,
                          ),
                          _NavTileLock(
                            title: 'Claim your certificate',
                            subtitle: '1 Assessment',
                            isLocked: false, // set true if gated
                            onTap: onOpenCertificate,
                          ),
                          _NavTile(
                            title: 'Learning Materials',
                            subtitle: '$totalResources Resources',
                            icon: Icons.menu_book_rounded,
                            onTap: onOpenMaterials,
                          ),
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
  // Convert possibly-HTML string into a single-line plain text
  static String inline(String html) {
    if (html.isEmpty) return '';
    var s = html;

    // normalize breaks and paragraphs to spaces
    s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), ' ');
    s = s.replaceAll(RegExp(r'</p>', caseSensitive: false), ' ');
    s = s.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), ' ');

    // remove all tags
    s = s.replaceAll(RegExp(r'<[^>]+>'), '');

    // decode a few common HTML entities
    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    return s.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  // Convert into blocks/paragraphs
  static List<String> blocks(String html) {
    if (html.trim().isEmpty) return const [];
    var s = html;

    // replace block-level separators with \n
    s = s.replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'</p>', caseSensitive: false), '\n');
    s = s.replaceAll(RegExp(r'<p[^>]*>', caseSensitive: false), '');

    // remove lists here; lists handled in toLines()
    s = s.replaceAll(
        RegExp(r'</?(ol|ul|li)[^>]*>', caseSensitive: false), '\n');

    // strip other tags
    s = s.replaceAll(RegExp(r'<[^>]+>'), '');

    // decode entities
    s = s
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'");

    // split & clean
    final parts =
        s.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
    return parts;
  }

  // Extracts ordered/bulleted items if present, otherwise returns paragraphs.
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

    // If we didn’t find any <ol>/<ul>, treat as paragraphs
    if (lines.isEmpty) {
      for (final p in blocks(html)) {
        lines.add(_Line.paragraph(p));
      }
    }

    return lines;
  }
}

class LessonData {
  final String title;
  final String url;
  final String duration;
  final bool isFree;

  LessonData({
    required this.title,
    required this.url,
    required this.duration,
    this.isFree = true,
  });
}

class CourseModule {
  final String title; // e.g. "Module 1: Introduction to Machine Learning"
  final List<LessonData> lessons;

  CourseModule({
    required this.title,
    required this.lessons,
  });
}

class LearningVideosPage extends StatefulWidget {
  final String title;
  final List<CourseModule> modules;

  const LearningVideosPage({
    super.key,
    required this.title,
    required this.modules,
  });

  @override
  State<LearningVideosPage> createState() => _LearningVideosPageState();
}

class _LearningVideosPageState extends State<LearningVideosPage> {
  VideoPlayerController? _vc;
  ChewieController? _cc;

  int _currentModuleIndex = 0;
  int _currentLessonIndex = 0;

  @override
  void initState() {
    super.initState();
    // Default: Module 0, Lesson 0 agar available ho
    if (widget.modules.isNotEmpty && widget.modules[0].lessons.isNotEmpty) {
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

  @override
  Widget build(BuildContext context) {
    final modules = widget.modules;

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
                      // ExpansionTile border color fix
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

                            return Column(
                              children: [
                                ListTile(
                                  onTap: () => _load(
                                      moduleIndex, lessonIndex), // play video
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  leading: CircleAvatar(
                                    backgroundColor: isActive
                                        ? AppColors.primary.withOpacity(.1)
                                        : AppColors.background,
                                    child: isActive
                                        ? const Icon(
                                            Icons.play_arrow_rounded,
                                            color: AppColors.primary,
                                          )
                                        : Text(
                                            '${lessonIndex + 1}',
                                            style: const TextStyle(
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                  ),
                                  title: Text(
                                    lesson.title,
                                    style: TextStyle(
                                      fontWeight: isActive
                                          ? FontWeight.w600
                                          : FontWeight.w400,
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
                                      if (lesson.isFree)
                                        const Icon(
                                          Icons.visibility_rounded,
                                          color: AppColors.primary,
                                          size: 20,
                                        )
                                      else
                                        const Icon(
                                          Icons.lock_outline_rounded,
                                          color: AppColors.textSecondary,
                                          size: 20,
                                        ),
                                      // Agar download chahiye to ye uncomment karna:
                                      // IconButton(
                                      //   icon: const Icon(
                                      //     Icons.download_rounded,
                                      //     color: AppColors.primary,
                                      //   ),
                                      //   onPressed: () => _downloadFile(
                                      //     lesson.url,
                                      //     '${lesson.title}.mp4',
                                      //   ),
                                      // ),
                                    ],
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

class _LessonItem {
  final String title;
  final String url;
  final String durationLabel;
  final bool isFree;
  _LessonItem({
    required this.title,
    required this.url,
    required this.durationLabel,
    this.isFree = false,
  });
}

/// =================================================================
/// LEARNING MATERIALS PAGE WITH PDF VIEW & DOWNLOAD
/// =================================================================


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



/// =================================================================
/// QUIZ PAGE (Interactive)
/// =================================================================

class QuizPage extends StatefulWidget {
  final String title;

  const QuizPage({super.key, required this.title});

  @override
  State<QuizPage> createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // 🔹 20 Questions – simple static list (baad me API se bhi la sakte ho)
  final List<Map<String, dynamic>> _questions = const [
    {
      'q': 'Which library is used for numerical computing in Python?',
      'a': ['TensorFlow', 'NumPy', 'React', 'NodeJS'],
      'correct': 1,
    },
    {
      'q': 'What is supervised learning?',
      'a': [
        'Learning without data',
        'Learning with labeled data',
        'Learning from mistakes only',
        'Learning random behavior',
      ],
      'correct': 1,
    },
    {
      'q': 'Which of these is a programming language?',
      'a': ['HTML', 'CSS', 'Python', 'Figma'],
      'correct': 2,
    },
    {
      'q': 'Which type of ML algorithm groups similar data points together?',
      'a': ['Classification', 'Clustering', 'Regression', 'Reinforcement'],
      'correct': 1,
    },
    {
      'q': 'In Python, how do you start a function definition?',
      'a': [
        'func myFunc():',
        'def myFunc():',
        'function myFunc()',
        'fn myFunc():'
      ],
      'correct': 1,
    },
    {
      'q': 'Which library is commonly used for data visualization in Python?',
      'a': ['Pandas', 'NumPy', 'Matplotlib', 'Scikit-learn'],
      'correct': 2,
    },
    {
      'q': 'Which of the following is a supervised learning task?',
      'a': [
        'Customer segmentation',
        'Spam email detection',
        'Anomaly detection',
        'Dimensionality reduction'
      ],
      'correct': 1,
    },
    {
      'q': 'What does "ML" stand for?',
      'a': [
        'Main Logic',
        'Machine Learning',
        'Model Language',
        'Modern Learning'
      ],
      'correct': 1,
    },
    {
      'q': 'Which data type is used to store True/False values in Python?',
      'a': ['int', 'bool', 'str', 'float'],
      'correct': 1,
    },
    {
      'q': 'Which of these is an example of regression?',
      'a': [
        'Predicting email is spam or not',
        'Predicting tomorrow’s temperature',
        'Clustering users by interests',
        'Finding outliers in a dataset',
      ],
      'correct': 1,
    },
    {
      'q': 'Which library is primarily used for deep learning?',
      'a': ['Pandas', 'TensorFlow', 'Seaborn', 'Matplotlib'],
      'correct': 1,
    },
    {
      'q': 'What is overfitting in ML?',
      'a': [
        'Model learns only from test data',
        'Model performs too well on training data but poorly on new data',
        'Model is too simple',
        'Model has no parameters',
      ],
      'correct': 1,
    },
    {
      'q': 'Which of these is a valid Python list?',
      'a': [
        '{1, 2, 3}',
        '(1, 2, 3)',
        '[1, 2, 3]',
        '<1, 2, 3>',
      ],
      'correct': 2,
    },
    {
      'q': 'Which of the following is NOT a machine learning task?',
      'a': ['Classification', 'Clustering', 'Compilation', 'Regression'],
      'correct': 2,
    },
    {
      'q': 'What does "epoch" mean in training a neural network?',
      'a': [
        'Number of layers in the model',
        'One full pass over the entire training dataset',
        'Number of neurons',
        'Size of the batch',
      ],
      'correct': 1,
    },
    {
      'q': 'Which of the following Python libraries is used for data analysis?',
      'a': ['Pandas', 'OpenCV', 'Django', 'Flask'],
      'correct': 0,
    },
    {
      'q': 'What is the main goal of classification?',
      'a': [
        'Predict a continuous value',
        'Group similar items',
        'Assign input to one of the predefined categories',
        'Reduce dimensions',
      ],
      'correct': 2,
    },
    {
      'q': 'In Python, which symbol is used for comments?',
      'a': ['//', '#', '/* */', '<!-- -->'],
      'correct': 1,
    },
    {
      'q': 'Which metric is commonly used for classification problems?',
      'a': ['Mean Squared Error', 'Accuracy', 'R-squared', 'RMSE'],
      'correct': 1,
    },
    {
      'q': 'Which of these is a popular Jupyter alternative for notebooks?',
      'a': ['VS Code', 'Google Colab', 'PyCharm', 'Slack'],
      'correct': 1,
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex; // konsa option select hai

  void _onNext() {
    final currentQ = _questions[_currentIndex];

    if (_selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select an answer before continuing.')),
      );
      return;
    }

    final correctIndex = currentQ['correct'] as int;
    if (_selectedIndex == correctIndex) {
      _score++;
    }

    if (_currentIndex < _questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
      });
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    final total = _questions.length;
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
            },
            child: const Text('Retry Quiz'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
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
    final q = _questions[_currentIndex];
    final options = q['a'] as List<String>;
    final total = _questions.length;
    final current = _currentIndex + 1;

    final progress = current / total;

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
            // 🔹 Top: Question counter + progress bar
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
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
            const SizedBox(height: 24),

            // 🔹 Question Card
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
                  q['q'] as String,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // 🔹 Options list with radio circles
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

            // 🔹 Bottom Next / Submit button
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
    final dateStr = DateFormat.yMMMMd().format(completedOn);

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
                      const Text('Auratech Academy',
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: AppColors.textPrimary,
                          )),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(.08),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Text('Verified Certificate',
                            style: TextStyle(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            )),
                      )
                    ],
                  ),
                  if (priceText.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Text(priceText,
                        style: const TextStyle(color: AppColors.textSecondary)),
                  ],

                  const SizedBox(height: 12),

                  // live preview (vector UI, not a network image)
                  AspectRatio(
                    aspectRatio: 6 / 7,
                    child: _CertificatePreview(
                      userName: userName,
                      courseTitle: courseTitle,
                      completedOn: dateStr,
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
                                borderRadius: BorderRadius.circular(12)),
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
                                borderRadius: BorderRadius.circular(12)),
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

  // ---------------------- PDF GEN ----------------------
  Future<pw.Document> _buildPdf() async {
    final pdf = pw.Document();

    final dateStr = DateFormat.yMMMMd().format(completedOn);

    final primary = const PdfColor.fromInt(0xFF2962FF); // tweak to your theme
    final textPrimary = const PdfColor.fromInt(0xFF111827);
    final textSecondary = const PdfColor.fromInt(0xFF6B7280);
    final border = const PdfColor.fromInt(0xFFE5E7EB);

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4.landscape,
        margin: const pw.EdgeInsets.all(24),
        build: (context) => pw.Container(
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: border, width: 2),
          ),
          child: pw.Stack(
            children: [
              // subtle watermark
              pw.Positioned.fill(
                child: pw.Center(
                  child: pw.Transform.rotate(
                    angle: -0.35,
                    child: pw.Text(
                      'AURATECH ACADEMY',
                      style: pw.TextStyle(
                        color: primary,
                        fontSize: 60,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                ),
              ),

              pw.Padding(
                padding: const pw.EdgeInsets.all(28),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    // header row
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: pw.CrossAxisAlignment.center,
                      children: [
                        pw.Text('Auratech Academy',
                            style: pw.TextStyle(
                              color: textPrimary,
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 20,
                            )),
                        pw.Container(
                          padding: const pw.EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: pw.BoxDecoration(
                            color: primary,
                            borderRadius: pw.BorderRadius.circular(16),
                          ),
                          child: pw.Text('Verified Certificate',
                              style: pw.TextStyle(
                                color: primary,
                                fontWeight: pw.FontWeight.bold,
                              )),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 24),

                    // title block
                    pw.Text('CERTIFICATE',
                        style: pw.TextStyle(
                          fontSize: 38,
                          letterSpacing: 2,
                          color: textPrimary,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 4),
                    pw.Text('OF COMPLETION',
                        style: pw.TextStyle(
                          fontSize: 16,
                          letterSpacing: 3,
                          color: textSecondary,
                        )),
                    pw.SizedBox(height: 28),

                    pw.Text('Presented to',
                        style: pw.TextStyle(
                          color: textSecondary,
                          fontSize: 12,
                        )),
                    pw.SizedBox(height: 4),
                    pw.Text(userName,
                        style: pw.TextStyle(
                          color: textPrimary,
                          fontSize: 28,
                          fontWeight: pw.FontWeight.bold,
                        )),
                    pw.SizedBox(height: 14),

                    pw.Text(
                      'For successfully completing the online course',
                      style: pw.TextStyle(color: textSecondary, fontSize: 12),
                    ),
                    pw.SizedBox(height: 6),

                    pw.Text(
                      courseTitle,
                      style: pw.TextStyle(
                        color: textPrimary,
                        fontSize: 18,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 8),
                    pw.Text('Course completed on $dateStr',
                        style:
                            pw.TextStyle(color: textSecondary, fontSize: 12)),
                    pw.Spacer(),

                    // footer row
                    pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Container(height: 1, width: 200, color: border),
                            pw.SizedBox(height: 4),
                            pw.Text('Harish Subramanian',
                                style: pw.TextStyle(
                                    color: textPrimary,
                                    fontWeight: pw.FontWeight.bold)),
                            pw.Text('Academic Director, Auratech Academy',
                                style: pw.TextStyle(
                                    color: textSecondary, fontSize: 10)),
                          ],
                        ),
                        pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Text('Verify Authenticity',
                                style: pw.TextStyle(
                                  color: textSecondary,
                                  fontSize: 10,
                                )),
                            pw.SizedBox(height: 4),
                            pw.BarcodeWidget(
                              data:
                                  'AURATECH|$userName|$courseTitle|$dateStr', // simple verifiable payload
                              barcode: pw.Barcode.qrCode(),
                              width: 64,
                              height: 64,
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
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

// ---------------------- LIVE PREVIEW WIDGET ----------------------
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: const Color(0xFFE5E7EB), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // watermark
          Center(
            child: Transform.rotate(
              angle: -0.35,
              child: Text(
                'AURATECH ACADEMY',
                style: TextStyle(
                  color: AppColors.primary.withOpacity(0.05),
                  fontSize: 40,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 2,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // header row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Auratech Academy',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: AppColors.textPrimary,
                        )),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(.08),
                        borderRadius: BorderRadius.circular(16),
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
                const SizedBox(height: 14),
                const Text(
                  'CERTIFICATE',
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'OF COMPLETION',
                  style: TextStyle(
                    fontSize: 12,
                    letterSpacing: 3,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 18),

                const Text('Presented to',
                    style: TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 4),
                Text(
                  userName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'For successfully completing the online course',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(courseTitle,
                    style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                        fontSize: 14)),
                const SizedBox(height: 4),
                Text('Course completed on $completedOn',
                    style: const TextStyle(
                        color: AppColors.textSecondary, fontSize: 12)),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        SizedBox(
                          height: 1,
                          width: 160,
                          child: DecoratedBox(
                            decoration: BoxDecoration(color: Color(0xFFE5E7EB)),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text('Sona Sharma',
                            style: TextStyle(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w700,
                                fontSize: 12)),
                        Text('Academic Director, Auratech Academy',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 10)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text('Verify Authenticity',
                            style: TextStyle(
                                color: AppColors.textSecondary, fontSize: 10)),
                        SizedBox(height: 6),
                        Icon(Icons.qr_code_2_rounded,
                            size: 40, color: AppColors.textSecondary),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
