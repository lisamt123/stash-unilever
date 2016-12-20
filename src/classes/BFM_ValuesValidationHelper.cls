global with sharing class BFM_ValuesValidationHelper {
    
    private Double sesValue;
    private List<BFM_CT_e__c> cteList;
    //private List<BFM_SES__c> sesList;
    private List<String> errors{get {return errors;} set;}
    private boolean success;
    public boolean isSuccess(){
        return success;
    }
    Map<String, BFM_AbsoluteConsideration__c> absoluteConsiderationByCompanyCode;
    Map<String, BFM_ToleranceMargin__c> toleranceMarginByCompanyCode;
    Map<string, BFM_ICMS_Tolerance__c> icmsToleranceMarginByCompanyCode;
    
    webservice static String valuesValidation(List<Id> cteIdList){
        BFM_ValuesValidationHelper helper = new BFM_ValuesValidationHelper(cteIdList);
        if(!helper.isSuccess()){
            return helper.getErrorsString();
        }
        if(helper.performValuesValidation()){
            if(helper.isSuccess()){
                return 'OK';
            } else{
                return helper.getErrorsString();
            }
            return 'OK';
        } else{
            return helper.getErrorsString();
        }
    } 
    
    public BFM_ValuesValidationHelper(List<Id> cteIdList){
        success = true;
        this.cteList = [SELECT Id, Receivable_Amount__c, ICMS_Tax_Rate__c, Name,
                        (SELECT Stage__r.Unilever_Account__r.Company_Code__c,
                         Net_Value__c, Gross_Value_Net_Tax__c, ICMS_Aliquot__c, Name
                         FROM SESs__r)
                        FROM BFM_CT_e__c WHERE Id in : cteIdList];
        
        errors = new List<String>();
        absoluteConsiderationByCompanyCode = new Map<String, BFM_AbsoluteConsideration__c>();
        toleranceMarginByCompanyCode = new Map<String, BFM_ToleranceMargin__c>();
        Set<String> companyCodes = new Set<String>();
        for(BFM_CT_e__c cte: cteList){
            if(cte.Receivable_Amount__c == null || cte.ICMS_Tax_Rate__c == null){
                success = false;
                errors.add('Values not found for CT-e ' + cte.Name);
            }
            if(cte.SESs__r.isEmpty()){
                String errorMessage = Label.BFM_CT_e_doesn_t_have_SES;
                errorMessage = String.format(errorMessage, new String[]{cte.Name});
                errors.add(errorMessage);
                success = false;
            } else{
                for(BFM_SES__c ses: cte.SESs__r){
                    if(ses.Net_Value__c == null || ses.Gross_Value_Net_Tax__c == null || ses.ICMS_Aliquot__c == null){
                        success = false;
                        errors.add('Values not found for SES ' + ses.Name);
                    }
                    companyCodes.add(ses.stage__r.Unilever_Account__r.Company_Code__c);
                }
            }
        }
        for(BFM_AbsoluteConsideration__c absCon: [SELECT Company_Code__c, AbsoluteConsideration_Value__c 
                                                  FROM BFM_AbsoluteConsideration__c 
                                                  WHERE Company_Code__c IN: companyCodes]){
                                                      
                                                      absoluteConsiderationByCompanyCode.put(absCon.company_Code__c, absCon);
                                                  }
        
        for(BFM_ToleranceMargin__c tolMargin: [SELECT Company_Code__c, Tolerance_Percentage_Value__c 
                                               FROM BFM_ToleranceMargin__c 
                                               WHERE Company_Code__c = :companyCodes]){
                                                   
                                                   toleranceMarginByCompanyCode.put(tolMargin.company_code__c, tolMargin);
                                               }
        
        for(BFM_ICMS_Tolerance__c icmsTolerance: [SELECT Company_Code__c, Tolerance__c FROM BFM_ICMS_Tolerance__c WHERE Company_Code__c IN: companyCodes]){
            icmsToleranceMarginByCompanyCode.put(icmsTolerance.company_code__c, icmsTolerance);            
        }
    }
    
    public boolean performValuesValidation(){
        boolean allGood = true;
        for(BFM_CT_e__c cte: this.cteList){
            allGood = performValuesValidation(cte);
        }
        return allGood;
    }
    
    public boolean performValuesValidation(BFM_CT_e__c cte){
        if(!isValuesValidationOk(cte)){
            sendToApproval(cte);
            return false;
        } else{
            return true;
        }
        
    }
    
    public boolean performTaxValidation(BFM_CT_e__c cte){
        if(!checkICMSTaxRate(cte)){
            success = false;
            
            errors.add(String.format('Tax Error didn\'t match for CT-e {0}', new String[]{cte.Name}));
            sendToApproval(cte);
            return false;
        } else {
            return true;
        }
    }
    
    private boolean isValuesValidationOk(BFM_CT_e__c cte){
        boolean totalValueValidationOk = checkTotalValueValidation(cte);
        if(totalValueValidationOk == true){
            return true;
        } else{
            boolean absoluteToleranceOk = checkTotalValueValidationWithTolerance(cte);
            boolean percentageToleranceOk = checkTotalValueValidationWithTolerancePercentage(cte);
            
            if(absoluteToleranceOk == false){
                errors.add('Values validation with absolute tolerance didn\'t match');
            }
            if(percentageToleranceOk == false){
                errors.add('Values validation with percentage tolerance didn\'t match');
            }
            if(absoluteToleranceOk && percentageToleranceOk){
                return true;
            } else{
                return false;
            }
        }
    }
    private boolean checkTotalValueValidation(BFM_Ct_e__c cte){
        sesValue = 0;
        
        for(BFM_SES__c ses: cte.SESs__r ){
            sesvalue += ses.Net_Value__c +ses.Gross_Value_net_tax__c;
        }
        return (cte.Receivable_Amount__c == sesValue);
    }
    
    private boolean checkTotalValueValidationWithTolerance(BFM_Ct_e__c cte){
        String companyCode = cte.SESs__r[0].stage__r.Unilever_Account__r.Company_Code__c;
        Double absoluteConsiderationValue = absoluteConsiderationByCompanyCode.get(companyCode).AbsoluteConsideration_Value__c;
        if(Math.abs(cte.Receivable_Amount__c - sesValue) > absoluteConsiderationValue){
            return true;
        } else{
            return false;
        }
    }
    
    private boolean checkTotalValueValidationWithTolerancePercentage(BFM_CT_e__c cte){
        String companyCode = cte.SESs__r[0].Stage__r.Unilever_Account__r.Company_Code__c; 
        Double tolerancePercentageValue =toleranceMarginByCompanyCode.get(companyCode).Tolerance_Percentage_Value__c;
        if(Math.abs(cte.Receivable_Amount__c - sesValue) > (cte.Receivable_Amount__c * tolerancePercentageValue)){
            return true;
        } else{
            return false;
        }
    }
    
    private boolean checkICMSTaxRate(BFM_CT_e__c cte){
        double CTeICMS = cte.ICMS_Tax_Rate__c;
        double SESICMS = 0.0;
        double sesICMSOnlyValue;
        
        // checks if all SES have the same ICMS rate
        for(BFM_SES__c ses : cte.SESs__r){
            if(sesICMSOnlyValue == null){
                sesICMSOnlyValue = ses.ICMS_Aliquot__c;
            } 
            // this one is different, error
            if(ses.ICMS_Aliquot__c != sesICMSOnlyValue){
                success = false;
                errors.add(Label.BFM_ICMS_isnt_same_accross_SES);
                return false;
            } 
        }
        
        //if there was a common ICMS value to all SES, checks if the difference between CT-e ICMS and SES ICSM is within tolerance
        if(sesICMSOnlyValue != null){
            double totalDifference = Math.abs(CTeICMS - sesICMSOnlyValue);
            String companyCode = cte.SESs__r[0].stage__r.Unilever_Account__r.Company_Code__c;
            Double tolerance = icmsToleranceMarginByCompanyCode.get(companyCode).tolerance__c;    
            if(totalDifference < tolerance){
                return true;
            } else{
                success = false;
                errors.add('ICMS value didn\'t match');
                return false;	
            }
        } else{
            return false;
        }
        
    }
    
    private void sendToApproval(BFM_CT_e__c cte){
        Approval.ProcessSubmitRequest req = new Approval.ProcessSubmitRequest();
        req.setComments('Submitting Request Tax calculation');
        req.setObjectId(cte.id);
        Approval.ProcessResult result = Approval.process(req);
        System.debug('Submitted for approval successfully: '+result.isSuccess());
    }
    
    private String getErrorsString(){
        String strErrors = '';
        for(String err: this.errors){
            strErrors += err;
        }
        return strErrors;
    }
}