<?php

// DETECT IF URL HAS PARAMETER
// First parameter = filter

$xurl_query = parse_url($_SERVER['REQUEST_URI'], PHP_URL_QUERY);

parse_str($xurl_query, $xparams);

$FIRST_URI = explode('?', $_SERVER['REQUEST_URI']);

foreach ($xparams as $key => $value) {
	if (!empty($value)) {
		$xcategory[$key] = $value;
	}
}

// Require sub_file "path = /includes/sub_pages/"
require_once($_SERVER['SITE_DIR']."/includes/sub_pages/sub_".str_replace('/', '', $FIRST_URI[0])."");

?>