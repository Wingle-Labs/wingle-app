---
name: wingle-backend-context
description: Use when working with the Wingle backend GitHub repository `wingle-Labs/wingle-be`, including backend implementation analysis, controller/service/entity tracing, Swagger-to-code verification, API behavior debugging, status transition checks, and comparing mobile app assumptions against backend source.
---

# Wingle Backend Context

Use this skill to inspect the Wingle backend repository as a source of truth behind Swagger and Notion. This skill complements `api-backend-context`; for app API work, use both when backend implementation details matter.

## Repo

Read `references/repo.md` before cloning or inspecting the backend repository.

Canonical repository:

```text
https://github.com/wingle-Labs/wingle-be
```

## Workflow

1. Confirm the question scope: endpoint behavior, schema mismatch, status transition, admin behavior, file upload, auth, notification, or persistence.
2. Check Swagger/OpenAPI first through `api-backend-context` when the task concerns API contracts.
3. Inspect backend source only after identifying the relevant endpoint, model, or domain.
4. Prefer read-only commands: `rg`, `git grep`, `git show`, `sed`, `nl`, `find`, and framework-specific test commands only when needed.
5. Trace implementation in this order:
   - Route/controller handler
   - Request DTO or validation layer
   - Service/use-case method
   - Repository/entity/query layer
   - Response DTO/mapper
   - Exception handler/status code mapping
   - Security/auth annotation or filter
6. Compare backend implementation with:
   - Swagger request/response schema
   - Notion policy
   - Mobile app repository/provider assumptions
7. Report concrete file references and line numbers from the backend repo and app repo where relevant.

## Framework Detection

Do not assume the backend stack. Inspect root files first:

- `build.gradle`, `settings.gradle`, `gradlew` -> likely Spring/Gradle
- `pom.xml` -> likely Spring/Maven
- `package.json`, `nest-cli.json` -> likely NestJS/Node
- `docker-compose.yml`, `Dockerfile`, `application*.yml`, `.env.example` -> runtime/config clues

After detection, use local framework conventions without inventing architecture.

## Search Patterns

For Spring-style code, start with:

```bash
rg "@(Get|Post|Put|Patch|Delete|Request)Mapping|@RestController|@Controller" .
rg "profiles|contacts|choice-questions|essay-questions|notifications|codebook" .
rg "onboardingStatus|PROFILE_REJECTED|ONBOARDING_COMPLETED|AWAITING_APPROVAL" .
```

For NestJS-style code, start with:

```bash
rg "@(Controller|Get|Post|Put|Patch|Delete)\\(" .
rg "profiles|contacts|choice-questions|essay-questions|notifications|codebook" .
```

## Output Format

For analysis requests, answer with:

- **Conclusion**: direct answer or implementation decision.
- **Backend Evidence**: files and line references from `wingle-be`.
- **Contract Comparison**: Swagger/Notion/app differences, if any.
- **App Impact**: what the Flutter app should do.
- **Risks/Unknowns**: only unresolved facts that affect implementation.

## Safety

- Never write backend credentials, admin credentials, tokens, or `.env` contents into app files or skill files.
- Do not run destructive commands, migrations, admin actions, or production-like API calls unless the user explicitly asks and the target is safe.
- Do not modify the backend repository unless the user explicitly asks for backend changes.
- If backend and Swagger disagree, state the disagreement instead of silently choosing one.
