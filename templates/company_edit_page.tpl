{include file="includes/header.tpl"}

<link rel="stylesheet" href="assets/test_temp/edittable-styles.css">
<link rel="stylesheet" href="assets/test_temp/styles.css">

<!-- begin #content -->
<div id="content" class="content p-0">

  <div id="page-design" class="edit">

    <div id="menu-htmleditor">
      <div id="design-controls">
        <button type="button" id="edit" class="active btn btn-primary"><i class="glyphicon glyphicon-edit "></i> Edit</button>
        <!-- <button type="button" id="save" class="btn btn-success"><i class="fa fa-save"></i> Save</button> -->
        <button type="button" id="save-design" class="btn btn-success"><i class="fa fa-save"></i> Save</button>
        <button type="button" class="btn btn-inverse" id="sourcepreview"><i class="glyphicon-eye-open glyphicon"></i> Preview</button>
      </div>
      <br>
      <div id="preview-btns">
        <button type="button" class="active btn btn-inverse" id="pc" data-toggle="tooltip" data-placement="left" title="Desktop"><i class="fa fa-laptop"></i></button>
        <button type="button" class="btn btn-inverse" id="tablet" data-toggle="tooltip" data-placement="left" title="Tablet"><i class="fa fa-tablet"></i></button>
        <button type="button" class="btn btn-inverse" id="mobile" data-toggle="tooltip" data-placement="left" title="Mobile"><i class="fa fa-mobile"></i></button>
      </div>
    </div>

    <iframe src="{$page_source}" id="frameView" scrolling="yes" frameborder="0" class="hide"></iframe>

    <div class="container-fluid">

      <div class="sidebar-nav">

        <div class="wrapper bg-green-lighter text-white">
          {$page_title}
        </div>

        <div class="panel-group" id="accordion">
          <div class="panel panel-inverse bg-green m-0">
            <div class="panel-heading bg-green-darker" style="border-radius: 0;">
              <h3 class="panel-title">
                <a class="accordion-toggle accordion-toggle-styled collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseOne">
                  <i class="fa fa-plus-circle pull-right"></i> 
                  Columns
                </a>
              </h3>
            </div>
            <div id="collapseOne" class="panel-collapse collapse in">
              <div class="panel-body p-0" style="border-top: none;">
                {include file="includes/page_modules/module_columns.tpl"}
              </div>
            </div>
          </div>
          <div class="panel panel-inverse bg-green m-0">
            <div class="panel-heading bg-green-darker" style="border-radius: 0;">
              <h3 class="panel-title">
                <a class="accordion-toggle accordion-toggle-styled ui-sortable collapsed" data-toggle="collapse" data-parent="#accordion" href="#collapseTwo">
                  <i class="fa fa-plus-circle pull-right"></i> 
                  Modules
                </a>
              </h3>
            </div>
            <div id="collapseTwo" class="panel-collapse ui-sortable collapse" style="height: 0px;">
              <div class="panel-body p-0" style="border-top: none;">
                <ul class="nav nav-list">
                  <li class="boxes">

                    {include file="includes/page_module.tpl" html_code="<h2>Header Title</h2>" module_title="Header" module_icon="fa-header" data_type="header" has_setting="true"}

                    {include file="includes/page_module.tpl" html_code="<p>Paragraph</p>" module_title="Paragraph" module_icon="fa-paragraph" data_type="paragraph" has_setting="true"}

                    {include file="includes/page_module.tpl" html_code='<img src="assets/img/image-placeholder.jpg" class="img-responsive" title="default title"/>' module_title="Image" module_icon="fa-image" data_type="image" has_setting="true"}

                    {include file="includes/page_module.tpl" html_code='<iframe src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d172138.65427095362!2d-122.48214666413611!3d47.6131746401848!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x5490102c93e83355%3A0x102565466944d59a!2sSeattle%2C+WA%2C+USA!5e0!3m2!1sen!2sph!4v1511258480365" width="100%" height="250" frameborder="0" style="border:0" allowfullscreen></iframe>' module_title="Map" module_icon="fa-map-o" data_type="map" has_setting="true"}
                    
                    {include file="includes/page_module.tpl" template="includes/page_modules/property_details.tpl" module_title="Property Details" module_icon="fa-list-alt" data_type="property-details"}

                    {include file="includes/page_module.tpl" template="includes/page_modules/hot_home.tpl" module_title="Hot Home" module_icon="fa-fire" data_type="hot-home"}

                    {include file="includes/page_module.tpl" template="includes/page_modules/house_details.tpl" module_title="House Details" module_icon="fa-home" data_type="house-details"}

                    {include file="includes/page_module.tpl" template="includes/page_modules/module_form.tpl" module_title="Module Form" module_icon="fa-map-o" data_type="form"}

                  </li>
                </ul>
              </div>
            </div>
          </div>
        </div>
      </div>

      <div class="panel" style="background-color: transparent;">
        <div class="panel-body p-0">
          <div id="page-design-sheet">

            <div class="htmlpage-header">
              {include file=$editable_header}
            </div>
            
            <div class="htmlpage">
              {if $editable_code ne ''}
              {$editable_code}
              {/if}
            </div>

            {if $editable_footer ne ''}
            <div class="htmlpage-footer">
              {include file=$editable_footer}
            </div>
            {/if}

          </div>
        </div>
      </div>

    </div>

  </div>
</div>
<!-- end #content -->

<!-- MODAL SAVE HTML -->
<div class="modal fade" id="download" tabindex="-1" role="dialog" aria-labelledby="download" aria-hidden="true">
  <div class="modal-dialog" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> 
        <h4 class="modal-title"><i class='fa fa-save'></i>&nbsp;Save as </h4>
      </div>
      <div class="modal-body" id='sourceCode'>
        <h3>Plain HTML Codes</h3>
        <textarea id="src" rows="10" class="form-control"></textarea>
        <br>
        <h3>HTML Codes with Draggable</h3>
        <textarea id="model" rows="10" class="form-control"></textarea>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal"><i class='fa fa-close'></i>&nbsp;Close</button>
        <button type="button" class="btn btn-success" id="srcSave"><i class='fa fa-save'></i>&nbsp;Save</button>
      </div>
    </div>
  </div>
</div>

<!-- MODAL SETTINGS -->
<div class="modal fade " id="preferences" aria-hidden="false">
  <div class="modal-dialog modal-lg" role="document">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button> 
        <h4 class="modal-title" id="preferencesTitle"></h4>
      </div>
      <div class="modal-body" id="preferencesContent">
        <div id="alert_success" class="alert alert-success fade in hide flash" style="border-radius: 0;">
          <strong>Success!</strong>
          <span id="msg"></span>
          <span class="close" data-dismiss="alert">×</span>
        </div>

        <div id="mediagallery" style="overflow:auto;height:400px; display:none" >
          <div id="contenutoimmagini"></div>
          <form enctype="multipart/form-data" id="form-id">
            <input name="nomefile" type="file" />
            <input class="button" type="button" value="Upload" />
          </form>
          <progress value="0"></progress><br>
          <a class="btn btn-info" href="javascript:;" onclick="$('#mediagallery').hide();$('#thepref').show();">Return to image settings</a> 
        </div>

        <div id="thepref">
          <div class="tab-content m-b-0">
            <div role="tabpanel" class="tab-pane active" id="Settings">
              <div class="panel panel-body p-0 m-b-0">

                <div id="ht" style="display: none;"> <textarea id="html5editorLite"></textarea> </div>

                <div id="text" style="display: none;"> <textarea id="html5editor"></textarea> </div>

                <div id="hot-home" style="display: none;">
                  <div class="form-group"> <label> Content :  </label> <input type="text" class="form-control" id="hot-home-content"/> </div>
                  <div class="form-group"> <label> Link :  </label> <input type="text" class="form-control" id="hot-home-link"/> </div>
                </div>

                <div id="image" style="display:none">
                  <div class="row">
                    <div class="col-md-5" >
                      <div id="imgContent"> </div>
                      <a class="btn btn-default form-control" href="#" id="gallery"><i class="icon-upload-alt"></i>&nbsp;Browse ...</a> 
                    </div>
                    <div class="col-md-7">
                      <div class="form-group"> <label for="img-url">Url :</label> <input type="text" value="" id="img-url" class="form-control" /> </div>
                      <!-- <div class="form-group"> <label for="img-url">Click Url:</label> <input type="text" value="" id="img-clickurl" class="form-control" /> </div> --> 
                      <div class="row">
                        <div class="col-md-6">
                          <div class="form-group"> <label for="img-width">Width :</label> <input type="text" value="" id="img-width" class="form-control"/> </div>
                        </div>
                        <div class="col-md-6">
                          <div class="form-group"> <label for="img-height">Height :</label> <input type="text" value="" id="img-height" class="form-control"/> </div>
                        </div>
                      </div>
                      <div class="form-group"> <label for="img-title">Title : </label> <input type="text" value="" id="img-title" class="form-control"/> </div>
                      <div class="form-group"> <label for="img-rel">Rel :</label> <input type="text" value="" id="img-rel" class="form-control"/> </div>
                    </div>
                  </div>
                </div>

                <div id="map" style="display:none">
                  <div class="row">
                    <div class="col-md-12">
                      <div id="map-content"> </div>
                    </div>
                  </div>
                  <div class="row">
                    <div class="col-md-12">
                      <form>
                        <div class="form-group"> <label for="address">Latitude :</label> <input type="text" value="" id="latitude" class="form-control" /> </div>
                        <div class="form-group"> <label for="address">Longitude :</label> <input type="text" value="" id="longitude" class="form-control" /> </div>
                        <div class="form-group"> <label for="address">Zoom :</label> <input type="text" value="" id="zoom" class="form-control" /> </div>
                        <div class="row">
                          <div class="col-md-6">
                            <div class="form-group"> <label for="img-width">Width :</label> <input type="text" value="" id="map-width" class="form-control"/> </div>
                          </div>
                          <div class="col-md-6">
                            <div class="form-group"> <label for="img-height">Height :</label> <input type="text" value="" id="map-height" class="form-control"/> </div>
                          </div>
                        </div>
                      </form>
                    </div>
                  </div>
                </div>

                <div class="row" id="module-details">
                  <div class="col-md-12">
                    <div class="form-horizontal m-t-20">
                      <div class="form-group">
                        <label class="col-md-2 control-label">ID:</label>
                        <div class="col-md-10">
                          <input type="text" class="form-control" id="id" readonly>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>

              </div>
            </div>
          </div>
        </div>
      </div>
      <div class="modal-footer">
        <a href="javascript:void(0)" class="btn btn-sm btn-white" data-dismiss="modal">Close</a>
        <a href="javascript:void(0)" class="btn btn-sm btn-success" id="applyChanges"><i class='fa fa-check'></i> Apply changes</a>
      </div>
    </div>
  </div>
  <div id="download-layout">
    <div class="container"></div>
  </div>
</div>

{include file="includes/footer.tpl"}