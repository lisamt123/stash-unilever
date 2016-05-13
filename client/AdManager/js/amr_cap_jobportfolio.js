function setFocusOnLoad() {}

function transferCategoryValue(categoryValue) {
    sendCategory(categoryValue);
    $j('.loading').show();
}

function closeloading() {
    $j('.loading').hide();
}

function callFuctionForJobsSort(jobsSort) {
    callContrlJobsSort(jobsSort);
}

function callFuctionForCancelSort(jobsCancel) {
    callContrlCancelSort(jobsCancel);
}

function callActionFunctionStartDate(startDate) {

    callContrlStartDate(startDate);
}

function redirectToScheduler() {
    window.location.href = 'apex/Amr_AdManager';
}

function checkAll(cb, cbid) {
    var inputElem = document.getElementsByTagName("input");
    for (var i = 0; i < inputElem.length; i++) {
        if (inputElem[i].id.indexOf(cbid) != -1) {
            inputElem[i].checked = cb.checked;
        }
    }
}

function transferValue(projName, jobdetailprojectfield) {
    if (projName !== "--None--") {

        if (projName == 'other') {
            $j('#projectNameOther').show();
        } else {
            $j('.hidden-project-detail').val(projName);
            $j('.projecttextProjDetail').val(projName);
            $j('#projectNameOther').hide();
        }
    }

}

$j(function() {
    addHeaderTitle();
    $j("#datepicker").datepicker();

    $j('#projectNameOther').hide();

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

    $j('.pbTitle').remove();
	
	var defaultSection = urlSection('defaultSection');
	if(defaultSection && defaultSection=='CancelList') {		
			$j('.foldclass').attr('class','commonall openclass');
			$j('.joblist-section').hide();
			$j('.joblist-cancelled-section').show();
			$j('.cancelled-joblist-main-section h4.main_inner_sectionh4 .openclass').attr('class','foldclass');		
	}
});