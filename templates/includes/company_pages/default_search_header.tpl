<style type="text/css">
    #search-filters {
        background-color: #00acac;
        min-height: 50px;
    }
    #propertylist-box {
        height: 100vh;
    }
    #propertylist-box, #map-box {
        padding-top: 127px;
    }
    #top-nav {
        background-color: #00acac;
        min-height: 50px;
        position: fixed;
        top: 77px;
        left: 0;
        z-index: 3;
        width: 100%;
    }
    #map_container {
        position: relative;
    }
    #map {
        height: 0;
        overflow: hidden;
        padding-bottom: 83.5vh;
        padding-top: 30px;
        position: relative;
    }
    .photo-card {
        font-family: Gotham,gotham,Verdana,sans-serif;
        position: relative;
        margin-bottom: 10px;
        padding-left: 10px;
        float: left;
        width: 49%;
        color: #fff;
        text-shadow: 0 0 3px rgba(0,0,0,.5);
    }
    .photo-card img {
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        width: 100%;
        max-height: 200px;
    }
    .photo-card .caption h4 {
        font-size: 13px;
        line-height: 1.5;
        font-weight: 700;
        text-transform: uppercase;
    }
    .photo-card .caption {
        position: absolute;
        bottom: 7px;
        left: 20px;
        z-index: 2;
    }
    .photo-card .caption h4, .photo-card .caption p {
        margin-bottom: 0;
    }
    .photo-card-status .btn-icon {
        border: 2px solid #fff;
        margin-right: 4px;
    }
    .photo-card-address, .photo-card-beds, .photo-card-broker-name, .photo-card-broker-phone, .photo-card-info, .photo-card-notification, .photo-card-spec {
        white-space: nowrap;
        overflow: hidden;
        text-overflow: ellipsis;
    }
    .photo-card-price {
        font-size: 28px;
        line-height: 1;
    }
    .photo-card-address {
        font-size: 13px;
        color: #ccc;
    }
    #search-map-filter {
        padding: 10px;
    }
</style>

<!-- BEGIN #page-container -->
<div id="header" class="header" style="position: fixed;width: 100%;">
    <!-- BEGIN container -->
    <div class="container-fluid">
        <!-- BEGIN header-container -->
        <div class="header-container">
            <!-- BEGIN navbar-header -->
            <div class="navbar-header">
                <button type="button" class="navbar-toggle collapsed" data-toggle="collapse" data-target="#navbar-collapse">
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                    <span class="icon-bar"></span>
                </button>
                <div class="header-logo">
                    <a href="javascript:;">
                        <span class="brand"></span>
                        <span>Color</span>Admin
                        <small>e-commerce frontend theme</small>
                    </a>
                </div>
            </div>
            <!-- END navbar-header -->
            <!-- BEGIN header-nav -->
            {if $parent_menu ne ''}
            <div class="header-nav">
                <div class=" collapse navbar-collapse" id="navbar-collapse">
                    <ul class="nav">
                        {foreach item=parent from=$parent_menu}
                            {if $parent.has_child eq '1'}
                            <li class="dropdown dropdown-hover">
                                <a href="{$parent.menu_link}" data-toggle="dropdown">
                                    {$parent.menu_label} 
                                    <i class="fa fa-angle-down"></i> 
                                    <span class="arrow top"></span>
                                </a>
                                <ul class="dropdown-menu">
                                {foreach item=child from=$child_menu}
                                    {if $child.parent_id eq $parent.menu_id}
                                    <li><a href="{$child.menu_link}">{$child.menu_label}</a></li>
                                    {/if}
                                {/foreach}
                                </ul>
                            </li>
                            {else}
                            <li><a href="{$parent.menu_link}">{$parent.menu_label}</a></li>
                            {/if}
                          </li>
                        {/foreach}
                    </ul>
                </div>
            </div>
            {else}
            Menu Not Set
            {/if}
            <!-- END header-nav -->
            <!-- BEGIN header-nav -->
            <div class="header-nav">
                <ul class="nav pull-right">
                    <li>
                        <a href="#modal-login" data-toggle="modal">
                            <i class="fa fa-sign-in"></i>
                            <span class="">Sign in</span>
                        </a>
                    </li>
                    <li class="divider"></li>
                    <li>
                        <a href="#modal-signin" data-toggle="modal">
                            <span class="">Join</span>
                        </a>
                    </li>
                </ul>
            </div>
            <!-- END header-nav -->
        </div>
        <!-- END header-container -->
    </div>
    <!-- END container -->
</div>

<div id="top-nav" class="top-nav">
    <div class="container-fluid">
        <form id="search-map-filter" class="form-inline">
            <div class="input-group">
                <input type="text" class="form-control input-white" placeholder="Address, city or ZIP code">
                <span class="input-group-btn">
                    <button class="btn btn-inverse" type="button"><i class="fa fa-search"></i></button>
                </span>
            </div>
            <div class="input-group">
                <div class="btn-group">
                    <a href="javascript:;" data-toggle="dropdown" class="btn btn-inverse dropdown-toggle" aria-expanded="false">Listing Type <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:;">Action 1</a></li>
                        <li><a href="javascript:;">Action 2</a></li>
                        <li><a href="javascript:;">Action 3</a></li>
                        <li class="divider"></li>
                        <li><a href="javascript:;">Action 4</a></li>
                    </ul>
                </div>
            </div>
            <div class="input-group">
                <div class="btn-group">
                    <a href="javascript:;" data-toggle="dropdown" class="btn btn-inverse dropdown-toggle" aria-expanded="false">Home Type <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:;">Action 1</a></li>
                        <li><a href="javascript:;">Action 2</a></li>
                        <li><a href="javascript:;">Action 3</a></li>
                        <li class="divider"></li>
                        <li><a href="javascript:;">Action 4</a></li>
                    </ul>
                </div>
            </div>
            <div class="input-group">
                <div class="btn-group">
                    <a href="javascript:;" data-toggle="dropdown" class="btn btn-inverse dropdown-toggle" aria-expanded="false">Price <span class="caret"></span></a>
                    <ul class="dropdown-menu">
                        <li><a href="javascript:;">Action 1</a></li>
                        <li><a href="javascript:;">Action 2</a></li>
                        <li><a href="javascript:;">Action 3</a></li>
                        <li class="divider"></li>
                        <li><a href="javascript:;">Action 4</a></li>
                    </ul>
                </div>
            </div>
        </form>
    </div>
</div>

<div class="container-fluid">
    <div class="row">
        <!-- Map -->
        <div class="col-md-7 col-xs-12 p-0">
            <div id="map-box">
                <div id="map_container"></div>
                <div id="map"></div>
            </div>
        </div>
        <!-- List -->
        <div class="col-md-5 col-xs-12 p-0">
            <div id="propertylist-box">
                <div data-scrollbar="true" data-height="100%">
                    <div class="col-md-12">
                        <h1>Seattle WA Real Estate</h1>
                        <div class="search-toolbar">
                            <!-- BEGIN row -->
                            <div class="row">
                                <!-- BEGIN col-6 -->
                                <div class="col-md-6">
                                    <h4>We found 732 Items for "Mobile Phones"</h4>
                                </div>
                                <!-- END col-6 -->
                                <!-- BEGIN col-6 -->
                                <div class="col-md-6 text-right">
                                    <ul class="sort-list">
                                        <li class="text"><i class="fa fa-filter"></i> Sort by:</li>
                                        <li class="active"><a href="javascript:;">Popular</a></li>
                                        <li><a href="javascript:;">New Arrival</a></li>
                                        <li><a href="javascript:;">Price</a></li>
                                    </ul>
                                </div>
                                <!-- END col-6 -->
                            </div>
                            <!-- END row -->
                        </div>
                    </div>

                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-1.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-2.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-3.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-4.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-5.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-6.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-7.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-8.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-3.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>
                    <div class="photo-card">
                        <img src="assets/img/gallery/gallery-10.jpg">
                        <div class="caption">
                            <h4>
                                <span class="photo-card-status"><span class="btn btn-danger btn-icon btn-circle btn-xs"></span>Condo For Sale</span>
                            </h4>
                            <p>
                                <span class="photo-card-price">$529,000</span>
                                <span class="photo-card-info">2 bds <span class="interpunct">·</span> 2 ba <span class="interpunct">·</span> 1,144 sqft</span>
                            </p>
                            <p><span class="photo-card-address">10203 47th Ave SW APT C14, Seattle, WA</span></p>
                        </div>
                    </div>

                    <div class="text-center">
                        <ul class="pagination m-t-0">
                            <li class="disabled"><a href="javascript:;">Previous</a></li>
                            <li class="active"><a href="javascript:;">1</a></li>
                            <li><a href="javascript:;">2</a></li>
                            <li><a href="javascript:;">3</a></li>
                            <li><a href="javascript:;">4</a></li>
                            <li><a href="javascript:;">5</a></li>
                            <li><a href="javascript:;">Next</a></li>
                        </ul>
                    </div>

                    <!-- BEGIN #footer-copyright -->
                    <div id="footer-copyright" class="footer-copyright">
                        <!-- BEGIN container -->
                        <div class="container">
                            <div class="copyright">
                                {if $company_settings.footer_line ne ''}
                                {$company_settings.footer_line}
                                {else}
                                Copyright &copy; 2018 Zugent. All rights reserved.
                                {/if}
                            </div>
                        </div>
                        <!-- END container -->
                    </div>
                    <!-- END #footer-copyright -->

                </div>
            </div>
        </div>
    </div>
</div>

<!-- #modal-login -->
<div class="modal fade" id="modal-login">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Sign In</h4>
            </div>
            <div class="modal-body">
                <div class="login-content">
                    <form action="index.html" method="POST" class="margin-bottom-0">
                        <div class="form-group m-b-20">
                            <input type="text" class="form-control input-lg" placeholder="Email Address" required="">
                        </div>
                        <div class="form-group m-b-20">
                            <input type="password" class="form-control input-lg" placeholder="Password" required="">
                        </div>
                        <div class="checkbox m-b-20">
                            <label>
                                <input type="checkbox"> Remember Me
                            </label>
                        </div>
                        <div class="login-buttons">
                            <button type="submit" class="btn btn-success btn-block btn-lg">Sign me in</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>
<!-- #modal-dialog -->
<div class="modal fade" id="modal-signin">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">×</button>
                <h4 class="modal-title">Join Us</h4>
            </div>
            <div class="modal-body">
                <div class="login-content">
                    <form action="index.html" method="POST" class="margin-bottom-0">
                        <div class="form-group m-b-20">
                            <input type="text" class="form-control input-lg" placeholder="Email Address" required="">
                        </div>
                        <div class="form-group m-b-20">
                            <input type="password" class="form-control input-lg" placeholder="Password" required="">
                        </div>
                        <div class="checkbox m-b-20">
                            <label>
                                <input type="checkbox"> I agree ...
                            </label>
                        </div>
                        <div class="login-buttons">
                            <button type="submit" class="btn btn-success btn-block btn-lg">Submit</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>