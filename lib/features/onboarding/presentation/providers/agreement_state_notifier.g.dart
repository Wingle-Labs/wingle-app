// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'agreement_state_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 약관 동의 화면의 상태를 관리하는 AsyncNotifier.
///
/// 책임:
/// - 서버에서 약관 목록을 로드한다.
/// - 개별 동의 상태를 제어한다.
/// - 전체 동의 상태를 제어한다.
/// - 필수 약관 충족 여부를 검증한다.
///
/// 상태 원칙:
/// - 단일 상태 소스는 [List<AgreementItem>]이다.
/// - "전체 동의"는 별도 bool로 저장하지 않는다.
/// - 파생 상태는 계산 기반으로 처리한다.

@ProviderFor(AgreementStateNotifier)
const agreementStateProvider = AgreementStateNotifierProvider._();

/// 약관 동의 화면의 상태를 관리하는 AsyncNotifier.
///
/// 책임:
/// - 서버에서 약관 목록을 로드한다.
/// - 개별 동의 상태를 제어한다.
/// - 전체 동의 상태를 제어한다.
/// - 필수 약관 충족 여부를 검증한다.
///
/// 상태 원칙:
/// - 단일 상태 소스는 [List<AgreementItem>]이다.
/// - "전체 동의"는 별도 bool로 저장하지 않는다.
/// - 파생 상태는 계산 기반으로 처리한다.
final class AgreementStateNotifierProvider
    extends
        $AsyncNotifierProvider<AgreementStateNotifier, List<AgreementItem>> {
  /// 약관 동의 화면의 상태를 관리하는 AsyncNotifier.
  ///
  /// 책임:
  /// - 서버에서 약관 목록을 로드한다.
  /// - 개별 동의 상태를 제어한다.
  /// - 전체 동의 상태를 제어한다.
  /// - 필수 약관 충족 여부를 검증한다.
  ///
  /// 상태 원칙:
  /// - 단일 상태 소스는 [List<AgreementItem>]이다.
  /// - "전체 동의"는 별도 bool로 저장하지 않는다.
  /// - 파생 상태는 계산 기반으로 처리한다.
  const AgreementStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'agreementStateProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$agreementStateNotifierHash();

  @$internal
  @override
  AgreementStateNotifier create() => AgreementStateNotifier();
}

String _$agreementStateNotifierHash() =>
    r'e82ecc91c605285dd2bf2b036c531ac70d198ca9';

/// 약관 동의 화면의 상태를 관리하는 AsyncNotifier.
///
/// 책임:
/// - 서버에서 약관 목록을 로드한다.
/// - 개별 동의 상태를 제어한다.
/// - 전체 동의 상태를 제어한다.
/// - 필수 약관 충족 여부를 검증한다.
///
/// 상태 원칙:
/// - 단일 상태 소스는 [List<AgreementItem>]이다.
/// - "전체 동의"는 별도 bool로 저장하지 않는다.
/// - 파생 상태는 계산 기반으로 처리한다.

abstract class _$AgreementStateNotifier
    extends $AsyncNotifier<List<AgreementItem>> {
  FutureOr<List<AgreementItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<AgreementItem>>, List<AgreementItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<AgreementItem>>, List<AgreementItem>>,
              AsyncValue<List<AgreementItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
