/*
 * @Description to test chatter notifications class. Although its an API call but this class will dummy the creation
*/
@IsTest
public class IPM_ChatterUtilsTest {
    
    /*
    * @Description to test chatter notifications class. Although its an API call but this class will dummy the creation
    */
    @isTest static void verifyChatterUtils() {
        Test.startTest();
        IPM_Project__c projects = IPM_TestFactory_Helper.createIPMProject(FALSE);
        projects.IPM_Project_Name__c='test'+Math.random();
        projects.IPM_PM_Approach__c='External';
        projects.IPM_IsCompleted__c=true;
        projects.IPM_Fast_Track_Project__c=false;
        projects.IPM_Phase__c='Ideas';
        projects.IPM_Market_Type__c='Developing';
        projects.IPM_Complexity__c='Lite';
        projects.IPM_Target_Launch_Dates__c=System.today()+10;
        projects.IPM_Project_Leader__c=UserInfo.getUserId();
        insert projects;
        
        String postText = 'Test';
        Set<Id> userMentionIds = new Set<Id>{UserInfo.getUserId()};
        
        //Added to remove exception when recordId was passed
        IPM_ChatterUtils.postRecordFeed(UserInfo.getUserId(), postText);
        IPM_ChatterUtils.postRecordFeedWithMention(UserInfo.getUserId(), postText, userMentionIds);
        
        IPM_ChatterUtils.postUserFeedWithMention(UserInfo.getUserId(), UserInfo.getUserId(), postText);
        
        User u2 = new User();               
        u2 = IPM_TestFactory_Helper.createUser(TRUE);
       
              
        PermissionSet Fps=new PermissionSet();
        PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
        system.runAs(u2){
       
            Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1];   
            assignpermission.AssigneeId =u2.id;
            assignpermission.PermissionSetId=Fps.id;
            insert assignpermission;
        }
        IPM_CheckRecursive.runOnce();
        IPM_CheckRecursive.runOnceAgain();
        //insert projects;  
        IPM_Project_Resource__c pResource= IPM_TestFactory_Helper.createIPMProjectResource(projects.Id,FALSE);
        pResource.IPM_Role_Type__c='Supply Chain';
        pResource.IPM_User__c = assignpermission.AssigneeId ;
        insert pResource;
        
        pResource.IPM_Project__c=projects.Id;
        pResource.IPM_Role_Type__c='Finance';
        pResource.IPM_User__c = assignpermission.AssigneeId ;
        update pResource;
        
        delete pResource;
        undelete pResource;
        Test.stopTest();
        system.assertEquals(1, [SELECT COUNT() FROM IPM_Project__c WHERE IPM_Target_Launch_Dates__c = :System.today()+10 LIMIT 1], 'Check tht project is created.');
        system.assertEquals(1, [SELECT COUNT() FROM IPM_Project_Resource__c WHERE IPM_Project__c = :projects.Id LIMIT 1], 'Check tht PR is created.');
    }
}