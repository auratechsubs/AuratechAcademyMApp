class FlashBannerResponse {
  final String? message;
  final List<FlashBanner>? data;

  FlashBannerResponse({
    this.message,
    this.data,
  });

  factory FlashBannerResponse.fromJson(Map<String, dynamic> json) {
    return FlashBannerResponse(
      message: json['message'] as String?,
      data: json['data'] != null
          ? List<FlashBanner>.from(
        json['data'].map((e) => FlashBanner.fromJson(e)),
      )
          : [],
    );
  }

  Map<String, dynamic> toJson() => {
    'message': message,
    'data': data?.map((e) => e.toJson()).toList(),
  };
}

class FlashBanner {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? name;
  final String? key1;
  final String? key2;
  final String? key3;
  final String? img;
  final String? buttonText;
  final String? phoneNumber;
  final String? email;
  final String? remarks;
  final String? extra;
  final int? createUser;
  final int? updateUser;

  FlashBanner({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.name,
    this.key1,
    this.key2,
    this.key3,
    this.img,
    this.buttonText,
    this.phoneNumber,
    this.email,
    this.remarks,
    this.extra,
    this.createUser,
    this.updateUser,
  });

  factory FlashBanner.fromJson(Map<String, dynamic> json) {
    return FlashBanner(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? "",
      updateDate: json['update_date'] ?? "",
      recordStatus: json['record_status'] ?? "",
      name: json['name'] ?? "",
      key1: json['key_1'] ?? "",
      key2: json['key_2'] ?? "",
      key3: json['key_3'] ?? "",
      img: json['img'] ?? "",
      buttonText: json['button_text'] ?? "",
      phoneNumber: json['phone_number'] ?? "",
      email: json['email'] ?? "",
      remarks: json['remarks'] ?? "",
      extra: json['extra'] ?? "",
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
    'key_1': key1,
    'key_2': key2,
    'key_3': key3,
    'img': img,
    'button_text': buttonText,
    'phone_number': phoneNumber,
    'email': email,
    'remarks': remarks,
    'extra': extra,
    'create_user': createUser,
    'update_user': updateUser,
  };
}
