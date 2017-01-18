public class BFM_WithholdTaxController {
    
    public BFM_CT_e__c cte{get;set;}
    private Map<String, BFM_Invoice_Withhold_Tax__c> taxesAlreadyWithheld;
    public List<BFM_Withhold_tax__c> withholdTaxList{get;set;}
    public String cteId {get;set;}
    private LIST<BFM_SES__c> SESlist {get;set;}
    public LIST<BFM_MIRO_Item_Tax__c> ivalist {get;set;}
    public String taxCode {get;set;}
    public Double baseAmount {get;set;}
    public Boolean willApply {get;set;}
    public Set<String> withIds {get;set;}
    
    public BFM_WithholdTaxcontroller() {}
    
    public BFM_WithholdTaxcontroller(ApexPages.StandardController stdCtr) {
        cteId = ApexPages.CurrentPage().getparameters().get('id');
        system.debug('cteid---->'+cteId);
        cte = [SELECT Carrier_Account__c, Carrier_Account__r.Company_Code__c, id, Tax_Code_id__c, Tax_Code_Description__c, Receivable_Amount__c, Service_Rendering_Value__c, 
               CT_e_key__c, Last_Tax_Classification_Update__c, Last_User_To_Update_Tax__c FROM BFM_CT_e__c WHERE ID =: cteId];
        
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
        
        withIds = new Set<String>();
        for(BFM_Withhold_tax__c with : withholdTaxList) {
            withIds.add(with.id);
        }
        
        baseAmount = cte.Service_Rendering_Value__c;
        
        System.debug('withholdTaxList ' + withholdTaxList);        
        
        ivalist = [SELECT id, Other_Base__c, MIRO_Item__c, Excluded_Base__c, Tax_Amount__c, Original_Tax_Base_Amount__c, Tax_Rate__c, FRS__c, Name FROM BFM_MIRO_Item_Tax__c WHERE FRS__c =: SESIds]; 
    }
    
    public PageReference createMiroTaxInformation() {
        System.debug('createMiroTaxInformation');
        
        List<BFM_MIRO_Withhold_Tax__c> lstWithholdTax = [SELECT id from BFM_MIRO_Withhold_Tax__c where Withhold_Tax__c =: withIds];
        if(lstWithholdTax.size() >0) { delete lstWithholdTax; }
        
        List<BFM_MIRO_Withhold_Tax__c> miroTaxList = new List<BFM_MIRO_Withhold_Tax__c>();
        for(BFM_Withhold_tax__c with : withholdTaxList) {
            BFM_MIRO_Header__c miroHeader = [SELECT id from BFM_MIRO_Header__c where Access_Key__c =: cte.CT_e_key__c];
            System.debug('miroHeader' + miroHeader);
            if(miroHeader != null) {
                BFM_MIRO_Withhold_Tax__c miroTax = new BFM_MIRO_Withhold_Tax__c();
                miroTax.MIRO_Header__r = new BFM_MIRO_Header__c(Access_Key__c = cte.CT_e_key__c);
                miroTax.Withhold_Tax__c = with.id;
                miroTax.Base_Amount__c = baseAmount;
                miroTaxList.add(miroTax);
            }
        }
        
        System.debug('miroTaxList' + miroTaxList);
        if(miroTaxList.size() > 0) {
            Database.upsert(miroTaxList);      
        }
        
        return null;
    }
    
    public PageReference saveWithholdTaxes() {     
        if(cte.Tax_Code_Id__c != null) {
            cte.Last_Tax_Classification_Update__c = System.now();
            cte.Last_User_To_Update_Tax__c = UserInfo.getUserName();
        }        
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
                cte.Last_Tax_Classification_Update__c = System.now();
                cte.Last_User_To_Update_Tax__c = UserInfo.getUserEmail();
                executeQueryTax(cte.id, cte.Tax_Code_Id__c); // Query Tax 
            }
        } else {
            ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR, 'É necessário um SES associado ao documento, para cálculo da Taxa.'));  // TODO : ADD CUSTOM LABEL
        }
        
        return null;
    }      
    
    public void executeQueryTax(Id cteId, String taxCode) {
        BFM_Querytax.queryTaxFuture(cteId, taxCode);
    }    
    
    public PageReference reset() {
        PageReference newpage = new PageReference(System.currentPageReference().getURL());
        newpage.setRedirect(true);
        return newpage;
    }
    
    @RemoteAction
    public static void updateMiroWitholdTaxes(String withholdIds) {
        System.debug('withholdIds' + withholdIds);
        
        Set<Id> setWithHoldIds = new Set<Id>();
        List<BFM_MIRO_Withhold_Tax__c> miroItemsUpdateList = new List<BFM_MIRO_Withhold_Tax__c>();
        List<String> withHoldIdsList = new List<String>();
        withHoldIdsList.addAll(withholdIds.split(','));

        System.debug('withHoldIdsList' + withHoldIdsList);
        for(String str : withHoldIdsList) {
            setWithHoldIds.add(Id.valueOf(str));   
        }       
        
        System.debug('setWithHoldIds' + setWithHoldIds);
        List<BFM_Withhold_Tax__c> withHoldList = [SELECT Id, Withholding_Tax_Type__c, Withholding_Tax_Code__c, Withholding_Tax_Flag__c, Withholding_Tax_Text__c
                                                  FROM BFM_Withhold_tax__c WHERE Id =: setWithHoldIds];
        
        System.debug('withHoldList' + withHoldList);
        for(BFM_Withhold_Tax__c with : withHoldList){
            BFM_MIRO_Withhold_Tax__c miroTax = new BFM_MIRO_Withhold_Tax__c();
            miroTax.Withhold_Tax__r = new BFM_Withhold_Tax__c(Id = with.Id);
            miroItemsUpdateList.add(miroTax);
        }
        
        System.debug('miroItemsUpdateList' + miroItemsUpdateList);
        Database.upsert(miroItemsUpdateList);
    }    
}