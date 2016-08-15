/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


var order_management_order_page_callDocumentReady_called = false;

$(document).ready(function () {
    if (!order_management_order_page_callDocumentReady_called)
    {
        order_management_order_page_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        }
        else
        {
            order_management_order_page_callDocumentReady();
        }
    }
});

function order_management_order_page_callDocumentReady() {
    require("jquery.serialize-object.js");
    bind_click_to_order_button();
}

function bind_click_to_order_button()
{
    require("jquery.serialize-object.js");

    $("a#order-button").off("click").on("click", function (event) {
        // get data
        data = $('form#size-color-form').serializeObject();

        $.ajax({
            url: "/order_management/add_to_order",
            dataType: "html",
            type: "post",
            data: data,
            success: function (data)
            {
                console.log(data);
                $("button.ui-dialog-titlebar-close").trigger("click")
                updateShoppingCartView();
                if (data == undefined || data == null || data == "")
                {
                    //display warning
                }
                else
                {
                    setUpPurrNotifier("Alert", data);
                    // $("#cart-contents").html(data);
                    //  bindProductActions();

                }
            }
        });
    });
}

