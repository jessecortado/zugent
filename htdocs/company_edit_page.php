<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
// require_once($_SERVER['SITE_DIR']."/includes/generate_page_menu.php");

check_company_page_access('broker_page');


// For viewing only (TEMPORARY)
if(!isset($_GET['edit'])) {

  // COMPANY MENU
  $sth2 = SQL_QUERY("select * from company_menus 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    order by menu_order ASC
  ");

  $parent_menu = array();
  $child_menu = array();

  if (SQL_NUM_ROWS($sth2) != 0) {
    while ($data = SQL_ASSOC_ARRAY($sth2)) {
      if ($data['parent_id'] == '0') {
        $parent_menu[] = $data;
      }
      else {
        $child_menu[] = $data;
      }
    }

    $smarty->assign('parent_menu', $parent_menu);
    $smarty->assign('child_menu', $child_menu);
  }
  else {
    $smarty->assign('parent_menu', '');
    $smarty->assign('child_menu', '');
  }

  // COMPANY PAGE
  $sth = SQL_QUERY("select * from pages 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    and page_name='".SQL_CLEAN($_GET['page'])."' 
    limit 1
  ");

  if (SQL_NUM_ROWS($sth) == 0) {
    $smarty->assign('page_template', '');
  }
  else {
    $company_template = array();
    while ($data = SQL_ASSOC_ARRAY($sth)) {
      $company_template[] = $data;
    }
    $smarty->assign('page_template', $company_template[0]['plain_code']);
  }

  // COMPANY PAGE SETTINGS
  $sth = SQL_QUERY("select * from company_page_settings 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    limit 1
  ");

  $settings_data = array();

  if (SQL_NUM_ROWS($sth) != 0) {
    $settings_data = SQL_ASSOC_ARRAY($sth);
  }

  // COMPANY DETAILS
  $sth2 = SQL_QUERY("select * from companies 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    limit 1
  ");

  $company_data = array();

  if (SQL_NUM_ROWS($sth2) != 0) {
    $company_data = SQL_ASSOC_ARRAY($sth2);
  }

  $smarty->assign('company_data', $company_data);
  $smarty->assign('company_settings', $settings_data);

  if ($_GET['page'] == 'home') {
    $smarty->display("includes/company_pages/home_page.tpl");
  }
  else if ($_GET['page'] == 'search') {
    $smarty->display("includes/company_pages/search_page.tpl");
  }
  else if ($_GET['page'] == 'details') {
    $smarty->display("includes/company_pages/details_page.tpl");
  }
  else {
    $smarty->display("includes/company_pages/custom_page.tpl");
  }

}
else {
  // COMPANY PAGE
  $sth = SQL_QUERY("select * from pages 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    and page_name='".SQL_CLEAN($_GET['page'])."' 
    limit 1
  ");

  $company_template = array();

  if (SQL_NUM_ROWS($sth) != 0) {
    while ($data = SQL_ASSOC_ARRAY($sth)) {
      $company_template[] = $data;
    }
    $edit_code = $company_template[0]['edittable_code'];
  }
  else { $edit_code = ''; }

  // COMPANY PAGE SETTINGS
  $sth = SQL_QUERY("select * from company_page_settings 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    limit 1
  ");

  $settings_data = array();

  if (SQL_NUM_ROWS($sth) != 0) {
    $settings_data = SQL_ASSOC_ARRAY($sth);
  }

  // COMPANY DETAILS
  $sth2 = SQL_QUERY("select * from companies 
    where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
    limit 1
  ");

  $company_data = array();

  if (SQL_NUM_ROWS($sth2) != 0) {
    $company_data = SQL_ASSOC_ARRAY($sth2);
  }

  if ($_GET['page'] == 'home') {
    $smarty->assign('editable_header', 'includes/company_pages/edit_home_header.tpl');
    $smarty->assign('editable_footer', 'includes/company_pages/edit_home_footer.tpl');
    $smarty->assign('page_source', 'company_edit_page.php?page=home');
  }
  else if ($_GET['page'] == 'search') {
    $smarty->assign('editable_header', 'includes/company_pages/edit_search_header.tpl');
    $smarty->assign('editable_footer', '');
    $smarty->assign('page_source', 'company_edit_page.php?page=search');
  }
  else if ($_GET['page'] == 'details') {
    $smarty->assign('editable_header', 'includes/company_pages/edit_details_header.tpl');
    $smarty->assign('editable_footer', 'includes/company_pages/edit_details_footer.tpl');
    $smarty->assign('page_source', 'company_edit_page.php?page=details');
  }
  else {
    $smarty->display("includes/company_pages/custom_page.tpl");
  }

  $smarty->assign('editable_code', $edit_code);
  $smarty->assign('company_data', $company_data);
  $smarty->assign('company_settings', $settings_data);
  $smarty->assign('page_title', $_GET['page']);
  $smarty->assign('footer_line', 'no');
  $smarty->assign('footer_js', 'includes/footers/company_edit_page_footer.tpl');

  $smarty->display("company_edit_page.tpl");
}


?>