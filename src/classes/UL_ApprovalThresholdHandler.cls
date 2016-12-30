/***************************************************************
Name: UL_ApprovalThresholdHandler()
Copyright © 2016 Salesforce
==============================================================
Purpose:
Handler class for UL_ApprovalThresholdTrigger on Approval Threshold object
==============================================================
History
-------
VERSION: 1.0                                         
AUTHOR: Soumyodeep                   
DATE: 3/11/2016
DETAIL: INITIAL DEV
Description: Check to prevent duplicate record creation in this object.                                                            
***************************************************************/
Public with sharing Class UL_ApprovalThresholdHandler{

/*******************************************************************
Purpose: Check to prevent duplicate record creation in this object. 
Version 1.0
Parameters: trigger.new(list of type UL_Approval_Threshold__c)
Returns: N/A
Throws N/A
********************************************************************/
    public static void NewCareerLevel(list<UL_Approval_Threshold__c> CareerLevelList){
//Assumption - Always a single record shall be created from the UI.

        List<UL_Approval_Threshold__c> ApprovalThresholdList = [SELECT Id FROM UL_Approval_Threshold__c WHERE UL_Career_Level__c=:CareerLevelList[0].UL_Career_Level__c AND UL_Sales_Organization__c =:CareerLevelList[0].UL_Sales_Organization__c];
        If(ApprovalThresholdList.size() > 0){
            CareerLevelList[0].addError(Label.UL_SALES_ORG_DUPLICATE_CAREER_LEVEL); 
        } 
    }
    public static void UpdateCareerLevel(list<UL_Approval_Threshold__c> CareerLevelList){
//Assumption - Always a single record shall be created from the UI.

        List<UL_Approval_Threshold__c> ApprovalThresholdList = [Select id FROM UL_Approval_Threshold__c WHERE UL_Career_Level__c=:CareerLevelList[0].UL_Career_Level__c AND UL_Sales_Organization__c =:CareerLevelList[0].UL_Sales_Organization__c AND Id!=:CareerLevelList[0].Id];
        If(ApprovalThresholdList.size() > 0){
            CareerLevelList[0].addError(Label.UL_Approval_Threshold_duplicate_error_message); 
        } 
    }
}