/************************************************************************************************************
 Name: UID_Switch_User_Currency() 
 Copyright © 2016 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Class controller that will be used for VF page for Switch User Currency
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION    AUTHOR      DATE            DETAIL Description 
 1.0        Barcenas    04/04/2016 :    INITIAL DEVELOPMENT
 *************************************************************************************************************/
public with sharing class UID_Switch_User_Currency {

    private ApexPages.StandardController aStandardController;
    private User userDetailtest;
    private String newUserCurrency;
        
    //Constructor
    public UID_Switch_User_Currency(ApexPages.StandardController stdController) {
       
       this.userDetailtest = getTargetUser();
       aStandardController = stdController;
       ApexPages.currentPage().getParameters().put('id', this.userDetailtest.Id );
    }
    
    public User getTargetUser() { 
       User currentUserDetails = [SELECT Id, 
                                       DefaultCurrencyIsoCode
                                   FROM User
                                   WHERE Id = :UserInfo.getUserId() 
                                   LIMIT 1]; 
       return currentUserDetails; 
    }
    
    public void setnewUserCurrency(String n) {
        newUserCurrency = n;
    }
            
    public String getnewUserCurrency() {
        return newUserCurrency;
    }
     
    public PageReference setCurrency(){    
        userDetailtest.DefaultCurrencyIsoCode =  System.currentPageReference().getParameters().get('setUserCurrency');
        system.debug('New User Currency Value Before: ----------- '+System.currentPageReference().getParameters().get('setUserCurrency'));
        //userDetailtest.DefaultCurrencyIsoCode = newUserCurrency;
        //userDetailtest.UL_User_Currency__c = System.currentPageReference().getParameters().get('setUserCurrency');           
        return null;
    }
    
    public PageReference save() {
        system.debug('New User Currency Value Before Update DML: userDetailtest ----------- '+userDetailtest);
        update userDetailtest;
//        Pagereference pr = New Pagereference('/01Z/o');
        Pagereference pr = New Pagereference('/apex/UID_Switch_User_Currency');
        pr.setRedirect(true);
        return pr;
    }
    
    public PageReference cancel() {

//        Pagereference pr = New Pagereference('/01Z/o');
        Pagereference pr = New Pagereference('/apex/UID_Switch_User_Currency');
        pr.setRedirect(true);
        return pr;
    }

    public PageReference saveTab() {
        system.debug('New User Currency Value Before Update DML: userDetailtest ----------- '+userDetailtest);
        update userDetailtest;
        Pagereference pr = New Pagereference('/01Z/o');
        pr.setRedirect(true);
        return pr;
    }

   public PageReference cancelTab() {

        Pagereference pr = New Pagereference('/01Z/o');
        //Pagereference pr = New Pagereference('/apex/UID_Switch_User_Currency');
        pr.setRedirect(true);
        return pr;
    }
    
}