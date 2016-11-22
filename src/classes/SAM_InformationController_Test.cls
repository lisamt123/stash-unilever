/**********************************************************************
Name: SAM_InformationController_Test ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Request.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Pooja Kanani       04/08/2016     INITIAL DEVELOPMENT CSR:
2.0        Pooja Kanani        09/19/2016    Modified for SonarQube
***********************************************************************/
@isTest
public  class SAM_InformationController_Test {
    /*******************************************************************
    Purpose: This method is used to cover custom settings
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static  void SAM_StatusMsgCustomSetting(){
        SAM_Trigger_Pattern__c ReqTP = SAM_testCustomSettingClass_util.SAMRequest_TriggerPattern();
        insert ReqTP;
        SAM_Trigger_Pattern__c qLITp = SAM_testCustomSettingClass_util.SAMQLI_TriggerPattern();
        insert qLITp;
        SAM_success_messages__c saveMsg = SAM_testCustomSettingClass_util.createTest_SaveSuccessaveMsg();
        insert saveMsg;
        
        SAM_Mandatory_fields_for_submit__c mandatoryFields = SAM_testCustomSettingClass_util.createTest_SAM_Mandatory_fields_for_submit();
        insert mandatoryFields;
        
        SAM_Mandatory_fields_for_submit__c mandatoryFields1 = SAM_testCustomSettingClass_util.createTest_SAM_controlling_fields_for_submit();
        insert mandatoryFields1;
    } 
    /*******************************************************************
    Purpose: This method is used insert user
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static  User SAM_User(){
        Profile p = [SELECT Id FROM Profile WHERE Name='Unilever - Force MultiApp Standard'];       
        User u1 = new User(Alias = 'standt1',Country='United Kingdom',Email='demo1@unilever.com',EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',LocaleSidKey='en_US',ProfileId = p.Id,TimeZoneSidKey='America/Los_Angeles', UserName='dprobertdemo1@unilever.org');
        return u1;
    }
    /*******************************************************************
    Purpose: This method covers Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void RequestInformationController_Test() {
        SAM_StatusMsgCustomSetting();
        
        Test.startTest();
        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        insert objRequest;
        //objRequest.txt_Master_Clarity_Id__c = NULL;
        objRequest.txt_Master_Clarity_Id__c = '0';
        objRequest.pkl_Deployments__c = 'Cloud';
        objRequest.mpkl_Cloud_Platforms__c = null;
        update objRequest;
        
       Test.setCurrentPage(new PageReference('SAM_RequestInformationPage'));
       System.currentPageReference().getParameters().put('id', objRequest.id);
       SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(objRequest));
        controller.submit();
        controller.reminderAction();
        controller.emailSentAction();
        controller.canelAction();
        
        Test.stopTest();
        SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
        System.assert(objRequestValue.pkl_Status__c != SAM_Constants.OPEN);
    }
/*******************************************************************
    Purpose: This method covers comments page
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void Requestcomment_Test() {
        SAM_StatusMsgCustomSetting();
        
        Test.startTest();
        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        insert objRequest;
      
        objRequest.mpkl_Cloud_Platforms__c = 'Amazon';
        update objRequest;
        
       Test.setCurrentPage(new PageReference('SAM_CommentPage'));
       System.currentPageReference().getParameters().put('id', objRequest.id);
       SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(objRequest));
       controller.commentsStr = 'test';
        controller.emailSentAction();
       controller.canelAction();
        
        Test.stopTest();
        System.assert(objRequest.pkl_Status__c != SAM_Constants.OPEN);
    } 
    /*******************************************************************
    Purpose: This method covers Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void CrossChargewithoutAttach_Test() {
        SAM_StatusMsgCustomSetting();
        
        Test.startTest();
        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Cross Charge' limit 1] ;
        objRequest.recordtypeid = rt.id;
        insert objRequest;
        
        Test.setCurrentPage(new PageReference('SAM_RequestInformationPage'));
        System.currentPageReference().getParameters().put('id', objRequest.id);
        SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(objRequest));
        controller.submit();
        
        Test.stopTest();
        SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
        System.assert(objRequestValue.pkl_Status__c != SAM_Constants.OPEN);
    }
    /*******************************************************************
    Purpose: This method covers Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void CrossChargewithAttach_Test() {
        SAM_StatusMsgCustomSetting();
        
        Test.startTest();
        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Cross Charge' limit 1] ;
        objRequest.recordtypeid = rt.id;
        insert objRequest;
        SAM_TestRequestClass_util.addApproval_EmailsAttachmentToParent(objRequest.id);
        
        Test.setCurrentPage(new PageReference('SAM_RequestInformationPage'));
        System.currentPageReference().getParameters().put('id', objRequest.id);
        SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(objRequest));
        controller.submit();
        
        Test.stopTest();
        SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
        System.assert(objRequestValue.pkl_Status__c != SAM_Constants.OPEN);
    }
/*******************************************************************
    Purpose: This method covers Query Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void Query_Test() {
        User u1 = SAM_User();
        insert u1;
        PermissionSet requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Requestor' limit 1];
        PermissionSetAssignment opsa = new PermissionSetAssignment();
        opsa.AssigneeId = u1.id;
        opsa.PermissionSetId = requestorPermissionSet.id;
        insert opsa;
        // you test for your controller
        System.runAs(u1){
            SAM_StatusMsgCustomSetting();
            RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Query' limit 1] ;
            SAM_Request__c reqRec = new SAM_Request__c();
            reqRec.ltxt_Query_Detailed_Notes__c = SAM_Constants.TEST;
            reqRec.txt_Query_Title__c = SAM_Constants.TEST;
            reqRec.recordtypeid = rt.id;
            insert reqRec;
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('SAM_RequestInformationPage'));
            System.currentPageReference().getParameters().put('id', reqRec.id);
            SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(reqRec));
            controller.submit();

            Test.stopTest();
            SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: reqRec.id];
            System.assert(objRequestValue.pkl_Status__c == SAM_Constants.OPEN);
        }
    } 
    /*******************************************************************
    Purpose: This method covers Query Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void Query2_Test() {
        User u1 = SAM_User();
        insert u1;
        PermissionSet requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Admin' limit 1];
        PermissionSetAssignment opsa = new PermissionSetAssignment();
        opsa.AssigneeId = u1.id;
        opsa.PermissionSetId = requestorPermissionSet.id;
        insert opsa;
        // you test for your controller
        System.runAs(u1){
            SAM_StatusMsgCustomSetting();
            RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Query' limit 1] ;
            SAM_Request__c reqRec = new SAM_Request__c();
            reqRec.ltxt_Query_Detailed_Notes__c = SAM_Constants.TEST;
            reqRec.txt_Query_Title__c = SAM_Constants.TEST;
            reqRec.recordtypeid = rt.id;
            insert reqRec;
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('SAM_RequestInformationPage'));
            System.currentPageReference().getParameters().put('id', reqRec.id);
            SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(reqRec));
            controller.submit();

            Test.stopTest();
            SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: reqRec.id];
            System.assert(objRequestValue.pkl_Status__c == SAM_Constants.OPEN);
        }
    }  
    /*******************************************************************
    Purpose: This method covers Query Request mandatory fields methods
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testmethod void Query3_Test() {      
        User u1 = SAM_User();
        insert u1;
        PermissionSet requestorPermissionSet = [select id,Name from PermissionSet where Name = 'SAM_Team' limit 1];
        PermissionSetAssignment opsa = new PermissionSetAssignment();
        opsa.AssigneeId = u1.id;
        opsa.PermissionSetId = requestorPermissionSet.id;
        insert opsa;
        // you test for your controller
        System.runAs(u1){
            SAM_StatusMsgCustomSetting();
            RecordType rt =[select id,Name from RecordType where sObjectType='SAM_Request__c' AND Name='Query' limit 1] ;
            SAM_Request__c reqRec = new SAM_Request__c();
            reqRec.ltxt_Query_Detailed_Notes__c = SAM_Constants.TEST;
            reqRec.txt_Query_Title__c = SAM_Constants.TEST;
            reqRec.recordtypeid = rt.id;
            insert reqRec;
            Test.startTest();
            
            Test.setCurrentPage(new PageReference('SAM_RequestInformationPage'));
            System.currentPageReference().getParameters().put('id', reqRec.id);
            SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(reqRec));
            controller.submit();            

            Test.stopTest();
            SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: reqRec.id];
            System.assert(objRequestValue.pkl_Status__c == SAM_Constants.OPEN);
        }
    }  
}