/**********************************************************************
Name: VEP_Visitor_Trigger
Copyright © 2016 Unilever
============================================================================
============================================================================
Purpose:This Trigger is used to popuklate the travel, lodging, pickup desk emails
on VEP records dynamically from custom settings
============================================================================
============================================================================
History
-----
VERSION   AUTHOR   DATE    
1.0       Leena    Jan-2016   
***********************************************************************/
trigger VEP_Visitor_Trigger on Vep_Visitor__c (before insert,before update,after insert) {
    //Populate Factory Manager details
    if(trigger.isBefore && trigger.IsInsert){
        VEP_Visitor_TriggerHandler.VEP_UpdateFactory(Trigger.new);            
    }
    //populate travel, lodging, pickup desk emials from custom settings
   
    if(trigger.isBefore ){
        VEP_Visitor_TriggerHandler.vep_populateDeskEmails(Trigger.new,Trigger.oldMap,Trigger.isInsert,Trigger.isUpdate);    
    }
    //visitor pass is generated automatically for request on behalf
    if(trigger.isAfter && trigger.isInsert){
        VEP_Visitor_TriggerHandler.vep_generatePassOnBehalf(Trigger.new);    
    }
}