<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");
SQL_QUERY("UPDATE contact_searches SET
                  date_modified = NOW(),
                  modified_user_id = '".SQL_CLEAN($_SESSION['user_id'])."',
                  min_bedroom = '".SQL_CLEAN($_POST['e_minbed'])."',
                  max_bedroom = '".SQL_CLEAN($_POST['e_maxbed'])."',
                  min_bathroom = '".SQL_CLEAN($_POST['e_minbath'])."',
                  max_bathroom = '".SQL_CLEAN($_POST['e_maxbath'])."',
                  min_sqft = '".SQL_CLEAN($_POST['e_minsqft'])."',
                  max_sqft = '".SQL_CLEAN($_POST['e_maxsqft'])."',
                  city = '".SQL_CLEAN($_POST['e_city'])."',
                  state = '".SQL_CLEAN($_POST['e_state'])."',
                  zip = '".SQL_CLEAN($_POST['e_zip'])."',
                  county = '".SQL_CLEAN($_POST['e_county'])."',
                  listing_class = '".SQL_CLEAN($_POST['e_class'])."',
                  listing_type = '".SQL_CLEAN($_POST['e_type'])."'
          WHERE contact_search_id = '".SQL_CLEAN($_POST['e_id'])."'
");

$edit_mls = SQL_QUERY("select * from zugent.contact_searches where is_deleted != 1 and contact_search_id = '".SQL_CLEAN($_POST['e_id'])."'");

$recently_updated_data = array();
$comment = "Changes in MLS Search";

while($data = SQL_ASSOC_ARRAY($edit_mls)) {
  $recently_updated_data[] = $data;
}

echo json_encode(array('msg'=>true, 'data'=>$recently_updated_data, 'comment'=>$comment));
?>
