$j = jQuery.noConflict();

function editFun(id) {
    editSavingActionFun(id);
    $j('.show-on-edit').show();
}

function closeloading() {
    $j('.loadingclass').remove();
    $j('.holder-class').attr('style', '');
}

function pCEuroAmountAcceptedCall(stringArray) {

    var PCCurrency = $j('.PCCurrencyAccepted').val();
    var PCLocalAmount = $j('.PCLocalAmountAccepted').val();

    if (PCCurrency == null || PCCurrency.length == 0) {
        $j('.PCEuroAmountAccepted').val('');
    }

    for (var i = 0; i < stringArray.length; i++) {

        if (stringArray[i].Currency_Unit__c == PCCurrency) {
            console.debug('inside' + PCLocalAmount);
            if (PCLocalAmount !== '0' && PCLocalAmount !== null && PCLocalAmount !== "") {
                if (PCLocalAmount !== null && PCLocalAmount !== "") {
                    PCLocalAmount = parseCurrency(PCLocalAmount);
                    var finalValue = PCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                    finalValue = finalValue.toFixed(2);
                    $j('.PCEuroAmountAccepted').val(finalValue);
                }
            } else {

                $j('.PCEuroAmountAccepted').val(0);
            }
        }

    }

    var PPCEuroAmount = $j('.PPCEuroAmountAccepted').val();
    var CAEuroAmount = $j('.CAEuroAmountAccepted').val();
    var PCEuroAmount = $j('.PCEuroAmountAccepted').val();

    if (PCEuroAmount !== "" && PPCEuroAmount !== "" && CAEuroAmount !== "") {
        PPCEuroAmount = parseFloat(PPCEuroAmount);
        CAEuroAmount = parseFloat(CAEuroAmount);
        PCEuroAmount = parseFloat(PCEuroAmount);
        var total = PCEuroAmount + PPCEuroAmount + CAEuroAmount;

        total = total.toFixed(2);

        $j('.TotalAcceptedFinalCostAccepted').val(total);
    }
}


function pPCEuroAmountAcceptedCall(stringArray) {

    var PPCCurrency = $j('.PPCCurrencyAccepted').val();
    var PPCLocalAmount = $j('.PPCLocalAmountAccepted').val();


    if (PPCCurrency == null || PPCCurrency.length == 0) {
        $j('.PPCEuroAmountAccepted').val('');
    }

    for (var i = 0; i < stringArray.length; i++) {

        if (stringArray[i].Currency_Unit__c == PPCCurrency) {
            console.debug('inside');
            if (PPCLocalAmount !== '0' && PPCLocalAmount !== null && PPCLocalAmount !== "") {
                if (PPCLocalAmount !== null && PPCLocalAmount !== "") {
                    PPCLocalAmount = parseCurrency(PPCLocalAmount);
                    var finalValue = PPCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                    finalValue = finalValue.toFixed(2);
                    $j('.PPCEuroAmountAccepted').val(finalValue);
                }
            } else {

                $j('.PPCEuroAmountAccepted').val(0);
            }
        }

    }

    var PPCEuroAmount = $j('.PPCEuroAmountAccepted').val();
    var CAEuroAmount = $j('.CAEuroAmountAccepted').val();
    var PCEuroAmount = $j('.PCEuroAmountAccepted').val();

    if (PCEuroAmount !== "" && PPCEuroAmount !== "" && CAEuroAmount !== "") {
        PPCEuroAmount = parseFloat(PPCEuroAmount);
        CAEuroAmount = parseFloat(CAEuroAmount);
        PCEuroAmount = parseFloat(PCEuroAmount);

        var total = PCEuroAmount + PPCEuroAmount + CAEuroAmount;

        total = total.toFixed(2);

        $j('.TotalAcceptedFinalCostAccepted').val(total);
    }
}

function cAEuroAmountAcceptedCall(stringArray) {

    var CACurrency = $j('.CACurrencyAccepted').val();
    var CALocalAmount = $j('.CALocalAmountAccepted').val();

    if (CACurrency == null || CACurrency.length == 0) {
        $j('.CAEuroAmountAccepted').val('');
    }

    for (var i = 0; i < stringArray.length; i++) {

        if (stringArray[i].Currency_Unit__c == CACurrency) {
            // console.debug('inside');
            if (CALocalAmount !== '0' && CALocalAmount !== null && CALocalAmount !== "") {
                if (CALocalAmount !== null && CALocalAmount !== "") {
                    CALocalAmount = parseCurrency(CALocalAmount);
                    var finalValue = CALocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                    finalValue = finalValue.toFixed(2);
                    $j('.CAEuroAmountAccepted').val(finalValue);
                }
            } else {

                $j('.CAEuroAmountAccepted').val(0);
            }
        }

    }

    var PPCEuroAmount = $j('.PPCEuroAmountAccepted').val();
    var CAEuroAmount = $j('.CAEuroAmountAccepted').val();
    var PCEuroAmount = $j('.PCEuroAmountAccepted').val();

    if (PCEuroAmount !== "" && PPCEuroAmount !== "" && CAEuroAmount !== "") {
        PPCEuroAmount = parseFloat(PPCEuroAmount);
        CAEuroAmount = parseFloat(CAEuroAmount);
        PCEuroAmount = parseFloat(PCEuroAmount);
        var total = PCEuroAmount + PPCEuroAmount + CAEuroAmount;

        total = total.toFixed(2);

        $j('.TotalAcceptedFinalCostAccepted').val(total);
    }
}


function commonCurrencyRelatedNewCall(stringArray) {

    var PCLocalAmountNew = $j('.PCLocalAmountNew').val();
    var PCEuroAmountNew = $j('.PCEuroAmountNew').val();
    var PCCurrencyNew = $j('.commonCurrencyRelatedNew').val();

    if (PCCurrencyNew == null || PCCurrencyNew.length == 0) {
        $j('.PCEuroAmountNew').val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        if (stringArray[i].Currency_Unit__c == PCCurrencyNew) {
            console.debug('Pc Currency==>' + PCCurrencyNew);
            if (PCLocalAmountNew !== '0' && PCLocalAmountNew !== null && PCLocalAmountNew !== "") {

                if (PCLocalAmountNew !== null && PCLocalAmountNew !== "") {
                    PCLocalAmountNew = parseCurrency(PCLocalAmountNew);
                    var finalValue = PCLocalAmountNew / stringArray[i].Currency_Unit_To_Euro__c;
                    finalValue = finalValue.toFixed(2);
                    $j('.PCEuroAmountNew').val(finalValue);
                }

            } else {

                $j('.PCEuroAmountNew').val(0);
            }
        }
    }
}

function commonCurrencyRelatedPPCNewFunCall(stringArray) {

    var PPCLocalAmountNew = $j('.PPCLocalAmountNew').val();
    var PPCEuroAmountNew = $j('.PPCEuroAmountNew').val();
    var PPCCurrencyNew = $j('.commonCurrencyRelatedPPCNew').val();

    if (PPCCurrencyNew == null || PPCCurrencyNew.length == 0) {
        $j('.PPCEuroAmountNew').val('');
    }

    for (var i = 0; i < stringArray.length; i++) {

        if (stringArray[i].Currency_Unit__c == PPCCurrencyNew) {

            if (PPCLocalAmountNew !== '0' && PPCLocalAmountNew !== null && PPCLocalAmountNew !== "") {

                if (PPCLocalAmountNew !== null && PPCLocalAmountNew !== "") {
                    PPCLocalAmountNew = parseCurrency(PPCLocalAmountNew);
                    var finalValue = PPCLocalAmountNew / stringArray[i].Currency_Unit_To_Euro__c;
                    finalValue = finalValue.toFixed(2);
                    $j('.PPCEuroAmountNew').val(finalValue);
                }
            } else {

                $j('.PPCEuroAmountNew').val(0);
            }
        }
    }
}

function commonCurrencyRelatedCANewFunCall(stringArray) {

    var CALocalAmountNew = $j('.CALocalAmountNew').val();
    var CAEuroAmountNew = $j('.CAEuroAmountNew').val();
    var CACurrencyNew = $j('.commonCurrencyRelatedCANew').val();

    if (CACurrencyNew == null || CACurrencyNew.length == 0) {
        $j('.CAEuroAmountNew').val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == CACurrencyNew) {
            console.debug('pPc Currency==>' + CACurrencyNew);
            if (CALocalAmountNew !== '0' && CALocalAmountNew !== null && CALocalAmountNew !== "") {
                if (CALocalAmountNew !== null && CALocalAmountNew !== "") {
                    CALocalAmountNew = parseCurrency(CALocalAmountNew);
                    var finalValue = CALocalAmountNew / stringArray[i].Currency_Unit_To_Euro__c;
                    finalValue = finalValue.toFixed(2);
                    $j('.CAEuroAmountNew').val(finalValue);
                }
            } else {

                $j('.CAEuroAmountNew').val(0);
            }
        }
    }

}

function showOnEdit() {
    $j('.show-on-edit').show();
}


function commonCALocalAmountCall(stringArray, CALocalAmount, CAEuroAmount, CACurrency, data_id) {
    if (CACurrency == null || CACurrency.length == 0) {
        $j('.CAEuroAmount' + data_id).val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == CACurrency) {
            //console.debug('pPc Currency==>' + CACurrency);
            if (CALocalAmount !== '0' && CALocalAmount !== null && CALocalAmount !== "") {
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
}


function commonCurrencyRelatedCACall(stringArray, CALocalAmount, CAEuroAmount, CACurrency, data_id) {
    if (CACurrency == null || CACurrency.length == 0) {
        $j('.CAEuroAmount' + data_id).val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == CACurrency) {
            console.debug('pPc Currency==>' + CACurrency);
            if (CALocalAmount !== '0' && CALocalAmount !== null && CALocalAmount !== "") {
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
}

function commonPPCLocalAmountCall(stringArray, PPCLocalAmount, PPCEuroAmount, PPCCurrency, data_id) {
    if (PPCCurrency == null || PPCCurrency.length == 0) {
        $j('.PPCEuroAmount' + data_id).val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == PPCCurrency) {
            console.debug('pPc Currency==>' + PPCCurrency);
            if (PPCLocalAmount !== '0' && PPCLocalAmount !== null && PPCLocalAmount !== "") {
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

}

function commonCurrencyRelatedPPCCall(stringArray, PPCLocalAmount, PPCEuroAmount, PPCCurrency, data_id) {
    if (PPCCurrency == null || PPCCurrency.length == 0) {
        $j('.PPCEuroAmount' + data_id).val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == PPCCurrency) {
            console.debug('pPc Currency==>' + PPCCurrency);
            if (PPCLocalAmount !== '0' && PPCLocalAmount !== null && PPCLocalAmount !== "") {
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

}

function commonPCLocalAmountCall(stringArray, PCLocalAmount, PCEuroAmount, PCCurrency, data_id) {
    if (PCCurrency == null || PCCurrency.length == 0) {
        $j('.PCEuroAmount' + data_id).val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == PCCurrency) {
            console.debug('Pc Currency==>' + PCCurrency);
            if (PCLocalAmount !== '0' && PCLocalAmount !== null && PCLocalAmount !== "") {
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
}

function commonCurrencyRelatedCall(stringArray, PCLocalAmount, PCEuroAmount, PCCurrency, data_id) {

    if (PCCurrency == null || PCCurrency.length == 0) {
        $j('.PCEuroAmount' + data_id).val('');
    }

    for (var i = 0; i < stringArray.length; i++) {
        console.debug('from backEnd' + stringArray[i]);
        if (stringArray[i].Currency_Unit__c == PCCurrency) {
            console.debug('Pc Currency==>' + PCCurrency);
            if (PCLocalAmount !== '0' && PCLocalAmount !== null && PCLocalAmount !== "") {
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

}

function starRatingProcess(data) {

    var divclass;
    for (var i = 0; i < data.length; i++) {
        var savingId = data[i].Id;
        divclass = data[i].Pc_Time_Manage_Star__c;
        for (var j = 1; j <= data[i].PC_Appraisal_Time_Management__c; j++) {

            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Pc_Cost_Manage_Star__c;
        for (var j = 1; j <= data[i].PC_Appraisal_Cost_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Pc_Proces_Manage_Star__c;
        for (var j = 1; j <= data[i].PC_Appraisal_Process_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Pc_Output_Quality_Star__c;
        for (var j = 1; j <= data[i].PC_Appraisal_Output_Quality__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ppc_Time_Manage_Star__c;
        for (var j = 1; j <= data[i].PPC_Appraisal_Time_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ppc_Cost_Manage_Star__c;
        for (var j = 1; j <= data[i].PPC_Appraisal_Cost_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ppc_Process_Manage_Star__c;
        for (var j = 1; j <= data[i].PPC_Appraisal_Process_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ppc_Output_Quality_Star__c;
        for (var j = 1; j <= data[i].PPC_Appraisal_Output_Quality__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ca_Time_Manage_Star__c;
        for (var j = 1; j <= data[i].CA_Appraisal_Time_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ca_Cost_Manage_Star__c;
        for (var j = 1; j <= data[i].CA_Appraisal_Cost_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ca_Process_Manage_Star__c;
        for (var j = 1; j <= data[i].CA_Appraisal_Process_Management__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }
        divclass = data[i].Ca_Output_Quality_Star__c;
        for (var j = 1; j <= data[i].CA_Appraisal_Output_Quality__c; j++) {
            $j('.' + divclass + savingId + ' span[rel=' + j + ']').addClass('changeColor');

        }

    }
}

function holderClassOpn() {
    $j('.holder-class span.common').click(function() {

        $j('.entire-submit').show();

        //$j('.loadingclass').show();
        $j('.holder-class').attr('style', 'pointer-events:none;');
        // $j(this).closest('.holder-class').find('.categoryStyle').append('<div class="loadingclass"> <img src="/img/loading.gif" alt="loading-image" /></div>');

        var num = $j(this).attr('rel');

        //  $(this).removeClass('changeColor');
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
        //  var fnparams1 = [];


        var fn = window[fnstring];

        if (typeof fn === "function") {
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
}
$j(function() {

    multiSelectShootLocation();
    holderClassOpn();

    $j('.quote_check').each(function() {
        if ($j(this).is(':checked')) {
            $j(this).addClass('default_quote');
        }
    });

    $j('.add_quote_button').click(function() {
        $j('.entire-submit').show();
    });

    $j('.available-quotes-file').hide();
    $j('.available-quotes-saving').hide();

    var accepted_quote_css = $j('.accepted-quote-css').html().trim();

    if (accepted_quote_css.length == 0) {
        $j('.accepted-quote-css').addClass('hide');
    }

    //save button hide quote
    $j('.savingClass').hide();

    if ($j('.noOfMastersMain').length) {
        loadMasterProcess();
        noOfmasterdurationkeypress();
        removeMasterDurationRows();
        addMasterDurationrowsCall();
        $j('.show-on-edit').show();
		
		loadAdditionalFilmProcess(); //
		noOfAdditionalFilmdurationkeypress(); //
		removeAdditionalFilmDurationRows(); //
		addAdditionalFilmsDurationrowsCall(); //
    }
	
	$j('a.cloneSaving').click(function(ev){
		ev.preventDefault();
		var savingId = $j(this).attr('savingId');
		var jobId    = $j(this).attr('jobId');
		window.location.href = 'apex/Amr_JobSheet?savingid='+savingId+'&id='+jobId+'&defaultPage=new_saving';
	});
});