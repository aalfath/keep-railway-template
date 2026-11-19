# Soketi: Pusher-compatible websocket server that pushes new alerts and incidents
# to open Keep browser tabs in real time (the server upstream ships for this).
# Official image, pinned by version and digest. Bump both together.
FROM quay.io/soketi/soketi:1.6.1-16-debian@sha256:713223456cf16459833f9cccef5711055e9c546bf88d910bbd817601563ef762

# One Pusher app (id 1). Its key and secret come from the template's generated
# SOKETI_DEFAULT_APP_KEY / SOKETI_DEFAULT_APP_SECRET variables.
ENV SOKETI_PORT=6001 \
    SOKETI_DEFAULT_APP_ID=1 \
    SOKETI_USER_AUTHENTICATION_TIMEOUT=3000 \
    SOKETI_DEBUG=0

EXPOSE 6001
