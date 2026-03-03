# UnraidScripts

This repository contains a collection of custom bash scripts written for various tasks on an Unraid server.

I focus on balancing data integrity with system uptime for critical services.

## 📂 Included Scripts

### [Duplicati Backup Script](./Duplicati-Backup/)
This script automates the full backup of Unraid appdata containers to a remote destination via the Duplicati API. 

* **Method:** It stops non-critical containers to ensure a "cold" backup with zero file corruption.
* **Security:** It uses a secure API authentication method by feeding the login payload directly into curl via stdin. This ensures the password never appears in the system process list (`ps`).
* **Logic:** Targets specific Job IDs, making the script universal for any backup job you have configured in Duplicati.

### [Home Security Config Backup Script](./Home-Security-Config-Backup/)
This is a lightweight script designed for critical configuration files belonging to containers that must stay online 24/7.

* **Method:** Targets essential files like `acme.json`, `config.yml`, and Z-Wave databases without stopping the service.
* **Integrity:** Uses a "non-speculative" safety check (`find -mmin -2`) to see if a file was modified in the last 2 minutes. 
* **Reliability:** If a file is currently being written to, the script skips it to prevent copying corrupted data, maintaining 100% uptime for Reverse Proxy and Home Security services.