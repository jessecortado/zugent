<?php

// Populates the table on mls listings page

if(isset($xcategory["neren"])) {

	$listings = array();

	// New Items
	$getInfo = SQL_QUERY("select * from idx_neren.listings 
		where date_status BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()");

	$mls_info_new = array();

	while($mlsinfonew = SQL_ASSOC_ARRAY($getInfo)){
		$mls_info_new[] = $mlsinfonew;
	}

	// Updated Items
	$getInfoUp = SQL_QUERY("select * from idx_neren.listings 
		where (date_updated BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()) AND 
		date_updated not in (
		select date_status 
		from idx_neren.listings 
		where date_status BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()
	)");

	$mls_info_updated = array();

	while($mlsinfoupdated = SQL_ASSOC_ARRAY($getInfoUp)){
		$mls_info_updated[] = $mlsinfoupdated;
	}

	$smarty->assign('new_listings', $mls_info_new);
	$smarty->assign('updated_listings', $mls_info_updated);
	$smarty->assign('total_new_listings', SQL_NUM_ROWS($mls_info_new));
	$smarty->assign('total_updated_listings', SQL_NUM_ROWS($mls_info_updated));
	$smarty->assign('mls_name', 'neren');

}
else if(isset($xcategory["mlspin"])) {

	$listings = array();

	// New Items
	$getInfo = SQL_QUERY("select * from idx_mlspin.listings 
		where date_status BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()");

	$mls_info_new = array();

	while($mlsinfonew = SQL_ASSOC_ARRAY($getInfo)){
		$mls_info_new[] = $mlsinfonew;
	}

	// Updated Items
	$getInfoUp = SQL_QUERY("select * from idx_mlspin.listings 
		where (date_updated BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()) AND 
		date_updated not in (
		select date_status 
		from idx_mlspin.listings 
		where date_status BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()
	)");

	$mls_info_updated = array();

	while($mlsinfoupdated = SQL_ASSOC_ARRAY($getInfoUp)){
		$mls_info_updated[] = $mlsinfoupdated;
	}

	$smarty->assign('new_listings', $mls_info_new);
	$smarty->assign('updated_listings', $mls_info_updated);
	$smarty->assign('total_new_listings', SQL_NUM_ROWS($mls_info_new));
	$smarty->assign('total_updated_listings', SQL_NUM_ROWS($mls_info_updated));
	$smarty->assign('mls_name', 'mlspin');

}
else if(isset($xcategory["nwmls"])) {

	$listings = array();

	// New Items
	$getInfo = SQL_QUERY("select * from idx_nwmls.listings 
		where date_status BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()");

	$mls_info_new = array();

	while($mlsinfonew = SQL_ASSOC_ARRAY($getInfo)){
		$mls_info_new[] = $mlsinfonew;
	}

	// Updated Items
	$getInfoUp = SQL_QUERY("select * from idx_nwmls.listings 
		where (date_updated BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()) AND 
		date_updated not in (
		select date_status 
		from idx_nwmls.listings 
		where date_status BETWEEN DATE_SUB(NOW(), INTERVAL 20 DAY) AND NOW()
	)");

	$mls_info_updated = array();

	while($mlsinfoupdated = SQL_ASSOC_ARRAY($getInfoUp)){
		$mls_info_updated[] = $mlsinfoupdated;
	}

	$smarty->assign('new_listings', $mls_info_new);
	$smarty->assign('updated_listings', $mls_info_updated);
	$smarty->assign('total_new_listings', SQL_NUM_ROWS($mls_info_new));
	$smarty->assign('total_updated_listings', SQL_NUM_ROWS($mls_info_updated));
	$smarty->assign('mls_name', 'nwmls');

}

?>