// class CourseMaster {
//   final int id;
//   final CourseCategory? courseCategory;
//   final CourseInstructor? courseInstructor;
//   final CourseDetail? courseDetail;
//   final String courseTitle;
//   final String courseThumbImage;
//   final String courseDuration;
//   final String courseDurationUnit;
//   final String slug;
//   final String description;
//   final int topCourse;
//   final double courseFee;
//   final String videoImage;
//   final String courseText;
//   final String courseRating;
//   final String courseLesson;
//   final String courseLevel;
//   final int status;
//   final String language;
//   final String numberOfStudents;
//   final String courseImage;
//   final String quizzes;
//
//   CourseMaster({
//     required this.id,
//     required this.courseCategory,
//     required this.courseInstructor,
//     required this.courseDetail,
//     required this.courseTitle,
//     required this.courseThumbImage,
//     required this.courseDuration,
//     required this.courseDurationUnit,
//     required this.slug,
//     required this.description,
//     required this.topCourse,
//     required this.courseFee,
//     required this.videoImage,
//     required this.courseText,
//     required this.courseRating,
//     required this.courseLesson,
//     required this.courseLevel,
//     required this.status,
//     required this.language,
//     required this.numberOfStudents,
//     required this.courseImage,
//     required this.quizzes,
//   });
//
//   factory CourseMaster.fromJson(Map<String, dynamic> json) {
//     return CourseMaster(
//       id: json['id'],
//       courseCategory: json['CourseMaster_courseCat'] != null
//           ? CourseCategory.fromJson(json['CourseMaster_courseCat'])
//           : null,
//       courseInstructor: json['CourseMaster_Courseinstructor'] != null
//           ? CourseInstructor.fromJson(json['CourseMaster_Courseinstructor'])
//           : null,
//       courseDetail: json['courseMaster_detail_id'] != null
//           ? CourseDetail.fromJson(json['courseMaster_detail_id'])
//           : null,
//       courseTitle: json['CourseMaster_title'] ?? '',
//       courseThumbImage: json['CourseMaster_tumbimage'] ?? '',
//       courseDuration: json['CourseMaster_duration'] ?? '',
//       courseDurationUnit: json['CourseMaster_duration_unit'] ?? '',
//       slug: json['slug'] ?? '',
//       description: json['Description'] ?? '',
//       topCourse: json['CourseMaster_topcourse'] ?? 0,
//       courseFee: (json['CourseMaster_fee'] ?? 0).toDouble(),
//       videoImage: json['Video_img'] ?? '',
//       courseText: json['course_text'] ?? '',
//       courseRating: json['CourseMaster_rating'] ?? '',
//       courseLesson: json['course_lesson'] ?? '',
//       courseLevel: json['course_level'] ?? '',
//       status: json['status'] ?? 0,
//       language: json['Language'] ?? '',
//       numberOfStudents: json['Number_of_students'] ?? '',
//       courseImage: json['Course_img'] ?? '',
//       quizzes: json['Quizzes'] ?? '',
//     );
//   }
// }
//
// class CourseCategory {
//   final int id;
//   final String categoryName;
//   final String categoryIcon;
//   final int itemStockValue;
//
//   CourseCategory({
//     required this.id,
//     required this.categoryName,
//     required this.categoryIcon,
//     required this.itemStockValue,
//   });
//
//   factory CourseCategory.fromJson(Map<String, dynamic> json) {
//     return CourseCategory(
//       id: json['id'],
//       categoryName: json['category_name'] ?? '',
//       categoryIcon: json['category_icon'] ?? '',
//       itemStockValue: json['item_stock_value'] ?? 0,
//     );
//   }
// }
//
// class CourseInstructor {
//   final int id;
//   final String name;
//   final String desig;
//   final String email;
//   final String image;
//   final double rating;
//   final double experience;
//
//   CourseInstructor({
//     required this.id,
//     required this.name,
//     required this.desig,
//     required this.email,
//     required this.image,
//     required this.rating,
//     required this.experience,
//   });
//
//   factory CourseInstructor.fromJson(Map<String, dynamic> json) {
//     return CourseInstructor(
//       id: json['id'],
//       name: json['CourseInstructor_name'] ?? '',
//       desig: json['CourseInstructor_desig'] ?? '',
//       email: json['CourseInstructor_email'] ?? '',
//       image: json['CourseInstructor_image'] ?? '',
//       rating: (json['CourseInstructor_rating'] ?? 0).toDouble(),
//       experience: (json['CourseInstructor_Experience'] ?? 0).toDouble(),
//     );
//   }
// }
//
// class CourseDetail {
//   final int id;
//   final String certification;
//   final String whatYouLearn;
//   final String curriculum;
//
//   CourseDetail({
//     required this.id,
//     required this.certification,
//     required this.whatYouLearn,
//     required this.curriculum,
//   });
//
//   factory CourseDetail.fromJson(Map<String, dynamic> json) {
//     return CourseDetail(
//       id: json['id'],
//       certification: json['Certification'] ?? '',
//       whatYouLearn: json['Whatyoulearn'] ?? '',
//       curriculum: json['Curriculam'] ?? '',
//     );
//   }
// }




class CourseMasterResponse {
  final String message;
  final List<CourseMaster> data;

  CourseMasterResponse({required this.message, required this.data});

  factory CourseMasterResponse.fromJson(Map<String, dynamic> json) {
    return CourseMasterResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CourseMaster.fromJson(item))
          .toList() ??
          [],
    );
  }
}

class CourseMaster {
  final int id;
  final CourseCategory? courseCategory;
  final CourseInstructor? courseInstructor;
  final CourseDetail? courseDetail;
  final String recordStatus;
  final String courseTitle;
  final String courseThumbImage;
  final String courseDuration;
  final String courseDurationUnit;
  final String slug;
  final String description;
  final int topCourse;
  final double courseFee;
  final String? videoImage;
  final String courseText;
  final String courseRating;
  final String courseLesson;
  final String courseLevel;
  final int status;
  final String language;
  final String numberOfStudents;
  final String courseImage;
  final String quizzes;
  final String createDate;
  final String updateDate;
  final bool is_enroll;

  CourseMaster({
    required this.id,
    this.courseCategory,
    this.courseInstructor,
    this.courseDetail,
    required this.recordStatus,
    required this.courseTitle,
    required this.courseThumbImage,
    required this.courseDuration,
    required this.courseDurationUnit,
    required this.slug,
    required this.description,
    required this.topCourse,
    required this.courseFee,
    this.videoImage,
    required this.courseText,
    required this.courseRating,
    required this.courseLesson,
    required this.courseLevel,
    required this.status,
    required this.language,
    required this.numberOfStudents,
    required this.courseImage,
    required this.quizzes,
    required this.createDate,
    required this.updateDate,
    required this.is_enroll,
  });

  factory CourseMaster.fromJson(Map<String, dynamic> json) {
    return CourseMaster(
      id: json['id'] ?? 0,
      courseCategory: json['CourseMaster_courseCat'] != null
          ? CourseCategory.fromJson(json['CourseMaster_courseCat'])
          : null,
      courseInstructor: json['CourseMaster_Courseinstructor'] != null
          ? CourseInstructor.fromJson(json['CourseMaster_Courseinstructor'])
          : null,
      courseDetail: json['courseMaster_detail_id'] != null
          ? CourseDetail.fromJson(json['courseMaster_detail_id'])
          : null,
      recordStatus: json['record_status'] ?? '',
      courseTitle: json['CourseMaster_title'] ?? '',
      courseThumbImage: json['CourseMaster_tumbimage'] ?? '',
      courseDuration: json['CourseMaster_duration'] ?? '',
      courseDurationUnit: json['CourseMaster_duration_unit'] ?? '',
      slug: json['slug'] ?? '',
      description: json['Description'] ?? '',
      topCourse: json['CourseMaster_topcourse'] ?? 0,
      courseFee: (json['CourseMaster_fee'] ?? 0).toDouble(),
      is_enroll: json['is_enroll'] == true ||
          json['is_enroll'] == 1 ||
          json['is_enroll'] == "1" ||
          json['is_enroll'] == "true",

      videoImage: json['Video_img'],
      courseText: json['course_text'] ?? '',
      courseRating: json['CourseMaster_rating'] ?? '',
      courseLesson: json['course_lesson'] ?? '',
      courseLevel: json['course_level'] ?? '',
      status: json['status'] ?? 0,
      language: json['Language'] ?? '',
      numberOfStudents: json['Number_of_students'] ?? '',
      courseImage: json['Course_img'] ?? '',
      quizzes: json['Quizzes'] ?? '',
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
    );
  }
}

class CourseCategory {
  final int id;
  final String recordStatus;
  final String categoryName;
  final String? categoryIcon;
  final int itemStockValue;
  final CourseSegment? courseSegment;

  CourseCategory({
    required this.id,
    required this.recordStatus,
    required this.categoryName,
    this.categoryIcon,
    required this.itemStockValue,
    this.courseSegment,
  });

  factory CourseCategory.fromJson(Map<String, dynamic> json) {
    return CourseCategory(
      id: json['id'] ?? 0,
      recordStatus: json['record_status'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryIcon: json['category_icon'],
      itemStockValue: json['item_stock_value'] ?? 0,
      courseSegment: json['coursesugment'] != null
          ? CourseSegment.fromJson(json['coursesugment'])
          : null,
    );
  }
}

class CourseSegment {
  final int id;
  final String name;
  final String recordStatus;
  final String createDate;
  final String updateDate;

  CourseSegment({
    required this.id,
    required this.name,
    required this.recordStatus,
    required this.createDate,
    required this.updateDate,
  });

  factory CourseSegment.fromJson(Map<String, dynamic> json) {
    return CourseSegment(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      recordStatus: json['record_status'] ?? '',
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
    );
  }
}

class CourseInstructor {
  final int id;
  final String name;
  final String desig;
  final String shortBio;
  final String email;
  final String mobile;
  final String image;
  final double rating;
  final double experience;
  final String facebook;
  final String twitter;
  final String instagram;
  final String youtube;
  final String linkedin;

  CourseInstructor({
    required this.id,
    required this.name,
    required this.desig,
    required this.shortBio,
    required this.email,
    required this.mobile,
    required this.image,
    required this.rating,
    required this.experience,
    required this.facebook,
    required this.twitter,
    required this.instagram,
    required this.youtube,
    required this.linkedin,
  });

  factory CourseInstructor.fromJson(Map<String, dynamic> json) {
    return CourseInstructor(
      id: json['id'] ?? 0,
      name: json['CourseInstructor_name'] ?? '',
      desig: json['CourseInstructor_desig'] ?? '',
      shortBio: json['CourseInstructor_shortbio'] ?? '',
      email: json['CourseInstructor_email'] ?? '',
      mobile: json['CourseInstructor_mobile_no'] ?? '',
      image: json['CourseInstructor_image'] ?? '',
      rating: (json['CourseInstructor_rating'] ?? 0).toDouble(),
      experience: (json['CourseInstructor_Experience'] ?? 0).toDouble(),
      facebook: json['CourseInstructor_facebook_url'] ?? '',
      twitter: json['CourseInstructor_twitter_url'] ?? '',
      instagram: json['CourseInstructor_instagram_url'] ?? '',
      youtube: json['CourseInstructor_youtube_url'] ?? '',
      linkedin: json['CourseInstructor_linkedin_url'] ?? '',
    );
  }
}

class CourseDetail {
  final int id;
  final String certification;
  final String whatYouLearn;
  final String curriculum;
  final String recordStatus;
  final String createDate;
  final String updateDate;

  CourseDetail({
    required this.id,
    required this.certification,
    required this.whatYouLearn,
    required this.curriculum,
    required this.recordStatus,
    required this.createDate,
    required this.updateDate,
  });

  factory CourseDetail.fromJson(Map<String, dynamic> json) {
    return CourseDetail(
      id: json['id'] ?? 0,
      certification: json['Certification'] ?? '',
      whatYouLearn: json['Whatyoulearn'] ?? '',
      curriculum: json['Curriculam'] ?? '',
      recordStatus: json['record_status'] ?? '',
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
    );
  }
}
