import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

import '../../Course_module/Model/Course_Master_Model.dart';
import '../../Course_module/View/Single_course_detail_Screen.dart';
import '../Controller/Segmentbase_Search_Controller.dart';

class Segmentbasesearchpage extends StatefulWidget {
  /// constructor se domain / segment name aayega
  final String initialSegment;

  const Segmentbasesearchpage({super.key, required this.initialSegment});

  @override
  State<Segmentbasesearchpage> createState() => _SegmentbasesearchpageState();
}

class _SegmentbasesearchpageState extends State<Segmentbasesearchpage> {
  final TextEditingController _searchController = TextEditingController();

  final CourseSegmantMasterController _courseCtrl =
      Get.find<CourseSegmantMasterController>();

  // yaha tum chaaho to backend se bhi segment list la sakte ho,
  // filhal tumhara hi static list rakhta hoon
  final List<String> _segments = const [
    'IT Diploma & Software Development',
    'Data & AI Technologies',
    'Security & Networking',
    'Diploma Courses',
  ];

  String? _selectedSegment;

  @override
  void initState() {
    super.initState();

    _selectedSegment = widget.initialSegment ?? _segments.first;

    // search ko controller se sync karna (optional but clean)
    _courseCtrl.searchQuery.value = '';

    // initial API call
    if (_selectedSegment != null) {
      _courseCtrl.fetchCoursesBySegment(_selectedSegment!);
    }

    _searchController.addListener(() {
      _courseCtrl.searchQuery.value = _searchController.text;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Flutter side filtering _CourseItem ke form me (UI friendly model)
  List<_CourseItem> _mapFromControllerCourses() {
    final List<CourseMaster> source = _courseCtrl.filteredCourses;

    return source.map((c) {
      final segmentName = c.courseCategory?.courseSegment?.name ??
          c.courseCategory?.categoryName ??
          'Unknown Segment';

      final levelText =
          '${c.courseLevel.isNotEmpty ? c.courseLevel : 'Course'} • ${c.courseDuration} ${c.courseDurationUnit}';

      final learnersText =
          c.numberOfStudents.isNotEmpty ? c.numberOfStudents : 'Learners';

      // tag decide – thoda swag:
      String tag = 'Trending';
      if (c.topCourse == 1 || c.topCourse == 2) {
        tag = 'Top Course';
      } else if (double.tryParse(c.courseRating) != null &&
          double.parse(c.courseRating) >= 4.5) {
        tag = 'Top Rated';
      }

      return _CourseItem(
        title: c.courseTitle,
        segment: segmentName,
        level: levelText,
        learners: '$learnersText learners',
        tag: tag,
        imageUrl: '${c.courseImage}',
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: const Text('Find Courses by Domain'),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // 🔍 Search + description
          _buildSearchSection(isTablet),

          // 🧩 Segment filter chips
          _buildSegmentChips(isTablet),

          const SizedBox(height: 8),

          // 📚 Course list (from controller)
          Expanded(
            child: _buildCourseList(isTablet),
          ),
        ],
      ),
    );
  }

  // ───────────────── SEARCH BAR ─────────────────
  Widget _buildSearchSection(bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 20 : 16,
        vertical: 8,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Browse by Segment',
            style: TextStyle(
              fontSize: isTablet ? 18 : 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Filter courses based on your preferred learning domain.',
            style: TextStyle(
              fontSize: isTablet ? 14 : 12.5,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, color: Colors.grey, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Search courses or segments…',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 18),
                    splashRadius: 18,
                    onPressed: () {
                      _searchController.clear();
                      // listener already controller.searchQuery update kar dega
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

   Widget _buildSegmentChips(bool isTablet) {
    return SizedBox(
      height: isTablet ? 54 : 50,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 16 : 12,
          vertical: 6,
        ),
        scrollDirection: Axis.horizontal,
        itemCount: _segments.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final segment = _segments[index];
          final bool isSelected = segment == _selectedSegment;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedSegment = segment;
              });
              // new segment ke liye fresh API call
              _courseCtrl.fetchCoursesBySegment(segment);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(
                horizontal: isTablet ? 18 : 14,
                vertical: isTablet ? 10 : 8,
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: isSelected ? const Color(0xFF2563EB) : Colors.white,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2563EB)
                      : Colors.grey.shade300,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: const Color(0xFF2563EB).withOpacity(0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ]
                    : [],
              ),
              child: Center(
                child: Text(
                  segment,
                  style: TextStyle(
                    fontSize: isTablet ? 13.5 : 12.5,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white : const Color(0xFF111827),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

   Widget _buildCourseList(bool isTablet) {
    return Obx(() {
      if (_courseCtrl.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (_courseCtrl.errorMessage.isNotEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded,
                    size: isTablet ? 56 : 46, color: Colors.redAccent),
                const SizedBox(height: 12),
                Text(
                  'Something went wrong',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  _courseCtrl.errorMessage.value,
                  style: TextStyle(
                    fontSize: isTablet ? 13.5 : 12.5,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 12),
                ElevatedButton.icon(
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Retry'),
                  onPressed: () {
                    final seg = _selectedSegment ?? _segments.first;
                    _courseCtrl.fetchCoursesBySegment(seg);
                  },
                ),
              ],
            ),
          ),
        );
      }

      final items = _mapFromControllerCourses();

      if (items.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.search_off_rounded,
                    size: isTablet ? 60 : 46, color: Colors.grey.shade400),
                const SizedBox(height: 12),
                Text(
                  'No courses found',
                  style: TextStyle(
                    fontSize: isTablet ? 18 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF111827),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Try changing the segment or search keyword.',
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 13,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 18 : 14,
          vertical: 10,
        ),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final course = items[index];
          return _CourseCard(
            course: course,
            isTablet: isTablet,
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => CourseDetailScreen(
                            course: _courseCtrl.courses[index],
                          )));
            },
          );
        },
      );
    });
  }
}



class _CourseCard extends StatelessWidget {
  final _CourseItem course;
  final bool isTablet;
  final VoidCallback? onTap;

  const _CourseCard({
    required this.course,
    required this.isTablet,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final gradient = const LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        Color(0xFFEEF2FF),
        Color(0xFFE0F2FE),
      ],
    );

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Container(
          margin: const EdgeInsets.all(1.2),
          padding: EdgeInsets.all(isTablet ? 16 : 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withOpacity(0.96),
          ),
          child: Row(
            children: [
              // Left decorative icon / avatar
              Container(
                width: isTablet ? 60 : 52,
                height: isTablet ? 60 : 52,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF2563EB), Color(0xFF4F46E5)],
                  ),
                ),

                child: ClipOval(
                  child: Image.network(
                    "https://api.auratechacademy.com${course.imageUrl}",
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Right content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tag
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB).withOpacity(0.08),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        course.tag,
                        style: TextStyle(
                          fontSize: isTablet ? 11.5 : 11,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      course.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      course.segment,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: isTablet ? 13.5 : 12.5,
                        color: Colors.grey.shade800,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Icon(Icons.access_time_rounded,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          course.level,
                          style: TextStyle(
                            fontSize: isTablet ? 12.5 : 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.people_alt_rounded,
                            size: 16, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Text(
                          course.learners,
                          style: TextStyle(
                            fontSize: isTablet ? 12.5 : 12,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 6),

              Icon(
                Icons.arrow_forward_ios_rounded,
                size: isTablet ? 16 : 14,
                color: Colors.grey.shade500,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _CourseItem {
  final String title;
  final String segment;
  final String level;
  final String learners;
  final String tag;
  final String imageUrl;

  const _CourseItem({
    required this.title,
    required this.segment,
    required this.level,
    required this.learners,
    required this.tag,
    required this.imageUrl,
  });
}