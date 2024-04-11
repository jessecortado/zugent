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
			<h1 class="page-header">{$contact_data.first_name} {$contact_data.last_name}<small>{$campaign_data.campaign_name}</small></h1>
			<!-- end page-header -->

			<!-- begin row -->
			<div class="row">

			    <div class="col-md-12 col-sm-12">

			        <!-- begin panel -->
	                <div class="panel panel-inverse" data-sortable-id="new-contacts">
	                    <div class="panel-heading">
	                        <h4 class="panel-title">{$contact_data.first_name}'s Campaign History</h4>
	                    </div>
	                    <div class="panel-body">
	                        <table class="table table-striped">
	                            <thead>
	                                <tr>
                                        <th>#</th>
                                        <th>Date Sent</th>
                                        <th>Event Name</th>
                                        <th>Opened</th>
	                                </tr>
	                            </thead>
	                            <tbody>
									{foreach from=$history item="data"}
		                                <tr>
		                                    <td>{$data.campaign_event_contact_id}</td>
											<td>{$data.date_sent|date_format}</td>
		                                    <td><a href="/campaign_edit_event.php?id={$data.campaign_event_id}">{$data.event_name}</a></td>
		                                    <td>{if $data.is_opened}{$data.date_opened|date_format}{/if}</td>
		                                </tr>
									{foreachelse}
										<tr><td colspan="8">There have been no captured events.</td></tr>
									{/foreach}
	                            </tbody>
	                        </table>
	                    </div>
	                </div>
	                <!-- end panel -->



			    </div>
			</div>
		<!-- end #row -->



		</div>
		<!-- end #content -->
		
{include file="includes/footer.tpl"}