/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.

var site_show_gifts_callDocumentReady_called = false;


$(document).ready(function () {
    if (!site_show_gifts_callDocumentReady_called)
    {
        site_show_gifts_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        } else
        {
            site_show_gifts_callDocumentReady();
        }
    }
});

function site_show_gifts_callDocumentReady() {

    // update left to correct height.
    $("#page-middle-left").height($("#page-body").height() + parseInt($("#page-body").css("margin-top")))


    require("brides/shared.js");
    brideeditClickBinding("div.edit-bride-gear");


    if ($("#admin-active").text() == "true") {
        // alert("Admin Active");
        setUpOrderChange();
        //bindProductMenu();
    }
    bestInPlaceCallbackInits();
}
;
function updateShoppingCartView() {
    $.ajax({
        url: "/site/get_shopping_cart_info",
        dataType: "html",
        type: "GET",
        data: "",
        success: function (data)
        {
            //alert(data);
            if (data === undefined || data === null || data === "")
            {
                //display warning
            } else
            {
                if ($("#shopping-cart.normal").length > 0)
                {
                    $("div#shopping-cart.normal div#shopping-cart-info").html(data);
                } else {
                    $("#shopping-cart-info").html(data);
                }
            }
        }
    });

    if ($("#shopping-cart.small").length > 0) {
        $.ajax({
            url: "/site/get_shopping_cart_info",
            dataType: "html",
            type: "GET",
            data: "small=true",
            success: function (data)
            {
                //alert(data);
                if (data === undefined || data === null || data === "")
                {
                    //display warning
                } else
                {
                    $("div#shopping-cart.small div#shopping-cart-info").html(data);
                }
            }
        });
    }

}

function bestInPlaceCallbackInits() {

    $("div.field div.best_in_place").each(function (index, value) {
        BestInPlaceEditorObject(value).setSuccessCallback(
                function (editor) {
                    // $("#schedule-total-loads").text(parseInt($("#best_in_place_schedule_truck_number").text()) * parseInt($("#best_in_place_schedule_number_turns").text()))
                    console.log("worked!");
                    updateShoppingCartView();
                });
    });
}

//
// Admin editor 
//

function orderUpdate(event, ui)
{
    alert("order changed!");
    console.log(event);
    console.log(ui);
}

function setUpOrderChange() {
    //    $( "#gift-block" ).sortable({ 
    //        handle: "#edit-gift" , 
    //        stop: function( event, ui ) {
    //            orderUpdate(event,ui);
    //        }
    //    });
    var currentPage = $("#page_number").text();

    $('#gift-block').sortable({
        dropOnEmpty: false,
        items: 'div.gift-item',
        handle: '.handle',
        cursor: '-webkit-grabbing',
        opacity: 0.4,
        scroll: true,
        update: function () {
            $.ajax({
                type: 'post',
                data: $('#gift-block').sortable('serialize') + "&   page=" + currentPage,
                dataType: 'script',
                complete: function (request) {
                    $('#gift-block').effect('highlight');
                },
                url: '/brides/update_gift_order'
            })
        }
    });
}

