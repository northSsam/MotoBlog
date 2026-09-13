// Model untuk menyimpan data artikel
class Post {
  final int id;
  final String title;
  final String content;
  final int categoryId;
  final String categoryName;
  final String? imageUrl;

  // Constructor untuk membuat object Post
  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.categoryId,
    required this.categoryName,
    this.imageUrl,
  });

  // Mengubah data JSON dari API menjadi object Post
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      imageUrl: json['image_url'],
    );
  }
}