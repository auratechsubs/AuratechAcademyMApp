class TestimonialResponse {
  final String message;
  final List<Testimonial> data;

  TestimonialResponse({
    required this.message,
    required this.data,
  });

  factory TestimonialResponse.fromJson(Map<String, dynamic> json) {
    return TestimonialResponse(
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map((item) => Testimonial.fromJson(item))
          .toList(),
    );
  }
}

class Testimonial {
  final int id;
  final String createDate;
  final String updateDate;
  final String recordStatus;
  final double rating;
  final String text;
  final String avatar;
  final String name;
  final String designation;

  Testimonial({
    required this.id,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.rating,
    required this.text,
    required this.avatar,
    required this.name,
    required this.designation,
  });

  factory Testimonial.fromJson(Map<String, dynamic> json) {
    return Testimonial(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      rating: (json['rating'] ?? 0).toDouble(),
      text: json['text'] ?? '',
      avatar: json['avatar'] ?? '',
      name: json['name'] ?? '',
      designation: json['designation'] ?? '',
    );
  }
}
