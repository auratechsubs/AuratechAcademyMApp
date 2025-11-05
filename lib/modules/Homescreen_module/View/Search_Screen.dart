import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/constant_colors.dart';
import '../../Course_module/Controller/Popular_course_controller.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PopularCourseController popularCourseController = Get.find();

  List<String> recentSearches = [
    '3D Design',
    'Graphic Design',
    'Programming',
    'SEO & Marketing',
    'Web Development',
    'Finance & Accounting',
  ];

  void _removeSearch(int index) {
    setState(() {
      recentSearches.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleSpacing: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.black,
            size: isTablet ? 28 : 24,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Search',
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isTablet ? 24 : 16,
          vertical: isTablet ? 12 : 8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔍 Search Box
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (value) {
                      popularCourseController.filterCategory(value);
                    },
                    decoration: InputDecoration(
                      hintText: "Search courses...",
                      hintStyle: GoogleFonts.lato(
                        color: Colors.grey,
                        fontSize: isTablet ? 16 : 14,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: AppColors.primary,
                        size: isTablet ? 28 : 24,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                        vertical: isTablet ? 12 : 0,
                        horizontal: isTablet ? 20 : 16,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(fontSize: isTablet ? 16 : 14),
                  ),
                ),
                SizedBox(width: isTablet ? 12 : 8),
                CircleAvatar(
                  radius: isTablet ? 26 : 22,
                  backgroundColor: AppColors.primary,
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: isTablet ? 24 : 20,
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 24 : 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Searches",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 18 : 16,
                    color: AppColors.textPrimary,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      recentSearches.clear();
                    });
                  },
                  child: Text(
                    "CLEAR ALL",
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isTablet ? 12 : 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: recentSearches.length,
              separatorBuilder: (_, __) =>
              const Divider(height: 1, color: Colors.black12),
              itemBuilder: (context, index) {
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    recentSearches[index],
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black54,
                      size: isTablet ? 20 : 18,
                    ),
                    onPressed: () => _removeSearch(index),
                  ),
                );
              },
            ),
            SizedBox(height: isTablet ? 24 : 20),
            Text(
              "Search Results",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isTablet ? 18 : 16,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(height: isTablet ? 12 : 10),
            Obx(() {
              final courseList = popularCourseController.filterCourse;
              if (courseList.isEmpty) {
                return Text(
                  "No results found.",
                  style: TextStyle(fontSize: isTablet ? 16 : 14),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: courseList.length,
                itemBuilder: (context, index) {
                  final item = courseList[index];
                  final url =
                      "https://api.auratechacademy.com${item.courseImage}";
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                      child: ListTile(
                        leading: Container(
                          height: isTablet ? 70 : 60,
                          width: isTablet ? 70 : 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            image: DecorationImage(
                              image: NetworkImage(url),
                              fit: BoxFit.cover,
                              onError: (exception, stackTrace) => const AssetImage(
                                  'assets/images/congratulationpic.png'),
                            ),
                          ),
                        ),
                        title: Text(
                          item.courseCategory?.categoryName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: isTablet ? 16 : 14,
                          ),
                        ),
                        subtitle: Text(
                          item.courseTitle,
                          style: TextStyle(fontSize: isTablet ? 14 : 12),
                        ),
                        trailing: Text(
                          "₹${item.courseFee}",
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }
}