public class BFM_NFSwithholdTaxController {
    private List<BFM_NFS__c> nfsList{get;set;}
    public BFM_NFS__c nfs {get;set;}
    private LIST<BFM_SES__c> SESlist {get;set;}
    public LIST<BFM_IVA__c> ivalist {get;set;}
    private Map<String, BFM_Invoice_Withhold_Tax__c> taxesAlreadyWithheld;
    public List<BFM_Withhold_tax__c> withholdTaxList{get;set;}
    public String nfsId {get;set;}
    public double otherBaseSum {get;set;}
    public double excludedBaseSum {get;set;}
    public double taxAmountSum {get;set;}
    public double taxBaseSum {get;set;} 
    public double taxRateSum {get;set;} 
    public String taxCode {get;set;}
    
    public BFM_NFSwithholdTaxController() {
    }
    public BFM_NFSwithholdTaxcontroller(ApexPages.StandardController stdCtr){
        nfsId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('nfsId---->'+nfsId);
        createWithHoldRecords(nfsId);
        
    }
    
    public  void createWithHoldRecords(String nfsId){
		nfs = [SELECT Carrier__c, Carrier__r.Company_Code__c, id, Tax_Code_Id__c, Tax_Code_Description__c, Base_Value__c FROM BFM_NFS__c where ID =: nfsId];
        
        SESlist = [SELECT id, NFS__c, Tax_Code__c,Unilever_company_code__c from BFM_SES__c where NFS__c =: nfsId];
        
        Set<String> SESIds = new Set<String>();
        Set<String> companyCodeIdFromSES = new Set<String>();
        for(BFM_SES__c ses : SESlist) {
            taxCode = ses.Tax_Code__c;
            SESIds.add(ses.id);
            companyCodeIdFromSES.add(ses.Unilever_company_code__c);
        }
        
        withholdTaxList = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c, Withholding_Tax_Text__c
                           FROM BFM_Withhold_tax__c 
                           WHERE Carrier_Account__c =: nfs.Carrier__c
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
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
    
    public PageReference saveWithholdTaxes() {
        Database.upsertResult results = Database.upsert (nfs);
        if(!results.isSuccess()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.BFM_Operation_Failed));
            for(Database.Error error: results.getErrors()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, error.getMessage()));
            }
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, 'NFS atualizado com sucesso')); // TODO : ADD CUSTOM LABEL
        }
        
        if(SESlist.size() > 0){ /* There must be a SES to calculate the Tax */
            if(nfs.Tax_Code_Id__c != null) {
                executeQueryTax(nfs.id); /* Query Tax */
            }        
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'É necessário um SES associado ao documento, para cálculo da Taxa.'));  // TODO : ADD CUSTOM LABEL
        }
        
        return null;
    }    
    
    public void executeQueryTax(Id nfsId) {
        BFM_Querytax.queryTaxFuture(nfsId);
    }
}