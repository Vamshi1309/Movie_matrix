class ApiConfig {
  static const String _baseUrl = "http://192.168.0.81:8080";

  static String getFullImageUrl(String path) {
    // ignore: unnecessary_null_comparison
    if (path == null || path.isEmpty) return "";

    return '$_baseUrl/$path';
  }

  static String get baseUrl => _baseUrl;

  static int get userId => 1;
}
