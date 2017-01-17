/***************************************************************
Name: UL_CreatePromotionController()
Copyright © 2015 Salesforce
======================================================
Purpose:
Controller for UL_CreatePromotion apex page.
======================================================
History
-------
VERSION     AUTHOR             DATE              DETAIL                             Description
1.0         Vinod Thupakula    24/10/2016        INITIAL DEV                        Creation of promotion for UKI on SmartUI.
            M Kalyan Goud      05/01/2017        Req No : TPM-1759, for LTA         Made changes to controllFieldsWithTemplates
*****************************************************************/
public with sharing class UL_CreatePromotionController{

     private final Static String CREATION_PLATFORM = 'Mobility';
     private final Static String PROMOTION_TYPE= 'SellablePromotion';

     public string customerset{set;get;}
     public String defaultsoldto{set;get;}
     public Date endDate{set;get;}
     public String planingLevelCustomers{set;get;}
     public Boolean msgFlag{get;set;}
     public List<SelectOption> defultsoldtocustomers{set;get;}
     public Boolean isForMorket{set;get;}
     public Boolean isForNational{set;get;}
     public Boolean isForPromotion{set;get;}
     public Boolean isForLTA{set;get;}
     public List<SelectOption> deliveryProfiles{set;get;}

     public ACCL__Promotion__c relatedRecord { get; 
        set{
            relatedRecord  = new ACCL__Promotion__c ();
            if(relatedRecord.ACCL__Placement_Date_From__c == null){
                relatedRecord.ACCL__Placement_Date_From__c = system.today();
                instoreDate =  system.today();
            }
            if(relatedRecord.ACCL__Date_From__c == null ||relatedRecord.ACCL__Date_Thru__c == null){
            relatedRecord.ACCL__Date_Thru__c = system.today();
            relatedRecord.ACCL__Date_From__c = system.today();
            }

        }
    }

    private Map<Id, UL_Planning_Level__c> planningLevelMap = null;
    private Map<Id, List<Account>> unplannedSoldToCustomerMap = null;
    private Id selectedCustomer{set;get;}
    private Id selectedDefaultSoldTo{set;get;}
    private Id selectedDeliveryProfile{set;get;}
    private Date instoreDate{set;get;}
    private String promotionTemplateSalesOrg{set;get;}
    private String salesOrg{set;get;}
    private Map<Id,String> promotionTemplateWithSalesOrg = new Map<Id,String>();
    private Map<Id,String> promotionTemplateNames = new Map<Id,String>();
    private Map<Id,UL_Delivery_Profile__c> listOfDeliveryProfile = new Map<Id,UL_Delivery_Profile__c>();
    /*******************************************************************
    Purpose: Default constructor fetch promotions
    Version: 1.0
    Parameters: N/A
    Returns: Void
    Throws N/A
    ********************************************************************/
    public UL_CreatePromotionController(ApexPages.StandardController ctr) {
        defultsoldtocustomers = new List<SelectOption>();
        deliveryProfiles = new List<SelectOption>();
        this.relatedRecord = (ACCL__Promotion__c) ctr.getRecord();
        salesOrg = UL_UtilityController.usersSalesOrg();
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
        try{
            PromotionTemplates = new List<SelectOption>();
            For (ACCL__Promotion_template__c template:[SELECT Id,
                                                                   ACCL__Description__c,
                                                                   ACCL__Anchor_Type__c,
                                                                   ACCL__Sales_Org__c
                                                                            FROM ACCL__Promotion_Template__c
                                                                            WHERE
                                                                   ACCL__Active__c = true
                                                                            AND
                                                                   ACCL__Sales_Org__c =:salesOrg
                                                                            AND
                                                                   ACCL__Creation_Platform__c <> :CREATION_PLATFORM

                                                                            ORDER BY
                                                                   ACCL__Sort__c
                                                                            LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]) {
                promotionTemplateWithSalesOrg.put(template.Id,template.ACCL__Sales_Org__c);
                promotionTemplateNames.put(template.Id,template.ACCL__Description__c);

                SelectOption PromotionTemplateOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                PromotionTemplateOption.setValue(template.Id);
                PromotionTemplateOption.setLabel(template.ACCL__Description__c);
                PromotionTemplates.add(PromotionTemplateOption);

                //PromotionTemplates.add(new SelectOption(template.Id, template.ACCL__Description__c));

                promotionTemplateSalesOrg  = template.ACCL__Sales_Org__c;
            }
            if(PromotionTemplates.size()<0){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.INFO,
                                        System.Label.ACCL.ERROR_NO_PROMOTION_TEMPLATE_AVAILABLE);
                ApexPages.addMessage(msg);
            }
            }
            catch(Exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,System.Label.UL_ERROR_MESSAGE));
                UL_Utility.logError(Ex, UserInfo.getUserId());
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

            if(relatedRecord.ACCL__Promotion_Template__c != null){
                promotionTemplateSalesOrg=promotionTemplateWithSalesOrg.get(relatedRecord.ACCL__Promotion_Template__c);
            }
            else{
                promotionTemplateSalesOrg = salesOrg;
            }
            if(relatedRecord.ACCL__Placement_Date_From__c != null){
                instoreDate = relatedRecord.ACCL__Placement_Date_From__c;
            }
            else{
                instoreDate = system.today();
            }

            //Prepare Customer list from Customer Planning level object.
            planningLevelMap = new Map<Id,UL_Planning_Level__c>();
            unplannedSoldToCustomerMap  = new Map<Id, List<Account>>();
            for(UL_Planning_Level__c planningLevel : [SELECT UL_Customer__c,UL_Customer__r.Name,UL_Account__c,UL_Account__r.Name FROM UL_Planning_Level__c WHERE UL_Sales_Organisation__c=:promotionTemplateSalesOrg AND UL_Planning_Level_Start_Date__c <= :instoreDate AND UL_Planning_Level_End_Date__c >=:instoreDate Order By UL_Customer__r.Name]){
                SelectOption planningLevelOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                planningLevelOption.setValue(planningLevel.UL_Customer__c);
                planningLevelOption.setLabel(planningLevel.UL_Customer__r.Name);
                Customers.add(planningLevelOption);
                //Customers.add(new SelectOption(planningLevel.UL_Customer__c,planningLevel.UL_Customer__r.Name));

                planningLevelMap.put(planningLevel.UL_Customer__c, planningLevel);
                if(selectedCustomer  != null && selectedCustomer.equals(planningLevel.UL_Customer__c)){
                   planingLevelCustomers = selectedCustomer;
                }

                //Prepare 'Sold To' list for unplanned customers
                unplannedSoldToCustomerMap.put(planningLevel.UL_Customer__c, UL_CustomerUtility.getCustomerTradeOrgHierarchy(planningLevel.UL_Customer__c, UL_Utility.LEVEL8,instoreDate,instoreDate,false));
            }

            //Set current selected customer from the customer list
           if(planingLevelCustomers == null && Customers.size() > 0){
               planingLevelCustomers = Customers[0].getValue();
            }
                loaddefultsoldtocustomers();
                loadDeliveryProfile();
       }
       catch(Exception ex) {
           msgFlag = true;
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, System.Label.UL_ERROR_MESSAGE);
           ApexPages.addMessage(msg);
           UL_Utility.logError(Ex, UserInfo.getUserId());
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
                String recordTypeDevName = [SELECT RecordType.DeveloperName FROM ACCL__Promotion__c where
                                                   Id = :this.relatedRecord.Id LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())].RecordType.DeveloperName;
                if(PROMOTION_TYPE.equals(recordTypeDevName)){
                    pref = ctr.edit();
                    Map<String, String> params = pref.getParameters();
                    params.clear();
                    params.put('retURL', ctr.view().getURL());
                }
                else{
                    pref = Page.MyPromotionPlanning;
                    pref.getParameters().put(Schema.SObjectType.ACCL__Promotion__c.fields.Id.getName(),promotionId);
                    pref.setRedirect(true);
                }
            }
            else{
                msgFlag = true;
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, system.label.UL_Template_Error);
                ApexPages.addMessage(msg);
            }
        }
        catch(Exception ex) {
            msgFlag = true;
            ApexPages.Message msg;
            if(String.valueOf(ex.getDmlType(0)).equals(UL_Utility.FIELD_CUSTOM_VALIDATION_EXCEPTION)){
                msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getdmlMessage(0));
            } else{
                msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            }
            //msg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage()+'=='+ex.getDmlType(0));
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
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
           selectedCustomer  = planingLevelCustomers;
           loaddefultsoldtocustomers();
           loadDeliveryProfile();
       }
       catch(Exception ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
       }
       return null;
    }

    /*******************************************************************
    Purpose: This method is used for set the default sold to
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    public void dafaultSoldToSet(){
        try{
             selectedDefaultSoldTo = defaultsoldto;
        }catch(Exception ex){
            UL_Utility.logError(Ex, UserInfo.getUserId());
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
                  ref = Page.UL_CreatePromotionSoCo;
                 //ref = Page.ACCL__CreatePromotion;
                  ref.setRedirect(true);
            }
            else{
                loadPromotionTemplates();
            }

        }
        catch(Exception Ex){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
                ApexPages.addMessage(msg);
                UL_Utility.logError(Ex, UserInfo.getUserId());
             }
         return ref;
    }


    /*******************************************************************
    Purpose: This method is used for conrtoll the fields based on template
    Version: 1.0
    Parameters: N/A
    Returns: PageReference
    Throws: N/A
    ********************************************************************/
    public PageReference controllFieldsWithTemplates(){
        try{
            if(relatedRecord.ACCL__Promotion_Template__c != null){
                ACCL__Promotion_template__c tempRec = [select id, name,UL_Promo_Type_ControlView__c from ACCL__Promotion_template__c where id=:relatedRecord.ACCL__Promotion_Template__c LIMIT 1];
                if(tempRec.UL_Promo_Type_ControlView__c.equals(UL_Utility.SPECIAL_HOLIDAY)){
                    Account level1Acc = [select id,name from Account where UL_Customer_Hierarchy_Level__c =:UL_Utility.LEVEL1 AND UL_Sales_Organization__c=:salesOrg  LIMIT 1];
                        isForMorket = false;
                        isForPromotion = false;
                        isForNational = true;
                        isForLTA = false;
                    }
                    else if(tempRec.UL_Promo_Type_ControlView__c.equals(UL_Utility.MARKETING_EVENT)){
                        isForMorket = true;
                        isForPromotion = false;
                        isForNational = false;
                        isForLTA = false;
                    } else if(tempRec.UL_Promo_Type_ControlView__c.equals(UL_Utility.LTA)){
                        isForLTA = true;
                        isForMorket = false;
                        isForPromotion = false;
                        isForNational = false;
                    } else{
                        isForLTA = false;
                        isForMorket = false;
                        isForPromotion = true;
                        isForNational = false;
                    }
            }

        }
        catch(Exception Ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
            }
        return null;
    }

    /*******************************************************************
    Purpose: This method is used for re-set the date field
    Version: 1.0
    Parameters: N/A
    Returns: void
    Throws: N/A
    ********************************************************************/
    public void dateThruPopulate(){
        try{
           if(relatedRecord.ACCL__Date_From__c!= null){
                relatedRecord.ACCL__Date_Thru__c= relatedRecord.ACCL__Date_From__c;
            }
        }
        catch(Exception Ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
            }
    }
    /*******************************************************************
    Purpose: This method is used for load the delivery profile
    Version: 1.0
    Parameters: N/A
    Returns: void
    Throws: N/A
    ********************************************************************/
    public void loadDeliveryProfile(){
        try{
            deliveryProfiles.clear();
            if(instoreDate != null && planingLevelCustomers != null){
                for(UL_Delivery_Profile__c uDeliveryProfile:[SELECT Id, UL_Delivery_Profile_Name__c, Name, UL_Shipment_Start_days__c, UL_Shipment_End_days__c, UL_Instore_End_days__c FROM UL_Delivery_Profile__c where UL_Valid_From__c<=:instoreDate AND UL_Valid_Thru__c>=:instoreDate AND UL_Sales_Organisation__c=:salesOrg AND (UL_Account__c =:planingLevelCustomers OR UL_Account__c = null) Limit:LIMITS.getLimitQueryRows()-LIMITS.getQueryRows()]){

                     SelectOption profileOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                     profileOption.setValue(uDeliveryProfile.Id);
                     profileOption.setLabel(uDeliveryProfile.UL_Delivery_Profile_Name__c);
                     deliveryProfiles.add(profileOption);
                     //deliveryProfiles.add(new SelectOption(uDeliveryProfile.Id,  uDeliveryProfile.UL_Delivery_Profile_Name__c));
                     listOfDeliveryProfile.put(uDeliveryProfile.Id,uDeliveryProfile);
                    if(selectedDeliveryProfile  != null && selectedDeliveryProfile.equals(uDeliveryProfile.Id)){
                       relatedRecord.UL_Delivery_Profile__c = selectedDeliveryProfile;
                   }
                }
            }
        }
        catch(Exception Ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
            }
    }
    /*******************************************************************
    Purpose: This method is used for set default delivery profile
    Version: 1.0
    Parameters: N/A
    Returns: void
    Throws: N/A
    ********************************************************************/
    public void deliveryProfileSet(){
        try{
             selectedDeliveryProfile  =   relatedRecord.UL_Delivery_Profile__c;
        }
        catch(Exception Ex){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,System.Label.UL_ERROR_MESSAGE);
            ApexPages.addMessage(msg);
            UL_Utility.logError(Ex, UserInfo.getUserId());
            }
    }

    //private methods
      /*******************************************************************
    Purpose: This method is used to map the promotion fields
    Version: 1.0
    Parameters: N/A
    Returns: Page Reference
    Throws: N/A
    ********************************************************************/
    private void mapPromotionFields(){
         Date dateThru = system.today();
         UL_Delivery_Profile__c  uDelivery = new UL_Delivery_Profile__c ();

         if(relatedRecord.ACCL__Placement_Date_Thru__c == null){
             dateThru = relatedRecord.ACCL__Placement_Date_From__c.addDays(1);
         }
         else{
             dateThru = relatedRecord.ACCL__Placement_Date_Thru__c;
         }
         if(relatedRecord.UL_Delivery_Profile__c != null && relatedRecord.UL_Delivery_Profile__c != UL_Utility.NONE){
             uDelivery = listOfDeliveryProfile.get(relatedRecord.UL_Delivery_Profile__c);
             relatedRecord.ACCL__Delivery_Date_From__c = relatedRecord.ACCL__Placement_Date_From__c.addDays(Integer.valueOf(uDelivery.UL_Shipment_Start_days__c));
             relatedRecord.ACCL__Delivery_Date_Thru__c = relatedRecord.ACCL__Placement_Date_From__c.addDays(Integer.valueOf(uDelivery.UL_Shipment_End_days__c));
             relatedRecord.ACCL__Placement_Date_Thru__c= relatedRecord.ACCL__Placement_Date_From__c.addDays(Integer.valueOf(uDelivery.UL_Instore_End_days__c));
             relatedRecord.UL_Delivery_Profile__c = uDelivery.UL_Delivery_Profile_Name__c;
         }
         else{
             relatedRecord.ACCL__Delivery_Date_From__c = relatedRecord.ACCL__Placement_Date_From__c ;
             relatedRecord.ACCL__Delivery_Date_Thru__c = dateThru;
             relatedRecord.ACCL__Placement_Date_Thru__c = dateThru;
         }
         relatedRecord.ACCL__Commit_Date__c = System.today();
         relatedRecord.ACCL__Anchor_Account__c = defaultsoldto;
         relatedRecord.UL_Account__c = planingLevelCustomers;
         relatedRecord.ACCL__Anchor_Account_Set__c = customerset;

    }

    /*******************************************************************
    Purpose: This method is used for validate the templates
    Version: 1.0
    Parameters: N/A
    Returns: boolean
    Throws: N/A
    ********************************************************************/
    private boolean validationTemplates(){
        boolean isValid = false;
        if(relatedRecord.ACCL__Promotion_Template__c != null){
        isValid  = true;
        }
        return isValid ;
    }

    /*******************************************************************
    Purpose: This method is used for validate the customers
    Version: 1.0
    Parameters: Id
    Returns: boolean
    Throws: N/A
    ********************************************************************/
    private boolean checkValidCustomers(Id idField){
    boolean isChecked = false;
       for(ACCL__Account_Manager__c accMgr : [select id, name, ACCL__User__c,ACCL__Valid_From__c,ACCL__Valid_Thru__c,ACCL__Active__c from ACCL__Account_Manager__c where ACCL__Account__c =:idField LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
           if(accMgr.ACCL__User__c.equals(UserInfo.getUserID()) && accMgr.ACCL__Active__c &&
           (accMgr.ACCL__Valid_From__c <= instoreDate && accMgr.ACCL__Valid_Thru__c>=instoreDate)){
               for(ACCL__Account_Extension__c accEx:[select id, name,ACCL__Promotion_Valid_From__c,ACCL__Promotion_Valid_Thru__c from ACCL__Account_Extension__c where ACCL__Account__c=:idField LIMIT :(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())]){
                   if(accEx.ACCL__Promotion_Valid_From__c <= instoreDate && accEx.ACCL__Promotion_Valid_Thru__c >=instoreDate){
                   isChecked  = true;
                   }
               }
           }
       }
       return isChecked ;
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
        Id planningLevelDefaultSoldTo = UL_UTILITY.NULL_ID;
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
                            SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                            custOption.setValue(customer.id);
                            custOption.setLabel(customer.Name);
                            defultsoldtocustomers.add(custOption);
                            if(selectedDefaultSoldTo  != null){
                                defaultsoldto = selectedDefaultSoldTo ;
                            }
                      }
                    }
                }
            }
     }
}