/**********************************************************************
Name: SAM_testCustomSettingClass_util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the test class data for custom setting data creation
-------
======================================================
======================================================
History : AC.08.12.01, AC.10.07.03
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Pooja      28/07/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class SAM_testCustomSettingClass_util {
    
    /*******************************************************************
    Purpose: This method is used to set the Request trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Trigger_Pattern__c SAMRequest_TriggerPattern(){

        SAM_Trigger_Pattern__c reqTriggerPattern = new SAM_Trigger_Pattern__c();
        reqTriggerPattern.Name ='SAM_Request_Trigger';
        reqTriggerPattern.chk_Stop_Trigger_Execution__c = true;
        return reqTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the after QLI trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Trigger_Pattern__c SAMQLI_TriggerPattern(){

        SAM_Trigger_Pattern__c qliTriggerPattern = new SAM_Trigger_Pattern__c();
        qliTriggerPattern.Name ='SAM_QLI_Trigger';
        qliTriggerPattern.chk_Stop_Trigger_Execution__c = true;
        return qliTriggerPattern;
        
    }
     /*******************************************************************
    Purpose: This method is used to set the after RLI trigger pattern
    Parameters:  
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Trigger_Pattern__c SAMRLI_TriggerPattern(){

        SAM_Trigger_Pattern__c rliTriggerPattern = new SAM_Trigger_Pattern__c();
        rliTriggerPattern.Name ='SAM_RLI_Trigger';
        rliTriggerPattern.chk_Stop_Trigger_Execution__c = true;
        return rliTriggerPattern;
        
    }
    
    /*******************************************************************
    Purpose: This method is used to set saveMsg data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_success_messages__c createTest_SaveSuccessaveMsg(){

        SAM_success_messages__c saveMsg = new SAM_success_messages__c();
        saveMsg.Name ='1';
        saveMsg.SAM_Status__c = 'Saved';
        saveMsg.SAM_Success_message__c = 'Request is saved successfully.';       
        return saveMsg;
        
    }
	/*******************************************************************
    Purpose: This method is used to set saveMsg data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_success_messages__c createTest_AwaitingChargeSuccessaveMsg(){

        SAM_success_messages__c awaitingChargeMsg = new SAM_success_messages__c();
        awaitingChargeMsg.Name ='1';
        awaitingChargeMsg.SAM_Status__c = 'Awaiting Charge';
        awaitingChargeMsg.SAM_Success_message__c = 'Request is awaiting chargeMsg.';       
        return awaitingChargeMsg;
        
    }
	/*******************************************************************
    Purpose: This method is used to set saveMsg data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_success_messages__c createTest_ClosedSuccessaveMsg(){

        SAM_success_messages__c closedMsg = new SAM_success_messages__c();
        closedMsg.Name ='1';
        closedMsg.SAM_Status__c = 'Closed';
        closedMsg.SAM_Success_message__c = 'Request is closed.';       
        return closedMsg;
        
    }
	/*******************************************************************
    Purpose: This method is used to set OpenMsg data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_success_messages__c createTest_OpenSuccessaveMsg(){

        SAM_success_messages__c OpenMsg = new SAM_success_messages__c();
        OpenMsg.Name ='1';
        OpenMsg.SAM_Status__c = 'Open';
        OpenMsg.SAM_Success_message__c = 'Request is Open.';       
        return OpenMsg;
        
    }
	/*******************************************************************
    Purpose: This method is used to set SAM Mandatory fields for submit
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Mandatory_fields_for_submit__c createTest_SAM_Mandatory_fields_for_submit(){

        SAM_Mandatory_fields_for_submit__c Mandatory_fields = new SAM_Mandatory_fields_for_submit__c();
		Mandatory_fields.name = '1';
        Mandatory_fields.SAM_controlling_field__c = null;
		Mandatory_fields.SAM_controlling_field_value__c = null;
		Mandatory_fields.SAM_Field_API_name__c = 'txt_Master_Clarity_Id__c';
		Mandatory_fields.SAM_Field_Label__c = 'Master Clarity Id *';
		Mandatory_fields.SAM_is_mandatory__c = true;
		Mandatory_fields.SAM_Record_type__c = 'SAM_RW_Project_Request';
		Mandatory_fields.SAM_validation_message__c = 'Mandatory';    
        return Mandatory_fields;
        
    }
/*******************************************************************
    Purpose: This method is used to set SAM Mandatory fields for submit
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static SAM_Mandatory_fields_for_submit__c createTest_SAM_controlling_fields_for_submit(){

        SAM_Mandatory_fields_for_submit__c Mandatory_fields = new SAM_Mandatory_fields_for_submit__c();
		Mandatory_fields.name = '2';
        Mandatory_fields.SAM_controlling_field__c = 'pkl_Deployments__c';
		Mandatory_fields.SAM_controlling_field_value__c = 'Cloud';
		Mandatory_fields.SAM_Field_API_name__c = 'mpkl_Cloud_Platforms__c';
		Mandatory_fields.SAM_Field_Label__c = 'Cloud Platforms';
		Mandatory_fields.SAM_is_mandatory__c = true;
		Mandatory_fields.SAM_Record_type__c = 'SAM_RW_Project_Request';
		Mandatory_fields.SAM_validation_message__c = 'Mandatory';  
        Mandatory_fields.SAM_Reverse_Validation__c  = true;
        Mandatory_fields.SAM_Reverse_Validation_message__c = 'Mandatory'; 
        return Mandatory_fields;
        
    }
}