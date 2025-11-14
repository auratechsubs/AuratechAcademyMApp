
import 'package:auratech_academy/utils/storageservice.dart';
import 'package:auratech_academy/utils/util_klass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../../constant/constant_colors.dart';
import '../../../widget/custombottombar.dart';
import '../../My_course_module/Controller/Add_To_Cart.dart';
import '../Controller/Course_review_Controller.dart';
import '../Controller/getReviewController.dart';
import '../Model/Course_Master_Model.dart';
import 'CourseDetailwith_Learning_screen.dart';

class CourseDetailScreen extends StatefulWidget {
  final CourseMaster course;
  const CourseDetailScreen({super.key, required this.course});

  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}

class _CourseDetailScreenState extends State<CourseDetailScreen>
    with SingleTickerProviderStateMixin {
  final AddToCart addToCart = Get.find();
  late TabController _tabController;
  final _reviewFormKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final getReviewController _getReviewController = Get.find();
  final PostReviewController postReviewController = Get.find();

  bool isExpanded = false;
  Future<void> getcoursereview() async {
    final userId = await StorageService.getData("User_id");

    if (userId != null && userId.toString().isNotEmpty) {
      await _getReviewController.getReview();
    } else {
      debugPrint("⚠️ User ID is null or empty. Skipping history fetch.");
      _getReviewController.errorMessage.value = "User not logged in.";
    }
  }

  @override
  void initState() {
    super.initState();
    getcoursereview();
    _tabController = TabController(length: 3, vsync: this);
   // print("API is_enroll => ${json['is_enroll']}");
    print("Model is_enroll => ${widget.course.is_enroll}");
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    String parseHtmlString(String htmlString) {
      final document = RegExp(r'<[^>]*>', multiLine: true, caseSensitive: true);
      return htmlString.replaceAll(document, '').trim();
    }

    List<String> splitCurriculumByNumbers(String htmlString) {
      final plainText = htmlString
          .replaceAll(RegExp(r'<[^>]*>'), '')
          .replaceAll('&nbsp;', ' ')
          .replaceAll('&amp;', '&')
          .replaceAll('\n', ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();

      return plainText
          .split(RegExp(r'(?=\d+\.\s)'))
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final rawCurriculum = widget.course.courseDetail?.curriculum ?? '';
    final curriculumItems = splitCurriculumByNumbers(rawCurriculum);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: AppColors.textPrimary),
        title: Text(
          'Course Details',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.bold,
            fontSize: isTablet ? 22 : 18,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: size.height * 0.02),
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    widget.course.courseThumbImage.isNotEmpty
                        ? "https://api.auratechacademy.com/${widget.course.courseThumbImage}"
                        : '',
                    height: size.height * (isTablet ? 0.25 : 0.2),
                    width: constraints.maxWidth * (isTablet ? 0.6 : 0.8),
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: size.height * (isTablet ? 0.25 : 0.2),
                      width: constraints.maxWidth * (isTablet ? 0.6 : 0.8),
                      color: Colors.grey[300],
                      alignment: Alignment.center,
                      child: const Icon(Icons.broken_image, size: 40),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(isTablet ? 24 : 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title & Price
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.course.courseCategory?.categoryName ??
                                      'Category',
                                  style: GoogleFonts.lato(
                                    color: AppColors.secondary,
                                    fontSize: isTablet ? 14 : 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  widget.course.courseTitle ?? '',
                                  style: GoogleFonts.lato(
                                    fontSize: isTablet ? 20 : 18,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '₹${widget.course.courseFee.toStringAsFixed(0)}',
                            style: GoogleFonts.lato(
                              fontSize: isTablet ? 18 : 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // TabBar
                      TabBar(
                        controller: _tabController,
                        labelColor: AppColors.primary,
                        unselectedLabelColor: AppColors.textPrimary,
                        indicatorColor: AppColors.primary,
                        labelStyle: GoogleFonts.lato(
                          fontWeight: FontWeight.bold,
                          fontSize: isTablet ? 16 : 14,
                        ),
                        tabs: const [
                          Tab(text: 'Overview'),
                          Tab(text: 'Curriculum'),
                          Tab(text: 'Reviews'),
                        ],
                      ),

                      // TabBarView
                      SizedBox(
                        height: size.height * (isTablet ? 0.4 : 0.35),
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Overview Tab
                            SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Course Overview',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isTablet ? 18 : 16,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      "Description",
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 24 : 22,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 24 : 18),
                                    Text(
                                      parseHtmlString(
                                          widget.course.description ?? ''),
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 16 : 14,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 24 : 18),
                                    Text(
                                      "What You Learn",
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 24 : 22,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 24 : 18),
                                    Text(
                                      parseHtmlString(widget.course.courseDetail
                                              ?.whatYouLearn ??
                                          'Nothing'),
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 16 : 14,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 24 : 18),
                                    Text(
                                      "Certification",
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 24 : 22,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    SizedBox(height: isTablet ? 24 : 18),
                                    Text(
                                      parseHtmlString(widget.course.courseDetail
                                              ?.certification ??
                                          ''),
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 16 : 14,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Curriculum Tab
                            SingleChildScrollView(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Course Curriculum',
                                      style: GoogleFonts.lato(
                                        fontSize: isTablet ? 20 : 18,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ...curriculumItems.asMap().entries.map(
                                      (entry) {
                                        final index = entry.key + 1;
                                        final text = entry.value;

                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 12),
                                          padding: const EdgeInsets.all(14),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.05),
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.play_circle_outline,
                                                color: AppColors.primary,
                                                size: isTablet ? 24 : 20,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Text(
                                                  '$index. $text',
                                                  style: GoogleFonts.lato(
                                                    fontSize:
                                                        isTablet ? 16 : 14,
                                                    fontWeight: FontWeight.w500,
                                                    color:
                                                        AppColors.textPrimary,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Reviews Tab
                            SingleChildScrollView(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Obx(() {
                                      if (_getReviewController
                                          .isLoading.value) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      }

                                      if (_getReviewController
                                          .courseReviews.isEmpty) {
                                        return const Center(
                                          child: Text("No reviews available"),
                                        );
                                      }

                                      return Column(
                                        children: List.generate(
                                          _getReviewController
                                              .courseReviews.length,
                                          (index) {
                                            final review = _getReviewController
                                                .courseReviews[index];
                                            final user = review.user;
                                            final course = review.course;

                                            return Card(
                                              color: AppColors.background,
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 16),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  radius: isTablet ? 28 : 24,
                                                  backgroundImage: (user
                                                                  ?.profilePic !=
                                                              null &&
                                                          user!.profilePic!
                                                              .isNotEmpty)
                                                      ? NetworkImage(
                                                          "https://api.auratechacademy.com/${user.profilePic}")
                                                      : const AssetImage(
                                                              "assets/icons/userImage.jpg")
                                                          as ImageProvider,
                                                ),
                                                title: Text(
                                                  user?.firstName?.isNotEmpty ==
                                                          true
                                                      ? user!.firstName!
                                                      : "Unknown User",
                                                  style: GoogleFonts.lato(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize:
                                                        isTablet ? 16 : 14,
                                                  ),
                                                ),
                                                subtitle: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        review.remark ??
                                                            'No review provided',
                                                        style: GoogleFonts.lato(
                                                            fontSize: isTablet
                                                                ? 14
                                                                : 12)),
                                                    const SizedBox(height: 4),
                                                    Row(
                                                      children: List.generate(
                                                        5,
                                                        (i) => Icon(
                                                          i <
                                                                  (review.rating
                                                                          ?.round() ??
                                                                      0)
                                                              ? Icons.star
                                                              : Icons.star,
                                                          color: Colors.amber,
                                                          size: isTablet
                                                              ? 20
                                                              : 18,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    }),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Write a Review',
                                      style: GoogleFonts.lato(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isTablet ? 18 : 16,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Form(
                                      key: _reviewFormKey,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          TextFormField(
                                            controller: _nameController,
                                            decoration: InputDecoration(
                                              labelText: 'Name',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Please enter your name'
                                                : null,
                                            style: GoogleFonts.lato(
                                                fontSize: isTablet ? 16 : 14),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: _emailController,
                                            decoration: InputDecoration(
                                              labelText: 'Email',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            validator: (value) => value!.isEmpty
                                                ? 'Please enter your email'
                                                : null,
                                            style: GoogleFonts.lato(
                                                fontSize: isTablet ? 16 : 14),
                                          ),
                                          const SizedBox(height: 12),
                                          TextFormField(
                                            controller: _messageController,
                                            decoration: InputDecoration(
                                              labelText: 'Review Message',
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                            ),
                                            maxLines: 3,
                                            validator: (value) => value!.isEmpty
                                                ? 'Please enter your review'
                                                : null,
                                            style: GoogleFonts.lato(
                                                fontSize: isTablet ? 16 : 14),
                                          ),
                                          const SizedBox(height: 12),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_reviewFormKey.currentState!
                                                  .validate()) {
                                                await postReviewController
                                                    .postReview(
                                                  courseId: widget.course.id,
                                                  userId:
                                                      StorageService.getData(
                                                          "User_id"),
                                                  reviewName: _nameController
                                                      .text
                                                      .trim(),
                                                  reviewEmail: _emailController
                                                      .text
                                                      .trim(),
                                                  reviewMessage:
                                                      _messageController.text
                                                          .trim(),
                                                  status: 1,
                                                );
                                                UtilKlass.showToastMsg(
                                                    "Review Submitted Successfully",
                                                    context);
                                                _nameController.clear();
                                                _emailController.clear();
                                                _messageController.clear();
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor:
                                                  AppColors.primary,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 14,
                                                      horizontal: 16),
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  'Post Review',
                                                  style: GoogleFonts.lato(
                                                    fontSize:
                                                        isTablet ? 16 : 14,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Icon(
                                                  Icons.arrow_forward,
                                                  size: isTablet ? 16 : 14,
                                                  color: Colors.white,
                                                )
                                              ],
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
                      ),

                      // Course Information
                      Card(
                        color: Colors.white,
                        margin: const EdgeInsets.only(top: 16),
                        child: ExpansionTile(
                          title: Text(
                            'Course Information',
                            style: GoogleFonts.lato(
                              fontWeight: FontWeight.bold,
                              fontSize: isTablet ? 18 : 16,
                              color: Colors.black87,
                            ),
                          ),
                          trailing: Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: Colors.black54,
                            size: isTablet ? 28 : 24,
                          ),
                          onExpansionChanged: (value) =>
                              setState(() => isExpanded = value),
                          children: [
                            const SizedBox(height: 12),
                            _buildInfoRow(
                              Icons.book,
                              'Lessons',
                              '${widget.course.courseLesson ?? 0} Lessons',
                              isTablet,
                            ),
                            _buildInfoRow(
                              Icons.timer,
                              'Duration',
                              widget.course.courseDurationUnit ?? 'N/A',
                              isTablet,
                            ),
                            _buildInfoRow(
                              Icons.star,
                              'Level',
                              widget.course.courseLevel ?? 'Beginner',
                              isTablet,
                            ),
                            _buildInfoRow(
                              Icons.language,
                              'Language',
                              widget.course.language ?? 'English',
                              isTablet,
                            ),
                            _buildInfoRow(
                              Icons.quiz,
                              'Quizzes',
                              '${widget.course.quizzes ?? 0} Quizzes',
                              isTablet,
                            ),
                            const SizedBox(height: 20),
                            Center(
                              child: ElevatedButton.icon(
                                onPressed: () async {
                                  final params = ShareParams(
                                    text: widget.course.courseTitle,
                                  );

                                  final result =
                                      await SharePlus.instance.share(params);

                                  if (result.status ==
                                      ShareResultStatus.success) {
                                    UtilKlass.showToastMsg(
                                        "Thank you for sharing the course $params",
                                        context);
                                    print('Thank you for sharing the course');
                                  }
                                },
                                icon: Icon(
                                  Icons.share,
                                  size: isTablet ? 22 : 20,
                                  color: Colors.white,
                                ),
                                label: Text(
                                  'Share the Course',
                                  style: GoogleFonts.lato(
                                    fontSize: isTablet ? 16 : 14,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isTablet ? 32 : 24,
                                    vertical: isTablet ? 16 : 14,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: FutureBuilder<bool>(
        future: StorageService.getIsLoggedIn(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          }

          final isLoggedIn = snapshot.data ?? false;

          return Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isTablet ? 24 : 16,
              vertical: isTablet ? 16 : 12,
            ),
            child: isLoggedIn
                ? Row(
                    children: [
                      Obx(() {
                        final isBusy = addToCart.isLoading.value;

                        return Expanded(
                          child: ElevatedButton(
                            onPressed: isBusy
                                ? null
                                : () async {
                                    try {
                                      final userId = StorageService.getData(
                                          "User_id"); // ensure int
                                      await addToCart.addToCart(
                                        user_id: userId,
                                        course_id: widget.course.id,
                                        quantity: 1,
                                      );
                                      UtilKlass.showToastMsg(
                                          "Course Added Successfully", context);
                                      Get.offAll(BottomnavBar());
                                    } catch (e) {
                                      Get.snackbar("Error", e.toString());
                                    }
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              padding: EdgeInsets.symmetric(
                                  vertical: isTablet ? 16 : 14),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16)),
                            ),
                            child: isBusy
                                ? SizedBox(
                                    height: isTablet ? 20 : 18,
                                    width: isTablet ? 20 : 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          AppColors.primary),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Add to Cart",
                                        style: GoogleFonts.lato(
                                          fontSize: isTablet ? 16 : 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Icon(
                                        Icons.arrow_forward,
                                        color: Colors.white,
                                        size: isTablet ? 16 : 14,
                                      ),
                                    ],
                                  ),
                          ),
                        );
                      }),
                      const SizedBox(width: 16),

           widget.course.is_enroll
                          ? ElevatedButton(
                              onPressed: () => Get.to(CourseDetailPage(course: widget.course,)),
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(165, 46),
                              ),
                              child: Text("Start Course"),
                            )
                          : const SizedBox.shrink(),
                    ],
                  )
                : ElevatedButton(
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding:
                          EdgeInsets.symmetric(vertical: isTablet ? 16 : 14),
                    ),
                    child: Text(
                      "Enroll Course (₹${widget.course.courseFee.toStringAsFixed(0)})",
                      style: GoogleFonts.lato(
                        fontSize: isTablet ? 16 : 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(
      IconData icon, String title, String value, bool isTablet) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 10),
      child: Row(
        children: [
          Icon(
            icon,
            size: isTablet ? 22 : 20,
            color: AppColors.primary,
          ),
          const SizedBox(width: 12),
          Text(
            '$title: ',
            style: GoogleFonts.lato(
              fontWeight: FontWeight.w600,
              fontSize: isTablet ? 16 : 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.lato(
                fontSize: isTablet ? 16 : 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CurriculumModule {
  final String title;
  final String topics;
  CurriculumModule({required this.title, required this.topics});
}
