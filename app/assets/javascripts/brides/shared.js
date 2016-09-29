/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

bride_edit_dialog = "";

function brideeditClickBinding(selector) {
    // selectors .edit-bride-item, tr.bride-row 

    $(selector).unbind("click").one("click", function (event) {
        event.stopPropagation();
        console.log($(this).find('#bride-id').text());
        var bride_id = $(this).find('#bride-id').text();
        var is_iframe = $("application-space").length > 0

        var url = '/brides/' + bride_id + '/edit?request_type=window&window_type=iframe&as_window=true';

        // $(this).effect("highlight", {color: "#669966"}, 1000);

        $.ajax({
            url: url,
            success: function (data)
            {
                bride_edit_dialog = createAppDialog(data, "edit-bride", {}, "");
                bride_edit_dialog.dialog({
                    close: function (event, ui) {
                        if ($("table#bride-table").length > 0)
                            brideTableAjax.draw();
                        
                        if ($("div#edit-bride").length > 0)
                        {
                         current_bride_id = $("div#bride div#attr-brides div#bride-id").text();
                            if (bride_id === current_bride_id)
                            {
                                show_bride(bride_id);
                            }
                        }
                        brideeditClickBinding("div#edit-brides");

                        //tinyMCE.editors[0].destroy();
                        $('#edit-bride').html("");
                        $('#edit-bride').dialog("destroy");
                        update_content();


                    }
                });
                
                require("brides/edit.js");
                requireCss("brides/edit.css");
                requireCss("brides.css");

                brides_edit_callDocumentReady();
                bride_edit_dialog.dialog('open');


            }
        });


    });
}

