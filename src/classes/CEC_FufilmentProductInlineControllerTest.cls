/**********************************************************************
Name:  CEC_FufilmentProductInlineControllerTest
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: This class is a test class for CEC_FufilmentProductInlineController
Class.

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR                        DATE            DETAIL                   
1.0        Masood Ahmad Ansari           April-2016      INITIAL DEVELOPMENT   

***********************************************************************/
@istest()
public class CEC_FufilmentProductInlineControllerTest {
    
    @testSetup static void setUpTestData() {
         User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
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
        }  
    }
    public static testMethod void testsaveList(){
         User u = CEC_TestDataFactory.getStandardCECTestUser();
        System.runAs(u) {
        //id caseId = [Select id From Case Limit 1].id;
        cec_Fulfilment__c fulfilment =[Select Id, Case__r.Country__r.Country__r.ISO_3166_1_Code__c,
                                       Case__r.CEC_Product__c, Case__r.CEC_Product__r.Name, isApproved__c
                                       FROM cec_Fulfilment__c LIMIT 1];
        mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
        PageReference pageRef = Page.CEC_Fulfilment_Product_Inline;
        Test.setCurrentPage(pageRef);
        ApexPages.StandardController stdController = new ApexPages.StandardController(fulfilment);
        CEC_FufilmentProductInlineController controller = new CEC_FufilmentProductInlineController(stdController);
        
        controller.productId = productObj.id;
        controller.productQuantity =1;
        test.StartTest();
        
        controller.saveList(); 
        
        test.StopTest();
        CEC_Fulfilment_Product__c fulfilmentProduct = [Select id, Fulfilment_Id__c, Product_Quantity__c FROM CEC_Fulfilment_Product__c WHERE Product__c =: productObj.id LIMIT 1 ]; 
        system.assert(fulfilmentProduct != null);
        system.assertEquals(1,fulfilmentProduct.Product_Quantity__c);
        system.assertEquals(fulfilment.id, fulfilmentProduct.Fulfilment_Id__c);
    }
    } 
}