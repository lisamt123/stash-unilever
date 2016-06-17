$j = jQuery.noConflict();

function setFocusOnLoad() {}

function addHeaderTitle() {
    $j('.tabsection th').each(function() {
        var title = $j(this).find('div').html();
        if (title) {
            $j(this).attr('title', title);
        }
    });
	
	$j('.tabsectionModified th').each(function() {
        var title = $j(this).find('div').html();
        if (title) {
            $j(this).attr('title', title);
        }
    });
}

function setTab(param) {
    var vars = {};
    window.location.href.replace(location.hash, '').replace(
        /[?&]+([^=&]+)=?([^&]*)?/gi, // regexp
        function(m, key, value) { // callback
            vars[key] = value !== undefined ? value : '';
        }
    );

    if (param) {
        return vars[param] ? vars[param] : null;
    }
    return vars;
}

function makeAllOtherFold() {

    $j('.foldclass').each(function() {
        var dataId1 = $j(this).attr('data-id');
        //alert(dataId1);				
        $j(this).attr('class', 'commonall openclass');
        $j('.' + dataId1).slideToggle(500);
    });
}

function commonclass($obj) {    
    var dataId = $obj.attr('data-id');

    if ($obj.hasClass('minusclass')) {
        $obj.attr('class', 'commonall plusclass');
        $j('.' + dataId).slideToggle(500);
    } else if ($obj.hasClass('plusclass')) {
        $obj.attr('class', 'commonall minusclass');
        $j('.' + dataId).slideToggle(500);
    } else if ($obj.hasClass('foldclass')) {
        $obj.attr('class', 'commonall openclass');
        $j('.' + dataId).slideToggle(500);
    } else if ($obj.hasClass('openclass')) {
        makeAllOtherFold();
        $obj.attr('class', 'commonall foldclass');
        $j('.' + dataId).slideToggle(500);
    }
}

function selectedFolder() {
    var folder = $j('.FolderSelected').val();
    downloadSelectedFiles(folder);
}

function callActionFunctionStartDate(startDate) {
    callContrlStartDate(startDate);
}

function callActionFunctionEndDate(endDate) {
    callContrlEndDate(endDate);

}

function callFuctionForPrioritySort(prioritySortOption) {
    callContrlPrioritySort(prioritySortOption);
}

function callFuctionForPendingSort(pendingSortOption) {
    callContrlPendingSort(pendingSortOption);
}

function callFuctionForDormantSort(dormantSortOption) {
    callContrlDormantSort(dormantSortOption);
}

function callFuctionForLiveSort(liveSortOption) {
    callContrlLiveSort(liveSortOption);
}

function currencyPopupCommonCurrencyRelatedcall() {
	$j('.commonCurrencyRelated').on('change', function() {        
        var a = $j(this).val();
        var data_id = $j(this).attr('data-id');        
        var PCLocalAmount = $j('.PCLocalAmount' + data_id).val();
        var PCEuroAmount = $j('.PCEuroAmount' + data_id).val();
        var PCCurrency = $j('.commonCurrencyRelated').val();        
        for (var i = 0; i < stringArray.length; i++) {            
            if (stringArray[i].Currency_Unit__c == PCCurrency) {                
                if (PCLocalAmount !== 0) {
                    if (PCLocalAmount !== null && PCLocalAmount !== "") {
                        PCLocalAmount = parseCurrency(PCLocalAmount);
                        var finalValue = PCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                        finalValue = finalValue.toFixed(2);
                        $j('.PCEuroAmount' + data_id).val(finalValue);
                    }
                } else {

                    $j('.PCEuroAmount' + data_id).val(0);
                }
            }
        }

    });	
}

function currencyPopup() {
	
	currencyPopupCommonCurrencyRelatedcall();
	
    $j('.commonPCLocalAmount').on('keyup', function() {        
        var a = $j(this).parent().find('.commonCurrencyRelated').val();
        //var data_id = $j(this).closest('.adMangerNo').find('.commonCurrencyRelated').attr('data-id');
		var data_id = $j(this).attr('data-id');
        var PCLocalAmount = $j('.PCLocalAmount' + data_id).val();
        var PCEuroAmount = $j('.PCEuroAmount' + data_id).val();
        //var PCCurrency = $j('.commonCurrencyRelated').val();
		var PCCurrency = $j('.commonCurrencyRelated'+data_id).val();

        for (var i = 0; i < stringArray.length; i++) {            
            if (stringArray[i].Currency_Unit__c == PCCurrency) {
                console.debug('Pc Currency==>' + PCCurrency);
                if (PCLocalAmount !== 0) {
                    if (PCLocalAmount !== null && PCLocalAmount !== "") {
                        PCLocalAmount = parseCurrency(PCLocalAmount);
                        var finalValue = PCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                        finalValue = finalValue.toFixed(2);
                        $j('.PCEuroAmount' + data_id).val(finalValue);
                    }
                } else {

                    $j('.PCEuroAmount' + data_id).val(0);
                }
            }
        }

    });


    $j('.commonCurrencyRelatedPPC').on('change', function() {

        var a = $j(this).val();
        var data_id = $j(this).attr('data-id');

        var PPCLocalAmount = $j('.PPCLocalAmount' + data_id).val();
        var PPCEuroAmount = $j('.PPCEuroAmount' + data_id).val();
        var PPCCurrency = $j('.commonCurrencyRelatedPPC').val();        
        for (var i = 0; i < stringArray.length; i++) {            
            if (stringArray[i].Currency_Unit__c == PPCCurrency) {                
                if (PPCLocalAmount !== 0) {
                    if (PPCLocalAmount !== null && PPCLocalAmount !== "") {
                        PPCLocalAmount = parseCurrency(PPCLocalAmount);
                        var finalValue = PPCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                        finalValue = finalValue.toFixed(2);
                        $j('.PPCEuroAmount' + data_id).val(finalValue);
                    }
                } else {
                    $j('.PPCEuroAmount' + data_id).val(0);
                }
            }
        }

    });

    $j('.commonPPCLocalAmount').on('keyup', function() {

        var a = $j(this).val();        
        //var data_id = $j(this).closest('.adMangerNo').find('.commonCurrencyRelatedPPC').attr('data-id');        
		var data_id = $j(this).attr('data-id');        
        var PPCLocalAmount = $j('.PPCLocalAmount' + data_id).val();
        var PPCEuroAmount = $j('.PPCEuroAmount' + data_id).val();
        //var PPCCurrency = $j('.commonCurrencyRelatedPPC').val();
		var PPCCurrency = $j('.commonCurrencyRelatedPPC'+data_id).val();
        for (var i = 0; i < stringArray.length; i++) {            
            if (stringArray[i].Currency_Unit__c == PPCCurrency) {                
                if (PPCLocalAmount !== 0) {
                    if (PPCLocalAmount !== null && PPCLocalAmount !== "") {
                        PPCLocalAmount = parseCurrency(PPCLocalAmount);
                        var finalValue = PPCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                        finalValue = finalValue.toFixed(2);
                        $j('.PPCEuroAmount' + data_id).val(finalValue);
                    }
                } else {

                    $j('.PPCEuroAmount' + data_id).val(0);
                }
            }
        }

    });


    currencyCAAmount();


}

function currencyCAAmount(){

	$j('.commonCurrencyRelatedCA').on('change', function() {

        var a = $j(this).val();
        var data_id = $j(this).attr('data-id');

        var CALocalAmount = $j('.CALocalAmount' + data_id).val();
        var CAEuroAmount = $j('.CAEuroAmount' + data_id).val();
        var CACurrency = $j('.commonCurrencyRelatedCA').val();        
        for (var i = 0; i < stringArray.length; i++) {            
            if (stringArray[i].Currency_Unit__c == CACurrency) {                
                if (CALocalAmount !== 0) {
                    if (CALocalAmount !== null && CALocalAmount !== "") {
                        CALocalAmount = parseCurrency(CALocalAmount);
                        var finalValue = CALocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                        finalValue = finalValue.toFixed(2);
                        $j('.CAEuroAmount' + data_id).val(finalValue);
                    }
                } else {

                    $j('.CAEuroAmount' + data_id).val(0);
                }
            }
        }

    });


    $j('.commonCALocalAmount').on('keyup', function() {

        var a = $j(this).val();        
       // var data_id = $j(this).closest('.adMangerNo').find('.commonCurrencyRelatedCA').attr('data-id');
	   var data_id = $j(this).attr('data-id');

        var CALocalAmount = $j('.CALocalAmount' + data_id).val();
        var CAEuroAmount = $j('.CAEuroAmount' + data_id).val();
       // var CACurrency = $j('.commonCurrencyRelatedCA').val();        
	   var CACurrency = $j('.commonCurrencyRelatedCA'+data_id).val();
        for (var i = 0; i < stringArray.length; i++) {            
            if (stringArray[i].Currency_Unit__c == CACurrency) {                
                if (CALocalAmount !== 0) {
                    if (CALocalAmount !== null && CALocalAmount !== "") {
                        CALocalAmount = parseCurrency(CALocalAmount);
                        var finalValue = CALocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                        finalValue = finalValue.toFixed(2);
                        $j('.CAEuroAmount' + data_id).val(finalValue);
                    }
                } else {
                    $j('.CAEuroAmount' + data_id).val(0);
                }
            }
        }

    });


}

function removeMasterDurationRows() {                	
	$j('.remove_master_durationrows').click(function(){
		if($j('.row1Main').length > 1 ) {        	
			$j(this).closest('.row1Main').remove();
		}
		
		masterProcess();
	});  		
	masterProcess();      	
}

function removeAdditionalFilmDurationRows() {                	
	$j('.remove_additional_films_durationrows').click(function(){
		if($j('.row1MainAdditional').length > 1 ) {        	
			$j(this).closest('.row1MainAdditional').remove();
		}
		
		additionalFilmProcess();
	});  		
	additionalFilmProcess();      	
}

function additionalFilmProcess() {
	var intNoOfMasters=0;
	var strNoOfMasters='';
	var strDurationOfMasters='';
	
	$j('.no-of-additional-films-class').each(function(){
		strNoOfMasters += ($j(this).val()?$j(this).val():0);
		strNoOfMasters += ',';
		
		if($j('.noOfAdditionalFilmsAddition').length) {
			intNoOfMasters += Number($j(this).val()?$j(this).val():0);
		}
		
	});
	
	strNoOfMasters = strNoOfMasters.replace(/,\s*$/, "");
	
	$j('.duration-of-additional-films-class').each(function(){
		strDurationOfMasters += ($j(this).val()?$j(this).val():0);
		strDurationOfMasters += ',';
	});
	
	strDurationOfMasters = strDurationOfMasters.replace(/,\s*$/, "");

	$j('.noOfAdditionalFilmsMain').val(strNoOfMasters);
	$j('.durationOfAdditionalFilmsMain').val(strDurationOfMasters);
	
	if($j('.noOfAdditionalFilmsAddition').length) {
		$j('.noOfAdditionalFilmsAddition').val(intNoOfMasters);
	} 	
}

        
        function masterProcess() {
        	var intNoOfMasters=0;
        	var strNoOfMasters='';
        	var strDurationOfMasters='';
        	
        	$j('.no-of-masters-class').each(function(){
        		strNoOfMasters += ($j(this).val()?$j(this).val():0);
        		strNoOfMasters += ',';
        		
        		if($j('.noOfMastersAddition').length) {
        			intNoOfMasters += Number($j(this).val()?$j(this).val():0);
        		}
        		
        	});
        	
        	strNoOfMasters = strNoOfMasters.replace(/,\s*$/, "");
        	
        	$j('.duration-of-masters-class').each(function(){
        		strDurationOfMasters += ($j(this).val()?$j(this).val():0);
        		strDurationOfMasters += ',';
        	});
        	
        	strDurationOfMasters = strDurationOfMasters.replace(/,\s*$/, "");
        
        	$j('.noOfMastersMain').val(strNoOfMasters);
        	$j('.durationOfMastersMain').val(strDurationOfMasters);
        	
        	if($j('.noOfMastersAddition').length) {
       			$j('.noOfMastersAddition').val(intNoOfMasters);
       		}        	
        }
        
        
        function loadMasterProcess() {        	
        	var arrstrNoOfMasters = $j('.noOfMastersMain').val().split(",");
        	var lengtharrstrNoOfMasters = arrstrNoOfMasters.length;
        	
        	var arrstrdurationOfMasters = $j('.durationOfMastersMain').val().split(",");
        	var lengtharrstrdurationOfMasters = arrstrdurationOfMasters.length;
        	        	
        	if(lengtharrstrNoOfMasters > 1) {
        		for( var i=0; i<lengtharrstrNoOfMasters-1;i++ ) {
        			var dataToAppend = $j('.row1Main').html();
        			$j('.row1MainParent').append('<div class="row1Main">'+dataToAppend+'</div>');
        		}
        	}
        	
        	if(lengtharrstrNoOfMasters >= 1) {
				if(lengtharrstrNoOfMasters == 1 && (($j('.noOfMastersMain').val().trim() =='' || $j('.noOfMastersMain').val().trim() ==0) && ($j('.durationOfMastersMain').val().trim() =='' || $j('.durationOfMastersMain').val().trim() ==0 ))) {
					$j('.no-of-masters-class').val('');
				} else {
					$j('.no-of-masters-class').each(function(index, value){
						$j(this).val(arrstrNoOfMasters[index]);	        		
					});
				}	        	
				if(lengtharrstrdurationOfMasters == 1 && (($j('.noOfMastersMain').val().trim() =='' || $j('.noOfMastersMain').val().trim() ==0) && ($j('.durationOfMastersMain').val().trim() =='' || $j('.durationOfMastersMain').val().trim() ==0 ))) {
					$j('.duration-of-masters-class').val('');
				} else {
					$j('.duration-of-masters-class').each(function(index, value){
						$j(this).val(arrstrdurationOfMasters[index]);	        		
					});
				}
        	}        		
        }
		
		function loadAdditionalFilmProcess() {
			//if($j('.noOfAdditionalFilmsMain').val() || $j('.durationOfAdditionalFilmsMain').val() ) {
				var arrstrNoOfMasters = $j('.noOfAdditionalFilmsMain').val().split(",");
				var lengtharrstrNoOfMasters = arrstrNoOfMasters.length;
				
				var arrstrdurationOfMasters = $j('.durationOfAdditionalFilmsMain').val().split(",");
				var lengtharrstrdurationOfMasters = arrstrdurationOfMasters.length;
							
				if(lengtharrstrNoOfMasters > 1) {
					for( var i=0; i<lengtharrstrNoOfMasters-1;i++ ) {
						var dataToAppend = $j('.row1MainAdditional').html();
						$j('.row1AdditionalMainParent').append('<div class="row1MainAdditional">'+dataToAppend+'</div>');
					}
				}
				
				if(lengtharrstrNoOfMasters >= 1) {
					if(lengtharrstrNoOfMasters == 1 && (($j('.noOfAdditionalFilmsMain').val().trim() =='' || $j('.noOfAdditionalFilmsMain').val().trim() ==0) && ($j('.durationOfAdditionalFilmsMain').val().trim() =='' || $j('.durationOfAdditionalFilmsMain').val().trim() ==0 ))) {
						$j('.no-of-additional-films-class').val('');
					} else {
						$j('.no-of-additional-films-class').each(function(index, value){
							$j(this).val(arrstrNoOfMasters[index]);	        		
						});
					}	        	
					if(lengtharrstrdurationOfMasters == 1 && (($j('.noOfAdditionalFilmsMain').val().trim() =='' || $j('.noOfAdditionalFilmsMain').val().trim() ==0) && ($j('.durationOfAdditionalFilmsMain').val().trim() =='' || $j('.durationOfMastersMain').val().trim() ==0 ))) {
						$j('.duration-of-additional-films-class').val('');
					} else {
						$j('.duration-of-additional-films-class').each(function(index, value){
							$j(this).val(arrstrdurationOfMasters[index]);	        		
						});
					}
				}        		
			//}
		}
		
        function noOfmasterdurationkeypress() {
        	$j('.no-of-masters-class, .duration-of-masters-class').on('input',function(){        		
        		masterProcess();
        	});
        }
		
		function noOfAdditionalFilmdurationkeypress() {
        	$j('.no-of-additional-films-class, .duration-of-additional-films-class').on('input',function(){        		
        		additionalFilmProcess();
        	});
        }
        
        function addMasterDurationrowsCall() {
        	$j('.add_master_durationrows').click(function(){    
				if($j('.row1Main').length < 50 ) {
					var dataToAppend = $j('.row1Main').html();
					$j('.row1MainParent').append('<div class="row1Main">'+dataToAppend+'</div>');
							
					removeMasterDurationRows();
					noOfmasterdurationkeypress();        		
				} else {
					alert('maximum 50 masters can be added');
				}
        	});
        }
		
		function addAdditionalFilmsDurationrowsCall() {
        	$j('.add_additional_films_durationrows').click(function(){  
				if($j('.row1MainAdditional').length < 50 ) {
					var dataToAppend = $j('.row1MainAdditional').html();
					$j('.row1AdditionalMainParent').append('<div class="row1MainAdditional">'+dataToAppend+'</div>');
                		
					removeAdditionalFilmDurationRows();
					noOfAdditionalFilmdurationkeypress();
				} else {
					alert('maximum 50 additional films can be added');
				}       		
        	});
        }

function multiSelectShootLocation() {
    var multiselectJq_selected = $j('.job-field-input-multiselectJq select').attr('datalist');
    //	alert(multiselectJq_selected_array);
    if (multiselectJq_selected) {
        var multiselectJq_selected_array = multiselectJq_selected.split(",");
        $j.each(multiselectJq_selected_array, function(i) {
            var multiselectJq_selected_arrayvalue = multiselectJq_selected_array[i];
            $j('.job-field-input-multiselectJq select option[value="' + multiselectJq_selected_arrayvalue + '"]').attr('selected', 1);
            //system.debug(multiselectJq_selected_arrayvalue);
            //	alert(multiselectJq_selected_arrayvalue);
        });
    }
}


$j(function() {
	
	addHeaderTitle();	
    $j('td.empty').remove();
    $j('.main_inner_sectionh4').click(function() {
        $obj = $j(this).find('.commonall');
        commonclass($obj);
    });
    $j('.inner_section h4').click(function() {
        $obj = $j(this).find('.commonall');
        commonclass($obj);
    });

    $j('.commonall').click(function() {
        if ($j(this).parent().hasClass('main_inner_sectionh4')) {
            //do nothing
        } else if ($j(this).parent().closest('div').hasClass('inner_section')) {
            //do nothing		      			
        } else {
            $obj = $j(this);
            commonclass($obj);
        }

    });


    $j('.holder-class span.common').click(function() {

        $j('.holder-class').attr('style', 'pointer-events:none;');
        $j(this).closest('.holder-class').find('.categoryStyle').append('<img src="/img/loading.gif"  class="loadingclass" />');

        var num = $j(this).attr('rel');
        $j(this).parent().find('span').removeClass('changeColor');

        var jq;
        for (var i = 1; i <= num; i++) {

            jq = $j(this).parent().children('span[rel=' + i + ']');
            jq.addClass('changeColor');
        }
        $j('.hel').text(num);
        var data_id = $j(this).closest('.holder-class').attr('data-id');

        var fnstring = data_id;
        var fnparams = [num, data_id];
        var fn = window[fnstring];

        if (typeof fn === "function"){
            fn.apply(null, fnparams);
	}

    });



    $j(".holder-class span").hover(function() {
        var num = $j(this).attr('rel');
        $j(this).parent().find('span').removeClass('changeColorHover');
        var jq;
        for (var i = 1; i <= num; i++) {
            jq = $j(this).parent().children('span[rel=' + i + ']');
            jq.addClass('changeColorHover');
        }

    });

    $j('.holder-class div').mouseleave(function() {
        $j(this).find('span').removeClass('changeColorHover');
    });
	
	$j('.nombydom').each(function(){
		var str = '';
		var arr = $j(this).html();
			arr = arr.split(':::');
		var duration = arr[0];
		var number 	 = arr[1];
			duration =  duration.split('_');
			number 	 =  number.split('_');
			if(duration.length>number.length) {
				var maxCount = duration.length; 
			} else {
				var maxCount = number.length;
			}
			for( var i=0;i<maxCount;i++ ) {
				if(trim(duration[i]) || trim(number[i])) {
					str +=  (trim(duration[i])?duration[i]:'0')+'x'+(trim(number[i])?number[i]:'0')+', ';
				}					
			}
		str=str.replace(/,\s*$/, "");
		$j(this).html(str);
		
		if($j(this).hasClass('tdelement')){					
			$j(this).closest('td').attr('title',$j(this).text().trim());
		}
					
	});

});