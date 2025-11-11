import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';

import '../../../constant/constant_colors.dart';
import '../Model/Course_Master_Model.dart';
import 'package:webview_flutter/webview_flutter.dart';

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

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
                _TopMetaCard(course: c),
                const SizedBox(height: 12),
                _TabsHeader(tabController: _tabController),
                _TabViews(tabController: _tabController, course: c),
                const SizedBox(height: 20),
                _LearningHub(
                  course: c,
                  onOpenVideos: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningVideosPage(
                        title: c.courseTitle,
                        lessons: _lessons
                            .map((e) => LessonData(
                                  title: e.title,
                                  url: e.url,
                                  duration: e.durationLabel,
                                  isFree: e.isFree,
                                ))
                            .toList(),
                      ),
                    ),
                  ),
                  onOpenMaterials: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => LearningMaterialsPage(
                        title: c.courseTitle,
                        materials: [
                          PdfItem(
                            title: 'AI Lecture Notes - Module 1',
                            url:
                                'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
                          ),
                          PdfItem(
                            title: 'NumPy & Pandas Quick Reference',
                            url:
                                'https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf',
                          ),
                        ],
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
                        title: c.courseTitle,
                        previewImage: 'https://i.imgur.com/9KQxR9v.png',
                        downloadUrl:
                            'https://www.adobe.com/support/products/enterprise/knowledgecenter/media/c4611_sample_explain.pdf',
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
      color: AppColors.surface,
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

class _KVRow extends StatelessWidget {
  final String k;
  final String v;
  const _KVRow({required this.k, required this.v});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$k: ',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            )),
        Expanded(
          child: Text(
            v,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
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

class LearningVideosPage extends StatefulWidget {
  final String title;
  final List<LessonData> lessons;
  const LearningVideosPage(
      {super.key, required this.title, required this.lessons});

  @override
  State<LearningVideosPage> createState() => _LearningVideosPageState();
}

class LessonData {
  final String title;
  final String url;
  final String duration;
  final bool isFree;
  LessonData(
      {required this.title,
      required this.url,
      required this.duration,
      this.isFree = false});
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

class _LearningVideosPageState extends State<LearningVideosPage> {
  VideoPlayerController? _vc;
  ChewieController? _cc;
  int _index = 0;

  @override
  void initState() {
    super.initState();
    _load(0);
  }

  Future<void> _load(int i) async {
    await _dispose();
    _vc = VideoPlayerController.networkUrl(Uri.parse(widget.lessons[i].url));
    await _vc!.initialize();
    _cc = ChewieController(
      videoPlayerController: _vc!,
      autoPlay: false,
      showControls: true,
    );
    setState(() => _index = i);
  }

  Future<void> _dispose() async {
    await _cc?.pause();
    _cc?.dispose();
    await _vc?.dispose();
  }

  Future<void> _downloadFile(String url, String name) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      final req = await http.Client().send(http.Request('GET', Uri.parse(url)));
      final total = req.contentLength ?? 0;
      var downloaded = 0;
      final sink = file.openWrite();
      await for (final chunk in req.stream) {
        downloaded += chunk.length;
        sink.add(chunk);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Downloading ${((downloaded / total) * 100).toStringAsFixed(0)}%'),
          duration: const Duration(milliseconds: 300),
        ));
      }
      await sink.close();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Download complete! Opening...')),
      );
      final result =
          await OpenFilex.open(file.path); // replaces OpenFile.open(path)
      if (result.type != ResultType.done) {
        // fallback if no handler found
        await launchUrl(Uri.file(file.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Download failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = widget.lessons;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text(widget.title),
      ),
      body: ListView(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Card(
              margin: const EdgeInsets.all(12),
              color: Colors.black,
              clipBehavior: Clip.hardEdge,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: _cc != null && _vc!.value.isInitialized
                  ? Chewie(controller: _cc!)
                  : const Center(child: CircularProgressIndicator()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.border)),
              child: ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: l.length,
                separatorBuilder: (_, __) =>
                    const Divider(height: 1, color: AppColors.border),
                itemBuilder: (_, i) => ListTile(
                  onTap: () => _load(i),
                  leading: CircleAvatar(
                    backgroundColor: AppColors.background,
                    child: i == _index
                        ? const Icon(Icons.play_arrow, color: AppColors.primary)
                        : Text('${i + 1}',
                            style:
                                const TextStyle(color: AppColors.textPrimary)),
                  ),
                  title: Text(l[i].title),
                  subtitle: Text(l[i].duration),
                  trailing: Icon(Icons.visibility_rounded,
                      color: l[i].isFree
                          ? AppColors.primary
                          : AppColors.textSecondary),
                  // trailing: IconButton(
                  //   icon: const Icon(Icons.download_rounded,
                  //       color: AppColors.primary),
                  //   onPressed: () =>
                  //       _downloadFile(l[i].url, '${l[i].title}.mp4'),
                  // ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// =================================================================
/// LEARNING MATERIALS PAGE WITH PDF VIEW & DOWNLOAD
/// =================================================================
class LearningMaterialsPage extends StatelessWidget {
  final String title;
  final List<PdfItem> materials;
  const LearningMaterialsPage(
      {super.key, required this.title, required this.materials});

  Future<void> _downloadFile(
      BuildContext context, String url, String name) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$name');
      final res = await http.get(Uri.parse(url));
      await file.writeAsBytes(res.bodyBytes);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('PDF downloaded!')));
      // OpenFile.open(file.path);
      final result =
          await OpenFilex.open(file.path); // replaces OpenFile.open(path)
      if (result.type != ResultType.done) {
        // fallback if no handler found
        await launchUrl(Uri.file(file.path));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
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
        itemCount: materials.length,
        itemBuilder: (_, i) {
          final m = materials[i];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: AppColors.border),
            ),
            margin: const EdgeInsets.only(bottom: 10),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.background,
                child: Icon(Icons.picture_as_pdf, color: AppColors.primary),
              ),
              title: Text(m.title,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Tap to view or download'),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PdfWebViewPage(title: m.title, url: m.url),
                ),
              ),
              // trailing: IconButton(
              //   icon: const Icon(Icons.download, color: AppColors.primary),
              //   onPressed: () =>
              //       _downloadFile(context, m.url, '${m.title}.pdf'),
              // ),
            ),
          );
        },
      ),
    );
  }
}

class PdfItem {
  final String title;
  final String url;
  const PdfItem({required this.title, required this.url});
}

/// =================================================================
/// PDF VIEWER PAGE
/// =================================================================
///
class PdfWebViewPage extends StatefulWidget {
  final String title;
  final String url;
  const PdfWebViewPage({super.key, required this.title, required this.url});

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
        'https://docs.google.com/gview?embedded=1&url=${widget.url}');
    final params = const PlatformWebViewControllerCreationParams();
    final controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageFinished: (_) => setState(() => _loading = false),
      ))
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
      body: Stack(children: [
        WebViewWidget(controller: _controller),
        if (_loading)
          const LinearProgressIndicator(minHeight: 2, color: AppColors.primary),
      ]),
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
  final _questions = const [
    {
      'q': 'Which library is used for numerical computing in Python?',
      'a': ['TensorFlow', 'NumPy', 'React', 'NodeJS'],
      'correct': 1
    },
    {
      'q': 'What is supervised learning?',
      'a': [
        'Learning without data',
        'Learning with labeled data',
        'Learning from mistakes only',
        'Learning random behavior'
      ],
      'correct': 1
    },
  ];

  int _index = 0;
  int _score = 0;

  @override
  Widget build(BuildContext context) {
    final q = _questions[_index];
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
            Text(q['q'] as String,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary)),
            const SizedBox(height: 16),
            ...(q['a'] as List<String>).asMap().entries.map((e) {
              final i = e.key;
              final text = e.value;
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 6),
                child: ListTile(
                  title: Text(text),
                  onTap: () {
                    final correct = q['correct'] == i;
                    if (correct) _score++;
                    if (_index < _questions.length - 1) {
                      setState(() => _index++);
                    } else {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: const Text('Quiz Completed!'),
                          content: Text(
                              'Your Score: $_score / ${_questions.length}'),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('OK'))
                          ],
                        ),
                      );
                    }
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

/// =================================================================
/// CERTIFICATE PAGE
/// =================================================================
class CertificatePage extends StatelessWidget {
  final String title;
  final String previewImage; // sample image
  final String downloadUrl; // pdf to download
  final String priceText;

  const CertificatePage({
    super.key,
    required this.title,
    required this.previewImage,
    required this.downloadUrl,
    required this.priceText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Text('$title • Certificate', overflow: TextOverflow.ellipsis),
      ),
      backgroundColor: AppColors.background,
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: AppColors.surface,
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
                  const Text('Certificate of Completion',
                      style: TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                          color: AppColors.textPrimary)),
                  const SizedBox(height: 6),
                  Text(priceText,
                      style: const TextStyle(color: AppColors.textSecondary)),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(previewImage,
                        height: 180, fit: BoxFit.cover),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => launchUrl(Uri.parse(downloadUrl),
                              mode: LaunchMode.externalApplication),
                          child: const Text('Buy / Download Sample'),
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
}
