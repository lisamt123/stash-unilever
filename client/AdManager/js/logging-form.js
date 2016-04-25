var Masterflag = true;
var SubMasterflag = true; 
var idName;
var agencyFlag = true;
var projectFlag = true;
$ = jQuery.noConflict();

window.onload = function() {
	document.getElementById('{!$Component.outputId}').disabled = true;
};
function Calculate()
{
	var selectedValue = document.getElementById('{!$Component.selectedId}').value; 
	/*alert(selectedValue);*/
	var localValue = document.getElementById('{!$Component.inputId}').value; 
	/*alert(localValue);*/
	document.getElementById('{!$Component.outputId}').value= localValue*selectedValue;
}
function isNumber(evt) {
	evt = (evt) ? evt : window.event;
	var charCode = (evt.which) ? evt.which : evt.keyCode;
	if (charCode > 31 && (charCode < 48 || charCode > 57)) {
	return false;
}
	return true;
}
function enableText(){
	document.getElementById('{!$Component.outputId}').disabled = false;
}

$(document).ready(function(){
	$('input.sub-master').click(function() {
	SubMasterflag = true;
	$('input.sub-master').each(function() {
	if(this.checked) {
	SubMasterflag = false;      
	}
	});
	if(true == SubMasterflag ) {
	$('.sub-master-detail').addClass('hide');
	$('.additional').prop('checked', false);
	$('.submasterdetaildiv input:checkbox').prop('checked', false);
	} else {
	$('.sub-master-detail').removeClass('hide'); 
	}
	});
	$('input.original_master').click(function() {
	if (this.checked) {
	$('input.other_master').prop('checked', false);
	$('.master-detail').removeClass('hide');
	$('.additional').prop('checked', false);
	$('.submasterdetaildiv input:checkbox').prop('checked', false);
	} else {
	$('input.other_master').prop('checked', false);
	$('.master-detail').addClass('hide');
	$('.sub-master-detail').addClass('hide');
	}
	});
	$('input.other_master').click(function() {
	Masterflag = true;
	if (this.checked) {
	$('input.original_master').prop('checked', false);
	$('.master-detail').removeClass('hide');
	$('.additional').prop('checked', false);
	$('.submasterdetaildiv input:checkbox').prop('checked', false);
	} else {
	$('input.other_master').each(function() {
	if (this.checked) {
	Masterflag = false;
	$('.master-detail').removeClass('hide');
	}
	});
	if( true == Masterflag ) {
	//$('input.original_master').removeAttr('disabled','disabled');
	$('.master-detail').addClass('hide');
	$('.sub-master-detail').addClass('hide');
	}
	}
	});
	$('.additional').click(function() {
	idName = $(this).attr('data-id');
	if(this.checked) {    
	$('.'+idName).prop('checked', true);
	} else {
	$('.'+idName).prop('checked', false);
	}
	});
	
	
	$('#agencytext').hide();
	$('#projecttext').hide();
	$('#agencyother').click(function(e) {
	e.preventDefault();
	if(agencyFlag == true){
	$('#agencypick').hide();
	$('#agencypick option').prop('selected', false);
	$('#agencytext').show();
	$('#agencyother').text('Cancel');
	agencyFlag = false;
	}else{
	$('#agencytext').val('');
	$('#agencytext').hide();
	$('#agencypick').show(); 
	$('#agencyother').text('Other');
	agencyFlag = true;
	}
	});   
	$('#projectother').click(function(e) {
	e.preventDefault();
	if(projectFlag == true){
	$('#projectpick').hide();
	$('#projectpick option').prop('selected', false);
	$('#projecttext').show();
	$('#projectother').text('Cancel');
	projectFlag = false;
	}else{
	$('#projecttext').val('');
	$('#projecttext').hide();
	$('#projectpick').show(); 
	$('#projectother').text('Other');
	projectFlag = true;
	}
	});
	
	$('.projectother').click(function(e) {
	e.preventDefault();
	if(projectFlag == true){
	$('.projectpick').hide();
	$('.projectpick option').prop('selected', false);
	$('.projecttext').show();
	$('.projectother').text('Cancel');
	projectFlag = false;
	}else{
	$('.projecttext').val('');
	$('.projecttext').hide();
	$('.projectpick').show(); 
	$('.projectother').text('Other');
	projectFlag = true;
	}
	});
});
