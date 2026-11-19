#!/bin/sh
# Wait (up to 3 minutes) until the database accepts TCP connections, so the first
# deploy doesn't crash-loop while Postgres is still starting. Then run upstream's entrypoint.
/venv/bin/python - <<'PY'
import os, socket, sys, time
from urllib.parse import urlparse
u = urlparse(os.environ.get("DATABASE_CONNECTION_STRING", ""))
if not u.hostname:
    sys.exit(0)
port = u.port or 5432
for i in range(90):
    try:
        socket.create_connection((u.hostname, port), timeout=3).close()
        print(f"database {u.hostname}:{port} is reachable", flush=True)
        sys.exit(0)
    except OSError:
        if i % 10 == 0:
            print(f"waiting for database {u.hostname}:{port} ...", flush=True)
        time.sleep(2)
print("database still unreachable, starting anyway", flush=True)
PY
exec /venv/lib/python3.13/site-packages/keep/entrypoint.sh "$@"
