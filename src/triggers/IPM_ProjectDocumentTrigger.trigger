/* ------------------------------------------------------------------------------------------------------------------
   Name:           ipmProjectDocumentTrigger
   Developed By:   Cognizant (Kannan, Samrat)
   Description:    Handle All events on Project Gate Documents
   
   Change History:
   17/02/2015    Vipul    Moved Logic to Handler Class
--------------------------------------------------------------------------------------------------------------------- */

trigger IPM_ProjectDocumentTrigger on IPM_Project_Document__c (after update) {
    ipmProjectDocumentTriggerHandler handler = new ipmProjectDocumentTriggerHandler();

    if(System.Trigger.isBefore){

    }else if(System.Trigger.isAfter){
        if(System.Trigger.isUpdate){
            handler.processAfterUpdate(trigger.new,'Trigger');
        }
    }
}