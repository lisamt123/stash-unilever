/**********************************************************************
Name:  CEC_CaseTriggerHelperExtenTest
Copyright ? 2016  Unilever
======================================================================
======================================================================
Purpose:  Test class for CEC_CaseTriggerHelperExtension                                
======================================================================
======================================================================
History                                                            
-------                                                            
VERSION  AUTHOR       DATE             DETAIL                  Description
1.0 -    Mahesh       01/08/2016       INITIAL DEVELOPMENT      Test class for CEC_CaseTriggerHelperExtension
****************************************************************************/
@isTest
public class CEC_CaseTriggerHelperExtTest {

    Private static final string brand = 'Knorr';
    Private static final string country = 'United Kingdom';
    
    @testSetup static void setUpTestData() {
        
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        u.Market__c = country ;
        update u;
        Id recTypeId =[Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id; 
         
        System.runAs(u) {
            
            List<mdm_Global_Listening_Tree__c> globalListeningTreeList = 
                CEC_TestDataFactory.createGlobalListeningTree(1);
            insert globalListeningTreeList;
            
            List<mdm_Reason_Code__c> reasonCodeList = 
                CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
            insert reasonCodeList;
            
            List<Account> accounts = CEC_TestDataFactory.createTestAccounts(1,'Smith','smith@gmail.com','23 Cathedral Road','3452','London','United Kingdom','Frequent');
            
            for(Account acct : accounts ){
                acct.PersonMobilePhone = '9839239823';
                acct.RecordTypeId = recTypeId;
            }
            
            insert accounts;
            
            List<Contact> conts = [SELECT Id FROM Contact limit 1];
            
            List<CEC_Case_Market_Mapping__c> cmmList = CEC_TestDataFactory.createMasterCaseMarketMapping(); 
            
            update cmmList;
            
            cec_Org_Settings__c orgSetting = new cec_Org_Settings__c(UpdateAccountOnSMSCase__c=true);
            insert orgSetting;
            
        }
    }
    
     static testMethod void testInsCaseUpdtOwner(){
        
        User u = [SELECT Id FROM User WHERE email ='cectestuser@test00DE0000000bbLj.org' Limit 1];
        
         System.runAs(u) {
            
                CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                    WHERE Market__c = :country LIMIT 1];
                cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c= cmmUK.id,Brand__c=brand ,Inbound_Email__c='unitedkingdom.knorr@unilever.com',Skill__c='Coffee & Snacks');
                insert cbm;
                
                
                Case newcase= new Case();
                newcase.SuppliedEmail='test@abc.com';
                newcase.SuppliedName=CEC_Constants.suppliedName;
                newcase.Status=CEC_Constants.caseStatus;
                newcase.Origin='Web';  
                newcase.Brand__c = brand;
                newcase.Country__c = cmmUK.id;
                newcase.Social_Media_External_Id__c= 'unitedkingdom.knorr';
                
                Test.startTest();
                    
                    insert newcase;
             
                    System.assertEquals('unitedkingdom.knorr@unilever.com', [SELECT Transient_External_Id__c FROM Case WHERE Id =:newcase.Id].Transient_External_Id__c);
                    System.assertEquals(cbm.Id, [SELECT Case_Brand_Mapping__c FROM Case WHERE Id =:newcase.Id].Case_Brand_Mapping__c);  
             Test.stopTest();
             
         }
        
    }
    
    static testMethod void testUpdateCaseOwner(){
        
        User u = [SELECT Id FROM User WHERE email ='cectestuser@test00DE0000000bbLj.org' Limit 1];
         System.runAs(u) {
            
                CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                    WHERE Market__c = :country  LIMIT 1];
                cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c= cmmUK.id,Brand__c=brand,Inbound_Email__c='unitedkingdom.knorr@unilever.com',Skill__c='Coffee & Snacks');
                insert cbm;
                
                
                Case newcase= new Case();
                newcase.SuppliedEmail='test@abc.com';
                newcase.SuppliedName=CEC_Constants.suppliedName;
                newcase.Status=CEC_Constants.caseStatus;
                newcase.Origin='Web';  
                newcase.Brand__c = brand;
                newcase.Country__c = cmmUK.id;
               
                insert newcase;
                
                Test.startTest();
                    newcase.Social_Media_External_Id__c= 'unitedkingdom.knorr';
                    update newcase;
             
                    System.assertEquals('unitedkingdom.knorr@unilever.com', [SELECT Transient_External_Id__c FROM Case WHERE Id =:newcase.Id].Transient_External_Id__c);
                    System.assertEquals(cbm.Id, [SELECT Case_Brand_Mapping__c FROM Case WHERE Id =:newcase.Id].Case_Brand_Mapping__c);  
             Test.stopTest();
             
         }
        
    }
    
     static testMethod void testInstCaseAcctCont(){
        
        User u = [SELECT Id FROM User WHERE email ='cectestuser@test00DE0000000bbLj.org' Limit 1];
         System.runAs(u) {
            
                CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                    WHERE Market__c = :country  LIMIT 1];
                                                    
                cmmUK.Consumer_Phone_Search_Digits__c = 6;
                update cmmUK;
                
                cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c= cmmUK.id,Brand__c=brand,Inbound_Email__c='3456464748@unilever.com',Skill__c='Coffee & Snacks');
                insert cbm;
                
             	List<Contact> conts = [SELECT Id FROM Contact limit 1];
                List<Account> accts = [SELECT Id,PersonContactId,Owner.Market__c,Mobile_Phone_No_Special_Char__c,SMS_Search_Mobile_Number__c  FROM Account Limit 1];
               
                System.debug('@@@Accounts@@@'+ accts [0]);
                 
                List<Case> cases = new List<Case>();
                
                for(Integer i=0; i < 2; i++){
                
                    Case newcase= new Case();
                    newcase.SMS_Mobile_Number__c ='983923982'+i;
                    newcase.SuppliedName=CEC_Constants.suppliedName;
                    newcase.Status=CEC_Constants.caseStatus;
                    newcase.Origin='SMS / text Messages';  
                    newcase.Brand__c = brand;
                    newcase.Country__c = cmmUK.id;
                    newcase.SMS_Inbound_Number__c = '3456464748';
                    
                    cases.add(newcase);
                }
                
                Test.startTest();
                    
                    insert cases;
             
                    System.assertEquals('3456464748@unilever.com', [SELECT Transient_External_Id__c FROM Case WHERE Id =:cases[0].Id].Transient_External_Id__c);
                    System.assertEquals(cbm.Id, [SELECT Case_Brand_Mapping__c FROM Case WHERE Id =:cases[0].Id].Case_Brand_Mapping__c);
                      
             Test.stopTest();
             
         }
        
    }
    
     static testMethod void testUpdateCaseAcctCont(){
        
        User u = [SELECT Id FROM User WHERE email ='cectestuser@test00DE0000000bbLj.org' Limit 1];
         System.runAs(u) {
            
                CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                    WHERE Market__c = :country LIMIT 1];
                cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c= cmmUK.id,Brand__c=brand ,Inbound_Email__c='3456464748@unilever.com',Skill__c='Coffee & Snacks');
                insert cbm;
             
                List<Contact> conts = [SELECT Id FROM Contact ];
                List<Account> accts = [SELECT Id,PersonContactId,Owner.Market__c,Mobile_Phone_No_Special_Char__c,SMS_Search_Mobile_Number__c  FROM Account limit 1];
                
             
                System.debug('@@@Accounts@@@'+ accts [0]);
                System.debug('@@@Owner.Market__c@@@'+ accts [0].Owner.Market__c);
                
                List<Case> cases = new List<Case>();
                
                for(Integer i=0; i < 2; i++){
                
                    Case newcase= new Case();
                    newcase.SMS_Mobile_Number__c ='9839239823';
                    newcase.SuppliedName=CEC_Constants.suppliedName;
                    newcase.Status=CEC_Constants.caseStatus;
                    newcase.Origin='SMS / text Messages';  
                    newcase.Brand__c = brand;
                    newcase.Country__c = cmmUK.id;
                    
                    cases.add(newcase);
                }
                
                insert cases;
                
                Test.startTest();
                    for(Case cse : cases){
                        cse.SMS_Inbound_Number__c = '3456464748';
                    }
                    
                    update cases;
             
                    System.assertEquals('3456464748@unilever.com', [SELECT Transient_External_Id__c FROM Case WHERE Id =:cases[0].Id].Transient_External_Id__c);
                    System.assertEquals(cbm.Id, [SELECT Case_Brand_Mapping__c FROM Case WHERE Id =:cases[0].Id].Case_Brand_Mapping__c);  
             Test.stopTest();
             
         }
        
    }
    
    static testMethod void testCheckDuplicateAcct(){
        
        User u = [SELECT Id,Market__c FROM User WHERE email ='cectestuser@test00DE0000000bbLj.org' Limit 1];
         System.runAs(u) {
            	
             	cec_Org_Settings__c.getOrgDefaults();
                CEC_Case_Market_Mapping__c cmmUK = [SELECT Id,Market__c FROM CEC_Case_Market_Mapping__c 
                                                    WHERE Market__c = :country LIMIT 1];
                cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c= cmmUK.id,Brand__c=brand ,Inbound_Email__c='3456464748@unilever.com',Skill__c='Coffee & Snacks');
                insert cbm;
             
               Id recTypeId =[Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
             
               List<Account> accounts = CEC_TestDataFactory.createTestAccounts(1,'Smith','smith@gmail.com','23 Cathedral Road','3452','London','United Kingdom','Frequent');
            	
             	for(Account acct : accounts ){
                    acct.PersonMobilePhone = '9839239823';
                    acct.RecordTypeId = recTypeId;
            	}
            
            	insert accounts;
             
                List<Account> accts = [SELECT Id,PersonContactId,Owner.Market__c,Mobile_Phone_No_Special_Char__c,SMS_Search_Mobile_Number__c  FROM Account];
                List<Contact> conts = [SELECT Id FROM Contact WHERE Id =: accts[0].PersonContactId];
             
                System.debug('@@@Accounts@@@'+ accts [0]);
                System.debug('@@@Owner.Market__c@@@'+ accts [0].Owner.Market__c);
             	System.debug('@@@PersonContactId@@@'+ accts [0].PersonContactId);
             
             	System.debug('@@@Accounts@@@'+ accts [1]);
                System.debug('@@@Owner.Market__c@@@'+ accts [1].Owner.Market__c);
             	System.debug('@@@PersonContactId@@@'+ accts [1].PersonContactId);
                
                List<Case> cases = new List<Case>();
                
                for(Integer i=0; i < 2; i++){
                
                    Case newcase= new Case();
                    newcase.SMS_Mobile_Number__c ='9839239823';
                    newcase.SuppliedName=CEC_Constants.suppliedName;
                    newcase.Status=CEC_Constants.caseStatus;
                    newcase.Origin='SMS / text Messages';  
                    newcase.Brand__c = brand;
                    newcase.Country__c = cmmUK.id;
                    newcase.SMS_Inbound_Number__c = '3456464748';
                    cases.add(newcase);
                }
                
                
                
                Test.startTest();
                                        
                    insert cases;
             
                    System.assertEquals('3456464748@unilever.com', [SELECT Transient_External_Id__c FROM Case WHERE Id =:cases[0].Id].Transient_External_Id__c);
                    System.assertEquals(cbm.Id, [SELECT Case_Brand_Mapping__c FROM Case WHERE Id =:cases[0].Id].Case_Brand_Mapping__c);  
             Test.stopTest();
             
         }
        
    }
    
}