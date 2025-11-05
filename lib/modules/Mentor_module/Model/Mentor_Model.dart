class CourseInstructor {
  final int id;
  final String createDate;
  final String updateDate;
  final String recordStatus;
  final String name;
  final String slug;
  final String designation;
  final String shortBio;
  final String email;
  final String mobileNo;
  final String biography;
  final String educationQualification;
  final String facebookUrl;
  final String twitterUrl;
  final String instagramUrl;
  final String youtubeUrl;
  final String linkedinUrl;
  final String image;
  final double rating;
  final double experience;
  final int status;
  final String sml;
  final dynamic createUser;
  final dynamic updateUser;

  CourseInstructor({
    required this.id,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.name,
    required this.slug,
    required this.designation,
    required this.shortBio,
    required this.email,
    required this.mobileNo,
    required this.biography,
    required this.educationQualification,
    required this.facebookUrl,
    required this.twitterUrl,
    required this.instagramUrl,
    required this.youtubeUrl,
    required this.linkedinUrl,
    required this.image,
    required this.rating,
    required this.experience,
    required this.status,
    required this.sml,
    this.createUser,
    this.updateUser,
  });

  factory CourseInstructor.fromJson(Map<String, dynamic> json) {
    return CourseInstructor(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      name: json['CourseInstructor_name'] ?? '',
      slug: json['slug'] ?? '',
      designation: json['CourseInstructor_desig'] ?? '',
      shortBio: json['CourseInstructor_shortbio'] ?? '',
      email: json['CourseInstructor_email'] ?? '',
      mobileNo: json['CourseInstructor_mobile_no'] ?? '',
      biography: json['Biography'] ?? '',
      educationQualification: json['Education_qualification'] ?? '',
      facebookUrl: json['CourseInstructor_facebook_url'] ?? '',
      twitterUrl: json['CourseInstructor_twitter_url'] ?? '',
      instagramUrl: json['CourseInstructor_instagram_url'] ?? '',
      youtubeUrl: json['CourseInstructor_youtube_url'] ?? '',
      linkedinUrl: json['CourseInstructor_linkedin_url'] ?? '',
      image: json['CourseInstructor_image'] ?? '',
      rating: (json['CourseInstructor_rating'] ?? 0).toDouble(),
      experience: (json['CourseInstructor_Experience'] ?? 0).toDouble(),
      status: json['status'] ?? 0,
      sml: json['CourseInstructor_sml'] ?? '',
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }
}
