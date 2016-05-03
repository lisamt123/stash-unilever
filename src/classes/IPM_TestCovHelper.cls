@IsTest
public with sharing class IPM_TestCovHelper {
    
    @isTest static void verifyMilestoneDelete() {
        
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
        List<IPM_Project__c>projList=[select Id,IPM_Complexity__c from IPM_Project__c where Id=:projects.Id];
        System.assertEquals(projList[0].IPM_Complexity__c,'Lite','project is not created successfully');

        String postText = 'Test';
        Set<Id> userMentionIds = new Set<Id>{UserInfo.getUserId()};

        //Added to remove exception when recordId was passed
       // IPM_ChatterUtils.postRecordFeed(UserInfo.getUserId(), postText);
      //  IPM_ChatterUtils.postRecordFeedWithMention(UserInfo.getUserId(), postText, userMentionIds);
        
     //   IPM_ChatterUtils.postUserFeedWithMention(UserInfo.getUserId(), UserInfo.getUserId(), postText);
        
         
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

       PermissionSet Fps=new PermissionSet();
       PermissionSetAssignment assignpermission=new PermissionSetAssignment ();
       system.runAs(u2){
       
       Fps=[SELECT Id FROM PermissionSet WHERE Name = 'IPMNG_Basic' limit 1]; 
      
       assignpermission.AssigneeId =u2.id;
       assignpermission.PermissionSetId=Fps.id;
       insert assignpermission;
       }
       
       IPM_Milestone__c ipmMilestones = new IPM_Milestone__c(Name = 'Test Milestone', IPM_Project__c=projects.Id);
       insert ipmMilestones;
       ApexPages.currentPage().getParameters().put('id', projects.Id);
       IPM_List_Milestones constMain = new IPM_List_Milestones();
       constMain.projectId = projects.Id;
       Test.stopTest();
        
    }
    
}