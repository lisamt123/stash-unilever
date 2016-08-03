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
    
	@testSetup static void setUpTestData() {
        
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            List<mdm_Global_Listening_Tree__c> globalListeningTreeList = 
                CEC_TestDataFactory.createGlobalListeningTree(1);
            insert globalListeningTreeList;
            
            List<mdm_Reason_Code__c> reasonCodeList = 
                CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
            insert reasonCodeList;
            
            List<CEC_Case_Market_Mapping__c> cmmList = CEC_TestDataFactory.createMasterCaseMarketMapping(); 
            update cmmList;
            
        }
    }
    
    static testMethod void testUpdateCaseOwner(){
        
        User u = [SELECT Id FROM User WHERE email ='cectestuser@test00DE0000000bbLj.org' Limit 1];
         System.runAs(u) {
            
                CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                    WHERE Market__c = 'United Kingdom' LIMIT 1];
                cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c= cmmUK.id,Brand__c='Knorr',Inbound_Email__c='unitedkingdom.knorr@unilever.com',Skill__c='Coffee & Snacks');
                insert cbm;
                
                
                Case newcase= new Case();
                newcase.SuppliedEmail='test@abc.com';
                newcase.SuppliedName=CEC_Constants.suppliedName;
                newcase.Status=CEC_Constants.caseStatus;
                newcase.Origin='Web';  
                newcase.Brand__c ='Knorr';
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
}