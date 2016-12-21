Public Class BFM_TotalValueValidation{
    
    Private static Decimal  grossValue=0;
    @invocableMethod()
    Public static void CteTotalValueValidation(list<BFM_CT_e__c> CTeRecord){
        set<Id> recId=New set<Id>();
        Decimal SESTaxvalue;
        Decimal tolerancValue=0;
        Decimal toleranceMargin=0;
        Decimal taxValue=0;
        Decimal absoluteConsiderationValue;
        list<BFM_CT_e__c> listCTeTaxUpdate = new  list<BFM_CT_e__c>();
        If(BFM_CheckRecursive.firstRun){
            BFM_CheckRecursive.firstRun=false;
            for(BFM_CT_e__c cte: CTeRecord) {
                recId.add(cte.id);
            }
            
            system.debug('recID--->'+recId);    
            list<BFM_CT_e__c> CTeRecordList = [SELECT Id,DEFINITIVE__c,Tax_Status__c,Cte_Status__c,ICMS_Value__c, ICMS_Tax_Rate__c,
                                               (select Net_Value__c,Gross_Value_net_tax__c,ICMS_Calculation_Base__c from SESs__r) 
                                               FROM BFM_CT_e__c where id IN:recId];
            system.debug('CTeRecordList---->'+CTeRecordList);
            
            for(BFM_CT_e__c cte: CTeRecordList){
                if(cte.DEFINITIVE__c && cte.SESs__r.size()>0){
                    system.debug('perform Validation---->');
                    system.debug('Number of attached SES---->'+cte.SESs__r.size());
                    for(integer i=0;i<cte.SESs__r.size();i++){ 
                        system.debug('gross value net tax---->'+cte.SESs__r[i].Gross_Value_net_tax__c);
                        if(cte.SESs__r[i].Gross_Value_net_tax__c!=null && cte.SESs__r[i].Net_Value__c!=null){                                        
                            grossValue = grossValue + (cte.SESs__r[i].Gross_Value_net_tax__c);
                            system.debug('gross value---->'+grossValue);
                            system.debug('net value---->'+cte.SESs__r[i].Net_Value__c);
                            //tax value calculated as : Tax= GrossValue -NetValue
                            taxValue = taxValue + (cte.SESs__r[i].Gross_Value_net_tax__c - cte.SESs__r[i].Net_Value__c);
                            system.debug('tax value---->'+taxValue);
                        }                           
                    }   
                    system.debug('BFM_ToleranceMargin__c.getValues(\'Value\').Tolerance_Percentage_Value__c:'+BFM_ToleranceMargin__c.getValues('Value').Tolerance_Percentage_Value__c);
                    toleranceMargin = grossValue*((BFM_ToleranceMargin__c.getValues('Value').Tolerance_Percentage_Value__c)/100);
                    tolerancValue = grossValue+toleranceMargin;
                    SESTaxvalue=taxValue;
                    absoluteConsiderationValue=BFM_AbsoluteConsideration__c.getValues('Value').AbsoluteConsideration_Value__c;
                    system.debug('grossValue---->'+grossValue);
                    system.debug('toleranceMargin----->'+toleranceMargin);                                   
                    
                    if(cte.ICMS_Value__c > grossValue && cte.ICMS_Value__c<=tolerancValue){
                        system.debug('Passes Tolerance check----->');
                        system.debug('cte.ICMS_Value__c--->'+cte.ICMS_Value__c);
                        system.debug('grossValue----->'+grossValue);
                        system.debug('absoluteConsiderationValue----->'+absoluteConsiderationValue);
                        if(cte.ICMS_Value__c!=Null && math.abs(cte.ICMS_Value__c-grossValue)<=absoluteConsiderationValue){
                            system.debug('Passes Absolute Considertation check----->');
                            system.debug('SESTaxvalue------>'+SESTaxvalue);
                            system.debug('tax value'+(cte.ICMS_Value__c*(cte.ICMS_Tax_Rate__c)/100));
                            
                            if(cte.ICMS_Tax_Rate__c!=null && (cte.ICMS_Value__c*(cte.ICMS_Tax_Rate__c)/100)==SESTaxvalue){
                                system.debug('Passes Tax percentage check----->');
                                cte.Tax_Status__c='Tax Validation Ok';
                                listCTeTaxUpdate.add(cte);
                                if(!Approval.isLocked(cte.Id)){
                                    Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                                    req.setComments('Submitting Request Tax calculation');
                                    req.setObjectId(cte.id);
                                    Approval.ProcessResult result = Approval.process(req);
                                    System.debug('Submitted for approval successfully: '+result.isSuccess());
                                }
                            } else{
                                cte.Tax_Status__c='Tax Value Error';
                                listCTeTaxUpdate.add(cte);
                                BFM_Error_Log__c newError = new BFM_Error_Log__c();          
                                newError.Reason__c = 'Tax value is not matching';
                                newError.BFM_CT_e__c = cte.id;
                                insert newError;
                            }
                        } else{
                            cte.Tax_Status__c='Absolute Consideration value Error';
                            listCTeTaxUpdate.add(cte);
                            BFM_Error_Log__c newError = new BFM_Error_Log__c();          
                            newError.Reason__c = 'Obsolute Consideration value is not matching';
                            newError.BFM_CT_e__c = cte.id;
                            insert newError;
                        }
                    } else{
                        cte.Tax_Status__c='Tolerance Margin Error';
                        listCTeTaxUpdate.add(cte);
                        //Initiate approval process 
                        if(!Approval.isLocked(cte.Id)){             
                            Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
                            req.setComments('Submitting Request for Total Value Validation');
                            req.setObjectId(cte.id);
                            Approval.ProcessResult result = Approval.process(req);
                            System.debug('Submitted for approval successfully: '+result.isSuccess());
                        }
                        BFM_Error_Log__c newError = new BFM_Error_Log__c();          
                        newError.Reason__c = 'Out of Tolerance value';
                        newError.BFM_CT_e__c = cte.id;
                        insert newError;                            
                    }
                    if(listCTeTaxUpdate != null){
                        Database.SaveResult[] updateRec = Database.update(listCTeTaxUpdate,false);
                    }
                }                               
            }
        }
    }
}