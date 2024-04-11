<?php 

// require_once($_SERVER['SITE_DIR']."bin/rets/idx_listings.php");

require_once $_SERVER['SITE_DIR'] . "/includes/common.php";
require_once $_SERVER['SITE_DIR'] . "/vendor/autoload.php";
// require_once "generate_media.php";


use Aws\S3\Exception\S3Exception;
use Aws\S3\S3Client;

$s3Client = S3Client::factory(array(
    'key' => 'AKIAJ7MLE7RT54HBO6XQ',
    'secret' => '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',
));

$user_id;
if (!isset($_POST['user_id'])) {
    $user_id = $_SESSION['user_id'];
} else {
    $user_id = $_POST['user_id'];
}


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

    $size = round($clen / 1048576, 2);

    return $size; // return formatted size
}

if (isset($_FILES['b_image']) && isset($_FILES['frame'])) {

    $bg_tempfile = $_FILES['b_image']['tmp_name'];
    $bg_filename = $_FILES['b_image']['name'];

    $frame_tempfile = $_FILES['frame']['tmp_name'];
    $frame_filename = $_FILES['frame']['name'];


    if (file_exists($frame_tempfile)) {
        
        try {
                $clean_name = preg_replace("/[^A-Za-z0-9.]/", '', $frame_filename);
                $result = $s3Client->putObject(array(
                    'Bucket' => 'zugent',
                    'Key' => 'mediafiles/' . $user_id . '/' . $clean_name,
                    'SourceFile' => $frame_tempfile,
                ));
                $frame_url = $result['ObjectURL'];

                $check_if_exists = SQL_QUERY("select * from user_media_elements where type='frame' and filename='" . SQL_CLEAN($frame_filename) . "' and media_url='" . SQL_CLEAN($frame_url) . "' and user_id='" . SQL_CLEAN($_SESSION['user']['user_id']) . "'");

                if (SQL_NUM_ROWS($check_if_exists) > 0) {

                } else {
                    $sth = SQL_QUERY("
                                    insert into
                                        user_media_elements set
                                        type='frame',
                                        filename='" . SQL_CLEAN($frame_filename) .
                        "', media_url='" . SQL_CLEAN($frame_url) .
                        "', user_id='" . SQL_CLEAN($_SESSION['user']['user_id']) .
                        "'
                                ");

                }

            

            list($frame_width, $frame_height) = getimagesize($frame_tempfile);


        } catch (S3Exception $e) {
            echo $e->getMessage() . "\n";
        }
    }
    else if ($_REQUEST['saved_frame']) {

        if (getRemoteFilesize($_REQUEST['frame_url']) >= 2) {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $img_1);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

            $contents = curl_exec($ch);
            curl_close($ch);

            $path = realpath("../../../temp");
            $new_image = ImageCreateFromString($contents);
            imagejpeg($new_image, $path . "/temp" . $date . ".jpg", 100);
            $img_1 = $path . "/temp" . $date . ".jpg";
            $frame_tempfile = $img_1;

        } else {
            $frame_tempfile = $_REQUEST['frame_url'];
        }

    list($frame_width, $frame_height) = getimagesize($frame_tempfile);

    }


    if (file_exists($bg_tempfile)) {
        try {

                $clean_name = preg_replace("/[^A-Za-z0-9.]/", '', $bg_filename);
                $result = $s3Client->putObject(array(
                    'Bucket' => 'zugent',
                    'Key' => 'mediafiles/' . $user_id . '/' . $clean_name,
                    'SourceFile' => $bg_tempfile,
                ));
                $bg_url = $result['ObjectURL'];

                $check_if_exists = SQL_QUERY("select * from user_media_elements where type='main' and filename='".SQL_CLEAN($bg_filename)."' and media_url='".SQL_CLEAN($bg_url)."' and user_id='".SQL_CLEAN($_SESSION['user']['user_id']."'"));

                if (SQL_NUM_ROWS($check_if_exists) > 0) {
                    
                }
                else {
                    $sth = SQL_QUERY("
                        insert into
                            user_media_elements set
                            type='main',
                            filename='" . SQL_CLEAN($bg_filename) .
                        "', media_url='" . SQL_CLEAN($bg_url) .
                        "', user_id='" . SQL_CLEAN($_SESSION['user']['user_id']) .
                        "'
                    ");

                }

            
            
            list($bg_width, $bg_height) = getimagesize($bg_tempfile);


        } catch (S3Exception $e) {
            echo $e->getMessage() . "\n";
        }
    }
    else if ($_REQUEST['saved_image']) {

        if (getRemoteFilesize($_REQUEST['image_url']) >= 2) {
            $ch = curl_init();
            curl_setopt($ch, CURLOPT_URL, $img_1);
            curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);

            $contents = curl_exec($ch);
            curl_close($ch);

            $path = realpath("../../../temp");
            $new_image = ImageCreateFromString($contents);
            imagejpeg($new_image, $path . "/temp2" . $date . ".jpg", 100);
            $img_2 = $path . "/temp2" . $date . ".jpg";
            $bg_tempfile = $img_2;

        } else {
            $bg_tempfile = $_REQUEST['image_url'];
        }

        list($bg_width, $bg_height) = getimagesize($bg_tempfile);
        
    }


    // SQL_QUERY("update users set is_profile_photo=1 where user_id=" . SQL_CLEAN($user_id));

    // $sth = SQL_QUERY("select * from users where user_id=" . $user_id);

    // if (!isset($_POST['user_id'])) {
    //     $user_data = SQL_ASSOC_ARRAY($sth);
    //     $_SESSION['user'] = $user_data;
    // }


    if ($frame_width > $bg_width && $frame_height > $bg_height) 
        $base_font_size = (($dest_width + $dest_height) / 2) * .05;
    else
        $base_font_size = (($frame_width + $frame_height) / 2) * .05;

    $header_font_size = round($base_font_size, 2);
    $sub_header_font_size = round($base_font_size * .8, 2);

    $offset_header = round($header_font_size * .25, 2);
    $offset_sub_header = round($sub_header_font_size * .65, 2);

    if ($frame_width > $bg_width && $frame_height > $bg_height) {
        echo json_encode(array("result" => false, "bg_image" => $bg_url, "frame" => $frame_url, "header" => $_POST['header'], "sub_header" => $_POST['sub_header'], "header_font_size" => $header_font_size, "sub_header_font_size" => $sub_header_font_size, "offset_header" => $offset_header, "offset_sub_header" => $offset_sub_header));
    }
    else {
        echo json_encode(array("result" => true, "bg_image" => $bg_url, "frame" => $frame_url, "header" => $_POST['header'], "sub_header" => $_POST['sub_header'], "header_font_size" => $header_font_size, "sub_header_font_size" => $sub_header_font_size, "offset_header" => $offset_header, "offset_sub_header" => $offset_sub_header));
    }

    @unlink($bg_filename);
    @unlink($frame_filename);
    exit;
}

echo "no files";

