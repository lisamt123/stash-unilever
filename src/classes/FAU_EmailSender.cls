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
    //Constructor
    public FAU_EmailSender()
    {
        
    }  
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
    }  


    /*******************************************************************
       Purpose:     create ICS Attachment
    ********************************************************************/
    public static Messaging.EmailFileAttachment createIcsAttachment(Datetime dtStart, Datetime dtEnd, String sLocation, String sSummary, String sDescription)
    {
        Messaging.EmailFileAttachment attachment = new Messaging.EmailFileAttachment();
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
        String T = 'T';
        String Z='Z\n';//Modified by yugandhar,declared new string Z
        String yyyymmdd = 'yyyyMMdd';// Changes made by Suman Sarita Mahapatra 28/04/2016 , to rectify "The String literal 'yyyymmdd' appears 5 times in this file; " in sonar.
        String HMS = 'HHmmss'; // Changes made by Bibhu

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
        txtInvite += 'CREATED:' + datetime.now().formatGmt(yyyymmdd) + T + datetime.now().formatGmt('HMS') + Z;
        txtInvite += 'DTEND:' + dtEnd.formatGmt(yyyymmdd) + T + dtEnd.formatGmt('HMS') + Z;
        txtInvite += 'DTSTAMP:'+ datetime.now().formatGmt(yyyymmdd) + T + datetime.now().formatGmt('HMS') + Z;
        txtInvite += 'DTSTART:' + dtStart.formatGmt(yyyymmdd) + T + dtStart.formatGmt('HMS') + Z;
        txtInvite += 'LAST-MODIFIED:'+ datetime.now().formatGmt(yyyymmdd) + T + datetime.now().formatGmt('HMS') + Z;
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
            msg.setTemplateId(lTemplateId[j]);
            msg.setWhatId(lWhatId[j]);
            msg.setTargetObjectId(c.id);
            //msg.setToAddresses(new List<String>{lUserEmail[j]});

            lstMsgs.add(msg);
        }   
         // Send the emails in a transaction, then roll it back
        Savepoint beforeInserts = Database.setSavepoint();

        List<Messaging.SendEmailResult> results = Messaging.sendEmail(lstMsgs, false);
        List<Messaging.SendEmailResult> results = Messaging.sendEmail(lstMsgs, false);
        
        Database.rollback(beforeInserts);
        System.Debug('##### FAU_EmailSender - After Rollback'); 

        // For each SingleEmailMessage that was just populated by the sendEmail() method, copy its
        // contents to a new SingleEmailMessage. Then send those new messages.
        List<Messaging.SingleEmailMessage> lstMsgsToSend = new List<Messaging.SingleEmailMessage>();
        for(Integer i = 0; i < lstMsgs.size(); i++){
            Messaging.SingleEmailMessage emailToSend = new Messaging.SingleEmailMessage();
            emailToSend.setToAddresses(lstMsgs[i].getToAddresses());
                emailToSend.setFileAttachments(new Messaging.EmailFileAttachment[] {createIcsAttachment(lDtStart[i], lDtEnd[i], lLocation[i], lSummary[i], lDescription[i])});

            }
            lstMsgsToSend.add(emailToSend);
        }

        System.Debug('##### FAU_EmailSender - lstMsgsToSend.size(): ' + lstMsgsToSend.size()); 
        System.Debug('##### FAU_EmailSender - Before Second Send'); 
        List<Messaging.SendEmailResult> results1 = Messaging.sendEmail(lstMsgsToSend, false);
        if (!results1.get(0).isSuccess()) {
            System.StatusCode statusCode = results1.get(0).getErrors()[0].getStatusCode();
            String errorMessage = results1.get(0).getErrors()[0].getMessage();
        System.StatusCode statusCode = results1.get(0).getErrors()[0].getStatusCode();
        String errorMessage = results1.get(0).getErrors()[0].getMessage();
            System.Debug('##### FAU_EmailSender - Message Error:' + errorMessage); 
        }
        System.Debug('##### FAU_EmailSender - VEry End'); 
    }
}