/***************************************************************
Name: UL_User_Extention_Controller()
Copyright © 2015 Salesforce
======================================================
Purpose:
Controller for UL_User_Career_Level VisualForce page.
======================================================
History
-------
VERSION: 1.0                                         
AUTHOR: Soumyodeep                   
DATE: 25/10/2016
DETAIL: INITIAL DEV
Description: Page loads the user with the same career level and Sales org as per the as per the Approval Threshold Record.                                                            
***************************************************************/
    public with sharing class UL_User_Extention_Controller{
    public list<user> userlist{set;get;}
    Id approvalThresholdId {get; set;}
	
	/*******************************************************************
	Purpose: Controller constructor 
	Version 1.0
	Parameters: N/A
	Returns: N/A
	Throws N/A
	********************************************************************/
    public UL_User_Extention_Controller(ApexPages.StandardController stdController){
    	approvalThresholdId = ((UL_Approval_Threshold__c)stdController.getRecord()).Id;
    }
    
	/*******************************************************************
	Purpose: Method to search for the user with the same Career level and Sales Org and then return it to the Vf Page. 
	Version 1.0
	Parameters: N/A
	Returns: N/A
	Throws N/A
	********************************************************************/
    public void initPage(){
        try{
	        UL_Approval_Threshold__c  approvalThreshold = [select id,UL_Career_Level__c,UL_Sales_Organization__r.Name  from UL_Approval_Threshold__c where id=:approvalThresholdId LIMIT :(Limits.getLimitQueryRows()-Limits.getQueryRows())];
	        userlist = [Select Name,UL_Career_Level__c, ACCL__Sales_Org__c from User where UL_Career_Level__c=:approvalThreshold.UL_Career_Level__c And ACCL__Sales_Org__c=:approvalThreshold.UL_Sales_Organization__r.Name LIMIT:(Limits.getLimitQueryRows()-Limits.getQueryRows())];
        }catch(Exception ex){
            UL_Utility.logError(ex, UserInfo.getUserId());
        }
    }
}