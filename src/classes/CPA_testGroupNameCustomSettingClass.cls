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
        groupName.CPA_Group_Name__c = 'CPA SMT';        
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
        groupNameULPM.CPA_Group_Name__c = 'CPA ULPM';        
        return groupNameULPM;
        
    }
}