class OrderResponseModel {
  final String? message;
  final OrderData? data;

  OrderResponseModel({this.message, this.data});

  factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderResponseModel(
      message: json['message'],
      data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
    );
  }
}

class OrderData {
  final int? id;
  final User? user;
  final List<CartItem>? cartItems;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? firstName;
  final String? lastName;
  final String? countryName;
  final String? companyName;
  final String? streetAddress;
  final String? apartmentNo;
  final String? city;
  final String? postcode;
  final String? emailAddress;
  final String? phoneNo;
  final String? orderDate;
  final dynamic createUser;
  final dynamic updateUser;

  OrderData({
    this.id,
    this.user,
    this.cartItems,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.firstName,
    this.lastName,
    this.countryName,
    this.companyName,
    this.streetAddress,
    this.apartmentNo,
    this.city,
    this.postcode,
    this.emailAddress,
    this.phoneNo,
    this.orderDate,
    this.createUser,
    this.updateUser,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      user: json['User_id'] != null ? User.fromJson(json['User_id']) : null,
      cartItems: json['cartitems'] != null
          ? List<CartItem>.from(
          json['cartitems'].map((item) => CartItem.fromJson(item)))
          : [],
      createDate: json['create_date'],
      updateDate: json['update_date'],
      recordStatus: json['record_status'],
      firstName: json['First_name'],
      lastName: json["Last_name"] ?? json["Lirst_name"],
      countryName: json['Country_name'],
      companyName: json['your_company_name'],
      streetAddress: json['street_address'],
      apartmentNo: json['Apartment_no'],
      city: json['city'],
      postcode: json['postcode'],
      emailAddress: json['Email_address'],
      phoneNo: json['phone_no'],
      orderDate: json['order_date'],
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
      id: json['id'],
      createDate: json['create_date'],
      updateDate: json['update_date'],
      recordStatus: json['record_status'],
      userImg: json['user_img'],
      email: json['email'],
      password: json['password'],
      firstName: json['first_name'],
      lastName: json["Last_name"] ?? json["Lirst_name"],
      mobileNo: json['mobile_no'],
      userGender: json['user_gender'],
      status: json['status'],
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }
}

class CartItem {
  final String? courseId;
  final String? courseName;
  final String? courseImg;
  final String? coursePrice;
  final String? quantity;
  final double? totalPrice;

  CartItem({
    this.courseId,
    this.courseName,
    this.courseImg,
    this.coursePrice,
    this.quantity,
    this.totalPrice,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      courseId: json['course_id'],
      courseName: json['course_name'],
      courseImg: json['course_img'],
      coursePrice: json['course_price'],
      quantity: json['quantity'],
      totalPrice: (json['total_price'] as num?)?.toDouble(),
    );
  }
}
