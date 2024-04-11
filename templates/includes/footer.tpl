
		<!-- begin scroll to top btn -->
		<a href="javascript:;" class="btn btn-icon btn-circle btn-success btn-scroll-to-top fade" data-click="scroll-top"><i class="fa fa-angle-up"></i></a>
		<!-- end scroll to top btn -->
	</div>
	<!-- end page container -->


    {if !isset($footer_line)}
	<div class="clearfix">&nbsp;</div>
	<div id="footer" class="footer">
        &copy;2016-{'Y'|date} AJ2, LLC. All Right Reserved
	</div>
    {/if}
	
	<!-- ================== BEGIN BASE JS ================== -->
	<script src="assets/plugins/jquery/jquery-1.9.1.min.js"></script>
	<script src="assets/plugins/jquery/jquery-migrate-1.1.0.min.js"></script>
	<script src="assets/plugins/jquery-ui/ui/minified/jquery-ui.min.js"></script>
	<script src="assets/plugins/bootstrap/js/bootstrap.min.js"></script>
	<!--[if lt IE 9]>
		<script src="assets/crossbrowserjs/html5shiv.js"></script>
		<script src="assets/crossbrowserjs/respond.min.js"></script>
		<script src="assets/crossbrowserjs/excanvas.min.js"></script>
	<![endif]-->
	<script src="assets/plugins/slimscroll/jquery.slimscroll.min.js"></script>
	<script src="assets/plugins/jquery-cookie/jquery.cookie.js"></script>
	<!-- ================== END BASE JS ================== -->

    <script src="assets/js/jquery.mask.js"></script>
	<script src="assets/plugins/parsley/dist/parsley.js"></script>
	<script src="assets/js/apps.js"></script>
    <script src="assets/js/custom.js"></script>

	<script type="text/javascript">
		$(document).ready(function() {
			App.init();
			$('.phone-us').mask('(000) 000-0000');
			$('[name="zip"]').mask('99999');
		});
	</script>

	<script type="text/javascript">
		$(document).ready(function() {
			$("#finish-impersonation").on("click", function() {

            $.ajax({
                type: "POST",
                url: '/ws/user/finish_impersonation',
                dataType: "json",
                success: function(result) {

                    if(result) {
                        console.log(result);
                        window.location = "user_view.php?id={$user.user_id}";
                    }

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });

        	});
		});
	</script>

    {if isset($footer_js)}
        {include file=$footer_js}
    {/if}

</body>
</html>
