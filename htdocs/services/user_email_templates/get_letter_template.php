<?php 

require_once($_SERVER['SITE_DIR']."/includes/common.php");
require_once($_SERVER['SITE_DIR']."/vendor/autoload.php");

// Get User Letter Templates
$letter_temp = SQL_QUERY("select * from user_email_templates 
	where user_email_template_id = '".$_POST['user_letter_template_id']."'");

$letter_template = array();

while ($data = SQL_ASSOC_ARRAY($letter_temp)) {
	$letter_template[] = $data;
}

// Get Company Header
$ch = SQL_QUERY("select url_email_logo from companies 
	where company_id = '".$_SESSION['user']['company_id']."'");

$company_header = array();

while ($data = SQL_ASSOC_ARRAY($ch)) {
	$company_header[] = $data;
}

// Get Agent Information
$agent = SQL_QUERY("select * from users 
	where user_id = '".$_SESSION['user_id']."'");

$agent_info = array();

while ($data = SQL_ASSOC_ARRAY($agent)) {
	$agent_info[] = $data;
}

// echo "<pre>";
// print_r($agent_info);
// echo "</pre>";
// die("QWERTY");

$html = $letter_template[0]['message'];

$mpdf = new \Mpdf\Mpdf(['tempDir' => __DIR__ . '/mpdf/temp', 'setAutoTopMargin' => 'stretch']);

//Define the Header/Footer before writing anything so they appear on the first page
if (!empty($company_header[0]['url_email_logo'])) {
	$template_header = '<div style="text-align: right; font-weight: bold;">';
	$template_header.= '<img src="';
	$template_header.= $company_header[0]['url_email_logo'];
	$template_header.= '" height="50px"/>';
	$template_header.= '</div>';
	$mpdf->SetHTMLHeader($template_header);
}
else {
	$mpdf->SetHTMLHeader('<div style="text-align: right; font-weight: bold;"><img src="https://ruopen.com/assets/img/ruopen_banner.jpg" height="50px" /></div>');
}


// Load Stylesheet
// $stylesheet = file_get_contents('mpdfstyleA4.css');
// $mpdf->WriteHTML($stylesheet, 1);

// $mpdf->SetHTMLFooter('
// <table width="100%">
//     <tr>
//         <td width="33%">{DATE j-m-Y}</td>
//         <td width="33%" align="center">{PAGENO}/{nbpg}</td>
//         <td width="33%" style="text-align: right;">My document</td>
//     </tr>
// </table>');

if ($agent_info[0]['is_profile_photo'] == "1") {
	$agent_profile_photo = 'https://s3-us-west-2.amazonaws.com/zugent/profilephotos/'.$agent_info[0]['user_id'].'/original.jpg';
}
else {
	$agent_profile_photo = '/assets/img/user-0.jpg';
}

$mpdf->SetHTMLFooter('
<table width="100%">
    <tr>
        <td width="10%">
        	<img src="'.$agent_profile_photo.'" height="50px" />
        </td>
        <td width="30%" style="text-align: left;">
	        <p>'.$agent_info[0]['first_name'].' '.$agent_info[0]['last_name'].'</p>
	        <p>'.$agent_info[0]['email'].'</p>
	        <p>'.$agent_info[0]['phone_mobile'].'</p>
        </td>
        <td width="60%"></td>
    </tr>
</table>');

$mpdf->WriteHTML($html);

// $mpdf->Output(); // For sending output to browser
$mpdf->Output('../../assets/pdfs/preview_letter.pdf','F'); // For Download

exit;

?>