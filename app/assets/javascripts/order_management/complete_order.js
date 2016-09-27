/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */


function BestInPlaceCallBack(input) {
    console.log(input);

    //    if(input.data.indexOf("product_detail[color]") != -1)
    if (input.attributeName.indexOf("quantity") != -1)
    {
        product_div = $(input.element).parent().parent().parent().parent().parent().parent().parent().parent();
        console.log($(input.element).parent().parent().parent().parent().parent());
        product_id = $(input.element).parent().parent().parent().parent().parent().attr("data-id");
        $("body").css("cursor", "progress");

        $.get('/order_management/get_product_sub_totals?product_id=' + product_id, function (data)
        {
            $(product_div).find("div.product-summary").html(data);
            ;
            updateShoppingCartSummary();
            $("body").css("cursor", "default");
        });
    }
}
;

function updateCartContents() {
    $.ajax({
        url: "/order_management/get_cart_contents",
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
                $("#cart-body").html(data);
                bindProductActions();

            }
        }
    });

}

function updateShoppingCartSummary() {
    $.ajax({
        url: "/site/get_cart_summary_body",
        dataType: "html",
        type: "GET",
        data: {summary_template: "/order_management/order_summary_body.html"},
        success: function (data)
        {
            //alert(data);
            if (data === undefined || data === null || data === "")
            {
                //display warning
            } else
            {
                $("div#current-subtotal").html(data);
                var bride_id = $("div#bride-id").first().text();
                
                if (parseFloat($("div#current-subtotal").text().replace(/\$|,/g, '')) == 0)
                {
                    //alert("Cart is empty");
                    window.location = "/site/show_gifts?id=" + bride_id + "&alert=The%20cart%20is%20now%20empty.";
                }
            }
        }
    });

}

function bindProductActions() {
    $("a.remove-product").button();


    $('a.remove-product').bind('ajax:success', function (xhr, data, status) {

        updateCartContents();
        updateShoppingCartSummary();

        // alert("remove success");
        $("#loader_progress").hide();
    }).bind('ajax:beforeSend', function (e, xhr, settings) {
        xhr.setRequestHeader('accept', '*/*;q=0.5, text/html, ' + settings.accepts.html);
        $("#loader_progress").show();

    });

}

$(document).ready(function () {
    bindProductActions();
});


