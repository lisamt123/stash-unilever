/**********************************************************************
Name:  CEC_LiveAgentControllerTest()
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_LiveAgentController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sreya           Jan-2016      INITIAL DEVELOPMENT   

***********************************************************************/

@isTest(SeeAllData = False)
public class CEC_LiveAgentControllerTest{

/* method to create test user*/
    public static User insertUser() {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
        User u = new User(LastName = 'Testing', 
                          Username = 'cectestuser@test00DE0000000bbLj.org', 
                          Email = 'cectestuser@test00DE0000000bbLj.org', 
                          Alias = 'utest', 
                          TimeZoneSidKey = 'Europe/London', 
                          LocaleSidKey = 'en_GB', 
                          EmailEncodingKey = 'UTF-8', 
                          ProfileId = p.Id, 
                          LanguageLocaleKey = 'en_US',
                          UserPermissionsKnowledgeUser = true);  
        
        insert u;
        
        List<PermissionSet> pslist = [SELECT Id FROM PermissionSet WHERE Name IN ('CEC_User','CEC_Manager','CEC_CRUD','CEC_Business_Admin','CEC_Knowledge_Manager','CEC_Automated_User')];
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
    
/**
Positive test for fetchRecords method
**/  
    public static testMethod void test_fetchrecords_positive(){
        User u = insertUser();
        System.runAs(u){
                        
            CEC_LiveAgentController ControllerObj = new CEC_LiveAgentController();                    
            ControllerObj.chatKey = 'TestKey';
            ControllerObj.surveyId = 'ThisIsUnitTestMethodRunning';
            
            Test.startTest();
                PageReference reference = ControllerObj.takeSurvey();           
                String referenceURL = reference.getUrl();
     
                System.assert(referenceURL.contains('clicktools'));            
            Test.stopTest();
            
        }         
    }
    
/**
Negetive test for  fetchRecords method
**/  
    public static testMethod void test_fetchrecords_Negetive(){
        User u = insertUser();
        System.runAs(u){
                        
            CEC_LiveAgentController ControllerObj = new CEC_LiveAgentController();                    
            ControllerObj.chatKey = 'TestKey';
            ControllerObj.surveyId = '';
            
            Test.startTest();
                PageReference reference = ControllerObj.takeSurvey();
     
                System.assertEquals(null,reference);            
            Test.stopTest();
            
        }         
    }
}