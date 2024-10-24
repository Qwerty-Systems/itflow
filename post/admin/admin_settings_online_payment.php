<?php

if (isset($_POST['edit_online_payment_settings'])) {

    validateCSRFToken($_POST['csrf_token']);

    $config_stripe_enable = intval($_POST['config_stripe_enable']);
    $config_stripe_publishable = sanitizeInput($_POST['config_stripe_publishable']);
    $config_stripe_secret = sanitizeInput($_POST['config_stripe_secret']);
    $config_stripe_account = intval($_POST['config_stripe_account']);
    $config_stripe_expense_vendor = intval($_POST['config_stripe_expense_vendor']);
    $config_stripe_expense_category = intval($_POST['config_stripe_expense_category']);
    $config_stripe_percentage_fee = floatval($_POST['config_stripe_percentage_fee']) / 100;
    $config_stripe_flat_fee = floatval($_POST['config_stripe_flat_fee']);

    mysqli_query($mysqli,"UPDATE settings SET config_stripe_enable = $config_stripe_enable, config_stripe_publishable = '$config_stripe_publishable', config_stripe_secret = '$config_stripe_secret', config_stripe_account = $config_stripe_account, config_stripe_expense_vendor = $config_stripe_expense_vendor, config_stripe_expense_category = $config_stripe_expense_category, config_stripe_percentage_fee = $config_stripe_percentage_fee, config_stripe_flat_fee = $config_stripe_flat_fee WHERE company_id = 1");

    //Logging
    mysqli_query($mysqli,"INSERT INTO logs SET log_type = 'Settings', log_action = 'Modify', log_description = '$session_name modified online payment settings', log_ip = '$session_ip', log_user_agent = '$session_user_agent', log_user_id = $session_user_id");

    $_SESSION['alert_message'] = "Online Payment Settings updated";

    header("Location: " . $_SERVER["HTTP_REFERER"]);
}
