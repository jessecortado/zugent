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

    $("#menu-html").css("min-height", "500px");

    $("#frmcustom-link").submit(function(e){
        e.preventDefault();
    });

    $('#menu-html .dd').nestable({ maxDepth: 2 });

    $('#add-to-menu').on('click', function () {
        var link_url = $('#frmcustom-link #url').val();
        var link_text = $('#frmcustom-link #link-text').val();
        if (link_text != '') {
            var menu_btn = '<li class="dd-item" data-id="'+s4()+'" data-custompage="0" data-type="menu-page">';
            menu_btn += '<a class="dd-handle" href="'+link_url+'">'+link_text+'</a>';
            menu_btn += '<a href="javascript:;" class="menu-setup"><i class="fa fa-gear"></i></a>';
            menu_btn += '<a href="javascript:;" class="menu-remove"><i class="fa fa-times"></i></a>';
            menu_btn += '</li>';
            $('#menu-html .dd ol.dd-list:first').append(menu_btn);

            $('#frmcustom-link #url').val('http://');
            $('#frmcustom-link #link-text').val('');
            $("#alert_validate_menu").addClass("hide");
            $("#alert_error_menu").addClass("hide");
            notifyItem();
        }
    });

    $(document).on('click', 'a.menu-setup', function (e) {
        e.preventDefault();
        var _s = $(this);
        var part = _s.parent();

        prepareEditor(part);
    });

    $('#save-company-menu').click(function () {
        console.log($("#menu-html .dd").nestable('serialize'));

        $.ajax({
            type: "POST",
            url: '/ws/page/save_menu',
            data: {
                'menu_list': $("#menu-html .dd").nestable('serialize')
            },
            dataType: "json",
            success: function(result) {
                if(result == 'empty') {
                    $("#alert_success_menu").addClass("hide");
                    $("#alert_validate_menu").removeClass("hide");
                    $("#alert_error_menu").addClass("hide");
                }
                else if(result) {
                    flash_alert('#alert_success_menu', 'Saved menu.');
                    $("#alert_validate_menu").addClass("hide");
                    $("#alert_error_menu").addClass("hide");
                }
                else {
                    $("#alert_success_menu").addClass("hide");
                    $("#alert_validate_menu").addClass("hide");
                    $("#alert_error_menu").removeClass("hide");
                }
            },
            error: function (XMLHttpRequest, textStatus, errorThrown) {
                console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
            }
        });
    });

    removeElm();
    notifyItem();
}

function prepareEditor(part) {
    var confirm = $('#applyChanges');
    var type = part.data('type');

    confirm.unbind('click');
    $('#preferencesTitle').html(part.data('title'));
    
    switch (type) {

        case 'menu-page':
            var btn = part.find('.dd-handle:first');

            $('#btn-url').val(btn.attr('href'));
            $('#btn-link-text').val(btn.text());

            $('#menu-page').show();

            confirm.bind('click', function (e) {
                e.preventDefault();
                btn.attr('href', $('#btn-url').val());
                btn.text($('#btn-link-text').val());
                flash_alert('#alert_success', 'Menu Link Updated!');
            });

            break;
    }
    
    $('#preferences').modal('show');
}

function removeElm() {
    $("#menu-html").delegate(".menu-remove", "click", function (e) {
        e.preventDefault();
        var elem = $(this);

        swal({
            title: 'Are you sure?',
            text: "You won't be able to revert this!",
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

            $.ajax({
                type: "POST",
                url: '/ws/page/remove_menu',
                data: {
                    'menu_id': elem.parent().attr("data-id")
                },
                dataType: "json",
                success: function(result) {
                    if(result) {
                        elem.parent().remove();
                        notifyItem();
                    }
                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' + errorThrown);
                }
            });

        }, function (dismiss) {});
    })
}

function notifyItem() {
    var count = 0;

    $("#menu-html .dd-item").each(function( index ) {
        count++;
    });

    if (count > 0) {
        $("p#item-added").css("display", "block");
        $("p#no-item-added").css("display", "none");
    }
    else {
        $("p#item-added").css("display", "none");
        $("p#no-item-added").css("display", "block");
    }
}

function s4() {
    var random1 = Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    var random2 = Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    var random3 = Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    var random4 = Math.floor((1 + Math.random()) * 0x10000)
            .toString(16)
            .substring(1);
    return random1 + '-' + random2 + '-' + random3 + '-' + random4;
}
