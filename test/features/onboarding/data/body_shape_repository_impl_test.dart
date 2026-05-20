import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:wingle/features/onboarding/data/body_shape_repository_impl.dart';

void main() {
  test('BodyShapeRepositoryImpl은 목업 codebook을 반환한다', () {
    final repository = BodyShapeRepositoryImpl(
      client: http.Client(),
      baseUrl: 'https://api.example.com',
    );

    final codebook = repository.fetchBodyShapeCodebook();

    expect(codebook.optionsForGender('male').first.code, 'slim');
    expect(codebook.optionsForGender('female').last.code, 'hidden');
  });
}

