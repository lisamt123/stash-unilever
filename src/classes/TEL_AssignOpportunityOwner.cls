/**********************************************************************
Name: TEL_AssignOpportunityOwner
Copyright © 2016 Unilever
======================================================
Purpose: Assign the opportunity owner to the currenty user from the
telesales team.

History 
VERSION AUTHOR 				DATE 		DETAIL Description
1.0 	Ronaldo Garcia  	27/12/2016  Class Creation
***********************************************************************/
public with sharing class TEL_AssignOpportunityOwner {

    @AuraEnabled
    public static String assignOppOwner(Id paramOppId){

        try{
			// Create a copy of opportunity target to be assigned. 
            Opportunity opp = [Select Id From Opportunity Where Id =: paramOppId LIMIT 1];
            
            // Get the current user Id to be set on Opportunity. 
            Id ownerId 		= System.UserInfo.getUserId(); 
            
            // Apply the opportunity owner. 
            opp.OwnerId 	= ownerId;

            database.update(opp);
        }
        catch(Exception e){
            return e.getMessage();
        }
        
        // On success, return a message. 
        return Label.TEL_Assign_Owner_Message;
    }
}