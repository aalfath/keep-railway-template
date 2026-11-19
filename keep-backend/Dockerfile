# Keep backend (FastAPI + gunicorn): REST API, alert ingestion webhooks, workflow engine.
# Official image, pinned by version and digest. Bump both together.
FROM us-central1-docker.pkg.dev/keephq/keep/keep-api:0.55.0@sha256:26f2ccedd4b3b0dac1fa3fac05831ba65d6fb8f1211bf523170792bc7ca66598

# Fixed settings for Railway. Every value can be overridden with a Railway variable of the same name.
# - AUTH_TYPE=DB: username/password login, the admin user is created on first boot.
# - SECRET_MANAGER_TYPE=DB: provider credentials are stored in Postgres, so the service needs no volume.
# - POSTHOG_DISABLED: no usage telemetry to keephq.dev.
ENV PORT=8080 \
    AUTH_TYPE=DB \
    SECRET_MANAGER_TYPE=DB \
    KEEP_DEFAULT_USERNAME=keep \
    PUSHER_APP_ID=1 \
    PUSHER_PORT=6001 \
    PUSHER_USE_SSL=false \
    PROMETHEUS_MULTIPROC_DIR=/tmp/prometheus \
    POSTHOG_DISABLED=true \
    USE_NGROK=false

EXPOSE 8080

# Same entrypoint as upstream: it builds the provider cache, runs the database migrations
# (gunicorn on_starting hook) and starts the API on port 8080.
ENTRYPOINT ["/venv/lib/python3.13/site-packages/keep/entrypoint.sh"]
CMD ["gunicorn", "keep.api.api:get_app", "--bind", "0.0.0.0:8080", "--workers", "4", "-k", "uvicorn.workers.UvicornWorker", "-c", "/venv/lib/python3.13/site-packages/keep/api/config.py", "--preload"]
