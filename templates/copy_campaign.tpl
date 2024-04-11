{include file="includes/header.tpl"}
<!-- begin #content -->
<div id="content" class="content">
			<!-- begin breadcrumb -->
			<ol class="breadcrumb hidden-print pull-right">
				<li><a href="/dashboard.php">Home</a></li>
				<li><a href="/campaign_catalogue.php">Campaign Catalogue</a></li>
				<li class="active">Confirmation</li>
			</ol>
			<!-- end breadcrumb -->
			<div class="pull-left m-r-15">
				<a class="btn btn-sm btn-success" href="/campaign_list.php">Back to List</a>
			</div>
			<!-- begin page-header -->
			<h1 class="page-header hidden-print"> <small>Confirm Copy</small></h1>
			<!-- end page-header -->
			
			<!-- begin invoice -->
			<div class="invoice">
                <div class="invoice-company">
                    {$data.company_name} Campaigns
                </div>
                <div class="invoice-header">
                    <div class="invoice-from">
                        <address class="m-t-5 m-b-5">
                            <strong>Campaign Details</strong>
                        </address>
                    </div>
                    <div class="invoice-to">
                        <!-- <small>to</small>
                        <address class="m-t-5 m-b-5">
                            <strong>Company Name</strong><br>
                            Street Address<br>
                            City, Zip Code<br>
                            Phone: (123) 456-7890<br>
                            Fax: (123) 456-7890
                        </address> -->
                    </div>
                    <div class="invoice-date">
                        <div class="date m-t-5">August 3,2012</div>
                    </div>
                </div>
                <div class="invoice-content">
                    <div class="table-responsive">
                        <table class="table table-invoice">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Campaign Name</th>
                                    <th>Max Send After Days</th>
                                    <th># of Events</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr>
                                    <td>
                                        {$data.campaign_id}
                                    </td>
                                    <td>{$data.campaign_name}</td>
                                    <td>{$data.max}</td>
                                    <td>{$data.events_count}</td>
                                </tr>
                                <tr>
                                	<td colspan="4">
                                		{$data.description}
                                	</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
	                <div class="text-center p-t-20">
                        <form id="frm-confirm-copy" action="copy_campaign.php" method="post">
                            <input type="hidden" value="{$id}" name="id">
                            <button type="submit" class="btn btn-success" id="confirm" data-toggle="confirmation">Confirm Copy</button>
                            <a class="btn btn-danger" href="/campaign_catalogue.php">Cancel</a>
                        </form>

	                </div>
                </div>
                <!-- <div class="invoice-note">
                    * Make all cheques payable to [Your Company Name]<br>
                    * Payment is due within 30 days<br>
                    * If you have any questions concerning this invoice, contact  [Name, Phone Number, Email]
                </div>
                <div class="invoice-footer text-muted">
                    <p class="text-center m-b-5">
                        THANK YOU FOR YOUR BUSINESS
                    </p>
                    <p class="text-center">
                        <span class="m-r-10"><i class="fa fa-globe"></i> matiasgallipoli.com</span>
                        <span class="m-r-10"><i class="fa fa-phone"></i> T:016-18192302</span>
                        <span class="m-r-10"><i class="fa fa-envelope"></i> rtiemps@gmail.com</span>
                    </p>
                </div> -->
            </div>
			<!-- end invoice -->
		</div>
<!-- end #content -->


<script type="text/javascript">
defer(deferred_method);


function defer(method){
	if (window.jQuery)
		method();
	else
		setTimeout(function() { defer(method) }, 150);
}

function deferred_method(){

    Confirm_Copy_Campaign.init({$data.campaign_id});

}

</script>


{include file="includes/footer.tpl"}