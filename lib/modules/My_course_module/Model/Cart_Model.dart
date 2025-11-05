// class CartModel {
//   final String message;
//   final CartData data;
//
//   CartModel({required this.message, required this.data});
//
//   factory CartModel.fromJson(Map<String, dynamic> json) {
//     return CartModel(
//       message: json['message'],
//       data: CartData.fromJson(json['data']),
//     );
//   }
// }
//
// class CartData {
//   final int id;
//   final int quantity;
//   final User user;
//   final String createDate;
//   final String updateDate;
//   final String recordStatus;
//   final String? courseImg;
//   final String courseName;
//   final double coursePrice;
//   final double totalPrice;
//   final String slug;
//   final dynamic createUser;
//   final dynamic updateUser;
//
//   CartData({
//     required this.id,
//     required this.quantity,
//     required this.user,
//     required this.createDate,
//     required this.updateDate,
//     required this.recordStatus,
//     required this.courseImg,
//     required this.courseName,
//     required this.coursePrice,
//     required this.totalPrice,
//     required this.slug,
//     this.createUser,
//     this.updateUser,
//   });
//
//   factory CartData.fromJson(Map<String, dynamic> json) {
//     return CartData(
//       id: json['id'],
//       quantity: json['quantity'],
//       user: User.fromJson(json['user']),
//       createDate: json['create_date'],
//       updateDate: json['update_date'],
//       recordStatus: json['record_status'],
//       courseImg: json['course_img'],
//       courseName: json['course_name'],
//       coursePrice: (json['course_price'] ?? 0).toDouble(),
//       totalPrice: (json['total_price'] ?? 0).toDouble(),
//       slug: json['slug'],
//       createUser: json['create_user'],
//       updateUser: json['update_user'],
//     );
//   }
// }
//
// class User {
//   final int id;
//   final String createDate;
//   final String updateDate;
//   final String recordStatus;
//   final String? userImg;
//   final String email;
//   final String password;
//   final String firstName;
//   final String lastName;
//   final String mobileNo;
//   final String userGender;
//   final int status;
//   final dynamic createUser;
//   final dynamic updateUser;
//
//   User({
//     required this.id,
//     required this.createDate,
//     required this.updateDate,
//     required this.recordStatus,
//     this.userImg,
//     required this.email,
//     required this.password,
//     required this.firstName,
//     required this.lastName,
//     required this.mobileNo,
//     required this.userGender,
//     required this.status,
//     this.createUser,
//     this.updateUser,
//   });
//
//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       id: json['id'],
//       createDate: json['create_date'],
//       updateDate: json['update_date'],
//       recordStatus: json['record_status'],
//       userImg: json['user_img'],
//       email: json['email'],
//       password: json['password'],
//       firstName: json['first_name'],
//       lastName: json['last_name'],
//       mobileNo: json['mobile_no'],
//       userGender: json['user_gender'],
//       status: json['status'],
//       createUser: json['create_user'],
//       updateUser: json['update_user'],
//     );
//   }
// }



import 'dart:core';

class CartModel {
  final String? message;
  final CartData? data;
  CartModel({this.message, this.data});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      message: json['message']?.toString(),
      data: (json['data'] is Map<String, dynamic>)
          ? CartData.fromJson(json['data'] as Map<String, dynamic>)
          : null,
    );
  }
}

class CartData {
  final int? id;
  final int? quantity;
  final User? user;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? courseImg;
  final String? courseName;
  final double? coursePrice;
  final double? totalPrice;
  final String? slug;
  final dynamic createUser;
  final dynamic updateUser;

  CartData({
    this.id,
    this.quantity,
    this.user,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.courseImg,
    this.courseName,
    this.coursePrice,
    this.totalPrice,
    this.slug,
    this.createUser,
    this.updateUser,
  });

  // factory CartData.fromJson(Map<String, dynamic> json) {
  //   num? num(dynamic v) => v is num ? v : (v is String ? num.tryParse(v) : null);
  //
  //   return CartData(
  //     id: (json['id'] as num?)?.toInt(),
  //     quantity: (json['quantity'] as num?)?.toInt(),
  //     user: (json['user'] is Map<String, dynamic>)
  //         ? User.fromJson(json['user'] as Map<String, dynamic>)
  //         : null,
  //     createDate: json['create_date']?.toString(),
  //     updateDate: json['update_date']?.toString(),
  //     recordStatus: json['record_status']?.toString(),
  //     courseImg: json['course_img']?.toString(),
  //     courseName: json['course_name']?.toString(),
  //     coursePrice: num(json['course_price'])?.toDouble(),
  //     totalPrice: num(json['total_price'])?.toDouble(),
  //     slug: json['slug']?.toString(),
  //     createUser: json['create_user'],
  //     updateUser: json['update_user'],
  //   );
  // }


  factory CartData.fromJson(Map<String, dynamic> json) {
    num? parseNum(dynamic v) =>
        v is num ? v : (v is String ? num.tryParse(v) : null);

    return CartData(
      id: (json['id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      user: (json['user'] is Map<String, dynamic>)
          ? User.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      createDate: json['create_date']?.toString(),
      updateDate: json['update_date']?.toString(),
      recordStatus: json['record_status']?.toString(),
      courseImg: json['course_img']?.toString(),
      courseName: json['course_name']?.toString(),
      coursePrice: parseNum(json['course_price'])?.toDouble(),
      totalPrice: parseNum(json['total_price'])?.toDouble(),
      slug: json['slug']?.toString(),
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }

}

class User {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? userImg;
  final String? email;
  final String? password;
  final String? firstName;
  final String? lastName;
  final String? mobileNo;
  final String? userGender;
  final int? status;
  final dynamic createUser;
  final dynamic updateUser;

  User({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.userImg,
    this.email,
    this.password,
    this.firstName,
    this.lastName,
    this.mobileNo,
    this.userGender,
    this.status,
    this.createUser,
    this.updateUser,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: (json['id'] as num?)?.toInt(),
      createDate: json['create_date']?.toString(),
      updateDate: json['update_date']?.toString(),
      recordStatus: json['record_status']?.toString(),
      userImg: json['user_img']?.toString(),
      email: json['email']?.toString(),
      password: json['password']?.toString(),
      firstName: json['first_name']?.toString(),
      lastName: json['last_name']?.toString(),
      mobileNo: json['mobile_no']?.toString(),
      userGender: json['user_gender']?.toString(),
      status: (json['status'] as num?)?.toInt(),
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }
}
