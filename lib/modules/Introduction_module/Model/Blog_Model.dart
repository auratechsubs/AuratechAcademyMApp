class BlogResponse {
  final String message;
  final List<Blog> blogs;

  BlogResponse({
    required this.message,
    required this.blogs,
  });

  factory BlogResponse.fromJson(Map<String, dynamic> json) {
    return BlogResponse(
      message: json['message'] ?? '',
      blogs: (json['data'] as List<dynamic>)
          .map((e) => Blog.fromJson(e))
          .toList(),
    );
  }
}

class Blog {
  final int id;
  final Author author;
  final String createDate;
  final String updateDate;
  final String recordStatus;
  final String slug;
  final String title;
  final String image;
  final int status;
  final String content;
  final String tag;
  final String blogCategory;
  final String blogDetail;
  final String blogDetailImg;
  final int? createUser;
  final int? updateUser;

  Blog({
    required this.id,
    required this.author,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.slug,
    required this.title,
    required this.image,
    required this.status,
    required this.content,
    required this.tag,
    required this.blogCategory,
    required this.blogDetail,
    required this.blogDetailImg,
    this.createUser,
    this.updateUser,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['id'] ?? 0,
      author: Author.fromJson(json['author_name']),
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      slug: json['slug'] ?? '',
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      status: json['status'] ?? 0,
      content: json['content'] ?? '',
      tag: json['tag'] ?? '',
      blogCategory: json['blogcategory'] ?? '',
      blogDetail: json['blog_detail'] ?? '',
      blogDetailImg: json['blog_detail_img'] ?? '',
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }
}

class Author {
  final int id;
  final String createDate;
  final String updateDate;
  final String recordStatus;
  final String name;
  final int? createUser;
  final int? updateUser;

  Author({
    required this.id,
    required this.createDate,
    required this.updateDate,
    required this.recordStatus,
    required this.name,
    this.createUser,
    this.updateUser,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] ?? 0,
      createDate: json['create_date'] ?? '',
      updateDate: json['update_date'] ?? '',
      recordStatus: json['record_status'] ?? '',
      name: json['author_name'] ?? '',
      createUser: json['create_user'],
      updateUser: json['update_user'],
    );
  }
}
