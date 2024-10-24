<?php
$name = sanitizeInput($_POST['name']);
$mac = sanitizeInput($_POST['mac']);
$ip = sanitizeInput($_POST['ip']);
if ($_POST['dhcp'] == 1){
    $ip = 'DHCP';
}
$ipv6 = sanitizeInput($_POST['ipv6']);
$port = sanitizeInput($_POST['port']);
$network = intval($_POST['network']);
$notes = sanitizeInput($_POST['notes']);
