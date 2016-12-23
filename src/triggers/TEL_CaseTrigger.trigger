/**********************************************************************
Name: Case Trigger
Copyright © 2016 Unilever

Purpose:
Handler the action based on Case info. 

History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Ronaldo Garcia  05/12/2016  Trigger creation  
***********************************************************************/
trigger TEL_CaseTrigger on Case (after update) {

    // Check if is after 
    If(trigger.isAfter){        
        if(trigger.isUpdate){
			
            // Create telesales opportunity to approved cases from sample request. 		           
            TEL_TelesalesBO.getInstance().createOpp(trigger.new);
        }
    }
}