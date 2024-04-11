<?php
//require_once($_SERVER['FEED_DIR']."/vendor/autoload.php");
//require_once($_SERVER['FEED_DIR']."/includes/connection.php");
require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");
error_reporting();
//namespace Zugent\Listings;


class Translate
{
  public function normalize($trans){
    global $conn;

    if($trans['tb']){
      $tbs = "'" . implode("','", $trans['tb']) . "'";
    }

    if($trans['status']){
      $cols = "'status'";
      $keys = "'" . implode("','", $trans['status']) . "'";
    }

    if($trans['listingtype']){
      $cols .= ",'listingtype'";
      $keys .= ",'" . implode("','", $trans['listingtype']) . "'";
    }

    if($trans['listingofficename']){
      $cols .= ",'listingofficename'";
      $keys .= ",'" . implode("','", $trans['listingofficename']) . "'";
    }

    $sql = "SELECT translation_value FROM {$trans['db']}.translations WHERE table_name IN ({$tbs}) AND column_name IN ({$cols}) and translation_key IN ({$keys})";
    //echo $sql;

    $stmt = $conn->query($sql);
    if($stmt->rowCount() > 0){
        $status = array();
        while ($property = $stmt->fetch(PDO::FETCH_ASSOC)) {
          $status[] = $property['translation_value'];
        }
        return $status;
    }

    return array();

  }
}
?>
