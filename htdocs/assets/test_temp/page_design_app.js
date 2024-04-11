$.cssHooks.backgroundColor = {
    get: function (elem) {
        if (elem.currentStyle)
            var bg = elem.currentStyle["background-color"];
        else if (window.getComputedStyle)
            var bg = document.defaultView.getComputedStyle(elem,
                    null).getPropertyValue("background-color");
        if (bg.search("rgb") == -1)
            return bg;
        else {
            bg = bg.match(/^rgb\((\d+),\s*(\d+),\s*(\d+)\)$/);
            function hex(x) {
                return ("0" + parseInt(x).toString(16)).slice(-2);
            }

        }
    }
}

'use strict';
//Make sure jQuery has been loaded before app.js
if (typeof jQuery === "undefined") {
    throw new Error("HtmlEditor requires jQuery");
}


$(function () {
    //Set up the object
    _init();
});

/* ----------------------------------
 * ----------------------------------
 * All HTMLeditor functions are implemented below.
 */


function _init() {

    $(window).resize(function () {
        // $("#page-design").css("min-height", $(window).height() - 90);
        $(".htmlpage").css("min-height", $(window).height() - 160)
    });

    tinymce.init({
        menubar: false,
        force_br_newlines: true,
        extended_valid_elements : "*[*]",
        valid_elements: "*[*]",
        selector: "#html5editor",
        plugins: [
            "advlist autolink lists link charmap anchor",
            "visualblocks code ",
            "insertdatetime  table contextmenu paste textcolor colorpicker"
        ],
        toolbar: "styleselect | bold italic |  forecolor backcolor |alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link code",
    });

    tinymce.init({
        menubar: false,
        force_br_newlines: false,
        force_p_newlines: false,
        forced_root_block: '',
        extended_valid_elements : "*[*]",
    valid_elements: "*[*]",
        selector: "#html5editorLite",
        plugins: [
        ],
        toolbar: "forecolor backcolor | alignleft aligncenter alignright alignjustify code",
    });

    
    // $("#page-design").css("min-height", $(window).height() - 90);

    $(".htmlpage").css("min-height", $(window).height() - 160);

    // $(".htmlpage").sortable({connectWith: ".lyrow", opacity: .35, handle: ".drag"});

    $(".htmlpage, .htmlpage .column").sortable({connectWith: ".column", opacity: .35, handle: ".drag"});

    $(".sidebar-nav .lyrow").draggable({connectToSortable: ".htmlpage", helper: "clone",  drag: function (e, t) {
        t.helper.width(400)
    }, stop: function (e, t) {
        $(".htmlpage .column").sortable({opacity: .35, connectWith: ".column"})
    }});

    $(".sidebar-nav .box").draggable({connectToSortable: ".column", helper: "clone", handle: ".preview", drag: function (e, t) {
        t.helper.width(400)
    }, stop: function (e, t) {
        /* if ( t.helper.data('type')==="map"|| t.helper.data('type')==="youtube" ) {
         var iframe = t.helper.find('div.view > iframe');

         var iframeId = iframe.assignId();
         $('#'+iframeId).attr('src',iframe.data('url'));
         }
         */

    }});

    $('.sidebar-minify-btn[data-click="sidebar-minify"]').on('click', function() {
        if ($(".sidebar-nav").hasClass("nav-minified")) {
            $(".sidebar-nav").removeClass('nav-minified');
        }
        else {
            $(".sidebar-nav").addClass('nav-minified');
        }
    });


    $(document).on('click', 'a.settings', function (e) {
        e.preventDefault();
        var _s = $(this);

        var part_id = _s.parent().parent().assignId();

        var part = _s.parent().parent();
        var column = _s.parent().parent().parent('.column');
        var row = _s.parent().parent().parent().parent('.row');

        prepareEditor(part, row, column);
        $('#module-details').show();
    });

    $(document).on('click', 'a.setup', function (e) {
        e.preventDefault();
        var _s = $(this);

        var part_id = _s.parent().parent().assignId();

        var part = _s.parent().parent();
        var column = _s.parent().parent().parent('.column');
        var row = _s.parent().parent().parent().parent('.row');

        prepareEditor(part, row, column);
        $('#module-details').hide();
    });

    $('a.btnpropa').on('click', function () {
        var rel = $(this).attr('rel');
        $('#buttonContainer a.btn').removeClass('btn-default')
                .removeClass('btn-success')
                .removeClass('btn-info')
                .removeClass('btn-danger')
                .removeClass('btn-info')
                .removeClass('btn-primary')
                .removeClass('btn-link')
                .addClass(rel);

    });

    $('a.btnpropb').on('click', function () {
        var rel = $(this).attr('rel');
        $('#buttonContainer a.btn').removeClass('btn-lg')
                .removeClass('btn-md')
                .removeClass('btn-sm')
                .removeClass('btn-xs')
                .addClass(rel);

    });

    $('a.btnprop').on('click', function () {
        var rel = $(this).attr('rel');
        $('#buttonContainer a.btn').toggleClass(rel);

    });

    $('#preferences').on('hidden.bs.modal', function () {
        $('#map').hide();
        $('#image').hide();
        $('#text').hide();
        $('#hot-home').hide();
    });

    $("#save").click(function (e) {
        downloadLayoutSrc();
    });

    $("#clear").click(function (e) {
        e.preventDefault();
        clearDemo()
    });

    $("#devpreview").click(function () {
        $("#page-design").removeClass("edit sourcepreview");
        $("#page-design").addClass("devpreview");
        removeMenuClasses();
        $(this).addClass("active");
        return false
    });

    $("#edit").click(function () {
        $("#page-design").removeClass("devpreview sourcepreview");
        $("#page-design #frameView").removeClass("tablet mobile");
        $("#page-design .container-fluid").removeClass("hide");
        $('#preview-btns button').removeClass('active');
        $("#preview-btns").removeClass("reveal");
        $("#page-design").addClass("edit");
        $("#page-design #frameView").addClass("hide");
        $("#save").prop('disabled', false);
        removeMenuClasses();
        $(this).addClass("active");
        return false
    });

    $('#gallery').click(function(){
        $('#thepref').slideUp();
        $('#mediagallery').slideDown();
    });

    $("#sourcepreview").click(function () {
        document.getElementById('frameView').contentWindow.location.reload();
        $('#pc').addClass('active');
        $("#page-design").removeClass("edit");
        $("#page-design #frameView").removeClass("hide");
        $("#page-design").addClass("devpreview sourcepreview");
        $("#preview-btns").addClass("reveal");
        $("#page-design .container-fluid").addClass("hide");
        $("#save").prop('disabled', true);
        removeMenuClasses();
        $(this).addClass("active");
        return false
    });

    $('#pc').click(function () {
        $("#page-design #frameView").removeClass("tablet mobile");
        $('#preview-btns button').removeClass('active');
        $(this).addClass('active');
    });

    $('#mobile').click(function () {
        $("#page-design #frameView").removeClass("tablet");
        $('#preview-btns button').removeClass('active');
        $(this).addClass('active');
        $("#page-design #frameView").addClass("mobile");
    });

    $('#tablet').click(function () {
        $("#page-design #frameView").removeClass("mobile");
        $('#preview-btns button').removeClass('active');
        $(this).addClass('active');
        $("#page-design #frameView").addClass("tablet");
    });

    $(".nav-header").click(function () {
        $(".sidebar-nav .boxes, .sidebar-nav .rows").hide();
        $(this).next().slideDown()
    });

    removeElm();
    gridSystemGenerator();

}

function prepareEditor(part, row, column) {
    var clone = part.clone();
    var confirm = $('#applyChanges');
    $('#preferencesTitle').html(part.data('title'));

    $('.column .box').removeClass('active');
    part.addClass('active');
    confirm.unbind('click');

    var clonedPart = clone.find('div.view').html();
    var type = part.data('type');
    var panel = $('#Settings');

    var o = part.find('div.view').children();
    var oid = o.assignId();

    $('#id').val(oid);
    $('#class').val(o.parent().parent().css('class'));
    $('#class').parent().show();
    $('#id').parent().show();
    
    switch (type) {
        
        case 'custom':

            var editor = tinyMCE.get('html5editor');
            editor.setContent(clonedPart);
            $('#text').show();

            var o = part.find('div.view');
            confirm.bind('click', function (e) {
                e.preventDefault();
                o.html(editor.getContent());
                o.attr('id', $('#id').val());

                $.ajax({
                    type: "POST",
                    url: '/ws/page/save_settings',
                    data: {
                        'action': 'percol',
                        'column': 'footer_line',
                        'value': editor.getContent().replace(/(<([^>]+)>)/ig,"")
                    },
                    dataType: "json",
                    success: function(result) {
                        o.html(editor.getContent().replace(/(<([^>]+)>)/ig,""));
                        o.attr('id', $('#id').val());
                        flash_alert('#alert_success', 'Successfully updated footer line.');
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            });

            break;

        case 'about-us':

            var editor = tinyMCE.get('html5editor');
            editor.setContent(clonedPart);
            $('#text').show();

            var o = part.find('div.view p');
            confirm.bind('click', function (e) {
                e.preventDefault();

                $.ajax({
                    type: "POST",
                    url: '/ws/page/save_settings',
                    data: {
                        'action': 'percol',
                        'column': 'about_us',
                        'value': editor.getContent().replace(/(<([^>]+)>)/ig,"")
                    },
                    dataType: "json",
                    success: function(result) {
                        if(result) {
                            o.html(editor.getContent().replace(/(<([^>]+)>)/ig,""));
                            o.attr('id', $('#id').val());
                            flash_alert('#alert_success', 'Successfully updated about us.');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            });

            break;

        case 'footer-text':

            var editor = tinyMCE.get('html5editor');
            editor.setContent(clonedPart);
            $('#text').show();

            var o = part.find('div.view');
            confirm.bind('click', function (e) {
                e.preventDefault();

                $.ajax({
                    type: "POST",
                    url: '/ws/page/save_settings',
                    data: {
                        'action': 'percol',
                        'column': 'footer_line',
                        'value': editor.getContent().replace(/(<([^>]+)>)/ig,"")
                    },
                    dataType: "json",
                    success: function(result) {
                        if(result) {
                            o.html(editor.getContent().replace(/(<([^>]+)>)/ig,""));
                            o.attr('id', $('#id').val());
                            flash_alert('#alert_success', 'Successfully updated footer line.');
                        }
                    },
                    error: function (XMLHttpRequest, textStatus, errorThrown) {
                        console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                    }
                });
            });

            break;

        case 'header':
            var editor = tinyMCE.get('html5editor');
            editor.setContent(clonedPart);
            $('#text').show();

            var o = part.find('div.view');
            confirm.bind('click', function (e) {
                e.preventDefault();
                alert(o);
                o.html(editor.getContent());
                o.attr('id', $('#id').val());
            });

            break;
        
        case 'paragraph':

            var editor = tinyMCE.get('html5editor');
            editor.setContent(clonedPart);
            $('#text').show();

            var o = part.find('div.view p');
            confirm.bind('click', function (e) {
                e.preventDefault();
                o.html(editor.getContent().replace(/(<([^>]+)>)/ig,""));
                o.attr('id', $('#id').val());
            });

            break;

        case 'image':
            var img = part.find('img');

            $('#imgContent').html(img.clone().attr('width', '200'));
            $('#img-url').val(img.attr('src'));
            $('#img-width').val(img.innerWidth());
            $('#img-height').val(img.innerHeight());
            $('#img-title').val(img.attr('title'));
            $('#class').val(img.attr('class'));
            $('#img-rel').val(img.attr('rel'));
            $('#img-title').val(img.attr('title'));
            // $('#img-clickurl').val(img.attr('onClick'));
            $('#image').show();

            confirm.bind('click', function (e) {
                e.preventDefault();
                img.attr('title', $('#img-title').val());
                img.attr('src', $('#img-url').val());
                img.css('width', $('#img-width').val());
                img.css('height', $('#img-height').val());
                img.attr('class', $('#class').val());
                img.attr('rel', $('#img-rel').val());
                //    img.attr('onClick', $('#img-clickurl').val());
                o.attr('id', $('#id').val());
                o.removeClass();
            });

            break;

        case 'map' :
            var iframe = part.find('iframe');
            var c = iframe.clone();
            $('#map-content').html(c.attr('width', '100%'));
            $('#address');
            $('#map').show();
            $('#map-width').val(iframe.innerWidth());
            $('#map-height').val(iframe.innerHeight());
            var url = iframe.attr('src');
            var latlon = gup('q', url).split(',');
            var z = gup('z', url);

            $('#latitude').val(latlon[0]);
            $('#longitude').val(latlon[1]);
            $('#zoom').val(z);

            //http://maps.google.com/maps?q=12.927923,77.627108&z=15&output=embed
            $('#latitude, #longitude, #zoom').change(function () {
                c.attr('src', 'https://maps.google.com/maps?q=' + $('#latitude').val() + ',' + $('#longitude').val() + '&z=' + $('#zoom').val() + '&output=embed');
            });

            confirm.bind('click', function (e) {
                e.preventDefault();
                iframe.css('width', $('#map-width').val());
                iframe.css('height', $('#map-height').val());
                iframe.attr('src', 'https://maps.google.com/maps?q=' + $('#latitude').val() + ',' + $('#longitude').val() + '&z=' + $('#zoom').val() + '&output=embed');
                o.attr('id', $('#id').val());
            });

            break;
        
        case 'hot-home':
            $('#hot-home-content').val(o.children('#hh-content').text());
            $('#hot-home-link').val(o.children('#hh-link').attr('href'));
            $('#hot-home').show();

            confirm.bind('click', function (e) {
                e.preventDefault();
                console.log(o);
                o.children('#hh-content').html($('#hot-home-content').val());
                o.children('#hh-link').attr("href", $('#hot-home-link').val());
                o.attr('id', $('#id').val());
            });

            break;
    }
    
    $('#preferences').modal('show');
}

$(document).on('focusin', function(e) {
    if ($(event.target).closest(".mce-window").length) {
        e.stopImmediatePropagation();
    }
});

function flash_alert(element, msg) {
    $('#alert_error').addClass('hide');
    $(element+' span#msg').text(msg);
    $(element).removeClass('hide');
    $(element).css('opacity', '1');
    $(element).css('display', 'block');
    window.setTimeout(function() {
      $(element).fadeTo(500, 0).slideUp(500, function(){
          $(element).addClass('hide');
      });
    }, 2000);
}

function handleSaveLayout() {
    var e = $(".htmlpage").html();
    if (e != window.htmlpageHtml) {
        saveLayout();
        window.htmlpageHtml = e
    }
}

function gridSystemGenerator() {
    $(".lyrow .preview input").bind("keyup", function () {
        var e = 0;
        var t = "";
        var n = false;
        var r = $(this).val().split(" ", 12);
        $.each(r, function (r, i) {
            if (!n) {
                if (parseInt(i) <= 0)
                    n = true;
                e = e + parseInt(i);
                t += '<div class="col-md-' + i + ' column"></div>'
            }
        });
        if (e == 12 && !n) {
            $(this).parent().next().children().html(t);
            $(this).parent().find('.drag').show()
        } else {
            $(this).parent().find('.drag').hide()
        }
    })
}

function removeElm() {
    $(".htmlpage").delegate(".remove", "click", function (e) {
        e.preventDefault();
        var elem = $(this);

        swal({
            title: 'Are you sure?',
            type: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33',
            confirmButtonText: 'Yes, delete it!',
            cancelButtonText: 'No, cancel!',
            confirmButtonClass: 'btn btn-sm btn-success m-r-5',
            cancelButtonClass: 'btn btn-sm btn-danger',
            buttonsStyling: false,
            allowOutsideClick: false
        }).then(function () {
            elem.parent().remove();

            if (!$(".htmlpage .lyrow").length > 0) {
                clearDemo();
            }
        }, function (dismiss) {});
    })
}

function clearDemo() {
    $(".htmlpage").empty()
}

function removeMenuClasses() {
    $("#menu-htmleditor li button").removeClass("active")
}

function changeStructure(e, t) {
    $("#download-layout ." + e).removeClass(e).addClass(t)
}

function cleanHtml(e) {
    $(e).parent().append($(e).children().html());
}

function cleanRow(row) {

    row.children('.remove , .drag, .preview').remove();
    row.find('div.ui-sortable').removeClass('ui-sortable');

    row.children('.view').find('br').remove();

    row.children('.view').children('.row').children('.column').each(function () {
        // se ci dovessero essere righe nella colonna allora :
        var col = $(this);

        col.removeClass('column');
        col.children('.lyrow').each(function () {
            cleanRow($(this));
        });
        col.children('.box-element').each(function () {
            var element = $(this);
            element.children('.remove , .drag, .configuration, .preview').remove();
            element.parent().append(element.children('.view').html());
            element.remove();
        });
    });
    row.parent().append(row.children('.view').html());
    row.remove();
}

function downloadLayoutSrc() {
    //  var e = "";
    $("#download-layout").children().html($(".htmlpage").html());

    // var t = $("#download-layout").children();
    $("#download-layout").children('.container').each(function (i) {
        var container = $(this);
        container.children('.lyrow').each(function (i) {
            var row = $(this);
            cleanRow(row);
        });
    });
    $('textarea#model').val($(".htmlpage").html());
    $('textarea#src').val(style_html($("#download-layout").html()));
    // $('#download').modal('show');

}

$('#srcSave').click(function () {
    // $.post(path + '/save.php', {html: style_html($("#download-layout").html())}, function (data) {       }, 'html');
});

function getIndent(level) {
    var result = '',
            i = level * 4;
    if (level < 0) {
        throw "Level is below 0";
    }
    while (i--) {
        result += ' ';
    }
    return result;
}

function style_html(html) {
    html = html.trim();
    var result = '',
            indentLevel = 0,
            tokens = html.split(/</);
    for (var i = 0, l = tokens.length; i < l; i++) {
        var parts = tokens[i].split(/>/);
        if (parts.length === 2) {
            if (tokens[i][0] === '/') {
                indentLevel--;
            }
            result += getIndent(indentLevel);
            if (tokens[i][0] !== '/') {
                indentLevel++;
            }

            if (i > 0) {
                result += '<';
            }

            result += parts[0].trim() + ">\n";
            if (parts[1].trim() !== '') {
                result += getIndent(indentLevel) + parts[1].trim().replace(/\s+/g, ' ') + "\n";
            }

            if (parts[0].match(/^(img|hr|br)/)) {
                indentLevel--;
            }
        } else {
            result += getIndent(indentLevel) + parts[0] + "\n";
        }
    }
    return result;
}

function s4() {
    return Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
}

function gup(name, url) {
    if (!url)
        url = location.href;
    name = name.replace(/[\[]/, "\\\[").replace(/[\]]/, "\\\]");
    var regexS = "[\\?&]" + name + "=([^&#]*)";
    var regex = new RegExp(regexS);
    var results = regex.exec(url);
    return results == null ? null : results[1];
}

(function ($) {

    $.fn.assignId = function () {
        var _self = $(this);
        var id = _self.attr('id');
        if (typeof id === typeof undefined || id === false) {

            id = s4() + '-' + s4() + '-' + s4() + '-' + s4();
            _self.attr('id', id);

        }
        return id;
    };

})(jQuery);
