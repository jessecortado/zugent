<?php
    
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


    // Get User LinkedIn ID & Token from Database
    $sth = SQL_QUERY("select linkedin_id,linkedin_token from users 
        where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
        user_id = '".SQL_CLEAN($_SESSION['user_id'])."' limit 1
        ");

    while ($data = SQL_ASSOC_ARRAY($sth)) {
        $linkedin_id = $data['linkedin_id'];
        $linkedin_token = $data['linkedin_token'];
    }

    // Initiate LinkedIn API
    $linkedIn = new Happyr\LinkedIn\LinkedIn(
        $social_app_config['LinkedIn']['client_id'],
        $social_app_config['LinkedIn']['client_secret']
    );

    $linkedIn->setAccessToken($linkedin_token);

    if ($linkedIn->isAuthenticated()) {

        $options = array('json'=>
            array(
                    'comment' => $_POST['message'],
                    'visibility' => array('code' => 'anyone')
                )
        );

        $result = $linkedIn->post('v1/people/~/shares', $options);
    
        // print_r($profile);

        // header('Location: index.php');
        echo "Successfully posted on your wall.";
        // echo $linkedIn->getAccessToken();
        
    }
    else {
        echo 'No Access Token';
    }


?>