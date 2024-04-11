<?php

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

 	use Aws\S3\S3Client;
	use Aws\S3\Exception\S3Exception;

	$s3Client = S3Client::factory(array(
	    'key'    => 'AKIAJ7MLE7RT54HBO6XQ',
	    'secret' => '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'
	));

	if (!isset($_POST['user_id']))
		$user_id = $_SESSION['user_id'];
	else
		$user_id = $_POST['user_id'];

	
	if (isset($_FILES['file'])) {

	    $tempfile = $_FILES['file']['tmp_name'];
	 	$filename = $_FILES['file']['name'];

 		if (file_exists($tempfile)) {
 			try {
	            $result = $s3Client->putObject(array(
					'Bucket'     => 'zugent',
					'Key'        => 'useremailphotos/'.$user_id.'/'.'original.jpg',
					'SourceFile' => $tempfile
	            ));  
	            $object_url = $result['ObjectURL'];
				// generateThumb(30, $tempfile);
				// generateThumb(80, $tempfile);
				// generateThumb(640, $tempfile);
			} catch (S3Exception $e) {
			    echo $e->getMessage() . "\n";
			}
        }

        SQL_QUERY("update users set url_email_logo='".$object_url."' where user_id=".SQL_CLEAN($user_id));

        // SQL_QUERY("update users set url_email_logo=".str_replace('/', '\\/', $object_url)." where user_id=".SQL_CLEAN($user_id));

		// $sth = SQL_QUERY("select * from users where user_id=".$user_id);

		// if (!isset($_POST['user_id'])) {
		// 	$user_data = SQL_ASSOC_ARRAY($sth);
		// 	$_SESSION['user'] = $user_data;
		// }

        @unlink($filename);
     
	}
	
	// function generateThumb($thumbSize, $filename) {
	// 	global $rets, $config, $options, $config_ini, $s3Client, $log_id, $log_added, $log_updated;

	// 	$user_id = $_SESSION['user_id'];

	//     list($width, $height) = getimagesize($filename);
	//     $myImage = imagecreatefromjpeg($filename);
	//     if ($width > $height) {
	//         $y = 0;
	//         $x = ($width - $height) / 2;
	//         $smallestSide = $height;
	//     } else {
	//         $x = 0;
	//         $y = ($height - $width) / 2;
	//         $smallestSide = $width;
	//     }
	//     $thumb = imagecreatetruecolor($thumbSize, $thumbSize);
	//     imagecopyresampled($thumb, $myImage, 0, 0, $x, $y, $thumbSize, $thumbSize, $smallestSide, $smallestSide);
	//     imagejpeg($thumb, $filename, 80);
	//     $result = $s3Client->putObject(array(
	//             'Bucket'     => 'zugent',
	//             'Key'        => 'profilephotos/'.$user_id.'/'.$thumbSize.'x'.$thumbSize.'.jpg',
	//             'SourceFile' => $filename
	//     ));
	//     @unlink('temp_'.$filename);
	// }
?>