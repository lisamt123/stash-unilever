/**********************************************************************
Name: Core_WP_EmailService 
Copyright © 2015 Salesforce
Project:
-------
Unilever Salesforce Engagement

Purpose:
-------
For Workplace App

History
-------
VERSION AUTHOR   DATE       DETAIL               Description
1.0     Mindtree 26/11/2015 INITIAL DEVELOPMENT  Email Service class for Workplace App
***********************************************************************/

global with sharing class Core_WP_EmailService implements Messaging.InboundEmailHandler {
    
    /*******************************************************************
    Purpose: This method used to handle Email server response
    Parameters: Messaging.InboundEmail email, Messaging.Inboundenvelope envelope
    Returns: Messaging.InboundEmailResult
    ********************************************************************/ 
    global Messaging.InboundEmailResult handleInboundEmail(Messaging.InboundEmail email, Messaging.Inboundenvelope envelope) {
    
        Messaging.InboundEmailResult result = new Messaging.InboundEmailResult();
    
        //try {
            List<Attachment> lstAttachment=new List<Attachment>();
            Workplace__c workPlaceKingston=[SELECT Id FROM Workplace__c WHERE Name = 'Kingston'];
            Workplace__c workPlace100VE=[SELECT Id FROM Workplace__c WHERE Name = '100VE'];
            // Parse the subject of the email.
            Matcher kingstonMatcher = Pattern.compile('\\b.*(?i)Kingston.*\\b').matcher(email.subject);
            Matcher hundredveMatcher = Pattern.compile('\\b.*(?i)100ve.*\\b').matcher(email.subject);
            
            Boolean isKingston = kingstonMatcher.find();
            Boolean is100ve = hundredveMatcher.find();
             
           if (email.binaryAttachments != null && email.binaryAttachments.size() > 0) {
              for (integer i = 0 ; i < email.binaryAttachments.size() ; i++) {                  
                   if(email.binaryAttachments[i].filename.toLowerCase().startsWith('menu')){
                       Attachment attachment = new Attachment();
                       //attach to the workplace object
                       if(isKingston)
                       attachment.ParentId = workPlaceKingston.Id;//'a6vc000000008WzAAI';
                        
                       if(is100ve)
                       attachment.ParentId = workPlace100VE.Id;//'a6vc000000008YHAAY';
                      
                       system.debug('file name'+email.binaryAttachments[i].filename);
                       attachment.Name = email.binaryAttachments[i].filename;
                       attachment.Body = email.binaryAttachments[i].body;
                       lstAttachment.add(attachment);
                   }                   
              }
          }
        //}catch(Exception e){}
        if(!lstAttachment.isEmpty()) insert lstAttachment;
        
        return result;
  }
}