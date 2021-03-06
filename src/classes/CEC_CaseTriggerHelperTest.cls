/**********************************************************************
Name:  CEC_CaseTriggerHelperTest
Copyright � 2015  Unilever
======================================================================
=======================================================================
Purpose: This is the test class for Case Trigger
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        -                   -        INITIAL DEVELOPMENT   
1.1        Sathish           Mar-2016   Code Refactoring.
***********************************************************************/
@isTest(seealldata=false)
public with sharing class CEC_CaseTriggerHelperTest {
    
    @testSetup static void setUpTestData() {
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= CEC_Constants.productBrand, Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c =CEC_Constants.productBrand);
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name=CEC_Constants.reasonCode);
            insert reasonobj;
            
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
            
            mdm_Geography__c  geographyUK = [SELECT Id FROM mdm_Geography__c WHERE Name = 'United Kingdom' LIMIT 1];
            
            
            cec_Case_QC_Mapping__c caseQCMappingObj = new cec_Case_QC_Mapping__c(QC_Type__c = 'Spam',Status__c = CEC_Constants.caseStatus,
                                                                                 Verbatim__c = 'Test description', 
                                                                                 Product__c = productObj.id,
                                                                                 Reason_Code__c = reasonObj.id,
                                                                                 Country__c = geographyUK.id);
            insert caseQCMappingObj;
            
            
            List<Account> masterAccountList = new List<Account>();
            masterAccountList.addAll(CEC_TestDataFactory.createTestAccounts(1, 'Test Account1', 
                                                                            '1cecTestForCase@UnileverTest.com', null, null, null, null, null));
            
            masterAccountList.addAll(CEC_TestDataFactory.createTestAccounts(1, 'Test Account2', 
                                                                            '2cecTestForCase@UnileverTest.com', null, null, null, null, null));
            insert masterAccountList;
            
            List<Case> caseList = CEC_TestDataFactory.createTestCases(2, CEC_Constants.caseStatus, CEC_Constants.caseOrigin, 'L1234', '1234',
                                                                      productObj.Id, reasonObj.Id, 
                                                                      null, cmmUK.Id , true);
            insert caseList;
            
        }
    }
    
    static testMethod void emailToCaseNoAccountTest(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest(); 
            // The new account is created when the case is of orign 'Email' and no existing acconts matching the email. 
            List<Case> caseList = [SELECT Id, AccountId FROM Case limit 100]; 
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                WHERE  Market__c = 'United Kingdom' Limit 1];
            for(Case caseObj: caseList){
                caseObj.CMMFlag__c = TRUE;
                caseObj.Country__C = cmmUK.Id;
            }
            update caseList;
            Test.stopTest();
            for (Case caseObj : caseList) {
                System.assertNotEquals(caseObj.AccountId,null);
            }
        }
    }
    
    static testMethod void emailToCaseWithExistingAccountTest(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest(); 
            Account accountObj = [SELECT Id FROM Account WHERE PersonEmail='1cecTestForCase@UnileverTest.com' LIMIT 1];
            Case newcase = new Case();
            newcase.SuppliedEmail = '1cecTestForCase@UnileverTest.com';
            newcase.SuppliedName = CEC_Constants.suppliedName;
            newcase.Status = CEC_Constants.caseStatus;
            newcase.Origin = CEC_Constants.caseOrigin;
            insert newcase;
            Test.stopTest();
            System.assertNotEquals(newcase.AccountId,accountObj.Id);
        }
    }
    
    static testMethod void updateCaseDetailsRecordIDSpam(){
        
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest(); 
            //List<Case> caseList = [SELECT Id, Reason_Code__c FROM Case limit 100]; 
            Id noneRecordTypeId = [SELECT id,name FROM RecordType WHERE name = 'None'].Id;
            Id spamRecordTypeId = [SELECT id,name FROM RecordType WHERE name = 'Spam'].Id;
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                WHERE Name = 'United Kingdom' LIMIT 1];
            Case newcase = new Case();
            newcase.RecordTypeId = noneRecordTypeId;
            newcase.Status=CEC_Constants.caseStatus;
            newcase.Origin='Call';
            newcase.Production_Code__c='1234';
            newcase.Country__c = cmmUK.id;
            insert newcase;
            Map<Id,Case> casesMap = new Map<Id,Case>();
            Map<Id,Case> casesMap1 = new Map<Id,Case>();
            casesMap.put(newcase.Id,newcase);
            newcase.RecordTypeId = spamRecordTypeId;
            update newcase;
            casesMap1.put(newcase.Id,newcase);
            
            CEC_CaseTriggerHelper caseHelper=new CEC_CaseTriggerHelper();
            caseHelper.updateCaseDetailsIfRecordTypeIsSpam(casesMap,casesMap1);
            caseHelper.identifyDateOfManufacture(newcase);
            System.assert(newcase.RecordTypeId == spamRecordTypeId);
            
            Test.stopTest();
        }
    }
    
    
    
    /* Starts -  US-097 Personal data not included in Pulse */
    
    static testMethod void setPIIWarningforEmailIdTest(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            // Insert Scenario with PII content            
            
            cec_Org_Settings__c custSetting = new cec_Org_Settings__c(PII_Email_Check__c = true);
            insert custSetting; 
            
            Case tempCase = new  Case();
            tempCase.Description='TheoWalcott@gmail.com';
            tempCase.SuppliedEmail = 'abcd@abcdasdsad.com';
            tempCase.SuppliedName = 'Mesut,Ozil';
            tempCase.Origin = CEC_Constants.caseOrigin;
            insert tempCase;
            
            Case resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);
            
            // Update Scenario without PII content
            tempCase.Description='TheoWalcott plays for England';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(False, resultCase.PII_Warning_Check__c);
            
            // Update Scenario with PII content
            tempCase.Description='TheoWalcott @ England';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);               
            Test.stopTest();
        }
    }
    
    static testMethod void setPIIWarningforBirthTest(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            cec_Org_Settings__c custSetting = new cec_Org_Settings__c(PII_DOB_Check__c = true, PII_Keywords__c = 'Birth');
            insert custSetting;            
            Case tempCase = new  Case();
            tempCase.Description='Arsenal team birth year is in 18th Century';
            insert tempCase;
            
            Case resultCase = [SELECT Id, PII_Warning_Check__c, Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('setPIIWarningforBirthTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);
            
            // Update Scenario without PII content
            tempCase.Description='Arsenal is a london club';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c, Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('setPIIWarningforBirthTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(False, resultCase.PII_Warning_Check__c);
            
            // Update Scenario with PII content
            tempCase.Description='Calculating Arsenal birth year..';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c, Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('setPIIWarningforBirthTest Case ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);               
            Test.stopTest();
        }
    }
    
    static testMethod void setPIIWarning4DigitTest(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            
            cec_Org_Settings__c custSetting = new cec_Org_Settings__c(PII_Phone_Number_Check__c = true);
            insert custSetting;            
            Case tempCase = new  Case();
            tempCase.Description='Arsenal club born in 1886';
            insert tempCase;
            
            Case resultCase = [SELECT Id, PII_Warning_Check__c, Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('setPIIWarning4DigitTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);
            
            // Update Scenario without PII content
            tempCase.Description='Arsenal is a london club';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c, Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('setPIIWarning4DigitTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(False, resultCase.PII_Warning_Check__c);
            
            // Update Scenario with PII content
            tempCase.Description='Olivier born in the year 1986';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c, Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('setPIIWarning4DigitTest Case ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);               
            Test.stopTest();
        }
    }
    
    //Acconut Detail Check 
    static testMethod void setPIIWarningAccountDetailsTest(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            // Insert Scenario with PII content            
            Account newacc = new Account(lastName='Test LastName');
            newacc.FirstName='Test FirstName';
            newacc.PersonMailingStreet='Hounslow East';
            newacc.PersonMailingPostalCode='400 706';
            insert newacc;
            
            cec_Org_Settings__c custSetting = new cec_Org_Settings__c(PII_Account_Name_Check__c = true, PII_Account_Address_Check__c = true);
            insert custSetting;            
            Case tempCase = new  Case();
            tempCase.Description='Hello.. Test FirstName is the first name of both account and contact';
            tempCase.AccountId = newacc.Id;
            insert tempCase;
            
            Case resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);
            
            
            // Update Scenario without PII content
            tempCase.Description='No Account Name at all';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case  ~~~~~~~~'+ resultCase);
            System.assertEquals(False, resultCase.PII_Warning_Check__c);
            
            // Update Scenario with PII content for Last Name
            tempCase.Description='Hello.. Test LastName is the last name of both account and contact';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);    
            
            // Update Scenario with PII content for Address - Street
            tempCase.Description='Test lives in London in a street called Hounslow East near to the tube station';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);
            
            // Update Scenario with PII content for Address - PostalCode
            tempCase.Description='Test lives in London whose area code is 400 706. This is zone 3.';
            update tempCase;
            resultCase = [SELECT Id, PII_Warning_Check__c,Description FROM Case WHERE Id = :tempCase.Id];
            System.debug('SetPIIWarningforEmailIdTest Case ~~~~~~~~'+ resultCase);
            System.assertEquals(True, resultCase.PII_Warning_Check__c);
            
            Test.stopTest();
        }
    }
    
    /* Ends  -  US-097 Personal data not included in Pulse */
    
    static testMethod void updateRetentionDays(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            Account accountObj = [SELECT Id FROM Account WHERE PersonEmail='1cecTestForCase@UnileverTest.com' LIMIT 1];
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name=CEC_Constants.reasonCode, Retention_Days__c=5);
            insert reasonobj;
            
            mdm_Reason_Code__c reasonObj2 = new mdm_Reason_Code__c(name=CEC_Constants.reasonCode);            
            insert reasonobj2;   
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= CEC_Constants.productBrand, Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c =CEC_Constants.productBrand);
            insert productObj;  
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                WHERE Name = 'United Kingdom' LIMIT 1];
            Case newcase= new Case();
            newcase.SuppliedEmail='test@abc.com';
            newcase.SuppliedName=CEC_Constants.suppliedName;
            newcase.Status=CEC_Constants.caseStatus;
            newcase.Origin=CEC_Constants.caseOrigin;
            newcase.CEC_Product__c = productObj.Id;
            newcase.AccountId = accountObj.Id;  
            newcase.Reason_Code__c = reasonobj.Id;
            insert newcase;

            Map<Id,Case> caseMap1 = new Map<Id,Case>();
            List<Case> caseList = new List<Case>();
            //List<Id> caseLstIds = new List<Id>();
            newcase.Country__c = cmmUK.Id;
            newcase.Subject ='test';
            newcase.Status= 'Closed';
            update newcase;

            caseList.add(newcase);
            caseMap1.put(newcase.id,newcase);
            CEC_CaseTriggerHelper caseHelperobj = new CEC_CaseTriggerHelper();
            caseHelperobj.updateRetentionDate(caseList, caseMap1);

            Case UpdatedCase = [Select id,Manual_Retention_Override__c, Manual_Override_Reason__c from case where id =: newcase.Id];
            Account UpdatedAcc = [Select Id, Retention_Reason__c, Retention_Date__c From Account Where id = :accountObj.Id];
            System.assertEquals(UpdatedCase.Manual_Retention_Override__c, date.today().addDays(5));
            System.assertEquals(UpdatedCase.Manual_Override_Reason__c, '3-Default');
            System.assertEquals(UpdatedAcc.Retention_Reason__c, '3-Default');
            System.assertEquals(UpdatedAcc.Retention_Date__c, date.today().addDays(5));
            Test.stopTest();            
        }
    }

    static testMethod void updateRetentionDays2(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();
        
        System.runAs(u) {
            Test.startTest();
            Account accountObj = [SELECT Id FROM Account WHERE PersonEmail='1cecTestForCase@UnileverTest.com' LIMIT 1];
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name=CEC_Constants.reasonCode, Retention_Days__c=5);
            insert reasonobj;
            
            mdm_Reason_Code__c reasonObj2 = new mdm_Reason_Code__c(name=CEC_Constants.reasonCode);            
            insert reasonobj2;   
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= CEC_Constants.productBrand, Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c =CEC_Constants.productBrand);
            insert productObj;  
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                WHERE Name = 'United Kingdom' LIMIT 1];
            case case2 = new Case();
            case2.SuppliedEmail='test@abc.com';
            case2.SuppliedName=CEC_Constants.suppliedName;
            case2.Status=CEC_Constants.caseStatus;
            case2.Origin=CEC_Constants.caseOrigin;
            case2.CEC_Product__c = productObj.Id;
            case2.AccountId = accountObj.Id; 
            case2.Reason_Code__c = reasonObj.Id;
            case2.Manual_Override_Reason__c = '1-Legal';
            case2.Manual_Retention_Override__c = Date.Today().addDays(10);
            insert case2;
            case2.Status = 'Closed';
            case2.Country__c = cmmUK.Id;
            case2.Subject ='test';            
            update case2;
            Map<Id,Case> caseMap1 = new Map<Id,Case>();
            List<Case> caseList = new List<Case>();

            CEC_CaseTriggerHelper caseHelperobj = new CEC_CaseTriggerHelper();
            caseHelperobj.updateRetentionDate(caseList, caseMap1);
            Case UpdatedCase2 = [Select id,Manual_Retention_Override__c, Manual_Override_Reason__c from case where id =: case2.Id];
            Account UpdatedAcc1 = [Select Id, Retention_Reason__c, Retention_Date__c From Account Where id = :accountObj.Id];
            System.assertEquals(UpdatedCase2.Manual_Retention_Override__c, date.today().addDays(10));
            System.assertEquals(UpdatedCase2.Manual_Override_Reason__c, '1-Legal');
            System.assertEquals(UpdatedAcc1.Retention_Reason__c, '1-Legal');
            System.assertEquals(UpdatedAcc1.Retention_Date__c, date.today().addDays(10));
            Test.stopTest();
            
        }
    }
    
    static testMethod void testupdateCaseBrandAndSkill(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();  
        System.runAs(u) {
            Test.startTest();
            
            Account accountObj = [SELECT Id FROM Account WHERE PersonEmail='1cecTestForCase@UnileverTest.com' LIMIT 1];
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                WHERE Name = 'United Kingdom' LIMIT 1];
            cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c=cmmUK.id,Brand__c='Knorr',Inbound_Email__c='unitedkingdom.knorr@unilever.com',Skill__c='Coffee & Snacks');
            insert cbm;
            
            
            Case newcase= new Case();
            newcase.SuppliedEmail='test@abc.com';
            newcase.SuppliedName=CEC_Constants.suppliedName;
            newcase.Status=CEC_Constants.caseStatus;
            newcase.Origin='Web';
            newcase.AccountId = accountObj.Id;  
            newcase.Brand__c ='Knorr';
            newcase.Country__c = cmmUK.id;
            insert newcase;
            
            System.debug('@@@@newcase' + newcase);
            System.assertEquals(true, true);
        }
    }
    static testMethod void testupdateCaseBrandAndSkillOnUpdate(){
        User u = CEC_TestDataFactory.getStandardCECTestUser();  
        System.runAs(u) {
            Test.startTest();
            
            Account accountObj = [SELECT Id FROM Account WHERE PersonEmail='1cecTestForCase@UnileverTest.com' LIMIT 1];
            
            CEC_Case_Market_Mapping__c cmmUK = [SELECT Id FROM CEC_Case_Market_Mapping__c 
                                                WHERE Name = 'United Kingdom' LIMIT 1];
            cec_Case_Brand_Mapping__c cbm = new cec_Case_Brand_Mapping__c(Country__c=cmmUK.id,Brand__c='Knorr',Inbound_Email__c='unitedkingdom.knorr@unilever.com',Skill__c='Coffee & Snacks');
            insert cbm;
            
            
            Case newcase= new Case();
            newcase.SuppliedEmail='test@abc.com';
            newcase.SuppliedName=CEC_Constants.suppliedName;
            newcase.Status=CEC_Constants.caseStatus;
            newcase.Origin='Web';
            newcase.AccountId = accountObj.Id;  
            newcase.Brand__c ='Ben';
            newcase.Country__c = cmmUK.id;
            insert newcase;
            
            newcase.Brand__c ='Knorr';
            update newcase;
            
            System.debug('@@@@newcase' + newcase);
            System.assertEquals(true, true);
        }
    }
}