/**
* Trigger Name: Core_CA_Header_BI_AI_AU
* Author : Mindtree
* Date: 17 Sept 2014
* Requirement/Project Name: Unilever Salesforce Engagement
* Requirement/Description: 1) Used to update Record Type Id with Selected Source System and
*                          Name with External System before inserting  
*                          2) Used to give access to specific users - Apex sharing
*                          3) Used for Trigger notification for GTES System
*    
*/
trigger Core_CA_Header_BI_AI_AU on Core_Approval_Header__c (Before Insert,After Insert,After Update) {
    
    Core_CA_Header_Handler headerHandler=new Core_CA_Header_Handler();
    //Used to update Record Type Id with Selected Source System and Name with External System before inserting
    if (Trigger.isbefore && Trigger.isinsert)
        headerHandler.handleBeforeInsert(Trigger.new);
    
    //Used to give access to specific users - Apex sharing
    if (Trigger.isafter && Trigger.isinsert)
        headerHandler.handleAfterInsert(Trigger.new);
   
    //Used for Trigger notification for GTES & Ariba System
    if(Trigger.isafter && Trigger.isupdate)
        headerHandler.handleAfterUpdate(Trigger.newMap,Trigger.oldMap);
                
       
        
}