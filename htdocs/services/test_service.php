<?php 

header('Access-Control-Allow-Origin: *');


function isMobileDevice() {
    $aMobileUA = array(
        '/iphone/i'             => 'iPhone',
        '/ipod/i'               => 'iPod',
        '/ipad/i'               => 'iPad',
        '/android/i'            => 'Android',
        '/blackberry/i'         => 'BlackBerry',
        '/webos/i'              => 'Mobile'
    );

    $data = array(
    	'isDesktop' => true,
    	'isMobile' => false,
    	'deviceName' => $_SERVER['HTTP_USER_AGENT']
    );

    //Return true if Mobile User Agent is detected
    foreach($aMobileUA as $sMobileKey => $sMobileOS){
        if(preg_match($sMobileKey, $_SERVER['HTTP_USER_AGENT'])){
            $data['isDesktop'] = false;
            $data['isMobile'] = true;
            $data['deviceName'] = $sMobileOS;
            break;
        }
    }

    //Otherwise return false..  
    return $data;
}

function getUserLocation() {
    $ip = $_SERVER['REMOTE_ADDR'];
    $try1 = "http://ipinfodb.com/ip_query.php?ip=".$ip."&output=xml";
    $try2 = "http://backup.ipinfodb.com/ip_query.php?ip=".$ip."&output=xml";
    $XML = @simplexml_load_file($try1,NULL,TRUE);
    if(!$XML) { $XML = @simplexml_load_file($try2,NULL,TRUE); }
    if(!$XML) { return false; }

    //Retrieve location, set time
    if($XML->City=="") { $loc = "Localhost / Unknown"; }
    else { $loc = $XML->City.", ".$XML->RegionName.", ".$XML->CountryName; }

    return $loc;
}


// Check Device/Browser
$data = isMobileDevice();
$checkDevice = json_encode(isMobileDevice());

echo json_encode(array("error" => false, "isMobile" => $data['isMobile'], "isDesktop" => $data['isDesktop'], "deviceName" => $data['deviceName']));

echo "<br><br>";

// Get User Location
$userData = getUserLocation();
echo json_encode(array("error" => false, "userLocation" => $userData, "server" => $_SERVER['REMOTE_ADDR']));

echo "<br><br>";




$deviceData = isMobileDevice();
$deviceIsMobile = json_encode($deviceData['deviceName']);
// $deviceIsMobile = json_encode(true);

echo $deviceIsMobile;

echo "<br><br>";

if ($deviceIsMobile == 'iPhone') {
    echo "IS IPHONE";
}
else {
    echo "NOT IPHONE";
}