/***************************************************************
Name: UL_CreatePromotionControllerSoCo
Copyright © 2016 Accenture
======================================================
Purpose:
A class to implement Promotion related functionalities.
Class will get invoke after click on New button from Promotion List View
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Alok Pandey   05/01/2017     INITIAL DEV            Promotion Type Atrribute functionality implemented.
***************************************************************/
public with sharing class UL_CreatePromotionControllerSoCo{  
    public final ACCL__Promotion__c relatedRecord { get;  set; }    
    public static string promotionTypeValue{get;set;}
    private List<ACCL__Promotion_Template__c> promotionMasterList = null;
    public List<SelectOption> PromotionTemplates {get;set;}  
    public string promotionTypeString;  
    private Map<Id,String> salesOrgs = new Map<Id,String>();
    public Boolean AnchorTypeCustomer{get;set;}
    private static Map<Id, String> promotionTemplateAnchorTypes;
    private final static String PROMOTION_REDIRECT_PAGE_KEY = 'UKI after Promotion creation redirect';
    private String promotionTemplateSalesOrg;
    
    public Boolean isMarketType{set;get;}
    /*******************************************************************
    Purpose: constuructor for initializing variable 
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/    
    public UL_CreatePromotionControllerSoCo(ApexPages.StandardController ctr)
    {
        relatedRecord = (ACCL__Promotion__c) ctr.getRecord(); 
        PromotionTemplates = new List<SelectOption>();
        isMarketType = true;
    }  
    public List<SelectOption> promotionType
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption(UL_Utility.DEFAULT_PROMOTION_TYPELABEL, UL_Utility.DEFAULT_PROMOTION_TYPEVALUE ));
            Schema.DescribeFieldResult fieldResult = ACCL__Promotion__c.UL_Promotion_Template_Type__c.getDescribe();
            List<Schema.PicklistEntry> promotionTypeList = fieldResult.getPicklistValues();            
            for( Schema.PicklistEntry promotionValue: promotionTypeList ){               
                SelectOption promotionOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                promotionOption.setValue(promotionValue.getLabel());
                promotionOption.setLabel(promotionValue.getValue());
                options.add(promotionOption);
                }
            return options;
        }
    }   
   /*******************************************************************
    Purpose: get filtered promotion template based on Promotion type value in Wizard
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/ 
    public void filterPromotionTemplates(){
     try{
        PromotionTemplates.clear();
        Accounts.clear();
        AccountSets.clear();
        if(promotionTypeValue.equals(UL_Utility.MARKETING_EVENT)){
            isMarketType = false;
        }else{
            isMarketType = true;
        }
        promotionTypeString = promotionTypeValue ;       
        for(ACCL__Promotion_Template__c template : promotionMasterList ){            
            if(template.UL_Promo_Type_ControlView__c == promotionTypeValue ){
                 
                //PromotionTemplates.add(new SelectOption(template.Id, template.ACCL__Description__c + UL_Utility.HYPHEN + template.ACCL__Sales_Org__c)); 
                SelectOption promotionTemplateList = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                promotionTemplateList.setValue(template.Id);
                promotionTemplateList.setLabel(template.ACCL__Description__c + UL_Utility.SPACE + UL_Utility.HYPHEN+ UL_Utility.SPACE + template.ACCL__Sales_Org__c);
                PromotionTemplates.add(promotionTemplateList);
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
    /*******************************************************************
    Purpose: get All promotion template based on logged in user and org
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/     
    public void getPromotionTemplates() { 
      try{
        Boolean userIsAccountManager = UL_TeamConcept.isAccountManager;        
        Boolean userIsAccountSetManager = UL_TeamConcept.isAccountSetManager;
        
        if(userIsAccountManager && userIsAccountSetManager) {
            promotionMasterList = [SELECT Id, ACCL__Description__c, UL_Promo_Type_ControlView__c, ACCL__Anchor_Type__c, ACCL__Sales_Org__c FROM ACCL__Promotion_Template__c WHERE ACCL__Active__c = :UL_Utility.BOOLEAN_TRUE  AND  ACCL__Creation_Platform__c <> :UL_Utility.PROMOTION_TEMPLATE_MOBILITY ORDER BY ACCL__Description__c];
        } else if (userIsAccountManager) {
            promotionMasterList = [SELECT Id, ACCL__Description__c, UL_Promo_Type_ControlView__c, ACCL__Anchor_Type__c, ACCL__Sales_Org__c FROM ACCL__Promotion_Template__c WHERE ACCL__Anchor_Type__c = :UL_Utility.PROMOTION_TEMPLATE_ANCHOR_TYPE_CUSTOMER AND ACCL__Active__c = :UL_Utility.BOOLEAN_TRUE AND ACCL__Creation_Platform__c <> :UL_Utility.PROMOTION_TEMPLATE_MOBILITY ORDER BY ACCL__Description__c];
        } else if (userIsAccountSetManager) {
            promotionMasterList = [SELECT Id, ACCL__Description__c, UL_Promo_Type_ControlView__c, ACCL__Anchor_Type__c, ACCL__Sales_Org__c FROM ACCL__Promotion_Template__c WHERE ACCL__Anchor_Type__c = :UL_Utility.PROMOTION_TEMPLATE_ANCHOR_TYPE_CUSTOMERSET AND ACCL__Active__c = :UL_Utility.BOOLEAN_TRUE AND ACCL__Creation_Platform__c <> :UL_Utility.PROMOTION_TEMPLATE_MOBILITY ORDER BY ACCL__Description__c];
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
    
    
  /*******************************************************************
    Purpose: get all valid accounts for Selected promotion template and promotion date ranges
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/   
    public void reloadAccounts() {  
       try{   
        list<Account> validAccounts= new list<Account>();
        Accounts= new List<SelectOption>();
        promotionTemplateSalesOrg=salesOrgs.get(relatedRecord.ACCL__Promotion_Template__c);          
        if(relatedRecord.ACCL__Date_From__c != null)
            if(promotionTypeString == UL_Utility.PROMOTION_TEMPLATE_TYPE_ACCOUNT_SPECIFIC_PROMOTION || 
               promotionTypeString == UL_Utility.PROMOTION_TEMPLATE_TYPE_LTA || 
               promotionTypeString == UL_Utility.PROMOTION_TEMPLATE_TYPE_ACCOUNT_PLAN){
                validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.ACCL__Sales_Org__c = :promotionTemplateSalesOrg AND UL_Is_Payer__c = TRUE AND
                                 UL_Customer_Hierarchy_Level__c = :UL_Utility.LEVEL8 AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :relatedRecord.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :relatedRecord.ACCL__Date_From__c)ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];          
            }
        else if(promotionTypeString == UL_Utility.PARENT_PROMOTION){
            List<String> Levels = new List<String>{UL_Utility.LEVEL6, UL_Utility.LEVEL7};
            validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.ACCL__Sales_Org__c = :promotionTemplateSalesOrg AND 
                             UL_Customer_Hierarchy_Level__c IN:(Levels) AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :relatedRecord.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :relatedRecord.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :relatedRecord.ACCL__Date_From__c)ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];          
        }
        else if(promotionTypeString == UL_Utility.PROMOTION_TEMPLATE_TYPE_SPECIALHOLIDAY ||  
                promotionTypeString == UL_Utility.PROMOTION_TEMPLATE_TYPE_MARKETINGEVENT || 
                promotionTypeString == UL_Utility.PROMOTION_TEMPLATE_TYPE_CUSTOMEREVENT){
            validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.UL_Is_AllCustomer_Level1__c = true AND account.ACCL__Sales_Org__c = :promotionTemplateSalesOrg ];
        
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
    
    
   /*******************************************************************
    Purpose: get all valid accounts for Selected promotion template and promotion date ranges
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/   
    public void reloadAccountsOLD() {  
       try{   
        list<Account> validAccounts= new list<Account>();
        Accounts= new List<SelectOption>();
        promotionTemplateSalesOrg=salesOrgs.get(relatedRecord.ACCL__Promotion_Template__c);          
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
    /*******************************************************************
    Purpose: get all valid account sets for Selected promotion template and promotion date ranges
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/      
    public void reloadAccountSets() {
      try{
        Boolean updateSelectedAccountSetId = true;
        AccountSets = new List<SelectOption>();
        
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
            if (description == UL_Utility.NULL_VALUE)
                 description = UL_Utility.SPACE;
            
            //Omkar - Made changes below to populate AccountSet SelectOption - 9-Feb-2017
            //AccountSets.add(new SelectOption(accountSet.Id, description + UL_Utility.SPACE +UL_Utility.HYPHEN + UL_Utility.SPACE +salesOrg));
            SelectOption accSet = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
            accSet.setValue(accountSet.Id);
            accSet.setLabel(description + UL_Utility.SPACE +UL_Utility.HYPHEN + UL_Utility.SPACE +salesOrg);
            AccountSets.add(accSet);

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
    /*******************************************************************
    Purpose: method to check anhor type value in Selected Promotion template for new Promotion
    Version 1.0
    Parameters: NA
    Returns: 
    Throws : N/A 
  ********************************************************************/   
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
     /*******************************************************************
    Purpose: method to check anhor type value in Selected Promotion template for new Promotion
    Version 1.0
    Parameters: promotionTemplateId
    Returns: Boolean
    Throws : N/A 
   ********************************************************************/  
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
    /*******************************************************************
    Purpose: method to check anhor type value in Selected Promotion template for new Promotion
    Version 1.0
    Parameters: promotionTemplateId
    Returns: String
    Throws : N/A 
   ********************************************************************/  
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
        
        try {
            if(promotionTypeValue.equals(UL_Utility.MARKETING_EVENT)){
            List<Account> allCustomers = [select id, name,UL_Customer_Hierarchy_Level__c from Account Where UL_Customer_Hierarchy_Level__c=:UL_Utility.LEVEL1 AND UL_Sales_Organization__c =:promotionTemplateSalesOrg limit 1];
            this.relatedRecord.ACCL__Anchor_Account__c = allCustomers[0].id;
            }
            this.relatedRecord.ACCL__Commit_Date__c = this.relatedRecord.ACCL__Date_From__c;
            this.relatedRecord.ACCL__Delivery_Date_From__c = this.relatedRecord.ACCL__Date_From__c;
            this.relatedRecord.ACCL__Delivery_Date_Thru__c = this.relatedRecord.ACCL__Date_Thru__c;
            this.relatedRecord.ACCL__Placement_Date_From__c = this.relatedRecord.ACCL__Date_From__c;
            this.relatedRecord.ACCL__Placement_Date_Thru__c = this.relatedRecord.ACCL__Date_Thru__c;
            database.insert(this.relatedRecord);
            Id promotionId=this.relatedRecord.id;           
            ApexPages.StandardController ctr = new ApexPages.StandardController(this.relatedRecord);
            String recordTypeDevName = [SELECT RecordType.DeveloperName FROM ACCL__Promotion__c where Id = :this.relatedRecord.Id].RecordType.DeveloperName;
            if(Constants.SELLABLE_PROMOTION_RECORDTYPE.equals(recordTypeDevName )){
                pr = ctr.edit();
                Map<String, String> params = pr.getParameters();
                params.clear();
                params.put(UL_Utility.RETURL, ctr.view().getURL());
            }
            else{
                  Map<String, UL_Utility__c> utilitySetting = UL_Utility__c.getAll();
                    if(utilitySetting != null && utilitySetting.get(PROMOTION_REDIRECT_PAGE_KEY) != null){
                        UL_Utility__c pageApiName = utilitySetting.get(PROMOTION_REDIRECT_PAGE_KEY);
                        String pageRef = UL_Utility.APEX +pageApiName.UL_Value__c + UL_Utility.URL_ID + promotionId;        
                        pr = new pageReference(pageRef);               
            } 
           }
            pr.setRedirect(true);
        } 
        catch(Exception ex) {
            //ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            //ApexPages.addMessage(msg);
            //Commented above line to display only the generic exception messages
            ApexPages.addMessages(ex);
            
        }        
        return pr;
    }  
    
}