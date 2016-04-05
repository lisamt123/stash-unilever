/**********************************************************************
Name: CPA_Test_Req_Deli_and_Key_Contacts_util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This is the util class of rest of the test classes.
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR       DATE            DETAIL Description
1.0      Pooja Kanani   01/01/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_Test_Req_Deli_and_Key_Contacts_util {
	/*******************************************************************
    Purpose: This method is used to set the after attachment trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_Key_ContactsTriggerPattern(){

        CPA_Trigger_Pattern__c Key_ContactsTriggerPattern = new CPA_Trigger_Pattern__c();
        Key_ContactsTriggerPattern.Name ='CPA_Key_Contact_Trigger';
        Key_ContactsTriggerPattern.chk_Check_Run__c = true;
        return Key_ContactsTriggerPattern;
        
    }
	/*******************************************************************
    Purpose: This method is used to set the after attachment trigger pattern
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Trigger_Pattern__c createTest_Req_DeliTriggerPattern(){

        CPA_Trigger_Pattern__c Req_DeliTriggerPattern = new CPA_Trigger_Pattern__c();
        Req_DeliTriggerPattern.Name ='CPA_Requirements_and_Deliverables';
        Req_DeliTriggerPattern.chk_Check_Run__c = true;
        return Req_DeliTriggerPattern;
        
    }		
}