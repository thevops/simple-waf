#!/bin/bash

# 1)skrypt PHP
# ---------------------------------------
# <?php
# $logfile = '/website/directory/.swaf/script_access.log';
# $line = gmdate("Y-m-d H:i:s", $_SERVER['REQUEST_TIME'] + 7200) . ' ' . $_SERVER['REMOTE_ADDR'] . ' ' . $_SERVER['REQUEST_URI'] . " " . $_SERVER['SCRIPT_FILENAME'];
# file_put_contents($logfile, $line . "\n", FILE_APPEND); // | LOCK_EX);
# ---------------------------------------

# 2) .user.ini
# auto_prepend_file = /website/directory/.swaf/swaf.php

# 3) cron co np. 5 minut

# 4) add to .htaccess
# at first line
# -------------------
# Order Allow,Deny
# Allow from all
# #swaf_tag

# SETTINGS

WEBSITE_DIR="/website/directory/"
SCRIPT_DIR="${WEBSITE_DIR}/.swaf"
SCRIPT_LOG_FILE="${SCRIPT_DIR}/swaf_access.log"

WHITELIST_IP="${SCRIPT_DIR}/whitelist"


# if file is not empty
if [ "$(wc -l < ${SCRIPT_LOG_FILE})" -gt 0 ]
then
	# move log to temp file - new log file will be created while somebody enter website
	mv -- "${SCRIPT_LOG_FILE}" "${SCRIPT_DIR}/swaf.log.temp"
else
	# if file is empty
	echo "Empty"
	exit 0
fi

# get stats - threshold = 100
cut -d' ' -f3 "${SCRIPT_DIR}/swaf.log.temp" | sort | uniq -c | sort -n | \
		awk '$1 > 100 {print $2}' > "${SCRIPT_DIR}/suspicious"

grep -v -f "$WHITELIST_IP" "${SCRIPT_DIR}/suspicious" > "${SCRIPT_DIR}/malicious"

# block IPs
if [ "$(wc -l < ${SCRIPT_DIR}/malicious)" -gt 0 ]
then
	while IFS= read -r ip
	do
		echo "Blokuj $ip"
		# add to .htaccess
		sed -i "/#swaf_tag/a Deny From $ip" "${WEBSITE_DIR}/.htaccess"
	done < "${SCRIPT_DIR}/malicious"
fi

rm -- "${SCRIPT_DIR}/swaf.log.temp"
exit 0
