import 'package:equatable/equatable.dart';

class NewsArticleEntity extends Equatable {
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;

  const NewsArticleEntity({
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });

  @override
  List<Object?> get props => [
    author,
    title,
    description,
    url,
    urlToImage,
    publishedAt,
    content,
  ];
}
