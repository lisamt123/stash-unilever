/**********************************************************************
 Name:  CEC_AlertActionHelper
 Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the test class for CEC_AlertActionHelper                                                                                                     

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   


 ***********************************************************************/
@isTest(seealldata=false)
public with sharing class CEC_AlertActionHelperTest {

    // Test Method for createSafetyAlert
    static testMethod void createCaseSafetyAlerts1(){

        Test.startTest();

        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;

        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
        insert productObj;          

        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L5_Desc__c = 'L4 Desc');
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
    update caseObj;

    Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
    System.assertEquals(1,atCount);

    Test.stopTest();
    }

    // Test Method for createSafetyAlert
    static testMethod void createCaseSafetyAlerts2(){

        Test.startTest();

        CEC_Case_Market_Mapping__c cmm = new CEC_Case_Market_Mapping__c();
        cmm.Market__c = 'India';
        insert cmm;

        mdm_Product_Category__c pCategory = new mdm_Product_Category__c(name='ProductCategory', L0_Product_Category__c='Foods Category');
        insert pCategory;

        mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product1', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo1', brand__c= 'Dove1', Consumer_Product_Descriptor_no_size__c ='Dove',Global_CPG_Code__c = pCategory.id);
        insert productObj;          

        mdm_Global_Listening_Tree__c gListingTree = new mdm_Global_Listening_Tree__c(L5_Desc__c = 'L4 Desc');
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

    cec_Alert_Action__c alertAction = new cec_Alert_Action__c( Type__c = 'Email', Alert_Rule_Id__c = alertRule.id, Email_Template_Name__c='AlertTemplate' , To__c='John.Smith@test.com;Karl.Muson@test.com');
    insert alertAction;

    caseObj.CEC_Product__c = productObj.id;
    update caseObj;

    Integer atCount = [SELECT COUNT() FROM cec_Alert_Tracker__c WHERE Alert_Rule_Id__c = :alertRule.Id];
    System.assertEquals(1,atCount);

    Test.stopTest();
    }
}