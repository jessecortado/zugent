{include file="includes/header.tpl"}
		
		<!-- begin #content -->
		<div id="content" class="content">
			<!-- begin breadcrumb -->
			<ol class="breadcrumb pull-right">
				<li>Home</li>
				<li><a href="/dashboard.php">Dashboard</a></li>
				<li class="active">Campaigns</li>
			</ol>
			<!-- end breadcrumb -->
			<!-- begin page-header -->
			<h1 class="page-header">Campaigns <small>List</small></h1>
			<!-- end page-header -->


			<!-- begin row -->
			<div class="row">

			    <div class="col-lg-6 col-md-6 col-sm-12">

			        <!-- begin panel -->
	                <div class="panel panel-inverse">
	                    <div class="panel-heading">
	                        <h4 class="panel-title">Create a new Campaign</h4>
	                    </div>
	                    <div class="panel-body">

							<form class="form-horizontal" action="campaign_new.php" method="post" data-parsley-validate="true">
								<div class="form-group">
									<label class="col-md-3 col-sm-5 col-xs-7 control-label">Campaign Name</label>
									<div class="col-md-9 col-sm-7 col-xs-5">
										<input type="text" name="campaign_name" id="campaign_name" class="form-control" placeholder="Campaign Name" data-parsley-required="true"/>
									</div>
	
									<div style="padding-top: 20px;" class="col-md-9 col-md-offset-3"><button type="submit" class="btn btn-sm btn-success"><i class="fa fa-save"></i> Create New Campaign</button></div>
								</div>							
							</form>
	                    </div>
	                </div>
	                <!-- end panel -->

			    </div>
			</div>
		<!-- end #row -->

		</div>
		<!-- end #content -->
		
{include file="includes/footer.tpl"}