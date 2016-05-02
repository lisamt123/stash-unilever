/**********************************************************************
Name:  CEC_BatchAlertActionHelper
Copyright@: 2015  Unilever
=======================================================================
=======================================================================
Purpose: This is the controller class for CEC_CaseInline Vf page                                                                                                    

========================================================================
========================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Pavan           Feb-2015      INITIAL DEVELOPMENT   
1.1      Sathish         Dec-2015      New class refactored from CEC_AlertActionHelper Class.
1.2      Sathish         Jan-2016      Updated for Chatter Post requirements.       
***********************************************************************/
public with sharing class CEC_BatchAlertActionHelper {
    /**
This method sends Email Alerts and post to the chatter feeds.
*/
    public void executeAction(List<cec_Alert_Tracker__c> alertTrackerList){
        
        if (!alertTrackerList.isEmpty()) {
            
            try {                
                Map<Id,cec_Alert_Tracker__c> alertTrackerMap = new Map<Id,cec_Alert_Tracker__c>(alertTrackerList);
                Set<Id> alertTrackerIds = alertTrackerMap.keySet();
                
                // Construct a map for Alert rule and it's alert tracker ids
                Map<Id,List<Id>> selectedAlertRuleTrackerMap = new Map<Id,List<Id>>();
                Set<String> alertActionType = new Set<String> { CEC_Constants.ALERT_ACTION_TYPE_EMAIL, 
                                                                CEC_Constants.ALERT_ACTION_TYPE_CHATTER };
                
                for(cec_Alert_Tracker__c alertTracker : alertTrackerList){                    
                    if(alertTracker.Current_Threshold__c >= alertTracker.Alert_Threshold__c){                        
                        if(selectedAlertRuleTrackerMap.get(alertTracker.Alert_Rule_Id__c) == null){
                            selectedAlertRuleTrackerMap.put(alertTracker.Alert_Rule_Id__c,new List<Id>());  
                        }
                        selectedAlertRuleTrackerMap.get(alertTracker.Alert_Rule_Id__c).add(alertTracker.Id);
                    }               
                }
                
                // Get alert action records related to the selected alert rules         
                List<cec_Alert_Action__c> alertActionList = [SELECT Name, Alert_Rule_Id__c, Email_Template_Name__c, 
                                                                Chatter_Template_Name__c, To__c, Type__c,
                                                                Country_Chatter_Group_Id__c, Category_Chatter_Group_Id__c
                                                                FROM cec_Alert_Action__c 
                                                                WHERE 
                                                                Alert_Rule_Id__c IN :selectedAlertRuleTrackerMap.keySet() 
                                                                AND Type__c IN :alertActionType];
                
                // Construct map for Email template developer name and its template
                Map<String,EmailTemplate> emailTemplateMap = new Map<String,EmailTemplate>();
                
                List<String> developerNameList = new List<String>(); 
                for(cec_Alert_Action__c alertAction: alertActionList){
                    if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_EMAIL)) {
                        developerNameList.add(alertAction.Email_Template_Name__c);
                    } else if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_CHATTER)) {
                        developerNameList.add(alertAction.Chatter_Template_Name__c);
                    }
                }
                
                List<EmailTemplate> emailTemplateList = [SELECT ID, DeveloperName, Subject, Body FROM EmailTemplate WHERE DeveloperName IN :developerNameList];
                
                for(EmailTemplate et:emailTemplateList){
                    emailTemplateMap.put(et.DeveloperName, et);
                }
                /*********** change start -> 03-Sept-15 Support Team changes **********/ 
                
                // Get alert tracker case string map        
                Map<Id,List<String>> alertTrackerCaseMap = getAlertTrackerCaseMap(alertTrackerIds);
                
                /*********** change end -> 03-Sept-15 Support Team changes **********/ 
                
                //Get the From address through custom settings
                cec_Org_Settings__c cecSetting = cec_Org_Settings__c.getOrgDefaults();
                String safetyAlertFromEmailId = cecSetting.Safety_Alert_Email_Id__c; 
                String alertChatterUserId = cecSetting.Alert_Chatter_User_Id__c;
                system.debug('FromAddress>>>>'+safetyAlertFromEmailId);
                
                
                // set the 'from' Address through Org wide Email Address
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :safetyAlertFromEmailId];
                system.debug('OWEA Contains>>>>>>'+owea.size());
                
                // Create a final mail and chatter feed list to update in bulk
                List<Messaging.SingleEmailMessage> finalMailList = new List<Messaging.SingleEmailMessage>();
                List<FeedItem> finalFeedItemList = new List<FeedItem>();
                EmailTemplate eTemplate;
                // Iterate through all alert actions
                for(cec_Alert_Action__c alertAction: alertActionList){
                   //  Get the email template based on the action type
                    if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_EMAIL)) {
                        eTemplate = emailTemplateMap.get(alertAction.Email_Template_Name__c);
                    } else if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_CHATTER)) {
                        eTemplate = emailTemplateMap.get(alertAction.Chatter_Template_Name__c);
                    }
                    // Iterate through all Alert trackers related to the Alert action's rule
                    for(Id alertTrackerId:selectedAlertRuleTrackerMap.get(alertAction.Alert_Rule_Id__c)){
                        
                        cec_Alert_Tracker__c aTracker = alertTrackerMap.get(alertTrackerId);
                        String subjectStr = alertTrackerCaseMap.get(alertTrackerId).get(0);
                        String caseListStr = alertTrackerCaseMap.get(alertTrackerId).get(1);
                        String finalMessageBody = constructTemplateBody(eTemplate.Body, caseListStr, aTracker);
                        // Create mail /feed related data based on the action type.
                        if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_EMAIL)) {
                            finalMailList.add(constructEmailMessage(alertAction, owea, eTemplate.Subject, subjectStr, finalMessageBody));
                        } else if (alertAction.Type__c.equals(CEC_Constants.ALERT_ACTION_TYPE_CHATTER)) {
                            finalFeedItemList.addAll(postChatterFeed(alertAction, finalMessageBody, alertChatterUserId));
                        }
                    }
                }
                // Send mail and Post chatter feeds for all alert tracker's action.                
                updateActionInBulk(finalMailList, finalFeedItemList);
                // Update the Trigger Batch flag to false.
                finalizeAction(alertTrackerList);
                
            } catch(Exception e) {
                System.debug(e.getMessage());
                throw e;
            }            
        }        
    }

    /******************************************************************* 
        Purpose: 
            Sends Email/Posts feed to the Chatter group as a bulk operation
        Parameters: 
            finalMailList - Email list to send the mails
            finalFeedItemList - Posts to update the group.
    ********************************************************************/
    private void updateActionInBulk(List<Messaging.SingleEmailMessage> finalMailList, 
                                    List<FeedItem> finalFeedItemList) {
        // Send all mails
        if(finalMailList.size() > 0) {            
            Messaging.SendEmailResult [] emailResult = Messaging.sendEmail(finalMailList);
            System.debug('Sent Email Result:: '+emailResult);              
        }
        // Create all posts
        if(finalFeedItemList.size() > 0) {
            insert finalFeedItemList;
        }
    }

    /******************************************************************* 
        Purpose: 
            Update the Trigger Batch flag to false.
        Parameters: 
            alertTrackerList - All the alertracker list picked up by the batch
    ********************************************************************/
    private void finalizeAction(List<cec_Alert_Tracker__c> alertTrackerList) {                
        // Uncheck all the trigger email check on the alert tracker.
        for(cec_Alert_Tracker__c alertTracker : alertTrackerList){
            alertTracker.Trigger_Batch__c = false;                    
        }
        update alertTrackerList;          
    }

    /******************************************************************* 
        Purpose: 
            Constructs the Body from the template
        Parameters: 
            templateSkeletonBody - PLace identifiers to replace with actual content.
            caseListStr - List of cases Per ALert Tracker.
            aTracker - ALert Tracker data.
    ********************************************************************/
    private String constructTemplateBody(String templateSkeletonBody, String caseListStr,
                                             cec_Alert_Tracker__c aTracker) {
        String finalMessageBody = templateSkeletonBody;
        // Replace email template merge fields with actual values               
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.Name}', aTracker.Name);
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.Link}',
                                                    URL.getSalesforceBaseUrl().toExternalForm()+'/'+aTracker.Id);
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.Alert_Rule_Id__c}', 
                                                    aTracker.Alert_Rule_Id__c);
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.Product_No_Size__c}',
                                                    String.valueOf(aTracker.Product_No_Size__c));
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.L5_Reason_Code__c}', 
                                                    aTracker.L5_Reason_Code__c);
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.Alert_Threshold__c}',
                                                    String.valueOf(aTracker.Alert_Threshold__c));
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.Current_Threshold__c}',
                                                    String.valueOf(aTracker.Current_Threshold__c));
        finalMessageBody = finalMessageBody.replace('{!cec_Alert_Tracker__c.caseList}', caseListStr);

        return finalMessageBody;
    }

    /******************************************************************* 
        Purpose: 
            Constructs the Mail related data and sets up the body/subject/address details.
        Parameters: 
            alertAction - Alert Action of type Email action
            owea - To set the From address
            templateSkeletonSubject - PLace identifiers to replace with actual content.
            customSubject - Custom Subject constructed.
            finalMessageBody - Final Body of the mail.
        Return:
            Messaging.SingleEmailMessage - Email Object.
    ********************************************************************/
    private Messaging.SingleEmailMessage constructEmailMessage(cec_Alert_Action__c alertAction, OrgWideEmailAddress[] owea,
                                                        String templateSkeletonSubject, String customSubject, 
                                                        String finalMessageBody) {
        // Construct email message
        Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        String[] toAddresses = alertAction.To__c.split(';');
        mail.setToAddresses(toAddresses);
        if (owea.size() > 0) {
            mail.setOrgWideEmailAddressId(owea.get(0).Id);
        }
        // Set email text body
        mail.setSubject(templateSkeletonSubject + customSubject);
        mail.setPlainTextBody(finalMessageBody);

        return mail;
    }

    /******************************************************************* 
        Purpose: 
            Constructs the Feed related data and sets up the body details.
        Parameters: 
            alertAction - Alert Action of type Chatter action
            alertChatterUserId - Default user who posts the post in chatter
            finalMessageBody - Final Body of the mail.
        Return:
            Messaging.SingleEmailMessage - Email Object.
    ********************************************************************/
    private List<FeedItem> postChatterFeed(cec_Alert_Action__c alertAction,
                                            String finalMessageBody, String alertChatterUserId) {
        List<FeedItem> feedItemList = new List<FeedItem>();
        String countryChatterGroupId = alertAction.Country_Chatter_Group_Id__c;
        String categoryChatterGroupId = alertAction.Category_Chatter_Group_Id__c;
        // Create the post for the Country Group
        if(String.isNotEmpty(countryChatterGroupId)) {
            FeedItem post = new FeedItem();
            post.ParentId = countryChatterGroupId;
            if (String.isNotBlank(alertChatterUserId)) { 
                post.createdById = alertChatterUserId;
            }
            post.Body = finalMessageBody;
            feedItemList.add(post);
        }
        // Create the post for the Category Group
        if(String.isNotEmpty(categoryChatterGroupId)) {
            FeedItem post = new FeedItem();
            post.ParentId = categoryChatterGroupId; 
            if (String.isNotBlank(alertChatterUserId)) { 
                post.createdById = alertChatterUserId;
            }
            post.Body = finalMessageBody;
            feedItemList.add(post);
        }
        return feedItemList;
    }    
    
    /**
This method returns map for Alert tracker and it's Case numbers
*/
    @TestVisible
    private Map<Id,List<String>> getAlertTrackerCaseMap(Set<Id> alertTrackerIds){
        
        // Get all alert tracker items associated with the alert trackers
        List<cec_Alert_Tracker_Item__c> alertTrackerItemList = [SELECT Alert_Tracker_Id__c, Case_Id__c FROM cec_Alert_Tracker_Item__c 
                                                                WHERE Active__c = TRUE AND Alert_Tracker_Id__c IN :alertTrackerIds ORDER BY LastModifiedDate DESC];
        // Get case records
        List<Id> caseIdList = new List<Id>();
        for(cec_Alert_Tracker_Item__c atItem:alertTrackerItemList){
            caseIdList.add(atItem.Case_Id__c);          
        }
        Map<Id,Case> caseMap = new Map<Id,Case>([SELECT Product_Code__c,CEC_Reason_Code__c,CaseNumber,CreatedDate,Description, Store__r.Name, Store_Location__c, Date_of_Manufacture__c, Date_of_Manufacture_str__c, Purchase_Date__c, Case_Brand__c, Country_Name__c, L2_Product_Category__c, Production_Code__c FROM Case WHERE ID IN :caseIdList]);
        
        // Construct a map of alert tracker id and case numbers string (all cases belong to the alert tracker)
        //Map<Id,String> alertTrackerCaseMap = new Map<Id,String>();
        Map<Id,list<String>> alertTrackerCaseMap = new Map<Id,list<String>>();
        Case caseObj;
        String caseStr = '';
        String subjectStr = '';
        Boolean isSubjectInfoSet = false;
        
        Integer caseIndex = 0;
        
        Map<Id,List<cec_Alert_Tracker_Item__c>> alertTrackerMap = new Map<Id,List<cec_Alert_Tracker_Item__c>>();
        
        for(cec_Alert_Tracker_Item__c atItem:alertTrackerItemList){
            if(alertTrackerMap.get(atItem.Alert_Tracker_Id__c) == null){
                alertTrackerMap.put(atItem.Alert_Tracker_Id__c,new List<cec_Alert_Tracker_Item__c>());  
            }
            alertTrackerMap.get(atItem.Alert_Tracker_Id__c).add(atItem);
        }
        
        
        for(Id alertTrackerId:alertTrackerMap.keyset()){
            caseStr = '';
            /*********** change start -> 03-Sept-15 Support Team changes **********/ 
            subjectStr = '';
            /*********** change end -> 03-Sept-15 Support Team changes **********/ 
            
            caseIndex = 0;
            /*********** change start -> 03-Sept-15 Support Team changes **********/ 
            isSubjectInfoSet = false;
            /*********** change end -> 03-Sept-15 Support Team changes **********/ 
            for(cec_Alert_Tracker_Item__c AlertTrackerItem:alertTrackerMap.get(alertTrackerId))
            {
                caseObj = caseMap.get(AlertTrackerItem.Case_Id__c);
                if (caseObj != null) {
                    caseStr += '\r\nCase #' + ++caseIndex + '\r\nCase Number: ' + caseObj.CaseNumber + '\r\nCase Opened Date: ' + caseObj.CreatedDate +  '\r\nCase Reason: ' + caseObj.CEC_Reason_Code__c + '\r\nCase Product: ' + caseObj.Product_Code__c +    '\r\nDescription: ' + caseObj.Description +  '\r\nStore: ' + caseObj.Store__r.Name + '\r\nStore Location: ' + caseObj.Store_Location__c +  '\r\nProduction Code: ' + caseObj.Production_Code__c + '\r\nDate of Manufacture: ' + caseObj.Date_of_Manufacture_str__c + '\r\nPurchase Date: ' + caseObj.Purchase_Date__c +  '\r\n';
                    
                    // Collect the required details to set the subject of the email alert to be sent. This has to be from the latest case and since the alertTrackerItemList is sorted by the last modified date so the case linked to the first alertTrackerItem would be the latest case.
                    
                    /*********** change start -> 03-Sept-15 Support Team changes **********/ 
                    if(!isSubjectInfoSet) {
                        
                        // constructing the subject for email based on case associated with alertracker item.
                        subjectStr = ' ' + caseObj.L2_Product_Category__c + '-' + caseObj.Case_Brand__c + '-' + caseObj.Country_Name__c;
                        
                        isSubjectInfoSet = true;
                    }
                    
                    /*********** change end -> 03-Sept-15 Support Team changes **********/ 
            	}
            }
            
            /*********** change start -> 03-Sept-15 Support Team changes **********/ 
            //alertTrackerCaseMap.put(alertTrackerId, caseStr);
            /*  Map for alert tracker ids and its corresponding list of subject and case description
                list[0] will contain email subject
                list[1] will contain email body contents
            */
            alertTrackerCaseMap.put(alertTrackerId, new List<String>{subjectStr,caseStr});
            
            /*********** change end -> 03-Sept-15 Support Team changes **********/ 
            
        }
        System.debug('~~~alertTrackerCaseMap' + alertTrackerCaseMap);
        return alertTrackerCaseMap;
    }

}