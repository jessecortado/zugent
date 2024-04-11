<?php
$lat = '40.7127753';
$lon = '-74.0059728';
$geocode = "https://maps.googleapis.com/maps/api/geocode/json?latlng=".$lat.",".$lon."&sensor=true&key=AIzaSyAq8WuTeXonjSzYw_vVLiN7PCRQNqf_v_Q";


$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $geocode);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
$json_data = json_decode(curl_exec($ch), true);

echo json_encode($json_data);
?>