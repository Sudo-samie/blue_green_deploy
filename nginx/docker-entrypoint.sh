#!/bin/sh
set -e

echo " Configuring Nginx for active pool: $ACTIVE_POOL"

# Determine which pool is primary vs backup
if [ "$ACTIVE_POOL" = "blue" ]; then
  export PRIMARY="app_blue"
  export BACKUP="app_green"
  export PRIMARY_PORT="$BLUE_PORT"
  export BACKUP_PORT="$GREEN_PORT"
elif [ "$ACTIVE_POOL" = "green" ]; then
  export PRIMARY="app_green"
  export BACKUP="app_blue"
  export PRIMARY_PORT="$GREEN_PORT"
  export BACKUP_PORT="$BLUE_PORT"
else
  echo " Unknown ACTIVE_POOL: '$ACTIVE_POOL' (expected 'blue' or 'green')"
  echo "Defaulting to blue as primary."
  export PRIMARY="app_blue"
  export BACKUP="app_green"
  export PRIMARY_PORT="$BLUE_PORT"
  export BACKUP_PORT="$GREEN_PORT"
fi

# Substitute variables in nginx.conf.template and generate nginx.conf

echo " Generating /etc/nginx/nginx.conf..."
envsubst "${PRIMARY} ${BACKUP} ${PRIMARY_PORT} ${BACKUP_PORT}" < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf
echo " Generated /etc/nginx/nginx.conf:"

# Optional: wait a few seconds for apps to become ready
echo " Waiting for app containers to initialize..."
sleep 5

echo " Starting Nginx with PRIMARY=$PRIMARY ($PRIMARY_PORT), BACKUP=$BACKUP ($BACKUP_PORT)"

exec nginx -g 'daemon off;'
