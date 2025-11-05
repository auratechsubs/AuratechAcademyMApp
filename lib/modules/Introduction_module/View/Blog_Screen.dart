import 'package:auratech_academy/constant/constant_colors.dart';
import 'package:auratech_academy/modules/Introduction_module/Controller/Blog_Controller.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class BlogScreen extends StatelessWidget {
  BlogScreen({super.key});

  final BlogController blogController = Get.find();
  final RxList<bool> expandedStates = <bool>[].obs;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Blogs",
          style: TextStyle(
            fontSize: isTablet ? 20 : 18,
            fontWeight: FontWeight.bold,
            // color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,

      ),
      body: SafeArea(
        child: Obx(() {
          if (blogController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (blogController.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                blogController.errorMessage.value,
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
            );
          }

          if (blogController.blogList.isEmpty) {
            return Center(
              child: Text(
                "No blogs found.",
                style: TextStyle(fontSize: isTablet ? 16 : 14),
              ),
            );
          }

          // Sync expandedStates with blog list length
          while (expandedStates.length < blogController.blogList.length) {
            expandedStates.add(false);
          }

          return ListView.builder(
            padding: EdgeInsets.all(isTablet ? 24 : 16),
            itemCount: blogController.blogList.length,
            itemBuilder: (context, index) {
              final blog = blogController.blogList[index];
              final isExpanded = expandedStates[index];

              return Card(
                color: AppColors.background,
                margin: EdgeInsets.only(bottom: isTablet ? 20 : 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: EdgeInsets.all(isTablet ? 20 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          "https://api.auratechacademy.com${blog.image}",
                          height: isTablet ? 220 : 180,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(
                            Icons.image_not_supported,
                            size: isTablet ? 60 : 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 24 : 20),
                      Text(
                        blog.title ?? "Untitled Blog",
                        style: GoogleFonts.roboto(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 20 : 18,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      SizedBox(height: isTablet ? 12 : 8),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Builder(
                            builder: (context) {
                              final fullText = blog.blogDetail.replaceAll(RegExp(r'<[^>]*>'), '') ?? '';
                              final isLong = fullText.length > 150;
                              final shortText = isLong ? fullText.substring(0, 150) : fullText;

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 5.0),
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          TextSpan(
                                            text: isExpanded || !isLong ? fullText : "$shortText... ",
                                            style: GoogleFonts.roboto(
                                              fontSize: isTablet ? 18 : 16,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                          if (!isExpanded && isLong)
                                            TextSpan(
                                              text: 'Read More',
                                              style: TextStyle(
                                                color: Theme.of(context).colorScheme.primary,
                                                fontSize: isTablet ? 20 : 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = () {
                                                  expandedStates[index] = true;
                                                  expandedStates.refresh();
                                                },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  if (isExpanded && isLong)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 5.0),
                                      child: TextButton(
                                        onPressed: () {
                                          expandedStates[index] = false;
                                          expandedStates.refresh();
                                        },
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: const Size(0, 0),
                                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        ),
                                        child: Text(
                                          "Read Less",
                                          style: TextStyle(
                                            color: Theme.of(context).colorScheme.primary,
                                            fontSize: isTablet ? 20 : 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),

                        ],
                      ),

                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}