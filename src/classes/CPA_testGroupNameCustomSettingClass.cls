/**********************************************************************
Name: CPA_testGroupNameCustomSettingClass ()
Copyright © 2015 Salesforce
======================================================
======================================================
Purpose: This Class is used to get custom setting values
-------
======================================================
======================================================
History
-------
VERSION     AUTHOR             DATE            DETAIL Description
1.0         Name     16/03/2016     INITIAL DEVELOPMENT CSR:
***********************************************************************/
public with sharing class CPA_testGroupNameCustomSettingClass {
/*******************************************************************
    Purpose: This method is used to set the name of groups
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Group__c createTest_CPA_Group(){

        CPA_Group__c groupName = new CPA_Group__c();
        groupName.Name ='SMT';
        groupName.CPA_Group_Name__c = 'CPA_SMT';        
        return groupName;
        
    }
    /*******************************************************************
    Purpose: This method is used to set the name of groups
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Group__c createTest_CPA_GroupULPM(){

        CPA_Group__c groupNameULPM = new CPA_Group__c();
        groupNameULPM.Name ='ULPM';
        groupNameULPM.CPA_Group_Name__c = 'CAP_ULPM';        
        return groupNameULPM;
        
    }
}