/***************************************************************
Name: UL_PromotionCopyExtension()
Copyright © 2016 Salesforce
======================================================
Purpose:
Extension Controller for Visualforce page-UL_PromotionCopy.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Chandrababu Naidu    12/11/2016        INITIAL DEV       Copy promotion for Soco in Sprint-3.
*****************************************************************/
public with sharing class UL_PromotionCopyExtension {
    public ACCL__Promotion__c PromDetails{get;set;}
    public ACCL__Promotion__c clonePromotionDetails;
    public Boolean AnchorTypeCustomer{get;set;}
    private static Map<Id, String> promotionTemplateAnchorTypes;
    Map<Id,String> promotionTemplateWithSalesOrg = new Map<Id,String>();
    public List<SelectOption> AccountSets{get;set;}
    public List<SelectOption> Accounts {get;set;}
    private Id anchorCustomer = UL_Utility.NULL_ID;
    private Id anchorSetCustomer = UL_Utility.NULL_ID; 
    private set<id> eligibleAnchorcust;
    set<id> eligibleCustSet;
    Set<ACCL__Account_Set__c> validAccountSets;
    private List<ACCL__Tactic__c> tacticCopyRecords = new List<ACCL__Tactic__c>();
    Set<Account> finalValidAccount;
    Map<Id,Boolean> promotionCopyid = new Map<Id,Boolean>();    
    List<ACCL__promotion__c> promotionCopy;
    
    /*******************************************************************
    Purpose: Constructor
    Version: 1.0
    Parameters: N/A
    Returns: N/A
    Throws N/A
    ********************************************************************/
    public UL_PromotionCopyExtension(ApexPages.StandardController stdController){
        if(!Test.isRunningTest()){
            List<String> additionalFields = new List<String>();           
            additionalFields.add(ul_utility.templateActive); 
            additionalFields.add(ul_utility.templateAllowPast); 
            stdController.addFields(additionalFields);
        }
        PromDetails=(ACCL__Promotion__c)stdController.getRecord();
        if(isPromotionTemplateAnchorTypeCustomer(PromDetails.ACCL__Promotion_Template__c)){
            anchorCustomer = PromDetails.ACCL__Anchor_Account__c;            
        }
        else{
              anchorSetCustomer = PromDetails.ACCL__Anchor_Account_Set__c;        
        } 
        isValid();
        clonePromotionDetails = new ACCL__Promotion__c();
        eligibleAnchorcust = new set<id>();
        eligibleCustSet = new set<id>();       
    }
    
    /*******************************************************************
    Purpose: Create Promotion from the existing promotion
    Version: 1.0
    Parameters: N/A
    Returns: Page reference with new promotion id
    Throws N/A
    ********************************************************************/
    public pagereference save(){
        pagereference pageReturn=null;
        try{
      if(PromDetails.ACCL__Promotion_Template__c != null){
           ACCL__Promotion_Template__c promotionTemp = [select id,UL_Allow_past_Promotions__c from ACCL__Promotion_Template__c where id=:PromDetails.ACCL__Promotion_Template__c limit 1];
           if(!promotionTemp.UL_Allow_past_Promotions__c && (PromDetails.ACCL__Date_From__c<system.today()|| PromDetails.ACCL__Date_Thru__c<system.today())){
               ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Label.TPM_Past_Date_Validation)); 
           }
         else{ clonePromotionDetails = PromDetails;
        if(anchorCustomer!=UL_Utility.NULL_ID){            
            clonePromotionDetails.ACCL__Anchor_Account__c = anchorCustomer;
            PromDetails.ACCL__Anchor_Account_Set__c = anchorSetCustomer;
            if(!eligibleAnchorcust.contains(anchorCustomer)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.UL_EligibleAnchor));                 
            }
        }
        else if(!isValid()){
            return pageReturn;
        }
        else{
            if(!eligibleCustSet.contains(anchorSetCustomer)){
                ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.UL_EligibleAnchor));                 
            }
            
        }
        
            Map<String, object> promotionFields = new Map<String, object>();
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Date_From__c.getName(), clonePromotionDetails.ACCL__Date_From__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Anchor_Account__c.getName(), clonePromotionDetails.ACCL__Anchor_Account__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Date_Thru__c.getName(), clonePromotionDetails.ACCL__Date_Thru__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_From__c.getName(), clonePromotionDetails.ACCL__Date_From__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Placement_Date_Thru__c.getName(), clonePromotionDetails.ACCL__Date_Thru__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Delivery_Date_From__c.getName(), clonePromotionDetails.ACCL__Date_From__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Delivery_Date_Thru__c.getName(), clonePromotionDetails.ACCL__Date_Thru__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.ACCL__Slogan_Language_1__c.getName(), clonePromotionDetails.ACCL__Slogan_Language_1__c);
            promotionFields.put(Schema.SObjectType.ACCL__Promotion__c.fields.UL_Current_Status__c.getName(), UL_Utility.PROMOTION_STATUS);
            
            Map<String, object> tacticFields = new Map<String, object>();
            tacticFields.put(Schema.SObjectType.ACCL__Tactic__c.fields.ACCL__Date_From__c.getName(), clonePromotionDetails.ACCL__Date_From__c);
            tacticFields.put(Schema.SObjectType.ACCL__Tactic__c.fields.ACCL__Date_Thru__c.getName(), clonePromotionDetails.ACCL__Date_Thru__c);
            tacticFields.put(Schema.SObjectType.ACCL__Tactic__c.fields.ACCL__Instore_Date_From__c.getName(), clonePromotionDetails.ACCL__Date_From__c);
            tacticFields.put(Schema.SObjectType.ACCL__Tactic__c.fields.ACCL__Instore_Date_Thru__c.getName(), clonePromotionDetails.ACCL__Date_Thru__c);
            tacticFields.put(Schema.SObjectType.ACCL__Tactic__c.fields.ACCL__Shipment_Date_From__c.getName(), clonePromotionDetails.ACCL__Date_From__c);
            tacticFields.put(Schema.SObjectType.ACCL__Tactic__c.fields.ACCL__Shipment_Date_Thru__c.getName(), clonePromotionDetails.ACCL__Date_Thru__c);
            
            if(AnchorTypeCustomer){
                List<id> accountIds = new List<id>(); 
                accountIds.add(clonePromotionDetails.ACCL__Anchor_Account__c);
                promotionCopy = UL_PromotionUtility.clonePromotion(clonePromotionDetails.id, accountIds, UL_Utility.BOOLEAN_TRUE, UL_Utility.BOOLEAN_TRUE, promotionFields, tacticFields, null);
            }
            else{
                List<id> accountSetIds = new List<id>(); 
                accountSetIds.add(clonePromotionDetails.ACCL__Anchor_Account_Set__c);            
                promotionCopy = UL_PromotionUtility.clonePromotion(clonePromotionDetails.id, accountSetIds, UL_Utility.BOOLEAN_TRUE, UL_Utility.BOOLEAN_TRUE, promotionFields, tacticFields, null);   
                
            }
            if(promotionCopy!=null && !promotionCopy.isEmpty()){                
                pageReturn = new pagereference(Label.UL_Pomotion_URL+ promotionCopy[0].Id);                
                pageReturn.setRedirect(true);
            } 
           
           }
        }

                  
        }
        catch(Exception Ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,Ex.getMessage()));
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return pageReturn;
    }
    
    /*******************************************************************
    Purpose: get customers
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public void updateAccountsAccountSets() {
        try{
            if (this.PromDetails.ACCL__Promotion_Template__c == null) {
                AnchorTypeCustomer = null;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.ACCL.ERROR_NO_PROMOTION_TEMPLATE_AVAILABLE);  
                ApexPages.addMessage(msg);
            } else {            
                AnchorTypeCustomer = isPromotionTemplateAnchorTypeCustomer(this.PromDetails.ACCL__Promotion_Template__c);
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
    Purpose: Indicates if the promotion template uses as anchor type a customer set
    Version: 1.0
    Parameters: Id promotionTemplateId Id
    Returns: Boolean TRUE if the promotion template uses customer sets as anchor of a promotion, else FALSE
    Throws N/A
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
    Purpose: Gets the AnchorType of a promotion template
    Version: 1.0
    Parameters: Id promotionTemplateId Id
    Returns: String AnchorType of the promotion template
    Throws N/A
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
    
    /*******************************************************************
    Purpose:Method to reload Customer Sets
    Version 1.0
    Parameters: N/A
    Returns: N/A
    Throws : N/A 
    ********************************************************************/    
    public void reloadAccountSets() {
        Boolean updateSelectedAccountSetId = true;
        AccountSets = new List<SelectOption>();        
        validAccountSets = new Set<ACCL__Account_Set__c>();
        String promotionTemplateSalesOrg=UL_Utility.SPACE;
        string promAccountset=UL_Utility.SPACE;
        try{
            for(ACCL__Promotion__c promdetails : [select ACCL__Anchor_Account_Set__c,ACCL__Anchor_Account__c from ACCL__Promotion__c where id=:this.PromDetails.id Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
                if(promdetails.ACCL__Anchor_Account_Set__c!=null){
                    promAccountset = promdetails.ACCL__Anchor_Account_Set__c;
                }  
            }        
            
            if(this.PromDetails.ACCL__Date_From__c != null) {
                for(ACCL__Account_Set__c acntset : [SELECT Id, ACCL__Description__c, ACCL__Sales_Org__c 
                                                         FROM ACCL__Account_Set__c
                                                         WHERE id=:promAccountset Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
                                                             if(acntset.id!=null){
                                                                 promotionTemplateSalesOrg = acntset.ACCL__Sales_Org__c;
                                                                 
                                                                 SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                                                                 custOption.setValue(acntset.Id);
                                                                 custOption.setLabel(acntset.ACCL__Description__c+ UL_Utility.HYPHEN +acntset.ACCL__Sales_Org__c);
                                                                 AccountSets.add(custOption);
                                                                 
                                                                //AccountSets.add(new SelectOption(acntset.Id, acntset.ACCL__Description__c+ UL_Utility.HYPHEN +acntset.ACCL__Sales_Org__c)); 
                                                             }
                                                         }
                
                validAccountSets = new Set<ACCL__Account_Set__c>([
                    SELECT Id, ACCL__Description__c, ACCL__Sales_Org__c 
                    FROM ACCL__Account_Set__c
                    WHERE ACCL__Sales_Org__c =: promotionTemplateSalesOrg AND Id IN (
                        SELECT ACCL__Account_Set__c
                        FROM ACCL__Account_Set_Manager__c
                        WHERE ACCL__Account_Set_Manager__c.ACCL__Active__c = TRUE
                        AND ACCL__Account_Set_Manager__c.ACCL__User__c = :UserInfo.getUserId()
                        AND ACCL__Account_Set_Manager__c.ACCL__Valid_From__c <= :this.PromDetails.ACCL__Date_From__c
                        AND ACCL__Account_Set_Manager__c.ACCL__Valid_Thru__c >= :this.PromDetails.ACCL__Date_From__c
                    ) Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())
                ]);    
                
            } else {
                
            }
            
            // Process account sets
            for(ACCL__Account_Set__c accountSet: validAccountSets) {            
                eligibleCustSet.add(accountSet.id);
                String description = accountSet.ACCL__description__c;
                String salesOrg = accountSet.ACCL__Sales_Org__c;
                if (description == UL_Utility.NULL_VALUE) {description = UL_Utility.SPACE;}
                
                SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                custOption.setValue(accountSet.Id);
                custOption.setLabel(description+ UL_Utility.HYPHEN +salesOrg);
                AccountSets.add(custOption);
                
                //AccountSets.add(new SelectOption(accountSet.Id, description+ UL_Utility.HYPHEN +salesOrg));
            }        
            // Preset AccountId with first entry
            if(validAccountSets.size() > 0) {
                if(updateSelectedAccountSetId)
                    for (ACCL__Account_Set__c firstAccountSet: validAccountSets) {
                        this.PromDetails.ACCL__Anchor_Account_Set__c = firstAccountSet.Id;
                        break;                
                    }
            } else {            
                this.PromDetails.ACCL__Anchor_Account_Set__c = null;
            }   
        }
        catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
     }     
    }
    
    /*******************************************************************
    Purpose:Method to update Selected Customer Sets
    Version 1.0
    Parameters: N/A
    Returns: N/A
    Throws : N/A 
    ********************************************************************/
    public void updateSelectedAccountAccountSet() {
        try{
            anchorSetCustomer = PromDetails.ACCL__Anchor_Account_Set__c;
        }
        catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
        }
    } 
       
    /*******************************************************************
    Purpose:Method to update Selected Customer
    Version 1.0
    Parameters: N/A
    Returns: N/A
    Throws : N/A 
    ********************************************************************/    
    public void reloadAccounts() {
        // Todo: Check for AnchorType => unset other AnchorType in Promotion__c + Set Indicator
        
        list<Account> validAccounts= new list<Account>();
        Accounts = new List<SelectOption>();
        finalValidAccount = new Set<Account>();
        try{
            if(this.PromDetails.ACCL__Date_From__c != null) {
                
                
                // Todo: External Setting + Handling of large RecordSet / Limits
                //AccountFinding.AccountSetWrapper foundAccounts = AccountFinder.getAccounts(1000);
                
                
                string testquery = 'SELECT Id, Name, ACCL__Sales_Org__c FROM account WHERE account.Id != null AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :this.PromDetails.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :this.PromDetails.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :this.PromDetails.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :this.PromDetails.ACCL__Date_From__c) ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows() - LIMITS.getQueryRows()';
                if(validAccounts.size()>0){
                       
                }
                
            } else {
                            }        
            String promotionTemplateSalesOrg=this.PromDetails.ACCL__Promotion_Template__c;
            
            for(Account account: [select id,name, ACCL__Sales_Org__c from account where id=:this.PromDetails.ACCL__Anchor_Account__c LIMIT:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
                if(account.id!= UL_Utility.NULL_ID){
                    promotionTemplateSalesOrg = account.ACCL__Sales_Org__c;
                    finalValidAccount.add(account);                
                }
            }
            validAccounts = [SELECT Id, Name, ACCL__Sales_Org__c FROM account WHERE account.Id != null AND account.ACCL__Sales_Org__c =:promotionTemplateSalesOrg AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :this.PromDetails.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :this.PromDetails.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :this.PromDetails.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :this.PromDetails.ACCL__Date_From__c) ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
            for(Account acnt : validAccounts){
                if(acnt.id!=null){
                    eligibleAnchorcust.add(acnt.id);
                    finalValidAccount.add(acnt);                
                }
            }
            if(finalValidAccount.size()>0){
                for(Account acnt : finalValidAccount){
                    SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                    custOption.setValue(acnt.Id);
                    custOption.setLabel(acnt.name + UL_Utility.HYPHEN + acnt.ACCL__Sales_Org__c);
                    Accounts.add(custOption);
                    
                    //Accounts.add(new SelectOption(acnt.Id, acnt.name + UL_Utility.HYPHEN + acnt.ACCL__Sales_Org__c)); 
                }   
            }
        }
        catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
        }

    } 
    
    /*******************************************************************
    Purpose:Method to update Selected AnchorCustomer
    Version 1.0
    Parameters: N/A
    Returns: N/A
    Throws : N/A 
    ********************************************************************/
    public void updateAnchorcustomer(){
        try{
            anchorCustomer = PromDetails.ACCL__Anchor_Account__c;
        }
        catch(Exception ex){
           UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    /*******************************************************************
    Purpose: Method is used to bind Cancel button
    Version 1.0
    Parameters: N/A
    Returns: N/A
    Throws : N/A 
    ********************************************************************/ 
    public pagereference cancel1(){
    PageReference pageRef = null;
        try{
            Schema.DescribeSObjectResult result = ACCL__Promotion__c.sObjectType.getDescribe();
            pageRef = New PageReference(UL_Utility.FORWARD_SLASH + result.getKeyPrefix() + UL_Utility.RECORD_OPEN_PARAM);
            pageref.setRedirect(true);
        
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId()); 
        }
        
        return pageRef;
    }   
     
    /*******************************************************************
    Purpose: Method is used validate Active Promotion Template
    Version 1.0
    Parameters: N/A
    Returns: N/A
    Throws : N/A 
    ********************************************************************/       
    private boolean isValid(){
        Boolean isValid = UL_Utility.BOOLEAN_TRUE; 
        if(!PromDetails.ACCL__Promotion_Template__r.ACCL__Active__c){
            isValid = UL_Utility.BOOLEAN_FALSE;
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,label.UL_PromTemplateActive));
        }
        return isValid;
    }
}