// import 'package:get/get.dart';
// import 'package:auratech_academy/ApiServices/ApiServices.dart';
//
// import '../../../utils/logx.dart';
// import '../Model/Learning_Module_Model.dart';
//
// class Learning_Module_Controller extends GetxController {
//   // 🔹 States
//   final RxBool isLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//
//   // 🔹 API service
//   final ApiService _api = ApiService(
//     baseUrl: 'https://api.auratechacademy.com/',
//   );
//
//   final RxList<CourseVideoModel> courseVideos = <CourseVideoModel>[].obs;
//
//   int? _lastCourseId;
//   final RxBool courseCompleted = false.obs;
//   final RxList<int> quizScores = <int>[].obs;
//   final RxSet<int> completedQuizVideoIds = <int>{}.obs;
//
//   Future<void> fetchLearningModules({required int courseId}) async {
//     _lastCourseId = courseId;
//
//     final String endpoint = 'course_video/?course_id=$courseId';
//
//     isLoading.value = true;
//     errorMessage.value = '';
//
//     LogX.printLog('📥 Fetching course videos for course_id=$courseId');
//     LogX.printLog('🌐 Endpoint: ${_api.baseUrl}$endpoint');
//
//     try {
//       final List<CourseVideoModel> result =
//           await _api.getList<CourseVideoModel>(
//         endpoint,
//         (json) => CourseVideoModel.fromJson(json),
//       );
//
//       LogX.printLog('✅ Course videos fetched: ${result.length}');
//
//       courseVideos.assignAll(result);
//       resetQuizProgress();
//       // courseCompleted.value = false;
//       // quizScores.clear();
//
//       if (result.isEmpty) {
//         LogX.printLog('ℹ No course videos found for course_id=$courseId');
//       } else {
//         // Quiz count logging
//         final totalQuizzes = result.fold<int>(
//           0,
//           (sum, v) => sum + (v.quizzes.length),
//         );
//         LogX.printLog('🧠 Total quizzes loaded: $totalQuizzes');
//       }
//     } catch (e, st) {
//       errorMessage.value =
//           'Failed to load course content. Please try again later.';
//       LogX.printError('❌ Error in fetchLearningModules: $e\n$st');
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   /// Convenience: Refresh with last used courseId (if available)
//   Future<void> refreshModules() async {
//     if (_lastCourseId != null) {
//       await fetchLearningModules(courseId: _lastCourseId!);
//     }
//   }
//
//   // ==================================================================
//   //  🔹 HELPER GETTERS – UI me direct use karne ke liye
//   // ==================================================================
//
//   /// Sirf woh items jinke paas actual video hai
//   List<CourseVideoModel> get videoItems =>
//       courseVideos.where((v) => (v.course_video ?? '').isNotEmpty).toList();
//
//   /// Sirf woh items jinke paas PDF attached hai
//   List<CourseVideoModel> get pdfItems =>
//       courseVideos.where((v) => (v.pdf_file ?? '').isNotEmpty).toList();
//
//   /// Sirf woh items jinke paas description/notes hain
//   List<CourseVideoModel> get noteItems =>
//       courseVideos.where((v) => (v.description).trim().isNotEmpty).toList();
//
//   /// Mixed: jo video ya pdf ya notes me se kuch to rakhte hain
//   List<CourseVideoModel> get contentItems => courseVideos
//       .where((v) =>
//           (v.course_video ?? '').isNotEmpty ||
//           (v.pdf_file ?? '').isNotEmpty ||
//           v.description.trim().isNotEmpty)
//       .toList();
//
//   /// Sirf woh items jinke paas at least 1 quiz hai
//   List<CourseVideoModel> get quizItems =>
//       courseVideos.where((v) => v.quizzes.isNotEmpty).toList();
//
//   /// Flattened: saare quizzes ek hi list me
//   List<QuizModel> get allQuizzes =>
//       courseVideos.expand((v) => v.quizzes).toList();
//
//   /// Kisi specific video ke quizzes (by model)
//   List<QuizModel> quizzesForVideo(CourseVideoModel video) => video.quizzes;
//
//   /// Kisi specific `course_video` id ke quizzes (FK se)
//   List<QuizModel> quizzesForVideoId(int courseVideoId) {
//     return courseVideos
//         .where((v) => v.id == courseVideoId)
//         .expand((v) => v.quizzes)
//         .toList();
//   }
//
//   // ==================================================================
//   //  🔹 URL BUILDERS (FULL URL FOR UI)
//   // ==================================================================
//
//   /// Full video URL from relative path
//   String buildFullVideoUrl(CourseVideoModel video) {
//     if (video.course_video == null || video.course_video!.isEmpty) {
//       return '';
//     }
//     return _api.baseUrl + video.course_video!;
//   }
//
//   /// Full PDF URL from relative path
//   String buildFullPdfUrl(CourseVideoModel video) {
//     if (video.pdf_file == null || video.pdf_file!.isEmpty) {
//       return '';
//     }
//     return _api.baseUrl + video.pdf_file!;
//   }
//
//   /// Full thumbnail URL from relative path
//   String buildFullThumbnailUrl(CourseVideoModel video) {
//     if (video.video_thumbnail == null || video.video_thumbnail!.isEmpty) {
//       return '';
//     }
//     return _api.baseUrl + video.video_thumbnail!;
//   }
//
//   /// Full PDF thumbnail URL (alag se bhi kaam aa sakta hai)
//   String buildFullPdfThumbnailUrl(CourseVideoModel video) {
//     if (video.pdf_thumbnail == null || video.pdf_thumbnail!.isEmpty) {
//       return '';
//     }
//     return _api.baseUrl + video.pdf_thumbnail!;
//   }
//
//   // ==================================================================
//   //  🔹 TEXT HELPERS – UI bind ko easy banane ke liye
//   // ==================================================================
//
//   String getVideoTitle(CourseVideoModel item) =>
//       item.coursevideo_title?.trim().isNotEmpty == true
//           ? item.coursevideo_title!.trim()
//           : 'Untitled Video';
//
//   String getVideoHeading(CourseVideoModel item) =>
//       item.coursevideo_heading?.trim().isNotEmpty == true
//           ? item.coursevideo_heading!.trim()
//           : '';
//
//   String getPdfTitle(CourseVideoModel item) =>
//       item.pdf_title?.trim().isNotEmpty == true
//           ? item.pdf_title!.trim()
//           : 'PDF Resource';
//
//   String getPdfHeading(CourseVideoModel item) =>
//       item.pdf_heading?.trim().isNotEmpty == true
//           ? item.pdf_heading!.trim()
//           : '';
//
//   String getModuleTitle(CourseVideoModel item) =>
//       item.course_module?.module_title.trim().isNotEmpty == true
//           ? item.course_module!.module_title.trim()
//           : '';
//
//   String getCourseTitle(CourseVideoModel item) =>
//       item.course_module?.course.CourseMaster_title.trim().isNotEmpty == true
//           ? item.course_module!.course.CourseMaster_title.trim()
//           : '';
//
//   /// Clean notes (description) – HTML ko baad me strip bhi kar sakte ho agar chaho
//   String getNotes(CourseVideoModel item) => item.description.trim();
//
//   // ==================================================================
//   //  🔹 QUIZ HELPERS – options + correct answer access
//   // ==================================================================
//
//   /// Ek quiz ke saare options as simple list (text only)
//   List<String> getQuizOptions(QuizModel quiz) => [
//         quiz.option1,
//         quiz.option2,
//         quiz.option3,
//         quiz.option4,
//       ];
//
//   /// Ek quiz ka correct option index (0–3), agar koi bhi true na ho to -1
//   int getCorrectOptionIndex(QuizModel quiz) {
//     if (quiz.option1_correct) return 0;
//     if (quiz.option2_correct) return 1;
//     if (quiz.option3_correct) return 2;
//     if (quiz.option4_correct) return 3;
//     return -1;
//   }
//
//   /// Ek quiz ka correct option text (agar na mile to empty string)
//   String getCorrectOptionText(QuizModel quiz) {
//     final idx = getCorrectOptionIndex(quiz);
//     if (idx == -1) return '';
//     return getQuizOptions(quiz)[idx];
//   }
//
//   ///quizes  helpers
//   /// Total video-lessons jinke paas quiz hai
//   int get totalQuizLessons => quizItems.length;
//
//   /// Naya course load hone pe progress reset
//   void resetQuizProgress() {
//     completedQuizVideoIds.clear();
//     courseCompleted.value = false;
//     quizScores.clear();
//   }
//
//
//   void markLessonQuizCompleted({
//     required int videoId,
//     required int score,
//   }) {
//     completedQuizVideoIds.add(videoId);
//     quizScores.add(score);
//
//     LogX.printLog('✅ markLessonQuizCompleted: videoId=$videoId, score=$score');
//     LogX.printLog('➡ ${completedQuizVideoIds.length} / $totalQuizLessons lessons completed');
//
//     if (completedQuizVideoIds.length >= totalQuizLessons &&
//         totalQuizLessons > 0) {
//       courseCompleted.value = true;
//       LogX.printLog('🌟 courseCompleted = true');
//     }
//   }
//
//   /// Check: ye lesson ka quiz pehle hi complete hua hai?
//   bool isLessonQuizCompleted(int videoId) {
//     return completedQuizVideoIds.contains(videoId);
//   }
// }
import 'package:get/get.dart';
import 'package:auratech_academy/ApiServices/ApiServices.dart';

import '../../../utils/logx.dart';
import '../Model/Learning_Module_Model.dart';

class Learning_Module_Controller extends GetxController {
  // 🔹 States
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // 🔹 API service
  final ApiService _api = ApiService(
    baseUrl: 'https://api.auratechacademy.com/',
  );

  final RxList<CourseVideoModel> courseVideos = <CourseVideoModel>[].obs;

  int? _lastCourseId;

  // 🔹 Quiz progress
  final RxBool courseCompleted = false.obs;
  final RxList<int> quizScores = <int>[].obs;
  final RxSet<int> completedQuizVideoIds = <int>{}.obs;

  // ================== FETCH ==================

  Future<void> fetchLearningModules({required int courseId}) async {
    _lastCourseId = courseId;

    final String endpoint = 'course_video/?course_id=$courseId';

    isLoading.value = true;
    errorMessage.value = '';

    LogX.printLog('📥 Fetching course videos for course_id=$courseId');
    LogX.printLog('🌐 Endpoint: ${_api.baseUrl}$endpoint');

    try {
      final List<CourseVideoModel> result =
      await _api.getList<CourseVideoModel>(
        endpoint,
            (json) => CourseVideoModel.fromJson(json),
      );

      LogX.printLog('✅ Course videos fetched: ${result.length}');

      courseVideos.assignAll(result);
      resetQuizProgress(); // ⚠️ ye har fetch pe reset karega

      if (result.isEmpty) {
        LogX.printLog('ℹ No course videos found for course_id=$courseId');
      } else {
        final totalQuizzes = result.fold<int>(
          0,
              (sum, v) => sum + (v.quizzes.length),
        );
        LogX.printLog('🧠 Total quizzes loaded: $totalQuizzes');
        LogX.printLog('🧠 Total quiz lessons: $totalQuizLessons');
      }
    } catch (e, st) {
      errorMessage.value =
      'Failed to load course content. Please try again later.';
      LogX.printError('❌ Error in fetchLearningModules: $e\n$st');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshModules() async {
    if (_lastCourseId != null) {
      await fetchLearningModules(courseId: _lastCourseId!);
    }
  }

  // ================== HELPERS ==================

  List<CourseVideoModel> get videoItems =>
      courseVideos.where((v) => (v.course_video ?? '').isNotEmpty).toList();

  List<CourseVideoModel> get pdfItems =>
      courseVideos.where((v) => (v.pdf_file ?? '').isNotEmpty).toList();

  List<CourseVideoModel> get noteItems =>
      courseVideos.where((v) => (v.description).trim().isNotEmpty).toList();

  List<CourseVideoModel> get contentItems => courseVideos
      .where((v) =>
  (v.course_video ?? '').isNotEmpty ||
      (v.pdf_file ?? '').isNotEmpty ||
      v.description.trim().isNotEmpty)
      .toList();

  List<CourseVideoModel> get quizItems =>
      courseVideos.where((v) => v.quizzes.isNotEmpty).toList();

  List<QuizModel> get allQuizzes =>
      courseVideos.expand((v) => v.quizzes).toList();

  List<QuizModel> quizzesForVideo(CourseVideoModel video) => video.quizzes;

  List<QuizModel> quizzesForVideoId(int courseVideoId) {
    return courseVideos
        .where((v) => v.id == courseVideoId)
        .expand((v) => v.quizzes)
        .toList();
  }

  String buildFullVideoUrl(CourseVideoModel video) {
    if (video.course_video == null || video.course_video!.isEmpty) return '';
    return _api.baseUrl + video.course_video!;
  }

  String buildFullPdfUrl(CourseVideoModel video) {
    if (video.pdf_file == null || video.pdf_file!.isEmpty) return '';
    return _api.baseUrl + video.pdf_file!;
  }

  String buildFullThumbnailUrl(CourseVideoModel video) {
    if (video.video_thumbnail == null || video.video_thumbnail!.isEmpty) {
      return '';
    }
    return _api.baseUrl + video.video_thumbnail!;
  }

  String buildFullPdfThumbnailUrl(CourseVideoModel video) {
    if (video.pdf_thumbnail == null || video.pdf_thumbnail!.isEmpty) {
      return '';
    }
    return _api.baseUrl + video.pdf_thumbnail!;
  }

  String getVideoTitle(CourseVideoModel item) =>
      item.coursevideo_title?.trim().isNotEmpty == true
          ? item.coursevideo_title!.trim()
          : 'Untitled Video';

  String getVideoHeading(CourseVideoModel item) =>
      item.coursevideo_heading?.trim().isNotEmpty == true
          ? item.coursevideo_heading!.trim()
          : '';

  String getPdfTitle(CourseVideoModel item) =>
      item.pdf_title?.trim().isNotEmpty == true
          ? item.pdf_title!.trim()
          : 'PDF Resource';

  String getPdfHeading(CourseVideoModel item) =>
      item.pdf_heading?.trim().isNotEmpty == true
          ? item.pdf_heading!.trim()
          : '';

  String getModuleTitle(CourseVideoModel item) =>
      item.course_module?.module_title.trim().isNotEmpty == true
          ? item.course_module!.module_title.trim()
          : '';

  String getCourseTitle(CourseVideoModel item) =>
      item.course_module?.course.CourseMaster_title.trim().isNotEmpty == true
          ? item.course_module!.course.CourseMaster_title.trim()
          : '';

  String getNotes(CourseVideoModel item) => item.description.trim();

  List<String> getQuizOptions(QuizModel quiz) => [
    quiz.option1,
    quiz.option2,
    quiz.option3,
    quiz.option4,
  ];

  int getCorrectOptionIndex(QuizModel quiz) {
    if (quiz.option1_correct) return 0;
    if (quiz.option2_correct) return 1;
    if (quiz.option3_correct) return 2;
    if (quiz.option4_correct) return 3;
    return -1;
  }

  String getCorrectOptionText(QuizModel quiz) {
    final idx = getCorrectOptionIndex(quiz);
    if (idx == -1) return '';
    return getQuizOptions(quiz)[idx];
  }

  // ================== QUIZ PROGRESS ==================

  int get totalQuizLessons => quizItems.length;

  void resetQuizProgress() {
    completedQuizVideoIds.clear();
    courseCompleted.value = false;
    quizScores.clear();
    LogX.printLog('🔄 Quiz progress reset');
  }

  void markLessonQuizCompleted({
    required int videoId,
    required int score,
  }) {
    completedQuizVideoIds.add(videoId);
    quizScores.add(score);

    LogX.printLog('✅ markLessonQuizCompleted: videoId=$videoId, score=$score');
    LogX.printLog(
        '➡ ${completedQuizVideoIds.length} / $totalQuizLessons lessons completed');

    if (completedQuizVideoIds.length >= totalQuizLessons &&
        totalQuizLessons > 0) {
      courseCompleted.value = true;
      LogX.printLog('🌟 courseCompleted = true');
    }
  }

  bool isLessonQuizCompleted(int videoId) {
    return completedQuizVideoIds.contains(videoId);
  }
}
