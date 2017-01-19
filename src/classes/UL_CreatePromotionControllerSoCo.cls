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
1.1         Eleonora Dotz 16/01/2017     Add IIBBTax Population Prepopulate IIBTAX either from anchor Or from Top Node to the Promotion    
***************************************************************/
public with sharing class UL_CreatePromotionControllerSoCo{
    
    Map<string,String> promotionTemplateWithType = new Map<string,String>();
    public string test {get;set;}
    public static string promotionTypeValue{get;set;}
    private List<ACCL__Promotion_Template__c> promotionMasterList = null;
    private ApexPages.StandardController promotionController; 
    /** the related Promotion__c record **/
    public ACCL__Promotion__c relatedRecord { get;  set; } 
    public ACCL__Promotion__c relatedRecord1 { get;  set; }
    public List<SelectOption> PromotionTemplates {get;set;}
    private static Map<Id, String> promotionTemplateAnchorTypes;
    Set<Account> finalValidAccount;
    private set<id> eligibleAnchorcust; 

    /*private PromotionTemplateId {get
        this.relatedRecord.ACCL__Promotion_Template__c = PromotionTemplates
        ; set;}
   */

    
    public UL_CreatePromotionControllerSoCo(ApexPages.StandardController ctr)
    {
        this.promotionController = ctr;
        this.relatedRecord = (ACCL__Promotion__c) ctr.getRecord();
             relatedRecord1 = (ACCL__Promotion__c) ctr.getRecord();  
        PromotionTemplates = new List<SelectOption>();
        system.debug('selected PromotionTemplates: '  + PromotionTemplates);
        system.debug('selected Anchor: '  + this.relatedRecord.ACCL__Anchor_Account__c);
        //this.relatedRecord.UL_IIBB_Tax__c = getIIBTax(this.relatedRecord);
    }
    
    public List<SelectOption> promotionType
    {
        get
        {
            List<SelectOption> options = new List<SelectOption>();
            Schema.DescribeFieldResult fieldResult = ACCL__Promotion__c.UL_Promotion_Template_Type__c.getDescribe();
            List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();            
            for( Schema.PicklistEntry f : ple)
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            return options;
        }
    }
    /*******************************************************************
    Purpose: Method to update the templates based on Promotion Type 
    Version 1.0
    Parameters: NA
    Returns: Void
    Throws : N/A 
    ********************************************************************/
    public void filterPromotionTemplates(){
        PromotionTemplates.clear();
        for(ACCL__Promotion_Template__c template : promotionMasterList ){
            
            if(template.UL_Promo_Type_ControlView__c == promotionTypeValue ){
                PromotionTemplates.add(new SelectOption(template.Id, template.ACCL__Description__c+' - '+template.ACCL__Sales_Org__c)); 
                
            }
            
        }
    }   
    /*******************************************************************
    Purpose: Method to get the All templates 
    Version 1.0
    Parameters: NA
    Returns: Void
    Throws : N/A 
    ********************************************************************/
    public void getPromotionTemplates() { 
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
    
    public void updatePromotionTemplate(){
        
        system.debug('checkingvalue..'+promotionTypeValue);
        
    }

    private decimal getIIBTax(ACCL__Promotion__c promotion){
        decimal IIBBTax = null;
        System.debug('Promotion ID: ' +promotion.ACCL__Promotion_Template__c);
        List<ACCL__Promotion_Template__c> promotionTemplate = [SELECT Id, UL_Consider_IIBB_Tax__c FROM ACCL__Promotion_Template__c WHERE id =:promotion.ACCL__Promotion_Template__c and UL_Consider_IIBB_Tax__c  = true ];
        if (promotionTemplate.size() >0){
            IIBBTax = getAnchorIIBBTaxes(promotion);
            System.debug('Promotion template is valid for IIBBTax');
        }
        return IIBBTax;
    }

    private decimal getAnchorIIBBTaxes(ACCL__Promotion__c promotion){
            decimal IIBBTax = null; 
            List<Account> accountIIBBTaxes = [SELECT Id,   UL_Level_1__c, UL_Level_1__r.name,
                                                                        (SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
                                                                        FROM IIBBTaxes__r
                                                                        where Date_From__c <= :this.relatedRecord.ACCL__Date_From__c
                                                                        and Date_Thru__c >= :this.relatedRecord.ACCL__Date_From__c
                                                                        order by Date_From__c asc) 

                                                                    FROM Account
                                                                    Where Id =: promotion.ACCL__Anchor_Account__c
                                                                    ];
            
            
            System.debug ('Anchor accountIIBBTaxes:--' + accountIIBBTaxes);
            if (accountIIBBTaxes.size()>0 && accountIIBBTaxes[0].IIBBTaxes__r != null){

                IIBBTax = accountIIBBTaxes[0].IIBBTaxes__r[0].IIBB_Tax__c;
                System.debug ('Anchor accountIIBBTaxes found:--' + accountIIBBTaxes[0].IIBBTaxes__r[0].IIBB_Tax__c);
            }
            else{
              List<Account> accountIIBBTaxesTop = [SELECT Id,   UL_Level_1__c, UL_Level_1__r.name,
                                                                        (SELECT Id, Account__c, Date_From__c, Date_Thru__c, IIBB_Tax__c 
                                                                        FROM IIBBTaxes__r
                                                                        where Date_From__c <= :this.relatedRecord.ACCL__Date_From__c
                                                                        and Date_Thru__c >= :this.relatedRecord.ACCL__Date_From__c
                                                                        order by Date_From__c asc) 

                                                                    FROM Account
                                                                    Where UL_Customer_Hierarchy_Level__c = 'Level 1'
                                                                    and ACCL__Sales_Org__c = : this.relatedRecord.ACCL__Sales_Org__c ];
             if (accountIIBBTaxesTop.size()>0 && accountIIBBTaxesTop[0].IIBBTaxes__r != null){
                IIBBTax = accountIIBBTaxesTop[0].IIBBTaxes__r[0].IIBB_Tax__c;
                System.debug ('Anchor TOPaccountIIBBTaxes found:--' + accountIIBBTaxesTop[0].IIBBTaxes__r[0].IIBB_Tax__c);
             }                                                       

            }


        return IIBBTax;
    }
    
    /* public PageReference save(){
        ACCl.CreatePromotionController CoreCls = new ACCl.CreatePromotionController(this.promotionController) ;
       // PageReference pr = ACCl.CreatePromotionController.save();
      // PageReference pr = CoreCls. save();
       this.relatedRecord =  CoreCls.relatedRecord;
       System.debug('Save Function related Record after core:'+ this.relatedRecord);

        System.debug('Promotion Template ID'+ this.relatedRecord.ACCL__Promotion_Template__c );
        this.relatedRecord.UL_IIBB_Tax__c = getIIBTax(this.relatedRecord);
        System.debug('relatedRecord__'+ relatedRecord);
        update this.relatedRecord;
       // PageReference pr = ACCl.CreatePromotionController.save();
        return pr;
        //
     } */
     
     
/*
public List<SelectOption> Accounts {
        get {
            if (Accounts == null) {
                reloadAccounts();
            }
            return Accounts;
        }
        private set;
    }
        public void reloadAccounts() {      
        system.debug('>>>>>>>>>>>' + relatedRecord1.ACCL__Date_From__c );

        list<Account> validAccounts= new list<Account>();
        Accounts = new List<SelectOption>();
        String promotionTemplateSalesOrg=this.relatedRecord.ACCL__Promotion_Template__r.ACCL__Sales_Org__c;
        system.debug('>>>>>>>>>>>' + relatedRecord.ACCL__Promotion_Template__c);
        validAccounts = [SELECT Id, Name, UL_Customer_Hierarchy_Level__c, ACCL__Sales_Org__c FROM account WHERE account.Id != null AND account.ACCL__Sales_Org__c =:promotionTemplateSalesOrg AND account.Id IN (SELECT ACCL__Account__c From ACCL__Account_Extension__c WHERE ACCL__Account_Extension__c.ACCL__Promotion_Valid_From__c <= :this.relatedRecord.ACCL__Date_From__c AND ACCL__Account_Extension__c.ACCL__Promotion_Valid_Thru__c >= :this.relatedRecord.ACCL__Date_From__c) AND account.Id IN (SELECT ACCL__Account__c FROM ACCL__Account_Manager__c WHERE ACCL__Account_Manager__c.ACCL__Active__c = true AND ACCL__Account_Manager__c.ACCL__User__c = :userinfo.getUserId() AND ACCL__Account_Manager__c.ACCL__Valid_From__c <= :this.relatedRecord.ACCL__Date_From__c AND ACCL__Account_Manager__c.ACCL__Valid_Thru__c>= :this.relatedRecord.ACCL__Date_From__c) ORDER BY account.Name Limit:(LIMITS.getLimitQueryRows()-LIMITS.getQueryRows())];
        if(validAccounts.size()>0){
                for(Account acnt : validAccounts){
                    SelectOption custOption = UL_Utility.getNewOption(UL_Utility.BOOLEAN_FALSE);
                    custOption.setValue(acnt.Id);
                    custOption.setLabel(acnt.name + UL_Utility.HYPHEN + acnt.ACCL__Sales_Org__c);
                    Accounts.add(custOption);
                    system.debug('>>>>>>>>>>>');
                    //Accounts.add(new SelectOption(acnt.Id, acnt.name + UL_Utility.HYPHEN + acnt.ACCL__Sales_Org__c)); 
                }   
            }
    }   
    
   */
       
        
}