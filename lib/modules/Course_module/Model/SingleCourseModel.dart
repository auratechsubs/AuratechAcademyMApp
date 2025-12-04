import 'Course_Master_Model.dart';

class SingleCourseModel {
  final String message;
  final CourseMaster? data;

  SingleCourseModel({
    required this.message,
    required this.data,
  });

  factory SingleCourseModel.fromJson(Map<String, dynamic> json) {
    return SingleCourseModel(
      message: json['message'] ?? '',
      data: CourseMaster.fromJson(json['data'] ?? {}),
    );
  }
}
