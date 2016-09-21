/* 
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

var site_show_my_gifts_callDocumentReady_called = false;


$(document).ready(function () {
    if (!site_show_my_gifts_callDocumentReady_called)
    {
        site_show_my_gifts_callDocumentReady_called = true;
        if ($("#as_window").text() == "true")
        {
            //  alert("it is a window");
        } else
        {
            site_show_my_gifts_callDocumentReady();
        }
    }
});

function site_show_my_gifts_callDocumentReady() {

    $("a#user-settings").button();
     bindAccountClick();

}


function bindAccountClick() {

    $('a#user-settings').bind('ajax:beforeSend', function (evt, xhr, settings) {
        // alert("ajax:before");  
        // console.log('ajax:before');
        // console.log(evt);
        // console.log(xhr);
        // console.log(settings);
        // console.log(this);
        $(this).find("#ajax-wait img").show();

    }).bind('ajax:success', function (evt, data, status, xhr) {


        require("jquery.urlparser.js");

        var windowType = $.url(this.href).param("window_type");
        var theController = $.url(this.href).segment(1);
        var theAction = $.url(this.href).segment(2) || "index"

        //   alert("this is a dialog!")
        //var thisDialog = createEditDialog(data);
        var thisDialog = createAppDialog(data, "app-dialog", {
            completion: function completionCallback() {
            }}, "Submit,Save as Draft,Cancel");

        thisDialog.dialog('open');

        $(thisDialog).find(".best_in_place").best_in_place();

        thisDialog.scrollTop(0);

        //// console.log(status);
        //// console.log(xhr);

        //// console.log(this.href);

        requireCss(theController + "/" + (theAction == 'index' ? 'index_' : theAction) + ".css");
        require(theController + "/" + (theAction == 'index' ? 'index_' : theAction) + ".js");

        //// console.log(theController + "_" + theAction + "_callDocumentReady");

        try
        {
            if ((typeof (theController + "_" + theAction + "_callDocumentReady") == 'function') | (typeof (eval(theController + "_" + theAction + "_callDocumentReady")) == 'function')) {
                eval(theController + "_" + theAction + "_callDocumentReady()");
            }
        } catch (e) {
            // statements to handle any exceptions
            // console.log(e); // pass exception object to error handler
        }




        //// console.log(status);
        //// console.log(xhr);

        //// console.log(this.href);

        //// console.log(theController + "_" + theAction + "_callDocumentReady");


    }).bind('ajax:error', function (evt, xhr, status, error) {
        // alert("ajax:failure"); 
        // console.log('ajax:error');
        // console.log(evt);
        // console.log(xhr);
        // console.log(status);
        // console.log(error);

        $(this).find("#ajax-wait img").hide();
        setUpPurrNotifier("Network Error", "A network error has occured, please click the icon again.")

    }).bind('ajax:complete', function (evt, xhr, status) {
        //    alert("ajax:complete");  
        // console.log('ajax:complete');
        // console.log(evt);
        // console.log(xhr);
        $('#edit-dialog').scrollTop(0);

        // // console.log(status);


    });

}