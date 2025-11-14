import 'package:flutter/material.dart';

class Segmentbasesearchpage extends StatefulWidget {
  /// Optional: agar tum kisi specific segment se is screen ko open karna chaho
  final String? initialSegment;

  const Segmentbasesearchpage({super.key, this.initialSegment});

  @override
  State<Segmentbasesearchpage> createState() => _SegmentbasesearchpageState();
}

class _SegmentbasesearchpageState extends State<Segmentbasesearchpage> {
  final TextEditingController _searchController = TextEditingController();

  // Dummy segment list – baad me API / controller se aa sakti hai
  final List<String> _segments = const [
    'IT Diploma & Software Development',
    'Data & AI Technologies',
    'Security & Networking',
    'Diploma Courses',
  ];

  String? _selectedSegment;

  // Dummy course list – yaha tum apna API data map kar sakte ho
  final List<_CourseItem> _allCourses = const [
    _CourseItem(
      title: 'Core Python Programming',
      segment: 'IT Diploma & Software Development',
      level: 'Beginner • 2 Months',
      learners: '1250+ learners',
      tag: 'Most Popular',
    ),
    _CourseItem(
      title: 'Advanced Python Programming',
      segment: 'IT Diploma & Software Development',
      level: 'Intermediate • 1 Month',
      learners: '900+ learners',
      tag: 'Advanced',
    ),
    _CourseItem(
      title: 'Machine Learning using Python',
      segment: 'Data & AI Technologies',
      level: 'Intermediate • 2 Months',
      learners: '185+ learners',
      tag: 'In-demand',
    ),
    _CourseItem(
      title: 'Network Security Fundamentals',
      segment: 'Security & Networking',
      level: 'Beginner • 1.5 Months',
      learners: '300+ learners',
      tag: 'Job-ready',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _selectedSegment = widget.initialSegment ?? _segments.first;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_CourseItem> get _filteredCourses {
    final query = _searchController.text.trim().toLowerCase();

    return _allCourses.where((c) {
      final matchSegment =
          _selectedSegment == null || c.segment == _selectedSegment;
      final matchSearch = query.isEmpty ||
          c.title.toLowerCase().contains(query) ||
          c.segment.toLowerCase().contains(query);

      return matchSegment && matchSearch;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FB),
      appBar: AppBar(
        title: Text(
          'Find Courses by Domain',
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 8),

          // 🔍 Search + chip header
          _buildSearchSection(isTablet),

          // 🧩 Segment filter chips
          _buildSegmentChips(isTablet),

          const SizedBox(height: 8),

          // 📚 Course list
          Expanded(
            child: _buildCourseList(isTablet),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SEARCH BAR + SMALL INFO
  // ─────────────────────────────────────────────────────────────
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
                    onChanged: (_) => setState(() {}),
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
                      setState(() {});
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // SEGMENT CHIPS
  // ─────────────────────────────────────────────────────────────
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

  // ─────────────────────────────────────────────────────────────
  // COURSE LIST
  // ─────────────────────────────────────────────────────────────
  Widget _buildCourseList(bool isTablet) {
    final items = _filteredCourses;

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
            // TODO: yaha CourseDetailPage pe navigation karna
            // Navigator.push(context, MaterialPageRoute(
            //   builder: (_) => CourseDetailPage(course: course),
            // ));
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────
// INTERNAL MODELS
// ─────────────────────────────────────────────────────────────

class _CourseItem {
  final String title;
  final String segment;
  final String level;
  final String learners;
  final String tag;

  const _CourseItem({
    required this.title,
    required this.segment,
    required this.level,
    required this.learners,
    required this.tag,
  });
}

// ─────────────────────────────────────────────────────────────
// COURSE CARD UI
// ─────────────────────────────────────────────────────────────

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
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 28,
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
