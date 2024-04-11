<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
$image_types = array
    (
        0=>'UNKNOWN',
        1=>'GIF',
        2=>'JPEG',
        3=>'PNG',
        4=>'SWF',
        5=>'PSD',
        6=>'BMP',
        7=>'TIFF_II',
        8=>'TIFF_MM',
        9=>'JPC',
        10=>'JP2',
        11=>'JPX',
        12=>'JB2',
        13=>'SWC',
        14=>'IFF',
        15=>'WBMP',
        16=>'XBM',
        17=>'ICO',
        18=>'COUNT'  
    );

function hex2rgb($hex) {
    
   $hex = str_replace("#", "", $hex);

   switch (strlen($hex)) {
       case 1:
           $hex = $hex.$hex;
       case 2:
          $r = hexdec($hex);
          $g = hexdec($hex);
          $b = hexdec($hex);
           break;

       case 3:
          $r = hexdec(substr($hex,0,1).substr($hex,0,1));
          $g = hexdec(substr($hex,1,1).substr($hex,1,1));
          $b = hexdec(substr($hex,2,1).substr($hex,2,1));
           break;

       default:
          $r = hexdec(substr($hex,0,2));
          $g = hexdec(substr($hex,2,2));
          $b = hexdec(substr($hex,4,2));
           break;
   }

   $rgb = array($r, $g, $b);
   return implode(",", $rgb); 
}

if (isset($_GET)) {
    
    list($dest_width, $dest_height, $dest_type, $dest_attr) = getimagesize($_GET['img_1']);
    list($src_width, $src_height, $src_type, $src_attr) = getimagesize($_GET['img_2']);

    $dest;
    $src;

    if ($image_types[$dest_type] == "JPEG") {
        $dest = imagecreatefromjpeg($_GET['img_1']);
    }
    else if ($image_types[$dest_type] == "PNG") {
        die("here");
        $dest = imagecreatefrompng($_GET['img_1']);
    }

    if ($image_types[$src_type] == "JPEG") {
        $src = imagecreatefromjpeg($_GET['img_2']);
        die("here");
    }
    else if ($image_types[$src_type] == "PNG") {
        $src = imagecreatefrompng($_GET['img_2']);
    }

    imagealphablending($dest, false);
    imagesavealpha($dest, true);

    $result = imagecopymerge($dest, $src, 10, 10, 0, 0, 300, 300, 100); 

    // echo $result;

    header('Content-Type: image/png');
    imagepng($dest);

    imagedestroy($dest);
    imagedestroy($src);
}


?>

 <img src="media_generator.php?img_1=assets/img/about-us-cover.jpg&img_2=assets/img/club_logo.png" alt="GD Library Example Image" >