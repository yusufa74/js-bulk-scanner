# JS Bulk Scanner

A Bash script to extract sensitive keywords, full URLs, and API endpoints from multiple JavaScript files.

## Features

- Downloads and scans each JavaScript file URL listed in an input file.
- Detects sensitive keywords like `apikey`, `token`, `auth`, `secret`, `password`, `jwt`, and `bearer`.
- Extracts full URLs and relative API endpoints found inside JS files.
- Avoids duplicates and groups findings per JS file.
- Saves results in a `findings.txt` report.

## Usage

1. Make sure you have Bash and `curl` installed.

2. Prepare a text file (e.g. `js-wayback.txt`) with URLs of JavaScript files to scan, one URL per line:


3. Make the script executable:

```bash
chmod +x js-bulk-scanner.sh
./js-bulk-scanner.sh

