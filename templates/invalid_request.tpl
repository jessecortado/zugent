{include file="includes/header.tpl"}

<!-- begin #content -->
<div id="content" class="content">

	<!-- begin page-header -->
	<h1 class="page-header">{$error_title|default:'Error Title Here!'}</h1>
	<div class="alert alert-info fade in m-b-15">
		<!-- <strong>Access Forbidden!</strong> -->
		{$error_msg|default:'Error Message Here!'}
		<span class="close" data-dismiss="alert">×</span>
	</div>
	<!-- end page-header -->

</div>
<!-- end #content -->

{include file="includes/footer.tpl"}