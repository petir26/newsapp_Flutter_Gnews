import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../config/env.dart';
import '../models/article_model.dart';
import '../models/news_response_model.dart';
import 'api_exception.dart';

class NewsApiService {
  final Dio _dio;

  NewsApiService({Dio? dio}) : _dio = dio ?? _buatDio();

  static Dio _buatDio() {
    final dio = Dio(BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 15),
      queryParameters: {
        if (Env.pakaiKeyLangsung) 'apikey': Env.apiKey,
        'lang': 'id',
        'country': 'id',
        'max': 10,
      },
    ));
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        responseBody: true,
        logPrint: (obj) => debugPrint(Env.samarkan(obj.toString())),
      ));
    }
    return dio;
  }

  Future<List<ArticleModel>> getTopHeadlines({String category = 'general'}) =>
      _ambilArtikel('/top-headlines', {'category': category});

  Future<List<ArticleModel>> searchNews(String keyword) =>
      _ambilArtikel('/search', {'q': keyword, 'sortby': 'publishedAt'});

  Future<List<ArticleModel>> _ambilArtikel(String path, Map<String, dynamic> query) async {
    if (!Env.lengkap) {
      throw const ApiException('Konfigurasi belum diisi. Jalankan dengan --dart-define-from-file=config/env.json');
    }
    try {
      final response = await _dio.get(path, queryParameters: query);
      final data = response.data;
      if (data is! Map<String, dynamic>) {
        throw const ApiException('Format data dari server tidak dikenali.');
      }
      return NewsResponseModel.fromJson(data).articles;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    } on TypeError {
      throw const ApiException('Struktur data dari server berbeda dari model.');
    }
  }
}
