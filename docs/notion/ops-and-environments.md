# Ops And Environments

Sources: `접근 경로 설정` (`34e406c3-c488-8097-88c2-ebdfc6f1086f`), `Wingle 개발 환경 SSH 접속 및 작업 방침` (`315406c3-c488-80c8-a988-d235649ed318`), `Docker Nginx 전환` (`315406c3-c488-807b-b1eb-c1e882dc8cf6`), `Wingle 이메일 및 계정 운영 정책` (`311406c3-c488-805a-bff8-f1a654628b19`).

## Public Operational URLs

- Swagger UI: `https://test.wingle.kr/api/v1/swagger-ui/index.html`
- Admin page: `https://test.wingle.kr/api/v1/admin.html`
- Test API domain: `test.wingle.kr`
- Storage domain: `storage.wingle.kr`
- Remote shell domain: `ssh.wingle.kr`

## Remote Environment

- Development server is a home-server based test/dev environment, not the final production hosting target.
- Remote shell uses public-key authentication only.
- Remote shell uses a non-default port.
- Direct credential and command examples are intentionally redacted: `[REDACTED_COMMAND]`.

## Project Server Layout

The server documents describe a project root with:

- Spring backend source.
- Docker Compose file.
- Environment file.
- PostgreSQL data volume.
- Spring log volume.
- MinIO data volume.

Sensitive file permissions are part of the operating model:

- Environment files are readable/writable only by development users.
- Docker 권한은 전용 그룹을 통해 관리된다.
- PostgreSQL data and application logs are mounted as volumes.

## Docker And Nginx

The infrastructure moved Nginx from host-level service to Docker Compose:

- Host Nginx is stopped/disabled.
- Docker Nginx terminates TLS and proxies API traffic to backend container.
- Nginx also proxies storage traffic to MinIO.
- Certificates are mounted read-only.
- Containers share a bridge network.

The compose topology includes:

- `nginx`
- `db` based on PostGIS PostgreSQL
- `backend-test`
- `minio`

## DNS And Domains

Cloudflare DNS is used for service domains. The documented routes include:

- `test.wingle.kr` for backend API.
- `storage.wingle.kr` for object storage entry.
- `ssh.wingle.kr` for remote shell entry.

## Account Policy

- Company email is managed through Zoho Mail.
- Personal accounts are used for individual work.
- Shared public-facing addresses are group or alias based.
- Super admin is limited to one owner.
- Two-factor authentication and least privilege are required.
- Billing owner permissions are separated from ordinary workspace roles.

## Redacted Source Notes

The source pages included concrete account names, admin credentials, local tunnel commands, and temporary signed file URLs. These were not copied into this repository. Use the original Notion source only when private operational details are explicitly needed.
