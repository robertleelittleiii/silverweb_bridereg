
var brideTableAjax = "";
var brides_index_callDocumentReady_called = false;
$(document).ready(function () {
    if (!brides_index_callDocumentReady_called)
    {
        brides_index_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
//  alert("it is a window");
        } else
        {
            brides_index_callDocumentReady();
        }
    }
});
function brides_index_callDocumentReady() {
    requireCss("tables.css");
    require("brides/shared.js");
    if ($('#mainnav:visible').length != 0)
    {
        $("div#bride-middle-left").hide();
        $("div#content").width("100%");
        $('#Content').css('background', "white")
    }

    //  Required scripts (loaded for this js file)
    //

    // reateBrideDialog();
    //    $("body").css("cursor", "progress");[
    //    brideTableOld=$('#bride-table-old').DataTable({
    //        "aLengthMenu": [[-1, 10, 25, 50], ["All", 10, 25, 50]]
    //    });
    $("body").css("cursor", "progress");
    createBrideTable();
    $("body").css("cursor", "default");
    //
    //    $('#bride-table .bride-row').bind('click', function(){
    //        $(this).addClass('row_selected');
    //        brideID=$(this).find("#bride-id").text().strip();
    //        window.location = "/bride/edit/"+brideID;
    //    });

    //    $('.delete-bride-item').bind('ajax:success', function(xhr, data, status){
    //        $("body").css("cursor", "progress");[
    //        theTarget=this.parentNode.parentNode;
    //        var aPos = brideTableAjax.fnGetPosition( theTarget );
    //        brideTableAjax.fnDeleteRow(aPos);
    //        brideTableAjax.draw();
    //        $("body").css("cursor", "default");[]
    //    });

    //    $('.delete-bride-item').bind('ajax:error', function(xhr, data, error){
    //        alert("Error:" + JSON.parse(data.responseText)["error"]);
    //        $("body").css("cursor", "default");[]
    //
    //    });

    $(".edit_bride").bind('ajax:success', function (xhr, data, status) {
        $('#edit-password-dialog').dialog('close');
    });
//    $('a#new-bride').unbind().bind('ajax:beforeSend', function (e, xhr, settings) {
//        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
//        $("body").css("cursor", "progress");
//    });
//
//    $('a#new-bride').bind('ajax:success', function (xhr, data, status) {
//        $("body").css("cursor", "default");
//        brideTableAjax.draw();
//        setUpPurrNotifier("Notice", "New Bride Created!'");
//    });


    // createPasswordDialog();
    // createBrideDialog();
    bindNewBride();
    $("a.button-link").button();
}



function deleteBride(bride_id)
{
    var answer = confirm('Are you sure you want to delete this?')
    if (answer) {
        $.ajax({
            url: '/brides/' + bride_id,
            type: "POST",
            data: {_method: "delete"},
            success: function (data)
            {
                setUpPurrNotifier("Notice", "Bride was Successfully Deleted.");
                brideTableAjax.draw();
            }
        });
    }
}

function editBride(bride_id)
{
    var url = '/brides/' + bride_id + '/edit?request_type=window&window_type=iframe';
    $('iframe#brides-app-id', window.parent.document).attr("src", url);
}


function loadBrideScreen() {

    bride - action - area
}


function createBrideDialog() {

    $('#edit-bride-dialog').dialog({
        autoOpen: false,
        width: 455,
        height: 625,
        modal: true,
        buttons: {
            "Delete": function () {
                bride_id = $(".m-content div#bride-id").text().trim();
                if (confirm("Are you sure you want to delete this bride?"))

                {
                    $(this).dialog("close");
                    $.ajax({
                        url: '/brides/delete_ajax?id=' + bride_id,
                        success: function (data)
                        {
                            brideTableAjax.draw();
                        }
                    });
                } else
                {

                }
            },
            "Ok": function () {
                $(this).dialog("close");
                brideTableAjax.draw();
            }
        }

    });
}



function createBrideTable() {
    console.log("create table");
    brideTableAjax = $('#bride-table').DataTable({
        brideLength: 25,
        lengthMenu: [[25, 50, 100], [25, 50, 100]],
        stateSave: true,
        stateSaveCallback: function (settings, data) {
            localStorage.setItem('DataTables_brides_' + window.location.pathname, JSON.stringify(data));
        },
        stateLoadCallback: function (settings) {
            return JSON.parse(localStorage.getItem('DataTables_brides_' + window.location.pathname));
        },
        processing: true,
        order: [[0, "asc"]],
        serverSide: true,
        searchDelay: 500,
        ajax: {
            url: "/brides/bride_table",
            type: "post"
        },
        rowCallback: function (row, data, index) {
            $(row).addClass('bride-row');
            $(row).addClass('gradeA');
            //return row;
        },
        initComplete: function () {
            // $(".best_in_place").best_in_place(); 

        },
        drawCallback: function (settings) {
            $(".best_in_place").best_in_place();
            //brideeditClickBinding(".edit-bride-item");
            brideeditClickBinding("tr.bride-row");
            bindDeleteBride();
            $("td.dataTables_empty").attr("colspan", "20")

        }

//"iDisplayLength": 25,
//        "aLengthMenu": [[25, 50, 100], [25, 50, 100]],
//        "bStateSave": true,
//        "fnStateSave": function (oSettings, oData) {
//        localStorage.setItem('DataTables_brides_' + window.location.pathname, JSON.stringify(oData));
//        },
//        "fnStateLoad": function (oSettings) {
//        return JSON.parse(localStorage.getItem('DataTables_brides_' + window.location.pathname));
//        },
//        "bProcessing": true,
//        "bServerSide": true,
//        "aaSorting": [[1, "asc"]],
//        "sAjaxSource": "/brides/bride_table",
//        "fnRowCallback": function (nRow, aData, iDisplayIndex, iDisplayIndexFull) {
//        $(nRow).addClass('bride-row');
//                $(nRow).addClass('gradeA');
//                return nRow;
//        },
//        "fnInitComplete": function () {
//        // $(".best_in_place").best_in_place(); 
//
//        },
//        "drawCallback": function () {
//        $(".best_in_place").best_in_place();
//                //brideeditClickBinding(".edit-bride-item");
//                brideeditClickBinding("tr.bride-row");
//                bindDeleteBride();
//        }
    });
}

function bindNewBride() {

    $('a#new-bride').unbind().bind('ajax:beforeSend', function (e, xhr, settings) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $("body").css("cursor", "progress");
    }).bind('ajax:success', function (xhr, data, status) {
        $("body").css("cursor", "default");
        brideTableAjax.draw();
        setUpPurrNotifier("Notice", "New Bride Created!'");
    }).bind('ajax:error', function (evt, xhr, status, error) {
        setUpPurrNotifier("Error", "Bride Creation Failed!'");
    });
//    $('a#new-bride').bind('ajax:beforeSend', function (evt, xhr, settings) {
//        // alert("ajax:before");  
//        console.log('ajax:before');
//        console.log(evt);
//        console.log(xhr);
//        console.log(settings);
//
//        $("body").css("cursor", "progress");
//
//
//
//    }).bind('ajax:success', function (evt, data, status, xhr) {
//        //  alert("ajax:success"); 
//        console.log('ajax:success');
//        console.log(evt);
//        console.log("date:" + data + ":");
//
//        $("body").css("cursor", "progress");
//        console.log(data.id);
//        editBride(data.id);
//
//        console.log(status);
//        console.log(xhr);
//
//    }).bind('ajax:error', function (evt, xhr, status, error) {
//        // alert("ajax:failure"); 
//        console.log('ajax:error');
//        console.log(evt);
//        console.log(xhr);
//        console.log(status);
//        console.log(error);
//
//        alert("Error:" + JSON.parse(data.responseText)["error"]);
//        $("body").css("cursor", "default");
//
//
//    }).bind('ajax:complete', function (evt, xhr, status) {
//        //    alert("ajax:complete");  
//        console.log('ajax:complete');
//        console.log(evt);
//        console.log(xhr);
//        // console.log(status);
//        $("body").css("cursor", "default");
//
//
//    });

}
function bindDeleteBride() {
    $(".delete-bride-item").on("click", function (e) {

// console.log($(this).parent().parent().parent().find('#bride-id').text());
        var bride_id = $(this).parent().parent().parent().find('#bride-id').text();
        deleteBride(bride_id);
        return false;
    });
}








// ************************************    
//
// Create Edit Dialog Box
//
// ************************************    
//
//function createAppDialog(theContent) {
//    
//        
//    if ($("#app-dialog").length == 0) 
//    {    
//        var dialogContainer =  "<div id='app-dialog'></div>";
//        $("#bride").append($(dialogContainer));
//    }
//    else 
//    {
//        dialogContainer=$("#app-dialog");   
//    }
//    // $('#app-dialog').html(theContent);
//    theContent = '<input type="hidden" autofocus="autofocus" />' + theContent
//    theAppDialog =  $('#app-dialog').dialog({
//        autoOpen: false,
//        modal: true,
//        buttons: {
//            "Close": function() { 
//                // Do what needs to be done to complete 
//                $(this).dialog("close"); 
//            }
//        },
//        close: function( event, ui ) {
//            $('#app-dialog').html("");
//            $('#app-dialog').dialog( "destroy" );
//        },
//        open: function (event, ui)
//        {
//            popUpAlertifExists();
//        }
//        
//        
//    });
//    
//    $('#app-dialog').html(theContent);
//
//    theHeight= $('#app-dialog #dialog-height').text() || "500";
//    theWidth= $('#app-dialog #dialog-width').text()  || "500";
//    theTitle= $('#app-dialog #dialog-name').text() || "Edit";
//    
//    theAppDialog.dialog({
//        title:theTitle,
//        width: theWidth,
//        height:theHeight
//    });
//        
//    return(theAppDialog)
//}

function edit_bride_dialog(data) {

// alert("ajax:success");
    bride_edit_dialog = createAppDialog(data, "edit-bride", {}, "");
    //initialize_save_button();
    //$('.datepicker').datepicker();
    //tiny_mce_initializer();
    //bind_org_select();
    //bind_membership_select();
    //bind_grade_select();
    //bind_flags_select();

    //bind_grade_all_select();

    //bind_grade_filter_display();
    //bind_membership_filter_display();
    //bind_flags_filter_display();
    //bind_select_ajax("picture_priority");
    //bind_select_ajax("picture_status");



    //current_notice = $("#picture-id").text();
    //set_before_edit(current_notice);
    // tinyMCE.init({"selector":"textarea.tinymce"});
    // $(".best_in_place").best_in_place();

    //bind_file_upload_to_upload_form();
    //$("button.ui-dialog-titlebar-close").hide();

    //initialize_add_organization();
    //select_subject_field();
    //initialize_select_all_button();
    //initialize_select_none_button();
    //initilize_filter_buttons();

}

$(document).off('focusin').on('focusin', function (e) {
    if ($(event.target).closest(".mce-window").length) {
        e.stopImmediatePropagation();
    }
});