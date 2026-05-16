# Admin Access

- Admin URL: `https://test.wingle.kr/api/v1/admin.html`
- Purpose: verify approval queues, onboarding summaries, user status labels, and admin actions against the current test environment.

## Access Policy

- Admin credentials are private operational data.
- Do not write phone numbers, passwords, tokens, or session cookies into repo-tracked files.
- Use credentials only at execution time from a private source supplied by the user or local secure storage.

## When To Use Admin

- 승인 대기 목록이나 온보딩 상태가 실제로 어떻게 보이는지 확인할 때
- API 응답의 상태 값이 운영 화면 라벨과 일치하는지 검증할 때
- Swagger나 Notion만으로는 알 수 없는 관리자 동작을 확인할 때

## Current Visible Areas

The accessible page currently exposes at least:

- 관리자 로그인 entry point
- 승인 대기 목록
- 온보딩 현황
- 전체 유저 목록

Use these as operational clues, but prefer Swagger/OpenAPI for wire contracts.
