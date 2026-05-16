# Codebook Bootstrap

## Sync Flow

1. 앱 시작 시 `BootstrapInitializer.initialize()`를 호출한다.
2. 로컬 Hive `codebook_metadata`에서 버전을 읽는다.
3. 서버 `/api/v1/codebook/current-versions`를 조회한다.
4. 로컬/서버 버전을 비교해 outdated group을 계산한다.
5. 필요한 group만 `/api/v1/codebook/snapshot?groups=...`로 조회한다.
6. 성공한 snapshot만 `codebook_snapshot`에 전체 교체 저장한다.
7. 앱 실행을 계속 진행한다.

## Cache Strategy

- `codebook_metadata`
  - 그룹별 최신 버전만 저장한다.
- `codebook_snapshot`
  - 그룹별 snapshot 전체를 저장한다.
- codebook별 Hive box는 만들지 않는다.

## Failure Policy

- 로컬 캐시가 있고 서버 조회가 실패하면 기존 캐시로 진행한다.
- 로컬 캐시가 없고 서버 조회가 실패하면 bootstrap 실패로 반환한다.
- 일부 그룹만 실패하면 성공한 그룹만 교체 저장하고, 실패 그룹은 기존 캐시를 유지한다.

## Bootstrap Responsibility

- Splash Widget 내부에 비즈니스 로직을 두지 않는다.
- bootstrap layer는 앱 초기화 orchestration만 책임진다.
- Riverpod state에는 전체 codebook 데이터를 올리지 않는다.

## Versioning Rule

- 서버는 any change 시 version을 증가시킨다.
- 클라이언트는 snapshot 전체 교체 전략을 사용한다.
- comparison 기준은 group version이다.

