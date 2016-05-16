/**********************************************************************
Name:  CEC_RetrievalRequestTriggerHelperTest
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: Test class for CEC_RetrievalRequestTriggerHelper

========================================================================
========================================================================
History
-------
VERSION    AUTHOR            DATE            DETAIL
1.0      Goverdhan S.       Apr-2016      INITIAL DEVELOPMENT

***********************************************************************/
@istest()
public class CEC_RetrievalRequestTriggerHelperTest {
	
	@testSetup static void setUpTestData() {
		List<mdm_Product_Category__c> prodCategoryList = CEC_TestDataFactory.createProductCategory(1);
		insert prodCategoryList;
		
		List<mdm_Case_Product__c> caseProductList = 
			CEC_TestDataFactory.createCaseProduct(1, prodCategoryList.get(0).Id);
		insert caseProductList;
		
		List<mdm_Global_Listening_Tree__c> globalListeningTreeList = 
			CEC_TestDataFactory.createGlobalListeningTree(1);
		insert globalListeningTreeList;
		
		List<mdm_Reason_Code__c> reasonCodeList = 
			CEC_TestDataFactory.createReasonCode(1, globalListeningTreeList.get(0).Id);
		insert reasonCodeList;
		
		List<CEC_Case_Market_Mapping__c> cmmList = CEC_TestDataFactory.createMasterCaseMarketMapping();
		CEC_Case_Market_Mapping__c cmmBrazil;
		for(CEC_Case_Market_Mapping__c cmm : cmmList) {
			if (cmm.Market__c == 'Brazil') {
				cmmBrazil = cmm;
				break;
			}
		}
		
		List<Account> accountList = CEC_TestDataFactory.createTestAccounts(1, 'TestAccount', null, null, null, 
																		   'Rio', 'Brazil', null);
		insert accountList;
		
		List<Case> caseList = CEC_TestDataFactory.createTestCases(1, 'New', 'Email', 'L1234', '1234',
																  caseProductList.get(0).Id, reasonCodeList.get(0).Id, 
																  accountList[0].Id, cmmBrazil.Id, false);
		for (Case caseObj : caseList) {
			caseObj.Case_product_category__c='IceCream';
			caseObj.Brand__c = 'Knorr';
		}
		insert caseList;
		
		List<cec_Fulfilment__c> fulfilmentList = CEC_TestDataFactory.createFulfilment(1, 'Brazil', null, null, null, null, null, caseList[0].Id);
		insert fulfilmentList;            
			
		cec_Org_Settings__c   orgsetting = new cec_Org_Settings__c(Debit_Card_Expiry_Days__c = 15,  E_Voucher_Expiry_Days__c = 15, Brazil_Factory_Response_Email_Id__c = 'unit@test.in');
		insert orgsetting;
        
        List<CEC_Factory_Details__c> factoryList = new List<CEC_Factory_Details__c>();
		CEC_Factory_Details__c textileFactory = New CEC_Factory_Details__c(Name = 'testTextileFactory', Email__c = 'unittest1@test.in', Type__c = 'Textile', Country__c = cmmBrazil.Id);
        CEC_Factory_Details__c productFactory = New CEC_Factory_Details__c(Name = 'testProductFactory', Email__c = 'unittest2@test.in', Type__c = 'Product', Country__c = cmmBrazil.Id);
        factoryList.add(textileFactory);
        factoryList.add(productFactory);
        insert factoryList;
		        
    }
    
    public static testMethod void testNoFactory(){
        CEC_Retrieval_Request__c retreq = new CEC_Retrieval_Request__c(Retrieval_Status__c = 'New', Retrieval_Quantity__c = 2, Case_Country_Name__c = 'Brazil');
		id caseId = [Select id From Case Limit 1].id;
		retreq.Case__c = caseId;
		insert retreq;
        
		test.StartTest();
            retreq.Retrieval_Status__c = 'Retrieval Complete';
        	update retreq;
        test.StopTest();
        CEC_Retrieval_Request__c AssertRR = [Select id, Retrieval_Status__c From CEC_Retrieval_Request__c Where Id = :retreq.Id Limit 1];
        system.assertEquals('Resolved', AssertRR.Retrieval_Status__c);
    }
	
	public static testMethod void testBrazilTextileFactoryEmail(){
        List<CEC_Factory_Details__c> factoryList = [Select id, Name FROM CEC_Factory_Details__c LIMIT 2];
        id factoryId;
        for(CEC_Factory_Details__c fd :factoryList){
            if(fd.Name == 'testTextileFactory'){
                factoryId = fd.Id;
            }
        }
		CEC_Retrieval_Request__c retreq = new CEC_Retrieval_Request__c(Textile_Factory__c = factoryId, Retrieval_Status__c = 'New', Retrieval_Quantity__c = 2, Case_Country_Name__c = 'Brazil');
		id caseId = [Select id From Case Limit 1].id;
		retreq.Case__c = caseId;
		insert retreq;
        
		test.startTest();
            retreq.Retrieval_Status__c = 'Retrieval Complete';
        	update retreq;
        test.StopTest();
        CEC_Retrieval_Request__c rr = [Select Id, Textile_Factory_Email_Sent__c, Product_Factory_Email_Sent__c FROM CEC_Retrieval_Request__c WHERE Id = :retreq.Id LIMIT 1];
        system.assertEquals(True, rr.Textile_Factory_Email_Sent__c);
        system.assertEquals(False, rr.Product_Factory_Email_Sent__c);
        case assertCase = [Select id, Status From Case Limit 1];
        system.assertEquals('New', assertCase.Status);
    }
    
    
	public static testMethod void testBrazilProductFactoryEmail(){
        List<CEC_Factory_Details__c> factoryList = [Select id, Name FROM CEC_Factory_Details__c LIMIT 2];
        id factoryId;
        for(CEC_Factory_Details__c fd :factoryList){
            if(fd.Name == 'testProductFactory'){
                factoryId = fd.Id;
            }
        }
		CEC_Retrieval_Request__c retreq = new CEC_Retrieval_Request__c(Product_Factory__c = factoryId, Retrieval_Status__c = 'New', Retrieval_Quantity__c = 2, Case_Country_Name__c = 'Brazil');
		id caseId = [Select id From Case Limit 1].id;
		retreq.Case__c = caseId;
		insert retreq;
        
		test.startTest();
            retreq.Retrieval_Status__c = 'Retrieval Complete';
        	update retreq;
        test.StopTest();     
        CEC_Retrieval_Request__c rr = [Select Id, Textile_Factory_Email_Sent__c, Product_Factory_Email_Sent__c FROM CEC_Retrieval_Request__c WHERE Id = :retreq.Id LIMIT 1];
        system.assertEquals(False, rr.Textile_Factory_Email_Sent__c);
        system.assertEquals(True, rr.Product_Factory_Email_Sent__c);
        case assertCase = [Select id, Status From Case Limit 1];
        system.assertEquals('New', assertCase.Status);
    }
	
}