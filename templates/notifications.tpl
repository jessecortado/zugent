{include file="includes/header.tpl"}

<link href="assets/plugins/bootstrap3-editable/css/bootstrap-editable.css" rel="stylesheet" />

<style type="text/css">
  .timeline-buttons a {
    -webkit-box-shadow: 0 2px 5px 0 rgba(0,0,0,.16), 0 2px 10px 0 rgba(0,0,0,.12);
    box-shadow: 0 2px 5px 0 rgba(0,0,0,.16), 0 2px 10px 0 rgba(0,0,0,.12);
  }
  .agent-profile img {
    border-radius: 50%;
    border: 3px solid #00acac;
    padding: 3px;
    margin: 0 auto;
    width: 120px;
    display: block;
  }
</style>

<!-- begin #content -->
<div id="content" class="content">

  <!-- start breadcrumb -->
  <h1 class="page-header">{$company.company_name} 
      <ol class="breadcrumb" style="display:inline-block;font-size:12px;">
          <li class="active">Notifications</li>
      </ol>
  </h1>
  <!-- end breadcrumb -->
    
  <div id="message"></div>

  <div class="col-lg-10 col-lg-offset-1 col-md-12 col-sm-12">
    <div class="row">
      <ul class="timeline">
        {foreach item=row from=$notifs}
        <li>
          <!-- begin timeline-time -->
          <div class="timeline-time">
            <span class="time">{$row.date_created|date_format}</span>
          </div>
          <!-- end timeline-time -->
          <!-- begin timeline-icon -->
          <div class="timeline-icon">
            <a href="javascript:;"><i class="fa fa-paper-plane"></i></a>
          </div>
          <!-- end timeline-icon -->
          <!-- begin timeline-body -->
          <div class="timeline-body" style="margin-right:0px;">
            <figure>
              <img height="140" src="assets/img/client-card.jpg" />
              <div class="timeline-content">
                {if $row.title ne ''}<h2>{$row.title} </h2>{/if}
                <p>
                  {$row.notification}
                </p>
              </div>
              <div class="timeline-image"><img src="assets/img/client-card.jpg"/></div>
              <div class="timeline-footer">
                <div class="icons">
                  {if $row.url_action ne ''}<a href="javascript:;" data-toggle="tooltip" title="Perform Actions" class="orange-tooltip"><i class="fa fa-eye"></i></a>{/if}
                </div>
                
            <span>{$row.unixtime_created|time_ago|ucfirst}</span>
              </div>
            </figure>
          </div>
          <!-- end timeline-body -->
        </li>
        {/foreach}
      </ul>
    </div>
  </div>

</div>
<!-- end #content -->

{include file="includes/footer.tpl" footer_js="includes/footers/notifications_footer.tpl" company_settings_keyval="1"}


