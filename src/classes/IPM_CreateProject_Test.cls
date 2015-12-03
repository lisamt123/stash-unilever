/**
* Description : This Test class for IPM_CreateProject apex class
* @author 
*/


@isTest
private class IPM_CreateProject_Test {
    
    public static IPM_Bosscard__c boss;
    /***************************************************
    * @Description: Test invoke constructor of the class
    * **************************************************/
    static testMethod void testCreateProjectConstructor(){
        Test.startTest();
        Id bosscardId;
        User u2 = new User();  
        Profile p1 = [SELECT Id FROM Profile WHERE Name='Read Only']; 
        
        // Insert User
        u2 = IPM_TestFactory_Helper.createUser(false);
        u2.ProfileId = p1.Id;
        insert u2;
        System.RunAs(u2){
            new IPM_CreateProject();
            IPM_CreateProject.CreateProjectId();
            IPM_CreateProject.createBosscard();
            bosscardId = IPM_CreateProject.createBosscard(); 
           	System.assert(bosscardId !=null,'Bosscard not inserted');       
        }     

        User u1 =   IPM_TestFactory_Helper.createUser(true);
        IPM_User_Profile__c ipmUserProfile = IPM_TestFactory_Helper.createUserProfile(false);
        ipmUserProfile.IPM_user__c =  u1.id;
        insert ipmUserProfile;
        new IPM_CreateProject();
        System.assert(bosscardId != null ,'Should not be empty');
        Test.stopTest();   
    }
   
    /********************************************************************
    * @Description: This method is used to call parameterized constructor
    *               and to create projects         
    * *******************************************************************/
    static testMethod void testCreateProjectId(){
        Test.startTest();
        new IPM_CreateProject();
        Id projId =IPM_CreateProject.CreateProjectId();
        System.assert(projId != null ,'Should not be empty');
        Test.stopTest();   
    }  
}