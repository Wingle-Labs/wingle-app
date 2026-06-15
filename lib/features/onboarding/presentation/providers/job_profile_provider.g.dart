// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'job_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 직장 정보 입력 상태를 관리하는 Notifier.

@ProviderFor(JobProfile)
const jobProfileProvider = JobProfileProvider._();

/// 직장 정보 입력 상태를 관리하는 Notifier.
final class JobProfileProvider
    extends $NotifierProvider<JobProfile, JobProfileModel> {
  /// 직장 정보 입력 상태를 관리하는 Notifier.
  const JobProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jobProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jobProfileHash();

  @$internal
  @override
  JobProfile create() => JobProfile();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(JobProfileModel value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<JobProfileModel>(value),
    );
  }
}

String _$jobProfileHash() => r'ad744d8bc9bffdcb95150a70b17a14c004d1e41f';

/// 직장 정보 입력 상태를 관리하는 Notifier.

abstract class _$JobProfile extends $Notifier<JobProfileModel> {
  JobProfileModel build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<JobProfileModel, JobProfileModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<JobProfileModel, JobProfileModel>,
              JobProfileModel,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
