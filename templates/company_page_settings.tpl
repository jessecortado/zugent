{include file="includes/header.tpl"}

<link href="assets/test_temp/menu_plugin/menu_styles.css" rel="stylesheet" />

<style type="text/css">
  .custom-pages-list {
    display: block;
    font-size: 16px;
    padding: 8px;
    color: #000;
    font-weight: bold;
  }
  .custom-pages-list .actions {
    display: inline-block;
    float: right;
    font-size: 12px;
    margin-top: -1px;
  }
</style>

<!-- begin #content -->
<div id="content" class="content">

  <div id="alert_error" class="alert alert-danger hide fade in m-b-15">
    <strong>Permission Denied!</strong>
    You don't have permission to access the requested process.
    <span class="close" data-dismiss="alert">×</span>
  </div>

  <!-- begin breadcrumb -->
  <ol class="breadcrumb pull-right">
    <li><a href="javascript:;">Home</a></li>
    <li><a href="settings.php">Settings</a></li>
    <li class="active">Page Settings</li>
  </ol>
  <!-- end breadcrumb -->

  <!-- begin page-header -->
  <h1 class="page-header">Page Settings <small>Company Pages</small></h1>
  <!-- end page-header -->

  <ul class="nav nav-pills">
    <li class="active">
      <a href="#nav-pills-tab-1" data-toggle="tab">
        <i class="fa fa-gears m-r-5"></i>
        <span class="hidden-xs">General Settings</span>
      </a>
    </li>
    <li>
      <a href="#nav-pills-tab-2" data-toggle="tab">
        <i class="fa fa-list m-r-5"></i>
        <span class="hidden-xs">Menu</span>
      </a>
    </li>
    <li>
      <a href="#nav-pills-tab-3" data-toggle="tab">
        <i class="fa fa-desktop m-r-5"></i>
        <span class="hidden-xs">Pages</span>
      </a>
    </li>
  </ul>

  <div class="tab-content p-0">
    <div class="tab-pane fade active in" id="nav-pills-tab-1">
      <div class="panel panel-inverse" data-sortable-id="form-stuff-1" style="">
        <div class="panel-heading">
          <h4 class="panel-title">General Settings</h4>
        </div>
        <div id="alert_success_setting" class="alert alert-success hide fade in flash">
          <strong>Success!</strong>
          <span id="msg"></span>
          <span class="close" data-dismiss="alert">×</span>
        </div>
        <div class="panel-body">
          <form id="form-general-settings" data-parsley-validate="true">
            <input type="hidden" name="action" value="allcol">
            <!-- Company Logo -->
            <div class="row">
              <div class="col-md-12">
                <div class="form-group">
                  <label>Company Logo</label>
                  <input type="text" class="form-control" name="logo" placeholder="Company Logo" value="{if $company_settings|count ne 0}{$company_settings.logo}{/if}">
                  <p>Recommended Size: 90x90</p>
                </div>
              </div>
            </div>
            <legend></legend>
            <!-- Company Site URL -->
            <div class="row">
              <div class="col-md-12">
                <div class="form-group">
                  <label>Company Site Address (URL)</label>
                  <div class="input-group">
                    <input type="text" class="form-control" placeholder="Company Site Address" name="site_address" value="{if $company_settings|count ne 0}{$company_settings.site_address}{/if}" aria-describedby="site-add" data-parsley-required="true">
                    <span class="input-group-addon" id="site-add">.crm.ruopen.com</span>
                  </div>
                </div>
              </div>
            </div>
            <legend></legend>
            <!-- Company Social Links -->
            <div class="row">
              <div class="col-md-6">
                <div class="form-group">
                  <label>Facebook Profile Link</label>
                  <div class="input-group">
                    <span class="input-group-addon" id="basic-addon1">https://www.facebook.com/</span>
                    <input type="text" class="form-control" name="facebook" placeholder="Company Facebook" value="{if $company_settings|count ne 0}{$company_settings.facebook}{/if}" aria-describedby="basic-addon1">
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label>Twitter Profile Link</label>
                  <div class="input-group">
                    <span class="input-group-addon" id="basic-addon2">https://twitter.com/</span>
                    <input type="text" class="form-control" name="twitter" placeholder="Company Twitter" value="{if $company_settings|count ne 0}{$company_settings.twitter}{/if}" aria-describedby="basic-addon2">
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label>Gmail Profile Link</label>
                  <div class="input-group">
                    <span class="input-group-addon" id="basic-addon3">https://plus.google.com/u/0/</span>
                    <input type="text" class="form-control" name="gmail" placeholder="Company Gmail" value="{if $company_settings|count ne 0}{$company_settings.gmail}{/if}" aria-describedby="basic-addon3">
                  </div>
                </div>
              </div>
              <div class="col-md-6">
                <div class="form-group">
                  <label>Instagram Profile Link</label>
                  <div class="input-group">
                    <span class="input-group-addon" id="basic-addon4">https://www.instagram.com/</span>
                    <input type="text" class="form-control" name="instagram" placeholder="Company Instagram" value="{if $company_settings|count ne 0}{$company_settings.instagram}{/if}" aria-describedby="basic-addon4">
                  </div>
                </div>
              </div>
            </div>
            <legend></legend>
            <!-- About Us -->
            <div class="row">
              <div class="col-md-12">
                <div class="form-group">
                  <label>About Us</label>
                  <textarea type="text" class="form-control" name="about_us" placeholder="About Us">{if $company_settings|count ne 0}{$company_settings.about_us}{/if}</textarea>
                </div>
              </div>
            </div>
            <legend></legend>
            <!-- Footer Line Text -->
            <div class="row">
              <div class="col-md-12">
                <div class="form-group">
                  <label>Footer Line Text (Copyright)</label>
                  <input type="text" class="form-control" name="footer_line" placeholder="Footer Line Text" value="{if $company_settings|count ne 0}{$company_settings.footer_line}{/if}">
                </div>
              </div>
            </div>
          </form>
          
          <button id="btn-save-settings" class="btn btn-sm btn-primary m-r-5"><i class="fa fa-save"></i> Save Settings</button>
        </div>
      </div>
    </div>
    <div class="tab-pane fade" id="nav-pills-tab-2">
      <div class="panel panel-inverse" data-sortable-id="form-stuff-1" style="">
        <div class="panel-heading">
          <h4 class="panel-title">Edit Menu</h4>
        </div>
        <div class="panel-body p-3" style="position: relative;">
        
          <div class="sidebar-nav">
            <div data-scrollbar="true" data-height="100%">

            <div class="panel-group" id="accordion">
              <div class="panel panel-inverse bg-green m-0">
                <div class="panel-heading bg-green-darker" style="border-radius: 0;">
                  <h3 class="panel-title">
                    <a class="accordion-toggle accordion-toggle-styled collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                      <i class="fa fa-plus-circle pull-right"></i> 
                      Custom Pages
                    </a>
                  </h3>
                </div>
                <div id="collapseOne" class="panel-collapse collapse in">
                  <div class="panel-body p-0" style="border-top: none;">
                    <!-- <h4 style="color:black;margin: auto 15%;">Underdevelopment...</h4> -->
                    <div data-scrollbar="true" data-height="100%">
                      {foreach item=row from=$custom_pages}
                      <div class="custom-pages-list">
                        {$row.page_name}
                        <div class="actions">
                          <button type="button" class="btn btn-xs btn-inverse add-custom-page" data-page-name="{$row.page_name|lower}"><i class="fa fa-plus"></i> Add</button>
                        </div>
                      </div>
                      {/foreach}
                    </div>
                  </div>
                </div>
              </div>
              <div class="panel panel-inverse bg-green m-0">
                <div class="panel-heading bg-green-darker" style="border-radius: 0;">
                  <h3 class="panel-title">
                    <a class="accordion-toggle accordion-toggle-styled ui-sortable collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                      <i class="fa fa-plus-circle pull-right"></i> 
                      Custom Links
                    </a>
                  </h3>
                </div>
                <div id="collapseTwo" class="panel-collapse ui-sortable collapse" style="height: 0px;">
                  <div class="panel-body p-0" style="border-top: none; padding: 3px;">
                    <div class="col-md-12 p-t-15">
                    <form class="form-horizontal" id="frmcustom-link">
                      <fieldset>
                        <div class="form-group">
                          <label class="col-md-4 control-label">URL</label>
                          <div class="col-md-8">
                            <input type="text" class="form-control" placeholder="Enter URL" id="url" value="http://" autocomplete="off">
                          </div>
                        </div>
                        <div class="form-group">
                          <label class="col-md-4 control-label">Link Text</label>
                          <div class="col-md-8">
                            <input type="text" class="form-control" placeholder="Enter Link Text" id="link-text" autocomplete="off">
                          </div>
                        </div>
                        <div class="form-group">
                          <div class="text-right">
                            <a id="add-to-menu" class="btn btn-sm btn-warning m-r-15"><i class="fa fa-plus"></i> Add to Menu</a>
                          </div>
                        </div>
                      </fieldset>
                    </form>
                    </div>
                  </div>
                </div>
              </div>
            </div>

            </div>
          </div>

          <div id="menu-html">
            <h3 class="m-t-0">Menu Structure</h3>
            <p id="item-added">Click the gear icon on the right of the item to reveal additional configuration options.</p>
            <p id="no-item-added">Add menu items from the column on the left.</p>
            <div class="dd">
              <ol class="dd-list">
                {if $parent_menu ne ''}
                {foreach item=parent from=$parent_menu}
                  <li class="dd-item" data-id="{$parent.menu_id}" data-custompage="{$parent.is_custom_page}" data-type="menu-page">
                    <a class="dd-handle" href="{$parent.menu_link}">{$parent.menu_label}</a>
                    <a href="javascript:;" class="menu-setup"><i class="fa fa-gear"></i></a>
                    <a href="javascript:;" class="menu-remove"><i class="fa fa-times"></i></a>
                    {if $parent.has_child eq '1'}
                    <ol class="dd-list">

                    {foreach item=child from=$child_menu}
                      {if $child.parent_id eq $parent.menu_id}
                      <li class="dd-item" data-id="{$child.menu_id}" data-custompage="{$parent.is_custom_page}" data-type="menu-page">
                        <a class="dd-handle" href="{$child.menu_link}">{$child.menu_label}</a>
                        <a href="javascript:;" class="menu-setup"><i class="fa fa-gear"></i></a>
                        <a href="javascript:;" class="menu-remove"><i class="fa fa-times"></i></a>
                      </li>
                      {/if}
                    {/foreach}

                    </ol>
                    {/if}
                  </li>
                {/foreach}
                {/if}

                <!-- <li class="dd-item" data-id="{$row.menu_id}" data-type="menu-page">
                  <a class="dd-handle" href="{$row.menu_link}">{$row.menu_label}</a>
                  <a href="javascript:;" class="menu-setup"><i class="fa fa-gear"></i></a>
                  <a href="javascript:;" class="menu-remove"><i class="fa fa-times"></i></a>
                </li> -->

              </ol>
            </div>
          </div>

          <div id="menu-html-save">
            <div id="alert_success_menu" class="alert alert-success fade in hide flash" style="border-radius:0;text-align:left;margin-bottom:6px;">
              <strong>Success!</strong>
              <span id="msg"></span>
              <span class="close" data-dismiss="alert">×</span>
            </div>
            
            <div id="alert_error_menu" class="alert alert-danger fade in hide flash" style="border-radius:0;text-align:left;margin-bottom:6px;">
              <strong>Error!</strong>
              <span>Something went wrong! Please contact customer support.</span>
              <span class="close" data-dismiss="alert">×</span>
            </div>
            
            <div id="alert_validate_menu" class="alert alert-warning fade in hide flash" style="border-radius:0;text-align:left;margin-bottom:6px;">
              <strong>Empty!</strong>
              <span>No item added. Please add items from the column on the left.</span>
              <span class="close" data-dismiss="alert">×</span>
            </div>

            <a href="javascript:;" id="save-company-menu" class="btn btn-primary"><i class="fa fa-save"></i> Save Menu</a>
          </div>
          
        </div>
      </div>
    </div>
    <div class="tab-pane fade" id="nav-pills-tab-3">
      <div class="panel panel-inverse" data-sortable-id="form-stuff-1" style="">
        <div class="panel-heading">
          <div class="panel-heading-btn">
            <a id="add-page" href="#modal-add-page" data-toggle="modal" class="btn btn-xs btn-success" style="margin-top: -1px;"><i class="fa fa-plus"></i>Add Page</a>
          </div>
          <h4 class="panel-title">Pages</h4>
        </div>
        <div class="panel-body">
          <div class="row">
            <div class="col-md-4 col-xs-12">
              <div class="widget widget-stats bg-green">
                <div class="stats-icon" style="top:4px"><i class="fa fa-globe"></i></div>
                <div class="stats-info">
                  <p>Home Page</p>  
                </div>
                <div class="stats-link">
                  <a href="http://{$company_settings.site_address}.{$smarty.server.HTTP_HOST}">Visit Home Page <i class="fa fa-globe"></i></a>
                  <a href="company_edit_page.php?page=home&edit=1">Edit Home Page <i class="fa fa-pencil"></i></a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xs-12">
              <div class="widget widget-stats bg-green">
                <div class="stats-icon" style="top:3px"><i class="fa fa-search"></i></div>
                <div class="stats-info">
                  <p>Search Page</p>  
                </div>
                <div class="stats-link">
                  <a href="http://{$company_settings.site_address}.{$smarty.server.HTTP_HOST}/search">Visit Search Page <i class="fa fa-globe"></i></a>
                  <!-- <a href="company_edit_page.php?page=search&edit=1">Edit Search Page <i class="fa fa-pencil"></i></a> -->
                  <a href="javascript:;">Edit Search Page <i class="fa fa-pencil"></i></a>
                </div>
              </div>
            </div>
            <div class="col-md-4 col-xs-12">
              <div class="widget widget-stats bg-green">
                <div class="stats-icon" style="top:6px"><i class="fa fa-list-alt"></i></div>
                <div class="stats-info">
                  <p>Details Page</p>
                </div>
                <div class="stats-link">
                  <a href="http://{$company_settings.site_address}.{$smarty.server.HTTP_HOST}/details">Visit Details Page <i class="fa fa-globe"></i></a>
                  <!-- <a href="company_edit_page.php?page=details&edit=1">Edit Details Page <i class="fa fa-pencil"></i></a> -->
                  <a href="javascript:;">Edit Details Page <i class="fa fa-pencil"></i></a>
                </div>
              </div>
            </div>
          </div>
          <legend></legend>

          <div id="customPages">
            <div class="row">
              {foreach item=row from=$custom_pages}
              <div class="col-md-4 col-xs-12">
                <div class="widget widget-stats bg-green">
                  <div class="stats-icon" style="top:6px"><i class="fa fa-file-text"></i></div>
                  <div class="stats-info">
                    <p>{$row.page_name} Page</p>
                  </div>
                  <div class="stats-link">
                    <a href="http://{$company_settings.site_address}.{$smarty.server.HTTP_HOST}/{$row.page_name|lower}">Visit {$row.page_name} Page <i class="fa fa-globe"></i></a>
                    <a href="company_edit_page.php?page={$row.page_name|lower}&edit=1">Edit {$row.page_name} Page <i class="fa fa-pencil"></i></a>
                    <a href="javascript:;" class="remove-custom-page" data-page-id="{$row.page_id}" data-page-name="{$row.page_name}">Remove Page <i class="fa fa-times"></i></a>
                  </div>
                </div>
              </div>
              {/foreach}
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>

</div>
<!-- end #content -->


<!-- MODAL SETTINGS -->
<div class="modal fade" id="preferences" aria-hidden="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> 
        <h4 class="modal-title" id="preferencesTitle">Menu Link Settings</h4>
      </div>
      <div class="modal-body" id="preferencesContent">

        <div id="thepref">
          <div class="tab-content m-b-0">
            <div role="tabpanel" class="tab-pane active" id="Settings">
              <div class="panel panel-body p-0 m-b-0">

                <div id="menu-page" style="display:none">
                  <div class="row">
                    <div class="col-md-12">
                      <div class="form-group"> <label for="img-url">Url :</label> <input type="text" value="" id="btn-url" class="form-control" /> </div>
                      <div class="form-group"> <label for="img-title">Link Text : </label> <input type="text" value="" id="btn-link-text" class="form-control"/> </div>
                    </div>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>

      </div>

      <div id="alert_error" class="alert alert-danger fade in hide flash" style="border-radius: 0;margin-bottom: 0;">
        <strong>Error!</strong>
        <span>Something went wrong! Please contact customer support.</span>
        <span class="close" data-dismiss="alert">×</span>
      </div>

      <div id="alert_success" class="alert alert-success fade in hide flash" style="border-radius: 0;margin-bottom: 0;">
        <strong>Success!</strong>
        <span id="msg"></span>
        <span class="close" data-dismiss="alert">×</span>
      </div>

      <div class="modal-footer">
        <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
        <a href="javascript:void(0)" class="btn btn-sm btn-success" id="applyChanges"><i class='fa fa-check'></i> Apply changes</a>
      </div>
    </div>
  </div>
</div>

<!-- ADD MODAL PAGE -->
<div class="modal fade" id="modal-add-page" aria-hidden="false">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> 
        <h4 class="modal-title" id="newpageTitle">Add New Page</h4>
      </div>
      <div class="modal-body">

        <form id="newpageContent" data-parsley-validate="true">
          <div class="row">
            <div class="col-md-12">
              <div class="form-group"> <label for="img-url">Page Title :</label> <input type="text" value="" name="page_name" class="form-control"  data-parsley-required="true"/> </div>
            </div>
            <div class="col-md-12">
              <div class="form-group"> <label for="img-url">URL :</label> <input type="text" value="" name="page_url" class="form-control"  data-parsley-required="true"/> </div>
            </div>
          </div>
        </form>

      </div>

      <div id="alert_error" class="alert alert-danger fade in hide flash" style="border-radius: 0;margin-bottom: 0;">
        <strong>Error!</strong>
        <span>Something went wrong! Please contact customer support.</span>
        <span class="close" data-dismiss="alert">×</span>
      </div>

      <div id="alert_success" class="alert alert-success fade in hide flash" style="border-radius: 0;margin-bottom: 0;">
        <strong>Success!</strong>
        <span id="msg"></span>
        <span class="close" data-dismiss="alert">×</span>
      </div>

      <div class="modal-footer">
        <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
        <a href="javascript:void(0)" class="btn btn-sm btn-success" id="createPage"><i class='fa fa-check'></i> Create Page</a>
      </div>
    </div>
  </div>
</div>

{include file="includes/footer.tpl"}