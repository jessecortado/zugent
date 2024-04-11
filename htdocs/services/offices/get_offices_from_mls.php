<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");

auth();

$db_config = array();

if (isset($_POST['mls_id'])) {


    $sth = SQL_QUERY("select m.* from mls as m 
					left join company_rel_mls as cm on m.mls_id=cm.mls_id 
					where cm.company_id=".SQL_CLEAN($_SESSION['user']['company_id'])." 
                    and m.mls_id=".SQL_CLEAN($_POST['mls_id'])." limit 1");

    $mls = SQL_ASSOC_ARRAY($sth);

    // $mls_ini = parse_ini_file($_SERVER['SITE_DIR']."/etc/mls/".$mls['mls_name']."/offices.ini",true);	
    
    // if (!SQL_CONNECT($site_config['MySQL']['Hostname'], $site_config['MySQL']['Username'], $site_config['MySQL']['Password'], $mls['mls_database'])) {
    //     $smarty->display('maintenance.tpl');
    //     exit;
    // }
    
    // $sth = SQL_QUERY('select 
    //                     '.$mls_ini["Columns"]["office_id"].' as office_id,
    //                     '.$mls_ini["Columns"]["office_name"].' as office_name,
    //                     '.$mls_ini["Columns"]["city"].' as city 
    //                 from offices');

    $sth = SQL_QUERY('select 
                        office_id,
                        office_name
                    from '. $mls['mls_database'].'.offices');

    // echo json_encode($sth);
    $mls_offices = array();
    while ($data = SQL_ASSOC_ARRAY($sth)) {
        $mls_offices[] = $data;
    }
    
    // die (var_dump($status));
    
    $json = json_encode(array("data" => $mls_offices));

    if ($json)
        echo $json;
    else
        echo json_last_error_msg();
    
}


?>