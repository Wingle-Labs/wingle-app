// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_codebook_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// JOB 코드북 트리를 제공하는 Provider.

@ProviderFor(jobCodebookTree)
const jobCodebookTreeProvider = JobCodebookTreeProvider._();

/// JOB 코드북 트리를 제공하는 Provider.

final class JobCodebookTreeProvider
    extends
        $FunctionalProvider<JobCodebookTree, JobCodebookTree, JobCodebookTree>
    with $Provider<JobCodebookTree> {
  /// JOB 코드북 트리를 제공하는 Provider.
  const JobCodebookTreeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobCodebookTreeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobCodebookTreeHash();

  @$internal
  @override
  $ProviderElement<JobCodebookTree> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  JobCodebookTree create(Ref ref) {
    return jobCodebookTree(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobCodebookTree value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobCodebookTree>(value),
    );
  }
}

String _$jobCodebookTreeHash() => r'1fbfe7bb7dfc544dfe8fdd31476ac7c6abf5380d';
