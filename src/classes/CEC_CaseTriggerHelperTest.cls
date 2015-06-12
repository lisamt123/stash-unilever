@isTest(seealldata=false)
public with sharing class CEC_CaseTriggerHelperTest {
    public static Id rtId;
    public static Id rtId1;
    public static Id rtId2;
    public static Account newacc;
    public static CEC_Case_Market_Mapping__c cmm;
    public static List<case> casesList;
    public static Case newcase,newcaseCommanameFormat,newcaseCommanameFormat2;
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
    static testMethod void emailToCaseWithExistingAccountTest(){
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
    
    static testMethod void updateCaseDetailsRecordIDSpam(){
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