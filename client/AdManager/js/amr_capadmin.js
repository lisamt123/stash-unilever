$j = jQuery.noConflict();

function multiCatProjectADM1(strMultiArr,multicatName) {			
	var newOp;			                        			
	for (var j = 0; j < strMultiArr.length; j++) {
		if (multicatName == strMultiArr[j] && multicatName !== null) {
			newOp = $j('<option value="' + strMultiArr[j] + '">' + strMultiArr[j] + '</option>');
			$j('#MultiCategoryList').append(newOp);
		}
	}
	var none = $j('<option value="none">--None--</option>');
	$j('#MultiCategoryList').append(none);

	for (var j = 0; j < strMultiArr.length; j++) {
		if (multicatName == strMultiArr[j]) {
			j = j + 1;
		}
		newOp = $j('<option value="' + strMultiArr[j] + '">' + strMultiArr[j] + '</option>');
		$j('#MultiCategoryList').append(newOp);
	}	
}

function multiCatProjectADM12(strMultiArr,multicatName) {			
	var newOp;			                        			
	for (var j = 0; j < strMultiArr.length; j++) {
		if (multicatName == strMultiArr[j] && multicatName !== null) {
			newOp = $j('<option value="' + strMultiArr[j] + '">' + strMultiArr[j] + '</option>');
			$j('#MultiCategoryList2').append(newOp);
		}
	}
	var none = $j('<option value="none">--None--</option>');
	$j('#MultiCategoryList2').append(none);

	for (var j = 0; j < strMultiArr.length; j++) {
		if (multicatName == strMultiArr[j]) {
			j = j + 1;
		}
		newOp = $j('<option value="' + strMultiArr[j] + '">' + strMultiArr[j] + '</option>');
		$j('#MultiCategoryList2').append(newOp);
	}	
}

function transferMultiCategoryValue(categoryValue){
	sendmultiCategory(categoryValue);
	$j('.multiloading').show();
}				

function transferMultiCategoryValue2(categoryValue){
	sendmultiCategory2(categoryValue);
	$j('.multiloading2').show();
}

function closemultiloading2() {
	$j('.multiloading2').hide();
}
$j(function() { 
	$j(document).on('click', '.catnew', function(event){
		$j('.catnew2 input').val('');
		$j('.catnew2').show();			    
		$j('.catnew1').hide();
		$j(this).attr('class', 'margin-top20 catnewclass' );
		$j(this).text('Cancel');
	});
	
	$j(document).on('click', '.catnewclass', function(event){
		$j('.catnew2 input').val('');
		$j('.catnew2').hide();			    
		$j('.catnew1').show();
		$j(this).attr('class', 'margin-top20 catnew' );
		$j(this).text('Add new');
	});
	
	$j(document).on('click', '.bpnew', function(event){
		$j('.bpnew2 input').val('');
		$j('.bpnew2').show();			    
		$j('.bpnew1').hide();
		$j(this).attr('class', 'margin-top20 bpnewclass' );
		$j(this).text('Cancel');
	});
	
	$j(document).on('click', '.bpnewclass', function(event){
		$j('.bpnew2 input').val('');
		$j('.bpnew2').hide();			    
		$j('.bpnew1').show();
		$j(this).attr('class', 'margin-top20 bpnew' );
		$j(this).text('Add new');
	});
});