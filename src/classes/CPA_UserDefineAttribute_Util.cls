/**********************************************************************
Name: CPA_UserDefineAttribute_Util()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to perform operation on before update event of User Define Attribute
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR     DATE            DETAIL Description
1.0         Name       21/04/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_UserDefineAttribute_Util{
    /*******************************************************************
    Purpose: This method is used to get the unique set of ID and attribute type
    Parameters:  newUDAist
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/ 
    public static void duplicateAttribute(List<CPA_User_Defined_Attribute__c > newUDAist)    
    { 
        for(CPA_User_Defined_Attribute__c uda :newUDAist){ 
            uda.Unique_value__c = uda.pkl_Attribute_Type__c + uda.lkp_CR__c + uda.lkp_HLE_Request__c + uda.lkp_LOI__c + uda.lkp_PWO__c + uda.lkp_PWORF__c;
        }
    }
}