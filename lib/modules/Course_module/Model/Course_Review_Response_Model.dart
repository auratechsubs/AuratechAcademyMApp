class CourseReviewResponse {
  final String? message;
  final List<CourseReview>? data;

  CourseReviewResponse({this.message, this.data});

  factory CourseReviewResponse.fromJson(Map<String, dynamic> json) {
    return CourseReviewResponse(
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => CourseReview.fromJson(e))
          .toList(),
    );
  }
}

class CourseReview {
  final int? id;
  final int? rating;
  final String? review;
  final String? createdAt;
  final CourseData? course;
  final Instructor? instructor;
  final UserData? user;

  CourseReview({
    this.id,
    this.rating,
    this.review,
    this.createdAt,
    this.course,
    this.instructor,
    this.user,
  });

  factory CourseReview.fromJson(Map<String, dynamic> json) {
    return CourseReview(
      id: json['id'],
      rating: json['rating'],
      review: json['review'],
      createdAt: json['created_at'],
      course: json['course'] != null ? CourseData.fromJson(json['course']) : null,
      instructor: json['instructor'] != null ? Instructor.fromJson(json['instructor']) : null,
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
    );
  }
}

class CourseData {
  final int? id;
  final String? name;
  final String? thumbnail;

  CourseData({this.id, this.name, this.thumbnail});

  factory CourseData.fromJson(Map<String, dynamic> json) {
    return CourseData(
      id: json['id'],
      name: json['name'],
      thumbnail: json['thumbnail'],
    );
  }
}

class Instructor {
  final int? id;
  final String? fullName;
  final String? profileImage;

  Instructor({this.id, this.fullName, this.profileImage});

  factory Instructor.fromJson(Map<String, dynamic> json) {
    return Instructor(
      id: json['id'],
      fullName: json['full_name'],
      profileImage: json['profile_image'],
    );
  }
}

class UserData {
  final int? id;
  final String? username;
  final String? profilePic;

  UserData({this.id, this.username, this.profilePic});

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'],
      username: json['username'],
      profilePic: json['profile_pic'],
    );
  }
}
