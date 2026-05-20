# Product And Status

Sources: `Wingle 프로젝트 통합 분석 보고서` (`332406c3-c488-8150-b2f7-d787a4c57200`), `Wingle 프로젝트: 현황 공유 문서` (`2c2406c3-c488-8082-85d2-d5149d6d7be0`), `현황관리` (`34e406c3-c488-803a-b7a5-cbede65da3fd`).

## Product Definition

Wingle is a value-based dating service. The product direction is to reduce fatigue from appearance-first dating apps by matching around values, habits, personality, interests, and relationship preferences.

## Core Value Proposition

- Fewer but higher quality recommendations.
- Text and values first, not appearance-first browsing.
- Reduced emotional fatigue compared to infinite swipe patterns.
- Exclusive relationship state after successful connection.
- Safety and trust through verification, reporting, blocking, and acquaintance blocking.

## MVP Scope

The Notion product documents define MVP around:

1. Phone-based signup and login.
2. Identity verification.
3. Profile input.
4. Value question input.
5. Profile card search and receipt.
6. Coffee chat.
7. Rotation dating.
8. Exclusive connect state.
9. Settings and account/security controls.

## Matching Concepts

- Users receive a limited number of profile cards.
- Search criteria can include age, region, gender, matching values, and mismatching values.
- Coffee chat is a lightweight conversation phase before connection.
- If a connection succeeds, other active coffee chats are cleaned up and the user enters an exclusive state.
- Rotation dating is designed around hot time entry, ready state, icebreaking, one-on-one rotation, and final selection.

## Architecture Direction

- Flutter app with Riverpod, GoRouter, Hive, Firebase integrations, localization, and Widgetbook.
- Feature-first structure with `data`, `domain`, and `presentation` layers.
- Repository pattern is preferred to allow mock/live switching.
- UI state and app/business state are intentionally separated.
- Design system uses semantic design values and Widgetbook validation.

## Current State

- Design system and onboarding UI foundations are partially implemented.
- Routing, shared input components, login/signup UI, and Widgetbook entries exist.
- The app is still closer to onboarding/common UI construction than full MVP completion.
- Main value flow after onboarding, especially card search, coffee chat, and connect, remains the largest product gap.

## Status Management Practice

The `현황관리` page defines the working protocol:

- Create a work page for each task.
- Record related documents inside the task page.
- Check off completed work.
- Record blockers and issues.
- Mention related people and link relevant assets.

## Priority Guidance

- Close the signup/onboarding vertical flow first.
- Lock the API contract for state transitions and cacheable resources.
- Replace remaining mock/stub integrations where the user flow depends on trust.
- Complete codebook/question local caching before building dependent UI at scale.
- Build the smallest card search to coffee chat vertical slice after onboarding.
