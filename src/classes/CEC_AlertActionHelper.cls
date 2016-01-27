/**********************************************************************
 Name:  CEC_AlertActionHelper
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
  2.0      Sathish         Dec-2015      Class is refactored to CEC_BatchAlertActionHelper & CEC_InstantAlertActionHelper.
 ***********************************************************************/

public without sharing class CEC_AlertActionHelper {
/*
           

   public void createCaseSafetyAlerts(Map<Id, Case> newCaseMap,Map<Id, Case> oldCaseMap){
        
        Case newCase, oldCase;
        Boolean result;
       
        try{
        
            List<Id> caseIds = new List<Id>();
            
            for(Id cId: newCaseMap.keySet()){
                
                newCase = newCaseMap.get(cId);
                oldCase = oldCaseMap.get(cId);
                
                // Check for the Product, Reason code, Market, Day code values are modified 
                result = isValidCaseUpdate(newCase, oldCase);
                if(result){
                    caseIds.add(cId);
                }
            }

            if(!caseIds.isEmpty()){
                
                // Delete the existed Alert tracker items for these cases
                List<cec_Alert_Tracker_Item__c> alertTrackerItems = [SELECT Id from cec_Alert_Tracker_Item__c WHERE Case_Id__c IN :caseIds];
                delete alertTrackerItems;
    
                // Get matching rules for all the cases         
                Map<Id, List<cec_Alert_Rule__c>> caseRuleMap = findMatchingRules(caseIds,newCaseMap);
                
                System.debug('caseRuleMap:: '+caseRuleMap);
                
                if(!caseRuleMap.isEmpty()){

                    Set<Id> selectedIds = caseRuleMap.keySet();
            
                    Map<Id, List<cec_Alert_Tracker__c>> caseAlertTrackerMap = new Map<Id, List<cec_Alert_Tracker__c>>();
                    List<cec_Alert_Tracker__c> alertTrackerList = new List<cec_Alert_Tracker__c>();
                
                    Case caseObj;
                    cec_Alert_Tracker__c alertTracker;
                    
                    String uniqueId;
                    String dayCode;
                    
                    List<cec_Alert_Rule__c> alertRuleList;
                    
                    for(Id cId:selectedIds){
                        
                        caseObj = newCaseMap.get(cId);
                        alertRuleList = caseRuleMap.get(cId);
                
                        for(cec_Alert_Rule__c alertRule:alertRuleList){
                        
                            uniqueId = null;
                            dayCode = '';

                            if(!alertRule.Group_By_Day_Code__c){
                                uniqueId = alertRule.Id + caseObj.Consumer_Product_Descriptor_no_size__c;
                            }else if(alertRule.Group_By_Day_Code__c && caseObj.DayCode__c != null){
                                uniqueId = alertRule.Id + caseObj.DayCode__c + caseObj.Consumer_Product_Descriptor_no_size__c;
                                dayCode = caseObj.DayCode__c;
                            }

                            if(uniqueId != null){
                                boolean flag = false;                                
                                for(cec_Alert_Tracker__c alertTrackerCheck:alertTrackerList) {
                                    if(uniqueId == alertTrackerCheck.Unique_Id__c){
                                        alertTracker = alertTrackerCheck;
                                        flag = true;
                                        break;
                                    }
                                }
                                if(!flag) {
                            
                                    alertTracker = new cec_Alert_Tracker__c();
                                    alertTracker.Unique_Id__c = uniqueId;
                                    alertTracker.Alert_Rule_Id__c = alertRule.Id;
                                    alertTracker.DayCode__c = dayCode;
                                    alertTracker.Product_No_Size__c = caseObj.Consumer_Product_Descriptor_no_size__c;
                                    alertTracker.Trigger_Batch__c = TRUE;
                                    alertTrackerList.add(alertTracker);                                 
                                }
                                if(caseAlertTrackerMap.get(cId) == null){
                                    caseAlertTrackerMap.put(cId, new List<cec_Alert_Tracker__c>());
                                }

                                caseAlertTrackerMap.get(cId).add(alertTracker);
                            }
                        }
                    }
                    
                    upsert alertTrackerList Unique_Id__c;
                    
                    System.debug('alertTrackerList:: '+alertTrackerList);
                    
                    List<cec_Alert_Tracker_Item__c> alertTrackerItemList = new List<cec_Alert_Tracker_Item__c>();
                    
                    cec_Alert_Tracker_Item__c alertTrackerItem;

                    //Set<Id> alertTrackerIds = new Set<Id>();
                                                          
                    for(Id cId : caseAlertTrackerMap.keySet()){
                        
                        for(cec_Alert_Tracker__c caseAlertTracker : caseAlertTrackerMap.get(cId)){
                            alertTrackerItem = new cec_Alert_Tracker_Item__c();     
                            alertTrackerItem.Case_Id__c = cId;
                            alertTrackerItem.Alert_Tracker_Id__c = caseAlertTracker.Id;
                            alertTrackerItemList.add(alertTrackerItem); 
                        }
                    }        
                    insert alertTrackerItemList;
                    System.debug('alertTrackerItemList:: '+alertTrackerItemList);                   
                }   
            }
            
        } catch(Exception e){

            System.debug('Error in CEC_AlertActionHelper -> createCaseSafetyAlerts : ' +  e.getMessage());
            throw e;    
        }
    
    }
    

    public Boolean isValidCaseUpdate(Case newCase, Case oldCase){

        Boolean result = false;
        
        if(newCase.CEC_Product__c != null && newCase.CEC_Product__c != oldCase.CEC_Product__c && newCase.Reason_Code__c != null){
            result = true;
        } else if(newCase.Reason_Code__c != null && newCase.Reason_Code__c != oldCase.Reason_Code__c && newCase.CEC_Product__c != null){
            result = true;
        } else if(newCase.DayCode__c != null && newCase.DayCode__c != oldCase.DayCode__c && newCase.CEC_Product__c != null && newCase.Reason_Code__c != null){
            result = true;
        } else if(newCase.Case_Market__c != null && newCase.Case_Market__c != oldCase.Case_Market__c && newCase.CEC_Product__c != null && newCase.Reason_Code__c != null){
            result = true;
        } else if(newCase.Market__c != null && newCase.Market__c != oldCase.Market__c && newCase.CEC_Product__c != null && newCase.Reason_Code__c != null){
            result = true;
        }

        return result;
    }
    

    public Map<Id, List<cec_Alert_Rule__c>> findMatchingRules(List<Id> caseIds,Map<Id, Case> newCaseMap){
    
        List<String> caseL0ProductCategoryList = new List<String>();
        List<String> caseL2ProductCategoryList = new List<String>();
        
        List<String> caseReasonCodeList = new List<String>();
        
        for(Id cId: caseIds){
            caseL0ProductCategoryList.add(newCaseMap.get(cId).L0_Product_Category__c);
            caseL2ProductCategoryList.add(newCaseMap.get(cId).L2_Product_Category__c);
            caseReasonCodeList.add(newCaseMap.get(cId).L5_Code__c);
        }
        
        // Get all safety & quality alert rules matching the case product category and reason codes       
         List<cec_Alert_Rule__c> alertRules = [SELECT Id, L0_Product_Category__c, L2_Product_Category__c, L5_Reason_Code__c, Market__c, All_Market__c, Group_By_Day_Code__c FROM cec_Alert_Rule__c WHERE Active__c = true AND ((Type__c = 'Safety' AND (L0_Product_Category__c IN :caseL0ProductCategoryList)) OR (Type__c = 'Quality' AND (L2_Product_Category__c IN :caseL2ProductCategoryList))) AND L5_Reason_Code__c IN :caseReasonCodeList];
        Map<Id, List<cec_Alert_Rule__c>> caseRuleMap = new Map<Id, List<cec_Alert_Rule__c>>();
        
        // Assign the corresponding alert rule for the cases
        Case caseObj;
        
        String caseMarket;
        
        for(Id cId: caseIds){
            
            caseObj = newCaseMap.get(cId);
            
            if(caseObj.Case_Market__c != null){
                caseMarket = caseObj.Case_Market__c; 
            }else{
                caseMarket = caseObj.Market__c; 
            }
            
            for(cec_Alert_Rule__c aRule: alertRules){
                if((aRule.L0_Product_Category__c == caseObj.L0_Product_Category__c || aRule.L2_Product_Category__c == caseObj.L2_Product_Category__c) && aRule.L5_Reason_Code__c == caseObj.L5_Code__c && (aRule.Market__c == caseMarket || aRule.All_Market__c == true)){
                    
                    if(caseRuleMap.get(caseObj.Id) == null ){
                        caseRuleMap.put(caseObj.Id,new List<cec_Alert_Rule__c>());
                    }
                    
                    caseRuleMap.get(caseObj.Id).add(aRule);
                }
            }
        }
        
        return caseRuleMap;
    }


    public void sendEmailAlerts(List<cec_Alert_Tracker__c> alertTrackerList){

        if (!alertTrackerList.isEmpty()) {

            try {

                Map<Id,cec_Alert_Tracker__c> alertTrackerMap = new Map<Id,cec_Alert_Tracker__c>(alertTrackerList);
                Set<Id> alertTrackerIds = alertTrackerMap.keySet();
                
                // Construct a map for Alert rule and it's alert tracker ids
                Map<Id,List<Id>> selectedAlertRuleTrackerMap = new Map<Id,List<Id>>();

                for(cec_Alert_Tracker__c alertTracker : alertTrackerList){
                    
                    if(alertTracker.Current_Threshold__c >= alertTracker.Alert_Threshold__c){
                    
                        if(selectedAlertRuleTrackerMap.get(alertTracker.Alert_Rule_Id__c) == null){
                            selectedAlertRuleTrackerMap.put(alertTracker.Alert_Rule_Id__c,new List<Id>());  
                        }
                        
                        selectedAlertRuleTrackerMap.get(alertTracker.Alert_Rule_Id__c).add(alertTracker.Id);
                        
                    }               
                }
                
                // Get alert action records related to the selected alert rules         
                List<cec_Alert_Action__c> alertActionList = [SELECT Name, Alert_Rule_Id__c, Email_Template_Name__c, To__c FROM cec_Alert_Action__c WHERE Alert_Rule_Id__c IN :selectedAlertRuleTrackerMap.keySet() AND Type__c = 'Email'];

                // Construct map for Email template developer name and its template
                Map<String,EmailTemplate> emailTemplateMap = new Map<String,EmailTemplate>();

                List<String> developerNameList = new List<String>(); 
                for(cec_Alert_Action__c alertAction: alertActionList){
                    developerNameList.add(alertAction.Email_Template_Name__c);
                }
                
                List<EmailTemplate> emailTemplateList = [SELECT ID, DeveloperName, Subject, Body FROM EmailTemplate WHERE DeveloperName IN :developerNameList];
                
                for(EmailTemplate et:emailTemplateList){
                    emailTemplateMap.put(et.DeveloperName, et);
                }
               /*********** change start -> 03-Sept-15 Support Team changes ********** 
                
                // Get alert tracker case string map        
                Map<Id,List<String>> alertTrackerCaseMap = getAlertTrackerCaseMap(alertTrackerIds);
                
                /*********** change end -> 03-Sept-15 Support Team changes **********
                
                //Get the From address through custom settings
                cec_Org_Settings__c FromAddress = [select Id, Safety_Alert_Email_Id__c FROM cec_Org_Settings__c];
                system.debug('FromAddress>>>>'+FromAddress.Safety_Alert_Email_Id__c);
                
                
                // set the 'from' Address through Org wide Email Address
                OrgWideEmailAddress[] owea = [select Id from OrgWideEmailAddress where Address = :FromAddress.Safety_Alert_Email_Id__c];
                system.debug('OWEA Contains>>>>>>'+owea.size());
                
                // Send mail logic
                List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
                String[] toAddresses;               
                EmailTemplate eTemplate;
                Messaging.SingleEmailMessage mail;        
                String plainBody;
             
                cec_Alert_Tracker__c aTracker;
                
                // Iterate through all alert actions
                for(cec_Alert_Action__c alertAction: alertActionList){

                    // Iterate through all Alert trackers related to the Alert action's rule
                    for(Id atId:selectedAlertRuleTrackerMap.get(alertAction.Alert_Rule_Id__c)){

                        // Construct email message
                        mail = new Messaging.SingleEmailMessage();
            
                        toAddresses = alertAction.To__c.split(';');
                        mail.setToAddresses(toAddresses);
                        
                        if (owea.size() > 0) {
                            mail.setOrgWideEmailAddressId(owea.get(0).Id);
                        }

                        eTemplate = emailTemplateMap.get(alertAction.Email_Template_Name__c);
                        
                        // If Email template is not available then ignore current action and do not send any mails
                        if(eTemplate == null){
                            System.debug('Email Template is not found for Alert Action - '+alertAction.Name);   
                            break;
                        }
                        
                        plainBody = eTemplate.Body;
                        
                        aTracker = alertTrackerMap.get(atId);
                        
                        // Replace email template merge fields with actual values               
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.Name}',aTracker.Name);
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.Link}',URL.getSalesforceBaseUrl().toExternalForm()+'/'+aTracker.Id);
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.Alert_Rule_Id__c}',aTracker.Alert_Rule_Id__c);
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.Product_No_Size__c}',String.valueOf(aTracker.Product_No_Size__c));
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.L5_Reason_Code__c}',aTracker.L5_Reason_Code__c);
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.Alert_Threshold__c}',String.valueOf(aTracker.Alert_Threshold__c));
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.Current_Threshold__c}',String.valueOf(aTracker.Current_Threshold__c));
                        
                    /*********** change start -> 03-Sept-15 Support Team changes **********
                        plainBody = plainBody.replace('{!cec_Alert_Tracker__c.caseList}',alertTrackerCaseMap.get(atId).get(1));
                        
                        // Set email text body
                        //mail.setSubject(eTemplate.Subject + additionalSubjectInfo);
                        mail.setSubject(eTemplate.Subject + alertTrackerCaseMap.get(atId).get(0));
                        
                        
                    /*********** change end -> 03-Sept-15 Support Team changes ********** 
                        mail.setPlainTextBody(plainBody);
                        
                        mails.add(mail);
                    }
                }                
                // Send all mails
                Messaging.SendEmailResult [] r = Messaging.sendEmail(mails);
                System.debug('Sent Email Result:: '+r);  

                // Uncheck all the trigger email check on the alert tracker.
                for(cec_Alert_Tracker__c alertTracker : alertTrackerList){
                    alertTracker.Trigger_Batch__c = false;                    
                }
                 update alertTrackerList;   

            } catch(Exception e) {
              System.debug(e.getMessage());
              throw e;
            }            
        }
        
    }
    
    
    

    @TestVisible
    private Map<Id,List<String>> getAlertTrackerCaseMap(Set<Id> alertTrackerIds){
    
        // Get all alert tracker items associated with the alert trackers
        List<cec_Alert_Tracker_Item__c> alertTrackerItemList = [SELECT Alert_Tracker_Id__c, Case_Id__c FROM cec_Alert_Tracker_Item__c WHERE Alert_Tracker_Id__c IN :alertTrackerIds ORDER BY LastModifiedDate DESC];
        
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
        /*********** change start -> 03-Sept-15 Support Team changes **********
        subjectStr = '';
        /*********** change end -> 03-Sept-15 Support Team changes ********** 
        
        caseIndex = 0;
        /*********** change start -> 03-Sept-15 Support Team changes ********** 
        isSubjectInfoSet = false;
        /*********** change end -> 03-Sept-15 Support Team changes **********
        
        for(cec_Alert_Tracker_Item__c AlertTrackerItem:alertTrackerMap.get(alertTrackerId))
        {
            caseObj = caseMap.get(AlertTrackerItem.Case_Id__c);
            
            caseStr += '\r\nCase #' + ++caseIndex + '\r\nCase Number: ' + caseObj.CaseNumber + '\r\nCase Opened Date: ' + caseObj.CreatedDate +  '\r\nCase Reason: ' + caseObj.CEC_Reason_Code__c + '\r\nCase Product: ' + caseObj.Product_Code__c +    '\r\nDescription: ' + caseObj.Description +  '\r\nStore: ' + caseObj.Store__r.Name + '\r\nStore Location: ' + caseObj.Store_Location__c +  '\r\nProduction Code: ' + caseObj.Production_Code__c + '\r\nDate of Manufacture: ' + caseObj.Date_of_Manufacture_str__c + '\r\nPurchase Date: ' + caseObj.Purchase_Date__c +  '\r\n';

            // Collect the required details to set the subject of the email alert to be sent. This has to be from the latest case and since the alertTrackerItemList is sorted by the last modified date so the case linked to the first alertTrackerItem would be the latest case.
            
            /*********** change start -> 03-Sept-15 Support Team changes **********
            if(!isSubjectInfoSet) {
              
                // constructing the subject for email based on case associated with alertracker item.
                subjectStr = ' ' + caseObj.L2_Product_Category__c + '-' + caseObj.Case_Brand__c + '-' + caseObj.Country_Name__c;
                
                isSubjectInfoSet = true;
            }
            
            /*********** change end -> 03-Sept-15 Support Team changes **********
            
        }
        
        /*********** change start -> 03-Sept-15 Support Team changes **********/ 
            //alertTrackerCaseMap.put(alertTrackerId, caseStr);
            /*  Map for alert tracker ids and its corresponding list of subject and case description
            list[0] will contain email subject
            list[1] will contain email body contents
            
            alertTrackerCaseMap.put(alertTrackerId, new List<String>{subjectStr,caseStr});
                
        /*********** change end -> 03-Sept-15 Support Team changes **********
                
        }
        System.debug('~~~alertTrackerCaseMap' + alertTrackerCaseMap);
        return alertTrackerCaseMap;
    } */
}