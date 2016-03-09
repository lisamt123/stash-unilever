/**********************************************************************
Name: CPA_testCustomSettingClass_util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the test class for attachment functionality
-------
======================================================
======================================================
History : AC.08.12.01, AC.10.07.03
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Pooja      08/03/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_testCustomSettingClass_util {
    /*******************************************************************
    Purpose: This method is used to set the status of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_CPA_Status_Msg(){

        CPA_Status_Msg__c saveStatus = new CPA_Status_Msg__c();
        saveStatus.Name ='Saved';
        saveStatus.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        saveStatus.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return saveStatus;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (auto accepted) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_AutoAcceMsg(){

        CPA_Status_Msg__c AutoAcceMsg = new CPA_Status_Msg__c();
        AutoAcceMsg.Name ='Auto Accepted';
        AutoAcceMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        AutoAcceMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return AutoAcceMsg;
        
    }
    
    /*******************************************************************
    Purpose: This method is used to set the status messages (accepted) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_CPA_Status_Msg1(){

        CPA_Status_Msg__c acceptedStatus = new CPA_Status_Msg__c();
        acceptedStatus.Name ='Accepted';
        acceptedStatus.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        acceptedStatus.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return acceptedStatus;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (submitted) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_SubMsg(){

        CPA_Status_Msg__c SubMsg = new CPA_Status_Msg__c();
        SubMsg.Name ='Submitted';
        SubMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        SubMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return SubMsg;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (Answered) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_AnsweredMsg(){

        CPA_Status_Msg__c AnsweredMsg = new CPA_Status_Msg__c();
        AnsweredMsg.Name ='Answered';
        AnsweredMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        AnsweredMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return AnsweredMsg;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the status messages (Cancel) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_CancelMsg(){

        CPA_Status_Msg__c CancelMsg = new CPA_Status_Msg__c();
        CancelMsg.Name ='Cancelled';
        CancelMsg.CNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.CR_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.HLE_Request_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.LOI_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.PWO_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.Status_Message__c = CPA_ConstantsForContractingAppClasses.TEST;
        CancelMsg.TNF_Status_Msg__c = CPA_ConstantsForContractingAppClasses.TEST;
        return CancelMsg;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the CR trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_CRTriggerPattern(){

        CPA_Trigger_Pattern__c CRtriggerPattern = new CPA_Trigger_Pattern__c();
        CRtriggerPattern.Name ='CPA_CR_Trigger';
        CRtriggerPattern.chk_Check_Run__c = true;
        return CRtriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the after attachment trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_AfterAttachmentTriggerPattern(){

        CPA_Trigger_Pattern__c AfterAttachmentTriggerPattern = new CPA_Trigger_Pattern__c();
        AfterAttachmentTriggerPattern.Name ='CPA_AfterAttachment';
        AfterAttachmentTriggerPattern.chk_Check_Run__c = true;
        return AfterAttachmentTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the HLE Request trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_HLERequestTriggerPattern(){

        CPA_Trigger_Pattern__c HLERequestTriggerPattern = new CPA_Trigger_Pattern__c();
        HLERequestTriggerPattern.Name ='CPA_HLERequest';
        HLERequestTriggerPattern.chk_Check_Run__c = true;
        return HLERequestTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the LOI trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_LOITriggerPattern(){

        CPA_Trigger_Pattern__c LOITriggerPattern = new CPA_Trigger_Pattern__c();
        LOITriggerPattern.Name ='CPA_LOI_Trigger';
        LOITriggerPattern.chk_Check_Run__c = true;
        return LOITriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWO trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_PWOTriggerPattern(){

        CPA_Trigger_Pattern__c PWOTriggerPattern = new CPA_Trigger_Pattern__c();
        PWOTriggerPattern.Name ='CPA_Project_Work_Order_Trigger';
        PWOTriggerPattern.chk_Check_Run__c = true;
        return PWOTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWORF trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_PWORFTriggerPattern(){

        CPA_Trigger_Pattern__c PWORFTriggerPattern = new CPA_Trigger_Pattern__c();
        PWORFTriggerPattern.Name ='CPA_PWORF_Trigger';
        PWORFTriggerPattern.chk_Check_Run__c = true;
        return PWORFTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the HLE Request SLA details
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_HLE_Request_SLAs__c createTest_HLEReqSLA(){

        CPA_HLE_Request_SLAs__c HLEReqSLA = new CPA_HLE_Request_SLAs__c();
        HLEReqSLA.Name ='SLA';
        HLEReqSLA.HLE_Request_SLA1__c = 5;
        HLEReqSLA.HLE_Request_SLA2__c = 5;
        return HLEReqSLA;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWORF All record types
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_PWORF_Record_type__c createTest_PWORF_All_recordtType(ID allId){

        CPA_PWORF_Record_type__c PWORFAllrecordtType = new CPA_PWORF_Record_type__c();
        PWORFAllrecordtType.Name ='All';
        PWORFAllrecordtType.Record_type_id__c = allId;
        return PWORFAllrecordtType;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the PWORF RA record type
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_PWORF_Record_type__c createTest_PWORF_RA_recordtType(ID raId){

        CPA_PWORF_Record_type__c PWORFRArecordtType = new CPA_PWORF_Record_type__c();
        PWORFRArecordtType.Name ='RA';
        PWORFRArecordtType.Record_type_id__c = raId;
        return PWORFRArecordtType;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the LOI
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_LOIMandatoryMessages__c createTest_LOI_message(){

        CPA_LOIMandatoryMessages__c  LOIMsg= new CPA_LOIMandatoryMessages__c ();
        LOIMsg.Name ='16';
        LOIMsg.txt_FieldAPIName__c= 'num_Expense_charges_of_LOI__c';
        LOIMsg.txt_FieldLabel__c = 'Expense charges of LOI';
        LOIMsg.txt_Message__c = 'Mandatory';
        return LOIMsg;
        
    }
    
}