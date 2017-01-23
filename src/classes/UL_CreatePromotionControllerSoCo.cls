/***************************************************************
Name: UL_CreatePromotionControllerSoCo
Copyright © 2016 Accenture
======================================================
Purpose:
A class to implement Promotion related functionalities.
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Alok Pandey   05/01/2017     INITIAL DEV            Promotion Type Atrribute functionality implemented.
***************************************************************/
public class UL_CreatePromotionControllerSoCo{  
    public final ACCL__Promotion__c relatedRecord { get;  set; }    
    public static string promotionTypeValue{get;set;}
    private List<ACCL__Promotion_Template__c> promotionMasterList = null;
    public List<SelectOption> PromotionTemplates {get;set;}  
    public string promotionTypeString;  
    private Map<Id,String> salesOrgs = new Map<Id,String>();
    public Boolean AnchorTypeCustomer{get;set;}
    private static Map<Id, String> promotionTemplateAnchorTypes;
    private final static String PROMOTION_REDIRECT_PAGE_KEY = 'SoCo after Promotion creation redirect';
    public UL_CreatePromotionControllerSoCo(ApexPages.StandardController ctr)
    {
        relatedRecord = (ACCL__Promotion__c) ctr.getRecord(); 
        PromotionTemplates = new List<SelectOption>();
    }  
    public List<SelectOption> promotionType
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None','--None--'));
            Schema.DescribeFieldResult fieldResult = ACCL__Promotion__c.UL_Promotion_Template_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();            
            for( Schema.PicklistEntry f : ple)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }    
    public void filterPromotionTemplates(){
     try{
        PromotionTemplates.clear();
        Accounts.clear();
        AccountSets.clear();
        promotionTypeString = promotionTypeValue ;       
        for(ACCL__Promotion_Template__c template : promotionMasterList ){            
            if(template.UL_Promo_Type_ControlView__c == promotionTypeValue ){
                PromotionTemplates.add(new SelectOption(template.Id, template.ACCL__Description__c+' - '+template.ACCL__Sales_Org__c)); 
                salesOrgs.put(template .id,template.ACCL__Sales_Org__c);
            }            
        }        
        relatedRecord.ACCL__Promotion_Template__c = PromotionTemplates[0].getValue();               
        updateAccountsAccountSets();
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }     
    public void getPromotionTemplates() { 
      try{
        Boolean userIsAccountManager = UL_TeamConcept.isAccountManager;        
        Boolean userIsAccountSetManager = UL_TeamConcept.isAccountSetManager;
        if(userIsAccountManager && userIsAccountSetManager) {
            promotionMasterList = [SELECT Id, ACCL__Description__c, UL_Promo_Type_ControlView__c, ACCL__Anchor_Type__c, ACCL__Sales_Org__c FROM ACCL__Promotion_Template__c WHERE ACCL__Active__c = TRUE  AND  ACCL__Creation_Platform__c <> 'Mobility' ORDER BY ACCL__Description__c];
        } else if (userIsAccountManager) {
            promotionMasterList = [SELECT Id, ACCL__Description__c, UL_Promo_Type_ControlView__c, ACCL__Anchor_Type__c, ACCL__Sales_Org__c FROM ACCL__Promotion_Template__c WHERE ACCL__Anchor_Type__c = 'Customer' AND ACCL__Active__c = TRUE AND ACCL__Creation_Platform__c <> 'Mobility' ORDER BY ACCL__Description__c];
        } else if (userIsAccountSetManager) {
            promotionMasterList = [SELECT Id, ACCL__Description__c, UL_Promo_Type_ControlView__c, ACCL__Anchor_Type__c, ACCL__Sales_Org__c FROM ACCL__Promotion_Template__c WHERE ACCL__Anchor_Type__c = 'CustomerSet' AND ACCL__Active__c = TRUE AND ACCL__Creation_Platform__c <> 'Mobility' ORDER BY ACCL__Description__c];
        } else {
            promotionMasterList = new List<ACCL__Promotion_Template__c>();
        }    
       }
      catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }  
            
    }  
    public List<SelectOption> Accounts{
        get {
            if (Accounts== null) {
                reloadAccounts();
            }
            return Accounts;
        }
        private set;
    }   
    public void reloadAccounts() {  
       try{   
        list<Account> validAccounts= new list<Account>();
        Accounts= new List<SelectOption>();
        String promotionTemplateSalesOrg=salesOrgs.get(relatedRecord.ACCL__Promotion_Template__c);          
        if(relatedRecord.ACCL__Date_From__c != null)
            if(promotionTypeString == UL_Utility.ACCOUNT_SPECIFIC_PROMOTION||promotionTypeString == UL_Utility.LTA){
                validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.ACCL__Sales_Org__c = :promotionTemplateSalesOrg AND 
                                 UL_Customer_Hierarchy_Level__c = :UL_Utility.LEVEL8 AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :relatedRecord.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :relatedRecord.ACCL__Date_From__c)ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];          
            }
        
        else if(promotionTypeString == UL_Utility.PARENT_PROMOTION){
            List<String> Levels = new List<String>{UL_Utility.LEVEL6, UL_Utility.LEVEL7};
            validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.ACCL__Sales_Org__c = :promotionTemplateSalesOrg AND 
                             UL_Customer_Hierarchy_Level__c IN:(Levels) AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :relatedRecord.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :relatedRecord.ACCL__Date_From__c)ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];          
        }
        
        else{
            validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.Id != null 
                             AND account.ACCL__Sales_Org__c =:promotionTemplateSalesOrg AND 
                             account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :relatedRecord.ACCL__Date_From__c)
                             AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :relatedRecord.ACCL__Date_From__c) ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
            
        }
        if(validAccounts.size()>0){
            for(Account acnt : validAccounts){
                SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                custOption.setValue(acnt.Id);
                custOption.setLabel(acnt.name + UL_Utility.HYPHEN + acnt.ACCL__Sales_Org__c);
                Accounts.add(custOption);
            }   
        }
       }
       catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    public List<SelectOption> AccountSets {
        get {
            if (AccountSets == null) {
                reloadAccountSets();
            }
            return AccountSets;
        }
        private set;
    }    
    public void reloadAccountSets() {
      try{
        Boolean updateSelectedAccountSetId = true;
        AccountSets = new List<SelectOption>();
        
        System.debug('Reloading AccountSets');
        Set<ACCL__Account_Set__c> validAccountSets = new Set<ACCL__Account_Set__c>();
        String promotionTemplateSalesOrg=salesOrgs.get(relatedRecord.ACCL__Promotion_Template__c);       
        if(this.relatedRecord.ACCL__Date_From__c != null) {            
            Date referenceDate = Date.today();
            validAccountSets = new Set<ACCL__Account_Set__c>([
                SELECT Id, ACCL__Description__c, ACCL__Sales_Org__c 
                FROM ACCL__Account_Set__c
                WHERE ACCL__Sales_Org__c =: promotionTemplateSalesOrg AND Id IN (
                    SELECT ACCL__Account_Set__c
                    FROM ACCL__Account_Set_Manager__c
                    WHERE ACCL__Account_Set_Manager__c.ACCL__Active__c = TRUE
                    AND ACCL__Account_Set_Manager__c.ACCL__User__c = :UserInfo.getUserId()
                    AND ACCL__Account_Set_Manager__c.ACCL__Valid_From__c <= :referenceDate
                    AND ACCL__Account_Set_Manager__c.ACCL__Valid_Thru__c >= :referenceDate
                )
            ]);    
            
        } else {
            System.debug('Cannot search for account sets without a reference Date');
        }
        
        // Process account sets
        For (ACCL__Account_Set__c accountSet: validAccountSets) {
            if(accountSet.Id == this.relatedRecord.ACCL__Anchor_Account_Set__c)
                updateSelectedAccountSetId = false;
            
            String description = accountSet.ACCL__description__c;
            String salesOrg = accountSet.ACCL__Sales_Org__c;
            if (description == null) description = '';
            AccountSets.add(new SelectOption(accountSet.Id, description+' - '+salesOrg));
        }
        
        // Preset AccountId with first entry
        if(validAccountSets.size() > 0) {            
            if(updateSelectedAccountSetId)
                for (ACCL__Account_Set__c firstAccountSet: validAccountSets) {
                    this.relatedRecord.ACCL__Anchor_Account_Set__c = firstAccountSet.Id;
                    break;                
                }
        } else {
            this.relatedRecord.ACCL__Anchor_Account_Set__c = null;
        }  
       }
       catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }      
    }
    
    public void updateAccountsAccountSets() {
        try{
            if (this.relatedRecord.ACCL__Promotion_Template__c == null) {                
                AnchorTypeCustomer = null;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ACCL.ERROR_NO_PROMOTION_TEMPLATE_AVAILABLE);  
                ApexPages.addMessage(msg);
            } else {
                AnchorTypeCustomer = isPromotionTemplateAnchorTypeCustomer(this.relatedRecord.ACCL__Promotion_Template__c);
                if (AnchorTypeCustomer) {                    
                    reloadAccounts();   
                } else {                    
                    reloadAccountSets();    
                }
            }
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    public static Boolean isPromotionTemplateAnchorTypeCustomer(Id promotionTemplateId) {
        
        try{
            if(promotionTemplateAnchorTypes == null)
                promotionTemplateAnchorTypes = new Map<Id, String>();
            
            if(!promotionTemplateAnchorTypes.containsKey(promotionTemplateId)) {                
                promotionTemplateAnchorTypes.put(promotionTemplateId, promotionTemplateAnchorType(promotionTemplateId));
            }
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        return (promotionTemplateAnchorTypes.get(promotionTemplateId) == UL_Utility.CUSTOMER);
    }
    private static String promotionTemplateAnchorType(Id promotionTemplateId) {
        String anchorType = UL_Utility.SPACE;
        try{
            for(ACCL__Promotion_Template__c promotionTemplate : [SELECT ACCL__Anchor_Type__c FROM ACCL__Promotion_Template__c WHERE Id = :promotionTemplateId Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]) {
                anchorType = promotionTemplate.ACCL__Anchor_Type__c;
            }
        }
        catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        
        return anchorType;
    } 
    
        /**
     * Saves the promotion
     */
    public PageReference save() {
        PageReference pr;
        
        try {database.insert(this.relatedRecord);
            Id promotionId=this.relatedRecord.id;           
            ApexPages.StandardController ctr = new ApexPages.StandardController(this.relatedRecord);
            String recordTypeDevName = [SELECT RecordType.DeveloperName FROM ACCL__Promotion__c where Id = :this.relatedRecord.Id].RecordType.DeveloperName;
            if(Constants.SELLABLE_PROMOTION_RECORDTYPE.equals(recordTypeDevName )){
                pr = ctr.edit();
                Map<String, String> params = pr.getParameters();
                params.clear();
                params.put('retURL', ctr.view().getURL());
            }
            else{
                  Map<String, UL_Utility__c> utilitySetting = UL_Utility__c.getAll();
                    if(utilitySetting != null && utilitySetting.get(PROMOTION_REDIRECT_PAGE_KEY) != null){
                        UL_Utility__c pageApiName = utilitySetting.get(PROMOTION_REDIRECT_PAGE_KEY);
                        String pageRef = '/apex/'+pageApiName.UL_Value__c+'?id='+promotionId;        
                        pr = new pageReference(pageRef);               
            } 
           }
            pr.setRedirect(true);
        } 
        catch(Exception ex) {
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
        }        
        return pr;
    }  
    
}