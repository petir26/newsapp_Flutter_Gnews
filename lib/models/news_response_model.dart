import 'article_model.dart';

class NewsResponseModel {
  final int totalArticles;
  final List<ArticleModel> articles;

  const NewsResponseModel({required this.totalArticles, required this.articles});

  factory NewsResponseModel.fromJson(Map<String, dynamic> json) => NewsResponseModel(
        totalArticles: json['totalArticles'] as int? ?? 0,
        articles: (json['articles'] as List<dynamic>?)
                ?.map((item) => ArticleModel.fromJson(item as Map<String, dynamic>))
                .toList() ??
            const [],
      );
}
