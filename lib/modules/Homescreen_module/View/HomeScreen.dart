import 'package:auratech_academy/modules/Category_module/Controller/Category_controller.dart';
import 'package:auratech_academy/modules/Homescreen_module/Model/Coursesegment_Model.dart'
    as csmodel;
import 'package:auratech_academy/modules/Mentor_module/Controller/Mentor_Controller.dart';
import 'package:auratech_academy/utils/storageservice.dart';
import 'package:auratech_academy/utils/util_klass.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:auratech_academy/modules/Course_module/View/Popular_Courses.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' show DateFormat;
import '../../../constant/constant_colors.dart';
import '../../../widget/WebminarCard.dart';
import '../../../widget/tagwidget.dart';
import '../../Category_module/View/Category_Screen.dart';
import '../../Course_module/Controller/Popular_course_controller.dart';
import '../../Course_module/View/Single_course_detail_Screen.dart';
import '../../Mentor_module/View/Single_mentor_Screen.dart';
import '../../Mentor_module/View/Top_Mentor_Screen.dart';
import '../Controller/Coursesegment_Controller.dart';
import '../Controller/Flash_deal_controller.dart';
import '../Controller/GalleyMaterController.dart';
import '../Controller/HomeScreen_Controller.dart';
import '../Controller/SuccessStoryController.dart';
import '../Controller/Testimonial_controller.dart';
import '../Controller/Webminar_Controller.dart';
import '../Model/SuccessStoryModel.dart';
import 'Search_Screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Homescreen_Controller controller = Get.find();
  final TestimonialController testimonialController = Get.find();
  final Category_Controller category_controller = Get.find();
  final PopularCourseController popularCourse_controller = Get.find();
  final Mentor_Controller mentor_controller = Get.find();
  final GalleryMasterController galleycontroller = Get.find();
  final CourseSegmentController courseSegmentController = Get.find();
  final FlashBannerController flashdealcontroller = Get.find();
  final SuccessStoryController successStoryController = Get.find();
  final WebinarController webinarController = Get.find();
  final String baseUrl = "https://api.auratechacademy.com/";
  final List<String> slideImages = [
    "assets/images/50%off.jpg",
    "assets/images/50%3d.jpg",
    "assets/images/50%biscuit.jpg",
  ];

  int _currentIndex = 0;
  final CarouselSliderController _carouselController =
      CarouselSliderController();

  final skills = <SkillItem>[
    SkillItem(icon: Icons.science, label: 'AI & Machine Learning'),
    SkillItem(icon: Icons.data_thresholding, label: 'Data Science & Analytics'),
    SkillItem(icon: Icons.memory, label: 'Generative AI'),
    SkillItem(icon: Icons.cases_outlined, label: 'Management'),
    SkillItem(icon: Icons.computer, label: 'Software & Tech'),
    SkillItem(icon: Icons.security, label: 'Cyber Security'),
    SkillItem(icon: Icons.cloud_queue, label: 'Cloud Computing'),
    SkillItem(icon: Icons.design_services, label: 'Design'),
  ];

  final List<Map<String, dynamic>> _stats = [
    {'number': '10K+', 'label': 'Students Enrolled', 'icon': Icons.school},
    {'number': '50+', 'label': 'Expert Mentors', 'icon': Icons.people},
    {'number': '100+', 'label': 'Courses', 'icon': Icons.menu_book},
    {'number': '95%', 'label': 'Success Rate', 'icon': Icons.trending_up},
  ];

  final List<Map<String, dynamic>> _features = [
    {
      'icon': Icons.live_tv_rounded,
      'title': 'live_classes'.tr,
      'subtitle': 'Interactive live sessions with mentors'
    },
    {
      'icon': Icons.assignment_turned_in_rounded,
      'title': 'assignments'.tr,
      'subtitle': 'Regular practice assignments'
    },
    {
      'icon': Icons.workspace_premium_rounded,
      'title': 'cirtifications'.tr,
      'subtitle': 'Industry recognized certificates'
    },
    {
      'icon': Icons.support_agent_rounded,
      'title': '24/7_support'.tr,
      'subtitle': 'Always available for help'
    },
  ];

  final List<IconData> itSectorIcons = [
    Icons.computer,
    Icons.code,
    Icons.biotech_rounded,
    Icons.security,
  ];

  DateTime? _parseDateTime(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return DateTime.parse(raw).toLocal(); // backend se Z aarha hai -> local
    } catch (_) {
      return null;
    }
  }

  String _formatDate(DateTime? dt) {
    if (dt == null) return "";
    return DateFormat("dd MMM yyyy").format(dt); // e.g. 22 Aug 2025
  }

  String _formatTime(DateTime? dt) {
    if (dt == null) return "";
    return DateFormat("hh:mm a").format(dt) + " IST"; // 06:00 PM IST
  }

  String _buildImageUrl(String? path) {
    if (path == null || path.isEmpty) {
      return "assets/images/auratech1.jpg"; // fallback local asset
    }
    if (path.startsWith("http")) return path;
    return "https://api.auratechacademy.com$path";
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isTablets = MediaQuery.of(context).size.shortestSide >= 600;
    final isTablet = size.width > 600;
    final screenWidth = size.width;
    final screenHeight = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Padding(
                padding: EdgeInsets.only(
                  top: isTablet ? 24 : 16,
                  left: isTablet ? 24 : 16,
                  right: isTablet ? 24 : 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Hi ${StorageService.getData("Login Email") ?? StorageService.getData("email") ?? "User"}",
                          style: TextStyle(
                            fontSize: isTablet ? 18 : 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 12 : 8),
                    Text(
                      "like_to_learn".tr,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 24 : 16),
                    TextField(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => SearchScreen()),
                      ),
                      decoration: InputDecoration(
                        hintText: "find_course_here".tr,
                        hintStyle: TextStyle(fontSize: isTablet ? 16 : 14),
                        suffixIcon: Icon(
                          Icons.search,
                          color: AppColors.primary,
                          size: isTablet ? 28 : 24,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              const BorderSide(width: 0.5, color: Colors.grey),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                              BorderSide(width: 1.5, color: AppColors.primary),
                        ),
                      ),
                      style: TextStyle(fontSize: isTablet ? 16 : 14),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.only(
                    left: isTablet ? 24 : 14,
                    bottom: isTablet ? 24 : 16,
                    right: isTablet ? 24 : 14,
                    top: isTablet ? 0 : 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isTablet ? 24 : 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "categories".tr,
                          style: TextStyle(
                            fontSize: isTablet ? 20 : 18,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => CategoryScreen()),
                          ),
                          child: Text(
                            "see_all".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    SizedBox(
                      height: isTablet ? 48 : 40,
                      child: Obx(() => ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: category_controller.categoryList.length,
                            itemBuilder: (context, index) {
                              final cat =
                                  category_controller.categoryList[index];
                              return Obx(() => Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: ChoiceChip(
                                      checkmarkColor: AppColors.background,
                                      side:
                                          BorderSide(color: AppColors.primary),
                                      chipAnimationStyle: ChipAnimationStyle(
                                        enableAnimation: AnimationStyle(
                                            curve: Curves.easeInOut),
                                      ),
                                      label: Text(
                                        cat.categoryName ?? "Unknown",
                                        style: TextStyle(
                                          fontSize: isTablet ? 16 : 14,
                                          color: popularCourse_controller
                                                      .selectedCategory.value ==
                                                  cat.categoryName
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                      selected: popularCourse_controller
                                              .selectedCategory.value ==
                                          cat.categoryName,
                                      onSelected: (_) {
                                        popularCourse_controller
                                            .HomefilterCorse(
                                                cat.categoryName ?? "");
                                      },
                                      selectedColor: AppColors.primary,
                                      backgroundColor: Colors.blueGrey.shade50,
                                    ),
                                  ));
                            },
                          )),
                    ),
                  ],
                ),
              ),

              Column(
                children: [
                  Obx(() {
                    if (flashdealcontroller.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (flashdealcontroller.banners.isEmpty) {
                      return const Center(
                        child: Text("No flash deals available"),
                      );
                    }

                    return Column(
                      children: [
                        CarouselSlider.builder(
                          carouselController: _carouselController,
                          itemCount: flashdealcontroller.banners.length,
                          itemBuilder: (context, index, realIndex) {
                            final banner = flashdealcontroller.banners[index];

                            // Backend image (convert relative → full URL)
                            final String imgUrl =
                                "https://api.auratechacademy.com${banner.img ?? ''}";

                            return ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(screenWidth * 0.025),
                              child: Container(
                                width: screenWidth,
                                height: screenHeight * 0.27,
                                margin: EdgeInsets.symmetric(
                                    horizontal: screenWidth * 0.02),
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(screenWidth * 0.03),
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF03C2),
                                      Color(0xFF0189FF)
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(imgUrl),
                                    fit: BoxFit.cover,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.15),
                                      blurRadius: screenWidth * 0.025,
                                      spreadRadius: 1,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Stack(
                                  children: [
                                    // Dark overlay
                                    Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.03),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.black.withOpacity(0.25),
                                            Colors.black.withOpacity(0.65),
                                          ],
                                        ),
                                      ),
                                    ),

                                    // KEY 1 & KEY 2 TAGS
                                    Positioned(
                                      top: screenHeight * 0.02,
                                      left: screenWidth * 0.025,
                                      child: Row(
                                        children: [
                                          TagWidget(
                                            label: banner.key1 ?? "",
                                            bgColor: Colors.redAccent,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                          SizedBox(width: screenWidth * 0.02),
                                          TagWidget(
                                            label: banner.key2 ?? "",
                                            bgColor: AppColors.primary,
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ],
                                      ),
                                    ),

                                    // KEY 3 (Lifetime Access or API key_3)
                                    Positioned(
                                      top: screenHeight * 0.02,
                                      right: screenWidth * 0.025,
                                      child: TagWidget(
                                        label: banner.key3 ?? "",
                                        bgColor: Colors.green,
                                        fontSize: screenWidth * 0.03,
                                      ),
                                    ),

                                    // COURSE / BANNER NAME
                                    Positioned(
                                      bottom: screenHeight * 0.07,
                                      left: screenWidth * 0.025,
                                      right: screenWidth * 0.25,
                                      child: Text(
                                        banner.name ?? "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isTablet ? 16 : 14,
                                          fontWeight: FontWeight.w600,
                                          height: 1.2,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),

                                    // CTA BUTTON
                                    Positioned(
                                      bottom: screenHeight * 0.05,
                                      right: screenWidth * 0.04,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          /// On Tap Action (payment / enroll)
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          padding: EdgeInsets.symmetric(
                                            horizontal: screenWidth * 0.035,
                                            vertical: screenHeight * 0.008,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                screenWidth * 0.045),
                                          ),
                                        ),
                                        child: Text(
                                          banner.buttonText ?? "Enroll Now",
                                          style: TextStyle(
                                            fontSize: isTablet ? 14 : 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),

                                    // CONTACT DETAILS
                                    Positioned(
                                      bottom: screenHeight * 0.015,
                                      left: screenWidth * 0.025,
                                      child: Row(
                                        children: [
                                          Icon(Icons.phone,
                                              color: Colors.white,
                                              size: isTablet ? 18 : 14),
                                          SizedBox(width: screenWidth * 0.015),
                                          Text(
                                            "+91${banner.phoneNumber ?? ""}",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isTablet ? 12 : 10,
                                            ),
                                          ),
                                          SizedBox(width: screenWidth * 0.03),
                                          Icon(Icons.email_outlined,
                                              color: Colors.white,
                                              size: isTablet ? 18 : 14),
                                          SizedBox(width: screenWidth * 0.015),
                                          Text(
                                            banner.email ?? "",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: isTablet ? 12 : 10,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                          options: CarouselOptions(
                            height: screenHeight * 0.27,
                            viewportFraction: 1.0,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) {
                              setState(() => _currentIndex = index);
                            },
                          ),
                        ),

                        // INDICATOR DOTS FROM API LIST
                        SizedBox(height: screenHeight * 0.01),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: flashdealcontroller.banners
                              .asMap()
                              .entries
                              .map((entry) {
                            return GestureDetector(
                              onTap: () =>
                                  _carouselController.animateToPage(entry.key),
                              child: Container(
                                width: _currentIndex == entry.key ? 15 : 10,
                                height: 10,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _currentIndex == entry.key
                                      ? Colors.blueAccent
                                      : Colors.grey,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ],
                    );
                  }),
                ],
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: isTablet ? 32 : 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "popular_courses".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PopularCoursesScreen(
                                courses: popularCourse_controller.courseList,
                              ),
                            ),
                          ),
                          child: Text(
                            "see_all".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.primary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 20),
                    _buildCourseTabs(isTablet),
                    SizedBox(height: isTablet ? 16 : 20),
                    Obx(() {
                      if (popularCourse_controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      }
                      if (popularCourse_controller.HomeFileterCourse.isEmpty) {
                        return Center(
                          child: Text(
                            'No courses found',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }
                      return Column(
                        children: List.generate(
                          popularCourse_controller.HomeFileterCourse.length,
                          (index) {
                            final course = popularCourse_controller
                                .HomeFileterCourse[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildCourseCardVertical(
                                coursefee: course.language ?? "N/A",
                                category: course.courseCategory?.categoryName ??
                                    'Unknown Category',
                                title: course.courseTitle ?? "Untitled Course",
                                price: course.courseRating.isNotEmpty
                                    ? course.courseRating
                                    : '0.0',
                                rating: '',
                                students: course.numberOfStudents.isNotEmpty
                                    ? course.numberOfStudents
                                    : '0',
                                imageUrl: course.courseThumbImage.isNotEmpty
                                    ? "https://api.auratechacademy.com/${course.courseThumbImage}"
                                    : '',
                                isTablet: isTablet,
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          CourseDetailScreen(course: course),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: isTablet ? 32 : 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "recommended_courses".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PopularCoursesScreen(
                                courses: popularCourse_controller.courseList,
                              ),
                            ),
                          ),
                          child: Text(
                            "see_all".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Obx(() {
                      if (popularCourse_controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      }
                      if (popularCourse_controller.HomeFileterCourse.isEmpty) {
                        return Center(
                          child: Text(
                            'No courses found',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        height: isTablet ? 240 : 200,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount:
                              popularCourse_controller.HomeFileterCourse.length,
                          itemBuilder: (context, index) {
                            final course = popularCourse_controller
                                .HomeFileterCourse[index];
                            return _buildCourseCard(
                              course.courseCategory?.categoryName ??
                                  'Unknown Category',
                              'Language:- ${course.language ?? "N/A"}',
                              course.courseRating.isNotEmpty
                                  ? course.courseRating
                                  : '0.0',
                              course.numberOfStudents.isNotEmpty
                                  ? "Enrolled Student:- ${course.numberOfStudents}"
                                  : '0',
                              course.courseThumbImage.isNotEmpty
                                  ? "https://api.auratechacademy.com/${course.courseThumbImage}"
                                  : '',
                              isTablet,
                              () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        CourseDetailScreen(course: course),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
              _buildBrowseByDomainSection(isTablet),
              _buildUpcomingWebinarsSection(isTablet),
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //     vertical: isTablet ? 32 : 10,
              //   ),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       // 🔹 Header Row
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 16.0),
              //         child: Row(
              //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //           children: [
              //             Expanded(
              //               child: Text(
              //                 "upcoming_webinars".tr,
              //                 style: TextStyle(
              //                   fontSize: isTablet ? 20 : 18,
              //                   fontWeight: FontWeight.bold,
              //                   color: AppColors.textPrimary,
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //             InkWell(
              //               onTap: () => Navigator.push(
              //                 context,
              //                 MaterialPageRoute(
              //                   builder: (_) => TopMentorsScreen(
              //                     mentors: mentor_controller.mentorList,
              //                   ),
              //                 ),
              //               ),
              //               child: Text(
              //                 "see_all".tr,
              //                 style: TextStyle(
              //                   fontSize: isTablet ? 16 : 14,
              //                   color: AppColors.primary,
              //                   fontWeight: FontWeight.w600,
              //                   overflow: TextOverflow.ellipsis,
              //                 ),
              //                 maxLines: 1,
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //
              //       const SizedBox(height: 10),
              //
              //       LayoutBuilder(
              //         builder: (context, constraints) {
              //           final screenWidth = constraints.maxWidth;
              //           final screenHeight = MediaQuery.of(context).size.height;
              //
              //           final cardHeight =
              //               screenHeight * (isTablet ? 0.40 : 0.45);
              //           final cardWidth =
              //               screenWidth * (isTablet ? 0.55 : 0.99);
              //
              //           return SizedBox(
              //             height: cardHeight,
              //             child: ListView.separated(
              //               scrollDirection: Axis.horizontal,
              //               shrinkWrap: true,
              //               physics: const BouncingScrollPhysics(),
              //               itemCount: 5,
              //               separatorBuilder: (_, __) =>
              //                   const SizedBox(width: 12),
              //               itemBuilder: (context, index) {
              //                 return SizedBox(
              //                   width: cardWidth,
              //                   child: WebinarCardPro(
              //                     title:
              //                         "The Power of Large Language Models: How They Work and Why They Matter",
              //                     date: "22 August 2025",
              //                     time: "06:00 PM IST",
              //                     speaker: "Gaurav Dadhich",
              //                     role: "Founder, Sona Sharma",
              //                     bannerAsset: "assets/images/50%3d.jpg",
              //                     speakerAvatar:
              //                         "https://images.unsplash.com/photo-1533901567451-7a6e68d6cd8f?w=500&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8Mnx8Zm91bmRlcnxlbnwwfHwwfHx8MA%3D%3D",
              //                     isLive: true,
              //                     isUpcoming: true,
              //                     onTap: () {},
              //                     onRegister: () {},
              //                   ),
              //                 );
              //               },
              //             ),
              //           );
              //         },
              //       ),
              //     ],
              //   ),
              // ),

              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: isTablet ? 32 : 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "top_mentors".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ),
                        InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TopMentorsScreen(
                                mentors: mentor_controller.mentorList,
                              ),
                            ),
                          ),
                          child: Text(
                            "see_all".tr,
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              color: AppColors.primary,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Obx(() {
                      if (mentor_controller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      }
                      if (mentor_controller.mentorList.isEmpty) {
                        return Center(
                          child: Text(
                            'No mentors found',
                            style: TextStyle(
                              fontSize: isTablet ? 16 : 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey[600],
                            ),
                          ),
                        );
                      }
                      return SizedBox(
                        height: isTablet ? 120 : 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          physics: const BouncingScrollPhysics(),
                          itemCount: mentor_controller.mentorList.length,
                          itemBuilder: (context, index) {
                            final mentor = mentor_controller.mentorList[index];
                            final imageUrl = mentor.image.isNotEmpty
                                ? "https://api.auratechacademy.com/${mentor.image}"
                                : "";
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MentorDetailScreen(mentor: mentor),
                                  ),
                                );
                              },
                              child: _buildMentorCircle(
                                mentor.name ?? "Unknown Mentor",
                                imageUrl,
                                isTablet,
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),

              // Testimonials Section
              // Padding(
              //   padding: EdgeInsets.symmetric(
              //       horizontal: isTablet ? 24 : 16,
              //       vertical: isTablet ? 32 : 24),
              //   child: Column(
              //     crossAxisAlignment: CrossAxisAlignment.start,
              //     children: [
              //       Text(
              //         "Our Testimonials",
              //         style: TextStyle(
              //           fontSize: isTablet ? 20 : 18,
              //           fontWeight: FontWeight.bold,
              //           color: AppColors.textPrimary,
              //         ),
              //       ),
              //       SizedBox(height: isTablet ? 16 : 12),
              //       Obx(() {
              //         if (testimonialController.isLoading.value) {
              //           return const Center(
              //             child: CircularProgressIndicator(
              //               valueColor:
              //                   AlwaysStoppedAnimation<Color>(Colors.blue),
              //             ),
              //           );
              //         }
              //         if (testimonialController.testimonials.isEmpty) {
              //           return Text(
              //             "No testimonials available",
              //             style: TextStyle(
              //               fontSize: isTablet ? 16 : 14,
              //               fontWeight: FontWeight.w500,
              //               color: Colors.grey[600],
              //             ),
              //           );
              //         }
              //         return CarouselSlider(
              //           options: CarouselOptions(
              //             height: isTablet ? 200 : 165,
              //             autoPlay: true,
              //             enlargeCenterPage: true,
              //             viewportFraction: isTablet ? 0.7 : 0.85,
              //             autoPlayCurve: Curves.easeInOut,
              //           ),
              //           items: testimonialController.testimonials
              //               .map((testimonial) {
              //             final avatarUrl = testimonial.avatar.isNotEmpty
              //                 ? "https://api.auratechacademy.com/${testimonial.avatar}"
              //                 : "https://api.auratechacademy.com/media/testimonial/testi_2_1_jrHSv5h.jpg";
              //             return Container(
              //               margin: const EdgeInsets.symmetric(horizontal: 4),
              //               padding: EdgeInsets.all(isTablet ? 20 : 16),
              //               decoration: BoxDecoration(
              //                 color: Colors.blueAccent,
              //                 borderRadius: BorderRadius.circular(15),
              //                 boxShadow: [
              //                   BoxShadow(
              //                     color: Colors.black.withOpacity(0.1),
              //                     blurRadius: 8,
              //                     offset: const Offset(0, 4),
              //                   ),
              //                 ],
              //               ),
              //               child: Column(
              //                 mainAxisAlignment: MainAxisAlignment.center,
              //                 crossAxisAlignment: CrossAxisAlignment.start,
              //                 children: [
              //                   Row(
              //                     mainAxisSize: MainAxisSize.min,
              //                     children: List.generate(5, (index) {
              //                       return const Icon(Icons.star,
              //                           color: Colors.amber, size: 18);
              //                     }),
              //                   ),
              //                   SizedBox(height: isTablet ? 12 : 10),
              //                   Expanded(
              //                     child: Text(
              //                       '"${testimonial.text ?? "No testimonial text"}"',
              //                       maxLines: 3,
              //                       overflow: TextOverflow.ellipsis,
              //                       style: TextStyle(
              //                         color: Colors.white,
              //                         fontSize: isTablet ? 15 : 13,
              //                         fontStyle: FontStyle.italic,
              //                       ),
              //                     ),
              //                   ),
              //                   SizedBox(height: isTablet ? 12 : 10),
              //                   Row(
              //                     children: [
              //                       CircleAvatar(
              //                         radius: isTablet ? 22 : 18,
              //                         backgroundImage:
              //                             CachedNetworkImageProvider(avatarUrl),
              //                       ),
              //                       SizedBox(width: isTablet ? 12 : 10),
              //                       Column(
              //                         crossAxisAlignment:
              //                             CrossAxisAlignment.start,
              //                         children: [
              //                           Text(
              //                             testimonial.name ?? "Anonymous",
              //                             style: TextStyle(
              //                               color: AppColors.background,
              //                               fontWeight: FontWeight.bold,
              //                               fontSize: isTablet ? 16 : 14,
              //                             ),
              //                           ),
              //                           Text(
              //                             testimonial.designation ??
              //                                 "No designation",
              //                             style: TextStyle(
              //                               color: Colors.white70,
              //                               fontSize: isTablet ? 14 : 12,
              //                             ),
              //                           ),
              //                         ],
              //                       ),
              //                     ],
              //                   ),
              //                 ],
              //               ),
              //             );
              //           }).toList(),
              //         );
              //       }),
              //     ],
              //   ),
              // ),
              // Testimonials Section
              ModernSkillsSection(items: skills),

              ///new section ko

              _buildFeaturesSection(isTablet),
              _buildStatsSection(isTablet),
              _buildTrendingTechSection(isTablet),
              _buildSuccessStoriesSection(isTablet),

              // Gallery Section
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: isTablet ? 24 : 16,
                    vertical: isTablet ? 32 : 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "our_galery".tr,
                      style: TextStyle(
                        fontSize: isTablet ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: isTablet ? 16 : 12),
                    Obx(() {
                      if (galleycontroller.isLoading.value) {
                        return const Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.blue),
                          ),
                        );
                      }
                      if (galleycontroller.errorMessage.isNotEmpty) {
                        return Center(
                          child: Column(
                            children: [
                              Text(galleycontroller.errorMessage.value),
                              TextButton(
                                onPressed: () {
                                  galleycontroller.getGalleryItems();
                                },
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        );
                      }
                      final allItems = galleycontroller.imageList;
                      const baseUrl = "https://api.auratechacademy.com/";
                      if (allItems.isEmpty) {
                        return const Center(
                            child: Text("No images available."));
                      }
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CarouselSlider.builder(
                            itemCount: allItems.length,
                            carouselController: _carouselController,
                            itemBuilder: (context, index, realIndex) {
                              final item = allItems[index];
                              final imageUrl = item.galleryImg?.isNotEmpty ==
                                      true
                                  ? "$baseUrl${item.galleryImg}"
                                  : "https://images.pexels.com/photos/256262/pexels-photo-256262.jpeg";
                              return GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (_) {
                                      final dialogCarouselController =
                                          CarouselSliderController();
                                      return Dialog(
                                        insetPadding: const EdgeInsets.all(10),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: StatefulBuilder(
                                          builder: (context, setState) {
                                            return Container(
                                              height: screenHeight * 0.70,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 16),
                                              decoration: BoxDecoration(
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color(0x00ff2cdf),
                                                    Color(0xFF2FEB12)
                                                  ],
                                                  begin: Alignment.topLeft,
                                                  end: Alignment.bottomRight,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                children: [
                                                  CarouselSlider.builder(
                                                    itemCount: allItems.length,
                                                    carouselController:
                                                        dialogCarouselController,
                                                    itemBuilder: (context,
                                                        dialogIndex,
                                                        realIndex) {
                                                      final dialogImgUrl = (allItems[
                                                                          dialogIndex]
                                                                      .galleryImg !=
                                                                  null &&
                                                              allItems[
                                                                      dialogIndex]
                                                                  .galleryImg!
                                                                  .isNotEmpty)
                                                          ? "$baseUrl${allItems[dialogIndex].galleryImg}"
                                                          : "https://images.pexels.com/photos/256262/pexels-photo-256262.jpeg";
                                                      return ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20),
                                                        child: Image.network(
                                                          dialogImgUrl,
                                                          fit: BoxFit.cover,
                                                          width:
                                                              double.infinity,
                                                          errorBuilder: (context,
                                                                  error,
                                                                  stackTrace) =>
                                                              const Icon(Icons
                                                                  .broken_image),
                                                        ),
                                                      );
                                                    },
                                                    options: CarouselOptions(
                                                      height:
                                                          screenHeight * 0.6,
                                                      enlargeCenterPage: true,
                                                      autoPlay: true,
                                                      viewportFraction: 0.8,
                                                      onPageChanged:
                                                          (index, reason) {
                                                        setState(() {
                                                          _currentIndex = index;
                                                        });
                                                      },
                                                    ),
                                                  ),
                                                  const SizedBox(height: 16),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: allItems
                                                        .asMap()
                                                        .entries
                                                        .map((entry) {
                                                      return GestureDetector(
                                                        onTap: () =>
                                                            dialogCarouselController
                                                                .animateToPage(
                                                                    entry.key),
                                                        child: Container(
                                                          width:
                                                              _currentIndex ==
                                                                      entry.key
                                                                  ? 15
                                                                  : 10,
                                                          height: 10,
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      4),
                                                          decoration:
                                                              BoxDecoration(
                                                            shape:
                                                                BoxShape.circle,
                                                            color: _currentIndex ==
                                                                    entry.key
                                                                ? Colors
                                                                    .blueAccent
                                                                : Colors.grey,
                                                          ),
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  );
                                },
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.network(
                                      imageUrl,
                                      fit: BoxFit.cover,
                                      width: screenWidth * 0.75,
                                      height: screenHeight * 0.22,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.broken_image),
                                    ),
                                  ),
                                ),
                              );
                            },
                            options: CarouselOptions(
                              height: screenHeight * 0.27,
                              enlargeCenterPage: true,
                              autoPlay: true,
                              viewportFraction: 0.8,
                              onPageChanged: (index, reason) {
                                setState(() {
                                  _currentIndex = index;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 15),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: allItems.asMap().entries.map((entry) {
                              return GestureDetector(
                                onTap: () => _carouselController
                                    .animateToPage(entry.key),
                                child: Container(
                                  width: _currentIndex == entry.key ? 15 : 10,
                                  height: 10,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentIndex == entry.key
                                        ? Colors.blueAccent
                                        : Colors.grey,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),

              // Bottom Padding
              _buildFooterSection(isTablet),
              SizedBox(height: isTablet ? 24 : 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBrowseByDomainSection(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Text(
              'browse_by_domain'.tr,
              style: TextStyle(
                fontSize: isTablet ? 28 : 24,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
          ),

          Obx(() {
            if (courseSegmentController.isLoading.value) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              );
            } else if (courseSegmentController.segments.isEmpty) {
              return Center(
                child: Text(
                  'No domains available',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[600],
                  ),
                ),
              );
            }
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isTablet ? 4 : 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: courseSegmentController.segments.length,
              itemBuilder: (context, index) {
                final domain = courseSegmentController.segments[index];
                return _DomainCard(
                  domain: domain,
                  isTablet: isTablet,
                  domainIcon: itSectorIcons[index],
                );
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildUpcomingWebinarsSection(bool isTablet) {
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: isTablet ? 32 : 10,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔹 Header Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    "upcoming_webinars".tr,
                    style: TextStyle(
                      fontSize: isTablet ? 20 : 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
                InkWell(
                  onTap: () {
                    // TODO: yaha “All Webinars” screen pe le ja sakte ho
                  },
                  child: Text(
                    "see_all".tr,
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                      overflow: TextOverflow.ellipsis,
                    ),
                    maxLines: 1,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;
              final screenHeight = MediaQuery.of(context).size.height;

              final cardHeight = screenHeight * (isTablet ? 0.40 : 0.45);
              final cardWidth = screenWidth * (isTablet ? 0.55 : 0.99);

              return SizedBox(
                height: cardHeight,
                child: Obx(() {
                  // 🔄 Loading
                  if (webinarController.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  // ❌ Error
                  if (webinarController.errorMessage.isNotEmpty) {
                    return Center(
                      child: Text(
                        webinarController.errorMessage.value,
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: isTablet ? 14 : 12,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  // 😶 Empty
                  if (webinarController.webinars.isEmpty) {
                    return Center(
                      child: Text(
                        "No upcoming webinars available",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: isTablet ? 14 : 12,
                        ),
                      ),
                    );
                  }

                  final list = webinarController.webinars;

                  return ListView.separated(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final webinar = list[index];

                      final dt = _parseDateTime(webinar.dateTime);
                      final dateText = _formatDate(dt);
                      final timeText = _formatTime(dt);

                      final bannerUrl = _buildImageUrl(webinar.img);

                      final isLive =
                          (webinar.key1?.toUpperCase() == "LIVE"); // from API
                      final isUpcoming =
                          (webinar.key2?.toUpperCase() == "UPCOMING");

                      return SizedBox(
                        width: cardWidth,
                        child: WebinarCardPro(
                          title: webinar.title ?? "Auratech Webinar",
                          date: dateText,
                          time: timeText,
                          speaker: webinar.speaker ?? "Auratech Mentor",
                          role: webinar.designation ?? "Mentor",
                          bannerAsset: bannerUrl,
                          speakerAvatar:
                              null, // Agar alag speaker image aaye to yaha set karna
                          buttonText: webinar.buttonText ?? "Register Now",
                          isLive: isLive,
                          isUpcoming: isUpcoming,
                          onTap: () {
                            // TODO: webinar detail page pe le jao
                          },
                          onRegister: () {
                            // TODO: register / Razorpay / form page etc
                          },
                        ),
                      );
                    },
                  );
                }),
              );
            },
          ),
        ],
      ),
    );
  }

  // final List<Domain> domains = [
  //   Domain(
  //     title: 'Networking',
  //     icon: Icons.lan_outlined,
  //     backgroundColor: Color(0xFF6366F1), // Indigo
  //   ),
  //   Domain(
  //     title: 'Database Management',
  //     icon: Icons.storage_outlined,
  //     backgroundColor: Color(0xFFEF4444), // Red
  //   ),
  //   Domain(
  //     title: 'Software Testing',
  //     icon: Icons.bug_report_outlined,
  //     backgroundColor: Color(0xFF3B82F6), // Blue
  //   ),
  //   Domain(
  //     title: 'Project Management',
  //     icon: Icons.assignment_outlined,
  //     backgroundColor: Color(0xFF8B5CF6), // Purple
  //   ),
  //   Domain(
  //     title: 'Business Analytics',
  //     icon: Icons.bar_chart_outlined,
  //     backgroundColor: Color(0xFFEC4899), // Pink
  //   ),
  //   Domain(
  //     title: 'IT Support',
  //     icon: Icons.support_agent_outlined,
  //     backgroundColor: Color(0xFF06B6D4), // Cyan
  //   ),
  // ];
  Widget _buildStatsSection(bool isTablet) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: isTablet ? 40 : 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primary.withOpacity(0.05),
            AppColors.primary.withOpacity(0.02),
          ],
        ),
        borderRadius: BorderRadius.circular(25),
      ),
      margin:
          EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: 20),
      child: Column(
        children: [
          Text(
            "why_choose_us".tr,
            style: TextStyle(
              fontSize: isTablet ? 24 : 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            "join_our_growing_community".tr,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: isTablet ? 30 : 20),

          // Stats Grid
          Wrap(
            spacing: isTablet ? 40 : 20,
            runSpacing: isTablet ? 30 : 20,
            alignment: WrapAlignment.spaceEvenly,
            children: _stats.map((stat) {
              return _buildStatItem(
                  stat['number'], stat['label'], stat['icon'], isTablet);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
      String number, String label, IconData icon, bool isTablet) {
    return Container(
      width: isTablet ? 150 : 130,
      padding: EdgeInsets.all(isTablet ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryDark),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child:
                Icon(icon, color: AppColors.primary, size: isTablet ? 24 : 20),
          ),
          SizedBox(height: 12),
          Text(
            number,
            style: TextStyle(
              fontSize: isTablet ? 28 : 24,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isTablet ? 14 : 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(bool isTablet) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "what_make_different".tr,
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 16,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "premium_features".tr,
                  style: TextStyle(
                    fontSize: isTablet ? 14 : 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 4 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
            itemCount: _features.length,
            itemBuilder: (context, index) {
              final feature = _features[index];
              return _buildFeatureCard(feature, isTablet);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(Map<String, dynamic> feature, bool isTablet) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: feature['onTap'],
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 20,
                offset: Offset(0, 5),
              ),
            ],
            border: Border.all(
              color: AppColors.primaryDark,
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withOpacity(0.9),
                      AppColors.primary.withOpacity(0.7),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  feature['icon'],
                  color: Colors.white,
                  size: isTablet ? 24 : 20,
                ),
              ),
              SizedBox(height: 16),
              Text(
                feature['title'],
                style: TextStyle(
                  fontSize: isTablet ? 16 : 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 6),
              Text(
                feature['subtitle'],
                style: TextStyle(
                  fontSize: isTablet ? 12 : 11,
                  color: AppColors.textSecondary,
                  height: 1.4,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCourseTabs(bool isTablet) {
    final controller = Get.find<Homescreen_Controller>();

    return SizedBox(
      height: isTablet ? 44 : 36,
      child: Obx(() {
        final totalTabs = 1 + popularCourse_controller.courseList.length;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: totalTabs,
          itemBuilder: (context, index) {
            final isSelected = index == controller.selectedTabIndex.value;
            String categoryName;
            if (index == 0) {
              categoryName = "All";
            } else {
              final course = popularCourse_controller.courseList[index - 1];
              categoryName = course.courseCategory?.categoryName ?? "Unknown";
            }
            return GestureDetector(
              onTap: () {
                controller.selectTab(index);
                if (index == 0) {
                  popularCourse_controller.HomefilterCorse('');
                } else {
                  popularCourse_controller.HomefilterCorse(categoryName);
                }
              },
              child: Container(
                margin: const EdgeInsets.only(right: 12),
                padding: EdgeInsets.symmetric(
                  horizontal: isTablet ? 20 : 16,
                  vertical: isTablet ? 10 : 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.primary),
                ),
                child: Text(
                  categoryName.isNotEmpty ? categoryName : 'Unknown Category',
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: isSelected ? Colors.white : Colors.black,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }

  Widget _buildCourseCardVertical({
    required String category,
    required String title,
    required String price,
    required String coursefee,
    required String rating,
    required String students,
    required String imageUrl,
    required bool isTablet,
    required VoidCallback onTap,
  }) {
    final finalImageUrl = (imageUrl.isNotEmpty)
        ? imageUrl
        : 'https://api.auratechacademy.com/media/testimonial/testi_2_1_jrHSv5h.jpg';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(12),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: finalImageUrl,
                height: isTablet ? 110 : 90,
                width: isTablet ? 110 : 90,
                fit: BoxFit.cover,
                placeholder: (context, url) => Image.asset(
                  'assets/images/congratulationpic.png',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) => Image.asset(
                  'assets/images/congratulationpic.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: isTablet ? 13 : 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: isTablet ? 16 : 14,
                    ),
                  ),
                  SizedBox(height: 2),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text(
                        rating,
                        style: const TextStyle(color: AppColors.textSecondary),
                      ),
                      SizedBox(width: 12),
                      const Icon(Icons.group,
                          size: 16, color: AppColors.primary),
                      SizedBox(width: 4),
                      Text(
                        students,
                        style: TextStyle(
                          fontSize: isTablet ? 13 : 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 2),
                  Text(
                    // "Fee: \u20B9$coursefee",
                    "Language:- $coursefee",
                    style: TextStyle(
                      fontSize: isTablet ? 13 : 12,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isTablet ? 14 : 13,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 10),
                const Icon(Icons.bookmark_border,
                    size: 20, color: AppColors.primary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCourseCard(String title, String price, String rating,
      String students, String imageUrl, bool isTablet, VoidCallback onTap) {
    final finalImageUrl = (imageUrl.isNotEmpty)
        ? imageUrl
        : 'https://api.auratechacademy.com/media/testimonial/testi_2_1_jrHSv5h.jpg';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: isTablet ? 240 : 250,
          margin: const EdgeInsets.only(right: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 6)],
          ),
          padding: EdgeInsets.all(isTablet ? 12 : 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CachedNetworkImage(
                  imageUrl: finalImageUrl,
                  height: isTablet ? 100 : 85,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Image.asset(
                    'assets/images/congratulationpic.png',
                    fit: BoxFit.cover,
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/congratulationpic.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: isTablet ? 10 : 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: isTablet ? 6 : 6),
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.orange,
                      ),
                    ),
                    SizedBox(height: isTablet ? 6 : 6),
                    Row(
                      children: [
                        Icon(Icons.star,
                            color: Colors.amber, size: isTablet ? 18 : 16),
                        SizedBox(width: isTablet ? 6 : 4),
                        Text(
                          rating,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          students,
                          style: TextStyle(
                            fontSize: isTablet ? 14 : 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMentorCircle(String name, String imageUrl, bool isTablet) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: Column(
        children: [
          CircleAvatar(
            radius: isTablet ? 42 : 36,
            backgroundColor: Colors.black12,
            backgroundImage: imageUrl.isNotEmpty
                ? CachedNetworkImageProvider(imageUrl)
                : null,
            child: imageUrl.isEmpty
                ? Icon(Icons.person, size: isTablet ? 42 : 36)
                : null,
          ),
          SizedBox(height: isTablet ? 6 : 4),
          Text(
            name,
            style: TextStyle(fontSize: isTablet ? 14 : 12),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  // Widget _buildSuccessStoriesSection(bool isTablet) {
  //   final successStories = [
  //     {
  //       'name': 'Rahul Sharma',
  //       'role': 'Flutter Developer',
  //       'company': 'Google',
  //       'image':
  //           'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=150',
  //       'story':
  //           'From zero to Flutter expert in 6 months. Landed my dream job at Google!',
  //       'salary': '₹18 LPA',
  //       'course': 'Flutter Masterclass'
  //     },
  //     {
  //       'name': 'Priya Patel',
  //       'role': 'Data Scientist',
  //       'company': 'Microsoft',
  //       'image':
  //           'https://images.unsplash.com/photo-1494790108755-2616b612b786?w=150',
  //       'story':
  //           'AuraTech helped me transition from mechanical engineering to data science.',
  //       'salary': '₹22 LPA',
  //       'course': 'Data Science Pro'
  //     },
  //     {
  //       'name': 'Amit Kumar',
  //       'role': 'Full Stack Developer',
  //       'company': 'Amazon',
  //       'image':
  //           'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?w=150',
  //       'story':
  //           'The project-based learning approach gave me real-world experience.',
  //       'salary': '₹20 LPA',
  //       'course': 'Full Stack Development'
  //     },
  //   ];
  //
  //   return Padding(
  //     padding:
  //         EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: 20),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: [
  //             Expanded(
  //               child: Text(
  //                 "success_stories".tr,
  //                 style: TextStyle(
  //                   fontSize: isTablet ? 22 : 18,
  //                   fontWeight: FontWeight.bold,
  //                   color: AppColors.textPrimary,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 maxLines: 1,
  //               ),
  //             ),
  //             InkWell(
  //               onTap: () {
  //                },
  //               child: Row(
  //                 mainAxisSize: MainAxisSize
  //                     .min, // 👈 important: shrink-wraps the right row
  //                 children: [
  //                   Text(
  //                     "see_all".tr,
  //                     style: TextStyle(
  //                       fontSize: isTablet ? 16 : 14,
  //                       color: AppColors.primary,
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                   SizedBox(width: 4),
  //                   Icon(
  //                     Icons.arrow_forward_ios_rounded,
  //                     size: isTablet ? 16 : 14,
  //                     color: AppColors.primary,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //         SizedBox(height: isTablet ? 16 : 12),
  //         SizedBox(
  //           height: isTablet ? 280 : 250,
  //           child: ListView.builder(
  //             scrollDirection: Axis.horizontal,
  //             itemCount: successStoryController.stories.length,
  //             itemBuilder: (context, index) {
  //               final story = successStories[index];
  //               return Padding(
  //                 padding: const EdgeInsets.only(bottom: 8.0),
  //                 child: _buildSuccessStoryCard(story, isTablet),
  //               );
  //             },
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildSuccessStoryCard(Map<String, dynamic> story, bool isTablet) {
  //   return Container(
  //     width: isTablet ? 300 : 280,
  //     margin: EdgeInsets.only(right: 16),
  //     decoration: BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.circular(21),
  //         border: Border.all(color: AppColors.primary, width: 1)),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         // Header with image and basic info
  //         Container(
  //           padding: EdgeInsets.all(isTablet ? 20 : 16),
  //           decoration: BoxDecoration(
  //             gradient: LinearGradient(
  //               colors: [
  //                 AppColors.primary.withOpacity(0.8),
  //                 AppColors.primary.withOpacity(0.6),
  //               ],
  //               begin: Alignment.topLeft,
  //               end: Alignment.bottomRight,
  //             ),
  //             borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(20),
  //               topRight: Radius.circular(20),
  //             ),
  //           ),
  //           child: Row(
  //             children: [
  //               CircleAvatar(
  //                 radius: isTablet ? 30 : 25,
  //                 backgroundImage: NetworkImage(story['image']),
  //               ),
  //               SizedBox(width: 12),
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Text(
  //                       story['name'],
  //                       style: TextStyle(
  //                         fontSize: isTablet ? 18 : 16,
  //                         fontWeight: FontWeight.bold,
  //                         color: Colors.white,
  //                       ),
  //                     ),
  //                     SizedBox(height: 4),
  //                     Text(
  //                       '${story['role']} at ${story['company']}',
  //                       style: TextStyle(
  //                         fontSize: isTablet ? 14 : 12,
  //                         color: Colors.white.withOpacity(0.9),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               Container(
  //                 padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white.withOpacity(0.2),
  //                   borderRadius: BorderRadius.circular(12),
  //                 ),
  //                 child: Text(
  //                   story['salary'],
  //                   style: TextStyle(
  //                     fontSize: isTablet ? 14 : 12,
  //                     color: Colors.white,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         // Story content
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.all(isTablet ? 20 : 16),
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Text(
  //                   '"${story['story']}"',
  //                   style: TextStyle(
  //                     fontSize: isTablet ? 15 : 13,
  //                     color: AppColors.textSecondary,
  //                     fontStyle: FontStyle.italic,
  //                     height: 1.4,
  //                   ),
  //                   maxLines: 3,
  //                   overflow: TextOverflow.ellipsis,
  //                 ),
  //                 Spacer(),
  //                 Container(
  //                   padding: EdgeInsets.all(12),
  //                   decoration: BoxDecoration(
  //                     color: AppColors.primary.withOpacity(0.1),
  //                     borderRadius: BorderRadius.circular(12),
  //                   ),
  //                   child: Row(
  //                     children: [
  //                       Icon(Icons.school_rounded,
  //                           color: AppColors.primary, size: isTablet ? 20 : 18),
  //                       SizedBox(width: 8),
  //                       Expanded(
  //                         child: Text(
  //                           'Completed: ${story['course']}',
  //                           style: TextStyle(
  //                             fontSize: isTablet ? 14 : 12,
  //                             color: AppColors.primary,
  //                             fontWeight: FontWeight.w600,
  //                           ),
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
  Widget _buildSuccessStoriesSection(bool isTablet) {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "success_stories".tr,
                  style: TextStyle(
                    fontSize: isTablet ? 22 : 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                    overflow: TextOverflow.ellipsis,
                  ),
                  maxLines: 1,
                ),
              ),
              InkWell(
                onTap: () {
                  // TODO: Navigate to full Success Stories screen if needed
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "see_all".tr,
                      style: TextStyle(
                        fontSize: isTablet ? 16 : 14,
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: isTablet ? 16 : 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: isTablet ? 16 : 12),

          // 🔹 Reactive list from controller
          SizedBox(
            height: isTablet ? 280 : 250,
            child: Obx(() {
              if (successStoryController.isLoading.value) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (successStoryController.errorMessage.isNotEmpty) {
                return Center(
                  child: Text(
                    successStoryController.errorMessage.value,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: isTablet ? 14 : 12,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              }

              if (successStoryController.stories.isEmpty) {
                return Center(
                  child: Text(
                    "No success stories available",
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: isTablet ? 14 : 12,
                    ),
                  ),
                );
              }

              final list = successStoryController.stories;

              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final story = list[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: _buildSuccessStoryCard(story, isTablet),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessStoryCard(SuccessStoryModel story, bool isTablet) {
    // 🔹 Safe mapping
    final name = story.name ?? 'Student';
    final placement = story.placement ?? '';
    final package = story.package ?? '';
    final description = story.description ?? '';
    final courseTitle = story.course?.title ?? 'Auratech Academy Course';

    // Placement se role & company nikalne ki light logic:
    String roleText = placement;
    String companyText = '';
    if (placement.contains(' at ')) {
      final parts = placement.split(' at ');
      roleText = parts[0];
      companyText = parts.length > 1 ? parts[1] : '';
    }

    // Profile image: Instructor ka image ya course image ya placeholder
    final String imageUrl = story.course?.courseInstructor?.image != null
        ? "https://api.auratechacademy.com${story.course!.courseInstructor!.image}"
        : (story.course?.courseImg != null
            ? "https://api.auratechacademy.com${story.course!.courseImg}"
            : "https://i.pravatar.cc/150?u=$name");

    return Container(
      width: isTablet ? 300 : 280,
      margin: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: AppColors.primary, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 🔹 Header with image + basic info
          Container(
            padding: EdgeInsets.all(isTablet ? 20 : 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withOpacity(0.8),
                  AppColors.primary.withOpacity(0.6),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: isTablet ? 30 : 25,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: TextStyle(
                          fontSize: isTablet ? 18 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        companyText.isNotEmpty
                            ? '$roleText at $companyText'
                            : roleText,
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 12,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
                if (package.isNotEmpty)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      package,
                      style: TextStyle(
                        fontSize: isTablet ? 14 : 12,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // 🔹 Story content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"$description"',
                    style: TextStyle(
                      fontSize: isTablet ? 15 : 13,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.school_rounded,
                          color: AppColors.primary,
                          size: isTablet ? 20 : 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            // yaha agar localize karna ho to 'completed_course'.tr, etc
                            'Completed: $courseTitle',
                            style: TextStyle(
                              fontSize: isTablet ? 14 : 12,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendingTechSection(bool isTablet) {
    final trendingTech = [
      {
        'name': 'flutter'.tr,
        'icon': '🎯',
        'growth': '+35%',
        'color': Colors.blue,
        'courses': 12
      },
      {
        'name': 'ai_ml'.tr,
        'icon': '🤖',
        'growth': '+42%',
        'color': Colors.green,
        'courses': 18
      },
      {
        'name': 'web3'.tr,
        'icon': '⛓️',
        'growth': '+28%',
        'color': Colors.purple,
        'courses': 8
      },
      {
        'name': 'cloud'.tr,
        'icon': '☁️',
        'growth': '+31%',
        'color': Colors.orange,
        'courses': 15
      },
      {
        'name': 'cyber_security'.tr,
        'icon': '🔒',
        'growth': '+25%',
        'color': Colors.red,
        'courses': 10
      },
      {
        'name': 'data_science'.tr,
        'icon': '📊',
        'growth': '+38%',
        'color': Colors.teal,
        'courses': 14
      },
    ];

    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: isTablet ? 24 : 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "treding_technologies".tr,
            style: TextStyle(
              fontSize: isTablet ? 22 : 18,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: isTablet ? 8 : 4),
          Text(
            "most_in_demand_skillls_in_2025".tr,
            style: TextStyle(
              fontSize: isTablet ? 16 : 14,
              color: AppColors.textSecondary,
            ),
          ),
          SizedBox(height: isTablet ? 16 : 12),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isTablet ? 3 : 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
            ),
            itemCount: trendingTech.length,
            itemBuilder: (context, index) {
              final tech = trendingTech[index];
              return _buildTechCard(tech, isTablet);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTechCard(Map<String, dynamic> tech, bool isTablet) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          // TODO: Filter courses by technology
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tech['color'].withOpacity(0.1),
                tech['color'].withOpacity(0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: tech['color'].withOpacity(0.2),
              width: 1,
            ),
          ),
          padding: EdgeInsets.all(isTablet ? 20 : 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    tech['icon'],
                    style: TextStyle(fontSize: isTablet ? 24 : 20),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: tech['color'].withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      tech['growth'],
                      style: TextStyle(
                        fontSize: isTablet ? 12 : 10,
                        color: tech['color'],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tech['name'],
                    style: TextStyle(
                      fontSize: isTablet ? 16 : 14,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 1,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '${tech['courses']} Courses',
                    style: TextStyle(
                      fontSize: isTablet ? 12 : 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterSection(bool isTablet) {
    return Container(
      width: double.infinity,
      padding:
          EdgeInsets.symmetric(vertical: 40, horizontal: isTablet ? 24 : 16),
      decoration: BoxDecoration(),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(isTablet ? 40 : 30),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
              border: Border.all(color: AppColors.primary),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 30,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "“Theory se zyada, hum practice pe believe karte hain.”",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    fontStyle: FontStyle.italic,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Text(
                  "🎉 Ready to Transform Your Career?",
                  style: TextStyle(
                    fontSize: isTablet ? 28 : 22,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  "Join 10,000+ students who have already started their journey with AuraTech Academy",
                  style: TextStyle(
                    fontSize: isTablet ? 16 : 14,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 75,
                          vertical: isTablet ? 18 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        "Explore All Courses",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 22),
                    OutlinedButton(
                      onPressed: () async {
                        await UtilKlass().openWhatsApp(
                            phone: "919460548809",
                            message:
                                "Hello, I would like to request a free consultation.");
                      },
                      style: OutlinedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: isTablet ? 32 : 80,
                          vertical: isTablet ? 18 : 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: BorderSide(color: AppColors.primary, width: 2),
                      ),
                      child: Text(
                        "Free Consultation",
                        style: TextStyle(
                          fontSize: isTablet ? 16 : 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class Domain {
//   final String title;
//   final IconData icon;
//   final Color backgroundColor;
//
//   const Domain({
//     required this.title,
//     required this.icon,
//     required this.backgroundColor,
//   });
// }

class _DomainCard extends StatelessWidget {
  final IconData domainIcon;
  final csmodel.CourseSegment domain;
  final bool isTablet;

  _DomainCard({
    required this.domain,
    required this.isTablet,
    required this.domainIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black12,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade50,
              Colors.blue.shade100,
              Colors.white,
            ],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              // Handle domain tap
              print('Tapped on ${domain.name}');
            },
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Icon Container
                  Container(
                    width: isTablet ? 50 : 40,
                    height: isTablet ? 50 : 40,
                    decoration: BoxDecoration(
                      color: Color(0xFF3B82F6),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      domainIcon,
                      color: Colors.white,
                      size: isTablet ? 24 : 20,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    domain.name.toString() ?? "Unknown",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SkillItem {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  SkillItem({required this.icon, required this.label, this.onTap});
}

class ModernSkillsSection extends StatelessWidget {
  const ModernSkillsSection({
    super.key,
    required this.items,
    this.maxContentWidth = 1200,
    this.gap = 24,
  });

  final List<SkillItem> items;

  final double maxContentWidth;
  final double gap;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    final isNarrow = w < 920;

    final content = ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxContentWidth),
      child: isNarrow
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _RightPillsGrid(items: items),
                ],
              ),
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(flex: 7, child: _RightPillsGrid(items: items)),
              ],
            ),
    );

    // Clean white page section — no extra containers/gradients.
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
      child: Center(child: content),
    );
  }
}

class _LeftTextBlock extends StatelessWidget {
  const _LeftTextBlock({
    required this.titleKicker,
    required this.title,
    required this.subtitle,
  });

  final String titleKicker;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    // Slightly smaller, tighter typography
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          titleKicker.toUpperCase(),
          style: const TextStyle(
            fontSize: 12.5,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w800,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 36, // smaller than display sizes
            height: 1.05,
            fontWeight: FontWeight.w800,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: const Text(
            // passed in via ctor; use const text style and dynamic string
            '',
            style: TextStyle(), // placeholder, overridden below
          ),
        ),
      ],
    ).applySubtitle(subtitle);
  }
}

extension _Subtitle on Column {
  Column applySubtitle(String subtitle) {
    final kids = List<Widget>.from(children);
    // Replace last ConstrainedBox child with actual text style
    kids[kids.length - 1] = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 520),
      child: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 14.5,
          height: 1.55,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: kids,
    );
  }
}

class _RightPillsGrid extends StatelessWidget {
  const _RightPillsGrid({required this.items});

  final List<SkillItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (_, c) {
        final isCompact = c.maxWidth < 520;
        final tileWidth = isCompact ? c.maxWidth : (c.maxWidth - 16) / 2;
        return Wrap(
          spacing: 16,
          runSpacing: 14,
          children: items
              .map(
                  (e) => SizedBox(width: tileWidth, child: _SkillPill(item: e)))
              .toList(),
        );
      },
    );
  }
}

class _SkillPill extends StatefulWidget {
  const _SkillPill({required this.item});
  final SkillItem item;

  @override
  State<_SkillPill> createState() => _SkillPillState();
}

class _SkillPillState extends State<_SkillPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final iconBg = AppColors.background;

    return AnimatedScale(
      scale: _hover ? 1.01 : 1.0,
      duration: const Duration(milliseconds: 120),
      child: Material(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        child: InkWell(
          onTap: widget.item.onTap,
          onHover: (v) => setState(() => _hover = v),
          borderRadius: BorderRadius.circular(14),
          splashColor: AppColors.primary.withOpacity(0.08),
          highlightColor: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: iconBg,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    widget.item.icon,
                    size: 18,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.item.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right_rounded,
                    size: 22, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
