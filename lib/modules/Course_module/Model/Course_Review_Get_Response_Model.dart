class CourseReview {
  final int? id;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? recordStatus;
  final String? name;
  final String? email;
  final String? remark;
  final int? status;
  final int? createUser;
  final int? updateUser;
  final int? userId;
  final User? user;
  final Course? course;
  final double? rating;

  CourseReview({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.name,
    this.email,
    this.remark,
    this.status,
    this.createUser,
    this.updateUser,
    this.userId,
    this.user,
    this.course,
    this.rating,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) {
    return CourseReview(
      id: json['id'],
      user: json['CourseRevie_user'] != null
          ? User.fromJson(json['CourseRevie_user'])
          : null,
      course: json['CourseReview_course'] != null
          ? Course.fromJson(json['CourseReview_course'])
          : null,
      remark: json['CourseReview_remark'],
      rating: json['CourseReview_rating'],
      // ... other fields
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': createDate?.toIso8601String(),
      'update_date': updateDate?.toIso8601String(),
      'record_status': recordStatus,
      'CourseReview_name': name,
      'CourseReview_email': email,
      'CourseReview_remark': remark,
      'status': status,
      'create_user': createUser,
      'update_user': updateUser,
      'CourseRevie_user_id': userId,
      'CourseRevie_user': user?.toJson(),
      'course': course?.toJson(),
      'rating': rating,
    };
  }




}

class User {
  final int? id;
  final String? firstName;
  final String? lastName;
  final String? profilePic;

  User({this.id, this.firstName, this.lastName, this.profilePic});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      profilePic: json['user_img'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'first_name': firstName,
    'last_name': lastName,
    'user_img': profilePic,
  };
}


class Course {
  final int? id;
  final String? name;

  Course({this.id, this.name});

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'],
      name: json['course_name'] ?? json['name'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'course_name': name,
  };
}
