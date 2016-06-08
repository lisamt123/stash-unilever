/**********************************************************************
Name:  CEC_TH1_DraftTrigger()
Copyright ? 2016  Unilever
======================================================
======================================================
Purpose:  Auto generate draft after it is approved                                               
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
1.0 -   Masood Ansari       14/01/2016       INITIAL DEVELOPMENT     Generate draft without without clicking on generate 
button after the draft is approved.
****************************************************************************/

trigger CEC_TH1_DraftTrigger on TH1__Draft__c (after update) {
    
    String draftsId;
    
    for(TH1__Draft__c drafts : Trigger.New){
        System.debug('********* DRAFT TRIGGER before = ' + drafts);
        draftsId =drafts.Id;        
        if(drafts.TH1__Status__c == 'Approved'){
            if(!test.isrunningtest()) 
                th1.GLOBAL_API_V1.finaliseDraftFuture(draftsId);
        }
        System.debug('********* DRAFT TRIGGER after = ' + drafts);    
    }       
}