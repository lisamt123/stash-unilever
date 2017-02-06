/***************************************************************
Name: UL_DefaultSoldTOCustomersController
Copyright © 2016 Salesforce
======================================================
Purpose:
Controller for DefaultSoldTOCustomers page.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Vinod Thupakula    05/12/2016        INITIAL DEV       Create planning level customers
*****************************************************************/
public with sharing class UL_DefaultSoldTOCustomersController{
    public UL_Planning_Level__c relatedRecord{set;get;}
    public String defaultsoldto{set;get;}
    public list<SelectOption> defultsoldtocustomers{set;get;}
    public String redirectUrl{set;get;}
    public Boolean showSaveButton{set;get;}
    public String buttonLab{set;get;} 
    private ApexPages.StandardController ctr;
    private Boolean isCustomerDifferentCurrency {set;get;} 
    private string currentCustomerLevel; 
    private Id recId;
    /*******************************************************************
    Purpose: Default constructor fetch planning level records
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_DefaultSoldTOCustomersController(ApexPages.StandardController controller) {
           controller.addFields(new List<String>{'UL_Planning_Level_End_Date__c', 'UL_Planning_Level_Start_Date__c','UL_Account__c'});
           this.relatedRecord = (UL_Planning_Level__c) controller.getRecord();    
          //Assign default start & end date. Temporary solution to read defult field value. 
          if(this.relatedRecord.UL_Planning_Level_End_Date__c == null && this.relatedRecord.UL_Planning_Level_Start_Date__c == null){
              this.relatedRecord.UL_Planning_Level_End_Date__c = Date.newInstance(2099, 12, 31);
              this.relatedRecord.UL_Planning_Level_Start_Date__c = Date.Today();
          }          
          this.ctr = controller;   
          showSaveButton = true ; 
          buttonLab = Label.ACCL.CANCEL; 
    }
    
    /*******************************************************************
    Purpose: This method is the fetch the default soldto customers
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/   
    public void loadDefaultSoldCustomers(){
        try{
        isCustomerDifferentCurrency = UL_Utility.BOOLEAN_FALSE;
        defultsoldtocustomers = new list<SelectOption>();
        system.debug('----->'+relatedRecord);
        if(relatedRecord.UL_Planning_Level_Start_Date__c != null && relatedRecord.UL_Planning_Level_End_Date__c!= null){
            
            if(relatedRecord.UL_Customer__c != null){
                Account currPLCustRec = [SELECT Id, Name,UL_Customer_Hierarchy_Level__c From Account WHERE Id =: relatedRecord.UL_Customer__c LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
                String relAccLev = currPLCustRec.UL_Customer_Hierarchy_Level__c ;            
                if(relAccLev.equalsIgnoreCase(UL_Utility.LEVEL8)){
                    defultsoldtocustomers.add(new SelectOption(relatedRecord.UL_Customer__c, currPLCustRec .Name));
                }
            }
            
            Set<String> currencySet = new Set<String>();
            List<Account> accountList = UL_CustomerUtility.getCustomerTradeOrgHierarchy(relatedRecord.UL_Customer__c, UL_Utility.LEVEL8,relatedRecord.UL_Planning_Level_Start_Date__c,relatedRecord.UL_Planning_Level_End_Date__c, false);
                if(accountList != null){
                    for(Account acc : accountList){
                        SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                        custOption.setValue(acc.id);
                        custOption.setLabel(acc.name);
                        defultsoldtocustomers.add(custOption);
                        
                        //defultsoldtocustomers.add(new SelectOption(acc.id,acc.name));
                        currencySet.add(acc.UL_Currency__c);
                    }
                    
                    //The currency discrepancy should be check at all level apart from level 8 (Sold To)
                    if(string.isNotEmpty(currentCustomerLevel) && (!currentCustomerLevel.equalsIgnoreCase(UL_Utility.LEVEL8)) &&  currencySet.size() > 1){
                        isCustomerDifferentCurrency = UL_Utility.BOOLEAN_TRUE;
                    }
                }
        }
      }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
          }
    }
    
    /*******************************************************************
    Purpose: This method used too check the valid customer
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws: System Exception
    ********************************************************************/  
    public void pageInit() {
        try{
        Id  currCustId = relatedRecord.UL_Customer__c ;
        List<Account> custLevLst = new List<Account>() ;
        List<Account> customerList = [SELECT UL_Customer_Hierarchy_Level__c From Account Where Id =: currCustId LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())] ;
                
        if(customerList.size() > 0){
            currentCustomerLevel = customerList[0].UL_Customer_Hierarchy_Level__c ;
        }
        
        if(String.isNotBlank(currentCustomerLevel)){
            currentCustomerLevel = currentCustomerLevel.substringAfter(UL_Utility.space);
            Integer level = Integer.valueOf(currentCustomerLevel);
            
            if(level < 3) {
                showSaveButton = false ;
                buttonLab = Label.ACCL.BACK;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.UL_PlanningLevelBetween3To7);
                ApexPages.addMessage(msg);
            }
        }        
        
        
        loadDefaultSoldCustomers() ;
        }
        catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
          }
    }
    
    /*******************************************************************
    Purpose: This method used to save the record
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws: System Exception
    ********************************************************************/ 
   public pageReference save(){
        pageReference pref = null;
        boolean isDuplicate = false;
       try{
        //Do not allow to create customer planning level if customer(s) at level 8 have different currency
        for(UL_Planning_Level__c existedPlanningLevels:[SELECT Id, Name,UL_Planning_Level_Start_Date__c,UL_Planning_Level_End_Date__c  From UL_Planning_Level__c WHERE UL_Customer__c =: relatedRecord.UL_Customer__c AND UL_Planning_Level_End_Date__c>=:relatedRecord.UL_Planning_Level_Start_Date__c AND UL_Planning_Level_Start_Date__c<=:relatedRecord.UL_Planning_Level_End_Date__c LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
            if(existedPlanningLevels.id != relatedRecord.id && existedPlanningLevels.UL_Planning_Level_End_Date__c  >= relatedRecord.UL_Planning_Level_Start_Date__c &&
             existedPlanningLevels.UL_Planning_Level_Start_Date__c  <= relatedRecord.UL_Planning_Level_End_Date__c){
               isDuplicate = true;                
            }
            
        }
        if(isDuplicate){
        ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.UL_PlanningLevelAndCurrency);
                ApexPages.addMessage(msg); 
        
        }
        else{
                Database.upsert(relatedRecord);
                pref  = new PageReference('/'+relatedRecord.UL_Customer__c);            
                pref.setRedirect(true);           
        }
       }
    catch(Exception ex){
        ApexPages.Message msg;
        if(ex.getMessage().contains(UL_Utility.FIELD_CUSTOM_VALIDATION_EXCEPTION)){
              msg = new ApexPages.Message(ApexPages.Severity.ERROR,UL_UtilityController.errorMessage(ex.getMessage()));
        }
        else{
              msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
        }           
           ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
          }
       return pref;
    }
   
}