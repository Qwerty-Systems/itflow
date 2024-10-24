<?php
$name = sanitizeInput($_POST['name']);
$description = sanitizeInput($_POST['description']);
$type = sanitizeInput($_POST['type']);
$make = sanitizeInput($_POST['make']);
$model = sanitizeInput($_POST['model']);
$serial = sanitizeInput($_POST['serial']);
$os = sanitizeInput($_POST['os']);
$ip = sanitizeInput($_POST['ip']);
if ($_POST['dhcp'] == 1) {
    $ip = 'DHCP';
}
$ipv6 = sanitizeInput($_POST['ipv6']);
$nat_ip = sanitizeInput($_POST['nat_ip']);
$mac = sanitizeInput($_POST['mac']);
$uri = sanitizeInput($_POST['uri']);
$uri_2 = sanitizeInput($_POST['uri_2']);
$status = sanitizeInput($_POST['status']);
$location = intval($_POST['location']);
$physical_location = sanitizeInput($_POST['physical_location']);
$vendor = intval($_POST['vendor']);
$contact = intval($_POST['contact']);
$network = intval($_POST['network']);
$purchase_date = sanitizeInput($_POST['purchase_date']);
if (empty($purchase_date)) {
    $purchase_date = "NULL";
} else {
    $purchase_date = "'" . $purchase_date . "'";
}
$warranty_expire = sanitizeInput($_POST['warranty_expire']);
if (empty($warranty_expire)) {
    $warranty_expire = "NULL";
} else {
    $warranty_expire = "'" . $warranty_expire . "'";
}
$install_date = sanitizeInput($_POST['install_date']);
if (empty($install_date)) {
    $install_date = "NULL";
} else {
    $install_date = "'" . $install_date . "'";
}
$notes = sanitizeInput($_POST['notes']);
$client_id = intval($_POST['client_id']);
