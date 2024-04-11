<!-- BEGIN #page-container -->
<div id="header" class="header">
    <!-- BEGIN container -->
    <div class="container">
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

<div class="content-bg">
    <img src="assets/img/zug_laptop.jpg" alt="Home">
    <div class="container home-content">
        <h1>Find your home</h1>
        <div id="custom-search-input">
            <ul class="banner-search-btn">
                <li class="active"><a href="javascript:;" id="btn-buy">Buy</a></li>
                <li><a href="javascript:;" id="btn-rent">Rent</a></li>
                <li><a href="javascript:;" id="btn-sell">Sell</a></li>
            </ul>
            <div class="input-group col-md-12">
                <input type="text" class="search-query form-control" id="search-input" placeholder="Enter an address, city or ZIP code" />
                <span class="input-group-btn">
                    <button class="btn btn-success" type="button">
                        <span class=" glyphicon glyphicon-search"></span>
                    </button>
                </span>
            </div>
        </div>
    </div>
</div>