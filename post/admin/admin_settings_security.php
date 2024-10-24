<?php

if (isset($_POST['edit_security_settings'])) {

    validateCSRFToken($_POST['csrf_token']);

    $config_login_message = sanitizeInput($_POST['config_login_message']);
    $config_login_key_required = intval($_POST['config_login_key_required']);
    $config_login_key_secret = sanitizeInput($_POST['config_login_key_secret']);
    $config_login_remember_me_expire = intval($_POST['config_login_remember_me_expire']);
    $config_log_retention = intval($_POST['config_log_retention']);

    mysqli_query($mysqli,"UPDATE settings SET config_login_message = '$config_login_message', config_login_key_required = '$config_login_key_required', config_login_key_secret = '$config_login_key_secret', config_login_remember_me_expire = $config_login_remember_me_expire, config_log_retention = $config_log_retention WHERE company_id = 1");

    // Logging
    mysqli_query($mysqli,"INSERT INTO logs SET log_type = 'Settings', log_action = 'Modify', log_description = '$session_name modified login key settings', log_ip = '$session_ip', log_user_agent = '$session_user_agent', log_user_id = $session_user_id");

    $_SESSION['alert_message'] = "Login key settings updated";

    header("Location: " . $_SERVER["HTTP_REFERER"]);
}
