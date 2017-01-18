/***************************************************************
Name: UL_CannibalisationRateController
======================================================
Purpose:
Handle Canniblisation Rate New & Edit Page Controller Extension
======================================================
History
-------
VERSION     AUTHOR         DATE             DETAIL                 Description
1.0         Omkar Narkar    2/12/2016       Initial Development    Controller extention class for UL_Create_Cannibalisation_Rate VF page
***************************************************************/
public with sharing class UL_CannibalisationRateController{
    
    private final UL_Cannibalisation_Rate__c record;
    private ApexPages.StandardController stdController;
    
    /*******************************************************************
    Purpose: Constructor
    Version 1.0
    Parameters: NA
    ********************************************************************/
    public UL_CannibalisationRateController(ApexPages.StandardController stdController) {
        this.stdController = stdController;
        this.record = (UL_Cannibalisation_Rate__c)stdController.getRecord();
        
        try{
            ACCL__Product__c allProducts = UL_Utility.returnGenericProduct();
            UL_Planning_Level__c allAccounts = UL_Utility.returnGenericCustomer();
            
            this.record.UL_Planning_Level__c = allAccounts.Id;
            this.record.UL_Product__c = allProducts.Id;
        }
        catch(Exception e){}
    }
    
    /*******************************************************************
    Purpose: Updates Date Thru to Date From on Cannibalisation Edit Page.
    Version 1.0
    Parameters: NA
    Returns: void
    Throws: None
    ********************************************************************/
    public void updateThruDate(){
        try{
            if(record.UL_Valid_From__c==null){
                throw new NullPointerException();
            }
            else{
             	record.UL_Valid_Thru__c = record.UL_Valid_From__c;   
            }
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
    
    
    /*******************************************************************
    Purpose: Custom Save & New method. Saves current record and redirects to new record creation page.
    Version 1.0
    Parameters: NA
    Returns: pageReference
    Throws: None
    ********************************************************************/
    public pageReference saveNew(){
        pageReference pageRef = null;
        try{
            Database.upsert(this.record);
            pageRef = new PageReference(System.Label.UL_Slash_Char+stdController.getRecord().getSObjectType().getDescribe().getKeyPrefix()+System.Label.UL_Edit_Keyword);
        }
        catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
        return pageRef;
    }
}