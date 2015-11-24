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
   
****************************************************************************/

public with sharing class CEC_AlertActionTriggerHelper {
    //Validate Email Template name
    public void checkEmailTemplate(List<cec_Alert_Action__c> newList){
        try{
        Map<String,EmailTemplate> emailTemplateMap= new Map<String,EmailTemplate>();
        List<String> namesString= new List<String>();
        for(cec_Alert_Action__c actionAction:newList){
            namesString.add(actionAction.Email_Template_Name__c);
        }
        List<EmailTemplate> templates = [Select Id, Name, IsActive, Folder.Name From EmailTemplate Where IsActive = true and Name IN: namesString];
        if(templates!=null && templates.size()>0){
        for(EmailTemplate emailsT:templates){
            emailTemplateMap.put(emailsT.Name,emailsT);
        }
        }
        
        //Checking all the alert actions
        EmailTemplate retrivedEmailTemplate= new EmailTemplate(); 
        for(cec_Alert_Action__c actionAction:newList){
                retrivedEmailTemplate=emailTemplateMap.get(actionAction.Email_Template_Name__c);
                if(retrivedEmailTemplate==null &&actionAction.Email_Template_Name__c != null ){
                    //add error             
                    actionAction.addError(Label.CEC_ValidEmailTemplate); 
            }
        }
        }
        catch(Exception e){
            
        }
    }
    
    

}