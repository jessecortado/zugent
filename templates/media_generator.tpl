{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap-wizard/css/bwizard.min.css" rel="stylesheet" />
<link href="assets/plugins/parsley/src/parsley.css" rel="stylesheet" />
<link href="assets/css/pages/media_generator.css" rel="stylesheet" />
<link href="assets/plugins/select2/dist/css/select2.min.css" rel="stylesheet">

<link href="assets/plugins/bootstrap-colorpicker/css/bootstrap-colorpicker.min.css" rel="stylesheet" />
    <link href="assets/plugins/jquery-simplecolorpicker/jquery.simplecolorpicker.css" rel="stylesheet" />
    <link href="assets/plugins/jquery-simplecolorpicker/jquery.simplecolorpicker-fontawesome.css" rel="stylesheet" />
    <link href="assets/plugins/jquery-simplecolorpicker/jquery.simplecolorpicker-glyphicons.css" rel="stylesheet" />
<!-- begin #content -->
<div id="content" class="content">

  <!-- start breadcrumb -->
  <h1 class="page-header">{$company.company_name}
    <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
      <li class="active">Generate Media</li>
    </ol>
  </h1>
  <!-- end breadcrumb -->

  <!-- begin row -->
  <div class="row">
    <form id="form-media" action="/services/generate_media/upload_images.php" method="POST" data-parsley-validate="true" name="form-wizard" enctype="multipart/form-data">
    <!-- begin col-6 -->
    <div class="col-md-7">
      <!-- begin panel -->
      <div class="panel panel-inverse">
        <div class="panel-heading">
          <h4 class="panel-title">Media Generation Wizard</h4>
        </div>
        <div class="panel-body">
            <input type="hidden" name="user_id" value="{$user.user_id}">
            <input id="save" type="hidden" name="save" value="0">
            <div id="wizard">
              <ol>
                <li>
                  Background Image
                  <small>Enter the MLS number then choose a photo or upload the photo</small>
                </li>
                <li>
                  Image Text
                  <small>Input text for the image</small>
                </li>
                <li>
                  Filename
                  <small>Enter the generated name</small>
                </li>
                <li>
                  Options
                </li>
              </ol>
              <!-- begin wizard step-1 -->
              <div class="wizard-step-1">
                <div class="jumbotron m-b-15 text-center">
                    <h1>Image Notice</h1>
                    <p> For best results the image uploaded here must have a larger width and height than the frame </p>
                </div>
                <fieldset>
                  <legend class="pull-left width-full"></legend>
                  <!-- begin row -->
                  <div class="row">
                    <!-- begin col-6 -->
                    <div class="col-md-12">
                      <div class="form-group block1 select-image-area">
                        <label>Upload an Image</label>
                        <input type="hidden" name="select_from_mls" id="select-from-mls" value="1">
                        <input id="b-image" type="file" name="b_image" class="form-control dropzone needsclick dz-clickable" data-parsley-group="wizard-step-1" required />
                        <p id="selected-image-name" class=" pull-left text-right"> </p>
                        <button id="show-modal-image" type="button" class="btn btn-primary m-t-10 pull-right" data-toggle="modal" data-target="#modal-image">or Select from MLS</button>
                      </div>
                    </div>
                    <!-- end col-6 -->
                    <!-- begin col-6 -->
                    <div class="col-md-12">
                      <div class="form-group">
                        <label>Frame</label>
                        <input id="frame" type="file" name="frame" class="form-control dropzone needsclick dz-clickable" data-parsley-group="wizard-step-1" required />
                        <p id="selected-frame-name" class="pull-left text-right"> </p>
                        <button id="show-modal-frame" type="button" class="btn btn-primary m-t-10 pull-right" data-toggle="modal" data-target="#modal-frame">Select Saved Frame</button>
                      </div>
                    </div>
                    <!-- end col-6 -->
                  </div>
                  <!-- end row -->
                </fieldset>
              </div>
              <!-- end wizard step-1 -->
              <!-- begin wizard step-2 -->
              <div class="wizard-step-2">
                <fieldset>
                  <legend class="pull-left width-full">Image Text</legend>
                  <!-- begin row -->
                  <div class="row">
                    <!-- begin col-6 -->
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Header </label>
                        <input id="header" type="text" name="header" placeholder="Just Sold In Montlake" class="form-control" data-parsley-group="wizard-step-2" 
                          required />
                      </div>
                    </div>
                    <!-- end col-6 -->
                    <!-- begin col-6 -->
                    <div class="col-md-6">
                      <div class="form-group">
                        <label>Sub Header</label>
                        <input id="sub-header" type="text" name="sub_header" placeholder="Seller Representation" class="form-control" data-parsley-group="wizard-step-2"
                         required />
                      </div>
                    </div>
                    <!-- end col-6 -->
                  </div>
                  <!-- end row -->
                </fieldset>
              </div>
              <!-- end wizard step-2 -->
              <!-- begin wizard step-3 -->
              <div class="wizard-step-3">
                <fieldset>
                  <legend class="pull-left width-full">Generated Name</legend>
                  <!-- begin row -->
                  <div class="row">
                    <!-- begin col-12 -->
                    <div class="col-md-8 col-md-offset-2">
                      <div class="form-group">
                        <label>Name</label>
                        <input id="media-name" type="text" name="media_name" placeholder="Image Name" class="form-control" data-parsley-group="wizard-step-1" required />
                      </div>
                    </div>
                    <!-- end col126 -->

                  </div>
                  <!-- end row -->
                  <button id="generate-preview" class="btn btn-success btn m-t-10">Generate Preview</button>
                </fieldset>
              </div>
              <!-- end wizard step-3 -->
              <!-- begin wizard step-4 -->
              <div>
                <p class="text-center">
                  Font size depends needs to be increased or decreased depending on the size of the image generated.
                </p>
                
                    <div class="row p-10 media-details">
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Header Font Size</label>
                          <input id="header-font-size" type="text" name="header_font_size" placeholder="16" class="form-control image-details" data-parsley-group="wizard-step-1" value="30"/>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Sub Header Font Size</label>
                          <input id="sub-header-font-size" type="text" name="sub_header_font_size" placeholder="16" class="form-control image-details" data-parsley-group="wizard-step-1" value="30"/>
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Header Font Color</label>
                          <input id="header-font-color" type="text" name="header_font_color" placeholder="Select A color" class="form-control colorpicker p-l-10" data-parsley-group="wizard-step-1" value="#FFFFFF" />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Sub Header Font Color</label>
                          <input id="sub-header-font-color" type="text" name="sub_header_font_color" placeholder="Select A Color" class="form-control colorpicker p-l-10'" data-parsley-group="wizard-step-1" value="#FFFFFF" />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Header Additional Offset</label>
                          <input id="header-offset" type="text" name="header_offset" placeholder="15" class="form-control p-l-10 image-offset" data-parsley-group="wizard-step-1" value="20" />
                        </div>
                      </div>
                      <div class="col-md-6">
                        <div class="form-group">
                          <label>Sub Header Additional Offset</label>
                          <input id="sub-header-offset" type="text" name="sub_header_offset" placeholder="5" class="form-control  p-l-10 image-offset" data-parsley-group="wizard-step-1" value="15" />
                        </div>
                      </div>
                    </div>
                    
              </div>
              <!-- end wizard step-4 -->
            </div>
        </div>
      </div>
      <!-- end panel -->
    </div>
    <!-- end col-6 -->
    <!-- start col-6 -->
    <div class="col-md-5">
      <div class="panel panel-inverse">
          <div class="panel-heading">
              <h4 class="panel-title">Media Generation Wizard</h4>
          </div>
          <div class="panel-body text-center" style="min-height:400px;">
            {* <button id="generate-preview" class="btn btn-success m-b-10">Start Preview</button> *}
            <div id="preview-section" class="jumbotron m-b-0 text-center hide">
                  {* <h1>Preview</h1> *}
                  <p class="p-10"> Don't forget to save if everything looks okay. You can also go back to any previous step and generate the image again.<br><small>*image may take a few seconds to load depending on your connection</small> </p>

              <p id="preview-area" class="save-section p-10" style="float: none !important;">
                <button type="submit" class="btn btn-success btn m-t-10">Save Image</button>
              </p>
            </div>
          </div>
      </div>
    </div>

          </form>
  </div>
  <!-- end row -->

  
  <p class="text-center">
    <b>Test Cases</b>
    </p>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image={$host_url}/assets/img/about-us-cover.jpg&frame={$host_url}/assets/img/frame_test.png&header=Testing&sub_header=Something"
      alt="Test 1" style="width:100%; height:auto;">
  </div>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image={$host_url}/assets/img/milestone-bg.jpg&frame={$host_url}/assets/img/frame_test.png&header=Testing&sub_header=Something"
      alt="Test 2" style="width:100%; height:auto;">
  </div>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image={$host_url}/assets/img/maintenance-bg-1.jpg&frame={$host_url}/assets/img/frame_test.png&header=Testing&sub_header=Something"
      alt="Test 3" style="width:100%; height:auto;">
  </div>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image={$host_url}/assets/img/macbook-pro.png&frame={$host_url}/assets/img/frame_square.png&header=Testing&sub_header=Something&invert_layers=1"
      alt="Frame larger" style="width:100%; height:auto;">
  </div>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image={$host_url}/assets/img/my-account-cover.jpg&frame={$host_url}/assets/img/frame_test.png&header=Testing&sub_header=Something"
      alt="Normal Test" style="width:100%; height:auto;">
  </div>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image={$host_url}/assets/img/quote-bg.jpg&frame={$host_url}/assets/img/frame_test.png&header=Testing&sub_header=Something"
      alt="Normal test" style="width:100%; height:auto;">
  </div>
  <div class="col-md-6">
    <img src="services/generate_media/generate_media.php?b_image=https://zugent.s3.amazonaws.com/mediafiles/2/comingsoon.jpg&frame={$host_url}/assets/img/frame_test.png&header=Testing&sub_header=Something"
      alt="Corrupted Image" style="width:100%; height:auto;">
  </div>


</div>
<!-- end #content -->

{* Start Modals *}
<div class="modal fade" id="modal-image" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Select an Image<span></span></h4>
			</div>
			<div class="modal-body p-20 p-b-30">
      
      <div class="row">
        <div class="col-md-3">
					<label class="control-label">MLS</label>
					<div class="form-group">
						<select id="select-mls" class="form-control">
              <option value="">Select One</option>
              {foreach item=row from=$mls}
                <option value="{$row.mls_name}">{$row.mls_name}</option>
              {/foreach}
            </select>
		      </div>

          <div id="div-mls-input" class="form-group">
            <label class="control-label">MLS</label>
            <input type="text" id="mls-number" class="form-control" name="mls_number">
          </div>
        </div>
        <div class="col-md-9">
            <div id="mls-images">
            </div>
            <div id="existing-images">
            <hr/>
              <h5 class="text-center"> Saved Images </h5>
              {foreach item=row from=$images}
                  <div class="col-md-4">
                    <div class="img-box text-center" style="height: 200px;" >
                      <h4>{$row.filename}</h4>
                      <img class="img-responsive" src="{$row.media_url}" alt="{$row.filename}">
                    </div>
                  </div>
              {/foreach}
            </div>
        </div>
        </div>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save-image" class="btn btn-sm btn-success" data-dismiss="modal"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>
<div class="modal fade" id="modal-frame" style="display: none;">
	<div class="modal-dialog modal-lg">
		<div class="modal-content">
			<div class="modal-header">
				<button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
				<h4 class="modal-title">Select a Frame<span></span></h4>
			</div>
			<div class="modal-body p-20 p-b-30">
      <div class="row">
      
      {foreach item=row from=$frames}
          <div class="col-md-4">
            <div class="img-box text-center">
              <h4>{$row.filename}</h4>
              <img class="img-responsive" src="{$row.media_url}" alt="{$row.filename}">
            </div>
          </div>
      {/foreach}

      </div>
			</div>
			<div class="modal-footer">
				<a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
				<a href="javascript:void(0)" id="modal-save-frame" class="btn btn-sm btn-success" data-dismiss="modal"><i class="fa fa-save"></i> Save</a>
			</div>
		</div>
	</div>
</div>
{* End Modals *}

{include file="includes/footer.tpl" footer_js="includes/footers/media_generator.tpl" company_settings_keyval="1"}