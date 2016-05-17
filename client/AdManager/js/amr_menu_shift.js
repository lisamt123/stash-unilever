$j = jQuery.noConflict();

$j(function(){
	var content = $j('#AppBodyHeader').html();        		
	$j('#Maintab').html(content);
	$j('#contentWrapper #AppBodyHeader.bPageHeader').remove();
	$j('.zen').show();
});

function isCurrency(evt) {
	evt = (evt) ? evt : window.event;
	var charCode  = (evt.which) ? evt.which : evt.keyCode;
	var CurrValue = $j(evt.target).val();		
	if((CurrValue.length == 0)&&( charCode == 44 || charCode == 46 )) {
		return false;
	} 	
	if ((charCode > 31 && (charCode < 48 || charCode > 57))&&(charCode !== 46)&&(charCode !== 44)) {
		return false;
	}
	if((CurrValue[CurrValue.length-1] == ',')&&(charCode == 44 || charCode == 46 )) {
		return false;
	}
	if((CurrValue[CurrValue.length-1] == '.')&&(charCode == 44 || charCode == 46 )) {
		return false;
	}
	if(((CurrValue.indexOf('.') > -1)) && ( charCode == 46 )) {
		return false;
	}
	return true; 	 	
}

function parseCurrency(localValue) {
	localValue = parseFloat( localValue.replace(/,/g,'') );
	return localValue;
}