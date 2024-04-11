<?php 
/**
* @name mob_request_agent.php
* @author [name] <[<email address>]>
* @author [Joy Victoria] <[<jvictoria@zugent.com>]> 
* @return [type] [<boolean>]
* @date July 2018
*/
include_once('mob_get_json.php');

if (isset($_POST['checkStatus'])) {
	echo json_encode(array('data' => true));
} else {
	echo json_encode(array('data' => false));
}
?>