<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");

SQL_QUERY("UPDATE contact_searches SET is_deleted = '".SQL_CLEAN($_POST['is_deleted'])."'  WHERE contact_search_id = '".SQL_CLEAN($_POST['search_id'])."'");
$deleted_mls = SQL_QUERY("select * from zugent.contact_searches where is_deleted != 1");

$recently_deleted_data = array();
$comment = "Deleted in MLS Search";

while($data = SQL_ASSOC_ARRAY($deleted_mls)) {
  $recently_deleted_data[] = $data;
}

echo json_encode(array('msg'=>true, 'data'=>$recently_deleted_data, 'comment'=>$comment));
?>
