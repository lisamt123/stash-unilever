/**
   @Author: Cognizant
   @name : IPM_NotifyUsersRoleChanged_Test
   @CreateDate : 10/01/2015
   @Description : Test class for IPM_NotifyUsersRoleChanged
   @Version <1.0>
   @reference 
  */
  
@isTest
private class IPM_NotifyUsersRoleChanged_Test {

    private static List<User> userList;
    private static List<IPM_Project__c> lstProjects;
    private static IPM_Project__c project;
    private static IPM_Company_Card__c ipmCompanyCard;
    private static List<IPM_Project_Resource__c> ipmProjRescourceList;
    
    private static final String  FEED_UPDATED_ASSERT = 'Feed Not Updated';
    private static final String PROJECTNAME = 'Acme';
    private static final String PROJECT_NOT_INSERTED = 'Projects not Inserted';
    private static final String PROJECTRESOURCE_NOT_INSERTED_ASSERTION = 'Project Resources not Inserted';
    private static final String COMPANY_CARD_NOT_INSERTED='Company Cards are not inserted';
    private static User platformUser;
    private static List<User> userWithRoleList;
    private static Set<Id> iDs;
    
    /*  Description: create user with different roles and email addresses
        @param : null
        @param : returns list of users
    */
    private static list<User> createUserWithRole(){
        
        userWithRoleList = new  List<User>(); 
        for(integer i=0 ;i<20 ;i++){
            User newUser = IPM_TestFactory_Helper.returnPlatformUser(); 
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
        
        iDs = new Set<Id>();
        
        // create users with different roles
        userList = createUserWithRole();   
         		
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
               
        		System.assertEquals(1, [Select count() from IPM_Company_Card__c where id= :ipmCompanyCard.id],COMPANY_CARD_NOT_INSERTED );
        
                //insert projects in bulk
                lstProjects = new List<IPM_Project__c>();
                for(Integer i=1; i<=20; i++){
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
                
                iDs.clear();
         		for(IPM_Project__c eachProj : lstProjects) {
           			iDs.add(eachProj.Id);
         		}
         		System.assertEquals(20, [Select count() from IPM_Project__c where id in:iDs],PROJECT_NOT_INSERTED);
        } 
    }

    /*  Description: test method to test senarioes of notifyIfUserRoleChanged method
        @param : null
        @param : null
    */
    private static testmethod void testResourceRoleChanged(){
        	iDs = new Set<Id>();
            List<Id> userListToUpdate = new List<Id>();
            initializeData();
             
        //Bulk insert of project resources
            ipmProjRescourceList = IPM_TestFactory_Helper.createIPMProjectResourceList(false, 20); 
            list<IPM_Project_Resource__c> projectResourceResultList =  new list<IPM_Project_Resource__c>();
            for(integer i=0;i<20;i++)
            {
                ipmProjRescourceList[i].IPM_Role_Type__c = IPM_ConstantUtils.IPM_ROLE_BD_MARKETING;
                ipmProjRescourceList[i].IPM_Project__c = lstProjects[i].Id; 
                ipmProjRescourceList[i].IPM_User__c = userList[i].Id;
                ipmProjRescourceList[i].IPM_Project_Role_Owner__c = true;
                projectResourceResultList.add(ipmProjRescourceList[i]);
            }
            insert projectResourceResultList;
             
             iDs.clear(); 
        	 for(IPM_Project_Resource__c eachResource : projectResourceResultList) {
            	iDs.add(eachResource.Id);
        	}
        	System.assertEquals(20, [Select count() from IPM_Project_Resource__c where id in:iDs],PROJECTRESOURCE_NOT_INSERTED_ASSERTION);
        	
        	Map<Id, IPM_Project__c> mapProjects = new Map<Id, IPM_Project__c>([Select Id from IPM_Project__c limit 1000]);
        	
        	//negative test, the chatter post wont be available before updating the user role
        	for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	System.assert(!projectFeed.Body.contains(System.Label.IPM_Not_Performing_Same_role),FEED_UPDATED_ASSERT);
            }
            
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
            
            for(IPM_Project__Feed projectFeed : [Select Id, Body from IPM_Project__Feed where ParentId IN : mapProjects.keySet()]){
            	//check if the chatter has been posted when the user role changes
                System.assert(projectFeed.Body.contains(System.Label.IPM_Not_Performing_Same_role),FEED_UPDATED_ASSERT);
            }
        }
   }
   
}