/**
* IPM_BosscardStatusController_Test : This Test class for IPM_BosscardStatusController apex class
* @author 
*
*/
@isTest
public class IPM_BosscardStatusController_Test
{   
    
    
    private static String SF_ID = 'Id';
    private static String BOSSFEEDBACK = 'Project has approved';
    private static User loginUser = new User();
    private static User readUser = new User();
    private static IPM_Bosscard__c boss = new IPM_Bosscard__c();
    private static IPM_Company_Card__c compCard = new IPM_Company_Card__c();
    private static IPM_User_Profile__c up = new IPM_User_Profile__c();
    private static IPM_BosscardStatusController bossCtrl;
    private static string IPMUSER_LASTNAME='IPMUSER_LASTNAME';
    private static string lastUserName_STR='user last name is:';
    private static string bosscardStatus_STR='Bosscard status is:';
    private static string category_STR='Household Care';
    /*********************************************************************
    * @Description: This method is used to initialize data for test class
    * *******************************************************************/
    static void initializeData(){
        
        //Insert User
        loginUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);//only created by user can do update operation
        readUser = IPM_TestFactory_Helper.createUser(false);
        insert readUser;
        
        List<User>userList=[SELECT LastName FROM user WHERE id=:loginUser.id LIMIT 1];
        System.AssertEquals(userList[0].LastName, loginUser.LastName,lastUserName_STR+userList[0].LastName);//positive test
        List<User>userLists=[SELECT LastName FROM user WHERE id=:readUser.id LIMIT 1];
        System.AssertEquals(userLists[0].LastName, readUser.LastName,lastUserName_STR+userLists[0].LastName);//positive test
       
        system.RunAs(loginUser){
            //Insert Company Card
            compCard=IPM_TestFactory_Helper.createGlobalCompanyCard(false);
            compCard.Name='bosscard company card';
            compCard.IPM_Managed_Category__c=category_STR;
            compCard.IPM_Currency__c='10';
            compCard.IPM_TxtGeographical_Scope__c='Global';
            insert compCard;
            List<IPM_Company_Card__c>companyCList=[SELECT Name FROM IPM_Company_Card__c WHERE ID=:compCard.id LIMIT 1];
            System.AssertEquals(companyCList[0].Name,compCard.Name, 'company card name is:'+companyCList[0].Name); //Positive test
            
            //Insert User Profile
            up=IPM_TestFactory_Helper.createUserProfile(false);
            up.IPM_User__c=loginUser.Id; 
            up.IPM_Company_Card__c= compCard.id;
            up.IPM_User_Function__c='Project Leader';
            up.IPM_User_Category__c=category_STR;
            insert up;
            List<IPM_User_Profile__c>userProfileCList=[SELECT IPM_User__c FROM IPM_User_Profile__c WHERE ID=:up.id LIMIT 1];
            System.AssertEquals(userProfileCList[0].IPM_User__c,loginUser.Id, 'user profile user name is:'+userProfileCList[0].IPM_User__c); //Positive test
            
            //Insert Bosscard
            boss = IPM_TestFactory_Helper.createIPMBosscard(false);
            boss.IPM_Bosscard_Status__c = IPM_ConstantUtils.STATUS_IN_PROGRESS;
            boss.IPM_Company_Card__c=compCard.id;
            insert boss;
            List<IPM_Bosscard__c>bossList=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
            System.AssertEquals(bossList[0].IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS, bosscardStatus_STR+bossList[0].IPM_Bosscard_Status__c); //Positive test
                    
            //call class constructor as project leader role
            
            PageReference pg = Page.IPM_BosscardStatus;
            Test.setCurrentPageReference(pg);
            ApexPages.CurrentPage().getparameters().put(SF_ID, boss.id);
            bossCtrl=new IPM_BosscardStatusController();
            
        }
        
    }
    /*************************************************
    * @Description: Test invoke updateStatus
    * ***********************************************/
    public Static testMethod void testBosscardStatus()
    {      
        initializeData();
        Test.startTest();
        System.runAs(loginUser)
        { 
            
            bossCtrl.updateStatus();//for first time update as in progress
            List<IPM_Bosscard__c>bossLists=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
            System.AssertEquals(bossLists[0].IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_IN_PROGRESS, bosscardStatus_STR+bossLists[0].IPM_Bosscard_Status__c); //Positive test
            //for the status - Not Approved
            bossCtrl.Statusvalue=IPM_ConstantUtils.STATUS_NOT_APPROVED;
            bossCtrl.updateStatus();
            List<IPM_Bosscard__c>bossUpdateList=[SELECT IPM_Bosscard_Status__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
            System.AssertEquals(bossUpdateList[0].IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_NOT_APPROVED, bosscardStatus_STR+bossUpdateList[0].IPM_Bosscard_Status__c); //Positive test
            
        }
        Test.stopTest();
    }
     
    
     /*****************************************************
     * @Description: Test invoke updateStatus and getStatus
     * ****************************************************/
    Static testMethod void testBosscardUpdate()
    {
        
        initializeData();
        Test.startTest();
        system.runAs(loginUser)
        {
            
            bossCtrl.selectedPL =IPMUSER_LASTNAME;
            bossCtrl.filterprojectLeader();
            IPM_BosscardStatusController.createProject(boss.id,loginUser.id,BOSSFEEDBACK );
            //project should get created
            List<IPM_Project__c>projectList=[SELECT IPM_Bosscard__c FROM IPM_Project__c WHERE IPM_Bosscard__c=:boss.id LIMIT 1];
            System.AssertEquals(projectList[0].IPM_Bosscard__c,boss.id, 'project bosscard name is:'+projectList[0].IPM_Bosscard__c); //Positive test
            
            List<SelectOption>statusList=bossCtrl.getStatusValue();
            system.assertEquals(statusList.isEmpty(),false,'statusList is Empty');//positive test
            
            bossCtrl.Statusvalue=IPM_ConstantUtils.STATUS_NOT_APPROVED; 
            bossCtrl.setStatus();
            system.assertEquals(bossCtrl.bosscard.IPM_Bosscard_Status__c,IPM_ConstantUtils.STATUS_NOT_APPROVED,'Bosscard Status is:'+bossCtrl.bosscard.IPM_Bosscard_Status__c);//positive test
            
            bossCtrl.holdPLUserId();
            system.assertEquals(bossCtrl.isPLSelected_Booln,true);//positive test
            
            bossCtrl.Statusvalue=IPM_ConstantUtils.STATUS_DISCARD; 
            bossCtrl.updateStatus();
            List<IPM_Bosscard__c>bossUpdateList=[SELECT IPM_Is_Archived__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
            System.AssertEquals(bossUpdateList[0].IPM_Is_Archived__c,true, 'Bosscard archived is:'+bossUpdateList[0].IPM_Is_Archived__c); //Positive test
            
        }
        Test.stopTest();
    }
     /*****************************************************
     * @Description: Test invoke updateStatus and getStatus with read only user
     * ****************************************************/
    Static testMethod void testBosscardReadUpdate()
    {
        
        initializeData();
        Test.startTest(); 
        system.runAs(readUser)
        {
            //Negative test
            //current user does not has access to the bosscard 
            IPM_BosscardStatusController.createProject(boss.id,loginUser.id,BOSSFEEDBACK );
            bossCtrl.Statusvalue=IPM_ConstantUtils.STATUS_DISCARD; 
            bossCtrl.updateStatus();
            List<IPM_Bosscard__c>bossUpdateList=[SELECT IPM_Is_Archived__c FROM IPM_Bosscard__c WHERE ID=:boss.id LIMIT 1];
            System.AssertEquals(bossUpdateList.isEmpty(),true,'bosscard list is not empty :'+bossUpdateList); //Negative test
            
        }
        Test.stopTest();
    }
}