# Home Security Config Backup (Lightweight)

This script performs a lightweight backup of critical configuration files directly to the `/mnt/user/backups` directory. 

Unlike the Duplicati backup, this script is designed to run while containers stay **online**, ensuring your Reverse Proxy (Traefik) and Home Security (Homebridge, Frigate, etc.) never go down.

## 🛠 Setup

1. Place `Home_Security_Config_Backups.sh` into your Unraid User Scripts.

2. Set a CRON schedule (e.g., Daily) that does not overlap with your main Duplicati backup to avoid resource contention.

3. Ensure your `BACKUP_DIR` exists on your array.

## 📄 Script Logic

* **Non-Speculative Safety:** Uses `find -mmin -2` to check if active database files (Z-Wave `.jsonl`) or certificate files (`acme.json`) were modified in the last 2 minutes.
* **Conditional Rsync:** If a file was recently modified, the script skips it for that run to prevent copying "half-written" or corrupted data.
* **Targeted Backups:** Only copies the "brains" of the containers (configs/persist folders) while ignoring bulky, non-essential data like `node_modules` or logs.

## 🔗 Links

* [Main Project Page](../)
* [View Script Code](./Home_Security_Config_Backups.sh)