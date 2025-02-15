<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta name="viewport" content="width=device-width" />
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<title>{$event.event_subject}</title>
<style>
{literal}.body-wrap,body{background-color:#f6f6f6}.footer,.footer a{color:#999}.aligncenter,.btn-primary{text-align:center}*{margin:0;padding:0;font-family:"Helvetica Neue",Helvetica,Helvetica,Arial,sans-serif;box-sizing:border-box;font-size:14px}.content,.content-wrap{padding:20px}img{max-width:100%}body{-webkit-font-smoothing:antialiased;-webkit-text-size-adjust:none;width:100%!important;height:100%;line-height:1.6}table td{vertical-align:top}.body-wrap{width:100%}.container{display:block!important;max-width:600px!important;margin:0 auto!important;clear:both!important}.clear,.footer{clear:both}.content{max-width:600px;margin:0 auto;display:block}.main{background:#fff;border:1px solid #e9e9e9;border-radius:3px}.content-block{padding:0 0 20px}.header{width:100%;margin-bottom:20px}.footer{width:100%;padding:20px}.footer a,.footer p,.footer td,.footer unsubscribe{font-size:12px}h1,h2,h3{font-family:"Helvetica Neue",Helvetica,Arial,"Lucida Grande",sans-serif;color:#000;margin:40px 0 0;line-height:1.2;font-weight:400}h1{font-size:32px;font-weight:500}h2{font-size:24px}h3{font-size:18px}h4{font-size:14px;font-weight:600}ol,p,ul{margin-bottom:10px;font-weight:400}ol li,p li,ul li{margin-left:5px;list-style-position:inside}a{color:#1ab394;text-decoration:underline}.alert a,.btn-primary{text-decoration:none}.btn-primary{color:#FFF;background-color:#1ab394;border:solid #1ab394;border-width:5px 10px;line-height:2;font-weight:700;cursor:pointer;display:inline-block;border-radius:5px;text-transform:capitalize}.alert,.alert a{color:#fff;font-weight:500;font-size:16px}.last{margin-bottom:0}.first{margin-top:0}.alignright{text-align:right}.alignleft{text-align:left}.alert{padding:20px;text-align:center;border-radius:3px 3px 0 0}.alert.alert-warning{background:#f8ac59}.alert.alert-bad{background:#ed5565}.alert.alert-good{background:#1ab394}.invoice{margin:40px auto;text-align:left;width:80%}.invoice td{padding:5px 0}.invoice .invoice-items{width:100%}.invoice .invoice-items td{border-top:#eee 1px solid}.invoice .invoice-items .total td{border-top:2px solid #333;border-bottom:2px solid #333;font-weight:700}@media only screen and (max-width:640px){.container,.invoice{width:100%!important}h1,h2,h3,h4{font-weight:600!important;margin:20px 0 5px!important}h1{font-size:22px!important}h2{font-size:18px!important}h3{font-size:16px!important}.content,.content-wrap{padding:10px!important}}{/literal}
</style>
</head>
<body>
<table class="body-wrap">
<tr>
<td></td>
<td class="container" width="600">
<div class="content">
<table class="main" width="100%" cellpadding="0" cellspacing="0">
<tr>
<td class="content-wrap">
<table  cellpadding="0" cellspacing="0">
{if isset($company.log_file)}{if $company.logo_file ne ''}{/if}
<tr>
<td>
<img class="img-responsive" src="{if isset($company.logo_file)}{$company.logo_file}{/if}"/>
</td>
</tr>
{/if}
<tr>
<td class="content-block">
{if isset($event.event_body)}{$event.event_body}{/if}
{if isset($body)}{$body}{/if}
</td>
</tr>
</table>
</td>
</tr>
</table>
<div class="footer">
<table width="100%">
{if isset($from.url_facebook)}
{if $from.url_facebook ne '' || $from.url_twitter}
<tr>
<td class="aligncenter content-block">Follow me on {if $from.url_facebook ne ''}<a href="{$from.url_facebook}">Facebook</a>{if $from.url_twitter ne ''} and {/if}{/if}{/if}{if isset($from.url_twitter)}{if $from.url_twitter ne ''}<a href="{$from.url_twitter}">Twitter</a>{/if}.</td>
</tr>
{/if}{/if}
<tr>
<td class="aligncenter content-block">
<!-- To unsubscribe click <a href="http://www.zugent.com/unsubscribe.php?id={$contact.contact_id}&e={$contact.email}">unsubscribe</a>.<br/> -->
{if isset($from.email_footer_line_1)}
{if $company.email_footer_line_1 ne ''}{$company.email_footer_line_1}<br/>{/if}
{/if}
{if isset($from.email_footer_line_2)}
{if $company.email_footer_line_2 ne ''}{$company.email_footer_line_2}<br/>{/if}
{/if}
</td>
</tr>
</table>
</div></div>
</td>
<td></td>
</tr>
</table>
<img src="http://crm.ruopen.com/services/track_event.php?id={$event.campaign_event_id}&c={$contact.contact_id}"/>
</body>
</html>