$(document).ready(function() { 
    var table = $('#sowListTable').DataTable({
        "dom": 'lrtip',
        'pagingType': 'full_numbers'
    });
    $('#sowListTable tbody').on('click', 'td', function() {
        if ($(this).hasClass("redirect_td")) {
            $(this).parent().toggleClass('selected');
            $(this).parent().addClass('bg_selected');

            var ids = $.map(table.rows('.selected').data(), function(item) {
                var temp = item[0].toString();
                var tempArray = temp.match(">(.*)<");
                return tempArray[1];
            });
            //alert(ids);
            if(typeof viewAssetFunction !== 'undefined'){
                blockme();
                viewAssetFunction(ids);
            }
        } 
    });
    $('.expandMore').readmore({
        moreLink: '<a href="#">Read more</a>',
        lessLink: '<a href="#">Close</a>',
        collapsedHeight: 36,
        blockCSS: 'display: block; width: 100%;',
        afterToggle: function(trigger, element, expanded) {
            if( expanded) { // The "more" link was clicked
                $(this).width("width","100%");
            }
        }
    });
    $('.expandMoreCountries a').click(function(e) {
        e.preventDefault();
        $('#countryPreview').toggleClass('hidden');
        $('#countryFullList').toggleClass('hidden');
    });
    $("[data-toggle=popover]").popover();
});

function calculateFee(){
    var percentageElement = $('input[id$=manualPercentage]');
    if($.isNumeric(percentageElement.val()) == false){
        $('#calculatedFee').html('#Error');
        $('#confirm_cancel_campaign').attr('disabled', 'disabled');
    } else {
        percentageElement.val(Math.round(percentageElement.val()));
        var fullFee = $(percentageElement).data('fullfee');
        var calculatedfee = Math.round(fullFee * percentageElement.val() / 100);
        $('#calculatedFee').html('€ ' + calculatedfee);
        $('#calculatedFee').data('calculatedfee', calculatedfee);
        $('#confirm_cancel_campaign').removeAttr('disabled');
    }
}