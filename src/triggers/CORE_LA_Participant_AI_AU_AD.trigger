/**
* Trigger Name: CORE_LA_Participant_AI_AU_AD
* Author : Mindtree
* Date: 12 Feb 2017
* Requirement/Project Name: Unilever Salesforce Engagement
* Requirement/Description: 1) Used to Notify Admin
*                          2) Used to give access to specific users - Apex sharing
*                          3) Used for Entity Subscription
**/

trigger CORE_LA_Participant_AI_AU_AD on CORE_LA_Participant__c (After Insert,After Update,After Delete) {

    Core_LA_Participant_Handler participantHandler = new Core_LA_Participant_Handler();
    
    //Used to give access to specific users - Apex sharing & Entity Subscription
    if (Trigger.isAfter && Trigger.isinsert)
        participantHandler.handleAfterInsert(Trigger.new);
    
    //Used for Trigger notification for Admin
    if (Trigger.isAfter && Trigger.isupdate)        
        participantHandler.handleAfterUpdate(Trigger.new,Trigger.old);
            
    if (Trigger.isAfter && Trigger.isdelete)
        participantHandler.handleAfterDelete(Trigger.old);
        
}