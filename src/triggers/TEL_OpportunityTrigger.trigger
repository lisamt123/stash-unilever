/**********************************************************************
Name: Opportunity Trigger
Copyright © 2016 Unilever

Purpose:
Handler the action based on Case info. 

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  27/12/2016  Trigger creation  
***********************************************************************/
trigger TEL_OpportunityTrigger on Opportunity (after update) {
    // Check if it is after 
    If(trigger.isAfter){        
        if(trigger.isUpdate){
            // Create telesales opportunity to approved cases from sample request. 		           
            TEL_TelesalesBO.getInstance().createOppLog(trigger.new, trigger.old);
        }
    }
}