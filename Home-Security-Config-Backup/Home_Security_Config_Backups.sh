#!/bin/bash

# Log output to flash drive
LOG_FILE="/boot/logs/config_backup_log.txt"
exec 1>> $LOG_FILE 2>&1
echo "=========================================================="
echo "--- Config Backup Start: $(date) ---"
echo "=========================================================="

# Set your main backup destination
BACKUP_DIR="/mnt/user/backups"

# Back up Frigate config
echo "Backing up Frigate config..."
mkdir -p "$BACKUP_DIR/frigate_configs"
rsync -av /mnt/user/appdata/frigate/config.yml "$BACKUP_DIR/frigate_configs/"

# Back up Coturn config
echo "Backing up Coturn config..."
mkdir -p "$BACKUP_DIR/coturn_configs"
rsync -av /mnt/user/appdata/coturn/turnserver.conf "$BACKUP_DIR/coturn_configs/"

# Back up Z-Wave-JS-UI core files
echo "Backing up Z-Wave-JS-UI core files..."
mkdir -p "$BACKUP_DIR/zwave-js-ui_configs"
if [[ $(find /mnt/user/appdata/zwave-js-ui/*.json* -mmin -2) ]]; then
    echo "WARNING: Z-Wave database files were modified recently. Skipping."
else
    rsync -av /mnt/user/appdata/zwave-js-ui/nodes.json "$BACKUP_DIR/zwave-js-ui_configs/"
    rsync -av /mnt/user/appdata/zwave-js-ui/settings.json "$BACKUP_DIR/zwave-js-ui_configs/"
    rsync -av /mnt/user/appdata/zwave-js-ui/users.json "$BACKUP_DIR/zwave-js-ui_configs/"
    rsync -av /mnt/user/appdata/zwave-js-ui/*.jsonl "$BACKUP_DIR/zwave-js-ui_configs/"
fi

# Back up Homebridge config and persist directory
echo "Backing up Homebridge configs..."
mkdir -p "$BACKUP_DIR/homebridge_configs/persist"
if [[ $(find /mnt/user/appdata/homebridge/persist/ -mmin -2) ]] || [[ $(find /mnt/user/appdata/homebridge/config.json -mmin -2) ]]; then
    echo "WARNING: Homebridge files were modified recently. Skipping."
else
    rsync -av /mnt/user/appdata/homebridge/config.json "$BACKUP_DIR/homebridge_configs/"
    rsync -av /mnt/user/appdata/homebridge/persist/ "$BACKUP_DIR/homebridge_configs/persist/"
    rsync -av /mnt/user/appdata/homebridge/startup.sh "$BACKUP_DIR/homebridge_configs/"
fi

# Backup DuckDNS config
echo "Backing up DuckDNS config..."
mkdir -p "$BACKUP_DIR/duckdns_configs"
rsync -av /mnt/user/appdata/duckdns/logrotate.conf "$BACKUP_DIR/duckdns_configs/"

# Backup Traefik configs
echo "Backing up Traefik configs..."
mkdir -p "$BACKUP_DIR/traefik_configs"
rsync -av /mnt/user/appdata/traefik/traefik.yml "$BACKUP_DIR/traefik_configs/"
rsync -av /mnt/user/appdata/traefik/fileConfig.yml "$BACKUP_DIR/traefik_configs/"

if [[ $(find /mnt/user/appdata/traefik/acme.json -mmin -2) ]]; then
    echo "WARNING: acme.json was modified recently. Skipping."
else
    rsync -av /mnt/user/appdata/traefik/acme.json "$BACKUP_DIR/traefik_configs/"
fi

if [[ $(find /mnt/user/appdata/traefik/acme-cloudflare.json -mmin -2) ]]; then
    echo "WARNING: acme-cloudflare.json was modified recently. Skipping."
else
    rsync -av /mnt/user/appdata/traefik/acme-cloudflare.json "$BACKUP_DIR/traefik_configs/"
fi

echo "--- Config Backup Finished: $(date) ---"
exit 0