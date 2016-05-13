$ = jQuery.noConflict();

function blockme() {
    $.blockUI({
        css: {
            border: 'none',
            padding: '15px',
            backgroundColor: '#000',
            '-webkit-border-radius': '10px',
            '-moz-border-radius': '10px',
            opacity: .5,
            color: '#fff'
        }
    });
}

function onKeyPress_IsDigitAndDecimalValidation(event, element) {
    var isDigitOrDot = event.charCode >= 48 && event.charCode <= 57 || event.keyCode == 46;
    var parts = $(element).val().split(/[.,]/);
    if (parts.length <= 1) { //Has no decimals - check if is digit
        return isDigitOrDot;
    } else if (parts.length == 2) { //has decimals - check if is digit and <2 decimals
        return (isDigitOrDot && parts[1].length < 2);    
    }
    return true;
}


$(document).ready(function() {
    
    $("link.user").each(function(index, value) {
        //console.log( index + ": " + value.href );
        if (value.href.indexOf("extended") > 0) {
            console.log('pass');
            $(this).attr("disabled", "disabled");
            this;
        }
    });
    $('html').bind('keypress', function(e){
        if(e.keyCode == 13){
            return false;
        }
    });
});