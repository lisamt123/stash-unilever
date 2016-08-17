/**********************************************************************
Name: SAM_InformationController_Test ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Request
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Pooja Kanani       04/08/2016     INITIAL DEVELOPMENT CSR:
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
        objRequest.txt_Master_Clarity_Id__c = NULL;
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
        
        
       Test.setCurrentPage(new PageReference('SAM_CommentPage'));
       System.currentPageReference().getParameters().put('id', objRequest.id);
       SAM_RequestInformationController  controller = new SAM_RequestInformationController (new ApexPages.StandardController(objRequest));
       controller.commentsStr = 'test';
        controller.emailSentAction();
       controller.canelAction();
        
        Test.stopTest();
        System.assert(objRequest.pkl_Status__c != SAM_Constants.OPEN);
    }    
}