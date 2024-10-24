<?php

if (isset($_POST['edit_quote_settings'])) {

    validateCSRFToken($_POST['csrf_token']);

    $config_quote_prefix = sanitizeInput($_POST['config_quote_prefix']);
    $config_quote_next_number = intval($_POST['config_quote_next_number']);
    $config_quote_footer = sanitizeInput($_POST['config_quote_footer']);

    mysqli_query($mysqli,"UPDATE settings SET config_quote_prefix = '$config_quote_prefix', config_quote_next_number = $config_quote_next_number, config_quote_footer = '$config_quote_footer' WHERE company_id = 1");

    //Logging
    mysqli_query($mysqli,"INSERT INTO logs SET log_type = 'Settings', log_action = 'Modify', log_description = '$session_name modified quote settings', log_ip = '$session_ip', log_user_agent = '$session_user_agent', log_user_id = $session_user_id");

    $_SESSION['alert_message'] = "Quote Settings updated";

    header("Location: " . $_SERVER["HTTP_REFERER"]);

}
