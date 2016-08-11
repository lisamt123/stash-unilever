/**********************************************************************
Name:  CEC_CaseInlineControllerTest()
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the Test class for CEC_CaseInlineController Apex class                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0       Koti           Jan-2015      INITIAL DEVELOPMENT   
1.1       Sathish           MAR-2016        Code Refactoring.
***********************************************************************/

@isTest(SeeAllData=false)
public class CEC_CaseInlineControllerTest{
    
    @testSetup static void setUpTestData() {
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            
            List<mdm_Product_Category__c> prodCategoryList = 
                                                CEC_TestDataFactory.createProductCategory(5);
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
            CEC_Case_Market_Mapping__c cmmUK = new CEC_Case_Market_Mapping__c();
            for(CEC_Case_Market_Mapping__c cmm : cmmList) {
                if (cmm.Market__c == 'United Kingdom') {
                    cmmUK = cmm;
                    break;
                }
            }

            List<cec_Alert_Rule__c> alertRuleList = 
                                                CEC_TestDataFactory.createAlertRule(1,'Safety','0','5','United Kingdom',
                                                                    reasonCodeList.get(0).Id,prodCategoryList.get(0).Id,
                                                                    null,false,false,false,1);
            insert alertRuleList;
            
            List<cec_Alert_Action__c> alertActionList = 
                                                CEC_TestDataFactory.createPopupAlertAction(1, 'Test Popup', 
                                                                    alertRuleList[0].Id);
            insert alertActionList;

            List<Case> caseList = CEC_TestDataFactory.createTestCases(3, 'New', 'Email', 'L1234', '1234',
                                                        caseProductList.get(0).Id, reasonCodeList.get(0).Id, 
                                                        null, cmmUK.Id, true);
            insert caseList;

            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test123@gmailxyz567.com';
            insert custsett;
        }
    }

    /**
        Test method for toggleMissingInfoDisplay method
    */  
    public static testMethod void test_toggleMissingInfoDisplay(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest(); 
            Case caseObj = [SELECT Id, Reason_Code__c FROM Case LIMIT 1];           
            mdm_Case_Product__c productObj = [SELECT Id,Product_Status__c FROM mdm_Case_Product__c LIMIT 1];
            productObj.Product_Status__c = 'Active';
            update productObj;
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];

            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.productStatus = productObj.Product_Status__c;
            caseControllerObj.toggleMissingInfoDisplay();
            System.assertEquals(true, caseControllerObj.missingInfoSectionDisplay);

            Test.stopTest(); 
        }
    }
    
    /**
Test method for updateFormAvailabilityDetails
*/
    public static testMethod void test_updateFormAvailabilityDetails(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            
            Case caseObj = new Case();
            insert caseObj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.caseRecord.isFormKnown__c = false;
            
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.productCategory = 'Food';
            caseControllerObj.updateFormAvailabilityDetails();
            
            caseObj.isFormKnown__c= true;
            caseObj.isVariantKnown__c= true;
            caseObj.isPacksizeKnown__c= true;
            stdController = new ApexPages.StandardController(caseObj);
            caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.caseRecord.isFormKnown__c = false;
            caseControllerObj.caseRecord.isVariantKnown__c= false;
            caseControllerObj.caseRecord.isPacksizeKnown__c = false;
            caseControllerObj.updateFormAvailabilityDetails();
            
            system.assertEquals(caseControllerObj.productId, productObj.Id);
        }
        Test.stopTest(); 
    }
    
    /**
Test method for updatePacksizeAvailabilityDetails
*/
    
    public static testMethod void test_updatePacksizeAvailabilityDetails(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            
            Case caseObj = new Case();
            insert caseObj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.productCategory = 'Food';
            caseControllerObj.caseRecord.isPacksizeKnown__c = false;
            caseControllerObj.updatePacksizeAvailabilityDetails();
            
            
            stdController = new ApexPages.StandardController(caseObj);
            caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.productCategory = 'Food';
            caseControllerObj.caseRecord.isPacksizeKnown__c = true;
            caseControllerObj.caseRecord.isVariantKnown__c= true;
            caseControllerObj.caseRecord.isFormKnown__c= true;
            caseControllerObj.updatePacksizeAvailabilityDetails();
            
            System.assertEquals(caseControllerObj.productId, productObj.Id);
            Test.stopTest(); 
        }
        
    }
    
    /**
Test method for updateVariantAvailabilityDetails
*/
    public static testMethod void test_updateVariantAvailabilityDetails(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            Case caseObj = new Case(Ownerid = u.id);
            insert caseObj;
           
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.productCategory = 'Food';
            caseControllerObj.caseRecord.isVariantKnown__c = false;
            caseControllerObj.updateVariantAvailabilityDetails();
            
            stdController = new ApexPages.StandardController(caseObj);
            caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            
            caseControllerObj.caseRecord.isVariantKnown__c = true;
            caseControllerObj.caseRecord.isFormKnown__c = true;
            caseControllerObj.caseRecord.isPacksizeKnown__c = true;        
            caseControllerObj.updateVariantAvailabilityDetails();
            system.assertEquals(caseControllerObj.productId, productObj.Id);
        }
        Test.stopTest(); 
    }
    
    public static testMethod void test_processProductionCode(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            Case caseObj = new Case();
            caseObj.Production_Code__c = 'L123456789023456788';
            insert caseObj;
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];

            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            
            caseControllerObj.processProductionCode();
            caseObj.Production_Code__c = 'L923456789023456788';
            stdController = new ApexPages.StandardController(caseObj);
            caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            
            caseControllerObj.processProductionCode();
            
            System.assertEquals('L923456789023456788', caseObj.Production_Code__c);
            Test.stopTest();
            
        }
         
    }
    
    
    /**
Test method for getCategoryValues method
*/
    public static testMethod void test_getCategoryValues(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            Case caseObj = new Case();
            insert caseObj;
            List<mdm_Product_Category__c> prodCategoryList = [SELECT Id FROM mdm_Product_Category__c limit 100];

            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            
            caseControllerObj.getCategoryValues();
            System.assertEquals(prodCategoryList.size()>0, true);
            Test.stopTest();
        }
         
    }
    
    /**
Test method for updateReasonHierarchy method
*/
    public static testMethod void test_updateReasonHierarchy(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.updateReasonHierarchy();
            system.assertEquals(caseControllerObj.reasonId, reasonObj.Id);
            Test.stopTest(); 
        }
        
    }
    
    /**
Test method for updateProductHierarchy method
*/
    public static testMethod void test_updateProductHierarchy(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = [SELECT Id,Product_Status__c FROM mdm_Case_Product__c LIMIT 1];
            productObj.Product_Status__c = 'Active';
            update productObj;
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.productStatus = productObj.Product_Status__c;
            caseControllerObj.updateProductHierarchy();
            system.assertEquals(caseControllerObj.productId, productObj.Id);
            Test.stopTest();
        }
         
    }
    
    /**
Test method for updateProductCategory method
*/
    public static testMethod void test_updateProductCategory(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.updateProductCategory();
            system.assertEquals(caseControllerObj.productId, productObj.Id);
            Test.stopTest();
        }
         
    }
    
    /**
Test method for searchMatchingProductKnowledgeArticles method
*/
    public static testMethod void test_searchMatchingProductKnowledgeArticles(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove', GTIN_EAN_UPC_Code__c ='12345');
            insert productObj;
            
            cec_Product_Information__kav testArticle = new cec_Product_Information__kav ();
            testArticle .Title = 'Test FAQ';
            testArticle .Summary = 'KB Summary';
            testArticle .URLName = 'test';
            testArticle .Product_Code__c ='12345';
            insert testArticle ;
            
            cec_Product_Information__kav insertedTestFaq = [SELECT KnowledgeArticleId FROM cec_Product_Information__kav 
                                                            WHERE ID = :testArticle.Id];
            
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.searchMatchingProductKnowledgeArticles();
            system.assertEquals(1,caseControllerObj.knowledgeWrapperList.size());
            Test.stopTest(); 
        }
        
    }
    
    /**
Test method for searchMatchingReasonKnowledgeArticles method
*/
    public static testMethod void test_searchMatchingReasonKnowledgeArticles(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            Case caseObj = new Case();
            insert caseObj;

            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            
            cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
            testArticle .Title = 'Test Reason';
            testArticle .Summary = 'KB Summary';
            testArticle .URLName = 'test';
            testArticle .Short_Code__c='Short Desc';
            insert testArticle ;
            
            cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
            
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.searchMatchingReasonKnowledgeArticles();
            system.assertEquals(1,caseControllerObj.knowledgeWrapperList.size());
            Test.stopTest();
        }
         
    }
    
    /**
Test method for mapArticleToCase method
*/
    public static testMethod void test_mapArticleToCase(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            List<RecordType> spamRec=[select id,Name from RecordType where name='Spam' limit 1];
            List<RecordType> noneRec=[select id,Name from RecordType where name='None' limit 1];
            Case caseObj = new Case();
            if(noneRec.size()>0)
                caseObj.recordTypeId=noneRec[0].Id;
            insert caseObj;
            
            mdm_Case_Product__c productObj = [SELECT Id FROM mdm_Case_Product__c LIMIT 1];
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.productId = productObj.Id;
            
            cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
            testArticle.Title = 'Test Reason';
            testArticle.Summary = 'KB Summary';
            testArticle.URLName = 'test';
            testArticle.Short_Code__c='Short Desc';
            insert testArticle;
            
            cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
            
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
            
            caseControllerObj.selectedArticleId = insertedTestFaq.KnowledgeArticleId;
            caseControllerObj.mapArticleToCase();
            
            Integer knCount = [SELECT COUNT() FROM CaseArticle WHERE KnowledgeArticleId = :insertedTestFaq.KnowledgeArticleId AND CaseId = :caseObj.Id];
            system.assertEquals(1,knCount);
            
            caseControllerObj.getAllRecords();
            System.assert(!caseControllerObj.displayMore);
            caseObj.RecordTypeId=spamRec[0].Id;
            caseControllerObj.caseRecord=caseObj;
            caseControllerObj.selectQuickcode();
            
            if(spamRec.size()>0){
                System.assert(caseControllerObj.caseRecord.RecordTypeId==spamRec[0].Id);
            } 
            Test.stopTest();
        }
         
    }
    /**
Test method for checkAlertAction method
*/
    
    public static testMethod void test_checkAlertAction(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            Case caseObj = [SELECT Id, Reason_Code__c FROM Case LIMIT 1];
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            mdm_Case_Product__c productObj = [SELECT Id,Product_Status__c FROM mdm_Case_Product__c LIMIT 1];
            productObj.Product_Status__c = 'Active';
            update productObj;
            mdm_Reason_Code__c reasonObj = [SELECT Id FROM mdm_Reason_Code__c LIMIT 1];

            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.productStatus = productObj.Product_Status__c;
                        
            caseObj.Reason_Code__c = reasonObj.Id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;

            caseControllerObj.checkAlertAction();
            
            System.assert(caseControllerObj.popupAlertCheck);
            Test.stopTest();
        }
        
    }
    
}