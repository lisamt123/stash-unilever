/**
   @Author: Cognizant
   @name : IPM_NotifyUsersRoleChanged_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_NotifyUsersRoleChanged
   @Version <1.0>
   @reference 
  */
  
@isTest
public class IPM_NotifyUsersRoleChanged_Test {

    private static List<User> userList;
    private static List<IPM_Project__c> lstProjects;
    private static IPM_Project__c project;
    private static IPM_Company_Card__c ipmCompanyCard;
    public static List<IPM_Project_Resource__c> ipmProjRescourceList;
    
    private static final String  FEED_UPDATED_ASSERT = 'Feed Updated';
    private static final String PROJECTNAME = 'Acme';
    private static final String PROJECT_INSERTED_ASSERTION = 'Projects Inserted';
    private static User platformUser;
    private static List<User> userWithRoleList;
    
    /*  Description: create user with different roles and email addresses
        @param : null
        @param : returns list of users
    */
    private static list<User> createUserWithRole(){
        
        userWithRoleList = new  List<User>(); 
        for(integer i=0 ;i<7 ;i++){
            User newUser = IPM_TestFactory_Helper.createUser(false); 
            newUser.Email='standarduser'+i+'@testorg.com';
            userWithRoleList.add(newUser); 
        }
        return userWithRoleList;
    }
    
    /*  Description: create projects and its associated project resources
        @param : null
        @param : null
    */
    private static void initializeData(){
        
        // create users with different roles
        userList = createUserWithRole();   
        insert userList;
        
        //Create platform user
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }
        //Insert test data as platform user's context
        System.runAs(platformUser){
                //create company card required for creation of project
                ipmCompanyCard = IPM_TestFactory_Helper.createGlobalCompanyCard(false);
                ipmCompanyCard.IPM_Business_Partner__c = UserInfo.getUserId();
                insert ipmCompanyCard;
                
                //insert projects in bulk
                lstProjects = new List<IPM_Project__c>();
                for(Integer i=1; i<=5; i++){
                    project = IPM_TestFactory_Helper.createIPMProject(false);
                    project.name = PROJECTNAME+i;
                    project.IPM_Project_Name__c = PROJECTNAME+i;
                    project.IPM_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;    
                    project.IPM_Temporary_Phase__c = IPM_ConstantUtils.PHASE_IDEAS;     
                    project.IPM_Complexity__c = IPM_ConstantUtils.COMPLEXITY_FULL;
                    project.IPM_GateKeeping_Model__c = IPM_ConstantUtils.GATEKEEPING_MODEL_BOTH;
                    project.IPM_Project_Leader__c = userWithRoleList[0].id;
                    project.Deputy_Project_Leader__c = userWithRoleList[1].id;
                    project.IPM_Technical_Project_Leader__c = userWithRoleList[2].id;
                    project.IPM_Project_Gatekeeper__c = userWithRoleList[3].id;
                    
                    project.IPM_Company_Card__c = ipmCompanyCard.id;
                    lstProjects.add(project);
                }
                insert lstProjects;
                System.assertEquals(5, lstProjects.size(),PROJECT_INSERTED_ASSERTION);
        } 
    }

    /*  Description: test method to test senarioes of notifyIfUserRoleChanged method
        @param : null
        @param : null
    */
    private static testmethod void testResourceRoleChanged(){
        
            List<Id> userListToUpdate = new List<Id>();
            initializeData();
            //Bulk insert of project resources
            ipmProjRescourceList= IPM_TestFactory_Helper.createIPMProjectResourceList(false, 3); 
            
            for(Integer resourceCount = 0; resourceCount < ipmProjRescourceList.size(); resourceCount++){
                for(Integer prjCount = 0; prjCount < lstProjects.size(); prjCount++){
                    
                    ipmProjRescourceList[resourceCount ].IPM_User__c =userList[resourceCount+3].Id;
                    ipmProjRescourceList[resourceCount ].IPM_Project__c = lstProjects[prjCount].Id;
                    
                }
            }
             insert ipmProjRescourceList;   
             
            //In the context of paltform user, change department of the team member and assert the results
            System.runAs(platformUser) {
            test.startTest();
                for(User user : userList)
                {
                    user.Department = 'Acme Department';
                    userListToUpdate.add(user.Id);
                 }
            IPM_NotifyUsersRoleChanged.notifyIfUserRoleChanged(userListToUpdate);
            test.stopTest();
            
            Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 1000]);
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
                System.assert(projectFeed.Body.contains(System.Label.IPM_Not_Performing_Same_role),FEED_UPDATED_ASSERT);
            }
        }
   }
   
}