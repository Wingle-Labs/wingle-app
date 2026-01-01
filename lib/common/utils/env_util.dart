import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wingle/common/constants/env_constants.dart';

/// 환경 변수 관리 유틸리티
class EnvUtil {
  /// 지정된 env 파일 로드
  static Future<void> loadEnv(EnvFile type) async {
    await dotenv.load(fileName: type.path);
  }

  /// env 값 가져오기
  static String get(EnvKey<String> key, {String? fallback}) {
    final value = dotenv.env[key.name];
    if (value == null || value.isEmpty) {
      if (fallback != null) return fallback;
      throw Exception('Environment variable "${key.name}" not found!');
    }
    return value;
  }

  /// nullable 가져오기
  static String? getNullable(EnvKey<String> key) {
    return dotenv.env[key.name];
  }

  /// bool 형 변환
  static bool getBool(EnvKey<String> key, {bool fallback = false}) {
    final value = getNullable(key);
    if (value == null) return fallback;
    return value.toLowerCase() == 'true';
  }

  /// int 형 변환
  static int getInt(EnvKey<String> key, {int fallback = 0}) {
    final value = getNullable(key);
    if (value == null) return fallback;
    return int.tryParse(value) ?? fallback;
  }

  /// 모든 env 파일 로드
  static Future<void> loadAll(List<EnvFile> envFiles) async {
    Map<String, String> merged = {};

    for (final file in envFiles) {
      await dotenv.load(fileName: file.path, mergeWith: merged);
      merged = Map.from(dotenv.env);
    }
  }
}
