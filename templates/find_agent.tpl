{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<style type="text/css">
	#floating-panel {
		position: absolute;
		top: 70px;
	    left: 48%;
	    width: 320px;
		z-index: 20;
		background-color: #000;
		padding: 5px;
		border: 1px solid #999;
		border-radius: 6px;
		text-align: center;
		font-family: 'Roboto','sans-serif';
		line-height: 30px;
	}
	#floating-panel-2 {
		position: absolute;
		top: 110px;
    	left: 12.5%;
	    width: 130px;
		z-index: 20;
		background-color: #000;
		padding: 5px;
		border: 1px solid #999;
		border-radius: 6px;
		text-align: center;
		font-family: 'Roboto','sans-serif';
		line-height: 30px;
	}
	.gmap-agent-avatar img {
		border-radius: 50%;
	}
	.gmap-agent-info {
		text-align: center;
		font-size: 14px;
		font-weight: bold;
		margin-top: 5px;
	}

	/*CSS Radio Button*/
	/*.checkbox.checkbox-css input, .radio.radio-css input {
		display: block; 
	}*/
	.radio.radio-css {
	    position: relative;
	    line-height: 16px;
	    padding-top: 7px;
	}
	.radio.radio-css label {
	    padding-left: 24px;
	    margin: 0;
	    color: #fff;
	}
	.radio.radio-css input:checked+label:before {
	    background: #348fe2;
	    border-color: #348fe2;
	}
	.radio.radio-css label:before {
	    content: '';
	    position: absolute;
	    left: 0;
	    top: 7px;
	    width: 16px;
	    height: 16px;
	    border-radius: 16px;
	    background: #dee2e6;
	}
	.radio.radio-css input:checked+label:after {
	    content: '';
	    position: absolute;
	    top: 12px;
	    left: 5px;
	    width: 6px;
	    height: 6px;
	    border-radius: 6px;
	    background: #fff;
	}
	.has-success .radio.radio-css label,
	.has-success.radio.radio-css label,
	.is-valid .radio.radio-css label,
	.is-valid.radio.radio-css label {
	    color: #008a8a;
	}

</style>

<!-- begin #content -->
<div id="content" class="content content-full-width">
	<!-- begin breadcrumb -->
	<ol class="breadcrumb pull-right">
		<li><a href="javascript:;">Home</a></li>
		<li class="active">Find an Agent</li>
	</ol>
	<!-- end breadcrumb -->
	<!-- begin page-header -->
	<h1 class="page-header">Find an Agent <small>All available agents</small></h1>
	<!-- end page-header -->

	<div id="browser-error" class="alert alert-danger fade in m-b-15 hide" style="margin: 35px 15px;">
		<strong>Permission Denied!</strong>
		Your browser does not allow to get your location.
		<!-- <span class="close" data-dismiss="alert">×</span> -->
	</div>
	
    <div id="floating-panel">
    	<form id="google-address-form" data-parsley-validate="true">
	      	<div class="input-group">
	            <input id="google-address" type="text" class="form-control" placeholder="Enter Location" data-parsley-required="true"  data-parsley-errors-container="#google-address_error">
	            <div class="input-group-btn">
	                <button type="submit" class="btn btn-success">Locate</button>
	            </div>
	        </div>
            <div id="google-address_error"></div>
        </form>
    </div>
	
    <div id="floating-panel-2">
        <div class="col-md-12">
        	<h5 style="color:#fff;">Check-In Duration</h5>
            <div class="radio radio-css">
                <input type="radio" name="check_in_duration" id="rad30min" value="30 MINUTE" checked="">
                <label for="rad30min">30 minutes</label>
            </div>
            <div class="radio radio-css">
                <input type="radio" name="check_in_duration" id="rad1hr" value="1 HOUR">
                <label for="rad1hr">1 hour</label>
            </div>
            <div class="radio radio-css">
                <input type="radio" name="check_in_duration" id="rad6hrs" value="6 HOUR">
                <label for="rad6hrs">6 hours</label>
            </div>
            <div class="radio radio-css">
                <input type="radio" name="check_in_duration" id="rad24hrs" value="1 DAY">
                <label for="rad24hrs">24 hours</label>
            </div>
            <div class="radio radio-css">
                <input type="radio" name="check_in_duration" id="rad1week" value="7 DAY">
                <label for="rad1week">1 week</label>
            </div>
        </div>
    </div>

	<div class="map">
        <div id="google-map" class="height-full width-full"></div>
    </div>
</div>
<!-- end #content -->


{include file="includes/footer.tpl"}