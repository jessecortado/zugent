<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");

/* AJAX check  */
if(!empty($_SERVER['HTTP_X_REQUESTED_WITH']) && strtolower($_SERVER['HTTP_X_REQUESTED_WITH']) == 'xmlhttprequest') {
	$is_ajax = TRUE;
}

$data = array(
	"code" => '1xbe7',
	"user_id" => $_SESSION['user']['user_id'],
	"user_company_id" => $_SESSION['user']['company_id']
);

auth_process($data, $is_ajax, FALSE);


if(isset($_POST['action_id']) && ($_POST['action_id'] == 'be7')){

	// Default Values of Filters
	$filters = array(
		"personal_contacts" => array(
				"is_set" => true
			),
		"company_contacts" => array(
				"is_set" => false
			),
		"contact_bucket" => array(
				"is_set" => false,
				"value" => ""
			),
		"contact_tags" => array(
				"is_set" => false,
				"value" => array()
			),
		"contact_city" => array(
				"is_set" => false,
				"value" => ""
			),
		"contact_county" => array(
				"is_set" => false,
				"value" => ""
			),
		"contact_zip" => array(
				"is_set" => false,
				"value" => ""
			)
	);

	$qst = 'select distinct c.* from contacts as c ';

	// With Company Contacts Filter
	if (isset($_POST['company_contacts'])) {
		$where_clause.= 'where c.company_id = '.SQL_CLEAN($_SESSION['user']['company_id']).'';

		$filters['company_contacts']['is_set'] = true;
	}
	else {
		$qst.= 'left join contacts_rel_users as cru on c.contact_id = cru.contact_id ';
		$where_clause = 'where cru.user_id = '.SQL_CLEAN($_SESSION['user_id']).'';
	}

	// With Bucket Filter
	if (isset($_POST['contact_bucket']) && !empty($_POST['contact_bucket'])) {
		$qst.= 'left join contact_buckets as cb on c.bucket_id = cb.bucket_id ';
		$where_clause.= " and cb.bucket_name LIKE '".SQL_CLEAN($_POST['contact_bucket'])."'";

		$filters['contact_bucket']['is_set'] = true;
		$filters['contact_bucket']['value'] = $_POST['contact_bucket'];
	}

	// With Tags Filter
	if (isset($_POST['contact_tags']) && !empty($_POST['contact_tags'])) {
		$tags = join("','", $_POST['contact_tags']);

		$qst.= 'left join contact_bucket_tags as cbt on c.bucket_id = cbt.bucket_id ';
		$where_clause.= " and (cbt.company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."'";
		$where_clause.= " and cbt.tag_name IN ('".$tags."'))";

		$filters['contact_tags']['is_set'] = true;
		foreach ($_POST['contact_tags'] as $key => $value) {
			$filters['contact_tags']['value'][$key] = $value;
		}
	}

	// With City Filter
	if (isset($_POST['contact_city']) && !empty($_POST['contact_city'])) {
		$where_clause.= " and c.city LIKE '".SQL_CLEAN($_POST['contact_city'])."'";

		$filters['contact_city']['is_set'] = true;
		$filters['contact_city']['value'] = $_POST['contact_city'];
	}

	// With County Filter
	if (isset($_POST['contact_county']) && !empty($_POST['contact_county'])) {
		$where_clause.= " and c.county LIKE '".SQL_CLEAN($_POST['contact_county'])."'";

		$filters['contact_county']['is_set'] = true;
		$filters['contact_county']['value'] = $_POST['contact_county'];
	}

	// With Zip Filter
	if (isset($_POST['contact_zip']) && !empty($_POST['contact_zip'])) {
		$where_clause.= " and c.zip LIKE '".SQL_CLEAN($_POST['contact_zip'])."'";

		$filters['contact_zip']['is_set'] = true;
		$filters['contact_zip']['value'] = $_POST['contact_zip'];
	}

	$where_clause.= " and c.is_unsubscribed != 1";

	$qst.= $where_clause;

	$contacts = SQL_QUERY($qst);

	$total_count = SQL_NUM_ROWS($contacts);

	$contacts_details = array();

	if ($total_count > 0) {
		while ($data = SQL_ASSOC_ARRAY($contacts)) {
			$contacts_details[] = $data;
		}
	}

	// echo json_encode(array('msg'=>true, 'total_count'=>$total_count, 'contacts_details'=>$contacts_details, 'query'=>$qst, 'POST'=>$_POST)); //for testing
	echo json_encode(array('msg'=>true, 'total_count'=>$total_count, 'contacts_details'=>$contacts_details, 'filters'=>$filters));

}
else {
	if ($is_ajax) {
		echo json_encode(false);
	}
	else {
		header("location: /dashboard.php?code=1xbe7");
	}
}

?>