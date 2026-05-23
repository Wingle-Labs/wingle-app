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

  test('REGION tree는 일반구가 시와 형제 코드로 내려오면 시와 구를 2레벨 라벨로 묶는다', () {
    final tree = RegionCodebookTree.fromSnapshot(
      const CodebookSnapshot(
        version: 1,
        codes: [
          CodebookEntry(
            code: 'R_31',
            codeName: '경기도',
            parentCode: null,
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_31190',
            codeName: '용인시',
            parentCode: 'R_31',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_31191',
            codeName: '처인구',
            parentCode: 'R_31',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_31192',
            codeName: '기흥구',
            parentCode: 'R_31',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_31193',
            codeName: '수지구',
            parentCode: 'R_31',
            displayOrder: 0,
          ),
          CodebookEntry(
            code: 'R_31193560',
            codeName: '동천동',
            parentCode: 'R_31193',
            displayOrder: 0,
          ),
        ],
      ),
      includeEntry: (entry, entriesByCode) => entry.code != 'R_31190',
      resolveCodeName: (entry, entriesByCode) {
        if (!entry.code.startsWith('R_') || !entry.codeName.endsWith('구')) {
          return entry.codeName;
        }

        final digits = entry.code.substring(2);
        if (digits.length != 5 || digits.endsWith('0')) {
          return entry.codeName;
        }

        final city = entriesByCode['R_${digits.substring(0, 4)}0'];
        if (city == null || city.parentCode != entry.parentCode) {
          return entry.codeName;
        }

        return '${city.codeName} ${entry.codeName}';
      },
    );

    expect(tree.childrenOf('R_31').map((node) => node.code), [
      'R_31192',
      'R_31193',
      'R_31191',
    ]);
    expect(tree.findByCode('R_31193')?.codeName, '용인시 수지구');
    expect(tree.pathTo('R_31193560').map((node) => node.code), [
      'R_31',
      'R_31193',
      'R_31193560',
    ]);
  });
}
