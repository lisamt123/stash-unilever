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
public with sharing class UL_CreatePromotionControllerSoCo{
    
    Map<string,String> promotionTemplateWithType = new Map<string,String>();
    public string test {get;set;}
    public static string promotionTypeValue{get;set;}
    private List<ACCL__Promotion_Template__c> promotionMasterList = null;
    private ApexPages.StandardController promotionController; 
    /** the related Promotion__c record **/
    public ACCL__Promotion__c relatedRecord { get; private set; }
    /** Cached Mapping between promotionTemplate and its AnchorType **/
    public List<SelectOption> PromotionTemplates {get;set;}
    private static Map<Id, String> promotionTemplateAnchorTypes; 
    
    public UL_CreatePromotionControllerSoCo(ApexPages.StandardController ctr)
    {
        this.promotionController = ctr;
        this.relatedRecord = (ACCL__Promotion__c) ctr.getRecord();
        PromotionTemplates = new List<SelectOption>();
        System.debug(relatedRecord);
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
    
}