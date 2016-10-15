/**
* Description : To check approver list
* @author : Cognizant
*
*/
@isTest
private class IPM_Approverlist_Test { 
    private static final string IPMUSER_LASTNAME='IPMUSER_LASTNAME';
    private static final string PLATFORM_LASTNAME='PLATFORM_USER';
    private static IPM_Bosscard__c boss = new IPM_Bosscard__c();
    private static User loginUser = new User();
    private static User readUser = new User();
    private static IPM_User_Profile__c up = new IPM_User_Profile__c();
    private static IPM_approverlist BosscardApprover;
    private static string bosscarName='TestApprBoss';
    /*************************************************
     * @Description: Test data initilaization
     * ***********************************************/
    @TestSetup static void initializeData(){
        readUser = IPM_TestFactory_Helper.createUser(false);
        insert readUser;
        List<User>userLists=[SELECT LastName FROM user WHERE id=:readUser.id LIMIT 1];
        System.AssertEquals(userLists[0].LastName, readUser.LastName,'your user last name is:'+userLists[0].LastName);//positive test
           
        loginUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);//only created by user can do update operation
        List<User>userList=[SELECT lastName FROM user WHERE id=:loginUser.id LIMIT 1];
        System.AssertEquals(userList[0].lastName, loginUser.lastName,'user name is:'+userList[0].lastName);//positive test
        
        
        system.runAs(loginUser){
            //Insert Bosscard
            boss = IPM_TestFactory_Helper.createIPMBosscard(false);
            boss.IPM_BosscardName__c=bosscarName;
            insert boss;
            List<IPM_Bosscard__c>bossCardList=[SELECT IPM_BosscardName__c FROM IPM_Bosscard__c WHERE id=:boss.id LIMIT 1];
            System.AssertEquals(bossCardList[0].IPM_BosscardName__c, boss.IPM_BosscardName__c,'bosscard name is:'+bossCardList[0].IPM_BosscardName__c);//positive test
            
             //Insert User Profile
            up=IPM_TestFactory_Helper.createUserProfile(false);
            up.IPM_User__c=loginUser.Id;   
            insert up;
            List<IPM_User_Profile__c>usrProfileList=[SELECT IPM_User__c FROM IPM_User_Profile__c WHERE IPM_User__c=:loginUser.id LIMIT 1];
            System.AssertEquals(usrProfileList[0].IPM_User__c, loginUser.id,'userprofile user id is:'+usrProfileList[0].IPM_User__c);//positive test
            
        }
    }

    /*************************************************
    * @Description: after filter of approver name user should select one user from list 
    * then select approver button will be enabled.
    * ***********************************************/
    Static testMethod void testSearchApprover()
    {
        loginUser=[SELECT ID FROM USER WHERE LastName=:PLATFORM_LASTNAME LIMIT 1];  
        BosscardApprover = new IPM_approverlist();  
        Test.startTest();
        system.runAs(loginUser){
            BosscardApprover.searchapprover_STR = IPMUSER_LASTNAME;
            BosscardApprover.searchApproverUser();//search user
            for(IPM_User_Profile__c upro:BosscardApprover.approverList){
                if(upro.IPM_User__r.name.equals(IPMUSER_LASTNAME)){
                    system.assertEquals(upro.IPM_User__r.name,IPMUSER_LASTNAME,'user name is:'+upro.IPM_User__r.name);//positive test   
                }
            }           
            BosscardApprover.searchapprover_STR = '';
            BosscardApprover.searchApproverUser();
            System.Assert(string.isBlank(BosscardApprover.searchapprover_STR),'values of searchapprover is :'+BosscardApprover.searchapprover_STR);
            IPM_approverlist BossApprover = new IPM_approverlist();
            BossApprover.approverid=loginUser.Id;
            BossApprover.holdApproverID();//hold selected user id only
            System.AssertEquals(BossApprover.displayApproveBtn,true,'display the approve button');//just holding user id with true or flase
        
            
        }
        Test.stopTest();
    }
    /*************************************************
    * @Description: once bosscard owner has selected an approver then he/she has to click on select approver button.
    * here we are validating with two type of user.one has edit access and another has no access on bosscard record.
    * ***********************************************/
    Static testMethod void testSaveApprover(){
        loginUser=[SELECT ID FROM USER WHERE LastName=:PLATFORM_LASTNAME LIMIT 1];  
        readUser=[SELECT ID FROM USER WHERE LastName=:IPMUSER_LASTNAME LIMIT 1];
        boss=[SELECT IPM_BosscardName__c FROM IPM_Bosscard__c WHERE IPM_BosscardName__c=:bosscarName LIMIT 1];
        BosscardApprover = new IPM_approverlist(); 
        Test.startTest();
        system.runAs(loginUser){
            BosscardApprover.bosscardId=boss.id;
            BosscardApprover.approverid=loginUser.Id;
            BosscardApprover.saveApprover();//save approver  user
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Gate_Keeper__c FROM IPM_Bosscard__c WHERE id=:boss.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Gate_Keeper__c,loginUser.Id,'Bosscard approver is:'+bossList[0].IPM_Gate_Keeper__c);//positive test
            
            
        }
        system.runAs(readUser){
            //negative test
            BosscardApprover.bosscardId=boss.id;//current user does not has access on record
            BosscardApprover.approverid=loginUser.Id;
            BosscardApprover.saveApprover();//save approver  user
            List<IPM_Bosscard__c>bossLists=[SELECT id FROM IPM_Bosscard__c WHERE id=:boss.id AND IPM_Gate_Keeper__c=:loginUser.Id LIMIT 1];
            System.AssertEquals(bossLists.isEmpty(),true, 'Bosscard List contains :'+bossLists);//Negative test
            
        }
        Test.stopTest();
    }
    
}