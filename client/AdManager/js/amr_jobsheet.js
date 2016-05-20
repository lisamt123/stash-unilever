$j = jQuery.noConflict();

function openDefaultEmailClientCall(subject, emailTo) {
	mailto="mailto:"+emailTo+"?subject="+subject;
	w=window.open('','_blank','',true);
	w.location.href=mailto;
	//w.close();
}

function enableTextJobSheet() {
	
	var outputIdClassValue = $j('.outputIdClass').val().replace(/[^0-9.]/g, '');
	$j('.outputIdClass').val(outputIdClassValue);
	
	$j('.setinactivemask').addClass('inactivemask');
	$j('body').attr('style', 'pointer-events:none;');

	$j('.outputIdClass').removeAttr('disabled');
	$j('.defaultTv').removeAttr('disabled');
	$j('.defaultCinema').removeAttr('disabled');
	$j('.defaultRadio').removeAttr('disabled');
	$j('.defaultPrint').removeAttr('disabled');
	$j('.defaultInternalVideo').removeAttr('disabled');
	
	
	if($j('.projecttext').is(":visible")) {             
		$j('.projecttextProjDetail').val('');
	} else {                
		$j('.projecttext').val('');
	}
	
	return true;
}

function urlParam(name) {
    var results = new RegExp('[\?&]' + name + '=([^&#]*)').exec(window.location.href);
    if (results == null) {
        return null;
    } else {
        return results[1] || 0;
    }
}

function showPopupJobsheet() {
    $j('#showAlertPopup').click(function(e) {
        $j("body").append('<div class="mask">');
        $j('.alert-popup').show();
    });
}

function calculate() {
    var selectedValue = $j('.selectedIdClass').val();
    var localValue = $j('.inputIdClass').val();

    if (localValue !== null && localValue !== "") {
        if (selectedValue !== '--None--') {
            localValue = parseCurrency(localValue);
            var finalValue = localValue / selectedValue;
            finalValue = finalValue.toFixed(2);
            $j('.outputIdClass').val('\u20AC'+' '+finalValue);
        } else {
            $j('.outputIdClass').val('\u20AC'+' '+0);
        }
    } else {
        $j('.outputIdClass').val('\u20AC'+' '+0);
    }
}

function hideOnPageLoad() {

    $j('.rellocate-popup').hide();
    $j('.show-all-detail').hide();
    $j('.change-status-popup').hide();
    $j('.alert-popup').hide();
}

function updateNotes(Notes) {
    updateNotesData(Notes);
}

function transferCategoryValue(categoryValue) {
    sendCategory(categoryValue);
    $j('.loading').show();
}

function transferValue(projName) {            
	if (projName !== "--None--") {
		$j('.projecttextProjDetail').attr('value', projName);                
	} else {
		$j('.projecttextProjDetail').val('');
	}
}

function catProjectJobsheet(stringArray,strArr,projFormPage,selectedCategory) {
				
		var newOp;
		var none = $j('<option value="--None--">--None--</option>');
		var newOption;
		
	   for(var j=0;j<strArr.length;j++){                 
                if(selectedCategory == strArr[j] && selectedCategory !== null){
                    newOp = $j('<option value="'+strArr[j]+'">'+strArr[j]+'</option>');
                    $j('#categoryList').append(newOp);                   
                }
               
             }
             
             
             $j('#categoryList').append(none);
             
            for(var j=0;j<strArr.length;j++){
                
                if(selectedCategory == strArr[j]){
                 j = j+1;
                }
                 newOp = $j('<option value="'+strArr[j]+'">'+strArr[j]+'</option>');
              
                 $j('#categoryList').append(newOp);
              
              
            }
		
		if(projFormPage.length === 0 || projFormPage == null || projFormPage == ''){
                var none = $j('<option value="--None--">--None--</option>');
                $j('#projectList').append(none); 
          
                for(var i=0;i<stringArray.length;i++){ 
                    if(stringArray[i] == '--None--'){
                        i = i+1;
                    }else{
                         newOption = $j('<option value="'+stringArray[i]+'">'+stringArray[i]+'</option>');
                         $j('#projectList').append(newOption); 
                    }                   
                 } 
           }else{
         
                for(var i=0;i<stringArray.length;i++){  
                   
                    if(projFormPage == stringArray[i] && projFormPage !== null){
                       newOption = $j('<option value="'+stringArray[i]+'">'+stringArray[i]+'</option>');
                       $j('#projectList').append(newOption);                   
                    }  
                 }        
                 for(var i=0;i<stringArray.length;i++){ 
                     
                    if(projFormPage == stringArray[i]){
                        i = i+1;
                    }
                    
                    newOption = $j('<option value="'+stringArray[i]+'">'+stringArray[i]+'</option>');                
                    $j('#projectList').append(newOption);
                 }           
           }
		
}

function closeloading() {       
	$j('.loading').hide();
}

function closeLoadingCategoryJobSheet() {
	$j('.loading').hide();
}

function commonfnCall() {
	$j('.unshare').click(function() {
        var id = $j(this).find('input').val();
        $j(this).parent().hide();
        unshareRapJob(id);
    });

    $j('.show-allocate-popup').click(function(e) {
        e.preventDefault();
        $j('.rellocate-popup').show();
        $j("body").append('<div class="mask">');
    });

    $j('.cancel-change-status-popup').click(function(e) {
        e.preventDefault();
        $j('.change-status-popup').hide();
        //  $j('.show-all-detail').hide();
        $j("div").remove('.mask');
    });
    $j('.cancel-allocation-popup').click(function(e) {
        e.preventDefault();
        $j('.rellocate-popup').hide();
        $j('.show-all-detail').hide();
        $j("div").remove('.mask');
    });
    $j('.cancel-all-popup').click(function(e) {
        e.preventDefault();
        $j('.show-all-detail').hide();
        $j("div").remove('.mask');
    });

    $j('.show-change-status-popup').click(function(e) {
        e.preventDefault();
        $j('.change-status-popup').show();
        $j("body").append('<div class="mask">');
    });

    $j('.show-all-detail-button').click(function(e) {
        e.preventDefault();
        $j('.show-all-detail').show();
        $j("body").append('<div class="mask">');
    });
    $j('.rellocate-apply').click(function(e) {        
        $j('.rellocate-popup').hide();
		$j("div").remove('.mask');
        $j('.show-all-detail').hide();
    });
    $j('.cancel-alert-popup').click(function(e) {
        // e.preventDefault();
        $j('.alert-popup').hide();
        $j("div").remove('.mask');
    });

    $j('.cancel-status-popup').click(function(e) {
        e.preventDefault();
        $j('.change-status-popup').hide();
        $j("div").remove('.mask');
    });
	
	$j(".reallocatepopupstatus select option[value='Pending']").remove();
	$j(".reallocatepopupstatus select option[value='']").remove(); 
	
	if($j('.loadErrorParent').length) {
		$j('html,body').animate({scrollTop: $j('.loadErrorParent').offset().top},'slow');
	} else if($j(".errorM3").length){
		$j('html,body').animate({scrollTop: $j('.errorM3').offset().top},'slow');
	}
}

function defaultParamCall() {
	var defaultParam = urlParam('defaultPage');
	
	var isJobdetail = false;
	isJobdetail 	= ($j('.loadErrorParent').length > 0 || (($j('.job_detail_main .messageText').length > 0)&& $j('.job_detail_main_error_visibility').is(":visible"))|| ($j('.job_detail_main .message').length > 0 && $j('.tabsection .messageText').is(':hidden')));
    if (defaultParam) {
        $j('.main_inner_sectionh4[hashId=' + defaultParam + ']').find('div').attr('class', 'commonall foldclass');
        var data_id_selected = $j('.main_inner_sectionh4[hashId=' + defaultParam + ']').find('div').attr('data-id');
        if (data_id_selected) {
            $j('.' + data_id_selected).show();
        }
    } else if($j('.form-field2 .errorMsg').length > 0 || $j('.production-activity-sub-section .errorM3').length > 0){
		$j('.main_inner_sectionh4[hashId=jobdetails]').find('div').attr('class', 'commonall foldclass');

        var data_id_selected = $j('.main_inner_sectionh4[hashId=jobdetails]').find('div').attr('data-id');
        if (data_id_selected) {
            $j('.' + data_id_selected).show();
        }
		/*
		if($j('.loadErrorParent').length) {
			$j('html,body').animate({scrollTop: $j('.loadErrorParent').offset().top},'slow');
		} else if($j(".errorM3").length){
			$j('html,body').animate({scrollTop: $j('.errorM3').offset().top},'slow');
		}
		*/
	}else if (($j('.compulsory-validation select').val() == '' && $j('.tabsection .errorM3').length == 0)&&(isJobdetail)) {
        $j('.main_inner_sectionh4[hashId=jobdetails]').find('div').attr('class', 'commonall foldclass');

        var data_id_selected = $j('.main_inner_sectionh4[hashId=jobdetails]').find('div').attr('data-id');
        if (data_id_selected) {
            $j('.' + data_id_selected).show();
        }
		/*
		if($j('.loadErrorParent').length) {
			$j('html,body').animate({scrollTop: $j('.loadErrorParent').offset().top},'slow');
		} else if($j(".errorM3").length){
			$j('html,body').animate({scrollTop: $j('.errorM3').offset().top},'slow');
		}
		*/
    } else if ($j('.compulsory-validation select').val() !== '' || $j('.tabsection .messageText').length > 0) {		
        $j('.main_inner_sectionh4[hashId=new_saving]').find('div').attr('class', 'commonall foldclass');

        var data_id_selected = $j('.main_inner_sectionh4[hashId=new_saving]').find('div').attr('data-id');
        if (data_id_selected) {
            $j('.' + data_id_selected).show();
        }		

    }
	loadErrorParentCall();
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
	} else if ($j(".production-activity-section .errorM3").length) {		    	 
		$j('html,body').animate({
			scrollTop: $j(".production-activity-section").offset().top
		}, 'slow');
	} else if ($j(".errorM3").length) {		    	 
		$j('html,body').animate({
			scrollTop: $j(".errorM3").offset().top
		}, 'slow');
	}
}
$j(document).ready(function() {
	
	commonfnCall();
	defaultParamCall();
	
	//var outputIdClassValue = $j('.outputIdClass').val();
	//$j('.outputIdClass').val('\u20AC'+' '+outputIdClassValue);
	
    $j('body').attr('style', 'pointer-events:auto;');
	
	$j('.setinactivemask').attr('class','setinactivemask');
	
    showPopupJobsheet();
    
    if ($j('.projecttextProjDetail').val().length > 0) {
        var projDeatVal = $j('.projecttextProjDetail').val();
        $j('.projectpick').val(projDeatVal);
    }
    hideOnPageLoad();

    // Agency logic
    var agencyFlag = true;
    var agencyValue;
    var agencyPickVal = $j('.agencypick').val();
    if ($j('.agencytext').val().length > 0) {
        agencyValue = $j('.agencytext').val();
        $j('.agencytext').show();
        $j('.agencypick').hide();
        $j('.agencypick option').prop('selected', false);
        //  $j('.agencyother').text('Cancel');
        agencyFlag = false;
    } else {
        $j('.agencytext').val('');
        $j('.agencytext').hide();
    }

    $j('.agencyother').click(function(e) {
        e.preventDefault();
        $j('.agencypick').hide();
        $j('.agencypick option').prop('selected', false);
        $j('.agencytext').show();
        $j('.agencytext').val(agencyValue);
        $j('.agencyother').hide();
        $j('.agencycancel').show();

    });
    $j('.agencycancel').click(function(e) {
        e.preventDefault();
        $j('.agencytext').val('');
        $j('.agencytext').hide();
        $j('.agencypick').show();
        $j('.agencypick').val(agencyPickVal);
        $j('.agencyother').show();
        $j('.agencycancel').hide();
    });

	var projectOtherVal = $j('.projecttext').val()
	var projectPickVal = $j('.projectpick').val();
	$j('.projectotherClass, .projectcancelClass').click(function(e) {
		e.preventDefault();
		var currPage = $j(this).attr('rel');
		if (currPage == 'select') {
			$j('.projectpick').hide();
			$j('.projectpick option').prop('selected', false);
			$j('.projecttext').show();
			$j('.projecttext').val(projectOtherVal);
			$j('.projectotherClass').hide();
			$j('.projectcancelClass').show();
		} else {
			$j('.projecttext').val('');
			$j('.projectpick').val(projectPickVal);
			$j('.projecttext').hide();
			$j('.projectpick').show();
			$j('.projectcancelClass').hide();
			$j('.projectotherClass').show();

		}
	});
});