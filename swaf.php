<?php
$logfile = '/website/directory/.swaf/script_access.log';
$line = gmdate("Y-m-d H:i:s", $_SERVER['REQUEST_TIME'] + 7200) . ' ' . $_SERVER['REMOTE_ADDR'] . ' ' . $_SERVER['REQUEST_URI'] . " " . $_SERVER['SCRIPT_FILENAME'];
file_put_contents($logfile, $line . "\n", FILE_APPEND); // | LOCK_EX);
