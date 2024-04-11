<div id="subscribe" class="section-container bg-silver p-t-30 p-b-30">
    <!-- BEGIN container -->
    <div class="container">
        <!-- BEGIN row -->
        <div class="row">
            <!-- BEGIN col-6 -->
            <div class="col-md-6 col-sm-6">
                <!-- BEGIN subscription -->
                <div class="subscription">
                    <div class="subscription-intro">
                        <h4> LET'S STAY IN TOUCH</h4>
                        <p>Get updates on sales specials and more</p>
                    </div>
                    <div class="subscription-form">
                        <form name="subscription_form" method="POST">
                            <div class="input-group">
                                <input type="text" class="form-control" name="email" placeholder="Enter Email Address">
                                <div class="input-group-btn">
                                    <button type="submit" class="btn btn-inverse"><i class="fa fa-angle-right"></i></button>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
                <!-- END subscription -->
            </div>
            <!-- END col-6 -->
            <!-- BEGIN col-6 -->
            <div class="col-md-6 col-sm-6">
                <!-- BEGIN social -->
                <div class="social">
                    <div class="social-intro">
                        <h4>FOLLOW US</h4>
                        <p>We want to hear from you!</p>
                    </div>
                    <div class="social-list">
                        {if $company_settings.facebook ne ''}<a href="https://www.facebook.com/{$company_settings.facebook}"><i class="fa fa-facebook"></i></a>{/if}
                        {if $company_settings.twitter ne ''}<a href="https://twitter.com/{$company_settings.twitter}"><i class="fa fa-twitter"></i></a>{/if}
                        {if $company_settings.gmail ne ''}<a href="https://plus.google.com/u/0/{$company_settings.gmail}"><i class="fa fa-google-plus"></i></a>{/if}
                        {if $company_settings.instagram ne ''}<a href="https://www.instagram.com/{$company_settings.instagram}"><i class="fa fa-instagram"></i></a>{/if}
                    </div>
                </div>
                <!-- END social -->
            </div>
            <!-- END col-6 -->
        </div>
        <!-- END row -->
    </div>
    <!-- END container -->
</div>

<div id="footer" class="footer">
    <!-- BEGIN container -->
    <div class="container">
        <!-- BEGIN row -->
        <div class="row">
            <!-- BEGIN col-3 -->
            <div class="col-md-3">
                <h4 class="footer-header">ABOUT US</h4>
                {if $company_settings.about_us ne ''}
                {$company_settings.about_us}
                {else}
                <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed nec tristique dolor, ac efficitur velit. Nulla lobortis tempus convallis. Nulla aliquam lectus eu porta pulvinar. Mauris semper justo erat. Vestibulum porttitor lorem et vestibulum pharetra. Phasellus sit amet mi congue, hendrerit mi ut, dignissim eros.</p>
                {/if}
            </div>
            <!-- END col-3 -->
            <!-- BEGIN col-3 -->
            <div class="col-md-3">
                <h4 class="footer-header">RELATED LINKS</h4>
                <ul class="fa-ul">
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Shopping Help</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Terms of Use</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Contact Us</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Careers</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Payment Method</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Sales &amp; Refund</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Sitemap</a></li>
                    <li><i class="fa fa-li fa-angle-right"></i> <a href="#">Privacy &amp; Policy</a></li>
                </ul>
            </div>
            <!-- END col-3 -->
            <!-- BEGIN col-3 -->
            <div class="col-md-3">
                <h4 class="footer-header">LATEST PRODUCT</h4>
                <ul class="list-unstyled list-product">
                    <li>
                        <div class="image">
                            <img src="assets/img/iphone-6s.jpg" alt="">
                        </div>
                        <div class="info">
                            <h4 class="info-title">Iphone 6s</h4>
                            <div class="price">$1200.00</div>
                        </div>
                    </li>
                    <li>
                        <div class="image">
                            <img src="assets/img/galaxy-s6.jpg" alt="">
                        </div>
                        <div class="info">
                            <h4 class="info-title">Samsung Galaxy s7</h4>
                            <div class="price">$850.00</div>
                        </div>
                    </li>
                
                    <li>
                        <div class="image">
                            <img src="assets/img/ipad-pro.jpg" alt="">
                        </div>
                        <div class="info">
                            <h4 class="info-title">Ipad Pro</h4>
                            <div class="price">$800.00</div>
                        </div>
                    </li>
                </ul>
            </div>
            <!-- END col-3 -->
            <!-- BEGIN col-3 -->
            <div class="col-md-3">
                <h4 class="footer-header">OUR CONTACT</h4>
                <address>
                    <strong>{$company_data.company_name}</strong><br>
                    {$company_data.street_address}<br>
                    {if $company_data.city ne ''}{$company_data.city}, {/if}{if $company_data.state ne ''}{$company_data.state}{/if} {if $company_data.zip ne ''}{$company_data.zip}{/if}<br><br>
                    <abbr title="Phone">Phone:</abbr> {$company_data.phone_office}<br>
                    <abbr title="Fax">Fax:</abbr> {$company_data.phone_fax}<br>
                    <abbr title="Email">Email:</abbr> <a href="mailto:{$company_data.email_footer_line_1}">{$company_data.email_footer_line_1}</a><br>
                </address>
            </div>
            <!-- END col-3 -->
        </div>
        <!-- END row -->
    </div>
    <!-- END container -->
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