# Wingle Backend Repository

## Canonical Repo

- GitHub: `https://github.com/wingle-Labs/wingle-be`
- Verified HEAD at creation time: `7c765408882c4fbec6f3ad7c9d01c14449086a28`

## Local Access

Prefer an existing local clone if present:

```bash
test -d /Users/myknow/coding/wingle-be/.git && git -C /Users/myknow/coding/wingle-be status --short
```

If no local clone exists and source inspection is required, clone read-only into the sibling workspace:

```bash
git clone https://github.com/wingle-Labs/wingle-be.git /Users/myknow/coding/wingle-be
```

For faster first inspection when history is not needed:

```bash
git clone --filter=blob:none https://github.com/wingle-Labs/wingle-be.git /Users/myknow/coding/wingle-be
```

Do not store credentials in the clone, in app source, or in this skill. If GitHub authentication is required, use the already configured GitHub CLI/app session.

## First Inspection Checklist

Run these from the backend clone:

```bash
git status --short
git branch --show-current
find . -maxdepth 2 -type f | sort | sed -n '1,120p'
rg "spring|boot|gradle|maven|nestjs|typeorm|jpa|flyway|liquibase" -i .
```

Then identify the stack:

- Gradle/Spring: inspect `build.gradle`, `settings.gradle`, `src/main/resources/application*.yml`, `src/main/java` or `src/main/kotlin`.
- Maven/Spring: inspect `pom.xml`, `src/main/resources/application*.yml`, `src/main/java`.
- NestJS: inspect `package.json`, `src/**/*.controller.*`, `src/**/*.service.*`, `src/**/*.module.*`.

## API Trace Checklist

For a mobile app API question:

1. Start from Swagger/OpenAPI path and method.
2. Search backend route annotations or route constants.
3. Follow DTO validation and enum conversion.
4. Follow service transaction and state transition logic.
5. Follow repository/entity persistence.
6. Check exception handlers for HTTP status and response body.
7. Compare with Flutter app request DTO and repository.

Always cite exact backend files and line numbers when reporting findings.
