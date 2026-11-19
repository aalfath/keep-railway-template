#!/bin/sh
# Next.js standalone binds to $HOSTNAME; the container runtime sets it to the
# container's name, so force all interfaces before handing over to upstream's entrypoint.
export HOSTNAME=0.0.0.0
exec /app/entrypoint.sh
