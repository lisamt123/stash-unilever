public with sharing class FA_SendPWTMail
{
    public static void sendSingleMail(Id usrID, String usrName, String taskName, String dueDate, String courseName)
    {
        // grab the email template
        EmailTemplate emailTemplate = [select Id, Subject, HtmlValue, Body from EmailTemplate where Name ='HTML_PreWork Task Reminder'];
        
        // grab the email Org Wide Address
        OrgWideEmailAddress oWEA = [Select id, Address,DisplayName, IsAllowAllProfiles from OrgWideEmailAddress where DisplayName like 'Jonathan Donner'];
        // process the merge fields
        String subject = emailTemplate.Subject;
        String htmlBody = emailTemplate.HtmlValue;
        if(String.isNotEmpty(taskName))
        {
            subject = subject.replace('{!FA_Pre_Work_Task__c.FA_Task_Name__c}', taskName);
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_Task_Name__c}', taskName);
        }
        else
        {
            subject = subject.replace('{!FA_Pre_Work_Task__c.FA_Task_Name__c}', ' ');
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_Task_Name__c}', ' ');
        }

        if(String.isNotEmpty(String.valueOf(dueDate)))
        {
            subject = subject.replace('{!FA_Pre_Work_Task__c.FA_Due_Date__c}', dueDate);
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_Due_Date__c}', dueDate);
        }
        else
        {
            subject = subject.replace('{!FA_Pre_Work_Task__c.FA_Due_Date__c}', ' ' );
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_Due_Date__c}', ' ');
        }
        
        if(String.isNotEmpty(courseName))
        {
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_OccurenceOM__c}',courseName);
        }
        else
        {
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_OccurenceOM__c}',' ');
        }
        if(String.isNotEmpty(usrName))
        {
            htmlBody = htmlBody.replace('{!FA_Pre_Work_Task__c.FA_OccMember__c}',usrName);
        
        
            //build the email message
            Messaging.Singleemailmessage email = new Messaging.Singleemailmessage();

            email.setOrgWideEmailAddressId(oWEA.id);
            email.setTargetObjectId(usrID);
            email.setSaveAsActivity(false);

            email.setSubject(subject);
            email.setHtmlBody(htmlBody);

            Messaging.sendEmail(new Messaging.SingleEmailmessage[] {email});
        }
        else
        {
            System.debug('%%%Error Sending Mail: USER ID NULL');
        }
    }
}