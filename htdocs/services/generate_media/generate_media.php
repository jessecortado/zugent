<?php

require_once $_SERVER['SITE_DIR'] . "/includes/common.php";

require_once $_SERVER['SITE_DIR'] . "/vendor/autoload.php";
// require_once "generate_media.php";
ini_set('memory_limit', '512M');

use Aws\S3\Exception\S3Exception;
use Aws\S3\S3Client;

putenv('GDFONTPATH=' . realpath('../..')."/assets/fonts/");

/**
 *  Get the file size of any remote resource (using get_headers()),
 *  either in bytes or - default - as human-readable formatted string.
 *
 *  @author  Stephan Schmitz <eyecatchup@gmail.com>
 *  @license MIT <http://eyecatchup.mit-license.org/>
 *  @url     <https://gist.github.com/eyecatchup/f26300ffd7e50a92bc4d>
 *
 *  @param   string   $url          Takes the remote object's URL.
 *  @param   boolean  $formatSize   Whether to return size in bytes or formatted.
 *  @param   boolean  $useHead      Whether to use HEAD requests. If false, uses GET.
 *  @return  string                 Returns human-readable formatted size
 *                                  or size in bytes (default: formatted).
 */
function getRemoteFilesize($url, $formatSize = true, $useHead = true)
{
    if (false !== $useHead) {
        stream_context_set_default(array('http' => array('method' => 'HEAD')));
    }
    $head = array_change_key_case(get_headers($url, 1));
    // content-length of download (in bytes), read from Content-Length: field
    $clen = isset($head['content-length']) ? $head['content-length'] : 0;

    // cannot retrieve file size, return "-1"
    if (!$clen) {
        return -1;
    }

    if (!$formatSize) {
        return $clen; // return size in bytes
    }

    // Removed
    // $size = $clen;
    // switch ($clen) {
    //     case $clen < 1024:
    //         $size = $clen . ' B';
    //         break;
    //     case $clen < 1048576:
    //         $size = round($clen / 1024, 2) . ' KiB';
    //         break;
    //     case $clen < 1073741824:
    //         $size = round($clen / 1048576, 2) . ' MiB';
    //         break;
    //     case $clen < 1099511627776:
    //         $size = round($clen / 1073741824, 2) . ' GiB';
    //         break;
    // }
    // New just return in MBs

    $size = round($clen / 1048576, 2);

    return $size; // return formatted size
}

function calculate_text_box($font_size, $font_angle, $font_file, $text)
{
    $box = imagettfbbox($font_size, $font_angle, "arial", $text);
    if (!$box) {
        return false;
    }

    $min_x = min(array($box[0], $box[2], $box[4], $box[6]));
    $max_x = max(array($box[0], $box[2], $box[4], $box[6]));
    $min_y = min(array($box[1], $box[3], $box[5], $box[7]));
    $max_y = max(array($box[1], $box[3], $box[5], $box[7]));
    $width = ($max_x - $min_x);
    $height = ($max_y - $min_y);
    $left = abs($min_x) + $width;
    $top = abs($min_y) + $height;
    // to calculate the exact bounding box i write the text in a large image
    $img = @imagecreatetruecolor($width << 2, $height << 2);
    $white = imagecolorallocate($img, 255, 255, 255);
    $black = imagecolorallocate($img, 0, 0, 0);
    imagefilledrectangle($img, 0, 0, imagesx($img), imagesy($img), $black);
    // for sure the text is completely in the image!
    imagettftext($img, $font_size,
        $font_angle, $left, $top,
        $white, $font_file, $text);
    // start scanning (0=> black => empty)
    $rleft = $w4 = $width << 2;
    $rright = 0;
    $rbottom = 0;
    $rtop = $h4 = $height << 2;
    for ($x = 0; $x < $w4; $x++) {
        for ($y = 0; $y < $h4; $y++) {
            if (imagecolorat($img, $x, $y)) {
                $rleft = min($rleft, $x);
                $rright = max($rright, $x);
                $rtop = min($rtop, $y);
                $rbottom = max($rbottom, $y);
            }
        }
    }

    // destroy img and serve the result
    imagedestroy($img);
    return array("left" => $left - $rleft,
        "top" => $top - $rtop,
        "width" => $rright - $rleft + 1,
        "height" => $rbottom - $rtop + 1);
}


function imagecopymerge_alpha($dst_im, $src_im, $dst_x, $dst_y, $src_x, $src_y, $src_w, $src_h, $pct)
{
    // creating a cut resource
    $cut = imagecreatetruecolor($src_w, $src_h);

    // copying relevant section from background to the cut resource
    imagecopy($cut, $dst_im, 0, 0, $dst_x, $dst_y, $src_w, $src_h);

    // copying relevant section from watermark to the cut resource
    imagecopy($cut, $src_im, 0, 0, $src_x, $src_y, $src_w, $src_h);

    // insert cut resource to destination image
    imagecopymerge($dst_im, $cut, $dst_x, $dst_y, 0, 0, $src_w, $src_h, $pct);
}

function image_resize($src, $width, $height, $crop = 0)
{
    try {
        // $w, $h current width and height of dest image
        // $width and $height target width and height
        if (!list($w, $h) = getimagesize($src)) {
            return "Unsupported picture type!";
        }

        $type = strtolower(substr(strrchr($src, "."), 1));
        if ($type == 'jpeg') {
            $type = 'jpg';
        }

        switch ($type) {
            case 'bmp':$img = imagecreatefromwbmp($src);
                break;
            case 'gif':$img = imagecreatefromgif($src);
                break;
            case 'jpg':$img = imagecreatefromjpeg($src);
                break;
            case 'png':$img = imagecreatefrompng($src);
                break;
            default:return "Unsupported picture type!";
        }

        // resize
        if ($crop) {
            // changed from or to and
            if ($w < $width && $h < $height) {
                return false;
            }

            $ratio = max($width / $w, $height / $h);
            $h = $height / $ratio;
            $x = ($w - $width / $ratio) / 2;
            $w = $width / $ratio;
        } else {
            if ($w < $width and $h < $height) {
                
                $ratio = min($width / $w, $height / $h);
                $width = $w * $ratio;
                $height = $h * $ratio;
                $x = 0;
            }
            else {
                $ratio = min($width / $w, $height / $h);
                $width = $w * $ratio;
                $height = $h * $ratio;
                $x = 0;
            }
        }

        $new = imagecreatetruecolor($width, $height);

        // preserve transparency
        if ($type == "gif" or $type == "png") {
            imagecolortransparent($new, imagecolorallocatealpha($new, 0, 0, 0, 127));
            imagealphablending($new, false);
            imagesavealpha($new, true);
        }

        imagecopyresampled($new, $img, 0, 0, $x, 0, $width, $height, $w, $h);

        return $new;

    } catch (exception $e) {
        return false;
    }
}

function hex2rgb($hex)
{

    $hex = str_replace("#", "", $hex);

    switch (strlen($hex)) {
        case 1:
            $hex = $hex . $hex;
        case 2:
            $r = hexdec($hex);
            $g = hexdec($hex);
            $b = hexdec($hex);
            break;

        case 3:
            $r = hexdec(substr($hex, 0, 1) . substr($hex, 0, 1));
            $g = hexdec(substr($hex, 1, 1) . substr($hex, 1, 1));
            $b = hexdec(substr($hex, 2, 1) . substr($hex, 2, 1));
            break;

        default:
            $r = hexdec(substr($hex, 0, 2));
            $g = hexdec(substr($hex, 2, 2));
            $b = hexdec(substr($hex, 4, 2));
            break;
    }

    $rgb = array($r, $g, $b);
    return implode(",", $rgb);
}

function generate_image($img_1, $img_2, $header = "header" , $sub_header = "sub-header", $crop = 1, $invert_layers = 0, $save = 0, $options = array()) 
{
    // Start Variables
    $font_path = realpath('../..') . "/assets/fonts/";
    $date = date("YmdHis");
    $image_types = array
        (
        0 => 'UNKNOWN',
        1 => 'GIF',
        2 => 'JPEG',
        3 => 'PNG',
        4 => 'SWF',
        5 => 'PSD',
        6 => 'BMP',
        7 => 'TIFF_II',
        8 => 'TIFF_MM',
        9 => 'JPC',
        10 => 'JP2',
        11 => 'JPX',
        12 => 'JB2',
        13 => 'SWC',
        14 => 'IFF',
        15 => 'WBMP',
        16 => 'XBM',
        17 => 'ICO',
        18 => 'COUNT',
    );

    
    // Start fix for larger files
    if (getRemoteFilesize($img_1) >= 2) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $img_1);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        $contents = curl_exec($ch);
        curl_close($ch);

        $path = realpath("../../../temp");
        // die($path);
        $new_image = ImageCreateFromString($contents);
        imagejpeg($new_image, $path."/temp".$date.".jpg", 100);
        $img_1 = $path."/temp".$date.".jpg";

        // die($img_1);
        // unlink($img_1);

        list($dest_width, $dest_height, $dest_type, $dest_attr) = getimagesize($img_1);
    } else {
        list($dest_width, $dest_height, $dest_type, $dest_attr) = getimagesize($img_1);
    }

    if (getRemoteFilesize($img_2) >= 2) {
        $ch = curl_init();
        curl_setopt($ch, CURLOPT_URL, $img_2);
        curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

        $contents = curl_exec($ch);
        curl_close($ch);

        $path = realpath("../../../temp");
        
        $new_image = ImageCreateFromString($contents);
        imagejpeg($new_image, $path . "/temp" . $date . ".jpg", 100);
        $img_1 = $path . "/temp" . $date . ".jpg";


        list($src_width, $src_height, $src_type, $src_attr) = getimagesize($contents);
    } else {
        list($src_width, $src_height, $src_type, $src_attr) = getimagesize($img_2);
    }
    // End fix for larger files

    
    if ($image_types[$dest_type] == "JPEG") {
        $dest = imagecreatefromjpeg($img_1);
    } else if ($image_types[$dest_type] == "PNG") {
        $dest = imagecreatefrompng($img_1);
    }

    if ($image_types[$src_type] == "JPEG") {
        $src = imagecreatefromjpeg($img_2);
    } else if ($image_types[$src_type] == "PNG") {
        $src = imagecreatefrompng($img_2);
    }

    // Start Header
    $header = $_GET['header'];
    $sub_header = $_GET['sub_header'];
    $base_font_size = (($src_width + $src_height) / 2) * .05;
    $header_font_size = !empty($options['header_font_size']) ? $options['header_font_size'] : $base_font_size;
    $sub_header_font_size = !empty($options['sub_header_font_size']) ? $options['sub_header_font_size'] : ($base_font_size*.8);
    $header_color = !empty($options['header_color']) ? str_replace("#", "", $options['header_color']) : "FFFFFF";
    $sub_header_color = !empty($options['sub_header_color']) ? str_replace("#", "", $options['sub_header_color']) : "FFFFFF";

    // die($header_font_size ." ".$sub_header_font_size);
    $offset_header = !empty($options['header_offset']) ? $options['header_offset'] : $header_font_size*.25;
    $offset_sub_header = !empty($options['sub_header_offset']) ? $options['sub_header_offset'] : $sub_header_font_size*.65;

    // $header = "wxh:".$dest_width."x".$dest_height." and ". $src_width."x".$src_height;
    $header_dim = calculate_text_box($header_font_size, 0, $font_path . "arial.ttf", $header);
    $sub_header_dim = calculate_text_box($sub_header_font_size, 0, $font_path . "arial.ttf", $sub_header);

    // Start Sub Header
    // $sub_header = $_GET['sub_header'];
    // $header_dim = calculate_text_box($header_font_size, 0, $font_path . "arial.ttf", $sub_header);

    $black = imagecolorallocate($dest, 30, 30, 30);
    $white = imagecolorallocate($dest, 255, 255, 255);
    $h_color = imagecolorallocate($dest, hexdec(substr($header_color, 0, 2)), hexdec(substr($header_color, 2, 2)), hexdec(substr($header_color, 4, 2)));
    $sh_color = imagecolorallocate($dest, hexdec(substr($sub_header_color, 0, 2)), hexdec(substr($sub_header_color, 2, 2)),  hexdec(substr($sub_header_color, 4, 2)));


    // die( "0x".substr($header_color, 0, 2). ",0x".substr($header_color, 2, 2). ",0x".substr($header_color, 4, 2));
    // die($black ." " .$white. " ".$h_color." ".$sh_color);

    // if (!$resized) {
        
    //     $resized = image_resize($img_2, imagesx($dest), imagesy($dest));
    //     $string_x = (imagesx($dest) - $header_dim['width']) / 2;
    //     $string_y = imagesy($dest) - $header_dim['height'] - 50;
    //     $center_x = (imagesx($resized) - imagesx($src)) / 2;
    //     $center_y = (imagesy($resized) - imagesy($src)) / 2;

    //     $cropped = $resized;
    //     // $cropped = imagecrop($src, ["x" => 0, "y" => 0, "width" => (imagesx($dest)), "height" => (imagesy($dest))]);
    //     // Add Text to images
    //     imagettftext($cropped, $header_font_size, 0, $string_x + 2, $string_y + 2, $black, $font_path . "arial.ttf", $header);
    //     imagettftext($cropped, $header_font_size, 0, $string_x, $string_y, $white, $font_path . "arial.ttf", $header);

    //     imagecopymerge_alpha($src, $cropped, 0, 0, 0, 0, $src_width, $src_height, 100);
    //     imagepng($cropped);

    // }

    // if (!$resized) 
    //     $resized = image_resize($img_2, imagesx($src), imagesy($src), $crop);
    // if (!$resized)
    //     $resized = image_resize($img_2, imagesx($src), imagesy($src));
    $cropped;
    if (!$invert_layers) {

        imagealphablending($dest, true);
        imagesavealpha($dest, true);

        // Start Image Center
        $center_x = (imagesx($dest) - imagesx($src)) / 2;
        $center_y = (imagesy($dest) - imagesy($src)) / 2;

        // Start Resize (combined with crop)
        $resized = image_resize($img_1, imagesx($src), imagesy($src), $crop);

        // die("".$h_color);
        $string_x = (imagesx($src) - $header_dim['width']) / 2;
        $string_y = imagesy($src) - $header_dim['height'] - $src_height * .07 - $offset_header;

        $center_x = (imagesx($resized) - imagesx($src)) / 2;
        $center_y = (imagesy($resized) - imagesy($src)) / 2;

        $cropped = $resized;

        $cropped = imagecrop($resized, ["x" => 0, "y" => 0, "width" => (imagesx($src)), "height" => (imagesy($src))]);

        // Add header to images
        imagettftext($cropped, $header_font_size, 0, $string_x + 1, $string_y + 1, $black, $font_path . "arial.ttf", $header);
        imagettftext($cropped, $header_font_size, 0, $string_x, $string_y, $h_color, $font_path . "arial.ttf", $header);

        $string_x = (imagesx($src) - $sub_header_dim['width']) / 2;
        $string_y = imagesy($src) - $sub_header_dim['height'] - $src_height * .07 - $offset_sub_header;
        // Add Sub Header to images
        imagettftext($cropped, $sub_header_font_size, 0, $string_x + 1, $string_y - $header_dim['height'] + 1, $black, $font_path . "arial.ttf", $sub_header);
        imagettftext($cropped, $sub_header_font_size, 0, $string_x, $string_y - $header_dim['height'], $sh_color, $font_path . "arial.ttf", $sub_header);

        imagecopymerge_alpha($cropped, $src, 0, 0, 0, 0, $src_width, $src_height, 100);

    }
    else {
        imagealphablending($src, true);
        imagesavealpha($src, true);

        // Start Resize (combined with crop)
        
        $resized_frame = image_resize($img_1, imagesx($src), imagesy($src), 0);
        // if (empty($resized_frame))
        //     $resized_frame = image_resize($img_1, imagesx($src), imagesy($src), 1);
        // die($resized_frame);
        $resized = image_resize($img_2, imagesx($resized_frame), imagesy($resized_frame), 1);


        // Get center point of image to be printed on
        $string_x = (imagesx($resized_frame) - $header_dim['width']) / 2;
        // Get bottom point minus the height of the text and a variable value
        $header_y = imagesy($resized_frame) - $header_dim['height'] - $offset_header;

        // echo($string_y);

        // Start Image Center
        $center_x = imagesx($resized_frame) / 2;
        $center_y = imagesy($resized_frame) / 2;


        // $cropped = imagecrop($resized_frame, ["x" => 0, "y" => 0, "width" => (imagesx($dest)), "height" => (imagesy($dest))]);
        
        // Add Header to images
        imagettftext($resized_frame, $header_font_size, 0, $string_x + 1, $header_y + 1, $black, $font_path . "arial.ttf", $header);
        imagettftext($resized_frame, $header_font_size, 0, $string_x, $header_y, $h_color, $font_path . "arial.ttf", $header);

        // Get center point of image to be printed on
        $string_x = (imagesx($resized_frame) - $sub_header_dim['width']) / 2;
        // Get bottom point minus the height of the text and a variable value
        $header_y = imagesy($resized_frame) - $header_dim['height'] - $sub_header_dim['height'] - $offset_sub_header;

        // Add Sub Header to images
        imagettftext($resized_frame, $sub_header_font_size, 0, $string_x + 1, $header_y + 1, $black, $font_path . "arial.ttf", $sub_header);
        imagettftext($resized_frame, $sub_header_font_size, 0, $string_x, $header_y, $sh_color, $font_path . "arial.ttf", $sub_header);

        imagecopymerge_alpha($resized, $resized_frame, 0, 0, 0, 0, $src_width, $src_height, 100);

        // For saving purposes
        $cropped = $resized;

        header('Content-Type: image/png');

        imagepng($cropped);
        exit;

    }

    if ($save) {

        if (!file_exists('/tmp/tmpfile')) {
            mkdir('/tmp/tmpfile');
        }

        header('Content-Type: image/png');
        $temp_file_path = $_SERVER['SITE_DIR'].'/temp/' .$_POST['media_name'].".png";
        imagepng($cropped, $temp_file_path);

        try {

            $s3Client = S3Client::factory(array(
                'key' => 'AKIAJ7MLE7RT54HBO6XQ',
                'secret' => '8vXm0TuKT6C2getoTJ/dE6KP2Ag3yIZ+PaVtLVQA',
            ));

            $clean_name = preg_replace("/[^A-Za-z0-9.]/", '', $_POST['media_name'].".png"); 
            $result = $s3Client->putObject(array(
                'Bucket' => 'zugent',
                'Key' => 'mediafiles/generated/' . $_SESSION['user']['user_id'] . '/' . $clean_name,
                'SourceFile' => $temp_file_path,
            ));
            $url = $result['ObjectURL'];

            $sth = SQL_QUERY("
                            insert into
                                generated_media set
                                    name='" . SQL_CLEAN($_POST['media_name']) .
                                "', generated_url='" . SQL_CLEAN($url) .
                                "', user_id='" . SQL_CLEAN($_SESSION['user']['user_id']) .
                        "'");

        } catch (S3Exception $e) {
            echo $e->getMessage() . "\n";
        }

        unlink($temp_file_path);
        header('Content-Type: application/json');

        echo json_encode(array("result"=>true, "url"=>$url));

    }
    else {

        header('Content-Type: image/png');

        imagepng($cropped);
    }

    // // Start crop
    // $string_x = (imagesx($src) - $header_dim['width']) / 2;
    // $string_y = imagesy($src) - $header_dim['height'] - 50;
    // $cropped = imagecrop( $dest, ["x"=>$center_x, "y"=>$center_y, "width"=>(imagesx($src)), "height"=>(imagesy($src))] );
    // // Add Text to images
    // imagettftext($cropped, $header_font_size, 0, $string_x, $string_y, $color, $font_path."arial.ttf", $string);
    // imagecopymerge_alpha($cropped, $src, 0, 0, 0, 0, $src_width, $src_height, 100);
    // imagepng($cropped);

    // // Start Original
    // $string_x = (imagesx($dest) - $header_dim['width']) / 2;
    // $string_y = imagesy($dest) - $header_dim['height'] - 50;
    // imagettftext($dest, $header_font_size, 0, $string_x, $string_y, $color, $font_path . "arial.ttf", $string);
    // imagecopymerge_alpha($dest, $src, $center_x, $center_y, 0, 0, $src_width, $src_height, 100);
    // imagepng($dest);

    imagedestroy($dest);
    imagedestroy($src);
    imagedestroy($cropped);
    imagedestroy($resized);
    imagedestroy($resized_frame);
    unlink($img_1);
    unlink($img_2);

}

if (!empty($_GET)) {
    // check for which picture is bigger
    $options = array (
        "header_font_size" => $_GET['header_font_size'],
        "sub_header_font_size" => $_GET['sub_header_font_size'],
        "header_color" => $_GET['header_color'],
        "sub_header_color" => $_GET['sub_header_color'],
        "header_offset" => $_POST['header_offset'],
        "sub_header_offset" => $_POST['sub_header_offset'],
        "text_position" => $_GET['text_position'],
        "header_font_style" => $_GET['header_font_style'],
        "sub_header_font_style" => $_GET['sub_header_font_style']
    );
    
    if (!$_GET['invert_layers']) 
        generate_image($_GET['b_image'], $_GET['frame'], $_GET['header'], $_GET['sub_header'], 1, $_GET['invert_layers'], 0, $options);
    else
        generate_image($_GET['frame'], $_GET['b_image'], $_GET['header'], $_GET['sub_header'], 1, $_GET['invert_layers'], 0, $options);
} else if (!empty($_POST)) {
    // echo ("here");
    $options = array (
        "header_font_size" => $_POST['header_font_size'],
        "sub_header_font_size" => $_POST['sub_header_font_size'],
        "header_color" => $_POST['header_color'],
        "sub_header_color" => $_POST['sub_header_color'],
        "header_offset" => $_POST['header_offset'],
        "sub_header_offset" => $_POST['sub_header_offset'],
        "text_position" => $_POST['text_position'],
        "header_font_style" => $_POST['header_font_style'],
        "sub_header_font_style" => $_POST['sub_header_font_style']
    );

    generate_image($_POST['b_image'], $_POST['frame'], $_POST['header'], $_POST['sub_header'], 1, $_POST['invert_layers'], 1, $options);
    
}



