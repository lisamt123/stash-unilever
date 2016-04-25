$j = jQuery.noConflict();

function EditFun(id) {        
              
                EditSavingActionFun(id);       
                $j('.show-on-edit').show();   
              }         
         function closeloading() {
                $j('.loadingclass').remove();
                $j('.holder-class').attr('style','');
       } 
	   
	   
	   
		
$j(function(){
	
	
	
});

function PCEuroAmountAcceptedCall( stringArray, PCCurrency, PCLocalAmount ) {
           
          		if(PCCurrency == null || PCCurrency.length == 0){
		              $j('.PCEuroAmountAccepted').val('');
		          }
		
		          for(var i=0;i<stringArray.length;i++){
		                   
		                    if(stringArray[i].Currency_Unit__c == PCCurrency ){
		                         console.debug('inside'+PCLocalAmount);
		                          if(PCLocalAmount !=='0' && PCLocalAmount !==null && PCLocalAmount !==""){
		                             if(PCLocalAmount !==null && PCLocalAmount !==""){
		                                  PCLocalAmount = parseCurrency(PCLocalAmount);
		                                  var finalValue = PCLocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
		                                  finalValue =finalValue.toFixed(2);
		                                 $j('.PCEuroAmountAccepted').val(finalValue);
		                             }         
		                          }else{
		                          
		                               $j('.PCEuroAmountAccepted').val(0);
		                          }
		                    }
		                    
		            } 
		            
		            var PPCEuroAmount = $j('.PPCEuroAmountAccepted').val();           
		            var CAEuroAmount = $j('.CAEuroAmountAccepted').val();           
		            var PCEuroAmount = $j('.PCEuroAmountAccepted').val();
		           
		            if(PCEuroAmount !== "" && PPCEuroAmount !=="" && CAEuroAmount!== ""){
		                  PPCEuroAmount = parseFloat(PPCEuroAmount);
		                  CAEuroAmount = parseFloat(CAEuroAmount);
		                  PCEuroAmount =  parseFloat(PCEuroAmount);
		                  var total = PCEuroAmount+PPCEuroAmount+CAEuroAmount;
		                 
		                  total = total.toFixed(2);
		                 
		                 $j('.TotalAcceptedFinalCostAccepted').val(total);
		            }
           }
		   
		   
function PPCEuroAmountAcceptedCall(stringArray, PPCCurrency, PPCLocalAmount) {
      	if(PPCCurrency == null || PPCCurrency.length == 0){
              $j('.PPCEuroAmountAccepted').val('');
          }
          
          for(var i=0;i<stringArray.length;i++){
                   
                    if(stringArray[i].Currency_Unit__c == PPCCurrency){
                         console.debug('inside');
                          if(PPCLocalAmount!=='0' && PPCLocalAmount!==null && PPCLocalAmount!==""){
                             if(PPCLocalAmount!==null && PPCLocalAmount!==""){
                                  PPCLocalAmount = parseCurrency(PPCLocalAmount);
                                  var finalValue = PPCLocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                    finalValue = finalValue.toFixed(2);
                                 $j('.PPCEuroAmountAccepted').val(finalValue);
                             }         
                          }else{
                          
                               $j('.PPCEuroAmountAccepted').val(0);
                          }
                    }
                    
            }
            
            var PPCEuroAmount = $j('.PPCEuroAmountAccepted').val();           
            var CAEuroAmount = $j('.CAEuroAmountAccepted').val();           
            var PCEuroAmount = $j('.PCEuroAmountAccepted').val();
           
            if(PCEuroAmount !== "" && PPCEuroAmount !=="" && CAEuroAmount!== ""){
                 PPCEuroAmount = parseFloat(PPCEuroAmount);
                 CAEuroAmount = parseFloat(CAEuroAmount);
                 PCEuroAmount =  parseFloat(PCEuroAmount);
                 
                 var total = PCEuroAmount+PPCEuroAmount+CAEuroAmount;
                 
                  total = total.toFixed(2);
                  
                 $j('.TotalAcceptedFinalCostAccepted').val(total);
            }
      }		   
	  
	  function CAEuroAmountAcceptedCall(stringArray, CACurrency, CALocalAmount) {
      	if(CACurrency == null || CACurrency.length == 0){
              $j('.CAEuroAmountAccepted').val('');
          }
          
          for(var i=0;i<stringArray.length;i++){
                   
                    if(stringArray[i].Currency_Unit__c == CACurrency){
                        // console.debug('inside');
                          if(CALocalAmount !=='0' && CALocalAmount !==null && CALocalAmount !==""){
                             if(CALocalAmount !==null && CALocalAmount !==""){
                                  CALocalAmount = parseCurrency(CALocalAmount);
                                  var finalValue =  CALocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                 $j('.CAEuroAmountAccepted').val(finalValue);
                             }         
                          }else{
                          
                               $j('.CAEuroAmountAccepted').val(0);
                          }
                    }
                    
            }
            
            var PPCEuroAmount = $j('.PPCEuroAmountAccepted').val();           
            var CAEuroAmount = $j('.CAEuroAmountAccepted').val();           
            var PCEuroAmount = $j('.PCEuroAmountAccepted').val();
           
            if(PCEuroAmount !== "" && PPCEuroAmount !=="" && CAEuroAmount!== ""){
                   PPCEuroAmount = parseFloat(PPCEuroAmount);
                   CAEuroAmount = parseFloat(CAEuroAmount);
                   PCEuroAmount =  parseFloat(PCEuroAmount);
                  var total = PCEuroAmount+PPCEuroAmount+CAEuroAmount;
                 
                  total = total.toFixed(2);
                  
                 $j('.TotalAcceptedFinalCostAccepted').val(total);
            }
      }
	  
	  
	  function commonCurrencyRelatedNewCall(stringArray, PCLocalAmountNew, PCEuroAmountNew, PCCurrencyNew) {
       	if(PCCurrencyNew == null || PCCurrencyNew.length == 0){
                      		$j('.PCEuroAmountNew').val('');
                       }

                       for(var i=0;i<stringArray.length;i++){                       
                            if(stringArray[i].Currency_Unit__c == PCCurrencyNew ){
                               console.debug('Pc Currency==>'+PCCurrencyNew);
                                 if(PCLocalAmountNew !=='0' && PCLocalAmountNew !==null && PCLocalAmountNew !=="" ){
                                
                                     if(PCLocalAmountNew !==null && PCLocalAmountNew !==""){
                                          PCLocalAmountNew = parseCurrency(PCLocalAmountNew);
                                   var finalValue =  PCLocalAmountNew/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.PCEuroAmountNew').val(finalValue);
                                     }  
                                            
                                 }else{
                              
                                   $j('.PCEuroAmountNew').val(0);    }
                            }
                       }
       }
	   
	   commonCurrencyRelatedPPCNewFunCall(stringArray, PPCLocalAmountNew, PPCEuroAmountNew, PPCCurrencyNew ) {
         		if(PPCCurrencyNew == null || PPCCurrencyNew.length == 0){
                          $j('.PPCEuroAmountNew').val('');
                      }

                       for(var i=0;i<stringArray.length;i++){
                           
                            if(stringArray[i].Currency_Unit__c == PPCCurrencyNew ){
                               
                                 if(PPCLocalAmountNew !=='0' && PPCLocalAmountNew !==null && PPCLocalAmountNew !==""){
                                
                                     if(PPCLocalAmountNew !==null && PPCLocalAmountNew !==""){
                                          PPCLocalAmountNew = parseCurrency(PPCLocalAmountNew);
                                   var finalValue =  PPCLocalAmountNew/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.PPCEuroAmountNew').val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.PPCEuroAmountNew').val(0);
                                 }
                            }
                       }
         }
		 
		 function commonCurrencyRelatedCANewFunCall(stringArray, CALocalAmountNew, CAEuroAmountNew, CACurrencyNew) {
                       		if(CACurrencyNew == null || CACurrencyNew.length == 0){
	                          $j('.CAEuroAmountNew').val('');
	                       }
	                       
	                       for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == CACurrencyNew ){
                               console.debug('pPc Currency==>'+CACurrencyNew );
                                 if(CALocalAmountNew !=='0' && CALocalAmountNew !==null && CALocalAmountNew !=="" ){                           
                                     if(CALocalAmountNew !==null && CALocalAmountNew !==""){
                                          CALocalAmountNew = parseCurrency(CALocalAmountNew);
                                   var finalValue =  CALocalAmountNew/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.CAEuroAmountNew').val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.CAEuroAmountNew').val(0);
                                 }
                            }
                       }
	                       
                       }
					   
					   function showOnEdit() {
                        $j('.show-on-edit').show();
                    }
					
					
					function commonCALocalAmountCall(stringArray, CALocalAmount, CAEuroAmount, CACurrency, data_id) {
                    	if(CACurrency == null || CACurrency.length == 0){
                          $j('.CAEuroAmount'+data_id).val('');
                          }
                          
                          for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == CACurrency ){
                               console.debug('pPc Currency==>'+CACurrency);
                                 if(CALocalAmount !=='0' && CALocalAmount !==null && CALocalAmount !==""){
                                     if(CALocalAmount !==null && CALocalAmount !==""){
                                          CALocalAmount = parseCurrency(CALocalAmount);
                                  var finalValue =  CALocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.CAEuroAmount'+data_id).val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.CAEuroAmount'+data_id).val(0);
                                 }
                            }
                       }
                    }
					
					
					function commonCurrencyRelatedCACall(stringArray,CALocalAmount,CAEuroAmount,CACurrency, data_id) {
                     	if(CACurrency == null || CACurrency.length == 0){
                          $j('.CAEuroAmount'+data_id).val('');
                      	}
                      	
                      	for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == CACurrency ){
                               console.debug('pPc Currency==>'+CACurrency);
                                 if(CALocalAmount !=='0' && CALocalAmount !==null && CALocalAmount !==""){
                                     if(CALocalAmount !==null && CALocalAmount !==""){
                                          CALocalAmount = parseCurrency(CALocalAmount);
                                   var finalValue =  CALocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.CAEuroAmount'+data_id).val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.CAEuroAmount'+data_id).val(0);
                                 }
                            }
                       }
                     }
					 
					 function commonPPCLocalAmountCall(stringArray, PPCLocalAmount, PPCEuroAmount, PPCCurrency, data_id) {
                    	if(PPCCurrency == null || PPCCurrency.length == 0){
                      		$j('.PPCEuroAmount'+data_id).val('');
                       }
                       
                       for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == PPCCurrency ){
                               console.debug('pPc Currency==>'+PPCCurrency);
                                 if(PPCLocalAmount !=='0' && PPCLocalAmount !==null && PPCLocalAmount !==""){
                                     if(PPCLocalAmount !==null && PPCLocalAmount !==""){
                                          PPCLocalAmount = parseCurrency(PPCLocalAmount);
                                  var finalValue =  PPCLocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.PPCEuroAmount'+data_id).val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.PPCEuroAmount'+data_id).val(0);
                                 }
                            }
                       }
                       
                    }
					
					function commonCurrencyRelatedPPCCall(stringArray, PPCLocalAmount, PPCEuroAmount, PPCCurrency, data_id) {
                    	if(PPCCurrency == null || PPCCurrency.length == 0){
                          $j('.PPCEuroAmount'+data_id).val('');
                      }
                      
                      for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == PPCCurrency ){
                               console.debug('pPc Currency==>'+PPCCurrency);
                                 if(PPCLocalAmount !=='0' && PPCLocalAmount !==null && PPCLocalAmount !==""){
                                     if(PPCLocalAmount !==null && PPCLocalAmount !==""){
                                          PPCLocalAmount = parseCurrency(PPCLocalAmount);
                                 var finalValue =  PPCLocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.PPCEuroAmount'+data_id).val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.PPCEuroAmount'+data_id).val(0);
                                 }
                            }
                       }
                      
                    }
					
					function commonPCLocalAmountCall(stringArray, PCLocalAmount, PCEuroAmount, PCCurrency, data_id) {
                    	if(PCCurrency == null || PCCurrency.length == 0){
                          $j('.PCEuroAmount'+data_id).val('');
                          }
                        
                        for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == PCCurrency ){
                               console.debug('Pc Currency==>'+PCCurrency);
                                 if(PCLocalAmount !=='0' && PCLocalAmount !==null && PCLocalAmount !==""){
                                     if(PCLocalAmount !==null && PCLocalAmount !==""){
                                          PCLocalAmount = parseCurrency(PCLocalAmount);
                                 var finalValue =  PCLocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.PCEuroAmount'+data_id).val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.PCEuroAmount'+data_id).val(0);
                                 }
                            }
                       }
                    }
					
					function commonCurrencyRelatedCall(stringArray, PCLocalAmount, PCEuroAmount, PCCurrency, data_id) {
                	
                	if(PCCurrency == null || PCCurrency.length == 0){
                      	$j('.PCEuroAmount'+data_id).val('');
                      }

                       for(var i=0;i<stringArray.length;i++){
                            console.debug('from backEnd'+stringArray[i]);
                            if(stringArray[i].Currency_Unit__c == PCCurrency ){
                               console.debug('Pc Currency==>'+PCCurrency);
                                 if(PCLocalAmount !=='0' && PCLocalAmount !==null && PCLocalAmount !==""){
                                     if(PCLocalAmount !==null && PCLocalAmount !==""){
                                          PCLocalAmount = parseCurrency(PCLocalAmount);
                                   var finalValue =  PCLocalAmount/stringArray[i].Currency_Unit_To_Euro__c;
                                  finalValue = finalValue.toFixed(2);
                                         $j('.PCEuroAmount'+data_id).val(finalValue);
                                     }         
                                 }else{
                              
                                   $j('.PCEuroAmount'+data_id).val(0);
                                 }
                            }
                       }
                
                }