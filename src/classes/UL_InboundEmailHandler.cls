/***************************************************************
Name: UL_InboundEmailHandler
Copyright © 2016 Accenture
======================================================
Purpose:
Utility class for processing inbound emails related to Approval Process (functionally known as Workflow)
======================================================
History
-------
VERSION     AUTHOR        DATE           DETAIL                 Description
1.0         Badri         1/1/2016      INITIAL DEV            
***************************************************************/
global without sharing class UL_InboundEmailHandler implements Messaging.InboundEmailHandler {    
    //class level variables
    public final static String APPROVE = 'approve' ;
    public final static String REJECT = 'reject' ;
    public final static String STR_YES = 'yes' ;
    public final static String STR_NO = 'no' ;
    public final static String PROM_NAME_FORMAT = 'P-' ; 
    public final static String ENTER_CHAR = '\n' ;  
    /*******************************************************************
    Purpose: 1. Processes inbound email body, looks for Promotion Name using string functions, queries DB with the promotion Name.
            2.  Uses string functions to look for Approve/Reject in the email body, calls respective function to approve/reject the Workflow.
            3. Approve/Reject terms accepted - approve,yes,reject,no 
    Version 1.0
    Parameters: Messaging.InboundEmail, Messaging.InboundEnvelope  
    Returns: Messaging.InboundEmailResult
    Throws : N/A 
    ********************************************************************/ 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {        
        //function variables
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();       
        List<ACCL__Promotion__c> promoLst = new List<ACCL__Promotion__c>() ;
        
        try{        
            //fetch email body
            String body = email.plainTextBody ;
            system.debug('body '+body) ;
            //fetch email subject
            String subject = email.subject ;
            system.debug('subject '+subject) ;
            //fetch Promotion Name from email subject
            Integer promoNameIndex = subject.indexOf(PROM_NAME_FORMAT) ;
            system.debug('promoNameIndex '+promoNameIndex) ;
            String promoName = subject.substring(promoNameIndex, promoNameIndex+10) ;
            system.debug('promoName '+promoName) ;
            
            //fetch promotion details from DB with Promotion Name
            promoLst = [SELECT UL_PromotionTemplateType__c, UL_Threshold_Window_Result__c,Id, Name, CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c, UL_Finance_Check_Approvers__c,UL_Manager_Check_Approvers__c,ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c, ACCL__Active__c, ACCL__Promotion_Template__c 
            FROM ACCL__Promotion__c WHERE Name =: promoName LIMIT 1] ;
            system.debug('promoLst '+promoLst) ;        
            
            /*get: 1. 1st line from email body - which would give Approve/Reject
            2. 2nd line from email body - which would give approval/rejection comments.*/
            String[] myStrings = new String[2]; 
            myStrings = body.split(ENTER_CHAR);
            body = myStrings[0] ;
            String comments = myStrings[1] ;
            
            //if email response is approve, call respective function of UL_PromotionWorkflowService class to approve the Workflow.
            if(body.containsIgnoreCase(APPROVE) || body.containsIgnoreCase(STR_YES)){
                UL_PromotionWorkflowService.approveWorkflow(promoLst[0].Id, promoLst,promoLst[0].UL_Current_Status__c,true) ;
                //update comments
                ACCL__Promotion__c promoObj = new ACCL__Promotion__c() ;
                promoObj.id = promoLst[0].id ;
                promoObj.UL_Free_Text__c = comments ;
                update promoObj ;
            }
            
            //if email response is reject, call respective function of UL_PromotionWorkflowService class to reject the Workflow.
            if(body.containsIgnoreCase(REJECT) || body.containsIgnoreCase(STR_NO)){
                UL_PromotionWorkflowService.rejectWorkflow(promoLst[0].Id, promoLst, true) ;
                //update comments
                ACCL__Promotion__c promoObj = new ACCL__Promotion__c() ;
                promoObj.id = promoLst[0].id ;
                promoObj.UL_Free_Text__c = comments ;
                update promoObj ;
            }
        }
        catch(Exception ex){
            throw ex;
            UL_Utility.logError(ex, UserInfo.getUserId());
        }        
        return result; //
    }
}