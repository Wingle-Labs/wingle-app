# Widgetbook Vercel CI/CD

## Goal

Widgetbook을 Flutter web 정적 산출물로 빌드한 뒤 Vercel에 배포한다.

## Flow

1. GitHub Actions가 `pull_request`와 `main` push를 감지한다.
2. `flutter pub get`으로 의존성을 설치한다.
3. `flutter build web -t lib/widgetbook.dart --release`로 Widgetbook을 빌드한다.
4. PR은 preview URL을 배포하고, PR 코멘트에 URL을 남긴다.
5. `main` push는 production 배포를 수행한다.

## Branch Policy

- `pull_request` -> preview deployment
- `main` push -> production deployment

## Split Workflows

- [`.github/workflows/widgetbook-vercel-preview.yml`](/Users/myknow/coding/wingle/.github/workflows/widgetbook-vercel-preview.yml)
- [`.github/workflows/widgetbook-vercel-prod.yml`](/Users/myknow/coding/wingle/.github/workflows/widgetbook-vercel-prod.yml)

## Required Secret

- `VERCEL_TOKEN`

## Notes

- Flutter web 산출물을 직접 배포하므로 별도 Node build pipeline은 두지 않는다.
- Widgetbook 전용 배포이며, 앱 본체는 Vercel 배포 대상이 아니다.
