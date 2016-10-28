/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

var brides_edit_callDocumentReady_called = false;
var editPasswordDialog = "";

$(document).ready(function () {
    if (!brides_edit_callDocumentReady_called)
    {
        brides_edit_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        } else
        {
            brides_edit_callDocumentReady();
        }
    }
});


function brides_edit_callDocumentReady() {
    $("#bride-tabs").tabs();

    $(".best_in_place").best_in_place();
    ui_ajax_select();

    $("a.button-link").button();
    $("div.button-link").button();

    passwordClickBinding();


    bindGiftSort();
    bindDeleteGift();
    bindGiftProductSearch();
    enableProductEdit();
    bindNewProduct();

}


function passwordClickBinding() {
    $('div#password-user-item').click(function () {
        user_id = $("div#user-id").text().trim();

        $.ajax({
            url: '/users/change_password?id=' + user_id + '&as_window=true',
            success: function (data)
            {
                editPasswordDialog = createAppDialog(data, "edit-password");

                // $('#edit-password-dialog').html(data);
                editPasswordDialog.dialog({
                    buttons: {}
                });
                editPasswordDialog.dialog('open');
                require("users/change_password.js");
                change_password_callDocumentReady();

                callbackFunction = function closethisDialog() {
                    editPasswordDialog.dialog('close');
                };
                bindChangePasswordClick(callbackFunction);
            }
        });
    });
}





$(document).off('focusin').on('focusin', function (e) {
    if ($(event.target).closest(".mce-window").length) {
        e.stopImmediatePropagation();
        console.log("worked!");
    }
});



function bindGiftSort() {


    $('div#gift-products').sortable({
        dropOnEmpty: false,
        handle: 'div.gift-product-item',
        cursor: '-webkit-grabbing',
        items: 'div.product-list-item',
        opacity: 0.4,
        scroll: true,
        tolerance: "pointer",
        update: function () {
            console.log($(this));
            $.ajax({
                url: '/brides/update_gift_order',
                type: 'post',
                data: $(this).sortable('serialize'),
                dataType: 'json',
                complete: function (request) {
                }
            });
        }
    });

}

function bindDeleteGift() {
    $('a.gift-delete').unbind().bind('ajax:beforeSend', function () {
        // alert("ajax:before");  
    }).bind('ajax:success', function () {
        console.log($(this).parent().parent());
        $(this).parent().parent().remove();
        // alert("ajax:success");  
    }).bind('ajax:failure', function () {
        //  alert("ajax:failure");    
    }).bind('ajax:complete', function () {
        //  alert("ajax:complete"); 
    });

}



function bindGiftProductSearch() {

    if ($("#product-search").length > 0)
    {
        $("#product-search").autocomplete({
            source: "/products/product_search.json",
            minLength: 2,
            select: function (event, ui) {

                var bride_id = $("div#attr-bride #bride-id").text();
                // update_job_site(job_id, ui.item.id);
                add_product_to_bride(ui.item.id, bride_id)
                console.log(ui);
                console.log(ui.item ?
                        "Selected: " + ui + " aka " + ui.item.id :
                        "Nothing selected, input was " + this.value);
                console.log(this);

                $(this).val("");
            }
        });
    }
}


function add_product_to_bride(product_id, bride_id)
{
    $.ajax({
        url: "/brides/update_gift_list",
        dataType: "json",
        type: "POST",
        data: "id=" + bride_id + "&product_id=" + product_id,
        success: function (data)
        {
            //alert(data);
            if (data === undefined || data === null || data === "")
            {
                //display warning
            } else
            {
                console.log("product added!");
                //  updateJobSiteInformation(job_id, false);
                if (data.success == true) {
                    setUpPurrNotifier("Success", data.alert);
                    updateGift();


                } else
                {
                    setUpPurrNotifier("Failed", data.alert);
                }

                //jobs_material_table.fnDraw();
                //jobs_material_trans_table.fnDraw();
                //  console.log(data);
                $("input#product-search").val("");

            }
        },
        fail: function (data) {

        }
    });

}

function updateGift() {

    //  alert("color changed");
    var bride_id = $("div#attr-bride #bride-id").text();
    $("body").css("cursor", "progress");
// $("#loader_progress").show();

    $.post('/brides/render_gift_section?id=' + bride_id, function (data)
    {
        $('div#product-gift').html(data);
        $("body").css("cursor", "default");

        // $("#loader_progress").hide();
        bindGiftSort();
        bindDeleteGift();
        bindGiftProductSearch();
        $(".best_in_place").best_in_place();
        enableProductEdit();
        bindNewProduct();

    });

}


function updateGiftList() {

    //  alert("color changed");
    var bride_id = $("div#attr-bride #bride-id").text();
    $("body").css("cursor", "progress");
// $("#loader_progress").show();

    $.post('/brides/render_gift_list?id=' + bride_id, function (data)
    {
        $('div#gift-section').html(data);
        $("body").css("cursor", "default");

        // $("#loader_progress").hide();
        bindGiftSort();
        bindDeleteGift();
        $(".best_in_place").best_in_place();
        enableProductEdit();

    });

}

function bindNewProduct() {

    $('a#new-product').unbind().bind('ajax:beforeSend', function (e, xhr, settings) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $("body").css("cursor", "progress");
    }).bind('ajax:success', function (xhr, data, status) {
        updateGift();
        setUpPurrNotifier("Notice", "New Product Created!'");
        $("body").css("cursor", "default");
    }).bind('ajax:error', function (evt, xhr, status, error) {
        setUpPurrNotifier("Error", "Product Creation Failed!'");
    });
}