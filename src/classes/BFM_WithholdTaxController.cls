public class BFM_WithholdTaxController {
    
    public BFM_CT_e__c cte{get;set;}
    private Map<String, BFM_Invoice_Withhold_Tax__c> taxesAlreadyWithheld;
    public List<BFM_Withhold_tax__c> withholdTaxList{get;set;}
    public string cteId {get;set;}
    private LIST<BFM_SES__c> SESlist {get;set;}
    public LIST<BFM_IVA__c> ivalist {get;set;}
    public double otherBaseSum {get;set;}
    public double excludedBaseSum {get;set;}
    public double taxAmountSum {get;set;}
    public double taxBaseSum {get;set;} 
    public double taxRateSum {get;set;}
    public String taxCode {get;set;}
    public String baseAmount {get;set;}
    public Boolean wthApply {get;set;}
    
    public BFM_WithholdTaxcontroller() {
    }
    
    public BFM_WithholdTaxcontroller(ApexPages.StandardController stdCtr){
        cteId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('cteid---->'+cteId);
        cte = [SELECT Carrier_Account__c, Carrier_Account__r.Company_Code__c, id, Tax_Code_id__c, Tax_Code_Description__c, Receivable_Amount__c, Service_Rendering_Value__c
               FROM BFM_CT_e__c 
               WHERE ID =: cteId];
        
        SESlist = [SELECT id, CT_E__c, Tax_Code__c, Unilever_company_code__c from BFM_SES__c where CT_E__c =: cteId];
        
        Set<String> SESIds = new Set<String>();
        Set<String> companyCodeIdFromSES = new Set<String>();
        for(BFM_SES__c ses : SESlist) {
            taxCode = ses.Tax_Code__c;
            SESIds.add(ses.id);
            companyCodeIdFromSES.add(ses.Unilever_company_code__c);
        }
        
        withholdTaxList = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c, Withholding_Tax_Text__c
                           FROM BFM_Withhold_tax__c 
                           WHERE Carrier_Account__c =: cte.Carrier_Account__c
                           AND Company_Code__c =: companyCodeIdFromSES
                           AND Withholding_Tax_Flag__c = true];
        
        baseAmount = String.valueOf(cte.Service_Rendering_Value__c);
        
        System.debug('withholdTaxList ' + withholdTaxList);        
        
        ivalist = [SELECT Other_Base__c, Excluded_Base__c, Tax_Amount__c, Tax_Base__c, Tax_Rate__c, SES__c, Name FROM BFM_IVA__c WHERE SES__c =: SESIds]; 
        
        AggregateResult[] groupedResults = [SELECT SUM(Tax_Amount__c)amount, SUM(Other_Base__c)otherbase,
                                            SUM(Excluded_Base__c)excluded, SUM(Tax_Base__c)taxbase,
                                            SUM(Tax_Rate__c)rate from BFM_IVA__c WHERE SES__c =: SESIds];
        System.debug('groupedResults' + groupedResults);
        
        for (AggregateResult ar : groupedResults)  {
            otherBaseSum = Double.valueOf(ar.get('otherbase'));
            excludedBaseSum = Double.valueOf(ar.get('excluded'));
            taxAmountSum = Double.valueOf(ar.get('amount'));
            taxBaseSum = Double.valueOf(ar.get('taxbase'));
            taxRateSum = Double.valueOf(ar.get('rate'));
        }
    }
    
    public PageReference saveWithholdTaxes() {        
        Database.upsertResult results = Database.upsert (cte);
        if(!results.isSuccess()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.BFM_Operation_Failed));
            for(Database.Error error: results.getErrors()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, error.getMessage()));
            }
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'CTE atualizado com sucesso'));  // TODO : ADD CUSTOM LABEL
        }
        
        if(SESlist.size() > 0){ /* There must be a SES to calculate the Tax */
            System.debug('saveWithholdTaxes Tax_Code_Id__c : ' + cte.Tax_Code_Id__c);
            if(cte.Tax_Code_Id__c != null) {
                executeQueryTax(cte.id); // Query Tax 
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'É necessário um SES associado ao documento, para cálculo da Taxa.'));  // TODO : ADD CUSTOM LABEL
        }
        
        return null;
    }      
    
    public void executeQueryTax(Id cteId) {
        BFM_Querytax.queryTaxFuture(cteId);
    }    
    
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
}