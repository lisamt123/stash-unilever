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
    /*******************************************************************
    Purpose: This method is used to set the Commercials Threshold
    Parameters: 
    Returns: 
    Throws [Exceptions]: 
    ********************************************************************/
    public static CPA_Commercials_Threshold__c createTest_CPA_Commercials_Threshold(){

        CPA_Commercials_Threshold__c Commercials_Threshold = new CPA_Commercials_Threshold__c();
        Commercials_Threshold.Name ='Large Project';
        Commercials_Threshold.DBTD_Est_Off__c = '33';
        Commercials_Threshold.DBTD_Est_On__c = '33';
        Commercials_Threshold.DBTD_Expense_perc__c = '33';
        Commercials_Threshold.Others_Est_Off__c = '33';
        Commercials_Threshold.Others_Est_On__c = '33';
        Commercials_Threshold.Others_Expense_Perc__c = '33';
        Commercials_Threshold.PADBTD_Est_Off__c = '33';
        Commercials_Threshold.PADBTD_Est_On__c = '33';
        Commercials_Threshold.PADBTD_Expense_Perc__c = '33';
        Commercials_Threshold.PA_Est_Off__c = '33';
        Commercials_Threshold.PA_Est_On__c = '33';
        Commercials_Threshold.PA_Expense_Perc__c = '33';
        Commercials_Threshold.RA_Est_Off__c = '33';
        Commercials_Threshold.RA_Est_On__c = '33';
        Commercials_Threshold.RA_Expense_Perc__c  = '33';      
        return Commercials_Threshold;
        
    }
}