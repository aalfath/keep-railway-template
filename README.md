[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/keep?utm_medium=integration&utm_source=button&utm_campaign=keep)

# Keep on Railway

One-click [Keep](https://github.com/keephq/keep) (open-source AIOps and alert management: one inbox for alerts from every monitoring tool, with deduplication, correlation into incidents and workflows) for Railway, with the full stack upstream ships.

**Version:** Keep `0.55.0`:
- backend `us-central1-docker.pkg.dev/keephq/keep/keep-api:0.55.0@sha256:26f2ccedd4b3b0dac1fa3fac05831ba65d6fb8f1211bf523170792bc7ca66598`
- UI `us-central1-docker.pkg.dev/keephq/keep/keep-ui:0.55.0@sha256:353893237bd225c05f68f23e5c5081c4ae03a24acf52b5857260b61b200d161b`
- websocket server Soketi `1.6.1` (`quay.io/soketi/soketi:1.6.1-16-debian@sha256:713223456cf16459833f9cccef5711055e9c546bf88d910bbd817601563ef762`, the Pusher-compatible server upstream's Compose file and Helm chart use)

## What it deploys

| Service | Source | What it does |
|---|---|---|
| `Keep` | `keep-frontend/` in this repo | Next.js web UI, the public entry point. Browser API calls go to `/backend/*`, which it proxies to `Keep Backend` over the private network. Health check `/api/healthcheck`. |
| `Keep Backend` | `keep-backend/` in this repo | FastAPI API, alert and webhook ingestion, workflow scheduler and event consumer. Runs the database migrations on boot. Private network only. Health check `/healthcheck`. |
| `Keep Websocket` | `keep-websocket/` in this repo | Soketi (Pusher protocol). Pushes new alerts and incidents to open browser tabs in real time. Has its own public domain because browsers connect to it directly. Health check `/`. |
| `Postgres` | Railway PostgreSQL 17 (with a volume) | All of Keep's data: alerts, incidents, workflows, users, and the credentials of connected providers (`SECRET_MANAGER_TYPE=DB`). |

No service other than Postgres keeps state, so only Postgres has a volume.

## Variables

The deployer is asked for nothing. All values are generated or derived:

- `KEEP_DEFAULT_PASSWORD` (on `Keep Backend`): generated password of the `keep` admin user, created on first boot. Read it in the service's **Variables** tab.
- `KEEP_JWT_SECRET` (backend) and `NEXTAUTH_SECRET` (UI): generated signing keys for sessions.
- `SOKETI_DEFAULT_APP_KEY` / `SOKETI_DEFAULT_APP_SECRET` (websocket): generated Pusher app credentials; the backend and UI reference them.
- `DATABASE_CONNECTION_STRING`: references to the `Postgres` service.
- `KEEP_API_URL` (backend): `https://<Keep domain>/backend`, the base URL shown in webhook instructions for your monitoring tools. `NEXTAUTH_URL` (UI): the UI's public URL. Change both if you add a custom domain to `Keep`; change `PUSHER_HOST` on `Keep` if you add one to `Keep Websocket`.
- Fixed settings (`AUTH_TYPE=DB`, `SECRET_MANAGER_TYPE=DB`, ports, `POSTHOG_DISABLED=true`, `SENTRY_DISABLED=true`) are in the Dockerfiles; any of them can be overridden with a Railway variable of the same name.

Optional features you can add later as variables on `Keep Backend`: an OpenAI key (`OPENAI_API_KEY`) for AI correlation and summaries, SMTP or other notification providers (set up in the UI), SSO (`AUTH_TYPE=KEYCLOAK`/`OIDC`/`AUTH0`, set on both `Keep Backend` and `Keep`). See the [Keep configuration reference](https://docs.keephq.dev/deployment/configuration).

## After deploy

1. Open the `Keep` public URL and sign in as `keep` with the `KEEP_DEFAULT_PASSWORD` from `Keep Backend`'s variables.
2. Go to **Providers** to connect your monitoring tools (Prometheus, Grafana, Datadog, Sentry, CloudWatch and many more), or send alerts to the webhook URL shown under **Settings → Webhook**.

## Updates

Every service except Postgres builds from this repo. When we bump the pinned versions on `main`, Railway shows an "update available" notice on your project, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first: breaking changes are listed at the top of each entry. Keep migrates its database on boot.

## Local test

`test/compose.yml` runs the same Dockerfiles locally with a plain Postgres: `docker compose -f test/compose.yml up -d --build`, then open http://localhost:3000.
