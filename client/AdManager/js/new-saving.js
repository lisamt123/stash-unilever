$j = jQuery.noConflict();

function CAEuroAmountCall(stringArray, CACurrency, CALocalAmount) {
        	
            if (CACurrency == null || CACurrency.length == 0) {
                $j('.CAEuroAmount').val('');
            }
            
            for (var i = 0; i < stringArray.length; i++) {

                if (stringArray[i].Currency_Unit__c == CACurrency) {
                    //console.debug('inside');
                    if (CALocalAmount == "0.000") {
                        CALocalAmount = "0";
                    }
                    if (CALocalAmount !== "0") {
                        if (CALocalAmount !== null && CALocalAmount !== "") {
                            CALocalAmount = parseCurrency(CALocalAmount);
                            var finalValue = CALocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                            //alert('before'+finalValue);
                            finalValue = finalValue.toFixed(2);
                            // alert('after'+finalValue);
                            $j('.CAEuroAmount').val(finalValue);

                        }
                    } else {

                        $j('.CAEuroAmount').val(0);
                    }
                }

            }
        }
		
function PPCEuroAmountCall(stringArray, PPCCurrency, PPCLocalAmount) {
        	if (PPCCurrency == null || PPCCurrency.length == 0) {
                $j('.PPCEuroAmount').val('');
            }
            
            for (var i = 0; i < stringArray.length; i++) {

                if (stringArray[i].Currency_Unit__c == PPCCurrency) {
                    //console.debug('inside');
                    if (PPCLocalAmount == "0.000") {
                        PPCLocalAmount = "0";
                    }
                    if (PPCLocalAmount !== "0") {
                        if (PPCLocalAmount !== null && PPCLocalAmount !== "") {
                            PPCLocalAmount = parseCurrency(PPCLocalAmount);
                            var finalValue = PPCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                            finalValue = finalValue.toFixed(2);
                            $j('.PPCEuroAmount').val(finalValue);
                        }
                    } else {

                        $j('.PPCEuroAmount').val(0);
                    }
                }

            }
        }		
		
		function PCEuroAmountCall(stringArray, PCCurrency, PCLocalAmount) {
        	if (PCCurrency == null || PCCurrency.length == 0) {
                $j('.PCEuroAmount').val('');
            }
            
            for (var i = 0; i < stringArray.length; i++) {

                if (stringArray[i].Currency_Unit__c == PCCurrency) {
                    //console.debug('inside'+PCLocalAmount);
                    if (PCLocalAmount == 0.000) {
                        PCLocalAmount = 0;
                    }
                    if (PCLocalAmount !== 0) {
                        if (PCLocalAmount !== null && PCLocalAmount !== "") {
                            PCLocalAmount = parseCurrency(PCLocalAmount);
                            var finalValue = PCLocalAmount / stringArray[i].Currency_Unit_To_Euro__c;
                            finalValue = finalValue.toFixed(2);
                            $j('.PCEuroAmount').val(finalValue);
                        }
                    } else {

                        $j('.PCEuroAmount').val(0);
                    }
                }

            }
        }
		
		
		function CAEuroAmountAcceptedCall(stringArray, CACurrency, CALocalAmount) {
			if (CACurrency == null || CACurrency.length == 0) {
                $j('.CAEuroAmountAccepted').val('');
            }
            
            for (var i = 0; i < stringArray.length; i++) {

                if (stringArray[i].Currency_Unit__c == CACurrency) {                    
                    if (CALocalAmount == "0.000") {
                        CALocalAmount = "0";
                    }
                    if (CALocalAmount !== "0") {
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
		
		function PPCEuroAmountAcceptedCall(stringArray, PPCCurrency, PPCLocalAmount) {
			if (PPCCurrency == null || PPCCurrency.length == 0) {
                $j('.PPCEuroAmountAccepted').val('');
            }
            
            for (var i = 0; i < stringArray.length; i++) {

                if (stringArray[i].Currency_Unit__c == PPCCurrency) {
                    //console.debug('inside');
                    if (PPCLocalAmount == "0.000") {
                        PPCLocalAmount = "0";
                    }
                    if (PPCLocalAmount !== "0") {
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
		
		function PCEuroAmountAcceptedCall(stringArray, PCCurrency, PCLocalAmount) {
			if (PCCurrency == null || PCCurrency.length == 0) {
                $j('.PCEuroAmountAccepted').val('');
            }
            
            for (var i = 0; i < stringArray.length; i++) {

                if (stringArray[i].Currency_Unit__c == PCCurrency) {
                    //console.debug('inside'+PCLocalAmount);
                    if (PCLocalAmount == 0.000) {
                        PCLocalAmount = 0;
                    }
                    if (PCLocalAmount !== 0) {
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
		
		function closeloading() {
            $j('.loadingclass').remove();
            $j('.holder-class').attr('style', '');
        }
		
		function alertDocumentSubmission() {
        	alert('Please attach documents and submit the data.');
        }
		
		$j(function(){			
			currencyPopup();			
		});