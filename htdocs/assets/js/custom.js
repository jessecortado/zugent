$(document).ready(function() {
    // for all panel-body that has a table inside set padding to 3px
    $("table").parents(".panel-body").css({'padding':'3px'});

    $(document).on('click', '#notifications', function (e) {
        e.stopPropagation();
    });

    $("#see-notifications").on("click", function() {
        $.ajax({
            type:"post",
            dataType:"json",
            url: "/services/notifications_seen.php",
            success: function(data) {
                console.log(data);
            },
            error: function(jqXHR, textStatus, errorThrown) {
                errormessage = errorThrown + ": " + textStatus + " | " + jqXHR.status;
                console.log(errormessage);
            },
        });
    });

    $("a[href^='tel']").on("click", function(){
        console.log("calling " + $(this).attr('href').replace(/[^\d\+]/g,""));
    });

    var offset = 10

    $("#load-more-notifications").on("click", function(e) {
        e.preventDefault();
        console.log("Getting more notifications");

        $.ajax({
            type:"post",
            dataType:"json",
            url: "/services/get_notifications.php",
            data: {offset: offset},
            success: function(result) {
                console.log(result);
                var temp = JSON.parse(JSON.stringify(result.data));

                if(temp != '') {
                    $.each(temp, function(index, val) {
                        var appendStr = '<li class="media"><a href="'+val.url_action+'">';
                            appendStr += '<div class="media-left"><i class="fa fa-bug media-object bg-red"></i></div><div class="media-body"><h6 class="media-heading">'+val.title+'</h6><p>'+val.notification+'</p><div class="text-muted f-s-11">'+val.time_elapsed+'</div></div></a></li>';
                        $("#notifications .dropdown-footer").before(appendStr);
                    });

                    if (temp.length < 10) {
                        $(this).html("No more notifications");
                        $(this).disable;
                    }
                }

                offset += 10;
                console.log(offset);

            },
            error: function(jqXHR, textStatus, errorThrown) {
                errormessage = errorThrown + ": " + textStatus + " | " + jqXHR.status;
                console.log(errormessage);
            },
        });

    });
});

function ready_contact_form(){
    $("#contact-form").submit(function(e){
        e.preventDefault();

        var name = $("#contact-name").val();
        var email = $("#contact-email").val();
        var message = $("#contact-message").val();
        var phone = $("#contact-phone").val();

        $.ajax({
            type:"post",
            dataType:"json",
            url: "./services/zug_contact_us.php",
            data: {name: name, phone: phone, email: email, message:message},
            success: function(data) {
                console.log(data);
                $("#contact-form").hide();
                $("#contact-form").parent().append("<p style='text-align:center; font-size: 14px; font-weight: bold; color: #313131' data-animation='true' data-animation-type='fadeInRight'>Your message has been delivered!<p>");
            },
            error: function(jqXHR, textStatus, errorThrown) {
                errormessage = errorThrown + ": " + textStatus + " | " + jqXHR.status;
                console.log(errormessage);
            },
        });
        
        return false;

    });
}

// function add_status(status_name, bucket_id, global) {
//     $.ajax({
//         type: "POST",
//         url: '/services/contact_status_manager.php',
//         data: { 'status_name': status_name, 'action': 'add_status', 'bucket_id': bucket_id },
//         dataType: "json",
//         success: function(result) {
//             console.log(result.status_id);

//             if(global){
//                 $("#global-status tbody").append('<tr><td>' + result.status_id + '</td><td><a href="#" class="editable" data-type="text" data-pk="'+result.status_id+'" data-value="'+result.status_name+'">' + result.status_name +
//                 '</a></td><td><input class="dashboard-checkbox" data-status-id="'+ result.status_id +'" type="checkbox">' +
//                             '</td><td><a href="sub_status_manager.php?status_id='+result.status_id+'&status_name='+result.status_name+'" class="btn btn-xs btn-success m-r-5 m-b-5"><i class="glyphicon glyphicon-eye-open"></i>View</a><a href="#" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete" data-toggle="confirmation" data-status-id="'+result.status_id+'"><i class="glyphicon glyphicon-remove"></i>Delete</a></td>');
            
//             }
//             else{
//                 $("#status tbody").append('<tr><td>' + result.status_id + '</td><td><a href="#" class="editable" data-type="text" data-pk="'+result.status_id+'" data-value="'+result.status_name+'">' + result.status_name +
//                 '</a></td><td><input class="dashboard-checkbox" data-status-id="'+ result.status_id +'" type="checkbox">' +
//                             '</td><td><a href="sub_status_manager.php?status_id='+result.status_id+'&status_name='+result.status_name+'" class="btn btn-xs btn-success m-r-5 m-b-5"><i class="glyphicon glyphicon-eye-open"></i>View</a><a href="#" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete" data-toggle="confirmation" data-status-id="'+result.status_id+'"><i class="glyphicon glyphicon-remove"></i>Delete</a></td>');
//             }

//             $('.editable').editable({
//                 url: '/services/contact_status_manager.php',
//                 title: 'Enter Status Name',
//                 params: function(params) {
//                     //originally params contain pk, name and value
//                     params.action = 'edit_status';
//                     params.status_id = $(this).data('pk');
//                     params.status_name = params.value;
//                     return params;
//                 },
//                 validate: function(value) {
//                     if($.trim(value) == '') {
//                         return 'This field is required';
//                     }
//                 },
//                 success: function(response, newValue) {
//                     console.log(response);
//                 }
//             });
//         },
//         error: function (XMLHttpRequest, textStatus, errorThrown) {
//             console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
//         }
//     });
// }

// function add_sub_status(sub_status_name, status_id) {
//     $.ajax({
//         type: "POST",
//         url: '/services/contact_status_manager.php',
//         data: { 'sub_status_name': sub_status_name, 'action': 'add_sub_status', 'status_id': status_id },
//         dataType: "json",
//         success: function(result) {
//             console.log(result.sub_status_id);

//                 $("#sub-status tbody").append('<tr><td>' + result.sub_status_id + '</td><td><a href="#" class="editable" data-type="text" data-pk="'+result.sub_status_id+'" data-value="'+result.sub_status_name+'">' + result.sub_status_name +
//                 '</a></td><td><input class="dashboard-checkbox" data-sub-status-id="'+ result.sub_status_id +'" type="checkbox">' +
//                             '</td><td><a href="#" class="btn btn-xs btn-danger m-r-5 m-b-5 btn-delete" data-sub-status-id="'+result.sub_status_id+'" data-toggle="confirmation"><i class="glyphicon glyphicon-remove"></i>Delete</a></td>');
                
//                 $('.editable').editable({
//                     url: '/services/contact_status_manager.php',
//                     title: 'Enter Status Name',
//                     params: function(params) {
//                         //originally params contain pk, name and value
//                         params.action = 'edit_sub_status';
//                         params.sub_status_id = $(this).data('pk');
//                         params.sub_status_name = params.value;
//                         return params;
//                     },
//                     validate: function(value) {
//                         if($.trim(value) == '') {
//                             return 'This field is required';
//                         }
//                     },
//                     success: function(response, newValue) {
//                         console.log(response);
//                     }
//                 });
//         },
//         error: function (XMLHttpRequest, textStatus, errorThrown) {
//             console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
//         }
//     });
// }

function ready_dropzone(){
    $("#dropzone").dropzone({ url: "/services/upload-profile-picture.php" });
}

// function confirm_delete(bucket_id, status_id, sub_status_id, action) {
//     console.log(bucket_id + ' ' + status_id + ' ' + sub_status_id + ' ' + action); 
//     $.ajax({
//         type: "POST",
//         url: '/services/contact_status_manager.php',
//         data: { 'bucket_id': bucket_id, 'status_id': status_id, 'sub_status_id': sub_status_id, 'action': action },
//         dataType: "json",
//     })
//     .done(function() {
//         // $(current).closest("tr").remove();
//     })
//     .fail(function() {
//         console.log("error");
//     })
//     .success(function() {
//         console.log("complete");
//     });
// }

// function confirm_remove_contact_user(contact_user_id, contact_id) {
//     console.log(contact_id);
//     var msg;
//     $.ajax({
//         async: false,
//         type: "POST",
//         url: '/ws/contact/remove_user_from_contact',
//         data: { 'contact_user_id': contact_user_id, 'contact_id': contact_id },
//         dataType: "json",
//     })
//     .fail(function(error) {
//         console.log(error.responseText);
//     })
//     .success(function(result) {
//         console.log(result);
//         msg = result;
//     });
//     return msg;
// }

// function confirm_delete_contact_file(contact_file_id, contact_id) {
//     var msg;
//     $.ajax({
//         async: false,
//         type: "POST",
//         url: '/ws/contact/attached_file/delete',
//         data: { 'contact_file_id': contact_file_id, 'contact_id': contact_id },
//         dataType: "json",
//     })
//     .fail(function (XMLHttpRequest, textStatus, errorThrown) {
//         console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
//     })
//     .success(function(result) {
//         console.log(result);
//         msg = result;
//     });
//     return msg;
// }

function confirm_delete_transaction_file(transaction_file_id, transaction_id) {

    $.ajax({
        type: "POST",
        url: '/services/delete_transaction_file.php',
        data: { 'transaction_file_id': transaction_file_id, 'transaction_id': transaction_id, 'action': 'delete_transaction_file' },
        dataType: "json",
    })
    .done(function() {
        // $(current).closest("tr").remove();
    })
    .fail(function (XMLHttpRequest, textStatus, errorThrown) {
            console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
    })
    .success(function(response) {
        console.log(response.result);
        if(response.result == true) {
            window.location = ("/transaction/"+transaction_id+"#transactionFilesTbl");
            location.reload();
        }
    });
}


// function confirm_restore_contact_file(contact_file_id, contact_id) {
//     var msg;
//     $.ajax({
//         async: false,
//         type: "POST",
//         url: '/ws/contact/attached_file/restore',
//         data: { 'contact_file_id': contact_file_id, 'contact_id': contact_id },
//         dataType: "json",
//     })
//     .fail(function (XMLHttpRequest, textStatus, errorThrown) {
//         console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
//     })
//     .success(function(result) {
//         console.log(result);
//         msg = result;
//     });
//     return msg;
// }


function confirm_restore_transaction_file(transaction_file_id, transaction_id) {

    $.ajax({
        type: "POST",
        url: '/services/restore_transaction_file.php',
        data: { 'transaction_file_id': transaction_file_id, 'transaction_id': transaction_id, 'action': 'restore_transaction_file' },
        dataType: "json",
    })
    .done(function() {
        // $(current).closest("tr").remove();
    })
    .fail(function (XMLHttpRequest, textStatus, errorThrown) {
            console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
    })
    .success(function(response) {
        console.log(response.result);
        if(response.result == true) {
            window.location = ("/transaction/"+transaction_id+"#transactionFilesTbl");
            location.reload();
        }
    });
}

function get_states() {
    var state_json = {"AL":"Alabama","AK":"Alaska","AS":"American Samoa","AZ":"Arizona","AR":"Arkansas","CA":"California","CO":"Colorado","CT":"Connecticut","DE":"Delaware","DC":"District Of Columbia","FM":"Federated States Of Micronesia","FL":"Florida","GA":"Georgia","GU":"Guam","HI":"Hawaii","ID":"Idaho","IL":"Illinois","IN":"Indiana","IA":"Iowa","KS":"Kansas","KY":"Kentucky","LA":"Louisiana","ME":"Maine","MH":"Marshall Islands","MD":"Maryland","MA":"Massachusetts","MI":"Michigan","MN":"Minnesota","MS":"Mississippi","MO":"Missouri","MT":"Montana","NE":"Nebraska","NV":"Nevada","NH":"New Hampshire","NJ":"New Jersey","NM":"New Mexico","NY":"New York","NC":"North Carolina","ND":"North Dakota","MP":"Northern Mariana Islands","OH":"Ohio","OK":"Oklahoma","OR":"Oregon","PW":"Palau","PA":"Pennsylvania","PR":"Puerto Rico","RI":"Rhode Island","SC":"South Carolina","SD":"South Dakota","TN":"Tennessee","TX":"Texas","UT":"Utah","VT":"Vermont","VI":"Virgin Islands","VA":"Virginia","WA":"Washington","WV":"West Virginia","WI":"Wisconsin","WY":"Wyoming"};

    var states = [];

    $.each({"AL":"Alabama","AK":"Alaska","AS":"American Samoa","AZ":"Arizona","AR":"Arkansas","CA":"California","CO":"Colorado","CT":"Connecticut","DE":"Delaware","DC":"District Of Columbia","FM":"Federated States Of Micronesia","FL":"Florida","GA":"Georgia","GU":"Guam","HI":"Hawaii","ID":"Idaho","IL":"Illinois","IN":"Indiana","IA":"Iowa","KS":"Kansas","KY":"Kentucky","LA":"Louisiana","ME":"Maine","MH":"Marshall Islands","MD":"Maryland","MA":"Massachusetts","MI":"Michigan","MN":"Minnesota","MS":"Mississippi","MO":"Missouri","MT":"Montana","NE":"Nebraska","NV":"Nevada","NH":"New Hampshire","NJ":"New Jersey","NM":"New Mexico","NY":"New York","NC":"North Carolina","ND":"North Dakota","MP":"Northern Mariana Islands","OH":"Ohio","OK":"Oklahoma","OR":"Oregon","PW":"Palau","PA":"Pennsylvania","PR":"Puerto Rico","RI":"Rhode Island","SC":"South Carolina","SD":"South Dakota","TN":"Tennessee","TX":"Texas","UT":"Utah","VT":"Vermont","VI":"Virgin Islands","VA":"Virginia","WA":"Washington","WV":"West Virginia","WI":"Wisconsin","WY":"Wyoming"}, function(k, v) {
        
        states.push({id: k, text: v});

    });

    console.log(states.toString());
    return states;
}

function get_transaction_status(company_id) {

    var transaction_statusz = [];

    console.log(company_id);
    $.ajax({
        type: "POST",
        url: '/services/transaction_manager.php',
        data: { 'company_id': company_id, 'action': 'get_transaction_status' },
        dataType: "json",
    })
    .fail(function (XMLHttpRequest, textStatus, errorThrown) {
            console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
    })
    .success(function(result) {
        var temp = JSON.parse(JSON.stringify(result.data));

        console.log(temp);

        $.each(temp, function(key, val) {
            transaction_statusz.push({ id : val.transaction_status_id, text : val.transaction_status });
        });

    });

    return transaction_statusz;
    
}

function get_transaction_types(company_id) {

    var transaction_types = [];
    console.log(company_id);
    $.ajax({
        type: "POST",
        url: '/services/transaction_manager.php',
        data: { 'company_id': company_id, 'action': 'get_transaction_types' },
        dataType: "json",
    })
    .fail(function (XMLHttpRequest, textStatus, errorThrown) {
            console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown)
    })
    .success(function(result) {
        var temp = JSON.parse(JSON.stringify(result.data));

        $.each(temp, function(key, val) {
            transaction_types.push({ id : val.transaction_type_id, text : val.transaction_type });
        });

        console.log("Displaying JSONs");

        console.log(transaction_types);
        // return transaction_status;
    });

    return transaction_types;
    
}

var confirm_purchase_init = function(id) {
    "use strict";
    console.log(id);
    $(document).on("click", "#confirm", function(){
    $("#page-loader, .page-loader").removeClass("hide");
    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Please Wait</p>");
        console.log("confirmed");

        $("#frm-confirm-purchase").submit();

    });
};

var Confirm_Purchase = function () {
    "use strict";
    return {
        //main function
        init: function (id) {
            confirm_purchase_init(id);
        }
    };
}();

var confirm_copy_campaign = function(id) {
    "use strict";
    console.log(id);
    $(document).on("click", "#confirm", function(){
    $("#page-loader, .page-loader").removeClass("hide");
    $("#page-loader").append("<p style='position:absolute; top: 70%; left: 46.5%; margin: -20px 0 0 -20px;'>Processing Please Wait</p>");
        console.log("confirmed");
    });
};


var Confirm_Copy_Campaign = function () {
    "use strict";
    return {
        //main function
        init: function (id) {
            confirm_copy_campaign(id);
        }
    };
}();

var handleFormPasswordIndicator = function() {
    "use strict";
    $('#password-indicator-newpassword').passwordStrength({targetDiv: '#passwordStrength-new'});
    $('#password-indicator-confirmpassword').passwordStrength({targetDiv: '#passwordStrength-confirm'});
};

var PasswordIndicator = function () {
    "use strict";
    return {
        //main function
        init: function () {
            handleFormPasswordIndicator();
        }
    };
}();

function checkGroup(group, errorDivSelector) {
    var flag = false;

    $.each($("input[data-parsley-group=" + group + "]"), function (i, el) {
        if (el.value.length > 0) {
            flag = true;
            return false; 
        }
    });

    if (flag) {
        $(errorDivSelector).addClass('hide');
        $("input[data-parsley-group=" + group + "]").removeClass('parsley-error');
    }
    else {
        $(errorDivSelector + '>.msg').text("At least one field must be filled");
        $(errorDivSelector).removeClass('hide');
        $("input[data-parsley-group=" + group + "]").addClass('parsley-error');
    }

    return flag;

}