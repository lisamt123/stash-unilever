/********************************************************************
 Name:  FAU_EmailSender()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles Email rouitnes like mass email and ICS functionality                                                    
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
public without sharing class FAU_EmailSender {
	//Constructor
    public FAU_EmailSender()
	{
		
	}  

    /*******************************************************************
       Purpose:     Send Email to Webparticipants (with Meeting Request)
    ********************************************************************/
    public static void sendInvitationToWebParts(FAU_Webinar_Participant__c[] lWebPart)
    {

        List<FAU_Webinar_Participant__c> lWebPartFull = [select id, FAU_Participant__r.FAU_User__c, FAU_Participants_Email__c, 
                                                        FAU_Participant_PA_s_Email__c,  
                                                        FAU_Participant__r.FAU_Is_deferred_To_PA__c,
                                                        FAU_Participant__r.FAU_Program_Wave__r.Name,
                                                        FAU_Start_Time__c,
                                                        FAU_End_Time__c,
                                                        FAU_URL__c,
                                                        FAU_URL_Text__c,
                                                        FAU_Webinar__r.FAU_Description__c
                                                        from FAU_Webinar_Participant__c where Id= :lWebPart];

        Id idtemplate = [SELECT Id FROM EmailTemplate WHERE DeveloperName = :Label.FAU_Webinar_Invitation_Template LIMIT 1].Id;


        Id[] lUserId =new Id[]{}; 
        Id[] lWhatId =new Id[]{}; 
        String[] lUserEmail = new String[]{};  
        Datetime[] lDtStart = new Datetime[]{}; 
        Id[] lTemplateId = new Id[]{};
        Datetime[] lDtEnd = new Datetime[]{}; 
        String[] lLocation = new String[]{}; 
        String[] lSummary = new String[]{}; 
        String[] lDescription = new String[]{}; 

        for(FAU_Webinar_Participant__c oWebPartFull : lWebPartFull) 
        {
            lUserId.add(oWebPartFull.FAU_Participant__r.FAU_User__c);
            lWhatId.add(oWebPartFull.Id);
            lUserEmail.add(oWebPartFull.FAU_Participants_Email__c);
            lDtStart.add(oWebPartFull.FAU_Start_Time__c);
            lTemplateId.add(idtemplate);
            lDtEnd.add(oWebPartFull.FAU_End_Time__c);
            lLocation.add(oWebPartFull.FAU_URL_Text__c);
            lSummary.add(oWebPartFull.FAU_Participant__r.FAU_Program_Wave__r.Name + ' :Webinar');
            lDescription.add(oWebPartFull.FAU_Webinar__r.FAU_Description__c);

        }

       sendUserEmailwithTemplate(lUserId, lUserEmail, lWhatId, lTemplateId, lDtStart, lDtEnd, lLocation, lSummary, lDescription);
 

    }  

    /*******************************************************************
       Purpose:     Send Email to Partipnats
    ********************************************************************/
    public static void sendEmailToParticipants(FAU_Participant__c[] lParticipant,  Id idTemplateId)
    {

        List<FAU_Participant__c> lParticipantsFull = [select id, FAU_User__c, FAU_User__r.email, 
                                                        FAU_Personal_Assistant__c, 
                                                        FAU_Personal_Assistant_s_Email__c, 
                                                        FAU_Is_deferred_To_PA__c,
                                                        FAU_Email_Address__c
                                                        from FAU_Participant__c where Id= :lParticipant];
        Id[] lUserId =new Id[]{}; 
        Id[] lWhatId =new Id[]{}; 
        String[] lUserEmail = new String[]{};  
        Datetime[] lDtStart = new Datetime[]{}; 
        Id[] lTemplateId = new Id[]{};
        Datetime[] lDtEnd = new Datetime[]{}; 
        String[] lLocation = new String[]{}; 
        String[] lSummary = new String[]{};
        String[] lDescription = new String[]{}; 

        for(FAU_Participant__c oParticipant : lParticipantsFull) 
        {
            lUserId.add(oParticipant.FAU_User__c);
            lWhatId.add(oParticipant.Id);
            lUserEmail.add(oParticipant.FAU_Email_Address__c);
            lTemplateId.add(idTemplateId);
            lDtStart.add(null);
            lDtEnd.add(null);
            lLocation.add(''); 
            lSummary.add(''); 
            lDescription.add('');

        }
        if (lParticipantsFull.size() > 0 ){
            sendUserEmailwithTemplate(lUserId, lUserEmail, lWhatId, lTemplateId, lDtStart, lDtEnd, lLocation, lSummary, lDescription);
        } 

    } 


    /*******************************************************************
       Purpose:     create ICS Attachment
    ********************************************************************/
    public static Messaging.EmailFileAttachment createIcsAttachment(Datetime dtStart, Datetime dtEnd, String sLocation, String sSummary, String sDescription)
    {
    	Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
        attachment.filename = 'meeting.ics';
        attachment.ContentType = 'text/calendar;';
        attachment.inline = true;
        attachment.body = createIcsBlob(dtStart, dtEnd, sLocation, sSummary, sDescription);
        return attachment; 
    }

    /*******************************************************************
       Purpose:     create ICS file
    ********************************************************************/
    private static Blob createIcsBlob(Datetime dtStart, Datetime dtEnd, String sLocation, String sSummary, String sDescription) {
        String txtInvite = '';

        txtInvite += 'BEGIN:VCALENDAR\n';
        txtInvite += 'PRODID:-//Microsoft Corporation//Outlook 12.0 MIMEDIR//EN\n';
        txtInvite += 'VERSION:2.0\n';
        txtInvite += 'METHOD:PUBLISH\n';
        txtInvite += 'X-MS-OLK-FORCEINSPECTOROPEN:TRUE\n';
        txtInvite += 'BEGIN:VEVENT\n';
        txtInvite += 'CLASS:PUBLIC\n';
        txtInvite += 'CREATED:' + datetime.now().formatGmt('yyyyMMdd') + 'T' + datetime.now().formatGmt('HHmmss') + 'Z\n';
        txtInvite += 'DTEND:' + dtEnd.formatGmt('yyyyMMdd') + 'T' + dtEnd.formatGmt('HHmmss') + 'Z\n';
        txtInvite += 'DTSTAMP:'+ datetime.now().formatGmt('yyyyMMdd') + 'T' + datetime.now().formatGmt('HHmmss') + 'Z\n';
        txtInvite += 'DTSTART:' + dtStart.formatGmt('yyyyMMdd') + 'T' + dtStart.formatGmt('HHmmss') + 'Z\n';
        txtInvite += 'LAST-MODIFIED:'+ datetime.now().formatGmt('yyyyMMdd') + 'T' + datetime.now().formatGmt('HHmmss') + 'Z\n';
        txtInvite += 'LOCATION:'+ sLocation +'\n';
        txtInvite += 'PRIORITY:5\n';
        txtInvite += 'SEQUENCE:0\n';
        txtInvite += 'SUMMARY:' + sSummary + '\n';
        txtInvite += 'LANGUAGE=en-us:Meeting\n';
        txtInvite += 'TRANSP:OPAQUE\n';
        txtInvite += 'UID:4036587160834EA4AE7848CBD028D1D200000000000000000000000000000000\n';
        txtInvite += 'X-ALT-DESC;FMTTYPE=text/html:<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 3.2//EN"><HTML><HEAD><META NAME="Generator" CONTENT="MS Exchange Server version 08.00.0681.000"><TITLE></TITLE></HEAD><BODY><!-- Converted from text/plain format --></BODY></HTML>\n';
        txtInvite += 'X-MICROSOFT-CDO-BUSYSTATUS:BUSY\n';
        txtInvite += 'X-MICROSOFT-CDO-IMPORTANCE:1\n';
        txtInvite += 'DESCRIPTION:' + sDescription +'\n';
        txtInvite += 'END:VEVENT\n';
        txtInvite += 'END:VCALENDAR';
 
        System.Debug('##### FAU_EmailSender - txtInvite : ' + txtInvite); 
        return Blob.valueOf(txtInvite);
    }

    /*******************************************************************
       Purpose:     Send Email Using Template
       Note:        I had to create the contact email first send it and roll it back
                    I then set it to user. 
    ********************************************************************/
    public static void sendUserEmailwithTemplate(Id[] lUserId, String[] lUserEmail, Id[] lWhatId, Id[] lTemplateId, Datetime[] lDtStart, Datetime[] lDtEnd, String[] lLocation, String[] lSummary, String[] lDescription)
    {
         // Pick a dummy Contact
         System.Debug('##### FAU_EmailSender - Pick a dummy Contact'); 
         Contact c = [select id, Email from Contact where email = 'fautestcontact@unilever.com' limit 1];

        // Construct the list of emails we want to send
        List<Messaging.SingleEmailMessage> lstMsgs = new List<Messaging.SingleEmailMessage>();
        for(Integer j = 0; j < lWhatId.size(); j++){
            Messaging.SingleEmailMessage msg = new Messaging.SingleEmailMessage();
            msg.setTemplateId(lTemplateId[j]);
            msg.setWhatId(lWhatId[j]);
            msg.setTargetObjectId(c.id);
            //msg.setToAddresses(new List<String>{lUserEmail[j]});

            lstMsgs.add(msg);
        }   
         // Send the emails in a transaction, then roll it back
        Savepoint beforeInserts = Database.setSavepoint();

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(lstMsgs, false);
        
        Database.rollback(beforeInserts);
        System.Debug('##### FAU_EmailSender - After Rollback'); 

        // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
        // contents to a new SingleEmailMessage. Then send those new messages.
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        for(Integer i = 0; i < lstMsgs.size(); i++){
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(lstMsgs[i].getToAddresses());
            emailToSend.setPlainTextBody(lstMsgs[i].getPlainTextBody());
            emailToSend.setHTMLBody(lstMsgs[i].getHTMLBody());
            emailToSend.setSubject(lstMsgs[i].getSubject());
            emailToSend.setTargetObjectId(lUserId[i]);
            emailToSend.setsaveAsActivity(false);
            if(lDtStart[i] <> null && lDtEnd[i] <> null){
                emailToSend.setFileAttachments(new Messaging.EmailFileAttachment[] {createIcsAttachment(lDtStart[i], lDtEnd[i], lLocation[i], lSummary[i], lDescription[i])});

            }
            lstMsgsToSend.add(emailToSend);
        }

        System.Debug('##### FAU_EmailSender - lstMsgsToSend.size(): ' + lstMsgsToSend.size()); 
        System.Debug('##### FAU_EmailSender - Before Second Send'); 
        if(!Test.isRunningTest()) {
            List<Messaging.SendEmailResult> results1 = Messaging.sendEmail(lstMsgsToSend, false);
            if (!results1.get(0).isSuccess()) {
                System.StatusCode statusCode = results1.get(0).getErrors()[0].getStatusCode();
                String errorMessage = results1.get(0).getErrors()[0].getMessage();
                System.Debug('##### FAU_EmailSender - Message Error:' + errorMessage); 
            }
        }
        System.Debug('##### FAU_EmailSender - VEry End'); 
    }
}