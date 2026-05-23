import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/data/codebook_repository_impl.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/basic_profile_body_shape_option_list.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/region_codebook_selection_panel.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';
import 'package:wingle/widgetbook/components/codebook/body_shape_codebook_mapper.dart';
import 'package:wingle/widgetbook/components/codebook/codebook_story_specs.dart';
import 'package:wingle/widgetbook/components/codebook/question_category_codebook_preview.dart';

/// 코드북 snapshot을 개별 key로 조회하는 Widgetbook 페이지.
class CodebookSnapshotPage extends ConsumerStatefulWidget {
  /// 조회할 코드북 키.
  final String groupKey;

  /// 생성자
  const CodebookSnapshotPage({super.key, required this.groupKey});

  @override
  ConsumerState<CodebookSnapshotPage> createState() =>
      _CodebookSnapshotPageState();
}

class _CodebookSnapshotPageState extends ConsumerState<CodebookSnapshotPage> {
  late final Future<_CodebookSnapshotResult?> _future = _load();

  Future<_CodebookSnapshotResult?> _load() async {
    final repository = ref.read(codebookRepositoryProvider);
    final snapshots = await repository.fetchCodebookSnapshot(
      groups: [widget.groupKey],
    );
    final snapshot = snapshots[widget.groupKey];
    if (snapshot == null) return null;

    final questionCategoryCurrentVersions =
        widget.groupKey == 'QUESTION_CATEGORY'
        ? await repository.fetchChoiceQuestionCurrentVersions()
        : const <String, int>{};
    final choiceSnapshots = widget.groupKey == 'QUESTION_CATEGORY'
        ? await repository.fetchChoiceQuestionSnapshot(
            categories: snapshot.codes.map((code) => code.code).toList(),
          )
        : const <String, ChoiceQuestionSetSnapshot>{};

    return _CodebookSnapshotResult(
      groupKey: widget.groupKey,
      snapshot: snapshot,
      questionCategoryCurrentVersions: questionCategoryCurrentVersions,
      choiceSnapshots: choiceSnapshots,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_CodebookSnapshotResult?>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _ErrorState(groupKey: widget.groupKey, error: snapshot.error);
        }

        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator.adaptive());
        }

        final result = snapshot.data;
        if (result == null) {
          return _EmptyState(groupKey: widget.groupKey);
        }

        final spec = codebookStorySpecs.firstWhere(
          (value) => value.key == widget.groupKey,
          orElse: () =>
              CodebookStorySpec(key: widget.groupKey, label: widget.groupKey),
        );

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _HeaderCard(
              title: spec.label,
              subtitle:
                  'Repository: '
                  '${RepositorySelector.selectionLabel(isApiReady: true)}\n'
                  'snapshot?groups=${widget.groupKey} 응답을 실제로 확인합니다.',
            ),
            const SizedBox(height: 16),
            if (widget.groupKey == 'QUESTION_CATEGORY')
              _QuestionCategorySnapshotPreview(
                snapshot: result.snapshot,
                currentVersions: result.questionCategoryCurrentVersions,
                choiceSnapshots: result.choiceSnapshots,
              )
            else if (widget.groupKey == 'REGION' || widget.groupKey == 'JOB')
              _RegionSnapshotPreview(snapshot: result.snapshot)
            else ...[
              _SnapshotCard(
                groupKey: result.groupKey,
                snapshot: result.snapshot,
              ),
              if (widget.groupKey == 'BODY_TYPE') ...[
                const SizedBox(height: 16),
                _BodyShapePreview(snapshot: result.snapshot),
              ],
            ],
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

class _SnapshotCard extends StatelessWidget {
  final String groupKey;
  final CodeSnapshot snapshot;

  const _SnapshotCard({required this.groupKey, required this.snapshot});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$groupKey · v${snapshot.version}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            for (final code in snapshot.codes) ...[
              Text(
                '${_displayOrderLabel(code.displayOrder)}. ${code.codeName}'
                ' (${code.code})'
                '${code.parentCode == null ? '' : ' -> ${code.parentCode}'}',
              ),
              const SizedBox(height: 8),
            ],
          ],
        ),
      ),
    );
  }

  String _displayOrderLabel(int displayOrder) {
    return displayOrder > 0 ? displayOrder.toString() : '-';
  }
}

class _RegionSnapshotPreview extends StatefulWidget {
  final CodeSnapshot snapshot;

  const _RegionSnapshotPreview({required this.snapshot});

  @override
  State<_RegionSnapshotPreview> createState() => _RegionSnapshotPreviewState();
}

class _QuestionCategorySnapshotPreview extends StatelessWidget {
  final CodeSnapshot snapshot;
  final Map<String, int> currentVersions;
  final Map<String, ChoiceQuestionSetSnapshot> choiceSnapshots;

  const _QuestionCategorySnapshotPreview({
    required this.snapshot,
    required this.currentVersions,
    required this.choiceSnapshots,
  });

  @override
  Widget build(BuildContext context) {
    return QuestionCategoryCodebookPreview(
      snapshot: snapshot,
      currentVersions: currentVersions,
      choiceSnapshots: choiceSnapshots,
    );
  }
}

class _RegionSnapshotPreviewState extends State<_RegionSnapshotPreview> {
  String? _selectedCode;

  @override
  Widget build(BuildContext context) {
    final tree = CodebookHierarchyTree.fromSnapshot(
      CodebookSnapshot(
        version: widget.snapshot.version,
        codes: widget.snapshot.codes
            .map(
              (code) => CodebookEntry(
                code: code.code,
                codeName: code.codeName,
                parentCode: code.parentCode,
                displayOrder: code.displayOrder,
              ),
            )
            .toList(),
      ),
    );

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'REGION / JOB · v${widget.snapshot.version}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            RegionCodebookSelectionPanel(
              tree: tree,
              selectedCode: _selectedCode,
              onSelected: (selection) =>
                  setState(() => _selectedCode = selection.code),
            ),
          ],
        ),
      ),
    );
  }
}

class _BodyShapePreview extends StatelessWidget {
  final CodeSnapshot snapshot;

  const _BodyShapePreview({required this.snapshot});

  @override
  Widget build(BuildContext context) {
    final bodyShapeCodebook = mapBodyTypeCodebook(snapshot);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '실제 컴포넌트: BasicProfileBodyShapeOptionList',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 16),
            Text('Gender: male'),
            BasicProfileBodyShapeOptionList(
              options: bodyShapeCodebook.optionsForGender('male'),
              selectedCode: null,
              onSelected: (_) {},
              padding: EdgeInsets.zero,
            ),
            const SizedBox(height: 16),
            Text('Gender: female'),
            BasicProfileBodyShapeOptionList(
              options: bodyShapeCodebook.optionsForGender('female'),
              selectedCode: null,
              onSelected: (_) {},
              padding: EdgeInsets.zero,
            ),
          ],
        ),
      ),
    );
  }
}

class _CodebookSnapshotResult {
  final String groupKey;
  final CodeSnapshot snapshot;
  final Map<String, int> questionCategoryCurrentVersions;
  final Map<String, ChoiceQuestionSetSnapshot> choiceSnapshots;

  const _CodebookSnapshotResult({
    required this.groupKey,
    required this.snapshot,
    required this.questionCategoryCurrentVersions,
    required this.choiceSnapshots,
  });
}

class _EmptyState extends StatelessWidget {
  final String groupKey;

  const _EmptyState({required this.groupKey});

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('$groupKey snapshot이 없습니다.'));
  }
}

class _ErrorState extends StatelessWidget {
  final String groupKey;
  final Object? error;

  const _ErrorState({required this.groupKey, required this.error});

  @override
  Widget build(BuildContext context) {
    final details = _describeError(error);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text('$groupKey snapshot을 불러오지 못했습니다.\n$details'),
      ),
    );
  }

  String _describeError(Object? error) {
    if (error is CodebookApiException) {
      return [
        error.message,
        'uri: ${error.uri}',
        if (error.statusCode != null) 'statusCode: ${error.statusCode}',
        if (error.responseBody != null && error.responseBody!.isNotEmpty)
          'responseBody: ${_compact(error.responseBody!)}',
      ].join('\n');
    }

    final text = error?.toString() ?? 'unknown error';
    if (text.contains('<!DOCTYPE') || text.contains('<html')) {
      return 'HTML 응답을 JSON으로 파싱하려다 실패했습니다.\n'
          '이 요청은 API가 아닌 웹 페이지로 라우팅되었을 가능성이 높습니다.\n'
          'raw: ${_compact(text)}';
    }

    return text;
  }

  String _compact(String value) {
    final trimmed = value.trim();
    if (trimmed.length <= 500) return trimmed;
    return '${trimmed.substring(0, 500)}...';
  }
}
