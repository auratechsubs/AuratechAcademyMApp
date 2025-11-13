// course_segment_model.dart

class CourseSegmentResponse {
  final String? message;
  final List<CourseSegment>? data;

  CourseSegmentResponse({this.message, this.data});

  factory CourseSegmentResponse.fromJson(Map<String, dynamic> json) {
    return CourseSegmentResponse(
      message: json['message'] as String?,
      data: json['data'] != null
          ? List<CourseSegment>.from(
          (json['data'] as List).map((e) => CourseSegment.fromJson(e)))
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class CourseSegment {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? name;
  final int? createUser;
  final int? updateUser;

  CourseSegment({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.name,
    this.createUser,
    this.updateUser,
  });

  factory CourseSegment.fromJson(Map<String, dynamic> json) {
    return CourseSegment(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      name: json['name'] ?? '',
      createUser: json['create_user'] ?? 0,
      updateUser: json['update_user'] ?? 0,
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
