<script src="assets/plugins/select2/dist/js/select2.min.js"></script>

<script type="text/javascript">
	$(document).ready(function() {

		$("#state").select2();
		$("#bucket").select2({ placeholder: 'Select Bucket' });
		// $("#status").select2({ placeholder: 'Select Status' });
		// $("#sub-status").select2({ placeholder: 'Select Sub Status' });
		// $("#sub-status").prop("disabled", true);

		// $("#bucket").on("change", function(){
		// 	var bucket_id = $(this).find(":selected").val();
		// 	console.log(bucket_id);
		// 	$.ajax({
		// 		type: "POST",
		// 		url: '/services/dropdown_changed.php',
		// 		data: { 'bucket_id': bucket_id},
		// 		dataType: "json",
		// 		success: function(result) {
		// 			console.log(result);
		// 			$("#status").html("");
		// 			$("#status").append('<option value="">Select Status</option>');
		// 			$("#sub-status").html("");
		// 			$("#sub-status").append('<option value="">Select Sub Status</option>');
		// 			$("#sub-status").prop("disabled", true);
		// 			var temp = JSON.parse(JSON.stringify(result));
		// 			$.each(temp.data, function(index, val) {
		// 				console.log(index + " " + val.status);
		// 				$("#status").append('<option value=' + val.status_id + '>' + val.status + '</option>');
		// 			});
		// 		},
		// 		error: function (XMLHttpRequest, textStatus, errorThrown) {
		// 			console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
		// 		}
		// 	});
		// });

		// $("#status").on("change", function(){
		// 	var status_id = $(this).find(":selected").val();
		// 	console.log(status_id);
		// 	$.ajax({
		// 		type: "POST",
		// 		url: '/services/dropdown_changed.php',
		// 		data: { 'status_id': status_id },
		// 		dataType: "json",
		// 		success: function(result) {
		// 			console.log(result);
		// 			$("#sub-status").html("");
		// 			$("#sub-status").prop("disabled", false);
		// 			$("#sub-status").append('<option value="">Select Sub Status</option>');
		// 			var temp = JSON.parse(JSON.stringify(result));
		// 			$.each(temp.data, function(index, val) {
		// 				console.log(index + " " + val.sub_status);
		// 				$("#sub-status").append('<option value=' + val.sub_status_id + '>' + val.sub_status + '</option>');
		// 			});
		// 		},
		// 		error: function (XMLHttpRequest, textStatus, errorThrown) {
		// 			console.log('XHR ERROR ' + XMLHttpRequest.status + ' ' + textStatus);
		// 		}
		// 	});
		// });

		// $("#sub_status").on("change", function(){
		// 	var bucket_id = $(this).find(":selected").val();
		// 	console.log(status_id);
		// });

	});
</script>