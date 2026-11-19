class Env {
  Env._();

  static const String baseUrl = String.fromEnvironment('GNEWS_BASE_URL');
  static const String apiKey = String.fromEnvironment('GNEWS_API_KEY');
  static bool get lengkap => baseUrl.isNotEmpty;
  static bool get pakaiKeyLangsung => apiKey.isNotEmpty;

  static String samarkan(String teks) {
    var hasil = teks.replaceAllMapped(
      RegExp(r'(apikey=)[^&\s"]+', caseSensitive: false),
      (m) => '${m[1]}***',
    );
    if (apiKey.isNotEmpty) hasil = hasil.replaceAll(apiKey, '***');
    return hasil;
  }
}
