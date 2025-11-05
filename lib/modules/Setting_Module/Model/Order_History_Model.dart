class OrderHistoryResponse {
  final String? message;
  final List<OrderData>? data;

  OrderHistoryResponse({this.message, this.data});

  factory OrderHistoryResponse.fromJson(Map<String, dynamic> json) {
    return OrderHistoryResponse(
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderData.fromJson(e))
          .toList(),
    );
  }
}

class OrderData {
  final int? id;
  final OrderID? orderId;
  final User? userId;
  final String? courseId;
  final String? courseImg;
  final String? courseName;
  final String? coursePrice;
  final String? quantity;
  final double? totalPrice;

  OrderData({
    this.id,
    this.orderId,
    this.userId,
    this.courseId,
    this.courseImg,
    this.courseName,
    this.coursePrice,
    this.quantity,
    this.totalPrice,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      id: json['id'],
      orderId: json['order_id'] != null ? OrderID.fromJson(json['order_id']) : null,
      userId: json['user_id'] != null ? User.fromJson(json['user_id']) : null,
      courseId: json['course_id'],
      courseImg: json['course_img'],
      courseName: json['course_name'],
      coursePrice: json['course_price'],
      quantity: json['quantity'],
      totalPrice: (json['total_price'] as num?)?.toDouble(),
    );
  }
}

class OrderID {
  final int? id;
  final User? user;
  final List<CartItem>? cartItems;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? firstName;
  final String? lastName;
  final String? countryName;
  final String? yourCompanyName;
  final String? streetAddress;
  final String? apartmentNo;
  final String? city;
  final String? postcode;
  final String? emailAddress;
  final String? phoneNo;
  final String? orderDate;

  OrderID({
    this.id,
    this.user,
    this.cartItems,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.firstName,
    this.lastName,
    this.countryName,
    this.yourCompanyName,
    this.streetAddress,
    this.apartmentNo,
    this.city,
    this.postcode,
    this.emailAddress,
    this.phoneNo,
    this.orderDate,
  });

  factory OrderID.fromJson(Map<String, dynamic> json) {
    return OrderID(
      id: json['id'],
      user: json['User_id'] != null ? User.fromJson(json['User_id']) : null,
      cartItems: (json['cartitems'] as List<dynamic>?)
          ?.map((e) => CartItem.fromJson(e))
          .toList(),
      createDate: json['create_date'],
      updateDate: json['update_date'],
      recordStatus: json['record_status'],
      firstName: json['First_name'],
      lastName: json['Lirst_name'],
      countryName: json['Country_name'],
      yourCompanyName: json['your_company_name'],
      streetAddress: json['street_address'],
      apartmentNo: json['Apartment_no'],
      city: json['city'],
      postcode: json['postcode'],
      emailAddress: json['Email_address'],
      phoneNo: json['phone_no'],
      orderDate: json['order_date'],
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
