<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

auth();

if (isset($_POST['office_id'])) {

    $sth = SQL_QUERY("delete from office_rel_offices 
                    where office_id=".SQL_CLEAN($_POST['office_id'])." 
                    and mls_id=".SQL_CLEAN($_POST['mls_id'])." 
                    and mls_office_id=".SQL_CLEAN($_POST['mls_office_id'])." 
                    ");

    echo json_encode($sth);
    
    
}


?>