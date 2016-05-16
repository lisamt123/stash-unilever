/* -----------------------------------------------------------------------------------------------------------------------
   Name:        CEC_Test_IssueCreationPageController
   Description: 
                                   
   Date         Version       Author           Summary of Changes 
   -----------  -------   -----------------    ------------------------------------------------------------------------
   Oct 2014    1.0           Shruti          Initial Release 
  ------------------------------------------------------------------------------------------------------------------------ */

/**
This class acts as a test class for Issue creation controller.
*/

@isTest(SeeAllData=true)
public class CEC_Test_IssueCreationPageController{

    /**
    Test method for test_toggleMissingInfoDisplay
    */
    
    
  /*  public static testMethod void test_toggleMissingInfoDisplay(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
        insert reasonobj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        
        issueControllerObj.reasonId = reasonObj.Id;
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.toggleMissingInfoDisplay();
        
        issueControllerObj.toggleMissingInfoDisplay();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_updateFormAvailabilityDetails(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo');
        insert productObj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.caseReason.isFormKnown__c = false;
        
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.productCategory = 'Food';
        issueControllerObj.updateFormAvailabilityDetails();
        
        issueObj.isFormKnown__c= true;
        issueObj.isVariantKnown__c= true;
        issueObj.isPacksizeKnown__c= true;
        stdController = new ApexPages.StandardController(issueObj);
        issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.caseReason.isFormKnown__c = false;
        issueControllerObj.caseReason.isVariantKnown__c= false;
        issueControllerObj.caseReason.isPacksizeKnown__c = false;
        
        issueControllerObj.updateFormAvailabilityDetails();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_updatePacksizeAvailabilityDetails(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.productCategory = 'Food';
        issueControllerObj.caseReason.isPacksizeKnown__c = false;
        issueControllerObj.updatePacksizeAvailabilityDetails();
        
        stdController = new ApexPages.StandardController(issueObj);
        issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.productCategory = 'Food';
        issueControllerObj.caseReason.isPacksizeKnown__c = true;
        issueControllerObj.caseReason.isVariantKnown__c= true;
        issueControllerObj.caseReason.isFormKnown__c= true;
        issueControllerObj.updatePacksizeAvailabilityDetails();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_updateVariantAvailabilityDetails(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Product_Category__c categoryObj = new mdm_Product_Category__c(name='Test Category', Corp_Prod_Grouping_Name__c='Group1');
        insert categoryObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo');
        insert productObj;
        productObj.Global_CPG_Code__c = categoryObj.Id;
   
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.productCategory = 'Food';
        issueControllerObj.caseReason.isVariantKnown__c = false;
        issueControllerObj.updateVariantAvailabilityDetails();
        
        stdController = new ApexPages.StandardController(issueObj);
        issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.caseReason.isVariantKnown__c = true;
        issueControllerObj.caseReason.isFormKnown__c = true;
        issueControllerObj.caseReason.isPacksizeKnown__c = true;        
        issueControllerObj.updateVariantAvailabilityDetails();
        
        
        Test.stopTest(); 
    }
    
    public static testMethod void test_saveAndContinue(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
        insert reasonobj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        issueObj.case__c = caseObj.Id;
        
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.caseReason.id = issueObj.Id;
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.reasonId = reasonObj.Id;
        
        cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
        testArticle .Title = 'Test Reason';
        testArticle .Summary = 'KB Summary';
        testArticle .URLName = 'test';
        testArticle .Short_Code__c='Test Desc';
        insert testArticle ;
        
        cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
        
        KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
        
        List<CEC_IssueCreationPageController.KnowledgeArticleWrapper> wrapperList = new List<CEC_IssueCreationPageController.KnowledgeArticleWrapper>();
        CEC_IssueCreationPageController.KnowledgeArticleWrapper wrapperObj = new CEC_IssueCreationPageController.KnowledgeArticleWrapper();
        wrapperObj.reasonArticle = testArticle ;
        wrapperObj.isSelected = true;
        wrapperObj.articleType = 'Reason Information';
        wrapperObj.subject= testArticle .Title ; 
        wrapperObj.articleId= testArticle .id;                  
        wrapperList.add(wrapperObj);
        
        issueControllerObj.knowledgeWrapperList = wrapperList;
        
        issueControllerObj.saveAndContinue();
        
        Test.stopTest(); 
    }
    
     public static testMethod void test_saveAndContinue1(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.saveAndContinue();
        
        
        Test.stopTest(); 
    }
    
    public static testMethod void test_validateCloseTab(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.validateCloseTab();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_processProductionCode(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
        insert reasonobj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        
        issueObj.Production_Code__c = 'L123456789023456788';
       
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.reasonId = reasonObj.Id;
        
        issueControllerObj.processProductionCode();
        
        issueObj.Production_Code__c = 'L923456789023456788';
       
        stdController = new ApexPages.StandardController(issueObj);
        issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.productId = productObj.Id;
        issueControllerObj.reasonId = reasonObj.Id;
        
        issueControllerObj.processProductionCode();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_getCategoryValues(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj.getCategoryValues();
        
        
        Test.stopTest(); 
    }
    
    
     public static testMethod void test_updateReasonHierarchy(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason', L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
        insert reasonobj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj .productId = productObj.Id;
        issueControllerObj .reasonId = reasonObj.Id;
        issueControllerObj.updateReasonHierarchy();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_updateProductHierarchy(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
        insert reasonobj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj .productId = productObj.Id;
        issueControllerObj .reasonId = reasonObj.Id;
        issueControllerObj.updateProductHierarchy();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_updateProductCategory(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
        insert reasonobj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj .productId = productObj.Id;
        issueControllerObj .reasonId = reasonObj.Id;
        issueControllerObj.updateProductCategory();
        
        
        Test.stopTest(); 
    }
    
    
    public static testMethod void test_searchMatchingProductKnowledgeArticles(){
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
        
        cec_Product_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Product_Information__kav where ID = :testArticle.Id];
        
        KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj .productId = productObj.Id;
        issueControllerObj.searchMatchingProductKnowledgeArticles();
        
        
        Test.stopTest(); 
    }
    
    public static testMethod void test_searchMatchingReasonKnowledgeArticles(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason', L5_Short_Desc__c ='Test Desc');
        insert reasonobj;
        
        cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
        testArticle .Title = 'Test Reason';
        testArticle .Summary = 'KB Summary';
        testArticle .URLName = 'test';
        testArticle .Short_Code__c='Test Desc';
        insert testArticle ;
        
        cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
        
        KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj .reasonId = reasonObj.Id;
        issueControllerObj.searchMatchingReasonKnowledgeArticles();
        
        
        Test.stopTest(); 
    }
    
    public static testMethod void test_mapArticlesToCases(){
        Test.startTest(); 
        
        Case caseObj = new Case();
        insert caseObj;
        
        mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
        insert reasonobj;
        
        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
        insert productObj;
        
        cec_Issue__c issueObj = new cec_Issue__c();
        ApexPages.StandardController stdController = new ApexPages.StandardController(issueObj);
        CEC_IssueCreationPageController issueControllerObj = new CEC_IssueCreationPageController(stdController);
        issueControllerObj .reasonId = reasonObj.Id;
        issueControllerObj .productId = productObj .Id;
        
        cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
        testArticle .Title = 'Test Reason';
        testArticle .Summary = 'KB Summary';
        testArticle .URLName = 'test';
        testArticle .Short_Code__c='Test Desc';
        insert testArticle ;
        
        cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
        
        KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
        
        List<CEC_IssueCreationPageController.KnowledgeArticleWrapper> wrapperList = new List<CEC_IssueCreationPageController.KnowledgeArticleWrapper>();
        CEC_IssueCreationPageController.KnowledgeArticleWrapper wrapperObj = new CEC_IssueCreationPageController.KnowledgeArticleWrapper();
        wrapperObj.reasonArticle = testArticle ;
        wrapperObj.isSelected = true;
        wrapperObj.articleType = 'Reason Information';
        wrapperObj.subject= testArticle .Title ; 
        wrapperObj.articleId= testArticle .id;                  
        wrapperList.add(wrapperObj);
        
        issueControllerObj.knowledgeWrapperList = wrapperList;
        issueControllerObj.mapArticlesToCases(caseObj.Id);
        
        
        Test.stopTest(); 
    }
    
    */
    
}