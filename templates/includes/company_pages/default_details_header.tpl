<style type="text/css">
    #top-nav {
        background-color: #00acac;
        min-height: 50px;
        z-index: 1;
    }
    .photo-card .photo-card-img {
        background-size: cover;
        background-position: center;
        background-repeat: no-repeat;
        width: 100%;
        height: 100%;
    }
    #search-map-filter {
        padding: 10px;
    }
</style>

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

<div id="top-nav" class="top-nav">
    <!-- BEGIN container -->
    <div class="container">
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
    <!-- END container -->
</div>

<div id="product" class="section-container p-t-20">
    <!-- BEGIN container -->
    <div class="container">
        <!-- BEGIN breadcrumb -->
        <ul class="breadcrumb m-b-10 f-s-12">
            <li><a href="#">Home</a></li>
            <li><a href="#">Location</a></li>
            <li class="active">Property</li>
        </ul>
        <!-- END breadcrumb -->


        <div class="row row-space-10">
            <!-- BEGIN col-6 -->
            <div class="col-md-6">
                <!-- BEGIN promotion -->
                <div class="promotion promotion-lg bg-black-darker">
                    <div class="promotion-image text-right promotion-image-overflow-bottom">
                        <img src="assets/img/iphone-se.png" alt="">
                    </div>
                    <div class="promotion-caption promotion-caption-inverse">
                        <h4 class="promotion-title">iPhone SE</h4>
                        <div class="promotion-price"><small>from</small> $299.00</div>
                        <p class="promotion-desc">A big step for small.<br>A beloved design. Now with more to love.</p>
                        <a href="#" class="promotion-btn">View More</a>
                    </div>
                </div>
                <!-- END promotion -->
            </div>
            <!-- END col-6 -->
            <!-- BEGIN col-3 -->
            <div class="col-md-3 col-sm-6">
                <!-- BEGIN promotion -->
                <div class="promotion bg-blue">
                    <div class="promotion-image promotion-image-overflow-bottom promotion-image-overflow-top">
                        <img src="assets/img/apple-watch-sm.png" alt="">
                    </div>
                    <div class="promotion-caption promotion-caption-inverse text-right">
                        <h4 class="promotion-title">Apple Watch</h4>
                        <div class="promotion-price"><small>from</small> $299.00</div>
                        <p class="promotion-desc">You. At a glance.</p>
                        <a href="#" class="promotion-btn">View More</a>
                    </div>
                </div>
                <!-- END promotion -->
                <!-- BEGIN promotion -->
                <div class="promotion bg-silver">
                    <div class="promotion-image text-center promotion-image-overflow-bottom">
                        <img src="assets/img/mac-mini.png" alt="">
                    </div>
                    <div class="promotion-caption text-center">
                        <h4 class="promotion-title">Mac Mini</h4>
                        <div class="promotion-price"><small>from</small> $199.00</div>
                        <p class="promotion-desc">It’s mini in a massive way.</p>
                        <a href="#" class="promotion-btn">View More</a>
                    </div>
                </div>
                <!-- END promotion -->
            </div>
            <!-- END col-3 -->
            <!-- BEGIN col-3 -->
            <div class="col-md-3 col-sm-6">
                <!-- BEGIN promotion -->
                <div class="promotion bg-silver">
                    <div class="promotion-image promotion-image-overflow-right promotion-image-overflow-bottom text-right">
                        <img src="assets/img/mac-accessories.png" alt="">
                    </div>
                    <div class="promotion-caption text-center">
                        <h4 class="promotion-title">Apple Accessories</h4>
                        <div class="promotion-price"><small>from</small> $99.00</div>
                        <p class="promotion-desc">Redesigned. Rechargeable. Remarkable.</p>
                        <a href="#" class="promotion-btn">View More</a>
                    </div>
                </div>
                <!-- END promotion -->
                <!-- BEGIN promotion -->
                <div class="promotion bg-black">
                    <div class="promotion-image text-right">
                        <img src="assets/img/mac-pro.png" alt="">
                    </div>
                    <div class="promotion-caption promotion-caption-inverse">
                        <h4 class="promotion-title">Mac Pro</h4>
                        <div class="promotion-price"><small>from</small> $1,299.00</div>
                        <p class="promotion-desc">Built for creativity on an epic scale.</p>
                        <a href="#" class="promotion-btn">View More</a>
                    </div>
                </div>
                <!-- END promotion -->
            </div>
            <!-- END col-3 -->
        </div>


        <!-- BEGIN product -->
        <div class="product m-t-20">
            <!-- BEGIN property-detail -->
            <div class="property-detail">
                <!-- BEGIN property-info -->
                <div class="property-info">
                    <div class="row">
                        <!-- BEGIN property-info-header -->
                        <div class="col-md-6">
                            <div class="property-info-header">
                                <h1 class="property-title"><!-- <span class="label label-success">41% OFF</span> --> 7742 Seward Park Ave S, Seattle, WA 98118 </h1>
                                <p class="property-category">7 beds 10 baths 12,330 sqft</p>
                            </div>
                            <!-- BEGIN property-warranty -->
                            <div class="property-warranty">
                                <div class="pull-right">Availability: In stock</div>
                                <div><b>1 Year</b> Local Manufacturer Warranty</div>
                            </div>
                            <!-- END property-warranty -->
                        </div>
                        <!-- END property-info-header -->
                        <!-- BEGIN property-purchase-container -->
                        <div class="col-md-6">
                            <div class="property-purchase-container">
                                <div class="property-price">
                                    <div class="price">$7,988,000</div>
                                </div>
                                <div class="property-discount">
                                    <span class="discount">EST. MORTGAGE $29,457/mo</span>
                                </div>
                                <div class="pull-right"><button class="btn btn-inverse btn-lg" type="submit">CONTACT AGENT</button></div>
                            </div>
                        </div>
                        <!-- END property-purchase-container -->
                    </div>
                    <div class="row">
                        <!-- BEGIN property-info-list -->
                        <div class="col-md-12">
                            <div class="property-info-list">
                                <p>Iconic gated estate offers 138' of waterfront & mountain views. This updated custom home has the finest in quality, design & finish details. Fabulous Chef's gourmet kitchen w/Miele appliances, granite tops, & entertaining island. Caretaker's cottage/home theater/gym/pool/elevator/steam/sauna/indoor spa & 2 master suites are just a few of the spectacular features. Rolling lawn leads to the outdoor waterfall, grotto, & private dock w/year-round deep moorage. Truly one of a kind waterfront retreat.</p>
                            </div>
                        </div>
                        <!-- END property-info-list -->
                    </div>
                </div>
                <!-- END property-info -->
            </div>
            <!-- END property-detail -->
            <!-- BEGIN property-tab -->
            <div class="property-tab">
                <!-- BEGIN #property-tab -->
                <ul id="property-tab" class="nav nav-tabs">
                    <li class="active"><a href="#property-desc" data-toggle="tab" aria-expanded="true">Product Description</a></li>
                    <li class=""><a href="#property-info" data-toggle="tab" aria-expanded="false">Additional Information</a></li>
                    <li class=""><a href="#property-reviews" data-toggle="tab" aria-expanded="false">Rating &amp; Reviews (5)</a></li>
                </ul>
                <!-- END #property-tab -->
                <!-- BEGIN #property-tab-content -->
                <div id="property-tab-content" class="tab-content">
                    <!-- BEGIN #property-desc -->
                    <div class="tab-pane fade active in" id="property-desc">
                        <!-- BEGIN property-desc -->
                        <div class="property-desc">
                            <div class="image">
                                <img src="assets/img/product-main.jpg" alt="">
                            </div>
                            <div class="desc">
                                <h4>iPhone 6s</h4>
                                <p>
                                    The moment you use iPhone 6s, you know you’ve never felt anything like it. With a single press, 3D Touch lets you do more than ever before. Live Photos bring your memories to life in a powerfully vivid way. And that’s just the beginning. Take a deeper look at iPhone 6s, and you’ll find innovation on every level.
                                </p>
                            </div>
                        </div>
                        <!-- END property-desc -->
                        <!-- BEGIN property-desc -->
                        <div class="property-desc right">
                            <div class="image">
                                <img src="assets/img/product-3dtouch.jpg" alt="">
                            </div>
                            <div class="desc">
                                <h4>3D Touch</h4>
                                <p>
                                    The original iPhone introduced the world to Multi-Touch, forever changing the way people experience technology. With 3D Touch, you can do things that were never possible before. It senses how deeply you press the display, letting you do all kinds of essential things more quickly and simply. And it gives you real-time feedback in the form of subtle taps from the all-new Taptic Engine.
                                </p>
                            </div>
                        </div>
                        <!-- END property-desc -->
                        <!-- BEGIN property-desc -->
                        <div class="property-desc">
                            <div class="image">
                                <img src="assets/img/product-cameras.jpg" alt="">
                            </div>
                            <div class="desc">
                                <h4>Cameras</h4>
                                <p>
                                    The 12-megapixel iSight camera captures sharp, detailed photos. It takes brilliant 4K video, up to four times the resolution of 1080p HD video. iPhone 6s also takes selfies worthy of a self-portrait with the new 5-megapixel FaceTime HD camera. And it introduces Live Photos, a new way to relive your favorite memories. It captures the moments just before and after your picture and sets it in motion with just the press of a finger.
                                </p>
                            </div>
                        </div>
                        <!-- END property-desc -->
                        <!-- BEGIN property-desc -->
                        <div class="property-desc right">
                            <div class="image">
                                <img src="assets/img/product-technology.jpg" alt="">
                            </div>
                            <div class="desc">
                                <h4>Technology</h4>
                                <p>
                                    iPhone 6s is powered by the custom-designed 64-bit A9 chip. It delivers performance once found only in desktop computers. You’ll experience up to 70 percent faster CPU performance, and up to 90 percent faster GPU performance for all your favorite graphics-intensive games and apps.
                                </p>
                            </div>
                        </div>
                        <!-- END property-desc -->
                        <!-- BEGIN property-desc -->
                        <div class="property-desc">
                            <div class="image">
                                <img src="assets/img/product-design.jpg" alt="">
                            </div>
                            <div class="desc">
                                <h4>Design</h4>
                                <p>
                                    Innovation isn’t always obvious to the eye, but look a little closer at iPhone 6s and you’ll find it’s been fundamentally improved. The enclosure is made from a new alloy of 7000 Series aluminum — the same grade used in the aerospace industry. The cover glass is the strongest, most durable glass used in any smartphone. And a new rose gold finish joins space gray, silver, and gold.
                                </p>
                            </div>
                        </div>
                        <!-- END property-desc -->
                    </div>
                    <!-- END #property-desc -->
                    <!-- BEGIN #property-info -->
                    <div class="tab-pane fade" id="property-info">
                        <!-- BEGIN table-responsive -->
                        <div class="table-responsive">
                            <!-- BEGIN table-product -->
                            <table class="table table-product table-striped">
                                <thead>
                                    <tr>
                                        <th></th>
                                        <th>iPhone 6s</th>
                                        <th>iPhone 6s Plus</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr>
                                        <td class="field">Capacity</td>
                                        <td>
                                            16GB<br>
                                            64GB<br>
                                            128GB
                                        </td>
                                        <td>
                                            16GB<br>
                                            64GB<br>
                                            128GB
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">Weight and Dimensions</td>
                                        <td>
                                            5.44 inches (138.3 mm) x 2.64 inches (67.1 mm) x 0.28 inch (7.1 mm)<br>
                                            Weight: 5.04 ounces (143 grams)
                                        </td>
                                        <td>
                                            6.23 inches (158.2 mm) x 3.07 inches (77.9 mm) x 0.29 inch (7.3 mm)<br>
                                            Weight: 6.77 ounces (192 grams)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">Display</td>
                                        <td>
                                            Retina HD display with 3D Touch<br>
                                            4.7-inch (diagonal) LED-backlit widescreen<br>
                                            1334-by-750-pixel resolution at 326 ppi<br>
                                            1400:1 contrast ratio (typical)<br>
                                            <br>
                                            <b>Both models:</b><br>
                                            500 cd/m2 max brightness (typical)<br>
                                            Full sRGB standard<br>
                                            Dual-domain pixels for wide viewing angles<br>
                                            Fingerprint-resistant oleophobic coating on front<br>
                                            Support for display of multiple languages and characters simultaneously<br>
                                            Display Zoom<br>
                                            Reachability
                                        </td>
                                        <td>
                                            Retina HD display with 3D Touch<br>
                                            5.5-inch (diagonal) LED-backlit widescreen<br>
                                            1920-by-1080-pixel resolution at 401 ppi<br>
                                            1300:1 contrast ratio (typical)
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">Chip</td>
                                        <td colspan="2">
                                            A9 chip with 64-bit architecture Embedded M9 motion coprocessor
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">iSight Camera</td>
                                        <td colspan="2">
                                            New 12-megapixel iSight camera with 1.22µ pixels<br>
                                            Live Photos<br>
                                            Autofocus with Focus Pixels<br>
                                            Optical image stabilization (iPhone 6s Plus only)<br>
                                            True Tone flash<br>
                                            Panorama (up to 63 megapixels)<br>
                                            Auto HDR for photos<br>
                                            Exposure control<br>
                                            Burst mode<br>
                                            Timer mode<br>
                                            ƒ/2.2 aperture<br>
                                            Five-element lens<br>
                                            Hybrid IR filter<br>
                                            Backside illumination sensor<br>
                                            Sapphire crystal lens cover<br>
                                            Auto image stabilization<br>
                                            Improved local tone mapping<br>
                                            Improved noise reduction<br>
                                            Face detection<br>
                                            Photo geotagging
                                        </td>
                                    </tr>
                                    <tr>
                                        <td class="field">Video Recording</td>
                                        <td colspan="2">
                                            4K video recording (3840 by 2160) at 30 fps<br>
                                            1080p HD video recording at 30 fps or 60 fps<br>
                                            720p HD video recording at 30 fps<br>
                                            Optical image stabilization for video (iPhone 6s Plus only)<br>
                                            True Tone flash<br>
                                            Slo-mo video support for 1080p at 120 fps and 720p at 240 fps<br>
                                            Time-lapse video with stabilization<br>
                                            Cinematic video stabilization (1080p and 720p)<br>
                                            Continuous autofocus video<br>
                                            Improved noise reduction<br>
                                            Take 8MP still photos while recording 4K video<br>
                                            Playback zoom<br>
                                            3x zoom<br>
                                            Face detection<br>
                                            Video geotagging
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                            <!-- END table-product -->
                        </div>
                        <!-- END table-responsive -->
                    </div>
                    <!-- END #property-info -->
                    <!-- BEGIN #property-reviews -->
                    <div class="tab-pane fade" id="property-reviews">
                        <!-- BEGIN row -->
                        <div class="row row-space-30">
                            <!-- BEGIN col-7 -->
                            <div class="col-md-7">
                                <!-- BEGIN review -->
                                <div class="review">
                                    <div class="review-info">
                                        <div class="review-icon"><img src="assets/img/user-1.jpg" alt=""></div>
                                        <div class="review-rate">
                                            <ul class="review-star">
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class=""><i class="fa fa-star-o"></i></li>
                                            </ul>
                                            (4/5)
                                        </div>
                                        <div class="review-name">Terry</div>
                                        <div class="review-date">24/05/2016 7:40am</div>
                                    </div>
                                    <div class="review-title">
                                        What does “SIM-free” mean?
                                    </div>                        
                                    <div class="review-message">
                                        Lorem ipsum dolor sit amet, consectetur adipiscing elit. Morbi in imperdiet augue. Integer non aliquam eros. Cras vehicula nec sapien pretium sagittis. Pellentesque feugiat lectus non malesuada aliquam. Etiam id tortor pretium, dictum leo at, malesuada tortor.
                                    </div>
                                </div>
                                <!-- END review -->
                                <!-- BEGIN review -->
                                <div class="review">
                                    <div class="review-info">
                                        <div class="review-icon"><img src="assets/img/user-2.jpg" alt=""></div>
                                        <div class="review-rate">
                                            <ul class="review-star">
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class=""><i class="fa fa-star-o"></i></li>
                                                <li class=""><i class="fa fa-star-o"></i></li>
                                            </ul>
                                            (3/5)
                                        </div>
                                        <div class="review-name">George</div>
                                        <div class="review-date">24/05/2016 8:40am</div>
                                    </div>                     
                                    <div class="review-title">
                                        When I buy iPhone from apple.com, is it tied to a carrier or does it come “unlocked”?
                                    </div>                
                                    <div class="review-message">
                                        In mauris leo, maximus at pellentesque vel, pharetra vel risus. Aenean in semper velit. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Morbi volutpat mattis neque, at molestie tellus ultricies quis. Ut lobortis odio nec nunc ullamcorper, vitae faucibus augue semper. Sed luctus lobortis nulla ac volutpat. Mauris blandit scelerisque sem.
                                    </div>
                                </div>
                                <!-- END review -->
                                <!-- BEGIN review -->
                                <div class="review">
                                    <div class="review-info">
                                        <div class="review-icon"><img src="assets/img/user-3.jpg" alt=""></div>
                                        <div class="review-rate">
                                            <ul class="review-star">
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                            </ul>
                                            (5/5)
                                        </div>
                                        <div class="review-name">Steve</div>
                                        <div class="review-date">23/05/2016 8:40am</div>
                                    </div>                     
                                    <div class="review-title">
                                        Where is the iPhone Upgrade Program available?
                                    </div>                
                                    <div class="review-message">
                                        Duis ut nunc sem. Integer efficitur, justo sit amet feugiat hendrerit, arcu nisl elementum dui, in ultricies erat quam at mauris. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec nec ultrices tellus. Mauris elementum venenatis volutpat.
                                    </div>
                                </div>
                                <!-- END review -->
                                <!-- BEGIN review -->
                                <div class="review">
                                    <div class="review-info">
                                        <div class="review-icon"><img src="assets/img/user-4.jpg" alt=""></div>
                                        <div class="review-rate">
                                            <ul class="review-star">
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class=""><i class="fa fa-star-o"></i></li>
                                                <li class=""><i class="fa fa-star-o"></i></li>
                                                <li class=""><i class="fa fa-star-o"></i></li>
                                            </ul>
                                            (2/5)
                                        </div>
                                        <div class="review-name">Alfred</div>
                                        <div class="review-date">23/05/2016 10.02am</div>
                                    </div>                     
                                    <div class="review-title">
                                        Can I keep my current service plan if I choose the iPhone Upgrade Program?
                                    </div>                
                                    <div class="review-message">
                                        Donec vel fermentum quam. Vivamus scelerisque enim eget tristique auctor. Vivamus tempus, turpis iaculis tempus egestas, leo augue hendrerit tellus, et efficitur neque massa at neque. Aenean efficitur eleifend orci at ornare.
                                    </div>
                                </div>
                                <!-- END review -->
                                <!-- BEGIN review -->
                                <div class="review">
                                    <div class="review-info">
                                        <div class="review-icon"><img src="assets/img/user-5.jpg" alt=""></div>
                                        <div class="review-rate">
                                            <ul class="review-star">
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                                <li class="active"><i class="fa fa-star"></i></li>
                                            </ul>
                                            (5/5)
                                        </div>
                                        <div class="review-name">Edward</div>
                                        <div class="review-date">22/05/2016 9.30pm</div>
                                    </div>                     
                                    <div class="review-title">
                                        I have an existing carrier contract or installment plan. Can I purchase with the iPhone Upgrade Program
                                    </div>                
                                    <div class="review-message">
                                        Aliquam consequat ut turpis non interdum. Integer blandit erat nec sapien sollicitudin, a fermentum dui venenatis. Nullam consequat at enim et aliquet. Cras mattis turpis quis eros volutpat tristique vel a ligula. Proin aliquet leo mi, et euismod metus placerat sit amet.
                                    </div>
                                </div>
                                <!-- END review -->
                            </div>
                            <!-- END col-7 -->
                            <!-- BEGIN col-5 -->
                            <div class="col-md-5">
                                <!-- BEGIN review-form -->
                                <div class="review-form">
                                    <form action="product_detail.html" name="review_form" method="POST">
                                        <h2>Write a review</h2>
                                        <div class="form-group">
                                            <label for="name">Name <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="name">
                                        </div>
                                        <div class="form-group">
                                            <label for="email">Title <span class="text-danger">*</span></label>
                                            <input type="text" class="form-control" id="email">
                                        </div>
                                        <div class="form-group">
                                            <label for="review">Review <span class="text-danger">*</span></label>
                                            <textarea class="form-control" rows="8" id="review"></textarea>
                                        </div>
                                        <div class="form-group">
                                            <label for="email">Rating  <span class="text-danger">*</span></label>
                                            <div class="rating rating-selection" data-rating="true" data-target="rating">
                                                <i class="fa fa-star-o" data-value="2"></i>
                                                <i class="fa fa-star-o" data-value="4"></i>
                                                <i class="fa fa-star-o" data-value="6"></i>
                                                <i class="fa fa-star-o" data-value="8"></i>
                                                <i class="fa fa-star-o" data-value="10"></i>
                                                <span class="rating-comment">
                                                    <span class="rating-comment-tooltip">Click to rate</span>
                                                </span>
                                            </div>
                                            <select name="rating" class="hide">
                                                <option value="2">2</option>
                                                <option value="4">4</option>
                                                <option value="6">6</option>
                                                <option value="8">8</option>
                                                <option value="10">10</option>
                                            </select>
                                        </div>            
                                        <button type="submit" class="btn btn-inverse btn-lg">Submit Review</button>
                                    </form>
                                </div>
                                <!-- END review-form --> 
                            </div>
                            <!-- END col-5 -->
                        </div>
                        <!-- END row -->
                    </div>
                    <!-- END #property-reviews -->
                </div>
                <!-- END #property-tab-content -->
            </div>
            <!-- END property-tab -->
        </div>
        <!-- END product -->

        <!-- BEGIN similar-product -->
        <h4 class="m-b-15 m-t-30">Nearby Homes</h4>
        <div class="row row-space-10">
            <div class="col-md-3 col-sm-6">
                <!-- BEGIN item -->
                <div class="item item-thumbnail">
                    <a href="product_detail.html" class="item-image">
                        <img src="assets/img/iphone.png" alt="">
                        <div class="discount">15% OFF</div>
                    </a>
                    <div class="item-info">
                        <h4 class="item-title">
                            <a href="product_detail.html">iPhone 6s Plus<br>16GB</a>
                        </h4>
                        <p class="item-desc">3D Touch. 12MP photos. 4K video.</p>
                        <div class="item-price">$649.00</div>
                        <div class="item-discount-price">$739.00</div>
                    </div>
                </div>
                <!-- END item -->
            </div>
            <div class="col-md-3 col-sm-6">
                <!-- BEGIN item -->
                <div class="item item-thumbnail">
                    <a href="product_detail.html" class="item-image">
                        <img src="assets/img/samsung-note5.png" alt="">
                        <div class="discount">32% OFF</div>
                    </a>
                    <div class="item-info">
                        <h4 class="item-title">
                            <a href="product.html">Samsung Galaxy Note 5<br>Black</a>
                        </h4>
                        <p class="item-desc">Super. Computer. Now in two sizes.</p>
                        <div class="item-price">$599.00</div>
                        <div class="item-discount-price">$799.00</div>
                    </div>
                </div>
                <!-- END item -->
            </div>
            <div class="col-md-3 col-sm-6">
                <!-- BEGIN item -->
                <div class="item item-thumbnail">
                    <a href="product_detail.html" class="item-image">
                        <img src="assets/img/iphone-se.png" alt="">
                        <div class="discount">20% OFF</div>
                    </a>
                    <div class="item-info">
                        <h4 class="item-title">
                            <a href="product.html">iPhone SE<br>32/64Gb</a>
                        </h4>
                        <p class="item-desc">A big step for small.</p>
                        <div class="item-price">$499.00</div>
                        <div class="item-discount-price">$599.00</div>
                    </div>
                </div>
                <!-- END item -->
            </div>
            <div class="col-md-3 col-sm-6">
                <!-- BEGIN item -->
                <div class="item item-thumbnail">
                    <a href="product_detail.html" class="item-image">
                        <img src="assets/img/zenfone2.png" alt="">
                        <div class="discount">15% OFF</div>
                    </a>
                    <div class="item-info">
                        <h4 class="item-title">
                            <a href="product_detail.html">Assus ZenFone 2<br>&rlm;(ZE550ML)</a>
                        </h4>
                        <p class="item-desc">See What Others Can’t See</p>
                        <div class="item-price">$399.00</div>
                        <div class="item-discount-price">$453.00</div>
                    </div>
                </div>
                <!-- END item -->
            </div>
        </div>
        <!-- END similar-product -->
    </div>
    <!-- END container -->
</div>