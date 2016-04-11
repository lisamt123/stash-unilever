/**
* Description : This Test class for IPM_CreateProject apex class
* @author 
*/


@isTest
private class IPM_CreateProject_Test {
    
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
        List<User>userList=[SELECT id,LastName FROM user WHERE id=:u2.id LIMIT 1];
        System.AssertEquals(userList[0].LastName, u2.LastName,'Error in User creation');//positive test
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
        List<IPM_User_Profile__c>userProfile=[SELECT id,Name FROM IPM_User_Profile__c WHERE id=:ipmUserProfile.id LIMIT 1];
        System.AssertEquals(userProfile[0].id, ipmUserProfile.id,'Error in UserProfile creation');//positive test
        
        new IPM_CreateProject();
        System.assert(bosscardId != null ,'Bosscard have not been created');
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
        System.assert(projId != null ,'Project have not been created');
        Test.stopTest();   
    }  
}