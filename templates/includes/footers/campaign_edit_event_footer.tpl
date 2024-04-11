<script src="assets/plugins/summernote/summernote.min.js" defer></script>

<script type="text/javascript">

$(document).ready(function() {
    var HightlightButton = function(context) {
        var ui = $.summernote.ui;
        var button = ui.button({
            contents: '<i class="fa fa-pencil"/> Highlight',
            tooltip: 'Highlight text with red color',
            click: function() {
                context.invoke('editor.foreColor', 'red');
            }
        });

        return button.render();
    }

    $('#summernote').summernote({
        onKeyup: function(e) {
            $("#event-body").val($("#summernote").code());
        },
        placeholder: 'Hi, tell us something about yourself',
        height: "400px",
        buttons: {
            highlight: HightlightButton
        }
    });

    $('#summernote').on('summernote.change', function(we, contents, $editable) {
        $("#event-body").html(contents);
    });

    $(".insert-data").on("click", function() {
        console.log($("#summernote").html()+$(this).find(".label").html());
        $(".note-editable").html($(".note-editable").html()+$(this).find(".label").html());
        $("#event-body").html($(".note-editable").html());
    });
});

</script>