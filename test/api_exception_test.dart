import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newsapp/services/api_exception.dart';

DioException _responseError(int statusCode, {dynamic data}) {
  final request = RequestOptions(path: '/test');
  return DioException(
    requestOptions: request,
    type: DioExceptionType.badResponse,
    response: Response<dynamic>(
      requestOptions: request,
      statusCode: statusCode,
      data: data,
    ),
  );
}

void main() {
  group('ApiException.fromDio', () {
    test('membedakan key salah, input, endpoint, dan rate limit', () {
      expect(ApiException.fromDio(_responseError(401)).message, contains('API key salah'));
      expect(ApiException.fromDio(_responseError(400, data: {
        'errors': {'q': 'Kata kunci tidak valid'},
      })).message, contains('Kata kunci tidak valid'));
      expect(ApiException.fromDio(_responseError(404)).message, contains('endpoint tidak ditemukan'));
      expect(ApiException.fromDio(_responseError(429)).message, contains('1 request per detik'));
    });

    test('memetakan timeout, koneksi, dan server 5xx', () {
      final timeout = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.receiveTimeout,
      );
      final disconnected = DioException(
        requestOptions: RequestOptions(path: '/test'),
        type: DioExceptionType.connectionError,
      );

      expect(ApiException.fromDio(timeout).message, contains('Koneksi lambat'));
      expect(ApiException.fromDio(disconnected).message, contains('Tidak ada koneksi internet'));
      expect(ApiException.fromDio(_responseError(503)).message, contains('Server GNews sedang bermasalah'));
    });
  });
}
