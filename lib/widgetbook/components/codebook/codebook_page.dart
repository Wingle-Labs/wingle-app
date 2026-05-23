import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:wingle/app/config/theme/components/states/animation_progress_indicator.dart';
import 'package:wingle/common/utils/repository_selector.dart';
import 'package:wingle/features/onboarding/domain/model/body_shape/body_shape_models.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/basic_profile_body_shape_option_list.dart';
import 'package:wingle/features/onboarding/presentation/components/selection/region_codebook_selection_panel.dart';
import 'package:wingle/features/onboarding/presentation/providers/codebook_repository_provider.dart';

/// 코드북 데이터와 실제 컴포넌트 소비 결과를 함께 보여주는 페이지.
class CodebookPage extends ConsumerStatefulWidget {
  /// 생성자
  const CodebookPage({super.key});

  @override
  ConsumerState<CodebookPage> createState() => _CodebookPageState();
}

class _CodebookPageState extends ConsumerState<CodebookPage> {
  late final Future<_CodebookPreviewData> _future = _load();

  Future<_CodebookPreviewData> _load() async {
    final repository = ref.read(codebookRepositoryProvider);
    final currentVersions = await repository.fetchCodebookCurrentVersions();
    final codebookSnapshot = await repository.fetchCodebookSnapshot(
      groups: const [
        'BODY_TYPE',
        'REGION',
        'JOB',
        'QUESTION_CATEGORY',
        'UNIVERSITY',
      ],
    );
    final termVersions = await repository.fetchTermsCurrentVersions();
    final termSnapshot = await repository.fetchTermsSnapshot();
    final choiceVersions = await repository
        .fetchChoiceQuestionCurrentVersions();
    final choiceSnapshot = await repository.fetchChoiceQuestionSnapshot(
      categories: const ['MEETING_STYLE', 'VALUE'],
    );
    final essayVersion = await repository.fetchEssayQuestionCurrentVersion();
    final essaySnapshot = await repository.fetchEssayQuestionSnapshot();
    return _CodebookPreviewData(
      repositoryLabel: RepositorySelector.selectionLabel(isApiReady: true),
      currentVersions: currentVersions,
      codebookSnapshot: codebookSnapshot,
      termVersions: termVersions,
      termSnapshot: termSnapshot,
      choiceVersions: choiceVersions,
      choiceSnapshot: choiceSnapshot,
      essayVersion: essayVersion,
      essaySnapshot: essaySnapshot,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_CodebookPreviewData>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return _ErrorState(error: snapshot.error);
        }

        if (!snapshot.hasData) {
          return const Center(child: AnimationProgressIndicator());
        }

        final data = snapshot.data!;
        final bodyShapeStory = _buildBodyShapeStory(data.codebookSnapshot);
        final regionStory = _buildRegionStory(data.codebookSnapshot);

        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            _HeaderCard(
              title: 'Codebook Explorer',
              subtitle:
                  'Repository: ${data.repositoryLabel}\n'
                  '실제 API 응답과 실제 컴포넌트 소비 결과를 함께 확인합니다.',
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Current Versions',
              child: _KeyValueGrid(
                entries: data.currentVersions,
                expectedKeys: const [
                  'QUESTION_CATEGORY',
                  'JOB',
                  'UNIVERSITY',
                  'BODY_TYPE',
                  'REGION',
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Terms / Questions',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _CompactVersionTile(
                    title: 'Terms',
                    version: data.termSnapshot.version,
                    meta: data.termVersions,
                    description: data.termSnapshot.terms
                        .map((term) => '${term.type} · v${term.version}')
                        .join('  '),
                  ),
                  const SizedBox(height: 12),
                  _CompactVersionTile(
                    title: 'Choice Questions',
                    version: data.choiceSnapshot.values.isEmpty
                        ? 0
                        : data.choiceSnapshot.values.first.version,
                    meta: data.choiceVersions,
                    description: data.choiceSnapshot.values
                        .map((set) => '${set.questions.length} questions')
                        .join('  '),
                  ),
                  const SizedBox(height: 12),
                  _CompactVersionTile(
                    title: 'Essay Questions',
                    version: data.essaySnapshot.version,
                    meta: {'ESSAY': data.essayVersion.version},
                    description:
                        '${data.essaySnapshot.questions.length} questions',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Codebook Explorer',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final group in const [
                    'QUESTION_CATEGORY',
                    'JOB',
                    'UNIVERSITY',
                    'BODY_TYPE',
                    'REGION',
                  ]) ...[
                    _GroupSnapshotSection(
                      group: group,
                      snapshot: data.codebookSnapshot[group],
                      bodyShapeStory: group == 'BODY_TYPE'
                          ? bodyShapeStory
                          : null,
                      regionStory: group == 'REGION' ? regionStory : null,
                    ),
                    if (group != 'REGION') const SizedBox(height: 12),
                  ],
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBodyShapeStory(Map<String, CodeSnapshot> snapshots) {
    final bodyTypeSnapshot = snapshots['BODY_TYPE'];
    if (bodyTypeSnapshot == null) {
      return const Text('BODY_TYPE 스냅샷이 없습니다.');
    }

    final bodyShapeCodebook = _bodyShapeCodebookFromSnapshot(bodyTypeSnapshot);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '실제 컴포넌트: BasicProfileBodyShapeOptionList',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _GenderPreview(gender: 'male', codebook: bodyShapeCodebook),
        const SizedBox(height: 16),
        _GenderPreview(gender: 'female', codebook: bodyShapeCodebook),
      ],
    );
  }

  Widget _buildRegionStory(Map<String, CodeSnapshot> snapshots) {
    final regionSnapshot = snapshots['REGION'];
    if (regionSnapshot == null) {
      return const Text('REGION 스냅샷이 없습니다.');
    }

    final tree = RegionCodebookTree.fromSnapshot(
      CodebookSnapshot(
        version: regionSnapshot.version,
        codes: regionSnapshot.codes
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

    return _RegionPreview(tree: tree);
  }

  BodyShapeCodebook _bodyShapeCodebookFromSnapshot(CodeSnapshot snapshot) {
    final maleOptions = <BodyShapeOption>[];
    final femaleOptions = <BodyShapeOption>[];

    for (final code in snapshot.codes) {
      final option = BodyShapeOption(
        code: code.code,
        label: code.codeName,
        order: code.displayOrder,
      );

      final parent = code.parentCode?.toUpperCase();
      if (parent == 'BT_MALE' || code.code.toUpperCase().startsWith('BT_M_')) {
        maleOptions.add(option);
      }

      if (parent == 'BT_FEMALE' ||
          code.code.toUpperCase().startsWith('BT_F_')) {
        femaleOptions.add(option);
      }
    }

    maleOptions.sort((left, right) => left.order.compareTo(right.order));
    femaleOptions.sort((left, right) => left.order.compareTo(right.order));

    return BodyShapeCodebook(
      maleOptions: maleOptions.isEmpty
          ? snapshotCodesAsOptions(snapshot)
          : maleOptions,
      femaleOptions: femaleOptions.isEmpty
          ? snapshotCodesAsOptions(snapshot)
          : femaleOptions,
    );
  }

  List<BodyShapeOption> snapshotCodesAsOptions(CodeSnapshot snapshot) {
    final options = snapshot.codes
        .map(
          (code) => BodyShapeOption(
            code: code.code,
            label: code.codeName,
            order: code.displayOrder,
          ),
        )
        .toList();
    options.sort((left, right) => left.order.compareTo(right.order));
    return options;
  }
}

/// 코드북 목업 또는 라이브 응답 정보를 표시하는 카드.
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

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

class _KeyValueGrid extends StatelessWidget {
  final Map<String, int> entries;
  final List<String> expectedKeys;

  const _KeyValueGrid({required this.entries, required this.expectedKeys});

  @override
  Widget build(BuildContext context) {
    final orderedEntries = [
      for (final key in expectedKeys) MapEntry(key, entries[key]),
      for (final entry in entries.entries)
        if (!expectedKeys.contains(entry.key)) entry,
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: orderedEntries
          .map(
            (entry) => Chip(
              label: Text(
                entry.value == null
                    ? '${entry.key}: missing'
                    : '${entry.key}: v${entry.value}',
              ),
            ),
          )
          .toList(),
    );
  }
}

class _GroupSnapshotSection extends StatelessWidget {
  final String group;
  final CodeSnapshot? snapshot;
  final Widget? bodyShapeStory;
  final Widget? regionStory;

  const _GroupSnapshotSection({
    required this.group,
    required this.snapshot,
    this.bodyShapeStory,
    this.regionStory,
  });

  @override
  Widget build(BuildContext context) {
    final current = snapshot;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(group, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(width: 8),
                if (current != null) Text('v${current.version}'),
              ],
            ),
            const SizedBox(height: 12),
            if (current == null)
              const Text('응답이 없습니다.')
            else if (regionStory != null)
              regionStory!
            else
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final code in current.codes) Text(_codeLine(code)),
                ],
              ),
            if (bodyShapeStory != null) ...[
              const SizedBox(height: 16),
              bodyShapeStory!,
            ],
          ],
        ),
      ),
    );
  }

  String _codeLine(CommonCodeDetail code) {
    final parentSuffix = code.parentCode == null
        ? ''
        : ' -> ${code.parentCode}';
    return '${code.displayOrder}. ${code.codeName} (${code.code})$parentSuffix';
  }
}

class _CompactVersionTile extends StatelessWidget {
  final String title;
  final int version;
  final Map<String, int> meta;
  final String description;

  const _CompactVersionTile({
    required this.title,
    required this.version,
    required this.meta,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('$title · v$version'),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 8),
            Text(
              meta.entries
                  .map((entry) => '${entry.key}: ${entry.value}')
                  .join(' · '),
            ),
          ],
        ),
      ),
    );
  }
}

class _GenderPreview extends StatefulWidget {
  final String gender;
  final BodyShapeCodebook codebook;

  const _GenderPreview({required this.gender, required this.codebook});

  @override
  State<_GenderPreview> createState() => _GenderPreviewState();
}

class _GenderPreviewState extends State<_GenderPreview> {
  String? _selectedCode;

  @override
  Widget build(BuildContext context) {
    final options = widget.codebook.optionsForGender(widget.gender);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Gender: ${widget.gender}'),
        const SizedBox(height: 8),
        BasicProfileBodyShapeOptionList(
          options: options,
          selectedCode: _selectedCode,
          onSelected: (code) => setState(() => _selectedCode = code),
          padding: EdgeInsets.zero,
        ),
      ],
    );
  }
}

class _RegionPreview extends StatefulWidget {
  final RegionCodebookTree tree;

  const _RegionPreview({required this.tree});

  @override
  State<_RegionPreview> createState() => _RegionPreviewState();
}

class _RegionPreviewState extends State<_RegionPreview> {
  String? _selectedCode;

  @override
  Widget build(BuildContext context) {
    return RegionCodebookSelectionPanel(
      tree: widget.tree,
      selectedCode: _selectedCode,
      onSelected: (selection) => setState(() => _selectedCode = selection.code),
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
        child: Text('코드북을 불러오지 못했습니다.\n$error'),
      ),
    );
  }
}

class _CodebookPreviewData {
  final String repositoryLabel;
  final Map<String, int> currentVersions;
  final Map<String, CodeSnapshot> codebookSnapshot;
  final Map<String, int> termVersions;
  final TermSnapshot termSnapshot;
  final Map<String, int> choiceVersions;
  final Map<String, ChoiceQuestionSetSnapshot> choiceSnapshot;
  final CurrentVersionResponse essayVersion;
  final EssayQuestionSnapshot essaySnapshot;

  const _CodebookPreviewData({
    required this.repositoryLabel,
    required this.currentVersions,
    required this.codebookSnapshot,
    required this.termVersions,
    required this.termSnapshot,
    required this.choiceVersions,
    required this.choiceSnapshot,
    required this.essayVersion,
    required this.essaySnapshot,
  });
}
