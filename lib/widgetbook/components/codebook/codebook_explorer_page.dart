import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/widgetbook/components/codebook/codebook_story_specs.dart';

/// 코드북 current versions를 조회하는 Widgetbook 페이지.
class CodebookExplorerPage extends ConsumerStatefulWidget {
  /// 생성자
  const CodebookExplorerPage({super.key});

  @override
  ConsumerState<CodebookExplorerPage> createState() =>
      _CodebookExplorerPageState();
}

class _CodebookExplorerPageState extends ConsumerState<CodebookExplorerPage> {
  late final Future<Map<String, int>> _future = _load();

  Future<Map<String, int>> _load() async {
    final repository = ref.read(codebookRepositoryProvider);
    return repository.fetchCodebookCurrentVersions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, int>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error);
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final versions = snapshot.data!;
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _HeaderCard(
              title: 'Codebook Explorer',
              subtitle:
                  'Repository: '
                  '${RepositorySelector.selectionLabel(isApiReady: true)}\n'
                  'current-versions 응답을 key/version 쌍으로 확인합니다.',
            ),
            const SizedBox(height: 16),
            _CurrentVersionCard(versions: versions, specs: codebookStorySpecs),
          ],
        );
      },
    );
  }
}

class _HeaderCard extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HeaderCard({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(subtitle),
          ],
        ),
      ),
    );
  }
}

class _CurrentVersionCard extends StatelessWidget {
  final Map<String, int> versions;
  final List<CodebookStorySpec> specs;

  const _CurrentVersionCard({required this.versions, required this.specs});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Versions',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            for (final spec in specs) ...[
              _VersionRow(label: spec.key, value: versions[spec.key]),
              if (spec != specs.last) const SizedBox(height: 12),
            ],
          ],
        ),
      ),
    );
  }
}

class _VersionRow extends StatelessWidget {
  final String label;
  final int? value;

  const _VersionRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text(label), Text(value == null ? 'missing' : 'v$value')],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  final Object? error;

  const _ErrorState({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('코드북 current-versions를 불러오지 못했습니다.\n$error'),
      ),
    );
  }
}
