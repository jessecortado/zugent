
<script src="assets/plugins/bootstrap3-editable/js/bootstrap-editable.min.js"></script>
<script src="assets/plugins/select2/dist/js/select2.min.js"></script>

<script type="text/javascript">

    $(document).ready(function() {

        $("#btn-add-pool").on("click", function() {
            var name = $("#pool-name").val();
            var share_level = $("#share-level").val();
            var description = $("#description").val();
            var id = $("#pool-id").val();

            $.ajax({
                type: "POST",
                url: '/services/pool_manager.php',
                data: { 'pool_name': name, 'share_level': share_level, 'description': description, 'action': $("#action").val() },
                dataType: "json",
                success: function(result) {

                    $("#tbl-pool").append('<tr><td>'+result.id+'</td><td>'+
                                name+'</td><td>'+
                                share_level+'</td><td>'+
                                result.date_created+'</td><td>'+
                                +'</td><td>'+
                                result.uploaded_by+'</td></tr>'
                                );
                    
                    $('#modal-add-pool').modal('hide');

                },
                error: function (XMLHttpRequest, textStatus, errorThrown) {
                    console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus + ' ' +errorThrown);
                }
            });
        });


        $(".call-lead").on("click", function() {
            // $(".theme-panel").addClass("active");
            if ($(".theme-panel").hasClass("active")) {
                $(".theme-panel").removeClass("active");
                startTime();
            } else {
                $(".theme-panel").addClass("active");
            }
        });

        // var poolLeadsBody = $("#tbl-pool-leads tbody").html();

        // $("#filter-leads").on("change", function(){
        //     var filter = $(this).find(":selected").val();

        //     $("#tbl-pool-leads tbody").addClass('hide');
        //     $("#page-loader").removeClass('hide');
        //     $("#tbl-pool-leads tbody").html(poolLeadsBody)

        //     console.log(filter);
        //     $.ajax({
        //         type: "POST",
        //         url: '/services/dropdown_changed.php',
        //         data: { 'filter': filter, id: '{$id}' },
        //         dataType: "json",
        //         success: function(result) {
        //             console.log(result);
        //             var appendStr = "";
        //             var temp = JSON.parse(JSON.stringify(result));
        //             $.each(temp.data, function(index, val) {
        //                 var find = "#pool-lead-" + val.pool_lead_id;
        //                 appendStr += "<tr>" + $(find).html() + "<tr></tr>" + $(find).next('tr').html() + "</tr>";
        //             });

        //             $("#tbl-pool-leads tbody").html("");
        //             $("#tbl-pool-leads tbody").append(appendStr);
        //             $("#tbl-pool-leads tbody").removeClass('hide');
        //             $("#page-loader").addClass('hide');

        //         },
        //         error: function (XMLHttpRequest, textStatus, errorThrown) {
        //             console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
        //         }
        //     });
        // });

        // $('#tbl-pool-leads').DataTable( {
        //     responsive: true,
        //     iDisplayLength: 25,
            // initComplete: function () {
            //     this.api().columns([1,2,3]).every( function () {
            //         var column = this;
            //         var select = $('<select style=" width: 92px;"><option value="">Show All</option></select>')
            //             .appendTo( $(column.footer()).empty() )
            //             .on( 'change', function () {
            //                 var val = $.fn.dataTable.util.escapeRegex(
            //                     $(this).val()
            //                 );
     
            //                 column
            //                     .search( val ? '^'+val+'$' : '', true, false )
            //                     .draw();
            //             } );
     
            //         column.data().unique().sort().each( function ( d, j ) {
            //             select.append( '<option value="'+d+'">'+d+'</option>' )
            //         } );
            //     } );

            //     $('#referralsTbl tfoot tr').insertAfter($('#referralsTbl thead tr'))
            // }
        // });

        {* var table_leads = $('#tbl-pool-leads').DataTable({
            responsive: true,
            iDisplayLength: 25,
            dom: '<"top pull-left custom-filter-container"><"top pull-right"l>rt<"bottom"i><"bottom pull-right"p>',
            data: {$pool_leads_json},
            columns: [
                { "mData": "pool_lead_id" },
                { "mData": "first_name" },
                { "mData": "county" },
                { "mData": "city" },
                { "mData": "date_added", "defaultContent": "<i>n/a</i>", "sClass": "text-center" },
                { "mData": "date_last_contacted", "defaultContent": "<i>n/a</i>", "sClass": "text-center" },
                {
                    "mData": null,
                    "sClass": "text-center",
                    "bSortable": false,
                    "bSearchable": false,
                    "mRender": function (o) { return '<a href="pool_lead_view.php?id='+ o.pool_lead_id +'" class="btn btn-xs btn-success m-t-2 m-b-2"><i class="glyphicon glyphicon-eye-open"></i>View Lead</a>'; }
                }
            ],
            columnDefs:[{
                "targets": [ 2,3 ],
                "visible": false
            }],
            initComplete: function(settings){
                var api = new $.fn.dataTable.Api( settings );
                $('.custom-filter-container', api.table().container()).append(
                    $('#filter-leads-container').detach().show()
                );

                $('#filter-leads').on('change', function(){
                    var county_city = this.value.split(" - ");
                    var county = county_city[0];
                    var city = county_city[1];
                    table_leads.columns(2).search(county).draw();
                    table_leads.columns(3).search(city).draw();
                });
            }
        });

        *}
        
        $('#filter-leads').select2({
            placeholder: "Select County",
            width: '200px'
        });

    });

</script>

