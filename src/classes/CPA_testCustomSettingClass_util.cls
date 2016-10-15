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
   /* public static CPA_PWORF_Record_type__c createTest_PWORF_All_recordtType(ID allId){

        CPA_PWORF_Record_type__c PWORFAllrecordtType = new CPA_PWORF_Record_type__c();
        PWORFAllrecordtType.Name ='All';
        PWORFAllrecordtType.Record_type_id__c = allId;
        return PWORFAllrecordtType;
        
    }*/
    /*******************************************************************
    Purpose: This method is used to set the PWORF RA record type
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    /*public static CPA_PWORF_Record_type__c createTest_PWORF_RA_recordtType(ID raId){

        CPA_PWORF_Record_type__c PWORFRArecordtType = new CPA_PWORF_Record_type__c();
        PWORFRArecordtType.Name ='RA';
        PWORFRArecordtType.Record_type_id__c = raId;
        return PWORFRArecordtType;
        
    }*/
    /*******************************************************************
    Purpose: This method is used to set the LOI
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
   /* public static CPA_LOIMandatoryMessages__c createTest_LOI_message(){

        CPA_LOIMandatoryMessages__c  LOIMsg= new CPA_LOIMandatoryMessages__c ();
        LOIMsg.Name ='16';
        LOIMsg.txt_FieldAPIName__c= 'num_Expense_charges_of_LOI__c';
        LOIMsg.txt_FieldLabel__c = 'Expense charges of LOI';
        LOIMsg.txt_Message__c = 'Mandatory';
        return LOIMsg;
        
    }
    */
    /*******************************************************************
    Purpose: This method is used to set SLA data
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_SLAConfiguration__c createTest_SLAdata(){

        CPA_SLAConfiguration__c sla = new CPA_SLAConfiguration__c();
        sla.Name ='Large Project';
        sla.DBTD_SLA2__c = '5';
        sla.Others_SLA1__c = '3';
        sla.Others_SLA2__c = '5';
        sla.PADBTD_SLA1__c = '3';
        sla.PADBTD_SLA2__c = '5';
        sla.PA_SLA1__c = '3';
        sla.PA_SLA2__c = '5';
        sla.RA_SLA1__c = '3';
        sla.RA_SLA2__c = '5';       
        return sla;
        
    }
}