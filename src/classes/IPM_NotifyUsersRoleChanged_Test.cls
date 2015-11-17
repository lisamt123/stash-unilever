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
    private static final String PROJECTRESOURCE_INSERTED_ASSERTION = 'Project Resources Inserted';
    private static User platformUser;
    /*  Description: create admin user
        @param ProfileName: profile name 
    */
    private static User getUser(String ProfileName){
        Profile p=[Select Id from Profile where Name =: ProfileName];
        User user = IPM_TestFactory_Helper.createUser(false); 
        user.ProfileId = p.Id;
        insert user;
        return user;
        
    }
    
    /*  Description: create user with different roles and email addresses
        @param : null
        @param : returns list of users
    */
    private static list<User> createUserWithRole(){
        
        List<User> userWithRoleList = new  List<User>(); 
        list<String> roleSet =  new list<String>{IPM_ConstantUtils.TEAM_PROJECT_LEADER,IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER,IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER,IPM_ConstantUtils.IPM_ROLE_FINANCE,
                                                IPM_ConstantUtils.IPM_ROLE_BD,IPM_ConstantUtils.IPM_ROLE_CD,IPM_ConstantUtils.IPM_ROLE_CMI};
        for(integer i=0 ;i<7 ;i++){
            User newUser = IPM_TestFactory_Helper.createUser(false); 
            newUser.Email='standarduser'+i+'@testorg.com';
            newUser.IPM_Role__c = roleSet[i];
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
        
        map<string,User> userRoleMap = new map<string,User>();
        for(User userRole : userList){
            userRoleMap.put(userRole.IPM_Role__c,userRole);
        }
        
        //Create platform user
        System.runAs(IPM_TestFactory_Helper.createUserAdmin(true)){
            platformUser = IPM_TestFactory_Helper.createIPMPlatformProfileUser(IPM_ConstantUtils.BLANK);
        }
        //Insert test data as platform user's context
        System.runAs(platformUser){
                //create company card required for creation of project
                ipmCompanyCard = IPM_TestFactory_Helper.createIPMCompanyCard(false);
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
                    project.IPM_Project_Leader__c = userRoleMap.get(IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER).id;
                    project.Deputy_Project_Leader__c = userRoleMap.get(IPM_ConstantUtils.TEAM_PROJECT_LEADER).id;
                    project.IPM_Technical_Project_Leader__c = userRoleMap.get(IPM_ConstantUtils.TEAM_TECHNICAL_PROJECT_LEADER).id;
                    project.IPM_Project_Gatekeeper__c = userRoleMap.get(IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER).id;
                    
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
                    
                    ipmProjRescourceList[resourceCount ].IPM_Role_Type__c = userList[resourceCount+3].IPM_Role__c;
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