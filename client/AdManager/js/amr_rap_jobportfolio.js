$j = jQuery.noConflict();

function transferCategoryValue(categoryValue) {
	sendCategory(categoryValue);
	$j('.loading').show();
}

function closeloading() {
	$j('.loading').hide();
}

function callActionFunctionStartDate(startDate) {
	callContrlStartDate(startDate);
}

function transferValue(projName) {
	if (projName !== "--None--") {

		if (projName == 'other') {
			$j('#projectNameOther').show();
		} else {
			$j('.projecttextProjDetail').val(projName);                    
			$j('#projectNameOther').hide();
		}
	}
}

$j(function() {
	//$j("#datepicker").datepicker();
	
	$j('.alert-popup').hide();
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
	$j('.cancel-alert-popup').click(function(e) {
		e.preventDefault();
		$j("div").remove('.mask');
		$j('.alert-popup').hide();
	});
	$j('.hide-alert').click(function() {
		var selectedInput = $j(this).parent().find('input');
		var id = selectedInput.val();
		hideAlert(id);
		$j(this).parent().parent().remove();
	});
	$j('#projectNameOther').hide();
	showPopupRAPPortfolio();
});	

function showPopupRAPPortfolio() {
	$j('#showalertPopup').click(function() {
		$j("body").append('<div class="mask">');
		$j('.alert-popup').show();
	});	
}