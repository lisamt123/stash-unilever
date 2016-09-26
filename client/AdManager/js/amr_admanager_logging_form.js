$j = jQuery.noConflict();

var agencyFlag      = true;
var projectFlag     = true;         

function transferValue(projName)
{           
	if(projName!=="--None--") {  
	$j('.projecttextProjDetail').val(projName);          
	}else{
	$j('.projecttextProjDetail').val('');
	}
}

function callActionFunctionProjectName(projectName) {       
	callContrlProjectName(projectName);
}  


function calculateOnChangenKP(onchange) {                  
	var selectedValue   = $j('.selectedIdClass').val();
	var localValue      = $j('.inputIdClass').val();   


	if(localValue!==null && localValue !=="") {  
		if(selectedValue  !=='--None--'){		
			localValue = parseCurrency( localValue );		
			var finalValue =localValue/selectedValue;
			finalValue=finalValue.toFixed(2);   
			$j('.outputIdClass').val('\u20AC'+' '+finalValue);
		}else{
			$j('.outputIdClass').val('\u20AC'+' '+0);					
			if(onchange) {
				$j('.inputIdClass').val('');
			}		
		}
	}else{
		$j('.outputIdClass').val('\u20AC'+' '+0);
	}               
}

function enableText() {
		
	$j('.setinactivemask').addClass('inactivemask');
	$j('.outputIdClass').removeAttr('disabled');             
	$j('.defaultTv').removeAttr('disabled');
	$j('.defaultCinema').removeAttr('disabled');
	$j('.defaultRadio').removeAttr('disabled');
	$j('.defaultPrint').removeAttr('disabled');
	$j('.defaultInternalVideo').removeAttr('disabled');     	
	
	var sumData = $j('.summary').html();
	sumData = sumData.replace('<div class="summary-title">Summary</div>', '');
	var dataText = $j(sumData).text();
	var arrayString = sumData.split('<div class="clear"></div>');
	var paList ='';
	for(var i=1;i<arrayString.length-1;i++){
		var adding = $j(arrayString[i]).text();
		paList += '\n \n' + adding;
	}
	sendProductionActivity(paList);                      
}

function allSummaryData(){            
	sendProductionActivity(paList);
}

function closeloading() {       
	$j('.loading').hide();
}

function transferCategoryValue(categoryValue){
	sendCategory(categoryValue);
	$j('.loading').show();
}

function enableText1() {    
	
	var outputIdClassValue = $j('.outputIdClass').val().replace(/[^0-9.]/g, '');	
	$j('.outputIdClass').val(outputIdClassValue);	
	
	$j('.setinactivemask').addClass('inactivemask');
	$j('body').attr('style', 'pointer-events:none;');
	$j('body').css({'cursor':'wait'});
	
	$j('.outputIdClass').removeAttr('disabled');             
	$j('.defaultTv').removeAttr('disabled');
	$j('.defaultCinema').removeAttr('disabled');
	$j('.defaultRadio').removeAttr('disabled');
	$j('.defaultPrint').removeAttr('disabled');
	$j('.defaultInternalVideo').removeAttr('disabled'); 
   
	allSummaryData1();                          
}     
function allSummaryData1(){   
	$j('.summary-detail').append('--');
	var sumData = $j('.summary').html();               
	sumData = sumData.replace('<div class="summary-title">Summary</div>', '');
	var dataText = $j(sumData).text();           
	var arrayString = sumData.split('<div class="clear"></div>');              
	var paList ='';
	for(var i=1;i<arrayString.length-1;i++){                
		var adding = $j(arrayString[i]).text();
		paList += '\n' + adding;
	}                
	sendProductionActivity(paList);
}

function catProjectADM(stringArray,strArr,projFormPage,catName) {
	var newOption;
	var newOp;
	for (var i = 0; i < stringArray.length; i++) {
		if (projFormPage == stringArray[i] && projFormPage !== null) {
			newOption = $j('<option value="' + stringArray[i] + '">' + stringArray[i] + '</option>');
			$j('#projectList').append(newOption);
		}
	}

	for (var i = 0; i < stringArray.length; i++) {
		if (projFormPage == stringArray[i]) {
			i = i + 1;
		}
		newOption = $j('<option value="' + stringArray[i] + '">' + stringArray[i] + '</option>');
		$j('#projectList').append(newOption);
	}                        
	
	for (var j = 0; j < strArr.length; j++) {
		if (catName == strArr[j] && catName !== null) {
			newOp = $j('<option value="' + strArr[j] + '">' + strArr[j] + '</option>');
			$j('#categoryList').append(newOp);
		}
	}
	var none = $j('<option value="none">--None--</option>');
	$j('#categoryList').append(none);

	for (var j = 0; j < strArr.length; j++) {
		if (catName == strArr[j]) {
			j = j + 1;
		}
		newOp = $j('<option value="' + strArr[j] + '">' + strArr[j] + '</option>');
		$j('#categoryList').append(newOp);
	}	
}

function loadErrorParentCall() {
    /*Load Error code*/ 

    $j('.loadError').each(function() {
        var lengthOfParent = $j(this).attr('data-width');
        if (lengthOfParent) {
            $j(this).closest('.form-field-parent').addClass('loadErrorParent width70percent');
        } else {
            $j(this).closest('.form-field-parent').addClass('loadErrorParent');
        }
    });

    /*End of load error code*/

    if ($j(".loadErrorParent").length) {
		$j('html,body').animate({
			scrollTop: $j(".loadErrorParent").offset().top
		}, 'slow');	
	} else if ($j(".errorM3").length) {		    	 
		$j('html,body').animate({
			scrollTop: $j(".errorM3").offset().top
		}, 'slow');
	}
}
$j(document).ready(function() {
	
	$j('body').attr('style', 'pointer-events:auto;');
	$j('body').css({'cursor':'default'});
	
	$j('.setinactivemask').attr('class','setinactivemask');
	
	//Default popup for your email address                
	$j('.your_email_address').val( $j('.your_email_address').attr('default-value') );

	//Auto calculation                                                
	$j('.outputIdClass').attr('disabled', 'disabled');
	$j('.outputIdClass').css('background', '#EFEFEF');

	// Agency logic
	if($j('.agencytext').val().length>0) {
		$j('.agencytext').show();
		$j('.agencypick').hide();
		$j('.agencypick option').prop('selected', false);
		$j('.agencyother').text('Cancel');
		agencyFlag = false;
	} else {
		$j('.agencytext').val('');
		$j('.agencytext').hide();
	}

	$j('.agencyother').click(function(e) {
		e.preventDefault();
		if(agencyFlag == true){
			$j('.agencypick').hide();
			$j('.agencypick option').prop('selected', false);
			$j('.agencytext').show();
			$j('.agencyother').text('Cancel');
			agencyFlag = false;
		} else {
			$j('.agencytext').val('');
			$j('.agencytext').hide();
			$j('.agencypick').show(); 
			$j('.agencyother').text('Other');
			agencyFlag = true;
		}
	});  

	// Project info logic
	if($j('.projecttext').val().length>0) {
		$j('.projecttext').show();
		$j('.projectpick').hide();
		$j('.projectpick option').prop('selected', false);
		$j('.projectotherClass').text('Cancel');
		projectFlag = false;
	} else { 
		$j('.projecttext').val('');
		$j('.projecttext').hide();
		$j('.projectpick').show(); 
		$j('.projectotherClass').text('Other');
		projectFlag = true;   
	}

	$j('.projectotherClass').click(function(e) {
		e.preventDefault();                    
		if(projectFlag == true) {                   
			$j('.projectpick').hide();
			$j('.projectpick option').prop('selected', false);
			$j('.projecttext').show();
			$j('.projectotherClass').text('Cancel');
			projectFlag = false;
		} else {
			$j('.projecttext').val('');
			$j('.projecttext').hide();
			$j('.projectpick').show(); 
			$j('.projectotherClass').text('Other');
			projectFlag = true;
		}
	});
	if( $j('.projecttextProjDetail').val().length>0){
		var projDeatVal =$j('.projecttextProjDetail').val();	
		$j('.projectpick').val(projDeatVal);                     
	}	
	
	if($j(".loadErrorParent").length) {
		$j('html,body').animate({scrollTop: $j(".loadErrorParent").offset().top},'slow');
	} else if($j(".errorM3").length){
		$j('html,body').animate({scrollTop: $j(".errorM3").offset().top},'slow');
	}	
});