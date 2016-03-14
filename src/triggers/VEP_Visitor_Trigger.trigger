/**********************************************************************
Name: VEP_Visitor_Trigger

Purpose:This Trigger is used to populate the travel, lodging, pickup desk emails
        on VEP records dynamically from custom settings

History
-----
VERSION   AUTHOR   DATE        DETAIL 
1.0       Leena    Jan-2016    INITIAL DEVELOPMENT  
***********************************************************************/
trigger VEP_Visitor_Trigger on Vep_Visitor__c (before insert,before update,after insert,before delete,after undelete, after update,after delete) {
    TriggerFactory.createHandler(VEP_Visitor__c.sObjectType);  
}