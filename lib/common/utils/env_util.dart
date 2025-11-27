import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 환경 변수 관리 유틸리티
class EnvUtil {
  /// 지정된 env 파일 로드
  static Future<void> loadEnv(String fileName) async {
    await dotenv.load(fileName: fileName);
  }

  /// env 값 가져오기
  static String get(String key, {String? fallback}) {
    final value = dotenv.env[key];
    if (value == null || value.isEmpty) {
      if (fallback != null) return fallback;
      throw Exception('Environment variable "$key" not found!');
    }
    return value;
  }

  /// nullable 가져오기
  static String? getNullable(String key) {
    return dotenv.env[key];
  }

  /// bool 형 변환
  static bool getBool(String key, {bool fallback = false}) {
    final value = getNullable(key);
    if (value == null) return fallback;
    return value.toLowerCase() == 'true';
  }

  /// int 형 변환
  static int getInt(String key, {int fallback = 0}) {
    final value = getNullable(key);
    if (value == null) return fallback;
    return int.tryParse(value) ?? fallback;
  }
}
