<?php
require_once($_SERVER['SITE_DIR']."/includes/common.php");

SQL_QUERY("
  insert into contact_searches
  (
    contact_id,
    date_created,
    created_user_id,
    min_bedroom,
    max_bedroom,
    min_bathroom,
    max_bathroom,
    min_sqft,
    max_sqft,
    city,
    state,
    zip,
    county,
    listing_class,
    listing_type
  ) values (
    '".SQL_CLEAN($_SESSION['user_id'])."',
    NOW(),
    '".SQL_CLEAN($_SESSION['user_id'])."',
    '".SQL_CLEAN($_POST['min_bed'])."',
    '".SQL_CLEAN($_POST['max_bed'])."',
    '".SQL_CLEAN($_POST['min_bath'])."',
    '".SQL_CLEAN($_POST['max_bath'])."',
    '".SQL_CLEAN($_POST['min_sqft'])."',
    '".SQL_CLEAN($_POST['max_sqft'])."',
    '".SQL_CLEAN($_POST['city_name'])."',
    '".SQL_CLEAN($_POST['state_name'])."',
    '".SQL_CLEAN($_POST['zip_code'])."',
    '".SQL_CLEAN($_POST['county_name'])."',
    '".SQL_CLEAN($_POST['listing_class'])."',
    '".SQL_CLEAN($_POST['listing_type'])."'
  )
");
$contact_search_id = SQL_INSERT_ID();

$add_mls = SQL_QUERY("select * from zugent.contact_searches where is_deleted != 1 and contact_search_id = '".SQL_CLEAN($contact_search_id)."'");

$recently_added_data = array();
$comment = "Added in MLS Search";

while($data = SQL_ASSOC_ARRAY($add_mls)) {
  $recently_added_data[] = $data;
}

echo json_encode(array('msg'=>true, 'data'=>$recently_added_data, 'comment'=>$comment));
 ?>
