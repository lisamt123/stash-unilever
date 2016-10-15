/**
* Trigger Name: Core_CA_Line_Details_BI
* Author : Mindtree
* Date: 18 Sept 2014
* Requirement/Project Name: Unilever Salesforce Engagement
* Requirement/Description: Used to update Name with Expense_Type__c field for GTES And
*                          Line_Item_Number__c field for Ariba.
**/

trigger Core_CA_Line_Details_BI on Core_Approval_Details__c (Before Insert) {
   
    TriggerFactory.createHandler(Core_Approval_Details__c.sObjectType);
}