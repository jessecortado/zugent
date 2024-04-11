
<!-- SIPjs js/sip-0.11.3.js -->
<!-- <script src="assets/plugins/select2/dist/js/select2.min.js"></script> -->
<!-- /SIPjs -->

<style type="text/css">
    .theme-panel {
        width: 420px;
        right: -420px;
        height: 215px;
        top: unset;
        bottom: 5%;
    }
    .theme-panel .theme-collapse-btn {
        left: -32px;
        bottom: 0;
        width: 32px;
        height: 180px;
        font-weight: bold;
        color: #fff;
        background: #00acac;
        border-radius: 8px 0 0 8px;
        writing-mode: tb-rl;
        /* transform: rotate(180deg); */
    }
    .btn.btn-icon.btn-lg {
        font-size: 24px;
    }
    ul.theme-list .btn:not(.btn-scroll-to-top) .fa,
    ul.theme-list .btn:not(.btn-scroll-to-top) .glyphicon {
        margin-right: 0; 
        width: 100%;
    }
    a.theme-collapse-btn:focus, a.theme-collapse-btn:hover {
        text-decoration: none;
    }
    .dialer-timer {
        text-align: right;
    }
    .dialer-timer .call-status {
        color: #000;
    }
    .dialer-timer #call-timer {
        font-size: 24px;
    }
    .contact-details b {
        display: block;
    }
    .theme-panel.active .theme-collapse-btn .fa:before {
        content: '\f101';
    }
</style>

<!-- begin theme-panel -->
<div class="theme-panel">
    <a href="javascript:;" data-click="theme-panel-expand" class="theme-collapse-btn dialer-status">
        <i class="fa fa-angle-double-left m-b-10"></i>DISCONNECTED
    </a>
    
    <div class="theme-panel-content">
        <!-- <h5 class="m-t-0"><b>RUOPEN Dialer</b></h5> -->
        <ul class="theme-list">
            <li>
                <a href="javascript:;" class="btn btn-primary btn-icon btn-circle btn-lg" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Call"><i class="fa fa-phone"></i>&nbsp;</a>
            </li>
            <li>
                <a href="javascript:;" class="btn btn-info btn-icon btn-circle btn-lg" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Call"><i class="fa fa-phone"></i>&nbsp;</a>
            </li>
            <li>
                <a href="javascript:;" class="btn btn-success btn-icon btn-circle btn-lg" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Call"><i class="fa fa-phone"></i>&nbsp;</a>
            </li>
            <li>
                <a href="javascript:;" class="btn btn-warning btn-icon btn-circle btn-lg" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Call"><i class="fa fa-phone"></i>&nbsp;</a>
            </li>
            <li>
                <a href="javascript:;" class="btn btn-danger btn-icon btn-circle btn-lg" data-toggle="tooltip" data-trigger="hover" data-container="body" data-title="Call"><i class="fa fa-phone"></i>&nbsp;</a>
            </li>
        </ul>
        <div class="row dialer-timer">
            <div class="col-md-6 control-label double-line call-status"><b>Call Status</b></div>
            <div class="col-md-6 control-label double-line" id="call-timer"><b>00:00:00</b></div>
        </div>
        <div class="divider"></div>
        <div class="row m-t-10 contact-details">
            <div class="col-md-5 control-label double-line">
                <b>Name:</b>
                <b>Phone:</b>
                <b>Email:</b>
                <b>Address:</b>
            </div>
            <div class="col-md-7">
                <b>Contact Name</b>
                <b>Contact Phone</b>
                <b>Contact Email</b>
                <b>Contact Address</b>
            </div>
        </div>
        <!-- <div class="row m-t-10">
            <div class="col-md-5 control-label">Header</div>
            <div class="col-md-7">
                <select name="header-fixed" class="form-control form-control-sm">
                    <option value="1">fixed</option>
                    <option value="2">default</option>
                </select>
            </div>
        </div> -->
        <div class="row m-t-10">
            <div class="col-md-12">
                <a href="javascript:;" class="btn btn-success btn-block btn-sm" id="xCall">Call</a>
            </div>
        </div>
    </div>
</div>
<!-- end theme-panel -->


<script type="text/javascript">
    // initialize your variables outside the function 
    var count = 0;
    var clearTime;
    var seconds = 0, minutes = 0, hours = 0;
    var clearState;
    var secs, mins, gethours;

    function startWatch() {
        /* check if seconds is equal to 60 and add a +1 to minutes, and set seconds to 0 */
        if ( seconds === 60 ) { seconds = 0; minutes = minutes + 1; }
        /* you use the javascript tenary operator to format how the minutes should look and add 0 to minutes if less than 10 */
        mins = ( minutes < 10 ) ? ( '0' + minutes + ': ' ) : ( minutes + ': ' );
        /* check if minutes is equal to 60 and add a +1 to hours set minutes to 0 */
        if ( minutes === 60 ) { minutes = 0; hours = hours + 1; } 
        /* you use the javascript tenary operator to format how the hours should look and add 0 to hours if less than 10 */
        gethours = ( hours < 10 ) ? ( '0' + hours + ': ' ) : ( hours + ': ' ); secs = ( seconds < 10 ) ? ( '0' + seconds ) : ( seconds );
        // display the stopwatch 
        var x = document .getElementById("timer"); x.innerHTML = 'Time: ' + gethours + mins + secs;
        /* call the seconds counter after displaying the stop watch and increment seconds by +1 to keep it counting */
        seconds++;
        /* call the setTimeout() to keep the stop watch alive ! */
        clearTime = setTimeout( "startWatch( )", 1000 );
    }

    // startWatch() //create a function to start the stop watch 
    function startTime() {
        /* check if seconds, minutes, and hours are equal to zero and start the stop watch */
        if (seconds === 0 && minutes === 0 && hours === 0) { 
            /* hide the fulltime when the stop watch is running */
            var fulltime = document.getElementById("call-timer");
            fulltime.style.display = "none"; /* hide the start button if the stop watch is running */
            this.style.display = "none";
            /* call the startWatch( ) function to execute the stop watch whenever the startTime( ) is triggered */
            startWatch();
        } 
        // 
    }  startTime()

    /* you need to bind the startTime() function to any event type to keep the stop watch alive ! */
    window.addEventListener( 'load', function () {
        var start = document .getElementById("start");
        start.addEventListener( 'click', startTime );
    });

</script>