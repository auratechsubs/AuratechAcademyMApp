/// =============================
/// TOP-LEVEL RESPONSE MODEL
/// =============================
class CourseVideoResponseModel {
  final String message;
  final List<CourseVideoModel> data;

  CourseVideoResponseModel({
    required this.message,
    required this.data,
  });

  factory CourseVideoResponseModel.fromJson(Map<String, dynamic> json) {
    return CourseVideoResponseModel(
      message: json['message'] as String? ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CourseVideoModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

/// =============================
/// EACH ITEM INSIDE "data"
/// =============================
class CourseVideoModel {
  final int id;

  /// "course_module" object (future-proof: nullable)
  final CourseModuleModel? course_module;

  /// "course_module_id" bhi null aa sakta hai
  final int? course_module_id;

  /// NEW: quizzes list
  final List<QuizModel> quizzes;

  final String create_date;
  final String update_date;
  final String record_status;

  final String? coursevideo_heading;
  final String? coursevideo_title;

  final String? course_video;
  final String? video_thumbnail;

  /// description kabhi "" aa rahi hai, null ho to bhi "" set kar rahe
  final String description;

  final String? slug;
  final String? pdf_title;
  final String? pdf_heading;
  final String? pdf_file;
  final String? pdf_thumbnail;

  final String? remarks;
  final String? extra;

  final int? create_user;
  final int? update_user;

  CourseVideoModel({
    required this.id,
    required this.course_module,
    required this.course_module_id,
    required this.quizzes,
    required this.create_date,
    required this.update_date,
    required this.record_status,
    this.coursevideo_heading,
    this.coursevideo_title,
    this.course_video,
    this.video_thumbnail,
    required this.description,
    this.slug,
    this.pdf_title,
    this.pdf_heading,
    this.pdf_file,
    this.pdf_thumbnail,
    this.remarks,
    this.extra,
    this.create_user,
    this.update_user,
  });

  factory CourseVideoModel.fromJson(Map<String, dynamic> json) {
    return CourseVideoModel(
      id: json['id'] as int,
      course_module: json['course_module'] != null
          ? CourseModuleModel.fromJson(
        json['course_module'] as Map<String, dynamic>,
      )
          : null,
      course_module_id: json['course_module_id'] as int?,
      quizzes: (json['quizzes'] as List<dynamic>? ?? [])
          .map((e) => QuizModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      create_date: json['create_date'] as String? ?? '',
      update_date: json['update_date'] as String? ?? '',
      record_status: json['record_status'] as String? ?? '',
      coursevideo_heading: json['coursevideo_heading'] as String?,
      coursevideo_title: json['coursevideo_title'] as String?,
      course_video: json['course_video'] as String?,
      video_thumbnail: json['video_thumbnail'] as String?,
      description: json['description'] as String? ?? '',
      slug: json['slug'] as String?,
      pdf_title: json['pdf_title'] as String?,
      pdf_heading: json['pdf_heading'] as String?,
      pdf_file: json['pdf_file'] as String?,
      pdf_thumbnail: json['pdf_thumbnail'] as String?,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_module': course_module?.toJson(),
      'course_module_id': course_module_id,
      'quizzes': quizzes.map((e) => e.toJson()).toList(),
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'coursevideo_heading': coursevideo_heading,
      'coursevideo_title': coursevideo_title,
      'course_video': course_video,
      'video_thumbnail': video_thumbnail,
      'description': description,
      'slug': slug,
      'pdf_title': pdf_title,
      'pdf_heading': pdf_heading,
      'pdf_file': pdf_file,
      'pdf_thumbnail': pdf_thumbnail,
      'remarks': remarks,
      'extra': extra,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

/// =============================
/// NEW: QUIZ MODEL
/// =============================
class QuizModel {
  final int id;
  final String create_date;
  final String update_date;
  final String record_status;

  final int question_no;
  final String question_text;

  final String option1;
  final bool option1_correct;

  final String option2;
  final bool option2_correct;

  final String option3;
  final bool option3_correct;

  final String option4;
  final bool option4_correct;

  final int? create_user;
  final int? update_user;

  /// course_video id (FK)
  final int course_video;

  QuizModel({
    required this.id,
    required this.create_date,
    required this.update_date,
    required this.record_status,
    required this.question_no,
    required this.question_text,
    required this.option1,
    required this.option1_correct,
    required this.option2,
    required this.option2_correct,
    required this.option3,
    required this.option3_correct,
    required this.option4,
    required this.option4_correct,
    this.create_user,
    this.update_user,
    required this.course_video,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id'] as int,
      create_date: json['create_date'] as String? ?? '',
      update_date: json['update_date'] as String? ?? '',
      record_status: json['record_status'] as String? ?? '',
      question_no: json['question_no'] as int? ?? 0,
      question_text: json['question_text'] as String? ?? '',
      option1: json['option1'] as String? ?? '',
      option1_correct: json['option1_correct'] as bool? ?? false,
      option2: json['option2'] as String? ?? '',
      option2_correct: json['option2_correct'] as bool? ?? false,
      option3: json['option3'] as String? ?? '',
      option3_correct: json['option3_correct'] as bool? ?? false,
      option4: json['option4'] as String? ?? '',
      option4_correct: json['option4_correct'] as bool? ?? false,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
      course_video: json['course_video'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'question_no': question_no,
      'question_text': question_text,
      'option1': option1,
      'option1_correct': option1_correct,
      'option2': option2,
      'option2_correct': option2_correct,
      'option3': option3,
      'option3_correct': option3_correct,
      'option4': option4,
      'option4_correct': option4_correct,
      'create_user': create_user,
      'update_user': update_user,
      'course_video': course_video,
    };
  }
}

/// =============================
/// NESTED "course_module"
/// =============================
class CourseModuleModel {
  final int id;
  final CourseMasterModel course;
  final int course_id;

  final String create_date;
  final String update_date;
  final String record_status;

  final String module_title;

  /// Ye JSON me kabhi null aa raha hai (module 2)
  final String? module_thumbnail;

  /// Ye bhi kabhi null aa rahe hain
  final String? remarks;
  final String? extra;

  final int? create_user;
  final int? update_user;

  CourseModuleModel({
    required this.id,
    required this.course,
    required this.course_id,
    required this.create_date,
    required this.update_date,
    required this.record_status,
    required this.module_title,
    this.module_thumbnail,
    this.remarks,
    this.extra,
    this.create_user,
    this.update_user,
  });

  factory CourseModuleModel.fromJson(Map<String, dynamic> json) {
    return CourseModuleModel(
      id: json['id'] as int,
      course: CourseMasterModel.fromJson(
        json['course'] as Map<String, dynamic>,
      ),
      course_id: json['course_id'] as int,
      create_date: json['create_date'] as String? ?? '',
      update_date: json['update_date'] as String? ?? '',
      record_status: json['record_status'] as String? ?? '',
      module_title: json['module_title'] as String? ?? '',
      module_thumbnail: json['module_thumbnail'] as String?,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course.toJson(),
      'course_id': course_id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'module_title': module_title,
      'module_thumbnail': module_thumbnail,
      'remarks': remarks,
      'extra': extra,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

/// =============================
/// NESTED "course" (CourseMaster)
/// =============================
class CourseMasterModel {
  final int id;
  final String create_date;
  final String update_date;
  final String record_status;
  final String CourseMaster_title;
  final String CourseMaster_tumbimage;
  final String CourseMaster_duration;
  final String CourseMaster_duration_unit;
  final String slug;
  final String Description;
  final int CourseMaster_topcourse;
  final double CourseMaster_fee;
  final String Video_img;
  final String course_text;
  final String CourseMaster_rating;
  final String course_lesson;
  final String course_level;
  final int status;
  final String Language;
  final String Number_of_students;
  final String Course_img;
  final String? certificate_text;
  final String? certificate_img;
  final String Quizzes;
  final bool is_enroll;
  final String? remarks;
  final String? extra;
  final int? create_user;
  final int? update_user;
  final int CourseMaster_courseCat;
  final int CourseMaster_Courseinstructor;
  final int courseMaster_detail_id;

  CourseMasterModel({
    required this.id,
    required this.create_date,
    required this.update_date,
    required this.record_status,
    required this.CourseMaster_title,
    required this.CourseMaster_tumbimage,
    required this.CourseMaster_duration,
    required this.CourseMaster_duration_unit,
    required this.slug,
    required this.Description,
    required this.CourseMaster_topcourse,
    required this.CourseMaster_fee,
    required this.Video_img,
    required this.course_text,
    required this.CourseMaster_rating,
    required this.course_lesson,
    required this.course_level,
    required this.status,
    required this.Language,
    required this.Number_of_students,
    required this.Course_img,
    this.certificate_text,
    this.certificate_img,
    required this.Quizzes,
    required this.is_enroll,
    this.remarks,
    this.extra,
    this.create_user,
    this.update_user,
    required this.CourseMaster_courseCat,
    required this.CourseMaster_Courseinstructor,
    required this.courseMaster_detail_id,
  });

  factory CourseMasterModel.fromJson(Map<String, dynamic> json) {
    return CourseMasterModel(
      id: json['id'] as int,
      create_date: json['create_date'] as String? ?? '',
      update_date: json['update_date'] as String? ?? '',
      record_status: json['record_status'] as String? ?? '',
      CourseMaster_title: json['CourseMaster_title'] as String? ?? '',
      CourseMaster_tumbimage:
      json['CourseMaster_tumbimage'] as String? ?? '',
      CourseMaster_duration:
      json['CourseMaster_duration'] as String? ?? '',
      CourseMaster_duration_unit:
      json['CourseMaster_duration_unit'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      Description: json['Description'] as String? ?? '',
      CourseMaster_topcourse: json['CourseMaster_topcourse'] as int? ?? 0,
      CourseMaster_fee:
      (json['CourseMaster_fee'] as num?)?.toDouble() ?? 0.0,
      Video_img: json['Video_img'] as String? ?? '',
      course_text: json['course_text'] as String? ?? '',
      CourseMaster_rating:
      json['CourseMaster_rating'] as String? ?? '',
      course_lesson: json['course_lesson'] as String? ?? '',
      course_level: json['course_level'] as String? ?? '',
      status: json['status'] as int? ?? 0,
      Language: json['Language'] as String? ?? '',
      Number_of_students:
      json['Number_of_students'] as String? ?? '',
      Course_img: json['Course_img'] as String? ?? '',
      certificate_text: json['certificate_text'] as String?,
      certificate_img: json['certificate_img'] as String?,
      Quizzes: json['Quizzes'] as String? ?? '',
      is_enroll: json['is_enroll'] as bool? ?? false,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
      CourseMaster_courseCat:
      json['CourseMaster_courseCat'] as int? ?? 0,
      CourseMaster_Courseinstructor:
      json['CourseMaster_Courseinstructor'] as int? ?? 0,
      courseMaster_detail_id:
      json['courseMaster_detail_id'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'CourseMaster_title': CourseMaster_title,
      'CourseMaster_tumbimage': CourseMaster_tumbimage,
      'CourseMaster_duration': CourseMaster_duration,
      'CourseMaster_duration_unit': CourseMaster_duration_unit,
      'slug': slug,
      'Description': Description,
      'CourseMaster_topcourse': CourseMaster_topcourse,
      'CourseMaster_fee': CourseMaster_fee,
      'Video_img': Video_img,
      'course_text': course_text,
      'CourseMaster_rating': CourseMaster_rating,
      'course_lesson': course_lesson,
      'course_level': course_level,
      'status': status,
      'Language': Language,
      'Number_of_students': Number_of_students,
      'Course_img': Course_img,
      'certificate_text': certificate_text,
      'certificate_img': certificate_img,
      'Quizzes': Quizzes,
      'is_enroll': is_enroll,
      'remarks': remarks,
      'extra': extra,
      'create_user': create_user,
      'update_user': update_user,
      'CourseMaster_courseCat': CourseMaster_courseCat,
      'CourseMaster_Courseinstructor': CourseMaster_Courseinstructor,
      'courseMaster_detail_id': courseMaster_detail_id,
    };
  }
}
