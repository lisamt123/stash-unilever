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