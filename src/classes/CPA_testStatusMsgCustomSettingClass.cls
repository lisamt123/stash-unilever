public with sharing class CPA_testStatusMsgCustomSettingClass {
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
    Purpose: This method is used to set the status messages (READYTOSUBMIT) of various objects
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Status_Msg__c createTest_READYTOSUBMIT(){

        CPA_Status_Msg__c CancelMsg = new CPA_Status_Msg__c();
        CancelMsg.Name ='READYTOSUBMIT';
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
    Purpose: This method is used to set the Query trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_QueryTriggerPattern(){

        CPA_Trigger_Pattern__c QueryTriggerPattern = new CPA_Trigger_Pattern__c();
        QueryTriggerPattern.Name ='CPA_Queries';
        QueryTriggerPattern.chk_Check_Run__c = true;
        return QueryTriggerPattern;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the Query comment trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_Query_commentTriggerPattern(){

        CPA_Trigger_Pattern__c Query_commentTriggerPattern = new CPA_Trigger_Pattern__c();
        Query_commentTriggerPattern.Name ='CPA_Query_comment';
        Query_commentTriggerPattern.chk_Check_Run__c = true;
        return Query_commentTriggerPattern;
        
    }
}