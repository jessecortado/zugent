<?php
    
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
$social_app_config = parse_ini_file($_SERVER['SITE_DIR']."/etc/site_config.ini",true);


    // if(isset($_SESSION['facebook_token'])){
        
    //     $id = $_POST['pageid'];
    //     $message = $_POST['message'];
        
    //     $data = array(
    //         'message' => $message
    //     );
        
    //     $res = $fb->get('/me/accounts', $_SESSION['facebook_token']);
    //     $res = $res->getDecodedBody();
        
    //     foreach($res['data'] as $page){
    //         if($page['id'] == $id){
    //             $accesstoken = $page['access_token'];
    //         }
    //     }
        
    //     $res = $fb->post($id . '/feed/', $data, $accesstoken);
    //     header('Location: index.php');
        
    // }

    // Get User Facebook ID & Token from Database
    $sth = SQL_QUERY("select facebook_id,facebook_token from users 
        where company_id = '".SQL_CLEAN($_SESSION['user']['company_id'])."' and 
        user_id = '".SQL_CLEAN($_SESSION['user_id'])."' limit 1
        ");

    while ($data = SQL_ASSOC_ARRAY($sth)) {
        $facebook_id = $data['facebook_id'];
        $facebook_token = $data['facebook_token'];
    }

    // Initiate Facebook API
    $fb_initiate = new Facebook\Facebook([
        'app_id'                => $social_app_config['Facebook']['app_id'],
        'app_secret'            => $social_app_config['Facebook']['secret_key'],
        'default_graph_version' => 'v2.2',
    ]);
    
    if(isset($facebook_token)){

        $fb_initiate->setDefaultAccessToken($facebook_token);

        $profile_request = $fb_initiate->get('/me?fields-name,first_name,last_name,email');
        $profile = $profile_request->getGraphNode()->asArray();
        
        $post = $fb_initiate->post('/me/feed', array('message' => $_POST['message']));
    
        // print_r($profile);

        // header('Location: index.php');

        echo "Successfully posted on your timeline.";
        
    }
    else {
        echo 'No Access Token';
    }


?>