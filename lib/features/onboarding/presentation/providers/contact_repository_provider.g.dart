// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// [ContactRepository] 구현체를 제공하는 Provider.

@ProviderFor(contactRepository)
const contactRepositoryProvider = ContactRepositoryProvider._();

/// [ContactRepository] 구현체를 제공하는 Provider.

final class ContactRepositoryProvider
    extends
        $FunctionalProvider<
          ContactRepository,
          ContactRepository,
          ContactRepository
        >
    with $Provider<ContactRepository> {
  /// [ContactRepository] 구현체를 제공하는 Provider.
  const ContactRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'contactRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$contactRepositoryHash();

  @$internal
  @override
  $ProviderElement<ContactRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ContactRepository create(Ref ref) {
    return contactRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ContactRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ContactRepository>(value),
    );
  }
}

String _$contactRepositoryHash() => r'30ba957013a77789efeca8e2f42820775ce7e230';
