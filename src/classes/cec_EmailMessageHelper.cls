/**********************************************************************
 Name:  cec_EmailMessageHelper
 Copyright ? 2014  Unilever
 ======================================================
======================================================
Purpose:  for EmailMessageHleper                                                    
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Aalokkumar       19/09/2014       INITIAL DEVELOPMENT     Email Message
   1.1 -   Pavan Kumar      09/02/2015       CR                      Email Message  
   1.2 -   Sathish          05/08/2015       Notification Email      Email Notification for missing CBM
   1.3 -   Nagesh           05/18/2016       Sonar Issue             Sonar Issue
****************************************************************************/
public with sharing class cec_EmailMessageHelper{

    Map<String, cec_Case_Brand_Mapping__c> incomingEmailAddresses = new Map<String, cec_Case_Brand_Mapping__c>();
    List<Case> casesToUpdate = new List<Case>();
    String emailNotificationContent = '';
    Set<Id> caseIdSet = new Set<Id>();
    Set<String> caseOriginSet = new Set<String>();
    Map<Id,Case> caseMap = new Map<Id, Case>();
    Map<String,Id> CMMMap = new Map<String,Id>();

    public void emailMessage(List<EmailMessage> emList){
    
        // Get list of all branded emails
        Set<String> brandEmailSet = new Set<String>();
        List<cec_Case_Brand_Mapping__c> branEmailList = [Select Inbound_Email__c,skill__c,Country__c From cec_Case_Brand_Mapping__c where Inbound_Email__c!=null];
        for(cec_Case_Brand_Mapping__c cbr: branEmailList){
            brandEmailSet.add(cbr.Inbound_Email__c);
        }
        // loop on email list
        for (EmailMessage em : emList) {
        
            System.debug('Inserting the email message: ' + em);                   
            System.debug('Parent Id is ' + em.ParentId);
            // if email type is incoming, fetch all email addresses
            if (em.Incoming) {
                // add parent case id to set
                caseIdSet.add(em.parentId);
                // Get all the email address in TO, CC and BCC section and consolidate it in a String
                String allEmailStr = '';
                // get to addresses
                if (em.ToAddress != null) {
                    allEmailStr += em.ToAddress;
                }// get cc addresses
                if (em.CcAddress != null) {
                    allEmailStr += ';' + em.CcAddress;
                }// get bcc addresses
                if (em.BccAddress != null) {
                    allEmailStr += ';' + em.BccAddress;
                }
                System.debug('Consolidated email addresses in String :: '+ allEmailStr);
                String[] emailList = allEmailStr.split(';');
                System.debug('Email Addresses:: '+ emailList);
                // if email is present in brandemail set, add it to incomingEmailAddresses map
                for(Integer i=0; i < emailList.size(); i++){
                    if(brandEmailSet.contains(emailList[i].trim())){
                        incomingEmailAddresses.put(emailList[i].trim(), null);
                        System.debug('First Branded Email:: '+emailList[i]);        
                        break;
                    }
                }            
            }
        }
        // fetch cbm for all brand emails
        for (cec_Case_Brand_Mapping__c cbm: [Select Inbound_Email__c,     
                                                Brand_Market__c, 
                                                Brand__c,
                                                Auto_Response_Template__c, 
                                                External_Image_Address__c,
                                                Country__c,
                                                skill__c
                                         From cec_Case_Brand_Mapping__c 
                                         Where  Inbound_Email__c In :incomingEmailAddresses.keyset()]) {
            incomingEmailAddresses.put(cbm.Inbound_Email__c, cbm);
        }
        // fetch parent cases
        if(caseIdSet.size()>0){
            caseMap = new Map<Id, Case>([Select Id, Case_Brand__c, Origin, CaseNumber FROM Case WHERE ID =: caseIdSet]);
        }
        // store case origins
        for(case caseRec: caseMap.values()){
           caseOriginSet.add(caseRec.Origin);
        }
        // create case origin and cmm map
        for(CEC_Case_Market_Mapping__c CMM : [Select Id, CaseOrigin__c  FROM CEC_Case_Market_Mapping__c WHERE CaseOrigin__c =:caseOriginSet]){
            CMMMap.put(CMM.CaseOrigin__c,CMM.Id);
        }
        
        
    
        for (EmailMessage em : emList) {
        
            if (em.Incoming) {

                Boolean caseAssociated=false;       
                //Case caseObj = [SELECT Case_Brand__c, Origin, CaseNumber FROM Case WHERE ID =: em.parentId];
                Case caseObj = caseMap.get(em.parentId);
                String caseNumber = caseObj.CaseNumber;
                // Get all the email address in TO, CC and BCC section and consolidate it in a String
                String allEmailStr = '';
                if (em.ToAddress != null) {
                    allEmailStr += em.ToAddress;
                }
                if (em.CcAddress != null) {
                    allEmailStr += ';' + em.CcAddress;
                }
                if (em.BccAddress != null) {
                    allEmailStr += ';' + em.BccAddress;
                }
                System.debug('Consolidated email addresses in String :: '+ allEmailStr);
                String[] emailList = allEmailStr.split(';');
                System.debug('Email Addresses:: '+ emailList);
            
                cec_Case_Brand_Mapping__c cbm = null;
                // Get the first occurrence of branded email from the To list
                for(Integer i=0; i < emailList.size(); i++){
                    cbm = incomingEmailAddresses.get(emailList[i].trim());
                    if(brandEmailSet.contains(emailList[i].trim())){
                        if (cbm != null) {
                            System.debug('here is the cbm: ' + cbm); 
                            Case c = new Case(id=em.parentId);
                            c.Set_Assignment_Fields__c = true;
                            c.Country__c=cbm.Country__c;
                            c.Case_Brand_Mapping__c = cbm.Id;
                            /*if(caseObj.Brand__c == null){
                                c.Brand__c = cbm.Brand__c;
                            }*/
                            c.Product_Skill__c=cbm.skill__c;
                            c.CMMFlag__C = TRUE;
                            System.debug('here is the case: ' + c);
                            caseAssociated=true;
                            casesToUpdate.add(c);       
                            break;
                        }
                    }            
                }
                if(!caseAssociated){
                    // Set the email content for the missing notification mail
                    emailNotificationContent += '<B>Case Id :: </B>' + caseNumber + '<br> <B>List of all Email Ids for the Case :: </B>' + allEmailStr + ' <br><br><br>';
                    // As a backup measure find the country from CaseMarketMapping based on CaseOrigin and set it to the Case
                    //CEC_Case_Market_Mapping__c[] cmmlist = [Select Id, CaseOrigin__c  FROM CEC_Case_Market_Mapping__c WHERE CaseOrigin__c =:caseObj.Origin LIMIT 1];
                    //system.debug('cmmlistsize>>>>>'+cmmlist.size());
                    //if(cmmlist.size()>0){
                    if(CMMMap.get(caseObj.Origin) != null){
                        Case cs = new Case(id=em.parentId);
                        cs.Country__c = CMMMap.get(caseObj.Origin);
                        casesToUpdate.add(cs);
                        break;
                    }
                     
                }
            }
        } 
        // Send the email to the configured mail if there is missing CaseBrandMapping.
        if (emailNotificationContent != '') {
            String finalContent = Label.CEC_CBM_NotificationBodyHeader + emailNotificationContent + Label.CEC_CBM_NotificationBodyFooter;
            CEC_Util.sendNotificationEmail(finalContent, Label.CEC_CBM_NotificationSubject);
        }
        update casesToUpdate;    
    }
}