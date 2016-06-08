/**********************************************************************
 Name:  CEC_Alert_Action 
 Copyright ? 2013  Unilever
 ======================================================
======================================================
Purpose:  Common Trigeer on Alert action objects for all events                                                
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Vaishnavi       19/03/2015       INITIAL DEVELOPMENT     EmailTemplateValidation 
   
****************************************************************************/
trigger CEC_Alert_Action on cec_Alert_Action__c (before insert, before update) {
// Validate Email Templates for email template name is existing or not
        CEC_AlertActionTriggerHelper alertActions= new CEC_AlertActionTriggerHelper();
        alertActions.checkEmailTemplate(trigger.new);
        alertActions.updateChatterGroupid(trigger.new);
        //alertActions.checkPopupLabel(trigger.new);
        
}