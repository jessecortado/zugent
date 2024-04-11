<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

auth();

if (isset($_POST['all_company_agents']) && $_POST['all_company_agents'] == 'true') {
	// Get Company Agents
	$list_agent = SQL_QUERY("select u.* from users as u ".
		"where u.last_drive != '' and ".
		"u.company_id = '".$_SESSION['user']['company_id']."' and ".
		"u.user_id != '".$_SESSION['user']['user_id']."' ".
		"order by u.last_drive desc");

	$agents = array();

	while ($data = SQL_ASSOC_ARRAY($list_agent)) {
		$agents[] = $data;
	}

	echo json_encode(array("errro" => false, "count" => count($agents), "agents" => $agents));

}
else {
	echo json_encode(array("errro" => true, "message" => "Something went wrong"));
}

?>