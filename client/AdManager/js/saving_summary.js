$j = jQuery.noConflict();
function setFocusOnLoad() {}
$j(function() {

    addHeaderTitle();

    $j('.advance-search-popup').hide();

    $j('.advance-popup').click(function(e) {
        e.preventDefault();
        $j("body").append('<div class="mask">');
        $j('.advance-search-popup').show();
    });
    $j('.cancel-advance-popup').click(function(e) {
        e.preventDefault();
        $j("div").remove('.mask');
        $j('.advance-search-popup').hide();
    });
    $j('.apply-advance-popup').click(function(e) {
        $j("div").remove('.mask');
        $j('.advance-search-popup').hide();
    });

    $j("#datepicker").datepicker();
    $j("#datepicker1").datepicker();
	$j("#datepicker2").datepicker();
});

function transferCategoryValue(categoryValue) {
    sendCategory(categoryValue);
    $j('.loading').show();
}

function callActionFunctionStartDate(startDate) {
    callContrlStartDate(startDate);
}

function callActionFunctionEndDate(endDate) {
    callContrlEndDate(endDate);
}

function callActionFunctionTotalFilms(films) {
    callContrlFilms(films);
}

function callFuctionForJobsSort(jobsSort) {
    callContrlJobsSort(jobsSort);
}