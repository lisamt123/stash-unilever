/*************************************************************
*@Author:Cognizant
*@Date:Jan 2015
*@Description : To test IPM_UserTriggerHandler class 
*************************************************************/
@isTest
public class IPM_UserTriggerHandler_Test {
    public static IPM_Project__c project;
    private static User platformUser;
    private static final String PROJ_CREATED='Projects are created';
    private static final String USER_UPDATED='User is updated';
    
    /*************************************************************
    *@Description : To insert the test data for project object. 
    *************************************************************/
    static  void initializeData(){
        //Creation test user
        platformUser =IPM_TestFactory_Helper.returnPlatformUser();
        System.runAs(platformUser)
        {
            project=IPM_TestFactory_Helper.createIPMProject(true);
            System.assertEquals(1, [Select count() from IPM_Project__c where id =:project.id],PROJ_CREATED);
        }
    }

    /*************************************************************
    *@Description : To insert the test data for project object. 
    *************************************************************/
    static testMethod void dotest() {
        
        initializeData();
        System.runAs(platformUser)
        {
           Test.startTest();
           
           PageReference pRef = new PageReference('/apex/IPM_UserTriggerHandler?id='+project.Id);
           Test.setCurrentPage(pRef);
           system.assert(pRef != null);
        
           IPM_UserTriggerHandler useTri=new IPM_UserTriggerHandler(true);
           User[] newUsers= new List<User>();
           newUsers.add(platformUser);
         
           Map<Id, User> oldUsersMap=new Map<Id, User>();
           oldUsersMap.put(platformUser.id, platformUser);
        
           User[] oldUsers= new List<User>();
           oldUsers.add(platformUser);
        
           useTri.OnAfterUpdate(newUsers,oldUsersMap);
           system.assertEquals(1,[Select count() from User where id =:platformUser.id],USER_UPDATED);
        
           useTri.OnAfterDelete(oldUsers);
           system.assertEquals(1,[Select count() from User where id =:platformUser.id], 'User Is Deleted');
           Test.stopTest();
        }
    }
}