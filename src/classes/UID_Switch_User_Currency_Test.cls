/**********************************************************************
 Name: UID_Switch_User_Currency_Test() 
 Copyright © 2016 Salesforce 
 ====================================================== 
 ====================================================== 
 Purpose: 
 1. Test class of UID_Switch_User_Currency
 ====================================================== 
 ====================================================== 
 History 
 ------- 
 VERSION AUTHOR DATE DETAIL Description 
 1.0 Barcenas  04/18/2016 INITIAL DEVELOPMENT
 ***********************************************************************/
@isTest(seealldata=false)
public class UID_Switch_User_Currency_Test{

    static testMethod void SwitchUserCurrency(){
        
        User u = createUser();
        insert u;
        system.assert(u!=null);
        
        PageReference pageRef = Page.UID_Switch_User_Currency; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('setUserCurrency', 'USD');
        //Add test data. For example, create a set of test Opportunities
      
        // Instantiate a new controller with all parameters in the page 
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        UID_Switch_User_Currency controller = new UID_Switch_User_Currency(sc);
        
        Test.startTest();
        controller.setnewUserCurrency('USD');
        controller.getnewUserCurrency();
        controller.setCurrency();
        controller.save();
        controller.cancel();
         
        Test.stopTest();

    }
    
     static testMethod void SwitchUserCurrencyTab(){
        
        User u = createUser();
        insert u;
        system.assert(u!=null);
        
        PageReference pageRef = Page.UID_Switch_User_CurrencyTab; //replace with your VF page name
        Test.setCurrentPage(pageRef);
        pageRef.getParameters().put('setUserCurrency', 'USD');
        //Add test data. For example, create a set of test Opportunities
      
        // Instantiate a new controller with all parameters in the page 
        ApexPages.StandardController sc = new ApexPages.StandardController(u);
        UID_Switch_User_Currency controller = new UID_Switch_User_Currency(sc);
        
        Test.startTest();
        controller.setnewUserCurrency('USD');
        controller.getnewUserCurrency();
        controller.setCurrency();
        controller.saveTab();
        controller.cancelTab();
         
        Test.stopTest();

    }
    
     public static User createUser(){
        Profile p = [Select Id From profile Where name='Unilever - Salesforce MultiApp Standard' LIMIT 1]; 
        system.assert(p != null);
        User u = new User(alias = 'standt', 
                            email='useremail@test.com', 
                            emailencodingkey='UTF-8', 
                            lastname='Testing', 
                            languagelocalekey='en_US',
                            localesidkey='en_US', 
                            profileid = p.Id,
                            timezonesidkey='America/Los_Angeles', 
                            username='bdm@testorg.com',
                            Language__c='French',
                            DefaultCurrencyIsoCode = 'EUR');
                            
        return u;
     }        
}