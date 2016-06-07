google.load("visualization", "1", {packages:["corechart"]});
google.setOnLoadCallback(drawChart);

function drawChart() {
    /*var data = google.visualization.arrayToDataTable([
    ['Task', 'Hours per Day'],
    ['Audio / Visual',     11],
    ['Digital',      2],
    ['Experiental',  2],
    ['Static Imagery', 2],
    ['Stimulus Materials',    7]
]);*/
    var totalAssets = $('#chart_div').data('chart-total-assets');
    if(typeof totalAssets !== 'undefined' && totalAssets !== 0){
        console.log($('#chart_div').data('chart-data'));
        var data = new google.visualization.DataTable();
        data.addColumn('string', 'Asset');
        data.addColumn('number', 'Count of Items');
        var arrayCreated = $('#chart_div').data('chart-data');
        var newArray = [];
        for (var i=0; i < arrayCreated.length; i++){
            console.log(arrayCreated[i][0]);
            console.log(arrayCreated[i][1]);
            //data.addRow([i[0], parseInt(i[1])]); 
            newArray.push([arrayCreated[i][0], parseInt(arrayCreated[i][1])]);
        }
        data.addRows(newArray);
        if(data.getNumberOfRows() > 0){
            console.log(JSON.stringify(data));
            var options = {
                pieHole: 0.5,
<<<<<<< HEAD
                colors: ['#FFC62C', '#B187B8', '#CEDC02', '#E46CB0', '#05B1A9'],
=======
                colors: ['#B187B8', '#CEDC02', '#E46CB0', '#05B1A9','#FFC62C'],
>>>>>>> develop
                legend: {position : 'none', alignment : 'center'},
                chartArea: {width: '75%', height: '75%'},
                fontSize: 15
            };

            var chart = new google.visualization.PieChart(document.getElementById('chart_div'));
            chart.draw(data, options);
        }
    }
}
$(document).ready(function() { 
    console.log('in here');
    var table = $('#sowListTable').DataTable({
        "dom": 'lrtip',
        //'pageLength': 100,
        //'lengthChange': false,
        'pagingType': 'full_numbers',
        'bPaginate' : false
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

    $('#cancelCampaignModal').on('shown.bs.modal', function (e) {
        blockCancelModal(); 
        refreshPopUpStageIdentifier();
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

    $("[id$=AdjustPercentage]").on("keyup",function(e) {
        console.log(e);
        console.log('### target: ');
        console.log(e.currentTarget);
        validateTotalAdjustFee(e.currentTarget, 'adjustFeeExcessWarning');
    });

    $("[id$=manualPercentage]").on("keyup",function(e) {
        console.log(e);
        console.log('### target: ');
        console.log(e.currentTarget);
        validateTotalAdjustFee(e.currentTarget, 'adjustFeeExcessWarningOnCancel');
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

validateTotalAdjustFee = function(item, panelId) {

    var maxAllowedAdjustValue = parseFloat($('#maxAllowedAdjustValue').val());
    var currValue = parseFloat($(item).val());

    if (currValue > maxAllowedAdjustValue) {
        $('#'+panelId).removeClass('hidden');
    } else {
        $('#'+panelId).addClass('hidden');
        //$('#adjustFeeExcessWarning').addClass('hidden');
        //$('#adjustFeeExcessWarningOnCancel').addClass('hidden');
    }
}

function calculateFee(){
    var percentageElement = $('input[id$=manualPercentage]');
    var percentageFeePFY = $('input[id$=percentageFeePFY]').val();
    var feesPFYwithFXadjustment = $('input[id$=feesPFYwithFXadjustment]').val();

    if($.isNumeric(percentageFeePFY) == false){
        percentageFeePFY = 0;
    }

    if($.isNumeric(feesPFYwithFXadjustment) == false){
        feesPFYwithFXadjustment = 0;
    }

    if($.isNumeric(percentageElement.val()) == false){
        $('#calculatedFee').html('#Error');
    } else {
        var fullFee = $(percentageElement).data('fullfee');
        var calculatedfee = Math.round(((parseFloat(percentageElement.val()) + parseFloat(percentageFeePFY)) * parseFloat(fullFee) / 100) - parseFloat(feesPFYwithFXadjustment));

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

var blockCancelModal = function() {
    //console.log('### block: ' + containerId);
    //$("span[id$=\'"+containerId+"\'] .campaign_stage_chevron_blockme").block({ 
    $("#cancelCampaignModal .modal-body").block({ 
        message: 'Please wait...',
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

var unblockCancelModal = function() {
    //console.log('### unblock: ' + containerId);
    $("#cancelCampaignModal .modal-body").unblock();
}

