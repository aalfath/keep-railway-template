# Keep web UI (Next.js). The public entry point; it proxies browser API calls (/backend/*)
# to the backend over Railway's private network.
# Official image, pinned by version and digest. Bump both together.
FROM us-central1-docker.pkg.dev/keephq/keep/keep-ui:0.55.0@sha256:353893237bd225c05f68f23e5c5081c4ae03a24acf52b5857260b61b200d161b

# Fixed settings for Railway. Every value can be overridden with a Railway variable of the same name.
# PUSHER_PORT=443: the browser reaches the websocket service through its Railway HTTPS domain.
ENV PORT=3000 \
    AUTH_TYPE=DB \
    PUSHER_PORT=443 \
    POSTHOG_DISABLED=true \
    SENTRY_DISABLED=true

COPY --chown=nextjs:nodejs start.sh /app/start.sh

EXPOSE 3000

ENTRYPOINT ["/bin/sh", "/app/start.sh"]
