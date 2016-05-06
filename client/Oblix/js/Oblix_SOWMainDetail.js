$ = jQuery.noConflict();
$('.read_more').click(function() {
    alert( "Handler for .click() called." );
    return false;
});
$(document).ready(function() {
    // force a user to write comments when rejecting SOW approval
    $('[id$="rejectComments"]').keyup(function(){
        if($(this).val() === ''){
            $('[id$="rejectButton"]').attr('disabled', 'disabled');
        } else {
            $('[id$="rejectButton"]').removeAttr('disabled');
        }
    });

    //Repaced below usage of Readmore.JS plugin with custom jQuery to satisfy requirement
    //of displaying first 3 clusters/countries ONLY in minified mode
    /*$('.countriesSelected').readmore({
        moreLink: '<a href="#">Read more</a>',
        lessLink: '<a href="#">Close</a>',
        collapsedHeight: 20,
        blockCSS: 'display: block; width: 100px;',
        // afterToggle: function(trigger, element, expanded) {
        //     if(expanded) { // The "more" link was clicked
                // $(this).addClass("width","100px");
                // $(this).addClass("fix_table_cell_expand_height");
        //     }
        // }
        afterToggle: function(trigger, element, expanded) {
            if(expanded) { // The "more" link was clicked
                $(element).addClass("width","100px");
                $(element).addClass("fix_table_cell_expand_height");
            }
        },
        beforeToggle: function(trigger, element, expanded) {
            if(expanded) { // The "close" link was clicked
                $(element).addClass("width","100px");
                $(element).removeClass("fix_table_cell_expand_height");
            }
        }
    });*/

    $('.expandMoreCountries a').on("click", function(e) {
        e.preventDefault();
        $(this).parents('.expandMoreCountries').find('.countryPreview').toggleClass('hidden');
        $(this).parents('.expandMoreCountries').find('.countryFullList').toggleClass('hidden');
    });

    $('tr[data-href]').on("click", function(e) {
        if ((e.target.nodeName == 'A') || ((e.target.nodeName == 'DIV') && (e.target.className == 'countryList'))) {
            //Do not navigate to the Campaign detail page if click was made on "Read more"/"Close" links or 
            //the country list itself
            e.preventDefault();
        } else {
            document.location = $(this).data('href');
        }
    });

    var table = $('#sowListTable').DataTable({
        "dom": 'lrtip',
        "pagingType": "full_numbers",
        "bAutoWidth": false,
        "aoColumns": [
          { "sWidth": "0%" },
          { "sWidth": "100px" },
          { "sWidth": "50px" },
          { "sWidth": "100px" },
          { "sWidth": "50px" },
          { "sWidth": "450px" },
          { "sWidth": "50px" },
          { "sWidth": "100px" }
       ]
    });
    $('#searchBox').on('keyup', function() {
        table.search(this.value).draw();

    });

});

function messageUser(swopName){
        $.unblockUI();
        alert('(' + swopName + ') has been approved successfully by Unilever and Agency.\nAn \'open for updates\' version will be available shortly to allow Unilever reflect any changes during the year.');
        window.location.href='/agency/apex/oblix_sowmain'
    }