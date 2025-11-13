// 📌 webinar_model.dart
class WebinarModel {
  final int? id;
  final String? createDate;
  final String? updateDate;
  final String? recordStatus;
  final String? title;
  final String? key1;
  final String? key2;
  final String? key3;
  final String? img;
  final String? buttonText;
  final String? dateTime;
  final String? speaker;
  final String? designation;
  final String? remarks;
  final String? extra;
  final int? createUser;
  final int? updateUser;

  WebinarModel({
    this.id,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.title,
    this.key1,
    this.key2,
    this.key3,
    this.img,
    this.buttonText,
    this.dateTime,
    this.speaker,
    this.designation,
    this.remarks,
    this.extra,
    this.createUser,
    this.updateUser,
  });

  factory WebinarModel.fromJson(Map<String, dynamic> json) {
    return WebinarModel(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? "",
      updateDate: json['update_date'] ?? "",
      recordStatus: json['record_status'] ?? "",
      title: json['title'] ?? "",
      key1: json['key_1'] ?? "",
      key2: json['key_2'] ?? "",
      key3: json['key_3'] ?? "",
      img: json['img'] ?? "",
      buttonText: json['button_text'] ?? "",
      dateTime: json['dateTime'] ?? "",
      speaker: json['speaker'] ?? "",
      designation: json['designation'] ?? "",
      remarks: json['remarks'] ?? "",
      extra: json['extra'] ?? "",
      createUser: json['create_user'] ?? 0,
      updateUser: json['update_user'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "create_date": createDate,
      "update_date": updateDate,
      "record_status": recordStatus,
      "title": title,
      "key_1": key1,
      "key_2": key2,
      "key_3": key3,
      "img": img,
      "button_text": buttonText,
      "dateTime": dateTime,
      "speaker": speaker,
      "designation": designation,
      "remarks": remarks,
      "extra": extra,
      "create_user": createUser,
      "update_user": updateUser,
    };
  }
}
