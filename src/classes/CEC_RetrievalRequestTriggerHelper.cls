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
    
    public class emailAddressWrapper{
        boolean isFromEmailVerified = false;
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
    }
    
    public void sendFactoryEmail(map<id,CEC_Retrieval_Request__c > newRetrievalmap, map<id,CEC_Retrieval_Request__c > oldRetrievalmap ){
        set<Id> textileFactoryRetrievalids = new set<Id>();
        set<Id> factoryRetrievalIdsToSendMail = new set<Id>();
        map<id, CEC_Retrieval_Request__c> factoryRetrievalMapToSendMail = new map<id, CEC_Retrieval_Request__c>();
        emailAddressWrapper fromEmailVerificationresults;
        boolean isFromEmailVerified = false;
        OrgWideEmailAddress owa = new OrgWideEmailAddress();
        
        cec_Org_Settings__c orgSettings = cec_Org_Settings__c.getOrgDefaults();
        
        // verify if FROM address in OW email Addresses is verified
        fromEmailVerificationresults = verifyFromEmail(orgSettings);
        
        // obtain verification results and org wide email 
        isFromEmailVerified = fromEmailVerificationresults.isFromEmailVerified;
        owa = fromEmailVerificationresults.owa;
        
        // if org wide email is verified, extract valid records to send emails
        if(isFromEmailVerified){
            for(CEC_Retrieval_Request__c retReq :newRetrievalmap.values()){
                if(retReq.Retrieval_Status__c != oldRetrievalmap.get(retReq.Id).Retrieval_Status__c && retReq.Case_Country_Name__c == 'Brazil'){
                    if(string.IsBlank(retReq.Textile_Factory__c) && string.IsBlank(retReq.Product_Factory__c) && retReq.Retrieval_Status__c == 'Retrieval Complete'){
                        retReq.Retrieval_Status__c = 'Resolved';
                    }else if((string.IsNotBlank(retReq.Textile_Factory__c) && retReq.Retrieval_Status__c == 'Retrieval Complete') || 
                             (string.IsNotBlank(retReq.Product_Factory__c) && (retReq.Retrieval_Status__c == 'Initiate Product Analysis' || retReq.Retrieval_Status__c == 'Retrieval Complete')))
                    {
                        factoryRetrievalMapToSendMail.put(retReq.Id, retReq);
                    }
                }
            }

            // if valid records are found, process them to send emails
            if(!factoryRetrievalMapToSendMail.IsEmpty()){
                sendRetrievalEmails(factoryRetrievalMapToSendMail, owa);
            }
        }
    }
        
    private emailAddressWrapper verifyFromEmail(cec_Org_Settings__c orgSettings){
        emailAddressWrapper eaWrap = new emailAddressWrapper();
        string factoryEmailAddress;
        boolean isValidEmailAddress;    
        list<OrgWideEmailAddress> owaList = new list<OrgWideEmailAddress>();
            
        factoryEmailAddress = orgSettings.Brazil_Factory_Response_Email_Id__c;
        // verify is email address is valid
        isValidEmailAddress = CEC_Util.isValidEmailAddress(factoryEmailAddress);
        // search Org wide email address corresponding to it
        if(isValidEmailAddress){
            if(!test.isRunningTest()){
                owaList = [SELECT Id, DisplayName, Address FROM orgWideEmailAddress WHERE Address =: factoryEmailAddress];
            }else{
                owaList = [SELECT Id, DisplayName, Address FROM orgWideEmailAddress LIMIT 1];
            }
            
            if(!owaList.IsEmpty()){
                if(!test.isRunningTest()){
                	eaWrap.owa = owaList.get(0);
                }
                eaWrap.isFromEmailVerified = true;
                
                return eaWrap;
            }
        }
        eaWrap.owa = null;
        eaWrap.isFromEmailVerified = false;

        return eaWrap;
    }
    
    private boolean sendRetrievalEmails(map<id, CEC_Retrieval_Request__c> factoryRetrievalMapToSendMail, OrgWideEmailAddress owa){
        list<id> factoryDetailIds = new list<id>();
        map<id, CEC_Factory_Details__c> retrivalIdTofactorymap = new map<id, CEC_Factory_Details__c>();
        list<id> parentCaseIds = new list<id>();
        
        map<id, case> factoryToCaseMap = new map<id, case>();
         
        // obtain factoryDetail Ids and parent Case Ids
        for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
            factoryDetailIds.add(rr.Product_Factory__c);
            factoryDetailIds.add(rr.Textile_Factory__c);
            parentCaseIds.add(rr.Case__c);
        }
        
        // create Parent case Map to obtain parent Case fields
        map<id, case> parentCaseMap = new map<id, case>([SELECT Id, CaseNumber, CreatedDate, Product_Code__c, Production_Code__c, Reason_L5_desc__c, Global_Reason_L5_desc__c, Product_UPC__c, Subject, Description FROM Case WHERE Id IN :parentCaseIds]);
        
        // create Factory Details map to obtain Factory email address
        map<id, CEC_Factory_Details__c> factoryMap = new map<id, CEC_Factory_Details__c>([SELECT Id, Name, Email__c, Type__c FROM CEC_Factory_Details__c WHERE Id IN :factoryDetailIds]);
        
        // null check and return: if parent case or factory email is not present, abort operation
        if(parentCaseMap.IsEmpty() || factoryDetailIds.IsEmpty()){
            return false;
        }
        
        list<Messaging.SingleEmailMessage> emailList = new List<Messaging.SingleEmailMessage>();
        list<EmailMessage> emailMessageList = new list<EmailMessage>();
        map<string, EmailTemplate> emailTemplateMap = new map <string, EmailTemplate>();
        
        // query email templates
        list<EmailTemplate> emailTemplates = [SELECT Id, Name, DeveloperName, Subject, Body, HtmlValue FROM EmailTemplate WHERE (DeveloperName = 'Brazil_Textile_Factory_Response' OR DeveloperName = 'Brazil_Product_Factory_Response') AND IsActive = true ];

        // map email templates 
        for(EmailTemplate eTmp :emailTemplates){
            if(eTmp.DeveloperName == 'Brazil_Textile_Factory_Response'){
                emailTemplateMap.put('Textile', eTmp);
            }else{
                emailTemplateMap.put('Product', eTmp);
            }
        }
        
        // send emails and attach  them to corresponding cases as well
        for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
            Case aCase = new Case();
            list<string> toEmailAdresses  = new list<string>();
            string updatedHTMLBody;
            string updatedSubject;
            
            // get parent case of current retrieval record
            aCase = parentCaseMap.get(rr.Case__c);
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            // format mail subject and body accordingly
            if(string.IsNotBlank(rr.Textile_Factory__c) && (rr.Retrieval_Status__c != 'Initiate Product Analysis')){
                updatedHTMLBody = formatEmail(aCase, emailTemplateMap.get('Textile').HtmlValue);
                updatedSubject = emailTemplateMap.get('Textile').Subject;
                toEmailAdresses = extractToEmailAddresses(factoryMap.get(rr.Textile_Factory__c).Email__c);
            }else if(string.IsNotBlank(rr.Product_Factory__c)){
                updatedHTMLBody = formatEmail(aCase, emailTemplateMap.get('Product').HtmlValue);
                updatedSubject = emailTemplateMap.get('Product').Subject;
                toEmailAdresses = extractToEmailAddresses(factoryMap.get(rr.Product_Factory__c).Email__c);
            }
            // replace thread id in email
            updatedHTMLBody = updatedHTMLBody.replace('{!Case.Thread_Id}', rr.Thread_Id__c);
            updatedSubject = searchAndReplace(updatedSubject, '{!Case.Thread_Id}', rr.Thread_Id__c);
            
            mail.setSubject(updatedSubject);
            mail.setHTMLBody(updatedHTMLBody);
            mail.setSaveAsActivity(false);
            if(!test.isRunningTest()){
                mail.setOrgWideEmailAddressId(owa.Id);
            }
            mail.setToAddresses(toEmailAdresses);
            emailList.add(mail);
            
            // create emailMessage object to link to case
            EmailMessage eMessage = new EmailMessage();
            eMessage.ParentId = rr.Case__c;
            eMessage.Subject = mail.getSubject();
            eMessage.HtmlBody = mail.getHTMLBody();
            eMessage.FromName = owa.DisplayName;
            eMessage.FromAddress = owa.Address;
            eMessage.ToAddress = string.valueOf(mail.getToAddresses()).substring(1, string.valueOf(mail.getToAddresses()).length()).replace(',',';');
            eMessage.Incoming = false;
            eMessage.MessageDate = system.Now();
            emailMessageList.add(eMessage);
        }
        Messaging.SendEmailResult[] resultMail;
        //send emails
        try{
            resultMail =  Messaging.sendEmail(emailList,true);
        }catch(exception e){
            for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
                // update error message on retrieval records
                rr.Retrieval_Message__c = 'Email sending failed';
            }
            return false;
        }
        if(resultMail.get(0).isSuccess()){
            
            for(CEC_Retrieval_Request__c rr :factoryRetrievalMapToSendMail.values()){
                // set email flags
                if(string.IsNotBlank(rr.Textile_Factory__c)&& (rr.Retrieval_Status__c != 'Initiate Product Analysis')){
                    rr.Textile_Factory_Email_Sent__c = true;
                }else if(string.IsNotBlank(rr.Product_Factory__c)){
                    rr.Product_Factory_Email_Sent__c = true;
                }
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
                rr.Retrieval_Message__c = 'Email sending failed. ERROR: '+ resultMail.get(0).getErrors();
            }
            return false;
        }
        return true;
    }
    
    private list<string> extractToEmailAddresses(string factoryEmail){
        // extract all email address
        factoryEmail = factoryEmail.replace(',',';');
        string[] toEmailAdresses = factoryEmail.trim().split(';');
        // reject invalid email address
        integer i = toEmailAdresses.size()-1;
        while(i >= 0){
            if(!CEC_Util.isValidEmailAddress(toEmailAdresses.get(i))){
                toEmailAdresses.remove(i);
            }
            i--;
        }
        // return all valid address
        return toEmailAdresses; 
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
}