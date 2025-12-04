// class OrderResponseModel {
//   final String? message;
//   final OrderData? data;
//
//   OrderResponseModel({this.message, this.data});
//
//   factory OrderResponseModel.fromJson(Map<String, dynamic> json) {
//     return OrderResponseModel(
//       message: json['message'],
//       data: json['data'] != null ? OrderData.fromJson(json['data']) : null,
//     );
//   }
// }
//
// class OrderData {
//   final int? id;
//   final User? user;
//   final List<CartItem>? cartItems;
//   final String? createDate;
//   final String? updateDate;
//   final String? recordStatus;
//   final String? firstName;
//   final String? lastName;
//   final String? countryName;
//   final String? companyName;
//   final String? streetAddress;
//   final String? apartmentNo;
//   final String? city;
//   final String? postcode;
//   final String? emailAddress;
//   final String? phoneNo;
//   final String? orderDate;
//   final dynamic createUser;
//   final dynamic updateUser;
//
//   OrderData({
//     this.id,
//     this.user,
//     this.cartItems,
//     this.createDate,
//     this.updateDate,
//     this.recordStatus,
//     this.firstName,
//     this.lastName,
//     this.countryName,
//     this.companyName,
//     this.streetAddress,
//     this.apartmentNo,
//     this.city,
//     this.postcode,
//     this.emailAddress,
//     this.phoneNo,
//     this.orderDate,
//     this.createUser,
//     this.updateUser,
//   });
//
//   factory OrderData.fromJson(Map<String, dynamic> json) {
//     return OrderData(
//       id: json['id'],
//       user: json['User_id'] != null ? User.fromJson(json['User_id']) : null,
//       cartItems: json['cartitems'] != null
//           ? List<CartItem>.from(
//           json['cartitems'].map((item) => CartItem.fromJson(item)))
//           : [],
//       createDate: json['create_date'],
//       updateDate: json['update_date'],
//       recordStatus: json['record_status'],
//       firstName: json['First_name'],
//       lastName: json["Last_name"] ?? json["Lirst_name"],
//       countryName: json['Country_name'],
//       companyName: json['your_company_name'],
//       streetAddress: json['street_address'],
//       apartmentNo: json['Apartment_no'],
//       city: json['city'],
//       postcode: json['postcode'],
//       emailAddress: json['Email_address'],
//       phoneNo: json['phone_no'],
//       orderDate: json['order_date'],
//       createUser: json['create_user'],
//       updateUser: json['update_user'],
//     );
//   }
// }
//
// class User {
//   final int? id;
//   final String? createDate;
//   final String? updateDate;
//   final String? recordStatus;
//   final String? userImg;
//   final String? email;
//   final String? password;
//   final String? firstName;
//   final String? lastName;
//   final String? mobileNo;
//   final String? userGender;
//   final int? status;
//   final dynamic createUser;
//   final dynamic updateUser;
//
//   User({
//     this.id,
//     this.createDate,
//     this.updateDate,
//     this.recordStatus,
//     this.userImg,
//     this.email,
//     this.password,
//     this.firstName,
//     this.lastName,
//     this.mobileNo,
//     this.userGender,
//     this.status,
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
//       lastName: json["Last_name"] ?? json["Lirst_name"],
//       mobileNo: json['mobile_no'],
//       userGender: json['user_gender'],
//       status: json['status'],
//       createUser: json['create_user'],
//       updateUser: json['update_user'],
//     );
//   }
// }
//
// class CartItem {
//   final String? courseId;
//   final String? courseName;
//   final String? courseImg;
//   final String? coursePrice;
//   final String? quantity;
//   final double? totalPrice;
//
//   CartItem({
//     this.courseId,
//     this.courseName,
//     this.courseImg,
//     this.coursePrice,
//     this.quantity,
//     this.totalPrice,
//   });
//
//   factory CartItem.fromJson(Map<String, dynamic> json) {
//     return CartItem(
//       courseId: json['course_id'],
//       courseName: json['course_name'],
//       courseImg: json['course_img'],
//       coursePrice: json['course_price'],
//       quantity: json['quantity'],
//       totalPrice: (json['total_price'] as num?)?.toDouble(),
//     );
//   }
// }





/// new order api response
///
///
///
///
library;
/// new model started from here
// class OrderListResponseModel {
//   final String? message;
//   final List<OrderDataModel>? data;
//
//   OrderListResponseModel({
//     this.message,
//     this.data,
//   });
//
//   factory OrderListResponseModel.fromJson(Map<String, dynamic> json) {
//     return OrderListResponseModel(
//       message: json['message'] as String?,
//       data: (json['data'] as List<dynamic>?)
//           ?.map((e) => OrderDataModel.fromJson(e as Map<String, dynamic>))
//           .toList(),
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'data': data?.map((e) => e.toJson()).toList(),
//     };
//   }
// }
//
// class OrderDataModel {
//   final int? id;
//   final OrderUserModel? user;
//   final int? user_id;
//   final String? create_date;
//   final String? update_date;
//   final String? record_status;
//   final String? date;
//   final String? order_from;
//   final String? item_count;
//   final String? total_qty;
//   final String? total_amt;
//   final String? tax_type;
//   final String? igst;
//   final String? cgst;
//   final String? scgst;
//   final String? other_charges;
//   final String? discount_amt;
//   final String? coupon_code;
//   final String? net_amt;
//   final String? billing_name;
//   final String? billing_address;
//   final String? gst_type;
//   final String? gst_statecode;
//   final String? description;
//   final bool? order_status;
//   final String? payment_mode;
//   final String? payment_response;
//   final bool? payment_Status;
//   final String? remarks;
//   final String? extra;
//   final int? create_user;
//   final int? update_user;
//
//   OrderDataModel({
//     this.id,
//     this.user,
//     this.user_id,
//     this.create_date,
//     this.update_date,
//     this.record_status,
//     this.date,
//     this.order_from,
//     this.item_count,
//     this.total_qty,
//     this.total_amt,
//     this.tax_type,
//     this.igst,
//     this.cgst,
//     this.scgst,
//     this.other_charges,
//     this.discount_amt,
//     this.coupon_code,
//     this.net_amt,
//     this.billing_name,
//     this.billing_address,
//     this.gst_type,
//     this.gst_statecode,
//     this.description,
//     this.order_status,
//     this.payment_mode,
//     this.payment_response,
//     this.payment_Status,
//     this.remarks,
//     this.extra,
//     this.create_user,
//     this.update_user,
//   });
//
//   factory OrderDataModel.fromJson(Map<String, dynamic> json) {
//     return OrderDataModel(
//       id: json['id'] as int?,
//       user: json['user'] != null
//           ? OrderUserModel.fromJson(json['user'] as Map<String, dynamic>)
//           : null,
//       user_id: json['user_id'] as int?,
//       create_date: json['create_date'] as String?,
//       update_date: json['update_date'] as String?,
//       record_status: json['record_status'] as String?,
//       date: json['date'] as String?,
//       order_from: json['order_from'] as String?,
//       item_count: json['item_count'] as String?,
//       total_qty: json['total_qty'] as String?,
//       total_amt: json['total_amt'] as String?,
//       tax_type: json['tax_type'] as String?,
//       igst: json['igst'] as String?,
//       cgst: json['cgst'] as String?,
//       scgst: json['scgst'] as String?,
//       other_charges: json['other_charges'] as String?,
//       discount_amt: json['discount_amt'] as String?,
//       coupon_code: json['coupon_code'] as String?,
//       net_amt: json['net_amt'] as String?,
//       billing_name: json['billing_name'] as String?,
//       billing_address: json['billing_address'] as String?,
//       gst_type: json['gst_type'] as String?,
//       gst_statecode: json['gst_statecode'] as String?,
//       description: json['description'] as String?,
//       order_status: json['order_status'] as bool?,
//       payment_mode: json['payment_mode'] as String?,
//       payment_response: json['payment_response'] as String?,
//       payment_Status: json['payment_Status'] as bool?,
//       remarks: json['remarks'] as String?,
//       extra: json['extra'] as String?,
//       create_user: json['create_user'] as int?,
//       update_user: json['update_user'] as int?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'user': user?.toJson(),
//       'user_id': user_id,
//       'create_date': create_date,
//       'update_date': update_date,
//       'record_status': record_status,
//       'date': date,
//       'order_from': order_from,
//       'item_count': item_count,
//       'total_qty': total_qty,
//       'total_amt': total_amt,
//       'tax_type': tax_type,
//       'igst': igst,
//       'cgst': cgst,
//       'scgst': scgst,
//       'other_charges': other_charges,
//       'discount_amt': discount_amt,
//       'coupon_code': coupon_code,
//       'net_amt': net_amt,
//       'billing_name': billing_name,
//       'billing_address': billing_address,
//       'gst_type': gst_type,
//       'gst_statecode': gst_statecode,
//       'description': description,
//       'order_status': order_status,
//       'payment_mode': payment_mode,
//       'payment_response': payment_response,
//       'payment_Status': payment_Status,
//       'remarks': remarks,
//       'extra': extra,
//       'create_user': create_user,
//       'update_user': update_user,
//     };
//   }
// }
//
// class OrderUserModel {
//   final int? id;
//   final String? create_date;
//   final String? update_date;
//   final String? record_status;
//   final String? user_img;
//   final String? email;
//   final String? password;
//   final String? first_name;
//   final String? last_name;
//   final String? mobile_no;
//   final String? user_gender;
//   final int? status;
//   final int? create_user;
//   final int? update_user;
//
//   OrderUserModel({
//     this.id,
//     this.create_date,
//     this.update_date,
//     this.record_status,
//     this.user_img,
//     this.email,
//     this.password,
//     this.first_name,
//     this.last_name,
//     this.mobile_no,
//     this.user_gender,
//     this.status,
//     this.create_user,
//     this.update_user,
//   });
//
//   factory OrderUserModel.fromJson(Map<String, dynamic> json) {
//     return OrderUserModel(
//       id: json['id'] as int?,
//       create_date: json['create_date'] as String?,
//       update_date: json['update_date'] as String?,
//       record_status: json['record_status'] as String?,
//       user_img: json['user_img'] as String?,
//       email: json['email'] as String?,
//       password: json['password'] as String?,
//       first_name: json['first_name'] as String?,
//       last_name: json['last_name'] as String?,
//       mobile_no: json['mobile_no'] as String?,
//       user_gender: json['user_gender'] as String?,
//       status: json['status'] as int?,
//       create_user: json['create_user'] as int?,
//       update_user: json['update_user'] as int?,
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'id': id,
//       'create_date': create_date,
//       'update_date': update_date,
//       'record_status': record_status,
//       'user_img': user_img,
//       'email': email,
//       'password': password,
//       'first_name': first_name,
//       'last_name': last_name,
//       'mobile_no': mobile_no,
//       'user_gender': user_gender,
//       'status': status,
//       'create_user': create_user,
//       'update_user': update_user,
//     };
//   }
// }
//
//
// class OrderCreateResponseModel {
//   final String? message;
//   final OrderDataModel? data;
//   final dynamic raw; // fallback agar API kuch weird structure bheje
//
//   OrderCreateResponseModel({
//     this.message,
//     this.data,
//     this.raw,
//   });
//
//   factory OrderCreateResponseModel.fromJson(Map<String, dynamic> json) {
//     return OrderCreateResponseModel(
//       message: json['message'] as String?,
//       data: json['data'] != null && json['data'] is Map<String, dynamic>
//           ? OrderDataModel.fromJson(json['data'] as Map<String, dynamic>)
//           : null,
//       raw: json['raw'], // ApiService.post me jo 'raw' wrap karte ho, woh yahan aa jayega
//     );
//   }
//
//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'data': data?.toJson(),
//       'raw': raw,
//     };
//   }
// }


// ================== ROOT LIST RESPONSE ==================

class OrderListResponseModel {
  final String? message;
  final List<OrderDataModel>? data;

  OrderListResponseModel({
    this.message,
    this.data,
  });

  factory OrderListResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderListResponseModel(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => OrderDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((e) => e.toJson()).toList(),
    };
  }
}

// ================== ORDER (MASTER) ==================

class OrderDataModel {
  final int? id;
  final OrderUserModel? user;
  final int? user_id;
  final List<OrderDetailModel>? order_details;

  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? date;
  final String? order_from;
  final String? item_count;
  final String? total_qty;
  final String? total_amt;
  final String? tax_type;
  final String? igst;
  final String? cgst;
  final String? scgst;
  final String? other_charges;
  final String? discount_amt;
  final String? coupon_code;
  final String? net_amt;
  final String? billing_name;
  final String? billing_address;
  final String? gst_type;
  final String? gst_statecode;
  final String? description;
  final bool? order_status;
  final String? payment_mode;
  final String? payment_response;
  final bool? payment_Status;
  final String? remarks;
  final String? extra;
  final int? create_user;
  final int? update_user;

  OrderDataModel({
    this.id,
    this.user,
    this.user_id,
    this.order_details,
    this.create_date,
    this.update_date,
    this.record_status,
    this.date,
    this.order_from,
    this.item_count,
    this.total_qty,
    this.total_amt,
    this.tax_type,
    this.igst,
    this.cgst,
    this.scgst,
    this.other_charges,
    this.discount_amt,
    this.coupon_code,
    this.net_amt,
    this.billing_name,
    this.billing_address,
    this.gst_type,
    this.gst_statecode,
    this.description,
    this.order_status,
    this.payment_mode,
    this.payment_response,
    this.payment_Status,
    this.remarks,
    this.extra,
    this.create_user,
    this.update_user,
  });

  factory OrderDataModel.fromJson(Map<String, dynamic> json) {
    return OrderDataModel(
      id: json['id'] as int?,
      user: json['user'] != null
          ? OrderUserModel.fromJson(json['user'] as Map<String, dynamic>)
          : null,
      user_id: json['user_id'] as int?,
      order_details: (json['order_details'] as List<dynamic>?)
          ?.map((e) => OrderDetailModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      date: json['date'] as String?,
      order_from: json['order_from'] as String?,
      item_count: json['item_count'] as String?,
      total_qty: json['total_qty'] as String?,
      total_amt: json['total_amt'] as String?,
      tax_type: json['tax_type'] as String?,
      igst: json['igst'] as String?,
      cgst: json['cgst'] as String?,
      scgst: json['scgst'] as String?,
      other_charges: json['other_charges'] as String?,
      discount_amt: json['discount_amt'] as String?,
      coupon_code: json['coupon_code'] as String?,
      net_amt: json['net_amt'] as String?,
      billing_name: json['billing_name'] as String?,
      billing_address: json['billing_address'] as String?,
      gst_type: json['gst_type'] as String?,
      gst_statecode: json['gst_statecode'] as String?,
      description: json['description'] as String?,
      order_status: json['order_status'] as bool?,
      payment_mode: json['payment_mode'] as String?,
      payment_response: json['payment_response'] as String?,
      payment_Status: json['payment_Status'] as bool?,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user?.toJson(),
      'user_id': user_id,
      'order_details': order_details?.map((e) => e.toJson()).toList(),
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'date': date,
      'order_from': order_from,
      'item_count': item_count,
      'total_qty': total_qty,
      'total_amt': total_amt,
      'tax_type': tax_type,
      'igst': igst,
      'cgst': cgst,
      'scgst': scgst,
      'other_charges': other_charges,
      'discount_amt': discount_amt,
      'coupon_code': coupon_code,
      'net_amt': net_amt,
      'billing_name': billing_name,
      'billing_address': billing_address,
      'gst_type': gst_type,
      'gst_statecode': gst_statecode,
      'description': description,
      'order_status': order_status,
      'payment_mode': payment_mode,
      'payment_response': payment_response,
      'payment_Status': payment_Status,
      'remarks': remarks,
      'extra': extra,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}
/// Request ke liye light-weight detail model
class OrderDetailCreateModel {
  final int course_id;
  final int subscription_id;
  final String qty;
  final String Rate;
  final String total_qty;
  final String total_amt;
  final String tax_type;
  final String? igst;
  final String? cgst;
  final String? scgst;
  final String? other_charges;
  final String? discount_amt;
  final String? net_amt;
  final String? remarks;
  final String? extra;
  final int create_user;
  final int update_user;

  OrderDetailCreateModel({
    required this.course_id,
    required this.subscription_id,
    required this.qty,
    required this.Rate,
    required this.total_qty,
    required this.total_amt,
    required this.tax_type,
    this.igst,
    this.cgst,
    this.scgst,
    this.other_charges,
    this.discount_amt,
    this.net_amt,
    this.remarks,
    this.extra,
    required this.create_user,
    required this.update_user,
  });

  Map<String, dynamic> toJson() {
    return {
      "course_id": course_id,
      "subscription_id": subscription_id,
      "qty": qty,
      "Rate": Rate,
      "total_qty": total_qty,
      "total_amt": total_amt,
      "tax_type": tax_type,
      "igst": igst,
      "cgst": cgst,
      "scgst": scgst,
      "other_charges": other_charges,
      "discount_amt": discount_amt,
      "net_amt": net_amt,
      "remarks": remarks,
      "extra": extra,
      "create_user": create_user,
      "update_user": update_user,
    };
  }
}

// ================== USER (INSIDE ORDER) ==================

class OrderUserModel {
  final int? id;
  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? user_img;
  final String? email;
  final String? password;
  final String? first_name;
  final String? last_name;
  final String? mobile_no;
  final String? user_gender;
  final int? status;
  final int? create_user;
  final int? update_user;

  OrderUserModel({
    this.id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.user_img,
    this.email,
    this.password,
    this.first_name,
    this.last_name,
    this.mobile_no,
    this.user_gender,
    this.status,
    this.create_user,
    this.update_user,
  });

  factory OrderUserModel.fromJson(Map<String, dynamic> json) {
    return OrderUserModel(
      id: json['id'] as int?,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      user_img: json['user_img'] as String?,
      email: json['email'] as String?,
      password: json['password'] as String?,
      first_name: json['first_name'] as String?,
      last_name: json['last_name'] as String?,
      mobile_no: json['mobile_no'] as String?,
      user_gender: json['user_gender'] as String?,
      status: json['status'] as int?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'user_img': user_img,
      'email': email,
      'password': password,
      'first_name': first_name,
      'last_name': last_name,
      'mobile_no': mobile_no,
      'user_gender': user_gender,
      'status': status,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== ORDER DETAIL (LINE ITEMS) ==================

class OrderDetailModel {
  final int? id;
  final CourseModel? course;
  final int? course_id;
  final SubscriptionModel? subscription;
  final int? subscription_id;

  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? qty;
  final String? Rate;
  final String? description;
  final String? total_qty;
  final String? total_amt;
  final String? tax_type;
  final String? igst;
  final String? cgst;
  final String? scgst;
  final String? other_charges;
  final String? discount_amt;
  final String? net_amt;
  final String? remarks;
  final String? extra;
  final int? create_user;
  final int? update_user;
  final int? order;

  OrderDetailModel({
    this.id,
    this.course,
    this.course_id,
    this.subscription,
    this.subscription_id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.qty,
    this.Rate,
    this.description,
    this.total_qty,
    this.total_amt,
    this.tax_type,
    this.igst,
    this.cgst,
    this.scgst,
    this.other_charges,
    this.discount_amt,
    this.net_amt,
    this.remarks,
    this.extra,
    this.create_user,
    this.update_user,
    this.order,
  });

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailModel(
      id: json['id'] as int?,
      course: json['course'] != null
          ? CourseModel.fromJson(json['course'] as Map<String, dynamic>)
          : null,
      course_id: json['course_id'] as int?,
      subscription: json['subscription'] != null
          ? SubscriptionModel.fromJson(
        json['subscription'] as Map<String, dynamic>,
      )
          : null,
      subscription_id: json['subscription_id'] as int?,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      qty: json['qty'] as String?,
      Rate: json['Rate'] as String?,
      description: json['description'] as String?,
      total_qty: json['total_qty'] as String?,
      total_amt: json['total_amt'] as String?,
      tax_type: json['tax_type'] as String?,
      igst: json['igst'] as String?,
      cgst: json['cgst'] as String?,
      scgst: json['scgst'] as String?,
      other_charges: json['other_charges'] as String?,
      discount_amt: json['discount_amt'] as String?,
      net_amt: json['net_amt'] as String?,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
      order: json['order'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course': course?.toJson(),
      'course_id': course_id,
      'subscription': subscription?.toJson(),
      'subscription_id': subscription_id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'qty': qty,
      'Rate': Rate,
      'description': description,
      'total_qty': total_qty,
      'total_amt': total_amt,
      'tax_type': tax_type,
      'igst': igst,
      'cgst': cgst,
      'scgst': scgst,
      'other_charges': other_charges,
      'discount_amt': discount_amt,
      'net_amt': net_amt,
      'remarks': remarks,
      'extra': extra,
      'create_user': create_user,
      'update_user': update_user,
      'order': order,
    };
  }
}

// ================== COURSE (INSIDE ORDER DETAIL) ==================

class CourseModel {
  final int? id;
  final CourseCategoryModel? CourseMaster_courseCat;
  final CourseInstructorModel? CourseMaster_Courseinstructor;
  final CourseDetailModel? courseMaster_detail_id;

  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? CourseMaster_title;
  final String? CourseMaster_tumbimage;
  final String? CourseMaster_duration;
  final String? CourseMaster_duration_unit;
  final String? slug;
  final String? Description;
  final int? CourseMaster_topcourse;
  final double? CourseMaster_fee;
  final String? Video_img;
  final String? course_text;
  final String? CourseMaster_rating;
  final String? course_lesson;
  final String? course_level;
  final int? status;
  final String? Language;
  final String? Number_of_students;
  final String? Course_img;
  final String? certificate_text;
  final String? certificate_img;
  final String? Quizzes;
  final bool? is_enroll;
  final String? remarks;
  final String? extra;
  final int? create_user;
  final int? update_user;

  CourseModel({
    this.id,
    this.CourseMaster_courseCat,
    this.CourseMaster_Courseinstructor,
    this.courseMaster_detail_id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.CourseMaster_title,
    this.CourseMaster_tumbimage,
    this.CourseMaster_duration,
    this.CourseMaster_duration_unit,
    this.slug,
    this.Description,
    this.CourseMaster_topcourse,
    this.CourseMaster_fee,
    this.Video_img,
    this.course_text,
    this.CourseMaster_rating,
    this.course_lesson,
    this.course_level,
    this.status,
    this.Language,
    this.Number_of_students,
    this.Course_img,
    this.certificate_text,
    this.certificate_img,
    this.Quizzes,
    this.is_enroll,
    this.remarks,
    this.extra,
    this.create_user,
    this.update_user,
  });

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    return CourseModel(
      id: json['id'] as int?,
      CourseMaster_courseCat: json['CourseMaster_courseCat'] != null
          ? CourseCategoryModel.fromJson(
        json['CourseMaster_courseCat'] as Map<String, dynamic>,
      )
          : null,
      CourseMaster_Courseinstructor:
      json['CourseMaster_Courseinstructor'] != null
          ? CourseInstructorModel.fromJson(
        json['CourseMaster_Courseinstructor']
        as Map<String, dynamic>,
      )
          : null,
      courseMaster_detail_id: json['courseMaster_detail_id'] != null
          ? CourseDetailModel.fromJson(
        json['courseMaster_detail_id'] as Map<String, dynamic>,
      )
          : null,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      CourseMaster_title: json['CourseMaster_title'] as String?,
      CourseMaster_tumbimage: json['CourseMaster_tumbimage'] as String?,
      CourseMaster_duration: json['CourseMaster_duration'] as String?,
      CourseMaster_duration_unit:
      json['CourseMaster_duration_unit'] as String?,
      slug: json['slug'] as String?,
      Description: json['Description'] as String?,
      CourseMaster_topcourse: json['CourseMaster_topcourse'] as int?,
      CourseMaster_fee: (json['CourseMaster_fee'] as num?)?.toDouble(),
      Video_img: json['Video_img'] as String?,
      course_text: json['course_text'] as String?,
      CourseMaster_rating: json['CourseMaster_rating'] as String?,
      course_lesson: json['course_lesson'] as String?,
      course_level: json['course_level'] as String?,
      status: json['status'] as int?,
      Language: json['Language'] as String?,
      Number_of_students: json['Number_of_students'] as String?,
      Course_img: json['Course_img'] as String?,
      certificate_text: json['certificate_text'] as String?,
      certificate_img: json['certificate_img'] as String?,
      Quizzes: json['Quizzes'] as String?,
      is_enroll: json['is_enroll'] as bool?,
      remarks: json['remarks'] as String?,
      extra: json['extra'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'CourseMaster_courseCat': CourseMaster_courseCat?.toJson(),
      'CourseMaster_Courseinstructor':
      CourseMaster_Courseinstructor?.toJson(),
      'courseMaster_detail_id': courseMaster_detail_id?.toJson(),
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'CourseMaster_title': CourseMaster_title,
      'CourseMaster_tumbimage': CourseMaster_tumbimage,
      'CourseMaster_duration': CourseMaster_duration,
      'CourseMaster_duration_unit': CourseMaster_duration_unit,
      'slug': slug,
      'Description': Description,
      'CourseMaster_topcourse': CourseMaster_topcourse,
      'CourseMaster_fee': CourseMaster_fee,
      'Video_img': Video_img,
      'course_text': course_text,
      'CourseMaster_rating': CourseMaster_rating,
      'course_lesson': course_lesson,
      'course_level': course_level,
      'status': status,
      'Language': Language,
      'Number_of_students': Number_of_students,
      'Course_img': Course_img,
      'certificate_text': certificate_text,
      'certificate_img': certificate_img,
      'Quizzes': Quizzes,
      'is_enroll': is_enroll,
      'remarks': remarks,
      'extra': extra,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== COURSE CATEGORY ==================

class CourseCategoryModel {
  final int? id;
  final CourseSegmentModel? coursesugment;
  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? category_name;
  final String? category_icon;
  final int? item_stock_value;
  final int? create_user;
  final int? update_user;

  CourseCategoryModel({
    this.id,
    this.coursesugment,
    this.create_date,
    this.update_date,
    this.record_status,
    this.category_name,
    this.category_icon,
    this.item_stock_value,
    this.create_user,
    this.update_user,
  });

  factory CourseCategoryModel.fromJson(Map<String, dynamic> json) {
    return CourseCategoryModel(
      id: json['id'] as int?,
      coursesugment: json['coursesugment'] != null
          ? CourseSegmentModel.fromJson(
        json['coursesugment'] as Map<String, dynamic>,
      )
          : null,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      category_name: json['category_name'] as String?,
      category_icon: json['category_icon'] as String?,
      item_stock_value: json['item_stock_value'] as int?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'coursesugment': coursesugment?.toJson(),
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'category_name': category_name,
      'category_icon': category_icon,
      'item_stock_value': item_stock_value,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== COURSE SEGMENT ==================

class CourseSegmentModel {
  final int? id;
  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? name;
  final int? create_user;
  final int? update_user;

  CourseSegmentModel({
    this.id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.name,
    this.create_user,
    this.update_user,
  });

  factory CourseSegmentModel.fromJson(Map<String, dynamic> json) {
    return CourseSegmentModel(
      id: json['id'] as int?,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      name: json['name'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'name': name,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== COURSE INSTRUCTOR ==================

class CourseInstructorModel {
  final int? id;
  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? CourseInstructor_name;
  final String? slug;
  final String? CourseInstructor_desig;
  final String? CourseInstructor_shortbio;
  final String? CourseInstructor_email;
  final String? CourseInstructor_mobile_no;
  final String? Biography;
  final String? Education_qualification;
  final String? CourseInstructor_facebook_url;
  final String? CourseInstructor_twitter_url;
  final String? CourseInstructor_instagram_url;
  final String? CourseInstructor_youtube_url;
  final String? CourseInstructor_linkedin_url;
  final String? CourseInstructor_image;
  final double? CourseInstructor_rating;
  final double? CourseInstructor_Experience;
  final int? status;
  final String? CourseInstructor_sml;
  final int? create_user;
  final int? update_user;

  CourseInstructorModel({
    this.id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.CourseInstructor_name,
    this.slug,
    this.CourseInstructor_desig,
    this.CourseInstructor_shortbio,
    this.CourseInstructor_email,
    this.CourseInstructor_mobile_no,
    this.Biography,
    this.Education_qualification,
    this.CourseInstructor_facebook_url,
    this.CourseInstructor_twitter_url,
    this.CourseInstructor_instagram_url,
    this.CourseInstructor_youtube_url,
    this.CourseInstructor_linkedin_url,
    this.CourseInstructor_image,
    this.CourseInstructor_rating,
    this.CourseInstructor_Experience,
    this.status,
    this.CourseInstructor_sml,
    this.create_user,
    this.update_user,
  });

  factory CourseInstructorModel.fromJson(Map<String, dynamic> json) {
    return CourseInstructorModel(
      id: json['id'] as int?,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      CourseInstructor_name: json['CourseInstructor_name'] as String?,
      slug: json['slug'] as String?,
      CourseInstructor_desig: json['CourseInstructor_desig'] as String?,
      CourseInstructor_shortbio:
      json['CourseInstructor_shortbio'] as String?,
      CourseInstructor_email: json['CourseInstructor_email'] as String?,
      CourseInstructor_mobile_no:
      json['CourseInstructor_mobile_no'] as String?,
      Biography: json['Biography'] as String?,
      Education_qualification:
      json['Education_qualification'] as String?,
      CourseInstructor_facebook_url:
      json['CourseInstructor_facebook_url'] as String?,
      CourseInstructor_twitter_url:
      json['CourseInstructor_twitter_url'] as String?,
      CourseInstructor_instagram_url:
      json['CourseInstructor_instagram_url'] as String?,
      CourseInstructor_youtube_url:
      json['CourseInstructor_youtube_url'] as String?,
      CourseInstructor_linkedin_url:
      json['CourseInstructor_linkedin_url'] as String?,
      CourseInstructor_image:
      json['CourseInstructor_image'] as String?,
      CourseInstructor_rating:
      (json['CourseInstructor_rating'] as num?)?.toDouble(),
      CourseInstructor_Experience:
      (json['CourseInstructor_Experience'] as num?)?.toDouble(),
      status: json['status'] as int?,
      CourseInstructor_sml: json['CourseInstructor_sml'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'CourseInstructor_name': CourseInstructor_name,
      'slug': slug,
      'CourseInstructor_desig': CourseInstructor_desig,
      'CourseInstructor_shortbio': CourseInstructor_shortbio,
      'CourseInstructor_email': CourseInstructor_email,
      'CourseInstructor_mobile_no': CourseInstructor_mobile_no,
      'Biography': Biography,
      'Education_qualification': Education_qualification,
      'CourseInstructor_facebook_url': CourseInstructor_facebook_url,
      'CourseInstructor_twitter_url': CourseInstructor_twitter_url,
      'CourseInstructor_instagram_url': CourseInstructor_instagram_url,
      'CourseInstructor_youtube_url': CourseInstructor_youtube_url,
      'CourseInstructor_linkedin_url': CourseInstructor_linkedin_url,
      'CourseInstructor_image': CourseInstructor_image,
      'CourseInstructor_rating': CourseInstructor_rating,
      'CourseInstructor_Experience': CourseInstructor_Experience,
      'status': status,
      'CourseInstructor_sml': CourseInstructor_sml,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== COURSE DETAIL (WhatYouLearn, Curriculum) ==================

class CourseDetailModel {
  final int? id;
  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? Certification;
  final String? Whatyoulearn;
  final String? Curriculam;
  final int? create_user;
  final int? update_user;

  CourseDetailModel({
    this.id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.Certification,
    this.Whatyoulearn,
    this.Curriculam,
    this.create_user,
    this.update_user,
  });

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) {
    return CourseDetailModel(
      id: json['id'] as int?,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      Certification: json['Certification'] as String?,
      Whatyoulearn: json['Whatyoulearn'] as String?,
      Curriculam: json['Curriculam'] as String?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'Certification': Certification,
      'Whatyoulearn': Whatyoulearn,
      'Curriculam': Curriculam,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== SUBSCRIPTION ==================

class SubscriptionModel {
  final int? id;
  final String? create_date;
  final String? update_date;
  final String? record_status;
  final String? SubscriptionType_name;
  final String? remarks;
  final int? srno;
  final int? create_user;
  final int? update_user;

  SubscriptionModel({
    this.id,
    this.create_date,
    this.update_date,
    this.record_status,
    this.SubscriptionType_name,
    this.remarks,
    this.srno,
    this.create_user,
    this.update_user,
  });

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionModel(
      id: json['id'] as int?,
      create_date: json['create_date'] as String?,
      update_date: json['update_date'] as String?,
      record_status: json['record_status'] as String?,
      SubscriptionType_name: json['SubscriptionType_name'] as String?,
      remarks: json['remarks'] as String?,
      srno: json['srno'] as int?,
      create_user: json['create_user'] as int?,
      update_user: json['update_user'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'create_date': create_date,
      'update_date': update_date,
      'record_status': record_status,
      'SubscriptionType_name': SubscriptionType_name,
      'remarks': remarks,
      'srno': srno,
      'create_user': create_user,
      'update_user': update_user,
    };
  }
}

// ================== CREATE RESPONSE (SINGLE ORDER) ==================

class OrderCreateResponseModel {
  final String? message;
  final OrderDataModel? data;
  final dynamic raw;

  OrderCreateResponseModel({
    this.message,
    this.data,
    this.raw,
  });

  factory OrderCreateResponseModel.fromJson(Map<String, dynamic> json) {
    return OrderCreateResponseModel(
      message: json['message'] as String?,
      data: json['data'] != null && json['data'] is Map<String, dynamic>
          ? OrderDataModel.fromJson(json['data'] as Map<String, dynamic>)
          : null,
      raw: json['raw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.toJson(),
      'raw': raw,
    };
  }
}
