public with sharing class FAU_EmailHandler {
    
    Public Static List<FAU_Email__c> emailtosend = new List<FAU_Email__c>();
    Public Static List<String> emid = new List<String>();
    Public Static List<String> ToAddress = new List<String>();
    Public Static List<String> CCAddress = new List<String>();
    Public Static List<String> AdditionalTo = new List<String>();
    public Static String FromAddresses = 'Chief.Learning.Officer@unilever.com';
    Public Static Messaging.SingleEmailMessage message;
    Public Static Messaging.SendEmailResult[] results;
    Public  Static Messaging.SingleEmailMessage[] messages;
    Public Static Set<String> TriggerId = new Set<String>();
    PRIVATE STATIC FINAL String EMAILSPLIT = ',';
       
    Public Static Void sendEmail(List<FAU_Email__c> send){
    System.debug('Hi Tja'+send);
        message = new Messaging.SingleEmailMessage();
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address =: FromAddresses];
         
            if ( owea.size() > 0 ) {
                message.setOrgWideEmailAddressId(owea.get(0).Id);
            }
            For(FAU_Email__c em:Send ){
            system.debug('hi****'+em.id);
                emid.add(em.id);
                system.debug('hi****'+emid);
            }
            emailtosend = new List<FAU_Email__c>();
            emailtosend  = [Select id,FAU_Additional_To__c,FAU_Body__c,FAU_CC__c,FAU_To_Address__c,From_Address__c,FAU_Subject__c from FAU_Email__c where Id IN : emid ];
            
        For(FAU_Email__c e: emailtosend ){
        
                       
            If(e.FAU_Send_Email__c = TRUE){
            
                ToAddress = e.FAU_To_Address__c.Split(EMAILSPLIT);
                system.debug('+++++++++To Address++++++++++'+ToAddress);
                 List<String> TempToEmails= new  List<string>();
                if(e.FAU_Additional_To__c!=null)
                {
                    AdditionalTo= e.FAU_Additional_To__c.split(EMAILSPLIT);
                    if(AdditionalTo.size()>0){
                        TempToEmails.addAll(AdditionalTo);
                    }
                    ToAddress.AddAll(TempToEmails);
             
                }
                system.debug('+++++++++To Address All++++++++++'+ToAddress);
                if(e.FAU_CC__c!=null)
                {
                    if(  e.FAU_CC__c.length()>0 && !String.isBlank(e.FAU_CC__c)){
                    CCAddress = e.FAU_CC__c.Split(EMAILSPLIT);
                    }
                    else{
                    CCAddress.add(e.FAU_CC__c);
                    }
                }
              //  CCAddress = e.FAU_CC__c.Split(EMAILSPLIT);
                system.debug('+++++++++CC Address All++++++++++'+CCAddress);
                message.setToAddresses(ToAddress);
                if(CCAddress!=null)
                {
                 message.setCcAddresses(CCAddress);
                }
               
                message.setsubject(e.FAU_Subject__c);
                message.setHtmlBody(e.FAU_Body__c);
                messages = new List<Messaging.SingleEmailMessage> {message};
            }
        }
        
        results = Messaging.sendEmail(messages);
        
        system.debug('++++++++++++Email Result++++++++++++'+results);
       
            system.debug('+++++++++++Result Success++++++++++');
        
        
    }
    
    
}