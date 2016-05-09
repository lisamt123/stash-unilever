$(document).ready(function() { 
    console.log('in here');
    var table = $('#sowListTable').DataTable({
        "dom": 'lrtip',
        'pageLength': 100,
        'lengthChange': false,
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

    /* Find any element which has a 'data-onload' function and load that to simulate an onload. */
    $('[data-onload]').each(function(){
        eval($(this).data('onload'));
    });

    /*Check if Adjust fee value is empty, if empty disable button*/
    if($('.adjust_allocation_box').val() == ""){
        $("[id$=saveChangesButton]").attr('disabled',true);
    }else{
        $("[id$=saveChangesButton]").attr('disabled',false);
    }

    $('.adjust_allocation_box').on('blur focus onchange mouseleave',
        function(){
            if($('.adjust_allocation_box').val() == ""){
                $("[id$=saveChangesButton]").attr('disabled',true);
            }else{
                $("[id$=saveChangesButton]").attr('disabled',false);
        }
    });

});

function validate(inputId) {
    var element = $('[id=\"'+inputId+'\"]');
    var valid = element[0].checkValidity();
    if (!valid) {
        element.addClass('error-input-border');
    } else {
        element.removeClass('error-input-border');
    }
    return valid;
}

function calculateFee(){
    var percentageElement = $('input[id$=manualPercentage]');
    if($.isNumeric(percentageElement.val()) == false){
        $('#calculatedFee').html('#Error');
    } else {
        var fullFee = $(percentageElement).data('fullfee');
        var calculatedfee = Math.round(fullFee * percentageElement.val() / 100);

        var formatter = new Intl.NumberFormat({
          maximumFractionDigits: 0,
          useGrouping: true,
          minimumSignificantDigits: 1
        });

        var formattedFee = formatter.format(calculatedfee);

        $('#calculatedFee').html('€ ' + formattedFee);
        $('#calculatedFee').data('calculatedfee', calculatedfee);
    }
}

