import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_entry.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/job_codebook_tree.dart';

void main() {
  test('JOB tree는 부모-자식 관계와 경로를 만든다', () {
    final tree = JobCodebookTree.fromSnapshot(
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

    expect(tree.roots.map((node) => node.code), ['J1', 'J2']);
    expect(tree.childrenOf('J1').map((node) => node.code), ['J101', 'J102']);
    expect(tree.pathTo('J101').map((node) => node.code), ['J1', 'J101']);
    expect(tree.findByCode('J2')?.codeName, '전문직');
  });
}
