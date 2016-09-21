/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

// TODO:  Add ajax function to load pictures based on properties object.


function bindZoomClick() {
    $("#zoom-invoice").click(function () {
        var zoomName = $("#zoom-invoice span").text()

        if (zoomName == "Zoom Invoice") {

            $("#zoom-invoice span").text("Shrink Invoice");
            $('div#frame-wrapper').addClass("zoom");
            $('#invoice-frame').addClass("zoom");
            $('#invoice-frame').removeClass("shrink");
//            
//            $('#invoice-frame').effect('scale', {
//                scale:'content',
//                origin: ['top','left'],
//                percent:250
//            }, 1000, function(){
                $("#invoice-tools").width("100%");
                $("#invoice-tools").css("margin-left","0px"); 

//                $('#invoice-frame').css('top', '0').css('left', '0'); 
//                $('#invoice-frame').css('width', '99%').css('height', '99%'); 
//
//                
//            });
        } else
        {
            $("#zoom-invoice span").text("Zoom Invoice");
            $('#invoice-frame').addClass("shrink");
            $('#invoice-frame').removeClass("zoom");
            $('#invoice-frame').on('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd',
                    function () {
                        $('div#frame-wrapper').removeClass("zoom");
                        $('#invoice-frame').off('transitionend webkitTransitionEnd oTransitionEnd otransitionend MSTransitionEnd')
                    });

//            $('#invoice-frame').effect('scale', {
//                scale:'content',
//                origin: ['top','left'],
//                percent:40
//            }, 1000, function() {
                $("#invoice-tools").width("525px");
                $("#invoice-tools").css("margin-left","25px");
//                $('#invoice-frame').css('top', '0').css('left', '0'); 
//                $('#invoice-frame').css('width', '39%').css('height', '39%'); 
//
//                
//            });
        }


        //  $('#invoice-frame').effect('scale', {scale:'content',percent:40}, 1000);


    });
    
}


$(document).ready(function () {
    bindZoomClick();
    
    $("a#zoom-invoice").button();
    $("div#invoice-tools-body a.navigation-link").button();
    $('#invoice-frame').css('top', '0').css('left', '0');


//    $('#invoice-frame').effect('scale', {
//                scale:'content',
//                origin: ['top','left'],
//                percent:40
//            }, 1000, function() {
//                $("#invoice-tools").width("585px");
//                $('#invoice-frame').css('top', '0').css('left', '0'); 
//                $('#invoice-frame').css('width', '39%').css('height', '39%'); 
//
//                
//            });

});

