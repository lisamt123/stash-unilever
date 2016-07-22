/**********************************************************************
Name:  CEC_RetrievalRequestTrigger
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: Trigger for Retrieval_Request__c

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Goverdhan S.       Apr-2016      INITIAL DEVELOPMENT

***********************************************************************/
trigger CEC_RetrievalRequestTrigger on CEC_Retrieval_Request__c (before Update) {
    
    if(trigger.isbefore && trigger.isUpdate && CEC_retrievalrequestTriggerhelper.executeBeforeUpdateTrigger){
        //recursion control
        CEC_retrievalrequestTriggerhelper.executeBeforeUpdateTrigger = false;
        // send Factory emails
        CEC_retrievalrequestTriggerhelper triggerHelper = new CEC_retrievalrequestTriggerhelper();
        triggerHelper.sendFactoryEmail(trigger.newmap, trigger.oldmap);
    }
    
}