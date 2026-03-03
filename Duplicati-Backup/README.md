# Duplicati Backup

This script automates the backup of Unraid containers to a remote destination (Cloud Storage, WebDAV, etc.) via the Duplicati API. 

It targets a specific JOB ID, meaning it can be used for any backup task you have configured within the Duplicati WebUI.

I place this in User Scripts on Unraid and set a CRON for it to run Daily at my chosen backup time. (I like to use [Cron tab Guru](https://crontab.guru) to double-check my Cron)

## 🛠 Setup

1. Copy `Duplicati_Backup_secret.conf.example` to `Duplicati_Backup_secret.conf`.

2. Enter your **Duplicati Passphrase** in the new `.conf` file.
    
        DUPLICATI_PASS="Your_Password"

     (*IF USING UNRAID TEMPLATE MAKE SURE THIS IS THE SAME PASSWORD AS WEBUI ENVIRONMENT VARIABLE IF THAT IS SET IN YOUR UNRAID TEMPLATE*)

3. Move the `.conf` file to `/boot/config/scripts/secrets/` on your Unraid flash drive. (Create the directory if it does not exist)

## 📄 Script Logic

* **Container Safety:** Stops specific Docker containers (excluding Home Security services) to ensure a clean backup.
* **Secure API Auth:** Requests an API token by feeding the login payload directly into curl via stdin, ensuring the password never appears in the system process list (`ps`).
* **Job Execution:** Triggers **Job ID 2** (Update the script with your specific JOB ID).
* **Startup Order:** Restarts databases first to ensure they are stabilized before starting the remaining containers.

## 🔗 Links

* [Main Project Page](../)
* [View Script Code](./Duplicati_Backup.sh)