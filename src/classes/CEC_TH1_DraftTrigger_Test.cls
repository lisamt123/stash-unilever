/**********************************************************************
Name:  CEC_TH1_DraftTrigger_Test
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for CEC_DraftTrigger Trigger.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Masood           15Jan-2016      INITIAL DEVELOPMENT   

***********************************************************************/
@isTest(SeeAllData=false)
public class CEC_TH1_DraftTrigger_Test {
    
    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
        
        User u = new User(LastName = 'Testing', 
                          Username = 'cectestuser@test00DE0000000bbLj.org', 
                          Email = 'testuser@test.com', 
                          Alias = 'utest', 
                          TimeZoneSidKey = 'Europe/London', 
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8', 
                          ProfileId = p.Id, 
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);  
        
        insert u;
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User','ONE Correspond Run-time User')];
        List<PermissionSetAssignment> psalist = new List<PermissionSetAssignment>();
        for(PermissionSet ps:pslist)
        {
            PermissionSetAssignment psa = new PermissionSetAssignment();
            psa.AssigneeId = u.Id;
            psa.PermissionSetId = ps.Id;
            
            psalist.add(psa);
            
        }
        
        insert psalist;
        
        Group GR = [SELECT Id,name FROM Group WHERE Name = 'CEC - Knowledge Manager'];
        GroupMember GM = new GroupMember();
        GM.GroupId = GR.id;
        GM.UserOrGroupId = u.Id;
        insert GM;
        
        return u;
        
    }
    
    
    
    @isTest static void test_DraftTrigger() {
        // Implement test code
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u){
            
            
            TH1__Document_Setting__c documentSettings = new TH1__Document_Setting__c();
            documentSettings.Name='abc';
            documentSettings.TH1__Template_name__c='Austria_Letter';
            documentSettings.TH1__Thunderhead_channel_name__c='Print';
            insert documentSettings;
            
            TH1__Draft__c drafts= new TH1__Draft__c();
            drafts.TH1__Document_Setting__c=documentSettings.id;
            drafts.TH1__Status__c='Pending';
            insert drafts;
            
            
            try{
                drafts.TH1__Status__c='Approved';
                database.update(drafts);
                System.assertEquals( drafts.TH1__Status__c, 'Approved');
            }
            catch(exception e){
                System.debug('Added error');
            }
            
            Test.stopTest();
        }
        
        
    }
}