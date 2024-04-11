{include file="includes/header.tpl"}
<link href="assets/plugins/dropzone/min/dropzone.min.css" rel="stylesheet" />
<link href="assets/plugins/summernote/summernote.css" rel="stylesheet" />
<link href="assets/plugins/bootstrap-toggle/css/bootstrap-toggle.min.css" rel="stylesheet" />
		
	<!-- begin #content -->
	<div id="content" class="content">
		<!-- begin breadcrumb -->
		<ol class="breadcrumb pull-right">
			<li>Home</li>
			<li><a href="/dashboard.php">Dashboard</a></li>
			<li><a href="/contacts.php">Contacts</a></li>
			<li class="active">New</li>
		</ol>
		<!-- end breadcrumb -->
		<!-- begin page-header -->
		<h1 class="page-header">My Profile <small>Edit</small></h1>
		<!-- end page-header -->

        <!-- begin panel -->

		<form id="form-edit-profile" action="/my_profile_edit.php" method="POST">
			<input type="hidden" name="user_id" value="{$user.user_id}"/>

	        <div class="panel panel-inverse" data-sortable-id="new-contacts">
	            <div class="panel-heading">
	                <h4 class="panel-title">User Details</h4>
	            </div>
	            <div class="panel-body">
					<fieldset>
						<div class="row">
							<div class="col-md-2">
					            <div class="profile-image">
					                <img src="{$profile_url}" />
					                <i class="fa fa-user hide"></i>
					            </div>
					            <div class="m-b-10">
					                <a href="#modal-upload" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Upload Profile Photo</a>
					            </div>
							</div>
							<div class="col-md-4">
	                            <div class="form-group">
	                                <label for="event_subject">First Name</label>
	                                <input type="text" class="form-control" value="{$user.first_name}" name="first_name" id="first_name" placeholder="John" />
	                            </div>

	                            <div class="form-group">
	                                <label for="event_subject">Last Name</label>
	                                <input type="text" class="form-control" value="{$user.last_name}" name="last_name" id="last_name" placeholder="Doe" />
	                            </div>

	                            <div class="form-group">
	                                <label for="event_subject">Email</label>
	                                <input type="text" class="form-control" name="email" id="email" value="{$user.email}" placeholder="fetu@ccini.com" />
	                            </div>
							</div>
							<div class="col-md-3">
	                            <div class="form-group">
	                                <label for="event_subject">Phone (office)</label>
	                                <input type="text" class="form-control phone-us" name="phone_office" id="phone_office" value="{$user.phone_office}" placeholder="(000) 000-0000" />
	                            </div>

	                            <div class="form-group">
	                                <label for="event_subject">Phone (mobile)</label>
	                                <input type="text" class="form-control phone-us" name="phone_mobile" id="phone_mobile" value="{$user.phone_mobile}" placeholder="(000) 000-0000" />
	                            </div>

	                            <div class="form-group">
	                                <label for="event_subject">Phone (fax)</label>
	                                <input type="text" class="form-control phone-us" name="phone_fax" id="phone_fax" value="{$user.phone_fax}" placeholder="(000) 000-0000" />
	                            </div>
							</div>
							<div class="col-md-3">
								<div class="form-group">
	                                <label for="event_subject">City</label>
	                                <input type="text" class="form-control" name="city" id="city" placeholder="City" value="{$user.city}" />
	                            </div>
								<div class="form-group">
	                                <label for="event_subject">State</label>
									<select class="form-control" name="state" id="state">
										<option value="">--</option>
										{include file="includes/states.tpl"}
									</select>
	                            </div>
								<div class="form-group">
	                                <label for="event_subject">Zip</label>
	                                <input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" value="{$user.zip}"/>
	                            </div>
							</div>
							<div class="col-md-7">
								<div class="form-group">
	                                <label for="event_subject">Street Address</label>
	                                <input type="text" class="form-control" name="street_address" id="street_address" value="{$user.street_address}" placeholder="00 ABC Street" />
	                            </div>
							</div>
							<div class="col-md-3">
	                            <div class="form-group">
	                                <label for="event_subject">Realtor License #</label>
	                                <input type="text" class="form-control" value="{$user.realtor_license_num}" name="realtor_license_num" id="realtor_license_num" placeholder="Realtor License #" />
	                            </div>
							</div>
						</div>

						<!-- <div class="row">
							<div class="col-md-3">
					            <div class="m-b-10">
					                <a href="#modal-pic-url" class="btn btn-warning btn-block btn-sm" data-toggle="modal">Picture Url</a>
					            </div>
							</div>
							<div class="col-md-9">
								<div class="form-group">
	                                <label for="event_subject">Street Address</label>
	                                <input type="text" class="form-control" name="street_address" id="street_address" value="{$user.street_address}" placeholder="00 ABC Street" />
	                            </div>
							</div>
						</div> -->

						<!-- <div class="row">
							<div class="col-md-3 col-md-offset-3">
								<div class="form-group">
	                                <label for="event_subject">City</label>
	                                <input type="text" class="form-control" name="city" id="city" placeholder="City" value="{$user.city}" />
	                            </div>
							</div>
							<div class="col-md-3">
								<div class="form-group">
	                                <label for="event_subject">State</label>
									<select class="form-control" name="state" id="state">
										<option value="">--</option>
										{include file="includes/states.tpl"}
									</select>
	                            </div>
							</div>
							<div class="col-md-3">
								<div class="form-group">
	                                <label for="event_subject">Zip</label>
	                                <input type="text" class="form-control" name="zip" id="zip" placeholder="Zip Code" value="{$user.zip}"/>
	                            </div>
							</div>
						</div> -->
						
						<div class="row">
							<div class="col-md-12">
								<legend class="m-b-15">Vehicle</legend>
								<div class="row">
									<div class="col-md-3">
										<div class="form-group">
											<label for="event_subject">Make</label>
											<input type="text" class="form-control" name="car_make" id="car_make" placeholder="Make" value="{$user.car_make}" />
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="event_subject">Model</label>
											<input type="text" class="form-control" name="car_model" id="car_model" placeholder="Model" value="{$user.car_model}"/>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="event_subject">Year</label>
											<input type="text" class="form-control" name="car_year" id="car_year" placeholder="Year" value="{$user.car_year}"/>
										</div>
									</div>
									<div class="col-md-3">
										<div class="form-group">
											<label for="event_subject">License Plate No.</label>
											<input type="text" class="form-control" name="car_license_num" id="car_license_num" placeholder="License Plate" value="{$user.car_license_num}"/>
										</div>
									</div>
								</div>
							</div>
						</div>

						<div class="row m-t-20">
							<div class="col-md-12">
	                            <div class="form-group">
	                                <label for="event_subject">Bio</label>
	                                <div id="summernote">{$user.bio}</div>
	                                <textarea class="form-control" id="bio" style="display:none" placeholder="about yourself" name="bio">{$user.bio}</textarea>
	                            </div>
							</div>
						</div>

						<div class="row">
							<div class="col-md-3">
	                            <div class="form-group">
	                                <label for="event_subject">Agent Website</label>
	                                <input type="text" class="form-control" value="{$user.url_website}" name="url_website" id="url_website" placeholder="Agent Website" />
	                            </div>
							</div>
							<div class="col-md-3">
	                            <div class="form-group">
	                                <label for="event_subject">Profile Photo Url</label>
	                                <input type="text" class="form-control" value="{$user.url_profile_photo}" name="url_profile_photo" id="url_profile_photo" placeholder="twitter.com/pictureofme.jpg" />
	                            </div>
							</div>
							<div class="col-md-3">
	                            <div class="form-group">
	                                <label for="event_subject">Twitter</label>
	                                <input type="text" class="form-control" value="{$user.url_twitter}" name="url_twitter" id="url_twitter" placeholder="twitter.com/tweetums" />
	                            </div>
							</div>
							<div class="col-md-3">
	                            <div class="form-group">
	                                <label for="event_subject">Facebook</label>
	                                <input type="text" class="form-control" value="{$user.url_facebook}" name="url_facebook" id="url_facebook" placeholder="facebook.com/myprofile" />
	                            </div>
							</div>
						</div>

						<hr>

						<div class="row">
							<div class="col-md-6 info-toggle-box">
								<div class="panel panel-inverse">
			                        <div class="panel-heading">
			                            <div class="panel-title form-group" style="margin-bottom:0;">
			                                <label for="accept_referral" class="text-white" style="margin-right:10px;">Accept Referrals from Outside of my Company?</label>
											<input type="checkbox" id="accept_referral" name="accepting_outside_referral" data-toggle="toggle"  data-on="Yes" data-off="No" data-onstyle="success" data-offstyle="danger" {if $user.is_accepting_outside_referral eq 1}checked{/if}>
			                            </div>
			                        </div>
			                        <div class="panel-body bg-black text-white">
										<p>Choosing to accept referrals from outside of your company will allow other agents to find you if they have a referral they are unable to show a home to or has a buyer they're unable to service at the time. This will allow that agent to easily find a colleague close to their client who is open to a referral.</p>
			                        </div>
			                    </div>
							</div>
						</div>

					</fieldset>
					
					<button id="save-profile" type="submit" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-floppy-o"></i>Save Profile Details</button>

	            </div>

	        </div>
		</form>
        <!-- end panel -->

        <!-- begin panel -->
        <div class="panel panel-inverse" data-sortable-id="new-contacts">
            <div class="panel-heading">
                <h4 class="panel-title">Email Header Photo</h4>
            </div>
            <div class="panel-body">

                <div class="row">
                    <div class="col-md-12">
                        <!-- <label>Company Email Header Photo</label> -->
                        <div class="profile-image">
                            {if $user.url_email_logo ne ''}
                                <img src="{$user.url_email_logo}" />
                            {else}
                                <h3 style="margin: 10px 0;">Email Header Photo Not Set</h3>
                            {/if}
                        </div>
                        <div class="m-b-10">
					        <a href="#modal-upload-email-header" class="btn btn-success btn-block btn-sm" data-toggle="modal">Upload Email Header Photo</a>
                        </div>
                    </div>
                </div>
                
            </div>
        </div>
        <!-- end panel -->
	</div>
	<!-- end #content -->

	<div class="modal fade" id="modal-upload" style="display: none;">
	    <div class="modal-dialog" style="max-width: 300px;">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	                <h4 class="modal-title">Upload Profile Photo</h4>
	            </div>
	            <div class="modal-body">
	                <div id="dropzone" class="text-center">
	                    <form id="my-dropzone" action="/services/upload_profile_picture.php" class="dropzone needsclick dz-clickable">
	                        <div class="dz-message needsclick">
	                            Drop files here or click to upload.<br>

	                            <div class="fallback">
	                                <input name="file" type="file" />
	                            </div>
	                        </div>
	                    </form>
	                </div>
	            </div>
	            <div class="modal-footer">
	                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
	                <a href="#" id="upload-image" data-dz-remove class="btn btn-sm btn-success">Upload image</a>
	            </div>
	        </div>
	    </div>
	</div>

	<div class="modal fade" id="modal-upload-email-header" style="display: none;">
	    <div class="modal-dialog" style="max-width: 300px;">
	        <div class="modal-content">
	            <div class="modal-header">
	                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
	                <h4 class="modal-title">Upload Email Header Photo</h4>
	            </div>
	            <div class="modal-body">
	                <div class="text-center">
	                    <form id="email-header" action="/services/user_email_header_photo.php" class="dropzone">
	                        <div class="dz-message">
	                            Drop files here or click to upload.<br>

	                            <div class="fallback">
	                                <input name="file" type="file" />
	                            </div>
	                        </div>
	                    </form>
	                </div>
	            </div>
	            <div class="modal-footer">
	                <a href="javascript:;" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
	                <a href="#" id="upload-email-header" data-dz-remove class="btn btn-sm btn-success">Upload image</a>
	            </div>
	        </div>
	    </div>
	</div>
		
	<script src="assets/plugins/summernote/summernote.min.js" defer></script>
	<script src="assets/plugins/bootstrap-toggle/js/bootstrap-toggle.min.js" defer></script>

	<script type="text/javascript">
		defer(deferred_method);

        function defer(method){
            if (window.jQuery)
                method();
            else
                setTimeout(function() { defer(method) }, 500);
        }

        function deferred_method() {

        	// $(".info-toggle-box").sortable("disable");

        	$('#summernote').summernote({
        		placeholder: 'Hi, tell us something about yourself',
        		height: "300px"
        	});

        	$('#summernote').on('summernote.change', function(we, contents, $editable) {
				$("#bio").html(contents);
			});

			$('#save-profile').click(function(){
				console.log("help");
				$("#form-edit-profile").submit();
			});

			$('#state').val('{$user.state}');

			$('#accept_referral').on('change', function() {
				var x = ($(this).attr("checked")) ? 1 : 0;
				$(this).val(x);
			});

        }

	</script>

{include file="includes/footer.tpl"}