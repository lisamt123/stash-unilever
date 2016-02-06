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
Test method for  fetchRecords method
**/  
    public static testMethod void test_fetchrecords(){
        
        User u = insertUser();
        System.runAs(u){
            /***** CREATING TEST DATA *****/
            
            //Create Account
            
            Account accountObj = new Account();
            accountObj.RecordTypeId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
            accountObj.PersonMailingCity = 'Mumbai';
            accountObj.PersonMailingPostalCode = '560023';
            accountObj.LastName = 'TestAccount';        
            insert accountObj;
            
            Case caseObj = new Case();
            caseObj .Status = 'New';
            caseObj .Origin = 'Email';
            caseObj.AccountID =  accountObj.id;
            insert caseObj;         
                        
            CEC_LiveAgentController ControllerObj = new CEC_LiveAgentController();            
            ControllerObj.newcase = caseObj;            
            ControllerObj.caseId = caseObj.id;            
            ControllerObj.chatKey = 'TestKey';
            
            Test.startTest();
                PageReference reference = ControllerObj.takeSurvey();           
                String referenceURL = reference.getUrl(); 
     
                System.assert(referenceURL.contains('clicktools'));            
            Test.stopTest();
            
        }         
    }
}