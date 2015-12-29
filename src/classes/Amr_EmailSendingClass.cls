public with sharing Class Amr_EmailSendingClass{

    
    public static void rapEmailSending(String whatId, String userEmail){
    
          Contact tempContact = new Contact();
          tempContact.LastName = 'Temporary Contact';
          tempContact.email = 'utkarsh.nnmm@gmail.com';
          insert tempContact;
          
          Id emailTemplate = [select Id from EmailTemplate where developerName = 'Amr_RAPAcceptedJob'].id;
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          
          mail.setTemplateId(emailTemplate);
          mail.setTargetObjectId(tempContact.id);
          mail.setWhatId(whatID);
          mail.setTreatTargetObjectAsRecipient(false);
          mail.setToAddresses(new String[] {userEmail});
          System.debug('Class -> '+ whatId);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    
     public static void rapJobAllocation(String whatId, List<String> userEmail){
    
          Contact tempContact = new Contact();
          tempContact.LastName = 'Temporary Contact';
          tempContact.email = 'utkarsh.nnmm@gmail.com';
          insert tempContact;
          System.debug('Email ->' + userEmail);
          Id emailTemplate = [select Id from EmailTemplate where developerName = 'Amr_RAPAllocatedJob'].id; 
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          mail.setTemplateId(emailTemplate);
          mail.setTargetObjectId(tempContact.id);
          mail.setWhatId(whatID);
          mail.setTreatTargetObjectAsRecipient(false);
          mail.setToAddresses(userEmail);
          System.debug('Class -> '+ whatId);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    public static void jobCancellationEmail(String whatId, List<String> toEmail){
    
          Contact tempContact = new Contact();
          tempContact.LastName = 'Temporary Contact';
          tempContact.email = 'utkarsh.nnmm@gmail.com';
          insert tempContact;
          
          Id emailTemplate = [select Id from EmailTemplate where developerName = 'Amr_JobCancellation'].id;
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          
          mail.setTemplateId(emailTemplate);
          mail.setTargetObjectId(tempContact.id);
          mail.setWhatId(whatID);
          mail.setTreatTargetObjectAsRecipient(false);
          mail.setToAddresses(toEmail);
          System.debug('Class -> '+ whatId);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }
    
    
    public static void jobShared(String whatId, List<String> userEmail){
    
          Contact tempContact = new Contact();
          tempContact.LastName = 'Temporary Contact';
          tempContact.email = 'utkarsh.nnmm@gmail.com';
          insert tempContact;
          
          Id emailTemplate = [select Id from EmailTemplate where developerName = 'Amr_RAPSharedJob'].id;
          Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
          
          mail.setTemplateId(emailTemplate);
          mail.setTargetObjectId(tempContact.id);
          mail.setWhatId(whatID);
          mail.setTreatTargetObjectAsRecipient(false);
          mail.setToAddresses(userEmail);
          System.debug('Class -> '+ whatId);
          Messaging.sendEmail(new Messaging.SingleEmailMessage[] {mail});
    }

}