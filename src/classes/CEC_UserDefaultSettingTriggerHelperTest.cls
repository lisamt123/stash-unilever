/**********************************************************************
 Name:  CEC_UserDefaultSettingTriggerHelperTest
 Copyright ? 2013  Unilever
 ======================================================
======================================================
Purpose:  Helper for CEC_UserDefaultSettingTrigger                                                
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Nagesh          02/04/2015       INITIAL DEVELOPMENT      CEC_UserDefaultSettingTrigger 
   
****************************************************************************/
@isTest(seealldata=false)
public with sharing class CEC_UserDefaultSettingTriggerHelperTest {
    
    // Test Method for updateLanguageSkillSet when language is less than 255 character
    static testMethod void updateLanguageSkillSet(){
     
        Test.startTest();
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
        User_Default_Setting__c userDefSett = new User_Default_Setting__c(UserName__c = u.id);
        insert userDefSett;
        Test.stopTest();
    }  
    
           
}