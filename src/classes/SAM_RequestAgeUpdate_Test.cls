/**********************************************************************
Name: SAM_RequestAgeUpdate_Test ()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Batch

-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Mindtree          04/08/2016        INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public  class SAM_RequestAgeUpdate_Test {

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
    Purpose: This method is used to test batch
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   static testMethod void testBatch(){
       //19/08 Dinesh - Initialize below variable to avoid below SonarQube issue
       //Avoid unused local variables such as 'batchprocessid'.
       ID batchprocessid = null;
        SAM_StatusMsgCustomSetting();
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        insert objRequest;
        
        Test.startTest();
        SAM_RequestAgeUpdate batchObj = new SAM_RequestAgeUpdate();
        batchprocessid = Database.executeBatch(batchObj);
        Test.StopTest();
        SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
        System.assert(objRequestValue.pkl_Status__c != SAM_Constants.OPEN);
    }
    
   }