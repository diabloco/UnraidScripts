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

# Back up Z-Wave-JS-UI store directory
echo "Backing up Z-Wave-JS-UI store..."
mkdir -p "$BACKUP_DIR/zwave-js-ui_configs/store"
rsync -av /mnt/user/appdata/zwave-js-ui/store/ "$BACKUP_DIR/zwave-js-ui_configs/store/"

# Back up Homebridge config and persist directory
echo "Backing up Homebridge configs..."
mkdir -p "$BACKUP_DIR/homebridge_configs/persist"
rsync -av /mnt/user/appdata/homebridge/config.json "$BACKUP_DIR/homebridge_configs/"
rsync -av /mnt/user/appdata/homebridge/persist/ "$BACKUP_DIR/homebridge_configs/persist/"

echo "--- Config Backup Finished: $(date) ---"
exit 0