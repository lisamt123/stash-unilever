/**
* @author Cognizant 
* @date 20/07/2015
* @description Test Class for Creating Queue for project sharing
 */
@isTest
private class IPM_GroupManagement_Test
 {
    private static List<User> userList = new  List<User>();
    private static IPM_Project__c project;
    private static IPM_Project__c projectchild;
    private static User projectLeader;
    private static User projectResource1;
    private static User projectResource2;
    private static User projectResource3;
    private static User projectResource4;
    private static User projectResource5;
    private static List<IPM_Project__c> listProject=new List<IPM_Project__c>();
    private static string plName='Project leader name is:';
    private static string projectSusP='Project sustainability period is:';
    private static string pTLD='Project target launch date is:';
    private static string userAccess='User should have edit access to ipm project';
    private static string dPLName='Deputy Project leader name is:';
    private static string susPeriod='3';
    private static string standardUser='Standard User';
    /*************************************************************************************************************************
    * @description Test Data
    */ 
    static void createTestData() {
        user projectLeaderUser=IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.PROJECT_LEADER);
        List<User>userPlList=[SELECT lastName FROM user WHERE id=:projectLeaderUser.id LIMIT 1];
        System.AssertEquals(userPlList[0].lastName, projectLeaderUser.lastName,'user LastName is:'+userPlList[0].lastName);//positive test
        
        //get standard user profile
        Profile p = [SELECT Id FROM Profile WHERE Name=:standardUser limit 3]; 
        //insert users
        projectLeader = IPM_TestFactory_Helper.createUser(false);
        projectLeader.ProfileId = p.id;                           
        
        projectResource1 =IPM_TestFactory_Helper.createUser(false);
        projectResource1.ProfileId = p.id;
        
        projectResource2 = IPM_TestFactory_Helper.createUser(false);
        projectResource2.ProfileId = p.id;      
                                 
        projectResource3 = IPM_TestFactory_Helper.createUser(false);
        projectResource3.ProfileId = p.id;
        
        projectResource4 = IPM_TestFactory_Helper.createUser(false);                                                  
        projectResource4.ProfileId = p.id;
        projectResource5 = IPM_TestFactory_Helper.createUser(false);                                                  
        projectResource5.ProfileId = p.id;
        
        userList.add(projectLeader);//add to user list
        userList.add(projectResource1);
        userList.add(projectResource2);
        userList.add(projectResource3);
        userList.add(projectResource4);
        userList.add(projectResource5);
        insert userList;//insert users
        List<User>lstUser=[SELECT ProfileId FROM USER WHERE ProfileId=:p.id];
        system.assertEquals(lstUser[0].ProfileId,p.id,'User profile id is:'+lstUser[0].ProfileId);//positive test
    
        system.RunAs(projectLeaderUser){
            
            project = IPM_TestFactory_Helper.createIPMProject(False); 
            project.Sustainability_Period__c=susPeriod;
            project.IPM_Target_Launch_Dates__c=system.today();
            project.IPM_Project_Leader__c=projectResource1.id;
            project.IPM_Technical_Project_Leader__c=projectResource2.Id;
            project.Deputy_Project_Leader__c=projectResource3.Id;
            project.IPM_Project_Gatekeeper__c=projectResource4.Id;
            project.IPM_Finance_Lead__c=projectResource1.Id;
            insert project;//insert project
            listProject.add(project);//add project to list for sharing
            List<IPM_Project__c>lstProject=[SELECT IPM_Project_Leader__c,Sustainability_Period__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c 
                                            WHERE id=:project.id LIMIT 1];
            system.assertEquals(lstProject[0].IPM_Project_Leader__c, projectResource1.id,plName +lstProject[0].IPM_Project_Leader__c);//positive test
            system.assertEquals(lstProject[0].Sustainability_Period__c, susPeriod,projectSusP+lstProject[0].Sustainability_Period__c);//positive test
            system.assertEquals(lstProject[0].IPM_Target_Launch_Dates__c, system.today(),pTLD+lstProject[0].IPM_Target_Launch_Dates__c);//positive test
            
            projectchild = IPM_TestFactory_Helper.createIPMProject(False); 
            projectchild.Sustainability_Period__c=susPeriod;
            projectchild.IPM_Target_Launch_Dates__c=system.today();
            projectchild.IPM_Parent_Project__c=project.id;
            projectchild.IPM_Project_Leader__c=projectResource1.id;
            insert projectchild;//insert child project
            listProject.add(projectchild);//add project to list for sharing
            List<IPM_Project__c>lstChildProject=[SELECT IPM_Parent_Project__c,Sustainability_Period__c,IPM_Target_Launch_Dates__c FROM IPM_Project__c 
                                            WHERE id=:projectchild.id LIMIT 1];
            system.assertEquals(lstChildProject[0].IPM_Parent_Project__c, project.id,plName +lstChildProject[0].IPM_Parent_Project__c);//positive test
            system.assertEquals(lstChildProject[0].Sustainability_Period__c, susPeriod,projectSusP+lstChildProject[0].Sustainability_Period__c);//positive test
            system.assertEquals(lstChildProject[0].IPM_Target_Launch_Dates__c, system.today(),pTLD+lstChildProject[0].IPM_Target_Launch_Dates__c);//positive test
            List<ipm_project__share> listProjectShare=IPM_TestFactory_Helper.shareIPMProject(listProject,userList);
            insert listProjectShare;//insert project share access records
            list<ipm_project__share>listSharedProject=[SELECT ParentId,UserOrGroupId FROM ipm_project__share WHERE ParentId=:projectchild.id AND UserOrGroupId=:projectResource1.id LIMIT 1];
            system.assertEquals(listSharedProject[0].UserOrGroupId,projectResource1.id,projectResource1.id+userAccess);//positive test
        }
         
    }
    
    /**************************************************************
    *@Description :testmethod to test dotest method  
    */
    static testMethod void updateChildProjectTest(){
        createTestData();
        system.RunAs(projectResource1){
            Test.startTest();
            projectchild.Deputy_Project_Leader__c=projectResource5.Id;
            update projectchild;
            List<IPM_Project__c>lstProject=[SELECT Deputy_Project_Leader__c FROM  IPM_Project__c 
                                        WHERE id=:projectchild.id AND Deputy_Project_Leader__c=:projectResource5.Id LIMIT 1];
            system.assertEquals(lstProject[0].Deputy_Project_Leader__c , projectResource5.Id,dPLName+lstProject[0].Deputy_Project_Leader__c );
            Test.stopTest();        
        }       
   } 
}