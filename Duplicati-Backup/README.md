# Duplicati Koofr Backup
This script automates the backup of my Unraid containers to Koofr via the Duplicati API. I'm just targeting the JOB ID so you are not limited to Koofr, I'm using WebDAV and Koofr on this job but in theory (I haven't tested) this script should target any job id to run you set.

I place this in User Scripts on Unraid and set a CRON for it to run Daily at my chosen backup time. (I like to use [Cron tab Guru](https://crontab.guru) to double check my Cron)

## 🛠 Setup
1. Copy `Daily_Koofr_Backups_secret.conf.example` to `Daily_Koofr_Backups_secret.conf`.
2. Enter your **Duplicati Passphrase** in the new `.conf` file.
    
        DUPLICATI_PASS="Your_Password"

     (*IF USING UNRAID TEMPLATE MAKE SURE THIS IS THE SAME PASSWORD AS WEBUI ENVIORNMENT VARIABLE IF THAT IS SET IN YOUR UNRAID TEMPLATE*)
3. Move the `.conf` file to `/boot/config/scripts/secrets/` on your Unraid flash drive. (Create if it does not exist)

## 📄 Script Logic
* Stops specific Docker containers (excluding Home Security - Home Security can be any set of containers you like).
* Requests an API token from Duplicati.
* Secure API Auth: Feeds the login payload directly into curl via stdin to ensure the password never appears in the system process list (ps).
* Triggers **Job ID 2**. (Change JOB ID For your backup.)
* Restarts databases, then all other containers. (Ensure DBs come up first)

## 🔗 Links
* [Main Project Page](../)
* [View Script Code](./Daily_Koofr_Backup.sh)
