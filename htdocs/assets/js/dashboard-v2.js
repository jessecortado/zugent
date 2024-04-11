/*
Template Name: Color Admin - Responsive Admin Dashboard Template build with Twitter Bootstrap 3.3.7
Version: 2.1.0
Author: Sean Ngu
Website: http://www.seantheme.com/color-admin-v2.1/admin/html/
*/

var getMonthName = function(number) {
    var month = [];
    month[0] = "January";
    month[1] = "February";
    month[2] = "March";
    month[3] = "April";
    month[4] = "May";
    month[5] = "Jun";
    month[6] = "July";
    month[7] = "August";
    month[8] = "September";
    month[9] = "October";
    month[10] = "November";
    month[11] = "December";
    
    return month[number];
};

var getDate = function(date) {
    var currentDate = new Date(date);
    var dd = currentDate.getDate();
    var mm = currentDate.getMonth() + 1;
    var yyyy = currentDate.getFullYear();
    
    if (dd < 10) {
        dd = '0' + dd;
    }
    if (mm < 10) {
        mm = '0' + mm;
    }
    currentDate = yyyy+'-'+mm+'-'+dd;
    
    return currentDate;
};

var handleVisitorsLineChart = function() {
    var green = '#0D888B';
    var greenLight = '#00ACAC';
    var blue = '#3273B1';
    var purple = '#727cb6';
	var black='#2d353c';
    var blueLight = '#348FE2';
    var red='#ff5b57';
    var orange='#f59c1a';

//    var blackTransparent = 'rgba(0,0,0,0.6)';

    var whiteTransparent = 'rgba(255,255,255,0.4)';
    var purpleTransparent = 'rgba(114,124,182,1)';
	var blackTransparent = 'rgba(45,53,60,1)';
	var orangeTransparent = 'rgba(245, 156, 26, 1)';
	var redTransparent = 'rgba(255, 91, 87, 1)';
	
    Morris.Line({
        element: 'visitors-line-chart',
        data: [
            {x: '2016-02-01', y: 60, z: 70, a: 10, b: 6},
            {x: '2016-03-01', y: 70, z: 40, a: 1, b: 6},
            {x: '2016-04-01', y: 40, z: 10, a: 10, b: 6},
            {x: '2016-05-01', y: 100, z: 70, a: 10, b: 6},
            {x: '2016-06-01', y: 40, z: 10, a: 10, b: 6},
            {x: '2016-07-01', y: 80, z: 50, a: 10, b: 6},
            {x: '2016-08-01', y: 70, z: 40, a: 10, b: 6},
            {x: '2016-09-01', y: 70, z: 40, a: 10, b: 6},
            {x: '2016-10-01', y: 70, z: 40, a: 10, b: 6},
            {x: '2016-11-01', y: 70, z: 40, a: 10, b: 6},
            {x: '2016-12-01', y: 70, z: 40, a: 10, b: 6},
            {x: '2017-01-01', y: 70, z: 40, a: 10, b: 6},
            {x: '2017-02-01', y: 70, z: 40, a: 10, b: 6}
        ],
        xkey: 'x',
        ykeys: ['y', 'z', 'a', 'b'],
        xLabelFormat: function(x) {
            x = getMonthName(x.getMonth());
            return x.toString();
        },
        labels: ['Personal Site', 'Brokerage Site','Expired or Cancelled','RedX'],
        lineColors: [green, blue, purple, red],
        pointFillColors: [greenLight, blueLight, purpleTransparent, redTransparent],
        lineWidth: '2px',
        pointStrokeColors: [blackTransparent, blackTransparent, blackTransparent, blackTransparent],
        resize: true,
        gridTextFamily: 'Open Sans',
        gridTextColor: whiteTransparent,
        gridTextWeight: 'normal',
        gridTextSize: '11px',
        gridLineColor: 'rgba(0,0,0,0.5)',
        hideHover: 'auto',
    });
};

var handleVisitorsDonutChart = function() {
    var green = '#00acac';
    var blue = '#348fe2';
    Morris.Donut({
        element: 'visitors-donut-chart',
        data: [
            {label: "New Visitors", value: 900},
            {label: "Return Visitors", value: 1200}
        ],
        colors: [green, blue],
        labelFamily: 'Open Sans',
        labelColor: 'rgba(255,255,255,0.4)',
        labelTextSize: '12px',
        backgroundColor: '#242a30'
    });
};

var handleVisitorsVectorMap = function() {
    if ($('#visitors-map').length !== 0) {
        $('#visitors-map').vectorMap({
            map: 'world_merc_en',
            scaleColors: ['#e74c3c', '#0071a4'],
            container: $('#visitors-map'),
            normalizeFunction: 'linear',
            hoverOpacity: 0.5,
            hoverColor: false,
            markerStyle: {
                initial: {
                    fill: '#4cabc7',
                    stroke: 'transparent',
                    r: 3
                }
            },
            regions: [{
                attribute: 'fill'
            }],
            regionStyle: {
                initial: {
                    fill: 'rgb(97,109,125)',
                    "fill-opacity": 1,
                    stroke: 'none',
                    "stroke-width": 0.4,
                    "stroke-opacity": 1
                },
                hover: {
                    "fill-opacity": 0.8
                },
                selected: {
                    fill: 'yellow'
                },
                selectedHover: {
                }
            },
            series: {
                regions: [{
                values: {
                    IN:'#00acac',
                    US:'#00acac',
                    KR:'#00acac'
                }
                }]
            },
            focusOn: {
                x: 0.5,
                y: 0.5,
                scale: 2
            },
            backgroundColor: '#2d353c'
        });
    }
};

var handleScheduleCalendar = function() {
    var monthNames = ["January", "February", "March", "April", "May", "June",  "July", "August", "September", "October", "November", "December"];
    var dayNames = ["S", "M", "T", "W", "T", "F", "S"];

    var now = new Date(),
        month = now.getMonth() + 1,
        year = now.getFullYear();

    var events = [
        [
            '2/' + month + '/' + year,
            'Popover Title',
            '#',
            '#00acac',
            'Some contents here'
        ],
        [
            '5/' + month + '/' + year,
            'Tooltip with link',
            'http://www.seantheme.com/color-admin-v1.3',
            '#2d353c'
        ],
        [
            '18/' + month + '/' + year,
            'Popover with HTML Content',
            '#',
            '#2d353c',
            'Some contents here <div class="text-right"><a href="http://www.google.com">view more >>></a></div>'
        ],
        [
            '28/' + month + '/' + year,
            'Color Admin V1.3 Launched',
            'http://www.seantheme.com/color-admin-v1.3',
            '#2d353c',
        ]
    ];
    var calendarTarget = $('#schedule-calendar');
    $(calendarTarget).calendar({
        months: monthNames,
        days: dayNames,
        events: events,
        popover_options:{
            placement: 'top',
            html: true
        }
    });
    $(calendarTarget).find('td.event').each(function() {
        var backgroundColor = $(this).css('background-color');
        $(this).removeAttr('style');
        $(this).find('a').css('background-color', backgroundColor);
    });
    $(calendarTarget).find('.icon-arrow-left, .icon-arrow-right').parent().on('click', function() {
        $(calendarTarget).find('td.event').each(function() {
            var backgroundColor = $(this).css('background-color');
            $(this).removeAttr('style');
            $(this).find('a').css('background-color', backgroundColor);
        });
    });
};

var handleDashboardGritterNotification = function() {
    $(window).load(function() {
        setTimeout(function() {
            $.gritter.add({
                title: 'Welcome back, Admin!',
                text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed tempus lacus ut lectus rutrum placerat.',
                image: 'assets/img/user-14.jpg',
                sticky: true,
                time: '',
                class_name: 'my-sticky-class'
            });
        }, 1000);
    });
};

var DashboardV2 = function () {
	"use strict";
    return {
        //main function
        init: function () {
            handleVisitorsLineChart();
            handleVisitorsDonutChart();
            handleVisitorsVectorMap();
            handleScheduleCalendar();
            // handleDashboardGritterNotification();
        }
    };
}();