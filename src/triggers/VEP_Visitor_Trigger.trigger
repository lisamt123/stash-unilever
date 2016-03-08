/**********************************************************************
Name: vep_PopulateRelatedEmails

Purpose:This Trigger is used to populate the travel, lodging, pickup desk emails
        on VEP records dynamically from custom settings

History
-----
VERSION   AUTHOR   DATE        DETAIL 
1.0       Leena    Jan-2016    INITIAL DEVELOPMENT  
***********************************************************************/
trigger VEP_Visitor_Trigger on Vep_Visitor__c (before insert,before update,after insert) {
   
    if(trigger.isBefore && trigger.IsInsert){
        VEP_Visitor_TriggerHandler.VEP_UpdateFactory(Trigger.new);            
    }
   
   
    if(trigger.isBefore ){
        VEP_Visitor_TriggerHandler.vep_populateDeskEmails(Trigger.new,Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);    
    }
   
    if(trigger.isAfter && trigger.isInsert){
        VEP_Visitor_TriggerHandler.vep_generatePassOnBehalf(Trigger.new);    
    }
}