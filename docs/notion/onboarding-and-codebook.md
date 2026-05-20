# Onboarding And Codebook

Sources: `온보딩 로직 MOCK -> LIVE 구현 및 테스트` (`35c406c3-c488-8033-a4f4-d267e5b4baa2`), `코드북 버전 관리 전략` (`335406c3-c488-80bc-8bbf-e859bea8ed81`), `객관식 질문 & 주관식 질문 db 코드북 반영` (`350406c3-c488-8051-b709-febc1ce74c0c`), `온보딩` (`35d406c3-c488-80fd-936c-ea69600daa28`).

## App Bootstrap And Codebook

- Codebook data is treated as server-owned SSOT and client-local data is a cache.
- App startup should compare local versions with server current versions.
- If a group version differs, the app fetches the full snapshot for only the changed groups.
- Codebooks are expected to support grouped snapshot requests so the app can fetch one or many groups in one call.

## Codebook Groups

The current app/backend discussion covers these groups:

- `BODY_TYPE`
- `REGION`
- `JOB`
- `UNIVERSITY`
- `QUESTION_CATEGORY`
- `CHOICE_QUESTIONS`

`REGION` and `JOB` have parent-child hierarchy. UI should parse them as trees, not flat lists.

## Codebook Schema Rules

- `group_codes` defines groups such as body type and region.
- `common_codes` defines codes and can self-reference via `parentCode`.
- `codebook` stores active snapshot version per group.
- `codebook_common_code` maps snapshots to active common codes.
- Code rows should not be updated or deleted in-place. Changes deactivate the old code and insert a new one.

## Snapshot API Shape

`GET /api/v1/codebook/snapshot?groups=BODY_TYPE,REGION`

The response is keyed by group code:

```json
{
  "BODY_TYPE": {
    "version": 1,
    "codes": [
      {"code": "BT_MALE", "codeName": "남성 체형", "parentCode": null}
    ]
  },
  "REGION": {
    "version": 1,
    "codes": [
      {"code": "R_11", "codeName": "서울특별시", "parentCode": null}
    ]
  }
}
```

## Choice And Essay Questions

- Choice questions reuse the codebook-like pattern through question categories.
- `QUESTION_CATEGORY` contains five categories such as family, life, personality, love, and career/economy.
- Choice question sets are versioned independently per category.
- If only one category changes, only that category version should increase.
- Questions are immutable. Edits deactivate the old question and create a new question.
- Essay questions are managed as a single versioned list rather than a category codebook.

## Education Verification Flow

Education flow should support both known and unknown schools:

```text
학교 선택
  - 코드북에 있는 학교: 이메일 인증 또는 증명서 업로드 선택
  - 코드북에 없는 학교: 직접 입력 후 증명서 업로드
```

If a school exists but the email domain does not match backend data, the user should be guided to certificate upload rather than being blocked.

## Current QA Findings

- Optional terms can be skipped while continuing signup.
- Pass verification can remain mocked while validating the rest of signup.
- Codebook endpoint authentication issue was identified as a frontend header handling issue, not necessarily a backend requirement.
- Required choice and essay questions must be complete before state transition.
