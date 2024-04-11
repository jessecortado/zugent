<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

auth();

$smarty->assign("id", $_GET['id']);

$smarty->display('thank_you_campaign.tpl');
