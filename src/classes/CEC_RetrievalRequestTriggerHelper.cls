/**********************************************************************
Name:  CEC_RetrievalRequestTriggerHelper
Copyright@: 2016  Unilever
=======================================================================
=======================================================================
Purpose: Contains various trigger actions to be performed                                                                                                

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Goverdhan S.       Apr-2016      INITIAL DEVELOPMENT

***********************************************************************/
public with sharing class CEC_RetrievalRequestTriggerHelper {
    
    //recursion handlers
    public static boolean executeBeforeUpdateTrigger = true;
    // filter relavant records and send emails
    public void sendFactoryEmail(map<id,CEC_Retrieval_Request__c > newRetrievalmap, map<id,CEC_Retrieval_Request__c > oldRetrievalmap ){
        // map to store retrieval request records which fulfill criteria
        map<id, CEC_Retrieval_Request__c> factoryRetrievalMapToSendMail = new map<id, CEC_Retrieval_Request__c>();
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
        cec_Org_Settings__c orgSettings = cec_Org_Settings__c.getOrgDefaults();
    
        for(CEC_Retrieval_Request__c retReq :newRetrievalmap.values()){
            // if status is changed and country is Brazil, proceed
            if(retReq.Retrieval_Status__c != oldRetrievalmap.get(retReq.Id).Retrieval_Status__c && retReq.Case_Country_Name__c == 'Brazil'){
                // set status to resolved if status is retrival complete
                if(string.IsBlank(retReq.Textile_Factory__c) && string.IsBlank(retReq.Product_Factory__c) && retReq.Retrieval_Status__c == 'Retrieval Complete'){
                    retReq.Retrieval_Status__c = 'Resolved';
                }// if textile factory is populated and retrieval status is retrieval complete or product factory is populated and status is Initiate Product Analysis or Retrieval Complete, then proceed with sending emials
                else if((string.IsNotBlank(retReq.Textile_Factory__c) && retReq.Retrieval_Status__c == 'Retrieval Complete') || 
                         (string.IsNotBlank(retReq.Product_Factory__c) && (retReq.Retrieval_Status__c == 'Initiate Product Analysis' || retReq.Retrieval_Status__c == 'Retrieval Complete')))
                {
                    factoryRetrievalMapToSendMail.put(retReq.Id, retReq);
                }

            }        
        
        }
        // if there are any valid records, send emails
        if(!factoryRetrievalMapToSendMail.IsEmpty()){
            // fetch from address from custom settings
            owa = verifyFromEmail(orgSettings);
        
            if(owa != null)
                sendRetrievalEmails(factoryRetrievalMapToSendMail, owa);
        
        }
    
    }
    
    private OrgWideEmailAddress verifyFromEmail(cec_Org_Settings__c orgSettings){
    
        string factoryEmailAddress = orgSettings.Brazil_Factory_Response_Email_Id__c;
        list<OrgWideEmailAddress> owaList = new list<OrgWideEmailAddress>();
        OrgWideEmailAddress owa;
        
        if(!test.isRunningTest()){
            owaList = [SELECT Id, DisplayName, Address FROM orgWideEmailAddress WHERE Address =: factoryEmailAddress];
        }else{
            owaList = [SELECT Id, DisplayName, Address FROM orgWideEmailAddress LIMIT 1];
        }

        if(!owaList.IsEmpty()){
            owa = owaList.get(0);
        }else{
            owa = null;
        }
        
        return owa;
    }
    
    private boolean sendRetrievalEmails(map<id, CEC_Retrieval_Request__c> factoryRetrievalMapToSendMail, OrgWideEmailAddress owa){
    
        Set<id> factoryDetailIds = new Set<id>();
        Set<id> parentCaseIds = new Set<id>();
        Set<string>templateNames = new Set<string>();
        
        // obtain factoryDetail Ids and parent Case Ids
        for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
            factoryDetailIds.add(rr.Product_Factory__c);
            factoryDetailIds.add(rr.Textile_Factory__c);
            parentCaseIds.add(rr.Case__c); 
        }
        
        // create Parent case Map to obtain parent Case fields
        map<id, case> parentCaseMap = new map<id, case>([SELECT Id, CaseNumber, CreatedDate, Product_Code__c, Production_Code__c, Reason_L5_desc__c, Global_Reason_L5_desc__c, Product_UPC__c, Subject, Description, Country__r.Product_Factory_Email_Template__c, Country__r.Textile_Factory_Email_Template__c FROM Case WHERE Id IN :parentCaseIds]);
               
        // create Factory Details map to obtain Factory email address
        map<id, CEC_Factory_Details__c> factoryMap = new map<id, CEC_Factory_Details__c>([SELECT Id, Name, Email__c, Type__c FROM CEC_Factory_Details__c WHERE Id IN :factoryDetailIds]);

        if(!parentCaseMap.IsEmpty() && !factoryDetailIds.IsEmpty()){
            
            list<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
            list<EmailMessage> emailMessageList = new list<EmailMessage>();
            map<string, EmailTemplate> emailTemplateMap = new map <string, EmailTemplate>();
            
            // obtain email template names
            for(case aCase :parentCaseMap.values()){
                templateNames.add(aCase.Country__r.Product_Factory_Email_Template__c);
                templateNames.add(aCase.Country__r.Textile_Factory_Email_Template__c);
            }
            
            // query email templates
            list<EmailTemplate> emailTemplates = [SELECT Id, Name, DeveloperName, Subject, Body, HtmlValue FROM EmailTemplate WHERE DeveloperName IN :templateNames AND IsActive = true ];

            // map email templates 
            for(EmailTemplate eTmp :emailTemplates){ 
                emailTemplateMap.put(eTmp.DeveloperName, eTmp);
            }


            Case aCase = new Case();
            list<string> toEmailAdresses  = new list<string>();
            string updatedHTMLBody;
            string updatedSubject;

            // send emails and attach  them to corresponding cases as well
            for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
				// reset case variable
                aCase = new Case();
                // get parent case of current retrieval record
                aCase = parentCaseMap.get(rr.Case__c);
                                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                // format mail subject and body accordingly
                if(string.IsNotBlank(rr.Textile_Factory__c) && (rr.Retrieval_Status__c != 'Initiate Product Analysis')){
                    // if textile factory is present factory template is defined, prepare email
                    if(string.IsNotBlank(aCase.Country__r.Textile_Factory_Email_Template__c)){
                        if(emailTemplateMap.get(aCase.Country__r.Textile_Factory_Email_Template__c) != null){
                            updatedHTMLBody = formatEmail(aCase, emailTemplateMap.get(aCase.Country__r.Textile_Factory_Email_Template__c).HtmlValue);
                            updatedSubject = emailTemplateMap.get(aCase.Country__r.Textile_Factory_Email_Template__c).Subject;
                            toEmailAdresses = extractToEmailAddresses(factoryMap.get(rr.Textile_Factory__c).Email__c);
                        }else{ // update error message on retrieval record
                            rr.Retrieval_Message__c = 'Textile email template for the country is unavailable. make sure such a template exists';
                            break;
                        }
                    }else{ // update error message on retrieval record
                        rr.Retrieval_Message__c = 'Textile email template for the country is undefined. Please populate the template name for related country';
                        break;
                    }
                }else if(string.IsNotBlank(rr.Product_Factory__c)){
                    // if product factory is present factory template is defined, prepare email
                    if(string.IsNotBlank(aCase.Country__r.Product_Factory_Email_Template__c)){
                        if(emailTemplateMap.get(aCase.Country__r.Product_Factory_Email_Template__c) != null){
                            updatedHTMLBody = formatEmail(aCase, emailTemplateMap.get(aCase.Country__r.Product_Factory_Email_Template__c).HtmlValue);
                            updatedSubject = emailTemplateMap.get(aCase.Country__r.Product_Factory_Email_Template__c).Subject;
                            toEmailAdresses = extractToEmailAddresses(factoryMap.get(rr.Product_Factory__c).Email__c);
                        }else{ // update error message on retrieval record
                            rr.Retrieval_Message__c = 'Product email template for the country is unavailable. make sure such a template exists';
                            break;
                        }
                    }else{ // update error message on retrieval record
                        rr.Retrieval_Message__c = 'Product email template for the country is undefined. Please populate the template name for related country';
                        break;
                    }
                }

                // replace thread id in email
                updatedHTMLBody = updatedHTMLBody.replace('{!Case.Thread_Id}', rr.Thread_Id__c);
                updatedSubject = searchAndReplace(updatedSubject, '{!Case.Thread_Id}', rr.Thread_Id__c);
                // prepare email
                mail.setSubject(updatedSubject);
                mail.setHTMLBody(updatedHTMLBody);
                mail.setSaveAsActivity(false);
                if(!test.isRunningTest()){
                    mail.setOrgWideEmailAddressId(owa.Id);
                }
                mail.setToAddresses(toEmailAdresses);
                // add email to list of emails to be sent
                emailList.add(mail);
                
                // create emailMessage object to link to case
                EmailMessage eMessage = new EmailMessage();
                eMessage.ParentId = rr.Case__c;
                eMessage.Subject = mail.getSubject();
                eMessage.HtmlBody = mail.getHTMLBody();
                eMessage.FromName = owa.DisplayName;
                eMessage.FromAddress = owa.Address;
                eMessage.ToAddress = string.valueOf(mail.getToAddresses()).trim().substring(1, string.valueOf(mail.getToAddresses()).length()-1).replace(',',';');
                eMessage.Incoming = false;
                eMessage.MessageDate = system.Now();
                // add email to list of emails to be added to case
                emailMessageList.add(eMessage);

            }

            Messaging.SendEmailResult[] resultMail;
            //send emails
            try{
                if(!emailList.IsEmpty() && !Test.isRunningTest()){
                    resultMail = Messaging.sendEmail(emailList,true);
                }else{
                    return false;
                }
            }catch(exception e){
                for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
                    // update error message on retrieval records
                    rr.Retrieval_Message__c = 'Email sending failed';
                }
                return false;
            }
            if(!resultMail.isEmpty()){
                if(resultMail.get(0).isSuccess()){
                
                    for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
                        // set email flags
                        if(string.IsNotBlank(rr.Textile_Factory__c)&& (rr.Retrieval_Status__c != 'Initiate Product Analysis')){
                            rr.Textile_Factory_Email_Sent__c = true;
                        }else if(string.IsNotBlank(rr.Product_Factory__c)){
                            rr.Product_Factory_Email_Sent__c = true;
                        }
                        //reset retrieval message
                        rr.Retrieval_Message__c = '';
                    }
    
                    // attach emails to respective Cases
                    try{
                        insert emailMessageList;
                    }catch(exception e){
                        system.debug('Error :'+e);
                    }
    
                }else{
                    for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
                        // update error message on retrieval records
                        rr.Retrieval_Message__c = 'Email sending has failed. Please contact your administrator if problem persists';
                    }
                    return false;
                }
            }
            return true;
        }
        else{
            return false;
        }
    
    }
    
    // to format email body
    private string formatEmail(Case aCase, string emailBody){
        string returnString = emailBody;        
        returnString = searchAndReplace(returnString, '{!Case.CaseNumber}', string.ValueOf(aCase.CaseNumber));
        returnString = searchAndReplace(returnString, '{!Case.CreatedDate}', string.ValueOf(aCase.CreatedDate));
        returnString = searchAndReplace(returnString, '{!User.Name}', UserInfo.getName());
        returnString = searchAndReplace(returnString, '{!Case.Product_Code__c}', aCase.Product_Code__c);
        returnString = searchAndReplace(returnString, '{!Case.Production_Code__c}', aCase.Production_Code__c);
        returnString = searchAndReplace(returnString, '{!Case.Reason_L5_desc__c}', aCase.Reason_L5_desc__c);
        returnString = searchAndReplace(returnString, '{!Case.Global_Reason_L5_desc__c}', aCase.Global_Reason_L5_desc__c);
        returnString = searchAndReplace(returnString, '{!Case.Product_UPC__c}', aCase.Product_UPC__c);
        returnString = searchAndReplace(returnString, '{!Case.Subject}', aCase.Subject);
        returnString = searchAndReplace(returnString, '{!Case.Description}', aCase.Description);
        
        return returnString;
    }
    
    // to find and replace string
    private string searchAndReplace(string sourceString, string searchString, string replaceString){
        string returnString = sourceString;
        if(returnString.contains(searchString)){
            if(string.IsNotEmpty(replaceString)){
                returnString = returnString.replace(searchString, replaceString);
            }else{
                returnString = returnString.replace(searchString, '');
            }
        }        
        return returnString;
    }    

    private list<string> extractToEmailAddresses(string factoryEmail){
        string aFactoryEmail;
        string removedEmail;
        
        // extract all email address
        aFactoryEmail = factoryEmail.replace(',',';');
        string[] toEmailAdresses = aFactoryEmail.trim().split(';');
        // reject invalid email address
        integer i = toEmailAdresses.size()-1;
        while(i >= 0){
            if(!CEC_Util.isValidEmailAddress(toEmailAdresses.get(i))){
                removedEmail = toEmailAdresses.remove(i);
            }
            i--;
        }
        // return all valid address
        return toEmailAdresses; 
    }

}