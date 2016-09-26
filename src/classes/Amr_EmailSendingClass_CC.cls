/*
    This class is used for sending emails
*/

public with sharing Class Amr_EmailSendingClass_CC{
  
  
    
/*
    Method used for sending emails
*/    
    
    public static void emailSending(String whatId, List<String> userEmail, String developerNameString){
               
        try{
            Id emailTemplate = [select Id from EmailTemplate where developerName = :developerNameString].id;
            Contact tempContact = new Contact();
            tempContact.LastName = 'Unilever Temporary Contact';
            tempContact.email = 'Advertising.Production@unilever.com';
            insert tempContact;
              
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage(); 
           /* 
            if(!attachmentId.IsEmpty()){
             mail.setDocumentAttachments(attachmentId);
            }
             */           
            mail.setTemplateId(emailTemplate);
            mail.setTargetObjectId(tempContact.id);
            mail.setWhatId(whatID);
            mail.setTreatTargetObjectAsRecipient(false);
            mail.setToAddresses(userEmail);
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
            
            delete tempContact;
       }
       catch(Exception ex){
           System.debug('Exception -> '+ ex.getmessage());
       }
      
    }

}