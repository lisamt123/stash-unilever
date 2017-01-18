public class BFM_WithholdTaxDebitNoteController {
	public BFM_Debit_Note__c dn{get;set;}
    private Map<String, BFM_Invoice_Withhold_Tax__c> taxesAlreadyWithheld;
    public List<BFM_Withhold_tax__c> withholdTaxList{get;set;}
    private LIST<BFM_SES__c> SESlist {get;set;}    
    public string dnId {get;set;}
    public LIST<BFM_IVA__c> ivalist {get;set;}
    public double otherBaseSum {get;set;}
    public double excludedBaseSum {get;set;}
    public double taxAmountSum {get;set;}
    public double taxBaseSum {get;set;} 
    public double taxRateSum {get;set;}
    public String taxCode {get;set;}
    
    public BFM_WithholdTaxDebitNoteController(ApexPages.StandardController stdCtr){
        dnId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('dnid---->'+dnId);
        dn = [SELECT Carrier_Account__c, Carrier_Account__r.Company_Code__c, id, Tax_Code_Id__c, DN_total_value__c FROM BFM_Debit_Note__c where ID =: dnId];
        
        SESlist = [SELECT id, Debit_Note__c, Tax_Code__c from BFM_SES__c where Debit_Note__c =: dnId];
        
        Set<String> SESIds = new Set<String>();
        Set<String> companyCodeIdFromSES = new Set<String>();
        for(BFM_SES__c ses : SESlist) {
            taxCode = ses.Tax_Code__c;
            SESIds.add(ses.id);
            companyCodeIdFromSES.add(ses.Unilever_company_code__c);
        }
        
        withholdTaxList = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c, Withholding_Tax_Text__c
                           FROM BFM_Withhold_tax__c 
                           WHERE Carrier_Account__c =: dn.Carrier_Account__c
                           AND Company_Code__c =: companyCodeIdFromSES];
        
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
        Database.upsertResult results = Database.upsert (dn);
        if(!results.isSuccess()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.BFM_Operation_Failed));
            for(Database.Error error: results.getErrors()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, error.getMessage()));
            }
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'Debit Note atualizado com sucesso'));
        }

        if(SESlist.size() > 0){ /* There must be a SES to calculate the Tax */
            System.debug('saveWithholdTaxes Tax_Code_Id__c : ' + dn.Tax_Code_Id__c);        
            if(dn.Tax_Code_Id__c != null) {
                executeQueryTax(dn.id); // Query Tax 
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'É necessário um SES associado ao documento, para cálculo da Taxa.'));  // TODO : ADD CUSTOM LABEL
        }
        
        return null;
    }       
    
    public void executeQueryTax(Id dnId) {
        BFM_Querytax.queryTaxFuture(dnId);
    }
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
}