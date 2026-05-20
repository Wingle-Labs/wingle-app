# Wingle Notion Knowledge Base

Last updated: 2026-05-20

이 디렉토리는 Notion 데이터베이스 `Wingle - 가치관 기반 소개팅`과 내부 연결 문서를 개발/API 중심으로 학습해 정리한 로컬 지식베이스다.

## Scope

- 시작점: `collection://2b6406c3-c488-81a3-8fa9-000bd1336a00`
- 우선순위: API, 온보딩, 코드북, 운영 환경, 배포, 현황관리
- 링크 정책: 내부 Notion 링크는 재귀적으로 추적하되, 이번 정리는 개발/API 관련성이 높은 문서를 우선 반영한다.
- 외부 링크 정책: 원문 수집 대상에서 제외하고 문맥과 목적만 기록한다.

## Documents

- [API and Backend](api-and-backend.md): API 계약, 백엔드 정책, 파일/회원가입/온보딩 상태.
- [Onboarding and Codebook](onboarding-and-codebook.md): 온보딩 흐름, 코드북 동기화, 질문 버전 관리.
- [Ops and Environments](ops-and-environments.md): 서버, 도메인, Docker/Nginx, 계정 운영 원칙.
- [Product and Status](product-and-status.md): 제품 방향, MVP 범위, 현재 진행 상태.
- [Link Index](link-index.md): 방문한 Notion 페이지와 내부 연결 상태.

## Redaction Policy

- 계정명, 관리자 인증값, 개인 연락처, 원문 접속 명령, 임시 서명 URL은 보존하지 않는다.
- 민감한 운영 세부값은 `[REDACTED_ACCOUNT]`, `[REDACTED_SECRET]`, `[REDACTED_COMMAND]`로 표기한다.
- 공개 운영 URL, 공개 Swagger URL, 엔드포인트명, 도메인 설계 원칙은 보존한다.

## Primary Sources

- Notion DB: `2b6406c3c4888081b99ad5202f555ff1`
- Data Source: `2b6406c3-c488-81a3-8fa9-000bd1336a00`
- 주요 페이지: `API 명세서 2`, `온보딩 로직 MOCK -> LIVE 구현 및 테스트`, `코드북 버전 관리 전략`, `그룹별 코드북 스냅샷 일괄 조회`, `현황관리`, `Wingle 프로젝트 통합 분석 보고서`.
