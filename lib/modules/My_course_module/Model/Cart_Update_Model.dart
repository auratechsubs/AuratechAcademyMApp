class CartUpdateResponse {
  final String? message;
  final CartData? data;

  CartUpdateResponse({this.message, this.data});

  factory CartUpdateResponse.fromJson(Map<String, dynamic> json) {
    return CartUpdateResponse(
      message: json['message'],
      data: json['data'] != null ? CartData.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
    };
  }
}

class CartData {
  final int? id;
    int? quantity;
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

  factory CartData.fromJson(Map<String, dynamic> json) {
    return CartData(
      id: json['id'],
      quantity: json['quantity'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createDate: json['create_date'],
      updateDate: json['update_date'],
      recordStatus: json['record_status'],
      courseImg: json['course_img'],
      courseName: json['course_name'],
      coursePrice: (json['course_price'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      slug: json['slug'],
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'quantity': quantity,
      'user': user?.toJson(),
      'create_date': createDate,
      'update_date': updateDate,
      'record_status': recordStatus,
      'course_img': courseImg,
      'course_name': courseName,
      'course_price': coursePrice,
      'total_price': totalPrice,
      'slug': slug,
      'create_user': createUser,
      'update_user': updateUser,
    };
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
      id: json['id'],
      createDate: json['create_date'],
      updateDate: json['update_date'],
      recordStatus: json['record_status'],
      userImg: json['user_img'],
      email: json['email'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      mobileNo: json['mobile_no'],
      userGender: json['user_gender'],
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
      'user_img': userImg,
      'email': email,
      'password': password,
      'first_name': firstName,
      'last_name': lastName,
      'mobile_no': mobileNo,
      'user_gender': userGender,
      'status': status,
      'create_user': createUser,
      'update_user': updateUser,
    };
  }
}
