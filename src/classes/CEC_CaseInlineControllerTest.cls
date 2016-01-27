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

***********************************************************************/

@isTest(SeeAllData=false)
public class CEC_CaseInlineControllerTest{
    
    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'CEC Global Head'];
        //System.debug('Role' + r.name);
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
Test method for toggleMissingInfoDisplay method
*/  
    public static testMethod void test_toggleMissingInfoDisplay(){
        Test.startTest(); 
        
        User u = insertUser();
        
        System.runAs(u)
        {
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            Case caseObj = new Case(); 
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.CEC_Product__c = productObj.id;
            insert caseObj;
            
            Case caseObj1 = new Case();
            caseObj1.Reason_Code__c = reasonObj.id;
            caseObj1.CEC_Product__c = productObj.id;
            CaseObj1.parentId = caseObj.id;
            insert caseObj1;
            
            Case caseObj2 = new Case();
            caseObj2.Reason_Code__c = reasonObj.id;
            caseObj2.CEC_Product__c = productObj.id;
            CaseObj2.parentId = caseObj.id;
            insert caseObj2;
            
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.toggleMissingInfoDisplay();
            system.assertEquals(true, caseControllerObj.missingInfoSectionDisplay);
            
            ApexPages.StandardController stdController1 = new ApexPages.StandardController(caseObj1);
            CEC_CaseInlineController caseControllerObj1 = new CEC_CaseInlineController(stdController1);
            
        }
        
        Test.stopTest(); 
    }
    
    /**
Test method for updateFormAvailabilityDetails
*/
    public static testMethod void test_updateFormAvailabilityDetails(){
        Test.startTest(); 
        
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo');
            insert productObj;
            
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
        Test.startTest(); 
        
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
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
            
            system.assertEquals(caseControllerObj.productId, productObj.Id);
        }
        Test.stopTest(); 
    }
    
    /**
Test method for updateVariantAvailabilityDetails
*/
    public static testMethod void test_updateVariantAvailabilityDetails(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            
            Case caseObj = new Case(Ownerid = u.id );
            //caseObj.Ownerid = u.id;
            insert caseObj;
            
            System.debug('~~~case inserted' + caseObj);
            System.debug('~~~case owner' + caseObj.Ownerid);
            mdm_Product_Category__c categoryObj = new mdm_Product_Category__c(name='Test Category', Corp_Prod_Grouping_Name__c='Group1');
            insert categoryObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo');
            insert productObj;
            productObj.Global_CPG_Code__c = categoryObj.Id;
            
            
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
        Test.startTest(); 
        
        User u = insertUser();
        
        System.runAs(u)
        {
            
            Case caseObj = new Case();
            caseObj.Production_Code__c = 'L123456789023456788';
            insert caseObj;
            
            System.debug('~~~case ownerp ' + caseObj.Ownerid);
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            
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
            
            system.assertEquals('L923456789023456788', caseObj.Production_Code__c);
            
        }
        Test.stopTest(); 
    }
    
    
    /**
Test method for getCategoryValues method
*/
    public static testMethod void test_getCategoryValues(){
        Test.startTest(); 
        
        User u = insertUser();
        
        System.runAs(u)
        {
            
            Case caseObj = new Case();
            insert caseObj;
            List<mdm_Product_Category__c> catogoryList = new List<mdm_Product_Category__c>();
            for(Integer i=0; i<5; i++){
                mdm_Product_Category__c categoryObj = new mdm_Product_Category__c(name='Test Category'+i, Corp_Prod_Grouping_Name__c='Group1', L2_Product_Category__c = 'L2 Category');
                catogoryList.add(categoryObj);
            }
            insert catogoryList;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            
            caseControllerObj.getCategoryValues();
            system.assertEquals(catogoryList.size()>0, true);
        }
        Test.stopTest(); 
    }
    
    /**
Test method for updateReasonHierarchy method
*/
    public static testMethod void test_updateReasonHierarchy(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason', L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.updateReasonHierarchy();
            system.assertEquals(caseControllerObj.reasonId, reasonObj.Id);
        }
        Test.stopTest(); 
    }
    
    /**
Test method for updateProductHierarchy method
*/
    public static testMethod void test_updateProductHierarchy(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.updateProductHierarchy();
            system.assertEquals(caseControllerObj.productId, productObj.Id);
        }
        Test.stopTest(); 
    }
    
    /**
Test method for updateProductCategory method
*/
    public static testMethod void test_updateProductCategory(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.updateProductCategory();
            system.assertEquals(caseControllerObj.productId, productObj.Id);
        }
        Test.stopTest(); 
    }
    
    /**
Test method for searchMatchingProductKnowledgeArticles method
*/
    public static testMethod void test_searchMatchingProductKnowledgeArticles(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove', GTIN_EAN_UPC_Code__c ='12345');
            insert productObj;
            
            cec_Product_Information__kav testArticle = new cec_Product_Information__kav ();
            testArticle .Title = 'Test FAQ';
            testArticle .Summary = 'KB Summary';
            testArticle .URLName = 'test';
            testArticle .Product_Code__c ='12345';
            //testArticle.OwnerId = u.id;
            insert testArticle ;
            
            cec_Product_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Product_Information__kav where ID = :testArticle.Id];
            
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.searchMatchingProductKnowledgeArticles();
            system.assertEquals(1,caseControllerObj.knowledgeWrapperList.size());
        }
        Test.stopTest(); 
    }
    
    /**
Test method for searchMatchingReasonKnowledgeArticles method
*/
    public static testMethod void test_searchMatchingReasonKnowledgeArticles(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            Case caseObj = new Case();
            insert caseObj;
            
            //mdm_Reason_Code__c reasonObj= [select id, name from mdm_Reason_Code__c where name = 'NEW FREEZER CLIENT' limit 1 ];
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason', L5_Short_Desc__c ='Test Desc',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
            testArticle .Title = 'Test Reason';
            testArticle .Summary = 'KB Summary';
            testArticle .URLName = 'test';
            testArticle .Short_Code__c='Test Desc';
            insert testArticle ;
            
            cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
            
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.searchMatchingReasonKnowledgeArticles();
            system.assertEquals(1,caseControllerObj.knowledgeWrapperList.size());
        }
        Test.stopTest(); 
    }
    
    /**
Test method for mapArticleToCase method
*/
    public static testMethod void test_mapArticleToCase(){
        Test.startTest(); 
        User u = insertUser();
        
        System.runAs(u)
        {
            List<RecordType> spamRec=[select id,Name from RecordType where name='Spam' limit 1];
            List<RecordType> noneRec=[select id,Name from RecordType where name='None' limit 1];
            Case caseObj = new Case();
            if(noneRec.size()>0)
                caseObj.recordTypeId=noneRec[0].Id;
            insert caseObj;
            
            //mdm_Reason_Code__c reasonObj= [select id, name from mdm_Reason_Code__c where name = 'NEW FREEZER CLIENT' limit 1 ];
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc');
            insert reasonobj;
            
            //mdm_Case_Product__c productObj = [select id, name from mdm_Case_Product__c where name = 'Dove AP Roll On Invisible 50ml' limit 1];
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.reasonId = reasonObj.Id;
            caseControllerObj.productId = productObj.Id;
            
            cec_Reason_Information__kav testArticle = new cec_Reason_Information__kav ();
            testArticle.Title = 'Test Reason';
            testArticle.Summary = 'KB Summary';
            testArticle.URLName = 'test';
            testArticle.Short_Code__c='Test Desc';
            insert testArticle;
            
            cec_Reason_Information__kav insertedTestFaq = [Select KnowledgeArticleId from cec_Reason_Information__kav where ID = :testArticle.Id];
            
            KbManagement.PublishingService.publishArticle(insertedTestFaq.KnowledgeArticleId, true);  
            
            caseControllerObj.selectedArticleId = insertedTestFaq.KnowledgeArticleId;
            caseControllerObj.mapArticleToCase();
            
            Integer knCount = [SELECT COUNT() FROM CaseArticle WHERE KnowledgeArticleId = :insertedTestFaq.KnowledgeArticleId AND CaseId = :caseObj.Id];
            system.assertEquals(1,knCount);
            
            caseControllerObj.getAllRecords();
            System.assert(caseControllerObj.displayMore==false);
            caseObj.RecordTypeId=spamRec[0].Id;
            CEC_Case_Market_Mapping__c caseMarketMappingObj = new CEC_Case_Market_Mapping__c();
            insert caseMarketMappingObj;
            caseObj.Country__c = caseMarketMappingObj.Id;
            caseControllerObj.caseRecord=caseObj;
            caseControllerObj.selectQuickcode();
            
            if(spamRec.size()>0){
                System.assert(caseControllerObj.caseRecord.RecordTypeId==spamRec[0].Id);
            } 
            
        }
        Test.stopTest(); 
    }
    /**
Test method for checkAlertAction method
*/
    
    public static testMethod void test_checkAlertAction(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Product_Category__c productcatObj = new mdm_Product_Category__c(name='test', L0_Product_Category__c='Foods Category');
            insert productcatObj;
            
            Case caseObj = new Case();
            insert caseObj;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Global_Listening_Tree__c glt = new mdm_Global_Listening_Tree__c(L5_Code__c='C1',L5_Desc__c='C1 Desc');
            insert glt;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason',L1_Desc__c='L1 Desc', L2_Desc__c ='L2 Desc',L5_Code__c='T1132',Global_Listening_Tree__c=glt.Id);
            insert reasonobj;
            
            ApexPages.StandardController stdController = new ApexPages.StandardController(caseObj);
            CEC_CaseInlineController caseControllerObj = new CEC_CaseInlineController(stdController);
            caseControllerObj.productId = productObj.Id;
            caseControllerObj.reasonId = reasonObj.Id;
            
            cec_Alert_Rule__c alertRuleObj = new cec_Alert_Rule__c(Name = 'Rule 4',Active__c=true,Type__c='Safety',Reason_Code__c=reasonObj.id,Market__c='India',  All_Market__c=true,Threshold__c=1, Product_Category__c = productcatObj.Id, Reason_Level__c ='5',Product_Level__c='0');
            insert alertRuleObj;
            
            cec_Alert_Action__c alertActionObj = new cec_Alert_Action__c(Type__c = 'Popup', Alert_Rule_Id__c =alertRuleObj.id,Email_Template_Name__c='AlertTemplate' , To__c='pavankumar.kothamasu@capgemini.com',Popup_Message__c='Test');
            insert alertActionObj;
            
            cec_Alert_Tracker__c alertTrackerObj = new cec_Alert_Tracker__c(Alert_Rule_Id__c=alertRuleObj.id);
            insert alertTrackerObj;
            
            cec_Alert_Tracker_Item__c alertTrackerItemObj = new cec_Alert_Tracker_Item__c(Alert_Tracker_Id__c = alertTrackerObj.id,Case_Id__c=caseObj.id);
            insert alertTrackerItemObj;
            caseControllerObj.checkAlertAction();
            
            System.assert(caseControllerObj.popupAlertCheck);
        }
        Test.stopTest();
    }
    
}