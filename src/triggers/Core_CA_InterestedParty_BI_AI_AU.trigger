/**
* Trigger Name: Core_CA_InterestedParty_BI_AI_AU
* Author : Mindtree
* Date: 18 Sept 2014
* Requirement/Project Name: Unilever Salesforce Engagement
* Requirement/Description: 1) Used to update Name with Role__c field
*                          2) Used to give access to specific users - Apex sharing
*                          3) Used for Trigger notification for GTES System
**/

trigger Core_CA_InterestedParty_BI_AI_AU on Core_Approver_Details__c (Before Insert,After Insert,After Update,After Delete) {

    Core_CA_InterestedParty_Handler approverHandler=new Core_CA_InterestedParty_Handler();
    
    //Used to update Name with Role__c field
    if (Trigger.isBefore && Trigger.isinsert)     
        approverHandler.handleBeforeInsert(Trigger.new);
    
    //Used to give access to specific users - Apex sharing and Trigger notification for GTES System
    if (Trigger.isAfter && Trigger.isinsert)
        approverHandler.handleAfterInsert(Trigger.new);
    
    //Used for Trigger notification for GTES System
    if (Trigger.isAfter && Trigger.isupdate)        
        approverHandler.handleAfterUpdate(Trigger.newMap,Trigger.oldMap);
            
    if (Trigger.isAfter && Trigger.isdelete)
        approverHandler.handleAfterDelete(Trigger.old);
        
}