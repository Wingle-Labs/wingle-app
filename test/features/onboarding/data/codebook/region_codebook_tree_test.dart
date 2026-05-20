import 'package:flutter_test/flutter_test.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_entry.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/codebook_snapshot.dart';
import 'package:wingle/features/onboarding/domain/model/codebook/region_codebook_tree.dart';

void main() {
  test('REGION tree는 부모-자식 관계와 경로를 만든다', () {
    final tree = RegionCodebookTree.fromSnapshot(
      const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'R_11',
            codeName: '서울특별시',
            parentCode: null,
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_11220',
            codeName: '서초구',
            parentCode: 'R_11',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_11230',
            codeName: '강남구',
            parentCode: 'R_11',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_11230650',
            codeName: '역삼2동',
            parentCode: 'R_11230',
            displayOrder: 0,
          ),
        ],
      ),
    );

    expect(tree.roots.map((node) => node.code), ['R_11']);
    expect(tree.roots.first.children.map((node) => node.code), [
      'R_11230',
      'R_11220',
    ]);
    expect(tree.pathTo('R_11230650').map((node) => node.code), [
      'R_11',
      'R_11230',
      'R_11230650',
    ]);
    expect(tree.findByCode('R_11230')?.codeName, '강남구');
  });
}
