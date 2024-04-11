<?php

    require_once($_SERVER['SITE_DIR']."/includes/common.php");
    

    //Agent Requests
    $requests = SQL_QUERY("select ar.*, com.company_name, u.first_name, u.last_name, ct.first_name as cfname, ct.last_name as clname, u.phone_mobile, cu.date_assigned ".
    "from agent_requests as ar ".
   "left join contacts as ct on ar.contact_id = ct.contact_id ".
   "left join users as u on ar.user_id = u.user_id ".
   "left join companies as com on u.company_id = com.company_id ".
   "left join contacts_rel_users as cu on ar.contact_id=cu.contact_id ".
   "where ct.date_created > DATE_SUB(NOW(), INTERVAL 30 DAY) ".
   "order by ct.date_created desc");

    $agent_requests = array();

    while ($data = SQL_ASSOC_ARRAY($requests)) {
    $agent_requests[] = $data;
    }

    $accepted_qry = SQL_QUERY("select COUNT(agent_request_id) as cnt from agent_requests where accepted=1");
    $accepted = SQL_ASSOC_ARRAY($accepted_qry);
    $accepted_cnt = $accepted['cnt'];

    $contact_query = SQL_QUERY("select * from contacts where date_created > DATE_SUB(NOW(), INTERVAL 30 DAY) order by date_created desc limit 10");

    $contacts = array();
    while($data = SQL_ASSOC_ARRAY($contact_query)){
        $contacts[] = $data;
    }

        //create loop for each contact
    $contact_agent_rels = array();
    for($i = 0; $i<count($contacts); $i++){
        $agents_requested = array();
        for($j = 0; $j<count($agent_requests); $j++){
            if($agent_requests[$j]['contact_id'] == $contacts[$i]['contact_id']){
                array_push($agents_requested, $agent_requests[$j]);
            }
        }
        $contact_agent_rel = ['cfname'=>$contacts[$i]['first_name'], 'clname'=>$contacts[$i]['last_name'], 'contact_id'=>$contacts[$i]['contact_id'], 'date_created'=>$contacts[$i]['date_created'], 'agent_requests'=>$agents_requested];
	array_push($contact_agent_rels, $contact_agent_rel);
    }

    //Last Active Users
   $agents = SQL_QUERY("select u.last_latitude, u.last_longitude, u.first_name, u.last_name, com.company_name, u.last_drive ". 	
       "from users as u LEFT JOIN companies as com on u.company_id=com.company_id ". 
       "WHERE (u.last_drive > DATE_SUB(NOW(), INTERVAL 6 HOUR) or u.is_perm_drive = 1) and u.is_active=1");
   
   $agents_driving = array();

   while($data = SQL_ASSOC_ARRAY($agents)){
       $agents_driving[] = $data;
   }

    echo json_encode(array("agent_requests"=>$agent_requests, "agents_driving"=>$agents_driving, "contacts"=>$contact_agent_rels, "accepted_reqs_ct"=>$accepted_cnt));
?>