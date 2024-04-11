<?php
//require_once($_SERVER['SITE_DIR']."/includes/connection.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
require_once($_SERVER['SITE_DIR']."/includes/feeds/normalize.php");

$test = nearby_properties(array("company_id" => "1", "lat" => "48.111152", "lng" => "-122.219450", "status" => array("A","P","E")));


//$test = search_properties('48.111152', '-122.219450');
print_r($test);

function get_all($company_id){
  global $conn;
  $sql = "SELECT * FROM zugent.mls as t1 INNER JOIN zugent.company_rel_mls as t2 ON t1.mls_id = t2.mls_id and t2.company_id = {$company_id}";
  $stmt = $conn->query($sql);
  $row = $stmt->fetchAll(PDO::FETCH_OBJ);

  foreach($row as $db){
    $dbase = $db->mls_database;
    $sql = "SELECT * FROM {$dbase}.listings where longitude !='' and latitude != '' limit 5";
    $stmt = $conn->query($sql);
    /*if($stmt->rowCount() > 0){
      $properties = array();
      while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {
         $properties[] = $property;
      }
      return $properties;
    }*/
    if($stmt->rowCount() > 0){
      $properties = array();
      while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {
        if($mapping){
          //get first photo
          $property['img_1'] = "https://zugidx.s3.amazonaws.com/650/{$dbase}_".$property['listing_number']."_1.jpg";
        }else{
          //get all photos
          for ($x = 1; $x <= $property['photo_count']; $x++) {
            $property['img_'.$x] = "https://zugidx.s3.amazonaws.com/650/{$dbase}_".$property['listing_number']."_{$x}.jpg";
          }
        }
         $properties[] = $property;
      }
      print_r( $properties);
    }
  }
}

function search_properties($lat, $lng, $mls_id = 3, $distance = 500){
  global $conn;
  /*$sql = "SELECT * FROM zugent.mls as t1 INNER JOIN zugent.company_rel_mls as t2 ON t1.mls_id = t2.mls_id and t2.company_id = {$company_id}";
  $stmt = $conn->query($sql);
  $row = $stmt->fetchAll(PDO::FETCH_OBJ);*/

  $sql = "SELECT mls_database FROM zugent.mls WHERE mls_id in ({$mls_id})";
  $stmt = $conn->query($sql);
  $row = $stmt->fetchAll(PDO::FETCH_OBJ);

  foreach($row as $db){
      $dbase = $db->mls_database;
      $sql = "SELECT *";

      $sql .= ", ROUND(6378.137 * 2 * ASIN(SQRT(POW(SIN(({$lat}*PI()/180-latitude * PI()/180)/2),2) + COS({$lat} * PI() / 180)*COS(latitude * PI() / 180) * POW(SIN(({$lng} * PI() / 180.0 - longitude * PI() / 180)/2),2))) * 10000) / 10000  as dis";
      $sql .= " FROM {$dbase}.listings HAVING dis <= {$distance} ORDER BY dis ASC";

      $stmt = $conn->query($sql);
      if($stmt->rowCount() > 0){
        $properties = array();
        while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {
        for ($x = 1; $x <= $property['photo_count']; $x++) {
          $property['img_'.$x] = "https://zugidx.s3.amazonaws.com/650/{$dbase}_".$property['listing_number']."_{$x}.jpg";
        }
          $properties[] = $property;
        }
        //return $properties;
        return json_encode($properties);
      }
  }
}

function nearby_properties($prop){
    global $conn;
    $trans = new Translate();

    //$company_id, $mapping, $min, $latitude, $longitude, $status, $listing_type, $min_price, $max_price, $min_bed, $max_bed, $min_bathroom, $max_bathroom, $city, $state, $zip, $county, $distance
    $sql = "SELECT * FROM zugent.mls as t1 INNER JOIN zugent.company_rel_mls as t2 ON t1.mls_id = t2.mls_id and t2.company_id = {$prop['company_id']}";
    $stmt = $conn->query($sql);
    $row = $stmt->fetchAll(PDO::FETCH_OBJ);

    foreach($row as $db){
        $dbase = $db->mls_database;
        if($prop['mapping']){
          $sql = "SELECT latitude, longitude, price, listing_status";
        }elseif ($prop['min']) {
          $sql = "SELECT beds_total, baths_total, price, address, city, state, zip, county, status, listing_type, photo_count";
        }else {
          $sql = "SELECT * ";
        }

        if($prop['lat'] !="" && $prop['lng'] !=""){
          $sql .= ", ROUND(6378.137 * 2 * ASIN(SQRT(POW(SIN(({$prop['lat']}*PI()/180-latitude * PI()/180)/2),2) + COS({$prop['lat']} * PI() / 180)*COS(latitude * PI() / 180) * POW(SIN(({$prop['lng']} * PI() / 180.0 - longitude * PI() / 180)/2),2))) * 10000) / 10000  as dis FROM {$dbase}.listings WHERE ";
        }else{
          $sql .= " FROM {$dbase}.listings WHERE ";
        }

       if($prop['status'] !="") {
         $status = "'" . implode("','", $prop['status']) . "'";
         $sql .= "status IN ({$status}) ";
       }else{
         $status = "'A','P'";
         $sql .= "status IN ({$status}) ";
       }

       if($prop['distance'] == ""){
          $prop['distance'] = '500';
       }

       if($prop['listing_type']!="") $sql .= "and listing_type IN ({$prop['listing_type']}) ";
       if($prop['min_price']!="") $sql .= "and price >= {$prop['min_price']} ";
       if($prop['max_price']!="") $sql .= "and price <= {$prop['max_price']} ";
       if($prop['min_bed']!="") $sql .= "and beds_total >= {$prop['min_bed']} ";
       if($prop['max_bed']!="") $sql .= "and beds_total <= {$prop['max_bed']} ";
       if($prop['min_bathroom']!="") $sql .= "and baths_total >= {$prop['min_bath']} ";
       if($prop['max_bathroom']!="") $sql .= "and baths_total <= {$prop['max_bath']} ";
       if($prop['city']!="") $sql .= "and city = {$prop['city']} ";
       if($prop['state']!="") $sql .= "and state = {$prop['state']} ";
       if($prop['zip']!="") $sql .= "and zip = {$prop['zip']} ";
       if($prop['county']!="") $sql .= "and county = {$prop['county']} ";
       if($prop['lat']!="" && $prop['lng']!="") $sql .= "HAVING dis <= {$prop['distance']} ORDER BY dis ASC limit 10";
       
       $stmt = $conn->query($sql);
       if($stmt->rowCount() > 0){
         $properties = array();
         $status_orig = array();
         $prop_img = array();
         while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {

           $status_normalize = $trans->normalize(array("db" => $dbase, "tb" => array("listings"), "status" => array($property['status'])));
           if($status_normalize){
             $property['status'] = $status_normalize[0];
           }

           if($property['date_photo_retrieved']){
               if($prop['mapping']){
                    $prop_img['img_1'] = "https://zugidx.s3.amazonaws.com/650/{$dbase}_".$property['listing_number']."_1.jpg";
               }else{
                 for ($x = 1; $x <= $property['photo_count']; $x++) {
                    $prop_img['img_'.$x] = "https://zugidx.s3.amazonaws.com/650/{$dbase}_".$property['listing_number']."_{$x}.jpg";
                 }
               }

               $property['images'] = $prop_img;
           }

            $properties[] = $property;
         }

         return $properties;
       }
  }
  return array();
}

function url_exists($url) {
    $hdrs = @get_headers($url);
    return is_array($hdrs) ? preg_match('/^HTTP\\/\\d+\\.\\d+\\s+2\\d\\d\\s+.*$/',$hdrs[0]) : false;
}
?>
