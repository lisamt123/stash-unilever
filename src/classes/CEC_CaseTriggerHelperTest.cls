@isTest(seealldata=false)
public with sharing class CEC_CaseTriggerHelperTest {
    public static Id rtId;
    public static Id rtId1;
    public static Id rtId2;
    public static Account newacc;
    public static CEC_Case_Market_Mapping__c cmm;
    public static List<case> casesList;
    public static Case newcase,newcaseCommanameFormat,newcaseCommanameFormat2;
    
    
    
    public static User insertUser()
    {
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Salesforce MultiApp Standard'];
        //Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        //UserRole r = [SELECT Id,name FROM UserRole WHERE Name = 'CEC Global Head'];
        //System.debug('Role' + r.name);
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
    
    public static void initRT(){
        rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
    }
    
    public static void  initRTNone(){
        rtId1 =  [select id,name from RecordType where name='None'].Id;
        rtId2 =  [select id,name from RecordType where name='Spam'].Id;
    }
    
    public static void initRTandAccount(){
        rtId = [select Id, name from RecordType where name = 'Person Account' and SObjectType = 'Account' limit 1].Id;
        //create account
        newacc = new Account(lastname='Test Account');
        newacc.PersonEmail='test@abc.com';
        newacc.RecordTypeId=rtId;
        try {
            insert newacc;
        } catch (DmlException e) {           
            
        }
    }
    
    public static void initCMM(){
        cmm = new CEC_Case_Market_Mapping__c(Name='TestCMM');
        try {
            insert cmm;
        } catch (DmlException e) {           
            
        }
        
    }
    static testMethod void emailToCaseNoAccountTest(){
        
        User u = insertUser();
        
        System.runAs(u)
        {
            
            initRT();
            Test.startTest();
            newcase= new Case();
            casesList= new List<Case>();
            newcase.SuppliedEmail='test@abc.com';
            newcase.SuppliedName='Test Abc';
            newcase.Status='New';
            newcase.Origin='Email';
            casesList.add(newcase);
            //insert newcase;
            newcaseCommanameFormat= new Case();
            newcaseCommanameFormat.SuppliedEmail='test@abc.com';
            newcaseCommanameFormat.SuppliedName='Test,Abc';
            newcaseCommanameFormat.Status='New';
            newcaseCommanameFormat.Origin='Email';
            casesList.add(newcaseCommanameFormat);
            newcaseCommanameFormat2= new Case();
            newcaseCommanameFormat2.SuppliedEmail='test@abc.com';
            newcaseCommanameFormat2.SuppliedName='Test';
            newcaseCommanameFormat2.Status='New';
            newcaseCommanameFormat2.Origin='Email';
            casesList.add(newcaseCommanameFormat2);
            insert casesList;
            initCMM();
            for(case c: casesList){
                c.CMMFlag__c = TRUE;
                c.Country__C = cmm.Id;
            }
            update casesList;
            Test.stopTest();
            
        }
    }
    static testMethod void emailToCaseWithExistingAccountTest(){
        User u = insertUser();
        
        System.runAs(u)
        {
            initRTandAccount();
            newacc = new Account(lastname='Test Account1');
            newacc.PersonEmail='test@abc.com';
            newacc.RecordTypeId=rtId;
            try {
                insert newacc;
            } catch (DmlException e) {           
                
            }
            Test.startTest();
            newcase= new Case();
            newcase.SuppliedEmail='test@abc.com';
            newcase.SuppliedName='Test Abc';
            newcase.Status='New';
            newcase.Origin='Email';
            insert newcase;
            Test.stopTest();
        }
    }
    
    static testMethod void updateCaseDetailsRecordIDSpam(){
        
        User u = insertUser();
        
        System.runAs(u)
        {
            initRTNone();
            Test.startTest();
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;
            
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason');
            insert reasonobj;
            
            mdm_Geography__c  geographyObj = new mdm_Geography__c(name='none');
            insert geographyObj;
            
            cec_Case_QC_Mapping__c caseQCMappingObj = new cec_Case_QC_Mapping__c(QC_Type__c='Spam',Status__c='New',Verbatim__c='Test description',Product__c=productObj.id,Reason_Code__c=reasonObj.id,Country__c=geographyObj.id);
            insert caseQCMappingObj;
            
            //code modified by richa
            CEC_Case_Market_Mapping__c marketObj = new CEC_Case_Market_Mapping__c(Country__c =geographyObj.id);
            insert marketObj;
            
            newcase = new Case();
            newcase.RecordTypeId = rtId1;
            newcase.Status='New';
            newcase.Origin='Call';
            newcase.Production_Code__c='1234';
            newcase.Country__c =marketObj.id;//line modified by richa
            insert newcase;
            Map<Id,Case> casesMap = new Map<Id,Case>();
            Map<Id,Case> casesMap1 = new Map<Id,Case>();
            casesMap.put(newcase.Id,newcase);
            newcase.RecordTypeId = rtId2;
            update newcase;
            casesMap1.put(newcase.Id,newcase);
            List<cec_Case_QC_Mapping__c> caseQcMapping= [select Product__c,QC_Type__c,Reason_Code__c,Status__c,Verbatim__c from cec_Case_QC_Mapping__c where QC_Type__c='Spam' limit 1];
            CEC_CaseTriggerHelper caseHelper=new CEC_CaseTriggerHelper();
            caseHelper.updateCaseDetailsIfRecordTypeIsSpam(casesMap,casesMap1);
            caseHelper.identifyDateOfManufacture(newcase);
            System.assert(newcase.RecordTypeId==rtId2);
            
            Test.stopTest();
        }
    }
    
    
    
    /* Starts -  US-097 Personal data not included in Pulse */
    
    static testMethod void setPIIWarningforEmailIdTest(){
        User runningUser = insertUser();
        System.runAs(runningUser)
        {
            Test.startTest();
            // Insert Scenario with PII content            
            Boolean Chkresult=false;
            
            cec_Org_Settings__c custSetting = new cec_Org_Settings__c(PII_Email_Check__c = true);
            insert custSetting;            
            Case tempCase = new  Case();
            tempCase.Description='TheoWalcott@gmail.com';
            tempCase.SuppliedEmail = 'abcd@abcdasdsad.com';
            tempCase.SuppliedName = 'Mesut,Ozil';
            tempCase.Origin = 'Email';
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
        User runningUser = insertUser();
        System.runAs(runningUser)
        {
            Test.startTest();
            // Insert Scenario with PII content            
            Boolean Chkresult=false;
            
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
        User runningUser = insertUser();
        System.runAs(runningUser)
        {
            Test.startTest();
            // Insert Scenario with PII content            
            Boolean Chkresult=false;
            
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
        User runningUser = insertUser();
        System.runAs(runningUser)
        {
            Test.startTest();
            // Insert Scenario with PII content            
            newacc = new Account(lastName='Test LastName');
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
        User u = insertUser();
        
        System.runAs(u){
            initRTandAccount();
            newacc = new Account(lastname='Test Account1');
            newacc.PersonEmail='test@abc.com';
            newacc.RecordTypeId=rtId;
            
            try {
                insert newacc;
            } catch (DmlException e) {           
                
            }
            mdm_Reason_Code__c reasonObj = new mdm_Reason_Code__c(name='Test Reason', Retention_Days__c=5);
            insert reasonobj;
            
            mdm_Reason_Code__c reasonObj2 = new mdm_Reason_Code__c(name='Test Reason');            
            insert reasonobj2;   
            
            mdm_Case_Product__c productObj = new  mdm_Case_Product__c (name='Test Product', brand__c= 'Dove', Consumer_Product_Descriptor_Local_Lang__c ='Done Shampoo', Consumer_Product_Descriptor_no_size__c ='Dove');
            insert productObj;  
            
            cmm = new CEC_Case_Market_Mapping__c(Name='TestCMM');
            insert cmm;
            
            Test.startTest();
            
            case case2 = new Case();
            case2.SuppliedEmail='test@abc.com';
            case2.SuppliedName='Test Abc';
            case2.Status='New';
            case2.Origin='Email';
            case2.CEC_Product__c = productObj.Id;
            case2.AccountId = newacc.Id; 
            case2.Reason_Code__c = reasonObj.Id;
            case2.Manual_Override_Reason__c = '1-Legal';
            case2.Manual_Retention_Override__c = Date.Today().addDays(10);
            insert case2;
            
            case2.Status = 'Closed';
            case2.Country__c = cmm.Id;
            case2.Subject ='test';
            
            update case2;
            
            
            newcase= new Case();
            newcase.SuppliedEmail='test@abc.com';
            newcase.SuppliedName='Test Abc';
            newcase.Status='New';
            newcase.Origin='Email';
            newcase.CEC_Product__c = productObj.Id;
            newcase.AccountId = newacc.Id;  
            newcase.Reason_Code__c = reasonobj.Id;
            insert newcase;
            
            Map<Id,Case> caseMap1 = new Map<Id,Case>();
            List<Case> caseList = new List<Case>();
            List<Id> caseLstIds = new List<Id>();
                 
            newcase.Country__c = cmm.Id;
            newcase.Subject ='test';
            newcase.Status= 'Closed';
            update newcase;
            
            caseList.add(newcase);
            caseMap1.put(newcase.id,newcase);
            
            CEC_CaseTriggerHelper caseHelperobj = new CEC_CaseTriggerHelper();
            caseHelperobj.updateRetentionDate(caseList, caseMap1);
            
            Case UpdatedCase = [Select id,Manual_Retention_Override__c, Manual_Override_Reason__c from case where id =: newcase.Id];
            Account UpdatedAcc = [Select Id, Retention_Reason__c, Retention_Date__c From Account Where id = :newacc.Id];
            System.assertEquals(UpdatedCase.Manual_Retention_Override__c, date.today().addDays(5));
            System.assertEquals(UpdatedCase.Manual_Override_Reason__c, '3-Default');
            System.assertEquals(UpdatedAcc.Retention_Reason__c, '1-Legal');
            System.assertEquals(UpdatedAcc.Retention_Date__c, date.today().addDays(10));
            
            
            Case UpdatedCase2 = [Select id,Manual_Retention_Override__c, Manual_Override_Reason__c from case where id =: case2.Id];
            Account UpdatedAcc1 = [Select Id, Retention_Reason__c, Retention_Date__c From Account Where id = :newacc.Id];
            System.assertEquals(UpdatedCase2.Manual_Retention_Override__c, date.today().addDays(10));
            System.assertEquals(UpdatedCase2.Manual_Override_Reason__c, '1-Legal');
            System.assertEquals(UpdatedAcc1.Retention_Reason__c, '1-Legal');
            System.assertEquals(UpdatedAcc.Retention_Date__c, date.today().addDays(10));
            Test.stopTest();
            
        }
    } 
    
}