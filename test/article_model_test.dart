import 'package:flutter_test/flutter_test.dart';
import 'package:newsapp/models/article_model.dart';
import 'package:newsapp/models/news_response_model.dart';

void main() {
  test('memetakan field GNews dan membersihkan penanda panjang konten', () {
    final response = NewsResponseModel.fromJson({
      'totalArticles': 1,
      'articles': [
        {
          'title': 'Judul berita',
          'description': 'Ringkasan berita',
          'content': 'Isi berita [988 chars]',
          'image': 'https://example.com/image.jpg',
          'url': 'https://example.com/story',
          'publishedAt': '2026-11-19T10:00:00Z',
          'source': {'name': 'Media Indonesia'},
        },
      ],
    });

    expect(response.totalArticles, 1);
    expect(response.articles.single.author, 'Media Indonesia');
    expect(response.articles.single.urlToImage, 'https://example.com/image.jpg');
    expect(response.articles.single.content, 'Isi berita...');
  });

  test('menggunakan nilai aman saat field wajib tidak ada', () {
    final article = ArticleModel.fromJson({});
    expect(article.title, 'Tanpa Judul');
    expect(article.author, 'Media');
  });
}
