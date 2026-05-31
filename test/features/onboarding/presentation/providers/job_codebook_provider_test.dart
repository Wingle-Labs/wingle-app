import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_models.dart';
import 'package:wingle/features/onboarding/presentation/providers/job_codebook_provider.dart';

void main() {
  test('buildJobCodebookTree는 무직을 루트 직업으로 승격한다', () {
    final tree = buildJobCodebookTree(
      const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'J1',
            codeName: '일반',
            parentCode: null,
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'J101',
            codeName: '무직',
            parentCode: 'J1',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'J102',
            codeName: '학생',
            parentCode: 'J1',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'J2',
            codeName: '전문직',
            parentCode: null,
            displayOrder: 0,
          ),
        ],
      ),
    );

    expect(tree.roots.map((node) => node.code), contains('J101'));
    expect(tree.findByCode('J101')?.parentCode, isNull);
    expect(tree.pathTo('J101').map((node) => node.code), ['J101']);
    expect(tree.childrenOf('J1').map((node) => node.code), ['J102']);
  });
}
