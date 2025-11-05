class CourseFaqModel {
  final String? message;
  final List<FaqItem>? data;

  CourseFaqModel({
    this.message,
    this.data,
  });

  factory CourseFaqModel.fromJson(Map<String, dynamic> json) {
    return CourseFaqModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => FaqItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }

  @override
  String toString() {
    return 'CourseFaqModel(message: $message, data: ${data?.map((e) => e.toString()).toList()})';
  }
}

class FaqItem {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final dynamic courseFaqCourse;
  final String? courseFaqQue;
  final String? courseFaqAns;
  final dynamic status;
  final dynamic createUser;
  final dynamic updateUser;

  FaqItem({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.courseFaqCourse,
    this.courseFaqQue,
    this.courseFaqAns,
    this.status,
    this.createUser,
    this.updateUser,
  });

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      id: json['id'] as int?,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      courseFaqCourse: json['courseFaq_course'],
      courseFaqQue: json['courseFaq_Que'] as String?,
      courseFaqAns: json['courseFaq_Ans'] as String?,
      status: json['status'],
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': createDate,
      'update_date': updateDate,
      'record_status': recordStatus,
      'courseFaq_course': courseFaqCourse,
      'courseFaq_Que': courseFaqQue,
      'courseFaq_Ans': courseFaqAns,
      'status': status,
      'create_user': createUser,
      'update_user': updateUser,
    };
  }

  @override
  String toString() {
    return 'FaqItem(id: $id, question: $courseFaqQue, answer: $courseFaqAns)';
  }
}

