class CourseCategoryResponse {
  final String message;
  final List<CourseCategoryModel> data;

  CourseCategoryResponse({
    required this.message,
    required this.data,
  });

  factory CourseCategoryResponse.fromJson(Map<String, dynamic> json) {
    return CourseCategoryResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => CourseCategoryModel.fromJson(e))
          .toList(),
    );
  }
}

class CourseCategoryModel {
  final int id;
  final CourseSugment courseSugment;
  final String createDate;
  final String updateDate;
  final String recordStatus;
  final String categoryName;
  final String categoryIcon;
  final int itemStockValue;

  CourseCategoryModel({
    required this.id,
    required this.courseSugment,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.categoryName,
    required this.categoryIcon,
    required this.itemStockValue,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] ?? 0,
      courseSugment: json['coursesugment'] != null
          ? CourseSugment.fromJson(json['coursesugment'])
          : CourseSugment.empty(),
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      categoryName: json['category_name'] ?? '',
      categoryIcon: json['category_icon'] ?? '',
      itemStockValue: json['item_stock_value'] ?? 0,
    );
  }
}

class CourseSugment {
  final int id;
  final String createDate;
  final String updateDate;
  final String recordStatus;
  final String name;

  CourseSugment({
    required this.id,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.name,
  });

  factory CourseSugment.fromJson(Map<String, dynamic> json) {
    return CourseSugment(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      name: json['name'] ?? '',
    );
  }

  factory CourseSugment.empty() {
    return CourseSugment(
      id: 0,
      createDate: '',
      updateDate: '',
      recordStatus: '',
      name: '',
    );
  }
}
