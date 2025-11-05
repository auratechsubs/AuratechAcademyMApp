class GalleryResponse {
  final String? message;
  final List<GalleryItem>? data;

  GalleryResponse({
    this.message,
    this.data,
  });

  factory GalleryResponse.fromJson(Map<String, dynamic> json) {
    return GalleryResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => GalleryItem.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'data': data?.map((item) => item.toJson()).toList(),
    };
  }
}

class GalleryItem {
  final int? galleryMasterId;
  final DateTime? createDate;
  final DateTime? updateDate;
  final String? recordStatus;
  final String? galleryName;
  final String? galleryDescription;
  final String? galleryImg;
  final int? srno;
  final String? createUser;
  final String? updateUser;

  GalleryItem({
    this.galleryMasterId,
    this.createDate,
    this.updateDate,
    this.recordStatus,
    this.galleryName,
    this.galleryDescription,
    this.galleryImg,
    this.srno,
    this.createUser,
    this.updateUser,
  });

  factory GalleryItem.fromJson(Map<String, dynamic> json) {
    return GalleryItem(
      galleryMasterId: json['GalleryMaster_ID'] as int?,
      createDate: json['create_date'] != null
          ? DateTime.parse(json['create_date'])
          : null,
      updateDate: json['update_date'] != null
          ? DateTime.parse(json['update_date'])
          : null,
      recordStatus: json['record_status'] as String?,
      galleryName: json['GalleryName'] as String?,
      galleryDescription: json['GalleryDescription'] as String?,
      galleryImg: json['Gallery_Img'] as String?,
      srno: json['srno'] as int?,
      createUser: json['create_user'] as String?,
      updateUser: json['update_user'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'GalleryMaster_ID': galleryMasterId,
      'create_date': createDate?.toIso8601String(),
      'update_date': updateDate?.toIso8601String(),
      'record_status': recordStatus,
      'GalleryName': galleryName,
      'GalleryDescription': galleryDescription,
      'Gallery_Img': galleryImg,
      'srno': srno,
      'create_user': createUser,
      'update_user': updateUser,
    };
  }
}
