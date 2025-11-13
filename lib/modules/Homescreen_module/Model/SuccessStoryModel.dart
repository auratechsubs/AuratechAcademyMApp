// success_story_model.dart

class SuccessStoryResponseModel {
  final String? message;
  final List<SuccessStoryModel>? data;

  SuccessStoryResponseModel({this.message, this.data});

  factory SuccessStoryResponseModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryResponseModel(
      message: json['message'] as String?,
      data: json['data'] != null
          ? List<SuccessStoryModel>.from(
        (json['data'] as List).map((e) => SuccessStoryModel.fromJson(e)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class SuccessStoryModel {
  final int? id;
  final CourseMasterModel? course;
  final int? courseId;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? name;
  final String? placement;
  final String? package;
  final String? description;
  final String? remarks;
  final String? extra;
  final int? createUser;
  final int? updateUser;

  SuccessStoryModel({
    this.id,
    this.course,
    this.courseId,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.name,
    this.placement,
    this.package,
    this.description,
    this.remarks,
    this.extra,
    this.createUser,
    this.updateUser,
  });

  factory SuccessStoryModel.fromJson(Map<String, dynamic> json) {
    return SuccessStoryModel(
      id: json['id'] as int?,
      course: json['course'] != null
          ? CourseMasterModel.fromJson(json['course'])
          : null,
      courseId: json['course_id'] as int?,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      name: json['name'] as String?,
      placement: json['placement'] as String?,
      package: json['package'] as String?,
      description: json['description'] as String?,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      createUser: json['create_user'] as int?,
      updateUser: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'course': course?.toJson(),
    'course_id': courseId,
    'create_date': createDate,
    'update_date': updateDate,
    'record_status': recordStatus,
    'name': name,
    'placement': placement,
    'package': package,
    'description': description,
    'remarks': remarks,
    'extra': extra,
    'create_user': createUser,
    'update_user': updateUser,
  };
}

class CourseMasterModel {
  final int? id;
  final CourseCategoryModel? courseCategory; // CourseMaster_courseCat
  final CourseInstructorModel? courseInstructor; // CourseMaster_Courseinstructor
  final CourseDetailModel? courseDetail; // courseMaster_detail_id

  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? title; // CourseMaster_title
  final String? thumbImage; // CourseMaster_tumbimage
  final String? duration; // CourseMaster_duration
  final String? durationUnit; // CourseMaster_duration_unit
  final String? slug;
  final String? description;
  final int? topCourse; // CourseMaster_topcourse
  final double? fee; // CourseMaster_fee
  final String? videoImg;
  final String? courseText;
  final String? rating; // CourseMaster_rating
  final String? lesson; // course_lesson
  final String? level; // course_level
  final int? status;
  final String? language;
  final String? numberOfStudents; // Number_of_students
  final String? courseImg; // Course_img
  final String? quizzes; // Quizzes
  final dynamic isEnroll;
  final int? createUser;
  final int? updateUser;

  CourseMasterModel({
    this.id,
    this.courseCategory,
    this.courseInstructor,
    this.courseDetail,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.title,
    this.thumbImage,
    this.duration,
    this.durationUnit,
    this.slug,
    this.description,
    this.topCourse,
    this.fee,
    this.videoImg,
    this.courseText,
    this.rating,
    this.lesson,
    this.level,
    this.status,
    this.language,
    this.numberOfStudents,
    this.courseImg,
    this.quizzes,
    this.isEnroll,
    this.createUser,
    this.updateUser,
  });

  factory CourseMasterModel.fromJson(Map<String, dynamic> json) {
    return CourseMasterModel(
      id: json['id'] as int?,
      courseCategory: json['CourseMaster_courseCat'] != null
          ? CourseCategoryModel.fromJson(json['CourseMaster_courseCat'])
          : null,
      courseInstructor: json['CourseMaster_Courseinstructor'] != null
          ? CourseInstructorModel.fromJson(json['CourseMaster_Courseinstructor'])
          : null,
      courseDetail: json['courseMaster_detail_id'] != null
          ? CourseDetailModel.fromJson(json['courseMaster_detail_id'])
          : null,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      title: json['CourseMaster_title'] as String?,
      thumbImage: json['CourseMaster_tumbimage'] as String?,
      duration: json['CourseMaster_duration'] as String?,
      durationUnit: json['CourseMaster_duration_unit'] as String?,
      slug: json['slug'] as String?,
      description: json['Description'] as String?,
      topCourse: json['CourseMaster_topcourse'] as int?,
      fee: (json['CourseMaster_fee'] is num)
          ? (json['CourseMaster_fee'] as num).toDouble()
          : null,
      videoImg: json['Video_img'] as String?,
      courseText: json['course_text'] as String?,
      rating: json['CourseMaster_rating'] as String?,
      lesson: json['course_lesson'] as String?,
      level: json['course_level'] as String?,
      status: json['status'] as int?,
      language: json['Language'] as String?,
      numberOfStudents: json['Number_of_students'] as String?,
      courseImg: json['Course_img'] as String?,
      quizzes: json['Quizzes'] as String?,
      isEnroll: json['is_enroll'],
      createUser: json['create_user'] as int?,
      updateUser: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'CourseMaster_courseCat': courseCategory?.toJson(),
    'CourseMaster_Courseinstructor': courseInstructor?.toJson(),
    'courseMaster_detail_id': courseDetail?.toJson(),
    'create_date': createDate,
    'update_date': updateDate,
    'record_status': recordStatus,
    'CourseMaster_title': title,
    'CourseMaster_tumbimage': thumbImage,
    'CourseMaster_duration': duration,
    'CourseMaster_duration_unit': durationUnit,
    'slug': slug,
    'Description': description,
    'CourseMaster_topcourse': topCourse,
    'CourseMaster_fee': fee,
    'Video_img': videoImg,
    'course_text': courseText,
    'CourseMaster_rating': rating,
    'course_lesson': lesson,
    'course_level': level,
    'status': status,
    'Language': language,
    'Number_of_students': numberOfStudents,
    'Course_img': courseImg,
    'Quizzes': quizzes,
    'is_enroll': isEnroll,
    'create_user': createUser,
    'update_user': updateUser,
  };
}

class CourseCategoryModel {
  final int? id;
  final CourseSegmentModel? coursesegment; // coursesugment
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? categoryName;
  final String? categoryIcon;
  final int? itemStockValue;
  final int? createUser;
  final int? updateUser;

  CourseCategoryModel({
    this.id,
    this.coursesegment,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.categoryName,
    this.categoryIcon,
    this.itemStockValue,
    this.createUser,
    this.updateUser,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] as int?,
      coursesegment: json['coursesugment'] != null
          ? CourseSegmentModel.fromJson(json['coursesugment'])
          : null,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      categoryName: json['category_name'] as String?,
      categoryIcon: json['category_icon'] as String?,
      itemStockValue: json['item_stock_value'] as int?,
      createUser: json['create_user'] as int?,
      updateUser: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'coursesugment': coursesegment?.toJson(),
    'create_date': createDate,
    'update_date': updateDate,
    'record_status': recordStatus,
    'category_name': categoryName,
    'category_icon': categoryIcon,
    'item_stock_value': itemStockValue,
    'create_user': createUser,
    'update_user': updateUser,
  };
}

class CourseSegmentModel {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? name;
  final int? createUser;
  final int? updateUser;

  CourseSegmentModel({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.name,
    this.createUser,
    this.updateUser,
  });

  factory CourseSegmentModel.fromJson(Map<String, dynamic> json) {
    return CourseSegmentModel(
      id: json['id'] as int?,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      name: json['name'] as String?,
      createUser: json['create_user'] as int?,
      updateUser: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'create_date': createDate,
    'update_date': updateDate,
    'record_status': recordStatus,
    'name': name,
    'create_user': createUser,
    'update_user': updateUser,
  };
}

class CourseInstructorModel {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? name; // CourseInstructor_name
  final String? slug;
  final String? designation; // CourseInstructor_desig
  final String? shortBio; // CourseInstructor_shortbio
  final String? email;
  final String? mobileNo; // CourseInstructor_mobile_no
  final String? biography;
  final String? educationQualification;
  final String? facebookUrl;
  final String? twitterUrl;
  final String? instagramUrl;
  final String? youtubeUrl;
  final String? linkedinUrl;
  final String? image; // CourseInstructor_image
  final double? rating; // CourseInstructor_rating
  final double? experience; // CourseInstructor_Experience
  final int? status;
  final String? sml; // CourseInstructor_sml
  final int? createUser;
  final int? updateUser;

  CourseInstructorModel({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.name,
    this.slug,
    this.designation,
    this.shortBio,
    this.email,
    this.mobileNo,
    this.biography,
    this.educationQualification,
    this.facebookUrl,
    this.twitterUrl,
    this.instagramUrl,
    this.youtubeUrl,
    this.linkedinUrl,
    this.image,
    this.rating,
    this.experience,
    this.status,
    this.sml,
    this.createUser,
    this.updateUser,
  });

  factory CourseInstructorModel.fromJson(Map<String, dynamic> json) {
    return CourseInstructorModel(
      id: json['id'] as int?,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      name: json['CourseInstructor_name'] as String?,
      slug: json['slug'] as String?,
      designation: json['CourseInstructor_desig'] as String?,
      shortBio: json['CourseInstructor_shortbio'] as String?,
      email: json['CourseInstructor_email'] as String?,
      mobileNo: json['CourseInstructor_mobile_no'] as String?,
      biography: json['Biography'] as String?,
      educationQualification:
      json['Education_qualification'] as String?,
      facebookUrl:
      json['CourseInstructor_facebook_url'] as String?,
      twitterUrl:
      json['CourseInstructor_twitter_url'] as String?,
      instagramUrl:
      json['CourseInstructor_instagram_url'] as String?,
      youtubeUrl:
      json['CourseInstructor_youtube_url'] as String?,
      linkedinUrl:
      json['CourseInstructor_linkedin_url'] as String?,
      image: json['CourseInstructor_image'] as String?,
      rating: (json['CourseInstructor_rating'] is num)
          ? (json['CourseInstructor_rating'] as num).toDouble()
          : null,
      experience: (json['CourseInstructor_Experience'] is num)
          ? (json['CourseInstructor_Experience'] as num).toDouble()
          : null,
      status: json['status'] as int?,
      sml: json['CourseInstructor_sml'] as String?,
      createUser: json['create_user'] as int?,
      updateUser: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'create_date': createDate,
    'update_date': updateDate,
    'record_status': recordStatus,
    'CourseInstructor_name': name,
    'slug': slug,
    'CourseInstructor_desig': designation,
    'CourseInstructor_shortbio': shortBio,
    'CourseInstructor_email': email,
    'CourseInstructor_mobile_no': mobileNo,
    'Biography': biography,
    'Education_qualification': educationQualification,
    'CourseInstructor_facebook_url': facebookUrl,
    'CourseInstructor_twitter_url': twitterUrl,
    'CourseInstructor_instagram_url': instagramUrl,
    'CourseInstructor_youtube_url': youtubeUrl,
    'CourseInstructor_linkedin_url': linkedinUrl,
    'CourseInstructor_image': image,
    'CourseInstructor_rating': rating,
    'CourseInstructor_Experience': experience,
    'status': status,
    'CourseInstructor_sml': sml,
    'create_user': createUser,
    'update_user': updateUser,
  };
}

class CourseDetailModel {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? certification;
  final String? whatYouLearn;
  final String? curriculum;
  final int? createUser;
  final int? updateUser;

  CourseDetailModel({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.certification,
    this.whatYouLearn,
    this.curriculum,
    this.createUser,
    this.updateUser,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json['id'] as int?,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      certification: json['Certification'] as String?,
      whatYouLearn: json['Whatyoulearn'] as String?,
      curriculum: json['Curriculam'] as String?,
      createUser: json['create_user'] as int?,
      updateUser: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'create_date': createDate,
    'update_date': updateDate,
    'record_status': recordStatus,
    'Certification': certification,
    'Whatyoulearn': whatYouLearn,
    'Curriculam': curriculum,
    'create_user': createUser,
    'update_user': updateUser,
  };
}
