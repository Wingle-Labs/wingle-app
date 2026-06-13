// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_block_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 연락처 지인 제외 화면 상태를 관리한다.

@ProviderFor(ContactBlockController)
const contactBlockControllerProvider = ContactBlockControllerProvider._();

/// 연락처 지인 제외 화면 상태를 관리한다.
final class ContactBlockControllerProvider
    extends $NotifierProvider<ContactBlockController, ContactBlockModel> {
  /// 연락처 지인 제외 화면 상태를 관리한다.
  const ContactBlockControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactBlockControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactBlockControllerHash();

  @$internal
  @override
  ContactBlockController create() => ContactBlockController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactBlockModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactBlockModel>(value),
    );
  }
}

String _$contactBlockControllerHash() =>
    r'4dde74c0742a23eafe44ea54625fc15d576fac06';

/// 연락처 지인 제외 화면 상태를 관리한다.

abstract class _$ContactBlockController extends $Notifier<ContactBlockModel> {
  ContactBlockModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ContactBlockModel, ContactBlockModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ContactBlockModel, ContactBlockModel>,
              ContactBlockModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
