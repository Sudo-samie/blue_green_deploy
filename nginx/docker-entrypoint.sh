#!/bin/sh
set -e

echo "================================================"
echo "Nginx Dynamic Configuration Setup"
echo "================================================"

# Set default values if not provided
ACTIVE_POOL=${ACTIVE_POOL:-blue}

# Calculate standby pool (opposite of active)
if [ "$ACTIVE_POOL" = "blue" ]; then
    STANDBY_POOL="green"
else
    STANDBY_POOL="blue"
fi

echo "Active Pool: $ACTIVE_POOL"
echo "Standby Pool: $STANDBY_POOL"

# Export variables for envsubst
export ACTIVE_POOL
export STANDBY_POOL

# Generate nginx.conf from template using envsubst
echo "Generating nginx.conf from template..."
envsubst '${ACTIVE_POOL} ${STANDBY_POOL}' < /etc/nginx/nginx.conf.template > /etc/nginx/nginx.conf

# Verify the generated configuration
echo "Testing nginx configuration..."
nginx -t

echo "Configuration generated successfully!"
echo "================================================"
cat /etc/nginx/nginx.conf
echo "================================================"

# Execute the original nginx entrypoint
exec nginx -g 'daemon off;'