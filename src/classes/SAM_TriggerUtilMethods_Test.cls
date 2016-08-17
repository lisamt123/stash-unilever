/**********************************************************************
Name: SAM_TriggerUtilMethods_Test()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0         Pooja Kanani      28/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
private class SAM_TriggerUtilMethods_Test {
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
        SAM_Trigger_Pattern__c rLITp = SAM_testCustomSettingClass_util.SAMRLI_TriggerPattern();
        insert rLITp;
        SAM_success_messages__c saveMsg = SAM_testCustomSettingClass_util.createTest_SaveSuccessaveMsg();
        insert saveMsg;
        SAM_success_messages__c aCCMsg = SAM_testCustomSettingClass_util.createTest_AwaitingChargeSuccessaveMsg();
        insert aCCMsg;
        SAM_success_messages__c closedMsg = SAM_testCustomSettingClass_util.createTest_ClosedSuccessaveMsg();
        insert closedMsg;
        SAM_success_messages__c openMsg = SAM_testCustomSettingClass_util.createTest_OpenSuccessaveMsg();
        insert openMsg;
        SAM_Mandatory_fields_for_submit__c mandatoryFields = SAM_testCustomSettingClass_util.createTest_SAM_Mandatory_fields_for_submit();
        insert mandatoryFields;
    }       
    /*******************************************************************
    Purpose: This method is used to cover trigger utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_Request_Util_Test(){ 
        SAM_StatusMsgCustomSetting();

        Test.startTest();   
                        
        SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
		insert objRequest;
		objRequest.txt_SA_Clarity_Id__c = SAM_Constants.TEST+SAM_Constants.TEST;
        update objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
		insert ObjRLI;
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);
		insert ObjQLI;
        
        objRequest.pkl_SAM_Requester_Status__c = SAM_Constants.QUOTE_APPROVED;
        update objRequest;
        
        SAM_TestRequestClass_util.addBuild_DetailsAttachmentToParent(objRequest.id);
        SAM_TestRequestClass_util.addApproval_EmailsAttachmentToParent(objRequest.id);
        
        objRequest.pkl_SAM_team_Status__c = SAM_Constants.AWAITINGCHARGE;
        update objRequest;
            
		objRequest.pkl_SAM_team_Status__c = SAM_Constants.CLOSED;
        objRequest.pkl_Reason_for_closure__c = 'Invalid Request';
        objRequest.ltxt_Comments__c = SAM_Constants.TEST;
        update objRequest;
		//delete objRequest;
        Test.stopTest();
        List<Attachment> attachments=[select id, name from Attachment where parent.id=:objRequest.id];
		System.assertEquals(2, attachments.size());
        
    }
    /*******************************************************************
    Purpose: This method is used to cover trigger utilities
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public Static testMethod  void SAM_Request_Util_DeleteTest(){ 
        SAM_StatusMsgCustomSetting();

        Test.startTest();   
                        
		SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
        objRequest.pkl_status__c = SAM_Constants.SAVED;
		insert objRequest;
        
        SAM_Request_Line_Item__c ObjRLI =  SAM_TestRequestClass_util.createProductDetails(objRequest);
		insert ObjRLI;
        
        SAM_Quote_Line_Item__c ObjQLI =  SAM_TestRequestClass_util.createQuotationDetails(objRequest);
		insert ObjQLI;
                             
        delete ObjQLI;
        delete ObjRLI;
		delete objRequest;
        
        Test.stopTest();

		System.assertEquals(objRequest.isdeleted, false);
        
    }
}