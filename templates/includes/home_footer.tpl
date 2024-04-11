        
        <!-- begin #footer -->
        <div id="footer" class="footer">
            <div class="container">
                <!-- <div class="footer-brand">
                    <div class="footer-brand-logo"></div>
                    Color Admin
                </div> -->
                <p>
                    &copy; 2017 RUOPEN
                </p>
                <p class="social-list">
                    <a href="#"><i class="fa fa-facebook fa-fw"></i></a>
                    <a href="#"><i class="fa fa-instagram fa-fw"></i></a>
                    <a href="#"><i class="fa fa-twitter fa-fw"></i></a>
                    <a href="#"><i class="fa fa-google-plus fa-fw"></i></a>
                    <a href="#"><i class="fa fa-dribbble fa-fw"></i></a>
                </p>
            </div>
        </div>
    </div>
    <!-- end #page-container -->
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/jquery/jquery-1.9.1.min.js"></script>
	<script src="assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
	<script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
		<script src="assets/crossbrowserjs/html5shiv.js"></script>
		<script src="assets/crossbrowserjs/respond.min.js"></script>
		<script src="assets/crossbrowserjs/excanvas.min.js"></script>
	<![endif]-->
	<script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
	<script src="assets/plugins/scrollMonitor/scrollMonitor.js"></script>
	<script src="assets/js/home_apps.min.js"></script>
	<!-- ================== END BASE JS ================== -->
    
    {if isset($footer_js)}
        {include file=$footer_js}
    {/if}
    
    <script src="assets/js/custom.js"></script>
	
	<script>    
	    $(document).ready(function() {
	        App.init();

            ready_contact_form();

	    });
	</script>
</body>
</html>