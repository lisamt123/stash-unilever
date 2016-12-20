public class BFM_NFSwithholdTaxController {
    private List<BFM_NFS__c> nfsList{get;set;}
    private BFM_NFS__c nfs {get;set;}
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
        
    public BFM_NFSwithholdTaxcontroller(ApexPages.StandardController stdCtr){
        nfsId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('nfsId---->'+nfsId);
        nfs = [SELECT Carrier__c, Carrier__r.Company_Code__c, id, Tax_Code_Id__c, Tax_Code_Description__c FROM BFM_NFS__c where ID =: nfsId];
        withholdTaxList = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c, Withholding_Tax_Text__c
                        FROM BFM_Withhold_tax__c 
                        WHERE Carrier_Account__c =: nfs.Carrier__c
                        AND Company_Code__c =: nfs.Carrier__r.Company_Code__c];
        
        System.debug('withholdTaxList ' + withholdTaxList);
        
        SESlist = [SELECT id, NFS__c, Tax_Code__c from BFM_SES__c where NFS__c =: nfsId];
        
        Set<String> SESIds = new Set<String>();
        for(BFM_SES__c ses : SESlist) {
            taxCode = ses.Tax_Code__c;
            SESIds.add(ses.id);
        }
        
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

    
    /*private Set<String> getWithheldableTaxes(){
        List<BFM_Withhold_Tax__c> withheldableTaxes = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c 
                                                       FROm BFM_Withhold_tax__c 
                                                       WHERE Company_code__c =: nfs.Carrier__r.Company_Code__c
                                                       AND Carrier_Account__c =: nfs.Carrier__c];
        Set<String> validTaxCodes = new Set<String>();
        for(BFM_Withhold_Tax__c wth: withheldableTaxes){
            String key = wth.Withholding_Tax_Type__c + wth.Withholding_Tax_Code__c;
            if(!String.isEmpty(key)){
                validTaxCodes.add(wth.Withholding_Tax_Type__c + wth.Withholding_Tax_Code__c);
            }
        }
        return validTaxCodes;
    } */
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
    
    public PageReference saveWithholdTaxes() {
        // TODO : ADD VALIDATION TAX RULES - WAITING FOR PAULO
        if(nfs.Tax_Code_Id__c != null) {
            executeQueryTax(nfs.id); /* Query Tax */
        }
        
        Database.upsertResult results = Database.upsert (nfs);
        if(!results.isSuccess()){
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, Label.BFM_Operation_Failed));
            for(Database.Error error: results.getErrors()){
                ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, error.getMessage()));
            }
        } else{
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.CONFIRM, Label.BFM_Operation_Successful));
        }
        
        
        return null;
    }    
    
    /*public PageReference saveWithholdTaxes(){
        Set<String> withheldableTaxes = getWithheldableTaxes();
        if(withheldableTaxes.isEmpty()){
            String errorMessage = String.format(Label.BFM_No_withhold_tax, new List<String>{nfs.Carrier__r.Vendor__c,nfs.Carrier__r.Company_Code__c });
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
            try{
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
            }catch(Exception e) {
                
            }
            
        }
        return null;
    } */
    
    public void executeQueryTax(Id nfsId) {
        BFM_Querytax.queryTaxFuture(nfsId);
    }
}