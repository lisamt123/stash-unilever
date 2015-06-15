@IsTest
public class IPM_ChatterUtilsTest {
    
    @isTest static void verifyChatterUtils() {
        Test.startTest();
        IPM_Project__c projects=new IPM_Project__c();
        //projects.Name='test'+Math.random();
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
        
       
        
        Id recordId = projects.Id;
        String postText = 'Test';
        Set<Id> userMentionIds = new Set<Id>{UserInfo.getUserId()};
        //IPM_ChatterUtils.postRecordFeed(recordId, postText);
        //IPM_ChatterUtils.postRecordFeedWithMention(recordId, postText, userMentionIds);
        
        //Added to remove exception when recordId was passed
        IPM_ChatterUtils.postRecordFeed(UserInfo.getUserId(), postText);
        IPM_ChatterUtils.postRecordFeedWithMention(UserInfo.getUserId(), postText, userMentionIds);
        
        IPM_ChatterUtils.postUserFeedWithMention(UserInfo.getUserId(), UserInfo.getUserId(), postText);
        
         
       User u2 = new User(); 
              Profile p1 = [SELECT Id FROM Profile WHERE Name='Standard User']; 


              
              u2 = new User(Alias = 'qqqppp', Email='zstandaarduseryy@testorg145.com', 
              EmailEncodingKey='UTF-8', LastName='zTestingayy1455', LanguageLocaleKey='en_US', 
              LocaleSidKey='en_US', ProfileId = p1.Id, 
              //TimeZoneSidKey='America/Los_Angeles', UserName='standarduser@testorg145.com', 
              TimeZoneSidKey='America/Los_Angeles', UserName='zxstandarduseradayyy@testqp.com', 
              IPM_Category__c = 'ztesta1'  , IPM_Brand_Positioning__c= 'zxtesta1yy',IPM_Brand_Name__c ='ztestsyy1',
              IPM_Role__c='Gate Keeper' ,IPM_Sub_Category__c='ztest1yy', isActive =true);
              insert u2;
              
       List<PermissionSetAssignment> newPermissionSetAccess = new List<PermissionSetAssignment>(); //list for new permission sets
       PermissionSet Fps=new PermissionSet();
       PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
       system.runAs(u2){
       
       Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
      
       assignpermission.AssigneeId =u2.id;
       assignpermission.PermissionSetId=Fps.id;
       insert assignpermission;
      }
        //insert projects;  
        IPM_Project_Resource__c pResource=new IPM_Project_Resource__c();
        pResource.IPM_Project__c=projects.Id;
        pResource.IPM_Role_Type__c='Supply Chain';
        pResource.IPM_User__c = assignpermission.AssigneeId ;
       // pResource.IPM_Role_Type__c='BD';
        insert pResource;
        
        pResource.IPM_Project__c=projects.Id;
        pResource.IPM_Role_Type__c='Finance';
        pResource.IPM_User__c = assignpermission.AssigneeId ;
        update pResource;
        
        delete pResource;
        undelete pResource;
        Test.stopTest();
        
    }
    
    @isTest static void verifyTasksCreation() {
        Test.startTest();
        IPM_CheckRecursive.runOnce();
        IPM_CheckRecursive.runOnceAgain();
        Test.stopTest();
        
    }
    
 /*  @isTest static void verifyChatterUtils1() {
        IPM_TestDataUtils testData = new IPM_TestDataUtils();
        
        testData.createIPMProjectResource ('BD',listIPMProjects[0]);
        IPM_Project_Resource__c pr = new IPM_Project_Resource__c();
                
        Test.startTest();
        
        pr.IPM_User__c = UserInfo.getUserId();
        update pr;
        
        delete pr;
        undelete pr;
        Test.stopTest();
    }*/
}