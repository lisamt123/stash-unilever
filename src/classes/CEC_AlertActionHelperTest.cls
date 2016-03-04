/**********************************************************************
Name:  CEC_AlertActionHelperTest
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the test class for CEC_InstantAlertActionHelper 
&& CEC_BatchAlertActionHelper

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0                                          INITIAL DEVELOPMENT
1.1        Sathish           DEC-2015        Updated test for 'Questionnaire' Alert Type 

***********************************************************************/
@isTest(seealldata=false)
public with sharing class CEC_AlertActionHelperTest {
    
    
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
    
    // Test Method for createSafetyAlert
    static testMethod void createCaseSafetyAlerts1(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', 
                                                                L2_Desc__c = 'Product', L3_Desc__c = 'Foreign matter',
                                                                L4_Desc__c = 'Unidentifiable Foreign Matter', 
                                                                L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            case caseTest = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            
            System.assertEquals(cmm.Market__c, caseTest.Case_Market__c);
            
            cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = true, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = false);
            insert alertRule;
            
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Email', Alert_Rule_Id__c = alertRule.id, Email_Template_Name__c='AlertTemplate' , To__c='John.Smith@test.com');
            insert alertAction;
            
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;
            
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1,atCount);
        }
        Test.stopTest();
    }
    
    // Test Method for createSafetyAlert
    static testMethod void createCaseSafetyAlerts2(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            
            caseObj.CEC_Product__c = null;
            update caseObj;
            
            case caseTest2 = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            
            System.assertEquals(cmm.Market__c, caseTest2.Case_Market__c);
            
            cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = true, X30_Days_Limit__c = True);
            insert alertRule;
            
            Id personAccountRecordId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
            Account newConsumer = new Account();
            newConsumer.FirstName = 'John.Smith@test.com';
            newConsumer.LastName = 'John.Smith@test.com';
            newConsumer.PersonEmail = 'John.Smith@test.com';
            newConsumer.RecordTypeId = personAccountRecordId;
            String accountString = JSON.serialize(newConsumer);
            accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
            newConsumer = (Account)JSON.deserialize( accountString, Account.class );
            insert newconsumer;
            
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Email', Alert_Rule_Id__c = alertRule.id, Email_Template_Name__c='AlertTemplate' , To__c='John.Smith@test.com;Karl.Muson@test.com');
            insert alertAction;
            
            caseObj.CEC_Product__c = productObj.id;
            update caseObj;
            
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1,atCount);
	
        }
        Test.stopTest();
    }

    // Test Method for Alert Action type 'Questionnaire'
    static testMethod void testQuestionnaireAlertAction(){
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            
            caseObj.CEC_Product__c = null;
            update caseObj;
            
            case caseTest2 = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            System.assertEquals(cmm.Market__c, caseTest2.Case_Market__c);
            
            cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = false, Threshold__c = 1, Product_Category__c = pCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = true);
            insert alertRule;
            
            Id personAccountRecordId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
            Account newConsumer = new Account();
            newConsumer.FirstName = 'John.Smith@test.com';
            newConsumer.LastName = 'John.Smith@test.com';
            newConsumer.PersonEmail = 'John.Smith@test.com';
            newConsumer.RecordTypeId = personAccountRecordId;
            String accountString = JSON.serialize(newConsumer);
            accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
            newConsumer = (Account)JSON.deserialize( accountString, Account.class );
            insert newconsumer;
            
            List<cec_Alert_Action__c> alertActionList = new List<cec_Alert_Action__c>();
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Questionnaire', Alert_Rule_Id__c = alertRule.id,
                                                            Q12__c = 'CaseOwner', Q2__c = 'CaseNumber', Q3__c = 'CaseOrigin', 
                                                            Q4__c = 'CaseOpenedDate', Q5__c = 'ProductCode', Q6__c = 'ProductCodeDesc',
                                                            Q7__c = 'ShortCode', Q8__c = 'ProductionCode',
                                                            Q9__c = 'UsedProdPreviously', Q10__c = 'Verbatim',
                                                            Survey_Id__c = 'abcdefgh', Survey_Name__c = 'Test Survey Name');

            
            cec_Alert_Action__c alertAction2 = new cec_Alert_Action__c( Type__c = 'Questionnaire', Alert_Rule_Id__c = alertRule.id,
                                                            Q12__c = 'ProductCode', Q2__c = 'CaseNumber', Q3__c = 'CaseOrigin', 
                                                            Q4__c = 'CaseOpenedDate',  Q5__c = 'ProductCodeDesc',
                                                            Q6__c = 'ShortCode', Q7__c = 'CaseOwner', Q8__c = 'ProductionCode',
                                                            Q9__c = 'CaseNumber', Q10__c = 'Verbatim',
                                                            Survey_Id__c = 'xyz123', Survey_Name__c = 'Test Survey Name_2');

            alertActionList.add(alertAction);
            alertActionList.add(alertAction2);
            insert alertActionList;
            
            caseObj.CEC_Product__c = productObj.id;
            update caseObj;
            
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1,atCount);
			
            // Check the Case Action result 1
            cec_Case_Action__c caseActionResult1 = [SELECT Q12__c, Q2__c, Q3__c, Q4__c, Q5__c,Q6__c, Q7__c, Q8__c, Q9__c, Q10__c, Q11__c, Survey_Id__c 
                                                    FROM cec_Case_Action__c 
                                                    WHERE Case_Id__c = :caseObj.Id AND Survey_Name__c = 'Test Survey Name'];
            System.assertEquals(caseActionResult1.Q12__c, 'CaseOwner');
            System.assertEquals(caseActionResult1.Q3__c, 'CaseOrigin');
            System.assertEquals(caseActionResult1.Q11__c, null);
            System.assertEquals(caseActionResult1.Survey_Id__c, 'abcdefgh');

            // Check the Case Action result 2
            cec_Case_Action__c caseActionResult2 = [SELECT Q12__c, Q2__c, Q3__c, Q4__c, Q5__c,Q6__c, Q7__c, Q8__c, Q9__c, Q10__c, Q11__c, Survey_Id__c 
                                                    FROM cec_Case_Action__c  
                                                    WHERE Case_Id__c = :caseObj.Id AND Survey_Name__c = 'Test Survey Name_2'];
            System.assertEquals(caseActionResult2.Q12__c, 'ProductCode');
            System.assertEquals(caseActionResult2.Q4__c, 'CaseOpenedDate');
            System.assertEquals(caseActionResult2.Q11__c,  null);
            System.assertEquals(caseActionResult2.Survey_Id__c, 'xyz123');
			      
        }
        Test.stopTest();
    }
	
	// Test Method to update Inactive Alert Tracker Items
    /*static testMethod void testInactiveAlertTrackerItems(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)  {
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            mdm_Product_Category__c prodCategory = new mdm_Product_Category__c(name='Test ProductCategory', L0_Product_Category__c='Test Foods Category');
            insert prodCategory;
            
            mdm_Case_Product__c caseproduct = new  mdm_Case_Product__c (name='Test Case Product', Consumer_Product_Descriptor_Local_Lang__c ='Test Dove Shampoo', brand__c= 'Test Dove', Consumer_Product_Descriptor_no_size__c ='Test Dove',Global_CPG_Code__c = prodCategory.id);
            insert caseproduct;          
            
            mdm_Global_Listening_Tree__c gListningTree = new mdm_Global_Listening_Tree__c(L5_Desc__c = 'L5 Desc');
            insert gListningTree;
            
            mdm_Reason_Code__c reasoncode = new mdm_Reason_Code__c(name='Test Reason Code', L5_Code__c='T5061',Global_Listening_Tree__c = gListningTree.Id);
            insert reasoncode;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            //Case #1
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.Country__c = cmm.id;
            insert caseObj;
            
            //Case #2
            Case caseObj1= new Case();
            caseObj1.Status='New';
            caseObj1.Origin='Email'; 
            caseObj1.Country__c = cmm.id;
            insert caseObj1;
         
            List<case> caseTest2 = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            System.assertEquals(cmm.Market__c, caseTest2[0].Case_Market__c);
            
            Id personAccountRecordId = [Select Id From RecordType Where SObjectType = 'Account' And Name = 'Person Account'].Id;
            Account newConsumer = new Account();
            newConsumer.FirstName = 'John.Smith@test.com';
            newConsumer.LastName = 'John.Smith@test.com';
            newConsumer.PersonEmail = 'John.Smith@test.com';
            newConsumer.RecordTypeId = personAccountRecordId;
            String accountString = JSON.serialize(newConsumer);
            accountString = accountString.subString( 0, accountString.length() - 1 ) + ',"IsPersonAccount":true}';
            newConsumer = (Account)JSON.deserialize( accountString, Account.class );
            insert newconsumer;
            
			
			cec_Alert_Rule__c alertRule30days = new cec_Alert_Rule__c(Name = '30 days Rule ', Active__c=true, Type__c='Safety', Reason_Code__c = reasoncode.id, Market__c='India',  All_Market__c = false, Threshold__c = 1, Product_Category__c = prodCategory.Id, Product_Level__c = '0', Reason_Level__c = '5', Group_By_Day_Code__c = true, X30_Days_Limit__c = true);
            insert alertRule30days;
            
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Popup', Alert_Rule_Id__c = alertRule30days.id, Popup_Message__c = 'Glass inside the product');
            insert alertAction;
            
            caseObj.CEC_Product__c = caseproduct.id;
            caseObj.Reason_Code__c = reasoncode.id;
			caseObj.Production_Code__c = 'L1234';
            update caseObj;
   
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule30days.Id];
            System.assertEquals(1,atCount);
			
			cec_Alert_Tracker__c AlertTracker = [SELECT Id, Product_No_Size__c FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule30days.Id];
           
            Integer atiCount = [SELECT COUNT() FROM cec_Alert_Tracker_Item__c WHERE Alert_Tracker_Id__c =:AlertTracker.Id];
			System.assertEquals(1,atiCount);
			
            List<cec_Alert_Tracker_Item__c> AlertTrackerItem = [SELECT Id, Active__c, Alert_Rule_Id__c,Alert_Tracker_Id__c,Case_Id__c FROM cec_Alert_Tracker_Item__c 												
                                                          WHERE Alert_Tracker_Id__c =:AlertTracker.Id];
            System.assertEquals(True, AlertTrackerItem[0].Active__c);
            System.assertEquals(alertRule30days.Id, AlertTrackerItem[0].Alert_Rule_Id__c);

            Integer atiCount2 = [SELECT COUNT() FROM cec_Alert_Tracker_Item__c WHERE Alert_Rule_Id__c =:alertRule30days.Id];
            System.assertEquals(1,atiCount2);

            String atiJSON = '{"attributes":{"type":"cec_Alert_Tracker_Item__c","url":"/services/data/v25.0/sobjects/cec_Alert_Tracker_Item__c/AlertTrackerItem.Id"},"Id":"AlertTrackerItem.Id","CreatedDate":"2015-11-04T17:54:26.000+0000"}';
            cec_Alert_Tracker_Item__c ati = (cec_Alert_Tracker_Item__c) JSON.deserialize(atiJSON, cec_Alert_Tracker_Item__c.class );
            System.debug('*****ATI CREATED DATE*********'+ati.createdDate);

            caseObj1.CEC_Product__c = caseproduct.id;
            caseObj1.Reason_Code__c = reasoncode.id;
			caseObj1.Production_Code__c = 'L1234';	
            update caseObj1;
            
            Integer atiCount3 = [SELECT COUNT() FROM cec_Alert_Tracker_Item__c WHERE Alert_Rule_Id__c =:alertRule30days.Id];
            System.assertEquals(2,atiCount3);
            
            List<cec_Alert_Tracker_Item__c> InactiveAlertTrackerItem = [SELECT Id, Active__c, Alert_Rule_Id__c,Alert_Tracker_Id__c,Case_Id__c, createdDate FROM cec_Alert_Tracker_Item__c 
                                                          		   WHERE Alert_Rule_Id__c =:alertRule30days.Id];
            System.debug('*****INActiveATItems*********'+InactiveAlertTrackerItem);
            //System.assertEquals(True, InactiveAlertTrackerItem[0].Active__c);
            //System.assertEquals(false, InactiveAlertTrackerItem[1].Active__c);
            System.assertEquals(alertRule30days.Id, InactiveAlertTrackerItem[0].Alert_Rule_Id__c);
            System.debug('*****ATItem CREATED DATE*********'+InactiveAlertTrackerItem[0].createdDate);
            System.debug('*****ATI Active Status*********'+InactiveAlertTrackerItem[0].Active__c);
           Datetime DaysOld31 = Datetime.now().addDays(-31);
		   	 Test.setCreatedDate(ati.Id, DaysOld31);
        }
        Test.stopTest();
    }*/

    // Test Method for createSafetyAlert
    static testMethod void createAlertsForCaseProduct(){
        
        Test.startTest();
        User u = insertUser();
        
        System.runAs(u)
        {
            
            mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
            insert pCategory;
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
            insert productObj;          
            
            mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L1_Desc__c='Complaint', L2_Desc__c = 'Product',
                                                                L3_Desc__c = 'Foreign matter',L4_Desc__c = 'Unidentifiable Foreign Matter', L5_Desc__c = 'Foreign matter - unidentifiable');
            insert gListingTree;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason1', L5_Code__c='T5261',Global_Listening_Tree__c = gListingTree.Id);
            insert reasonObj;
            
            CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
            cmm.Market__c = 'India';
            insert cmm;
            
            cec_Org_Settings__c custsett = new cec_Org_Settings__c();
            custsett.Safety_Alert_Email_Id__c = 'test@gmail.com';
            insert custsett;
            
            OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :custsett.Safety_Alert_Email_Id__c];
            
            Case caseObj= new Case();
            caseObj.Status='New';
            caseObj.Origin='Email'; 
            caseObj.CEC_Product__c = productObj.id;
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Country__c = cmm.id;
            caseObj.Production_Code__c = 'L1234';
            caseObj.DayCode__c ='1234';
            insert caseObj;
            caseObj.Reason_Code__c = null;
            update caseObj;
            
            case caseTest = [Select DayCode__c, Case_Market__c from case Where DayCode__c ='1234'];
            
            System.assertEquals(cmm.Market__c, caseTest.Case_Market__c);
            
            cec_Alert_Rule__c alertRule = new cec_Alert_Rule__c(Name = 'Rule 1', Active__c=true, Type__c='Safety', Reason_Code__c = reasonObj.id, Market__c='India',  All_Market__c = true, Threshold__c = 1, Case_Product__c = productObj.id, Reason_Level__c = '5', Group_By_Day_Code__c = false);
            insert alertRule;
            
            cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Email', Alert_Rule_Id__c = alertRule.id, Email_Template_Name__c='AlertTemplate' , To__c='John.Smith@test.com');
            insert alertAction;
            
            caseObj.Reason_Code__c = reasonObj.id;
            caseObj.Production_Code__c = null;
            caseObj.DayCode__c = null;
            update caseObj;
            
            Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
            System.assertEquals(1,atCount);
        }
        Test.stopTest();
    }
}