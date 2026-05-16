import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/common/constants/hive_constants.dart';
import 'package:wingle/common/utils/hive_util.dart';

/// 현재 로그인한 사용자의 성별을 읽는 Provider.
///
/// 로그인 시점에 저장된 값을 읽어오며, 화면을 벗어나면 자동 해제된다.
final currentUserGenderProvider = Provider.autoDispose<String?>((ref) {
  try {
    final rawGender = HiveUtil.read(HiveLoginBox.gender);
    return rawGender?.toLowerCase();
  } catch (_) {
    return null;
  }
});
