public class BFM_WithholdTaxController {

    private BFM_CT_e__c cte{get;set;}
    private Map<String, BFM_Invoice_Withhold_Tax__c> taxesAlreadyWithheld;
    public List<BFM_Invoice_Withhold_Tax__c> withholdTaxList{get;set;}
    
    public BFM_WithholdTaxcontroller(ApexPages.StandardController stdCtr){
        Id cteId = stdCtr.getId();
        try{
        cte = [SELECT Carrier_Account__c, Unilever_Account__r.Company_Code__c, 
               Carrier_Account__r.Vendor__c,
               (SELECT Tax_Type1__c, Tax_Code1__c,Apply__c FROM Invoice_Withhold_Taxes__r) FROM BFM_CT_e__c WHERE ID = :cteId];
        
        if(!cte.Invoice_Withhold_Taxes__r.isEmpty()){
            withholdTaxList = cte.Invoice_Withhold_Taxes__r;
        } else{
            withholdTaxList = new List<BFM_Invoice_Withhold_Tax__c>();
            withholdTaxList.add(new BFM_Invoice_Withhold_Tax__c(tax_type1__c = 'IS', tax_code1__c = 's0', ct_e__c = cteId ));
            withholdTaxList.add(new BFM_Invoice_Withhold_Tax__c(tax_type1__c = 'IR', tax_code1__c = 'r1', ct_e__c = cteId));
            withholdTaxList.add(new BFM_Invoice_Withhold_Tax__c(tax_type1__c = 'CF', tax_code1__c = 'c1', ct_e__c = cteId));
            withholdTaxList.add(new BFM_Invoice_Withhold_Tax__c(tax_type1__c = 'IN', tax_code1__c = 'n0', ct_e__c = cteId));
        }
        }catch(Exception e){} 
    }
    
    public pageReference addNewLine(){
        withholdTaxList.add(new BFM_Invoice_Withhold_Tax__c());
        return null;
    }
      
    public PageReference saveWithholdTaxes(){
        Set<String> withheldableTaxes = getWithheldableTaxes();
        if(withheldableTaxes.isEmpty()){
            String errorMessage = String.format(Label.BFM_No_withhold_tax, new List<String>{cte.Carrier_Account__r.Vendor__c,cte.Unilever_Account__r.Company_Code__c });
            System.debug(errorMessage);
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, errorMessage));
        } else{
            List<BFM_Invoice_Withhold_Tax__c> withholdTaxes = new List<BFM_Invoice_Withhold_Tax__c>();
            for(BFM_Invoice_Withhold_Tax__c line: withholdTaxList){
                if(line.apply__c){
                    if(!withheldableTaxes.contains(line.tax_type1__c+line.tax_Code1__c)){
                        System.debug('Invalid withhold tax ' + line.tax_type1__c + ' '+ line.tax_Code1__c);
                        ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, String.format(Label.BFM_Invalid_Withhold_Tax,
                                                                                                           new List<string>{line.tax_type1__c, line.tax_Code1__c})));
                    } else{
                        withholdTaxes.add(line);
                    }
                } else{
                    withholdTaxes.add(line);
                }
                
            }
            Database.upsertResult[] results = Database.upsert (withholdTaxes);
            for(Database.upsertResult sr : results){
                if(!sr.isSuccess()){
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.BFM_Operation_Failed));
                    for(Database.Error error: sr.getErrors()){
                    	ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, error.getMessage()));
                    }
                } else{
                    ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, Label.BFM_Operation_Successful));
                }
                    
            }
            
        }
        return null;
    }
    
    private Set<String> getWithheldableTaxes(){
        List<BFM_Withhold_Tax__c> withheldableTaxes = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c 
                                                       FROm BFM_Withhold_tax__c 
                                                       		WHERE Company_code__c =: cte.Unilever_Account__r.company_Code__c
                                                       AND Carrier_Account__c =: cte.Carrier_Account__c];
        Set<String> validTaxCodes = new Set<String>();
        for(BFM_Withhold_Tax__c wth: withheldableTaxes){
            String key = wth.Withholding_Tax_Type__c + wth.Withholding_Tax_Code__c;
            if(!String.isEmpty(key)){
            	validTaxCodes.add(wth.Withholding_Tax_Type__c + wth.Withholding_Tax_Code__c);
            }
        }
        return validTaxCodes;
    }
    
    public PageReference reset(){
        delete [SELECT Id FROM BFM_Invoice_Withhold_Tax__c WHERE Ct_e__c = :cte.Id];
        return Page.BFM_WithholdTax;
    }
}