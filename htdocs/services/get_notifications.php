<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

	$notifications = get_notifications(10, $_POST['offset']);

	echo json_encode(array("data"=>$notifications['data']));

exit;

?>