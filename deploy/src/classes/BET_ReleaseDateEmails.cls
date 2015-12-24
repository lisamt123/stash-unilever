/**********************************************************************
Name: BET_ReleaseDateEmails 
Copyright © 2014 Unilever.

============================================================================
============================================================================
Purpose: Class for sending mails. in relation with with BET_BatchScheduler
============================================================================
============================================================================
History
-------
VERSION AUTHOR                  DATE            DETAIL  FEATURES/CSR/TTP
1.0 -   Maciej Krol             22/12/2014      INITIAL DEVELOPMENT
1.1 -   Blessy Voola            4 May 2015    Modified code to redirect users OOO mails to cb4l@unilever.com 
**********************************************************************/
global class BET_ReleaseDateEmails implements Database.Batchable<sObject>, Database.AllowsCallouts {
    global final String query;
    private Boolean isFirst;
    
    global BET_ReleaseDateEmails(String cQuery, Boolean cIsFirst) {
        query = cQuery;
        isFirst = cIsFirst;
    }
    
    global Database.QueryLocator start(Database.BatchableContext BC) {
        Datetime d1 = system.today().addDays(30);
        Date due = Date.newInstance(d1.year(),d1.month(),d1.day());
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext BC, List<uw_BET__c> scope) {
        List<Messaging.SingleEmailMessage> mailList = new List<Messaging.SingleEmailMessage>();

        BET_Request_Access__c settings  = BET_Request_Access__c.getInstance();

        List<String> toAddresses = new List<String>();
        Messaging.SingleEmailMessage mail;
        //T0-Begin
        OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = 'cb4l@unilever.com'];
        //T0-End
        for(uw_BET__c bet : scope){
            toAddresses = new String[] { bet.Owner.Email }; 

            mail = new Messaging.SingleEmailMessage(); 
            //T0-Begin
           if ( owea.size() > 0 ) {
    mail.setOrgWideEmailAddressId(owea.get(0).Id);
}    
        //T0-End
                    if(isFirst){
                if(bet.Status__c == 'First release'){
                    continue;
                }
                mail.setSubject('REMINDER: '+bet.Name+' BET is due for First Release on '+bet.First_Release_Due_Date__c);
            }else{
                if(bet.Status__c == 'Final release'){
                    continue;
                }
                mail.setSubject('REMINDER: '+bet.Name+' BET is due for Final Release on '+bet.Final_Release_Due_Date__c);
            }           
            mailList.add(updateEmailParams(mail,bet,settings,isFirst,toAddresses));
        }

        List<Messaging.Sendemailresult> mailResult;
        if(!Test.isRunningTest()){
            mailResult = Messaging.sendEmail(mailList); 
        }
    }

    @TestVisible
    private static Messaging.SingleEmailMessage updateEmailParams(Messaging.SingleEmailMessage mail,uw_BET__c bet,BET_Request_Access__c settings,Boolean isFirst,List<String> toAddresses){
        String template = BET_ReleaseDateEmails.generateTemplate(bet, settings, isFirst);
                    //T0-Begin
            //comment out below line
          // mail.setSenderDisplayName(settings.From_Name__c);
                  //T0-End
        mail.setToAddresses(toAddresses);
        mail.setHtmlBody(template);
                                //T0-Begin
            //comment out below line
          //  mail.setReplyTo(settings.Email_Address__c);
                  //T0-End
        return mail;
    }

    @TestVisible
    private static String generateTemplate(uw_BET__c bet, BET_Request_Access__c settings, Boolean isFirst){
        String siteUrl = String.valueOf(Url.getSalesforceBaseUrl().toExternalForm());

        String template = '<table style="color: #222; font-size: 12px; font-family: Arial, Helvetica, sans-serif; line-height: 15px;" border="0" width="600">'
                            +'<tbody><tr><td>'
                            +'<table style="color: #222; font-size: 12px; font-family: Arial, Helvetica, sans-serif; line-height: 15px;" border="0" width="600">'
                            +'<tbody><tr>'
                            +'<td colspan="2">';
                            if(isFirst){
                                template += '<div class="headlineText" style="margin-top: 30px; margin-bottom: 19px;">Dear '+bet.Owner.Name+'<br />Your Brand Experience Toolkit (BET) '+bet.Name+' is due for FIRST RELEASE on '+bet.First_Release_Due_Date__c;
                                template +='<br />Please ensure your Brand Experience Presentation is available in the BET by '+bet.First_Release_Due_Date__c+'</div>';
                            }else{
                                template += '<div class="headlineText" style="margin-top: 30px; margin-bottom: 19px;">Dear '+bet.Owner.Name+'<br />Your Brand Experience Toolkit (BET) '+bet.Name+' is due for FINAL RELEASE on '+bet.Final_Release_Due_Date__c;
                                template +='<br />Please ensure your Brand Experience Key Visual is available in the BET by '+bet.Final_Release_Due_Date__c+'</div>';
                            }                            
                            template +='</td>'
                            +'</tr>'                  
                            +'<tr><td colspan="2"><div class="messageSmallText" style="width: 600px;">'
                            +'Click here to go to your <a href="'+siteUrl+'/'+bet.Id+'" style="text-decoration:none; color: #015ba7;" class="smallLinkStyle" target="_blank" title="This external link will open in a new window">'
                            +' '+siteUrl+'/'+bet.Id+'</a></div>'
                            +'</td></tr>'
                            +'</tbody></table></td>'
                            +'</tr><tr><td>'
                            +'<br><div class="footerText">'
                            +'<div class="emailfootertext" emloc="_footer_" style="font-family: Arial, Helvetica, sans-serif; color: #7d7d84; line-height: 14px; font-size: 11px;">'
                            +'This email was sent to the user <a href="'+siteUrl+'/'+bet.OwnerId+'?fromEmail=1" style="text-decoration:none; color: #015ba7;" target="_blank" title="This external link will open in a new window">'+bet.Owner.Email+'</a>.<br>';
                            if(settings.Logo_Url__c != null && settings.Logo_Url__c != ''){
                                template += '<br><img src="'+settings.Logo_Url__c+'" alt="Logo" title="Logo">';
                            }                           
                            template +=''+settings.Footer__c+'</div></div>'
                            +'</td>'
                            +'</tr></tbody></table>';
        return template;
    }
    
    global void finish(Database.BatchableContext BC) {
        
    }
}