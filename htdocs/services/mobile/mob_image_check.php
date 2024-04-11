<?php
# @description Checks wether an image URL is a valid image or not.
# @param $_GET['imgUrl'] String
# @returns JSON Arrray
# @author Joy Victoria <jvictoria@zugent.com>

######################
include_once('mob_get_json.php');

/**SAMPLE IMAGES */
$url = 'https://cdn2.iconfinder.com/data/icons/social-media-8/512/Chrome.png';
$url2 = 'https://zugidx.s3.amazonaws.com/650/nwmls_1037797_1.jpg';

/**CHECK IF DATA IS SET */
if (isset($_POST)) {
  $imgUrl = $_POST['imgUrl'];
  $imagesize = @getimagesize($imgUrl);
  if($imagesize === false) {
    echo json_encode(array('data'=> false, 'message' => 'Incorrect image file'));
  } else {
    echo json_encode(array('data' => $imagesize, 'message' => true));
  }
} else {
  echo json_encode(array('data'=> false, 'message' => 'data not set'));
}
?>
