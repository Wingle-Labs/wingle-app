import 'dart:collection';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/common/constants/api_error_messages.dart';
import 'package:wingle/features/onboarding/data/mock/mock_profile_repository.dart';
import 'package:wingle/features/onboarding/domain/model/profile/residence_code.dart';
import 'package:wingle/features/onboarding/domain/repository/profile_repository.dart';
import 'package:wingle/features/onboarding/presentation/providers/basic_profile_provider.dart';
import 'package:wingle/features/onboarding/presentation/providers/profile_repository_provider.dart';

class _QueueProfileRepository implements ProfileRepository {
  _QueueProfileRepository(Iterable<String> nicknames)
    : _nicknames = Queue<String>.from(nicknames);

  final Queue<String> _nicknames;

  @override
  Future<String> fetchRandomNickname() async {
    if (_nicknames.isEmpty) {
      throw Exception('no nickname');
    }

    return _nicknames.removeFirst();
  }

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyType,
  }) async {}

  @override
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  }) async {}

  @override
  Future<void> submitJob({
    required String company,
    required String occupation,
  }) async {}

  @override
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
  }) async {}

  @override
  Future<void> verifyEducationEmail({required String email}) async {}

  @override
  Future<void> verifyJobEmail({required String email}) async {}
}

class _FailingProfileRepository implements ProfileRepository {
  @override
  Future<String> fetchRandomNickname() async {
    throw Exception('failure');
  }

  @override
  Future<void> submitBasicProfile({
    required String nickname,
    required ResidenceCode residence,
    required int height,
    required String bodyType,
  }) async {}

  @override
  Future<void> submitEducation({
    required String? university,
    required String educationLevel,
  }) async {}

  @override
  Future<void> submitJob({
    required String company,
    required String occupation,
  }) async {}

  @override
  Future<void> submitProfileDetails({
    required String mbti,
    required String selfIntroduction,
  }) async {}

  @override
  Future<void> verifyEducationEmail({required String email}) async {}

  @override
  Future<void> verifyJobEmail({required String email}) async {}
}

void main() {
  group('BasicProfileNicknameProvider', () {
    test('랜덤 닉네임을 불러오면 상태가 갱신된다', () async {
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            _QueueProfileRepository([MockProfileRepository.mockNickname]),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(basicProfileProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(basicProfileProvider.notifier);

      await notifier.loadNickname();

      final state = container.read(basicProfileProvider);

      expect(state.nickname, MockProfileRepository.mockNickname);
      expect(state.isNicknameLoading, isFalse);
      expect(state.nicknameErrorMessage, isNull);
    });

    test('닉네임 변경 요청 시 새로운 닉네임을 다시 불러온다', () async {
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            _QueueProfileRepository(['첫 번째 닉네임', '두 번째 닉네임']),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(basicProfileProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(basicProfileProvider.notifier);

      await notifier.loadNickname();
      await notifier.refreshNickname();

      final state = container.read(basicProfileProvider);

      expect(state.nickname, '두 번째 닉네임');
      expect(state.isNicknameLoading, isFalse);
    });

    test('닉네임 조회 실패 시 에러 키를 보관한다', () async {
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(
            _FailingProfileRepository(),
          ),
        ],
      );
      addTearDown(container.dispose);

      final subscription = container.listen(basicProfileProvider, (_, _) {});
      addTearDown(subscription.close);

      final notifier = container.read(basicProfileProvider.notifier);

      await notifier.loadNickname();

      final state = container.read(basicProfileProvider);

      expect(state.nickname, isEmpty);
      expect(state.isNicknameLoading, isFalse);
      expect(
        state.nicknameErrorMessage,
        ApiErrorMessages.fetchRandomNicknameFailed,
      );
    });
  });
}
