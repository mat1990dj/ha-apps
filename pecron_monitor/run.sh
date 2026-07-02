#!/usr/bin/env bash
set -e

CONFIG_PATH=/data/options.json

# Parse variables out of the Home Assistant UI settings using jq
USERNAME=$(jq --raw-output '.pecron_account.username' $CONFIG_PATH)
PASSWORD=$(jq --raw-output '.pecron_account.password' $CONFIG_PATH)
REGION=$(jq --raw-output '.pecron_account.region' $CONFIG_PATH)
PROD_KEY=$(jq --raw-output '.device_information.product_key' $CONFIG_PATH)
DEV_KEY=$(jq --raw-output '.device_information.device_key' $CONFIG_PATH)
AUTH_KEY=$(jq --raw-output '.device_information.auth_key // empty' $CONFIG_PATH)
LAN_IP=$(jq --raw-output '.device_information.lan_ip // empty' $CONFIG_PATH)
DEV_NAME=$(jq --raw-output '.device_information.device_name' $CONFIG_PATH)

MQTT_HOST=$(jq --raw-output '.mqtt_settings.mqtt_host' $CONFIG_PATH)
MQTT_PORT=$(jq --raw-output '.mqtt_settings.mqtt_port' $CONFIG_PATH)
MQTT_USER=$(jq --raw-output '.mqtt_settings.mqtt_username' $CONFIG_PATH)
MQTT_PASS=$(jq --raw-output '.mqtt_settings.mqtt_password' $CONFIG_PATH)

CONNECTION_MODE=$(jq --raw-output '.device_information.connection_mode // "Automatic"' $CONFIG_PATH)

# Build the base device parameters
DEVICE_BLOCK="  - product_key: \"${PROD_KEY}\"
    device_key: \"${DEV_KEY}\"
    name: \"${DEV_NAME}\""

# Dynamically append lan_ip if provided in the UI
if [ -n "${LAN_IP}" ]; then
  DEVICE_BLOCK="${DEVICE_BLOCK}
    lan_ip: \"${LAN_IP}\""
fi

# Dynamically append auth_key if provided in the UI
if [ -n "${AUTH_KEY}" ]; then
  DEVICE_BLOCK="${DEVICE_BLOCK}
    auth_key: \"${AUTH_KEY}\""
fi

# Dynamically generate the precise nested format expected
cat << EOF > /app/config.yaml
region: "${REGION}"
email: "${USERNAME}"
password: "${PASSWORD}"

devices:
${DEVICE_BLOCK}

poll_interval: 70

homeassistant:
  enabled: true
  mqtt_host: "${MQTT_HOST}"
  mqtt_port: ${MQTT_PORT}
  mqtt_user: "${MQTT_USER}"
  mqtt_password: "${MQTT_PASS}"
  discovery_prefix: "homeassistant"
  clear_discovery_on_startup: true

EOF

#tr '\240' ' ' < /app/config.yaml > /app/config.yaml.tmp && mv /app/config.yaml.tmp /app/config.yaml

sed -i 's/cache it in config.yaml as auth_key/auth_key is: " + str(auth_key) + " (cache it)/g' /app/*.py || true
echo "Config generated successfully. Starting real-time Pecron stream..."

# Initialize an empty string for our connection flags
CONN_FLAGS=""

# Read the dropdown value from the parsed Home Assistant options
case "${CONNECTION_MODE}" in
    "Local only")
        echo "Configuration set to: Local Only mode."
        CONN_FLAGS="--local"
        ;;
    "Cloud only")
        echo "Configuration set to: Cloud Only mode."
        CONN_FLAGS="--nolocal"
        ;;
    "Cloud REST only")
        echo "Configuration set to: Cloud REST Only mode."
        CONN_FLAGS="--rest-only"
        ;;
    "Automatic")
        # Fall through
        ;;
    *)
        echo "No valid connection mode selected, defaulting to Automatic."
        ;;
esac

# Fire up Logan's native script with unbuffered output
exec python3 -u pecron_monitor.py --homeassistant ${CONN_FLAGS}