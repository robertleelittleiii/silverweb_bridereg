/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */



$(document).ready(function () {

    enableBrideMyAccount();
    intercept_click();

});


function enableBrideMyAccount() {
    var bride_active = $("div#bride-active").text();
    var bride_location = "/site/show_my_gifts"
    
    if (bride_active == "true") {
        
        if ($("div#admin-nav.normal").length > 0) {
            $("div#admin-nav #my-account").off("click").click(function () {
                
                window.location.href = bride_location;
            });
        } else
        {
            $("div#admin-nav.normal #my-account").off("click").click(function () {
                window.location.href = bride_location;
                // $("#nav-grid-links").fadeIn();
            });
            $("div#admin-nav.small #my-account").off("click").click(function () {
                window.location.href = bride_location;
            });
        }

    }

}

function validate_login(url_to_goto) {
    if ($($("div#logged-in")[0]).text() == "true") {
        window.location = url_to_goto;
        return(false);
    }
    else {
        loadLoginBox(url_to_goto);
        return(true);
    }

}

function intercept_click() {
    $("a.validate-login").click(function (event){
        event.stopPropagation();
        validate_login($(this).attr('href'));
        return false;
    });
}
