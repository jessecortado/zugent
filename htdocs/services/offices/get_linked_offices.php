<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

auth();

$db_config = array();

if (isset($_POST['office_id'])) {

    $sth = SQL_QUERY("select oo.*, m.mls_name, m.mls_database from office_rel_offices oo 
                    left join mls as m on m.mls_id=oo.mls_id
                    where oo.office_id=".SQL_CLEAN($_POST['office_id'])."
                    ");

    $mls = array();

    while ($data = SQL_ASSOC_ARRAY($sth)) {
        $mls[$data['mls_database']][] = $data;
    }


    $mls_offices = array();
    foreach ($mls as $key => $value) {

        // echo ($key ." and ".$value );
        // if (!SQL_CONNECT($site_config['MySQL']['Hostname'], $site_config['MySQL']['Username'], $site_config['MySQL']['Password'], $key)) {
        //     $smarty->display('maintenance.tpl');
        //     exit;
        // }

        foreach ($value as $row) {
            $sth = SQL_QUERY("Select * from ".$key.".offices where office_id=".SQL_CLEAN($row['mls_office_id']));
            $temp =  SQL_ASSOC_ARRAY($sth);
            $temp["mls_id"] = $row["mls_id"];
            $mls_offices[] = $temp;
        }

    }

    echo json_encode(array("data" => $mls_offices));
    
    // $sth = SQL_QUERY("select * from offices");
    // $mls_offices = array();
    // while ($data = SQL_ASSOC_ARRAY($sth)) {
    //     $mls_offices[] = $data;
    // }
    
    // echo json_encode(array("data" => $mls_data));
    
    
}


?>