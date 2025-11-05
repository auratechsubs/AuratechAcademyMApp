class CartListResponse {
  final String? message;
  final List<CartItem>? data;

  CartListResponse({
    this.message,
    this.data,
  });

  factory CartListResponse.fromJson(Map<String, dynamic> json) {
    return CartListResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => CartItem.fromJson(item))
          .toList(),
    );
  }
}

class CartItem {
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

  CartItem({
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

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      id: json['id'] as int?,
      quantity: json['quantity'] as int?,
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      courseImg: json['course_img'] as String?,
      courseName: json['course_name'] as String?,
      coursePrice: (json['course_price'] as num?)?.toDouble(),
      totalPrice: (json['total_price'] as num?)?.toDouble(),
      slug: json['slug'] as String?,
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
      id: json['id'] as int?,
      createDate: json['create_date'] as String?,
      updateDate: json['update_date'] as String?,
      recordStatus: json['record_status'] as String?,
      userImg: json['user_img'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      firstName: json['first_name'] as String?,
      lastName: json['last_name'] as String?,
      mobileNo: json['mobile_no'] as String?,
      userGender: json['user_gender'] as String?,
      status: json['status'] as int?,
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }
}
