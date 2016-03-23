/**********************************************************************
 Name:  CEC_UserTriggerHelperTest
 Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the test class for CEC_UserTriggerHelper                                                                                                     

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Richa            09-03-2015       
1.1        Sathish          Mar-2016        Code Refactoring.
 ***********************************************************************/
@isTest(seealldata=false)
public with sharing class CEC_UserTriggerHelperTest{

    @testSetup static void setUpTestData() {

        User u = CEC_TestDataFactory.createStandardCECTestUser();
    }

    // Test Method for updateLanguageSkillSet when language is less than 255 character
    static testMethod void updateLanguageSkillSet(){
     
        Test.startTest();
        User cecUser = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(cecUser) {            
            Profile p = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
            system.assert(p != null);
            User u = new User(alias = 'standt', email='pawan1234@capgemini.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser23@testorg.com',Language__c='French');
            insert u;
            u.Language__c='Dutch';
            update u;
            system.assert(u!=null);
        }
        Test.stopTest();
    }  
     // Test Method for updateLanguageSkillSet when language is more than 255 character
     static testMethod void updateLanguageSkillSet1(){
     
        Test.startTest();
        User cecUser = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(cecUser) {
            Profile p = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
            system.assert(p != null);
            User u = new User(alias = 'standt', email='pawan1234@capgemini.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser23@testorg.com');
            u.Language__c='Bosnian;Bulgarian;Croatian;Czech;Danish;Dutch;English;Finnish;Flemish;French;German;Greek;Hungarian;Italian;Moldavian;Norwegian;Polish;Portuguese;Serbian;Slovak;Slovenian;Spanish;Swedish;Bosnian;Bulgarian;Croatian;Czech;Danish;Dutch;English;Finnish;Flemish;French;German;Greek';
            insert u;
            
            u.Language__c='Bosnian;Bulgarian;Croatian;Czech;Danish;Dutch;English;Finnish;Flemish;French;German;Greek;Hungarian;Italian;Moldavian;Norwegian;Polish;Portuguese;Serbian;Slovak;Slovenian;Spanish;Swedish;Bosnian;Bulgarian;Croatian;Czech;Danish;Dutch;English;Finnish;Flemish;French;German;Greek;German;Greek';
            update u;
            system.assert(u!=null);
        }
        Test.stopTest();
    }  
       // Test Method for updateLanguageSkillSet when product category is less than 255 character
    static testMethod void updateProductCategorySkillSet(){
     
        Test.startTest();
        User cecUser = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(cecUser) {
            Profile p = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
            system.assert(p != null);
            
            User u = new User(alias = 'standt', email='pawan234@capgemini.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser24@testorg.com',Product_Category__c='Dressings');
            insert u;
            
            u.Product_Category__c= 'Hair Care';
            update u;
            system.assert(u!=null);
        }
        Test.stopTest();
    } 
    
         // Test Method for updateLanguageSkillSet when product category is more than 255 character
    static testMethod void updateProductCategorySkillSet1(){
     
        Test.startTest();
        User cecUser = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(cecUser) {

            Profile p = [Select Id From profile Where name='Unilever Way - Marketing - Standard Marketing User' LIMIT 1]; 
            system.assert(p != null);
        
            User u = new User(alias = 'standt', email='pawan123@capgemini.com', 
            emailencodingkey='UTF-8', lastname='Testing', languagelocalekey='en_US', 
            localesidkey='en_US', profileid = p.Id, 
            timezonesidkey='America/Los_Angeles', username='standarduser24@testorg.com');
            u.Product_Category__c='Hair Care;Household Care;Ice Cream;Laundry;Non Corporate Home Care Category;Non Corporate Personal Care Cat;Parent and Finance Category;Plantations;Prestige Legacy;Professional Cleaning Category;Savoury;Skin Cleansing;Spreads;Skin Care;Hair Care;Household Care;Ice Cream;Laundry;Non Corporate Home Care';
            insert u;
           
            u.Product_Category__c= 'Hair Care;Household Care;Ice Cream;Laundry;Non Corporate Home Care Category;Non Corporate Personal Care Cat;Oral Care;Other Foods;Parent and Finance Category;Plantations;Prestige Legacy;Professional Cleaning Category;Savoury;Skin Cleansing;Spreads;Skin Care;Hair Care;Household Care;Ice Cream;Laundry;Non Corporate Home Care';
            update u;
            
            system.assert(u!=null);
        }
        Test.stopTest();
    }   
}