import 'package:dio/dio.dart';

import '../config/env.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;

  const ApiException(this.message, {this.statusCode});

  factory ApiException.fromDio(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.sendTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.transformTimeout => const ApiException('Koneksi lambat. Server tidak merespons tepat waktu.'),
        DioExceptionType.connectionError => const ApiException('Tidak ada koneksi internet. Periksa jaringan Anda.'),
        DioExceptionType.badCertificate => const ApiException('Sertifikat keamanan server tidak valid.'),
        DioExceptionType.cancel => const ApiException('Permintaan dibatalkan.'),
        DioExceptionType.badResponse => _dariResponse(e.response),
        DioExceptionType.unknown => ApiException('Terjadi kesalahan tak terduga: ${Env.samarkan(e.message ?? '-')}' ),
      };

  static ApiException _dariResponse(Response<dynamic>? response) {
    final code = response?.statusCode;
    final server = _ambilPesanServer(response?.data);
    final message = switch (code) {
      400 => 'Permintaan tidak valid. ${server ?? ''}',
      401 => 'API key salah atau tidak terdaftar.',
      403 => 'Kuota harian habis atau email akun belum diverifikasi.',
      404 => 'Alamat endpoint tidak ditemukan.',
      429 => 'Terlalu cepat. Paket gratis hanya 1 request per detik.',
      final c? when c >= 500 => 'Server GNews sedang bermasalah ($c).',
      _ => 'Gagal memuat data (kode ${code ?? '-'}).',
    };
    return ApiException(message.trim(), statusCode: code);
  }

  static String? _ambilPesanServer(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is List && errors.isNotEmpty) return errors.first.toString();
    if (errors is Map && errors.isNotEmpty) return errors.values.first.toString();
    return null;
  }

  @override
  String toString() => message;
}
