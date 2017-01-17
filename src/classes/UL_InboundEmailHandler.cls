global class UL_InboundEmailHandler implements Messaging.InboundEmailHandler {
public final static String APPROVE = 'approve' ;
public final static String REJECT = 'reject' ;

    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.InboundEnvelope envelope) {
        Messaging.InboundEmailResult result = new Messaging.InboundEmailresult();
        List<ACCL__Promotion__c> promoLst = new List<ACCL__Promotion__c>() ;
        List<ACCL__Promotion__c> updPromoLst = new List<ACCL__Promotion__c>() ;
        String body = email.plainTextBody ;
        system.debug('body '+body) ;
        String subject = email.subject ;
        system.debug('subject '+subject) ;

        Integer promoNameIndex = subject.indexOf('P-') ;
        system.debug('promoNameIndex '+promoNameIndex) ;
        String promoName = subject.substring(promoNameIndex, promoNameIndex+10) ;
        system.debug('promoName '+promoName) ;

        promoLst = [SELECT Id, Name, CreatedById,createdby.UL_Finance_Manager__c,UL_Current_Status__c,UL_ThresholdViolated__c, UL_Finance_Check_Approvers__c,UL_Manager_Check_Approvers__c,ACCL__Date_From__c,ACCL__Date_Thru__c,ACCL__Promotion_Template__r.UL_Approval_Process_Identifier__c, ACCL__Sales_Org__c, ACCL__Active__c 
        FROM ACCL__Promotion__c WHERE Name =: promoName] ;
        system.debug('promoLst '+promoLst) ;

        /*for(ACCL__Promotion__c promo : promoLst){
          promo.UL_Free_Text__c = 'test'+system.now() ;
          updPromoLst.add(promo) ;
        }
        update updPromoLst ;
        */
        
        if(body.containsIgnoreCase(APPROVE)){
          UL_PromotionWorkflowService.approveWorkflow(promoLst[0].Id, promoLst,promoLst[0].UL_Current_Status__c,true) ;
        }
        if(body.containsIgnoreCase(REJECT)){
          UL_PromotionWorkflowService.rejectWorkflow(promoLst[0].Id, promoLst, true) ;
        }

        return result;
    }
}