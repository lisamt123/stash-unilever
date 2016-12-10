/***************************************************************
Name: UL_CreatePromotionController()
Copyright © 2015 Salesforce
======================================================
Purpose:
Controller for UL_CreatePromotion apex page.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL            Description
1.0         Vinod Thupakula    24/10/2016        INITIAL DEV       Creation of promotion for UKI on SmartUI.
*****************************************************************/
public with sharing class UL_CreatePromotionController{    
         
     private final Static String CREATION_PLATFORM = 'Mobility';
     private final Static String PROMOTION_TYPE= 'SellablePromotion';
     private Map<Id, UL_Planning_Level__c> planningLevelMap;
     private Map<Id, List<Account>> unplannedSoldToCustomerMap; 
      
   public string customerset{set;get;}
         
    public ACSFUL001__Promotion__c relatedRecord { get; 
    set{
        relatedRecord  = new ACSFUL001__Promotion__c ();
        if(relatedRecord.ACSFUL001__Placement_Date_From__c == null){
            relatedRecord.ACSFUL001__Placement_Date_From__c = system.today();            
        }
         
        if(relatedRecord.ACSFUL001__Date_From__c == null ||relatedRecord.ACSFUL001__Date_Thru__c == null){    
        relatedRecord.ACSFUL001__Date_Thru__c = system.today();
        relatedRecord.ACSFUL001__Date_From__c = system.today();
        }
        
    } 
    }    
    public String defaultsoldto{set;get;}   
    public Date endDate{set;get;}
    
    public String planingLevelCustomers{set;get;}     
    public Boolean msgFlag{get;set;}
    public List<SelectOption> defultsoldtocustomers{set;get;} 
    public Boolean isForMorket{set;get;}
    public Boolean isForNational{set;get;}
    public Boolean isForPromotion{set;get;}
   
    
    private Date instoreDate{set;get;}
    private String promotionTemplateSalesOrg{set;get;}       
    private String salesOrg{set;get;}    
    private Map<Id,String> promotionTemplateWithSalesOrg = new Map<Id,String>();
    private Map<Id,String> promotionTemplateNames = new Map<Id,String>();
    
    /*******************************************************************
    Purpose: Default constructor fetch promotions
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_CreatePromotionController(ApexPages.StandardController ctr) {
        defultsoldtocustomers = new List<SelectOption>();        
        this.relatedRecord = (ACSFUL001__Promotion__c) ctr.getRecord();        
        salesOrg = UL_UtilityController.usersSalesOrg();  
        //isForMorket = false;
        //isForNational = false;
        isForPromotion  = true;
                   
    }
    
    
    /*******************************************************************
    Purpose: This method feth the promotion templates assign to promotiontemplate variable. 
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public List<SelectOption> PromotionTemplates {
        get {
            if (PromotionTemplates == null) {
                loadPromotionTemplates();
            }
            return PromotionTemplates;
        }
        private set;
    }
    
    /*******************************************************************
    Purpose: This method feth the accounts assign to Customers variable.
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public List<SelectOption> Customers{
        get {
            if (Customers== null) {
                loadCustomers();
            }
            return Customers;
        }
        private set;
    }
    /*******************************************************************
    Purpose: This method feth the promotion templates.
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public void loadPromotionTemplates() {
        PromotionTemplates = new List<SelectOption>();      
        
        For (ACSFUL001__Promotion_template__c template:[SELECT Id, 
                                                               ACSFUL001__Description__c, 
                                                               ACSFUL001__Anchor_Type__c, 
                                                               ACSFUL001__Sales_Org__c 
                                                                        FROM ACSFUL001__Promotion_Template__c 
                                                                        WHERE 
                                                               ACSFUL001__Active__c = true 
                                                                        AND   
                                                               ACSFUL001__Sales_Org__c =:salesOrg 
                                                                        AND  
                                                               ACSFUL001__Creation_Platform__c <> :CREATION_PLATFORM 
                                                                        
                                                                        ORDER BY 
                                                               ACSFUL001__Sort__c                                                                        
                                                                        limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())]) {  
            promotionTemplateWithSalesOrg.put(template.Id,template.ACSFUL001__Sales_Org__c);
            promotionTemplateNames.put(template.Id,template.ACSFUL001__Description__c);
            PromotionTemplates.add(new SelectOption(template.Id, template.ACSFUL001__Description__c));
            promotionTemplateSalesOrg  = template.ACSFUL001__Sales_Org__c;             
        }
        if(PromotionTemplates.size()<0){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO, 
                                    System.Label.ACSFUL001.ERROR_NO_PROMOTION_TEMPLATE_AVAILABLE);
            ApexPages.addMessage(msg);
        }
       
    }
   
    /*******************************************************************
    Purpose: This method is the fetch the Accounts
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/
       public void loadCustomers(){
       try{
            Customers = new List<SelectOption>(); 
            defultsoldtocustomers.clear(); 
            planingLevelCustomers = null;
            
            if(relatedRecord.ACSFUL001__Promotion_Template__c != null){    
                promotionTemplateSalesOrg=promotionTemplateWithSalesOrg.get(relatedRecord.ACSFUL001__Promotion_Template__c);    
            }
            else{
                promotionTemplateSalesOrg = salesOrg;
            }
            if(relatedRecord.ACSFUL001__Placement_Date_From__c != null){
                instoreDate = relatedRecord.ACSFUL001__Placement_Date_From__c;
            } 
            else{
                instoreDate = system.today();
            }   
            
            //Prepare Customer list from Customer Planning level object.
            planningLevelMap = new Map<Id,UL_Planning_Level__c>();
            unplannedSoldToCustomerMap  = new Map<Id, List<Account>>();
            
            for(UL_Planning_Level__c planningLevel : [SELECT UL_Customer__c,UL_Customer__r.Name,UL_Account__c,UL_Account__r.Name FROM UL_Planning_Level__c WHERE UL_Planning_Level_Start_Date__c <= :instoreDate AND UL_Planning_Level_End_Date__c >=:instoreDate]){
               Customers.add(new SelectOption(planningLevel.UL_Customer__c,planningLevel.UL_Customer__r.Name));
               planningLevelMap.put(planningLevel.UL_Customer__c, planningLevel);
               
               //Prepare 'Sold To' list for unplanned customers
               unplannedSoldToCustomerMap.put(planningLevel.UL_Customer__c, UL_CustomerUtility.getCustomerTradeOrgHierarchy(planningLevel.UL_Customer__c, UL_Utility.LEVEL8,instoreDate,instoreDate,false));
            }
            
            //Set current selected customer from the customer list
            if(Customers.size() > 0){
              planingLevelCustomers = Customers[0].getValue();
            }
            
            loaddefultsoldtocustomers();
       }
       catch(Exception ex) {
           msgFlag = true;
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
           ApexPages.addMessage(msg);
       }
        
    }
    /*******************************************************************
    Purpose: This method is to Save the promotion records
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/
   public PageReference save() {
        PageReference pref = null;
        
        try {
        if(validationTemplates()){
             mapPromotionFields();
            Database.insert(relatedRecord);
            id promotionId = relatedRecord.id;
            ApexPages.StandardController ctr = new ApexPages.StandardController(this.relatedRecord);
            String recordTypeDevName = [SELECT RecordType.DeveloperName 
                                                       FROM ACSFUL001__Promotion__c 
                                                       where 
                                               Id = :this.relatedRecord.Id 
                                               limit :(Limits.getLimitQueryRows()-Limits.getQueryRows())].RecordType.DeveloperName;
            if(PROMOTION_TYPE.equals(recordTypeDevName)){
                pref = ctr.edit();
                Map<String, String> params = pref.getParameters();
                params.clear();
                params.put('retURL', ctr.view().getURL());
            }
            else{
                pref = Page.MyPromotionPlanning;
                pref.getParameters().put('id',promotionId);
                pref.setRedirect(true);
            } 
        }
        else{
            msgFlag = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select Promotion Template!');
            ApexPages.addMessage(msg);
        }        
        } 
        catch(Exception ex) {
            msgFlag = true;
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage());
            ApexPages.addMessage(msg);
            
        }        
        return pref;
    }
    
    /*******************************************************************
    Purpose: This method is used to load deafult sold to records
    Version: 1.0
    Parameters: N/A
    Returns: NA
    Throws: NA
    ********************************************************************/
    public pagereference fetchingDefaultsoldto(){
    try{
       loaddefultsoldtocustomers();
       }
       catch(Exception ex){
         ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_CreatePromotionController', 'fetchingDefaultsoldto', 'An Error occured while fetching customers', Ex, NULL, NULL, NULL, NULL, UL_Utility.APPLICATION_NAME);
       }
       
       return null;
    }
    
    /*******************************************************************
    Purpose: This method is to fetch planning level accounts based on Anchor customer
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    private void loaddefultsoldtocustomers(){        
        defultsoldtocustomers.clear();
        Id planningLevelDefaultSoldTo;
        if(planningLevelMap.size() > 0 && planningLevelMap.containsKey(planingLevelCustomers)){
                //Load 'Default Sold To' from the planned level 
                UL_Planning_Level__c planningLevel = planningLevelMap.get(planingLevelCustomers);
                
                //if the current logged user is manager for the soldto customer 
                if(checkValidCustomers(planningLevel.UL_Account__c)){
                    defultsoldtocustomers.add(new SelectOption(planningLevel.UL_Account__c,  planningLevel.UL_Account__r.Name));
                    planningLevelDefaultSoldTo =  planningLevel.UL_Account__c;
                }
            }
            
            //Load 'Default Sold To' from Customer Sales org hierarchy
            if(unplannedSoldToCustomerMap.size() > 0 && unplannedSoldToCustomerMap.containsKey(planingLevelCustomers)){
                List<Account> defaultSoldList = unplannedSoldToCustomerMap.get(planingLevelCustomers);
                
                if(defaultSoldList != null){
                    for(Account customer: defaultSoldList){
                      //Avoid duplication option from Planning Level Default SoldTo and from Customer Org Hierarchy list
                      if(customer.id.equals(planningLevelDefaultSoldTo)){
                          continue;
                      }  
                      
                      //Validate if the current logged user is manager for the soldto customer 
                      if(checkValidCustomers(customer.id)){
                            defultsoldtocustomers.add(new SelectOption(customer.id,  customer.Name)); 
                      }
                    }
                }
            }
     }   
        
    /*******************************************************************
    Purpose: This method will redirect the page based on user sales org
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: System Exception
    ********************************************************************/ 
     public PageReference redirectPage(){
        Pagereference ref = null;
        boolean isRedirect = false;
        try{          
            List<UL_SalesOrg__c> sOrgValues = UL_SalesOrg__c.getall().values();
            for(UL_SalesOrg__c sOrg:sOrgValues){
                if(sOrg.Name.equals(salesOrg)){                    
                  isRedirect = true;                      
                } 
            }
            
            if(isRedirect){
                  ref = Page.ACSFUL001__CreatePromotion;                  
                  ref.setRedirect(true);
            }
            else{
                loadPromotionTemplates();            
                //loadCustomers();
            }
                         
        }
        catch(Exception Ex){
             ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(), 'UL_CreatePromotionController', 'redirectPage', 'An Error occured in page data load', Ex, NULL, NULL, NULL, NULL,UL_Utility.APPLICATION_NAME);
             
             }
         return ref;
    }
    
    /*******************************************************************
    Purpose: This method is used to map the promotion fields
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    private void mapPromotionFields(){
         Date dateThru;
         if(relatedRecord.ACSFUL001__Placement_Date_Thru__c == null){
             dateThru = relatedRecord.ACSFUL001__Placement_Date_From__c.addDays(1);
         }
         else{
             dateThru = relatedRecord.ACSFUL001__Placement_Date_Thru__c;
         }
         relatedRecord.ACSFUL001__Anchor_Account__c = defaultsoldto;
         relatedRecord.UL_Account__c = planingLevelCustomers;
         relatedRecord.ACSFUL001__Anchor_Account_Set__c = customerset;
         relatedRecord.ACSFUL001__Placement_Date_Thru__c= dateThru ;
         relatedRecord.ACSFUL001__Commit_Date__c = relatedRecord.ACSFUL001__Placement_Date_From__c;

         relatedRecord.ACSFUL001__Date_From__c= relatedRecord.ACSFUL001__Placement_Date_From__c ;
         relatedRecord.ACSFUL001__Date_Thru__c= dateThru;
 
         relatedRecord.ACSFUL001__Order_Date_From__c = relatedRecord.ACSFUL001__Placement_Date_From__c ;
         relatedRecord.ACSFUL001__Order_Date_Thru__c = dateThru;
 
         relatedRecord.ACSFUL001__Delivery_Date_From__c = relatedRecord.ACSFUL001__Placement_Date_From__c ;
         relatedRecord.ACSFUL001__Delivery_Date_Thru__c = dateThru;
   
    }
    
    private boolean validationTemplates(){
        boolean isValid = false;
        if(relatedRecord.ACSFUL001__Promotion_Template__c != null || relatedRecord.ACSFUL001__Promotion_Template__c != '--None--'){
        isValid  = true;
        }
        return isValid ;
    }
    
    private boolean checkValidCustomers(Id idField){
    boolean isChecked = false;
    
    list<ACSFUL001__Account_Extension__c> accExtention = [select id, name,ACSFUL001__Promotion_Valid_From__c,ACSFUL001__Promotion_Valid_Thru__c from ACSFUL001__Account_Extension__c where ACSFUL001__Account__c=:idField];
       
       for(ACSFUL001__Account_Manager__c accMgr : [select id, name, ACSFUL001__User__c,ACSFUL001__Valid_From__c,ACSFUL001__Valid_Thru__c,ACSFUL001__Active__c from ACSFUL001__Account_Manager__c where ACSFUL001__Account__c =:idField]){
           if(accMgr.ACSFUL001__User__c.equals(UserInfo.getUserID()) && accMgr.ACSFUL001__Active__c && 
           (accMgr.ACSFUL001__Valid_From__c <= instoreDate && accMgr.ACSFUL001__Valid_Thru__c>=instoreDate)){
               for(ACSFUL001__Account_Extension__c accEx:accExtention){
                   if(accEx.ACSFUL001__Promotion_Valid_From__c <= instoreDate && accEx.ACSFUL001__Promotion_Valid_Thru__c >=instoreDate){
                   isChecked  = true;
                   }
               }
           }
       }
       return isChecked ;
    }
    
    public PageReference controllFieldsWithTemplates(){
    if(promotionTemplateNames.get(relatedRecord.ACSFUL001__Promotion_Template__c).equals('National Holiday UK')){
    Account level1Acc = [select id,name from Account where UL_Customer_Hierarchy_Level__c = 'Level 1' AND UL_Sales_Organization__c=:salesOrg  limit 1];
        customerset = reloadAccountSets();
        isForMorket = false;
        isForPromotion = false;
        isForNational = true;    
        reloadAccountSets();    
    }
    else if(promotionTemplateNames.get(relatedRecord.ACSFUL001__Promotion_Template__c).equals('Marketing Event UK')){
        isForMorket = true;
        isForPromotion = false;
        isForNational = false;        
    }
    else{
        isForMorket = false;
        isForPromotion = true;
        isForNational = false; 
    }
    return null;
    
    }
    
    public void dateThruPopulate(){    
       if(relatedRecord.ACSFUL001__Date_From__c!= null){        
            relatedRecord.ACSFUL001__Date_Thru__c= relatedRecord.ACSFUL001__Date_From__c;
        }
    }
        
        
    public String  reloadAccountSets() {
    string setid;
        Set<ACSFUL001__Account_Set__c> validAccountSets = new Set<ACSFUL001__Account_Set__c>();
        String promotionTemplateSalesOrg=promotionTemplateWithSalesOrg.get(relatedRecord.ACSFUL001__Promotion_Template__c);
         if(this.relatedRecord.ACSFUL001__Date_From__c!= null) {
            Date referenceDate = Date.today();
            validAccountSets = new Set<ACSFUL001__Account_Set__c>([
                SELECT Id, ACSFUL001__Description__c, ACSFUL001__Sales_Org__c 
                FROM ACSFUL001__Account_Set__c
                WHERE ACSFUL001__Sales_Org__c =: promotionTemplateSalesOrg AND Id IN (
                    SELECT ACSFUL001__Account_Set__c
                    FROM ACSFUL001__Account_Set_Manager__c
                    WHERE ACSFUL001__Account_Set_Manager__c.ACSFUL001__Active__c = TRUE
                        AND ACSFUL001__Account_Set_Manager__c.ACSFUL001__User__c = :UserInfo.getUserId()
                        AND ACSFUL001__Account_Set_Manager__c.ACSFUL001__Valid_From__c <= :relatedRecord.ACSFUL001__Date_From__c
                        AND ACSFUL001__Account_Set_Manager__c.ACSFUL001__Valid_Thru__c >= :relatedRecord.ACSFUL001__Date_Thru__c
                )
            ]);  
                    For (ACSFUL001__Account_Set__c accountSet: validAccountSets) {
                    setid =accountSet.id; 
                    }  
            
        } else {
            System.debug('Cannot search for account sets without a reference Date');
        }
        
        return setid;
    }
    
}