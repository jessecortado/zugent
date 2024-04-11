<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1x0c7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id'],
);

auth_process($data, $is_ajax, TRUE);

function checkItem($menu_id) {
	$sql_query = SQL_QUERY("select * from company_menus 
		where company_id='".SQL_CLEAN($_SESSION['user']['company_id'])."' 
		and menu_id='".SQL_CLEAN($menu_id)."' 
		limit 1
		");

	return SQL_NUM_ROWS($sql_query);
}

function addItem($data, $order, $parent_id) {
	$qs = 'insert into company_menus set ';
	$qs.= 'company_id="'.SQL_CLEAN($_SESSION['user']['company_id']).'", ';
	$qs.= 'menu_id="'.SQL_CLEAN($data['id']).'", ';
	$qs.= 'menu_label="'.SQL_CLEAN($data['label']).'", ';
	$qs.= 'menu_link="'.SQL_CLEAN($data['link']).'", ';
	$qs.= 'is_custom_page="'.SQL_CLEAN($data['custompage']).'", ';
	if ($parent_id != 0) {
		$qs.= 'parent_id="'.SQL_CLEAN($parent_id).'", ';
	}
	$qs.= 'menu_order="'.SQL_CLEAN($order).'"';

	$query = SQL_QUERY($qs);
}

function updateItem($data, $order, $parent_id) {
	$qs = 'update company_menus set ';
	$qs.= 'menu_label="'.SQL_CLEAN($data['label']).'", ';
	$qs.= 'menu_link="'.SQL_CLEAN($data['link']).'", ';
	if ($parent_id != 0) {
		$qs.= 'parent_id="'.SQL_CLEAN($parent_id).'", ';
	}
	$qs.= 'menu_order="'.SQL_CLEAN($order).'" ';
	$qs.= 'where company_id="'.SQL_CLEAN($_SESSION['user']['company_id']).'" ';
	$qs.= 'and menu_id="'.SQL_CLEAN($data['id']).'"';

	$query = SQL_QUERY($qs);
}

function updateItemParent($menu_id, $parent_id) {
	$qs = 'update company_menus set ';
	$qs.= 'parent_id="'.SQL_CLEAN($parent_id).'"';
	$qs.= 'where company_id="'.SQL_CLEAN($_SESSION['user']['company_id']).'" ';
	$qs.= 'and menu_id="'.SQL_CLEAN($menu_id).'"';

	$query = SQL_QUERY($qs);
}

function updateItemChild($menu_id, $has_child) {
	$qs = 'update company_menus set ';
	$qs.= 'has_child="'.SQL_CLEAN($has_child).'"';
	$qs.= 'where company_id="'.SQL_CLEAN($_SESSION['user']['company_id']).'" ';
	$qs.= 'and menu_id="'.SQL_CLEAN($menu_id).'"';

	$query = SQL_QUERY($qs);
}

if(!empty($_POST['menu_list'])){

	$menu_list = $_POST['menu_list'];
	$ctr = 0;

	// print_r($menu_list);
	// die("TESTING");

	foreach ($menu_list as $item) {
		$ctr++;
		// Check if menu_id exists
		if (checkItem($item['id']) != 0) {
			updateItem($item, $ctr, 0);

			// if it has children
			if(array_key_exists('children', $item)) {
				updateItemParent($item['id'], 0);
				updateItemChild($item['id'], 1);
				foreach ($item['children'] as $sub_menu) {
					// die(var_dump($sub_menu));
					$ctr++;
					// check if it exists
					if (checkItem($sub_menu['id']) != 0) {
						updateItem($sub_menu, $ctr, $item['id']);
						updateItemParent($sub_menu['id'], $item['id']);
						updateItemChild($sub_menu['id'], 0);
					}
					else {
						addItem($sub_menu, $ctr, $item['id']);
						updateItemParent($sub_menu['id'], $item['id']);
						updateItemChild($sub_menu['id'], 0);
					}
				}
			}
			else {
				updateItemParent($item['id'], 0);
				updateItemChild($item['id'], 0);
			}
		}
		else {
			addItem($item, $ctr, 0);

			if(array_key_exists('children', $item)) {
				updateItemParent($item['id'], 0);
				updateItemChild($item['id'], 1);
				foreach ($item['children'] as $sub_menu) {
					$ctr++;
					// check if it exists
					if (checkItem($sub_menu['id']) != 0) {
						updateItem($sub_menu, $ctr, $item['id']);
						updateItemParent($sub_menu['id'], $item['id']);
						updateItemChild($sub_menu['id'], 0);
					}
					else {
						addItem($sub_menu, $ctr, $item['id']);
						updateItemParent($sub_menu['id'], $item['id']);
						updateItemChild($sub_menu['id'], 0);
					}
				}
			}
		}
	}

	echo json_encode(true);
}
else if(empty($_POST['menu_list'])){
	echo json_encode('empty');
}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1x0c7");
	}
}

?>