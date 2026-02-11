class News {
  final String newsId;
  final String title;
  final String slug;
  final String content;
  final String author;
  final String imageUrl;
  final DateTime publishedAt;

  News({
    required this.newsId,
    required this.title,
    required this.slug,
    required this.content,
    required this.author,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory News.fromJson(Map<String, dynamic> json) {
    return News(
      newsId: json['news_id'],
      title: json['title'],
      slug: json['slug'],
      content: json['content'],
      author: json['author'],
      imageUrl: json['image_url'],
      publishedAt: DateTime.parse(json['published_at']),
    );
  }
}