/**********************************************************************
Name: SAM_QLINewButtonOverrideController_Test()
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose: This is the test class for Quote Button Override

-------
======================================================
======================================================
History
-------
VERSION     AUTHOR               DATE            DETAIL Description
1.0         Mindtree          10/08/2016        INITIAL DEVELOPMENT CSR:
***********************************************************************/
@isTest
public  class SAM_QLINewButtonOverrideController_Test{

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
    Purpose: This method is used to fetch all data and call all methods from class
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    static testMethod void methodToFetchData(){
     SAM_StatusMsgCustomSetting();
    
    Test.startTest();
    
       SAM_Request__c objRequest = SAM_TestRequestClass_util.SAM_Request();
       insert objRequest;
       objRequest.pkl_status__c = SAM_Constants.INPROGRESS;
       update objRequest;
       SAM_Quote_Line_Item__c  objQLI = SAM_TestRequestClass_util.createQuotationDetails(objRequest);
       insert objQLI;
       Test.setCurrentPage(new PageReference('SAM_QLI_NewButtonOverridePage'));
       System.currentPageReference().getParameters().put('id', objQLI.id);
       //String retURL = SAM_Request__c.getSObjectType().getDescribe().getKeyPrefix();
       String retURL = '/'+objQLI.id;
       ApexPages.currentPage().getParameters().put('retUrl',retURL);
       SAM_QLINewButtonOverrideController  controller = new SAM_QLINewButtonOverrideController(new ApexPages.StandardController(objQLI));
            
        controller.redirectToPageNewItem();
     
      Test.stopTest();
         
        SAM_Request__c objRequestValue = [select id,pkl_Status__c from SAM_Request__c where id =: objRequest.id];
        System.assert(objRequestValue.pkl_Status__c != SAM_Constants.OPEN);
     }
    
   

}