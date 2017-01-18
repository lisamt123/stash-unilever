/**
 * Name:        -   CTT_PostRefreshUserSetupTest
 * @description -   This is a test class to test user creation after sandbox refresh.
 * @Author      -   Prafull Choudhary   
 */
@isTest
public class CTT_PostRefreshUserSetupTest{
    public static @isTest void runTest(){
        list<CTT_User_Setup_Details__c> details = new list<CTT_User_Setup_Details__c>();
        details.add(new CTT_User_Setup_Details__c(name             = 'set1',
                                                  Sandbox_Name__c  = 'Accval01',
                                                  First_Name__c    = 'dev', 
                                                  Last_Name__c     = 'loper', 
                                                  Email__c         = 'myadminuser@unileverorg11.com' ));
                                              
        insert details;
        Test.startTest();
            CTT_PostRefreshUserSetup ClassInstance = new CTT_PostRefreshUserSetup();
            Test.testSandboxPostCopyScript(ClassInstance, UserInfo.getOrganizationId(), null, 'Accval01');
        Test.stopTest();    
        System.assertEquals(1, [Select count() from user where username ='myadminuser@unileverorg11.com.Accval01adm']);
    }
}