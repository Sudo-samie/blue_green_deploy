#!/bin/sh
set -e

echo " Configuring Nginx for active pool: $ACTIVE_POOL"

if [ "$ACTIVE_POOL" = "blue" ]; then
  export PRIMARY=app_blue
  export BACKUP=app_green
  export PRIMARY_PORT="$BLUE_PORT"
  export BACKUP_PORT="$GREEN_PORT"
else
  export PRIMARY=app_green
  export BACKUP=app_blue
  export PRIMARY_PORT="$GREEN_PORT"
  export BACKUP_PORT="$BLUE_PORT"
fi

# Replace variables in nginx.conf.template and generate nginx.conf
envsubst "${PRIMARY} ${BACKUP} ${PRIMARY_PORT} ${BACKUP_PORT}" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

echo "✅ Starting Nginx with primary=$PRIMARY on port=$PRIMARY_PORT"
exec nginx -g 'daemon off;'
