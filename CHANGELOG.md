# Changelog

Breaking changes come first in each entry. Applying an update rebuilds the services from this repo; Postgres data is kept.

## 0.55.0 (2026-11-19)

- First release of the template: Keep `0.55.0` (backend and UI, official images pinned by digest), Soketi `1.6.1` websocket server, Railway PostgreSQL 17.
- Username/password login (`AUTH_TYPE=DB`) with a generated admin password; provider credentials stored in Postgres; telemetry to keephq.dev disabled.
