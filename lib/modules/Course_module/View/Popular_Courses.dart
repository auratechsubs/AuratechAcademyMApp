import 'package:auratech_academy/modules/Course_module/View/Single_course_detail_Screen.dart';
import 'package:flutter/material.dart';
import '../../../constant/constant_colors.dart';
import '../Model/Course_Master_Model.dart';

class PopularCoursesScreen extends StatelessWidget {
  final List<CourseMaster> courses;

  const PopularCoursesScreen({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        title: const Text(
          "Popular Courses",
          style: TextStyle(color: Colors.black, fontSize: 20),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body:
      Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04, vertical: screenHeight * 0.02),
        child:
        ListView.builder(
          itemCount: courses.length,
          itemBuilder: (context, index) {
            final course = courses[index];

            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CourseDetailScreen(course: course),
                  ),
                );
              },
              child:
              Container(
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                padding: EdgeInsets.all(screenWidth * 0.03),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.blue, width: 2),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    )
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Course Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        course.courseThumbImage.isNotEmpty
                            ? "https://api.auratechacademy.com/${course.courseThumbImage}"
                            : 'https://api.auratechacademy.com/media/testimonial/testi_2_1_jrHSv5h.jpg',
                        height: screenWidth * 0.22,
                        width: screenWidth * 0.22,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: screenWidth * 0.04),

                    // Course Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Category
                          Text(
                            course.courseCategory?.categoryName ?? "Category",
                            style: TextStyle(
                              color: Colors.orange,
                              fontSize: screenWidth * 0.03,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.005),

                          // Title
                          Text(
                            course.courseTitle ?? "Title",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.01),

                          // Rating and Students
                          Row(
                            children: [
                              const Icon(Icons.star, size: 16, color: Colors.amber),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                course.courseRating ?? "4.5",
                                style: const TextStyle(color: AppColors.textSecondary),
                              ),
                              SizedBox(width: screenWidth * 0.03),
                              const Icon(Icons.group, size: 16, color: AppColors.primary),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                course.numberOfStudents ?? "0 students",
                                style: TextStyle(
                                  fontSize: screenWidth * 0.03,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Price & Bookmark
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          "₹${course.courseFee.toStringAsFixed(0)}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.030,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        const Icon(Icons.bookmark_border, size: 20, color: AppColors.primary),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
