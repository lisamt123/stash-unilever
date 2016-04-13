/**********************************************************************
Name:  AlertActionTriggerHelper 
Copyright ? 2013  Unilever
======================================================
======================================================
Purpose:  Helper for Alert Action trigger                                                
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
1.0 -   Vaishnavi       19/03/2015       INITIAL DEVELOPMENT     EmailTemplateValidation 
1.1 - Sathish/Mahendra  Jan - 2016       Chatter Update         Added Chatter related validation/Id Update
****************************************************************************/

public with sharing class CEC_AlertActionTriggerHelper {
    //Validate Email Template name
    public void checkEmailTemplate(List<cec_Alert_Action__c> newList){
        try{
            Map<String,EmailTemplate> emailTemplateMap= new Map<String,EmailTemplate>();
            List<String> namesString= new List<String>();
            for(cec_Alert_Action__c alertAction:newList){
                //Check for the Type as  'Chatter Post' Or 'Email'                
                if(alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_EMAIL)){                    
                    namesString.add(alertAction.Email_Template_Name__c);
                } else if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_CHATTER)){
                    namesString.add(alertAction.Chatter_Template_Name__c);
                }
            }
            List<EmailTemplate> templates = [Select Id, Name, IsActive, Folder.Name 
                                             From EmailTemplate 
                                             Where IsActive = true and Name IN: namesString];
            if(templates!=null && templates.size() > 0){
                for(EmailTemplate emailsT:templates){
                    emailTemplateMap.put(emailsT.Name,emailsT);
                }
            }
            
            //Checking all the alert actions
            EmailTemplate retrivedEmailTemplate = new EmailTemplate(); 
            for(cec_Alert_Action__c alertAction:newList){
                //Check for the Type as  'Chatter Post' Or 'Email'
                if(alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_EMAIL)) {
                    retrivedEmailTemplate=emailTemplateMap.get(alertAction.Email_Template_Name__c);
                    if(retrivedEmailTemplate==null && String.isNotEmpty(alertAction.Email_Template_Name__c)) {
                        //add error             
                        alertAction.addError(Label.CEC_ValidEmailTemplate + alertAction.Email_Template_Name__c); 
                    }
                } else if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_CHATTER)) {
                    retrivedEmailTemplate=emailTemplateMap.get(alertAction.Chatter_Template_Name__c);
                    if(retrivedEmailTemplate==null && String.isNotEmpty(alertAction.Chatter_Template_Name__c)) {
                        //add error             
                        alertAction.addError(Label.CEC_ValidChatterTemplate + alertAction.Chatter_Template_Name__c); 
                    } 
                }
            }
        }
        catch(Exception e){
            
        }
    }
    
    /******************************************************************* 
        Purpose: 
            Checks the Chatter group names and updates the SF id.
        Parameters: 
            alertActionList - ALert Action List to update the Chatter Group Id.
    ********************************************************************/
    public void updateChatterGroupid(List<cec_Alert_Action__c> alertActionList) {
        System.debug('Entering Method updateChatterGroupid. alertActionList = ' + alertActionList);        
        Set<String> chatterGroupNameSet = new Set<String>();
        
        // Get all the chatter names configured in the alert Action.
        for(cec_Alert_Action__c alertAction : alertActionList) {
            if(alertAction.Type__c == 'Chatter Post') {
                if(String.isNotBlank(alertAction.Country_Chatter_Group__c)) {
                    chatterGroupNameSet.add(alertAction.Country_Chatter_Group__c);
                } 
                if(String.isNotBlank(alertAction.Category_Chatter_Group__c)) {
                    chatterGroupNameSet.add(alertAction.Category_Chatter_Group__c);
                }   
            }
        }
        System.debug('Chatter Group Name Set = ' + chatterGroupNameSet);
        // Get the Chatter Groups and set the SF Id against each chatter group configured in the Alert Action.
        if(!chatterGroupNameSet.isempty()) {
            Map<String, Id> chatterGroupNameIdMap = new Map<String, Id>();
            for(CollaborationGroup chatterGroup : [ SELECT Id, Name 
                                                   FROM CollaborationGroup WHERE 
                                                   Name IN:chatterGroupNameSet]) {
                                                       
                                                       chatterGroupNameIdMap.put(chatterGroup.Name.toLowerCase(), chatterGroup.Id);                 
                                                   }
            for(cec_Alert_Action__c alertAction : alertActionList) {
                if(alertAction.Type__c == 'Chatter Post') {
                    // Update the Country Group Id for the group name. ELse set the Id to Empty value
                    if(String.isNotBlank(alertAction.Country_Chatter_Group__c)) {
                        validateAndUpdateAction(CEC_Constants.ALERT_ACTION_COUNTRYGROUP, 
                                                alertAction.Country_Chatter_Group__c, 
                                                alertAction, chatterGroupNameIdMap);
                    } else {
                        alertAction.Country_Chatter_Group_Id__c = '';
                    }
                    // Update the Category Group Id for the group name. ELse set the Id to Empty value
                    if(String.isNotBlank(alertAction.Category_Chatter_Group__c)) {
                        validateAndUpdateAction(CEC_Constants.ALERT_ACTION_CATEGORYGROUP, 
                                                alertAction.Category_Chatter_Group__c,
                                                alertAction, chatterGroupNameIdMap);
                    } else {
                        alertAction.Category_Chatter_Group_Id__c = '';
                    }    
                }   
            }       
        }
        System.debug('Exiting method updateChatterGroupid. alertActionList = ' + alertActionList);
    }
    
    /******************************************************************* 
        Purpose: 
            Checks the Chatter group names and updates the SF id.
        Parameters: 
            fieldType - Country/Category field.
            chatterGroupName - Chatter Group Name
            alertAction - Alert Action to update the chatter Id.
            chatterGroupNameIdMap - All the available chatter group name and its Id.
                    Key : Chatter Group Name
                    Id : SF id
    ********************************************************************/
    private void validateAndUpdateAction(String fieldType, String chatterGroupName, 
                                         cec_Alert_Action__c alertAction, Map<String, Id> chatterGroupNameIdMap) {
        System.debug('Entering method validateAndUpdateAction. alertAction = ' + alertAction);
        String lowerCaseGroupName = chatterGroupName.toLowerCase();
        if(chatterGroupNameIdMap.containsKey(lowerCaseGroupName)) {
            if (fieldType.equals(CEC_Constants.ALERT_ACTION_COUNTRYGROUP)) {
                alertAction.Country_Chatter_Group_Id__c = chatterGroupNameIdMap.get(lowerCaseGroupName);
            }
            if (fieldType.equals(CEC_Constants.ALERT_ACTION_CATEGORYGROUP)) {
                alertAction.Category_Chatter_Group_Id__c = chatterGroupNameIdMap.get(lowerCaseGroupName);
            }
        } else {
            alertAction.addError(Label.CEC_InvalidChatterGroupName + chatterGroupName);
        }
        System.debug('Exiting method validateAndUpdateAction. alertAction = ' + alertAction);
    }              
}