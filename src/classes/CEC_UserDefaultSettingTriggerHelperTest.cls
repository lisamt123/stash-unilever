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
   1.1     Sathish          Mar 2016        Code Refactoring         Used CEC_TestDataFactory class
****************************************************************************/
@isTest(seealldata=false)
public class CEC_UserDefaultSettingTriggerHelperTest {

    @testSetup static void setUpTestData() {
        List<String> permissionSetsToBeAssigned = new List<String>{'CEC_User','CEC_Manager', 'CEC_CRUD',
                                                    'CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User'};
        List<String> groupList = new List<String>{'CEC - Knowledge Manager'};

        User cecTestUser = CEC_TestDataFactory.createUser('System Administrator','CEC Global Head','cectestuser@test00DE0000000bbLj.org');
        CEC_TestDataFactory.assignPermissionSet(cecTestUser.Id, permissionSetsToBeAssigned);
        CEC_TestDataFactory.addToGroup(cecTestUser.Id, groupList);
        
    } 
    
    // Test Method for updateLanguageSkillSet when language is less than 255 character
    static testMethod void updateLanguageSkillSet(){

        User cecUser = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(cecUser) {
     
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
}