/***********************************************************************************
Name:  CEC_InstantAlertActionHelper
Copyright@: 2015  Unilever
====================================================================================
====================================================================================
Purpose: Helper class for the Instant Alert actions                                                                                            

=====================================================================================
=====================================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0      Sathish           Dec-2015      New class refactored from CEC_AlertActionHelper Class.   
1.1      Koti              Dec-2015      Added updateInactiveAlertTrackerItems() method.
1.2      Sathish           Feb-2016      Updated getMatchingAlertRules() method for CSC-4037
*************************************************************************************/
public without sharing class CEC_InstantAlertActionHelper {
    
    // A wrapper class which holds all the alert related data for a case. Key - CaseId, Value - CaseAlertWrapper.
    private Map<Id, AlertRuleWrapper> alertRuleWrapperMap = new Map<Id, AlertRuleWrapper>();
    
    /******************************************************************* 
        Purpose: 
            Create the Alert related data if a case matches Alert Rule.
        Parameters: 
            oldCaseMap - Map which has the old 'Case' data before doing modification.
            newCaseMap - Map which has the new 'Case' data after doing modification.
        Throws : 
            Send a notification mail with the case details.
    ********************************************************************/
    public void createAlertEntries(Map<Id, Case> oldCaseMap, Map<Id, Case> newCaseMap) {
        try{
            System.debug('Entering CreateAlertEntries() method. OldCaseMap = ' + oldCaseMap);
            System.debug('Entering CreateAlertEntries() method. NewCaseMap = ' + newCaseMap);
            
            // STEP 1 (Data Preparation) : Get all the elgible case Id's which has changes in either one of the five fields <Product Code, Reason Code, Day Code, Case Market, Market)
            List<Id> allModifiedCaseIdList = getAllModifiedCases(oldCaseMap, newCaseMap);
            
            if(!allModifiedCaseIdList.isEmpty()) {
                // STEP 2 : (Transaction) Delete all the alert tracker Items for the alert eligible cases 
                deleteExistingTrackerItems(allModifiedCaseIdList); 
                
                // STEP 3 (Data Preparation) : Find all the matching Alert Rules (if available) for the modified Cases.
                Set<Id> allAlertRuleIdSet = getMatchingAlertRules(allModifiedCaseIdList, newCaseMap);
                
                if(allAlertRuleIdSet != null && allAlertRuleIdSet.size() > 0) {
                    // STEP 4 : (Transaction) Update the Alert Tracker Items as per the 30 Days Limit logic
                    updateInactiveAlertTrackerItems();
                    
                    // STEP 5 : (Data Preparation) : Find all the Alert Action configured for the Alert Rules.
                    getMatchingAlertAction(allAlertRuleIdSet);
                    
                    // STEP 6 : (Transaction) Create Alert Tracker for the configured Alert Rules.
                    createAlertTracker();
                    
                    // STEP 7 : (Transaction) Create Alert Tracker Items for the configured Alert Rules.
                    createAlertTrackerItems();
                    
                    // STEP 8 : (Transaction) Create Case Action for the Alert Action of type 'Questionnaire'
                    createCaseAction();
                    
                    
                } 
                System.debug('Exiting CreateAlertEntries() method.');
            }
        } catch (Exception e) {
            // Get all the Case Numbers for the error notification.
            List<String> allCaseNumbers = new List<String>();
            for(Id caseId : oldCaseMap.keySet()) {
                allCaseNumbers.add(oldCaseMap.get(caseId).caseNumber);
            }
            String msgBodyStr = '*** ERROR IN CEC_InstantAlertActionHelper for creating Alerts *** \n \n \n Details :: ' + e.getMessage() 
                + '\n\n\nCaseIds are as follows\n' + String.join(allCaseNumbers, '\n');
            CEC_Util.sendNotificationEmail(msgBodyStr, 'CEC Notification : Alert Functionality Exception');
            System.debug('Exception in CEC_InstantAlertActionHelper -> createAlertEntries : ' +  e.getMessage());            
        }
    }
    
    /******************************************************************* 
    Purpose: 
        Util Method to check whether there is any data change in either 
        one of the five fields <Product Code, Reason Code, Day Code, Case Market, Market)
        for a single case.
    Parameters: 
        oldCase - Obj which has the old 'Case' data before doing modification.
        newCase - Obj which has the new 'Case' data after doing modification.
    Returns : Boolean
        true - if there is a change in one of the five fields
        false - No change in the five fields.
    ********************************************************************/
    private Boolean isValidCaseUpdate(Case oldCase, Case newCase){
        
        System.debug('Entering isValidCaseUpdate() method. OldCase = ' + oldCase);
        System.debug('Entering isValidCaseUpdate() method. NewCase = ' + newCase);
        
        Boolean result = false;        
        if(newCase.CEC_Product__c != null && newCase.CEC_Product__c != oldCase.CEC_Product__c && newCase.Reason_Code__c != null){
            result = true;
        } else if(newCase.Reason_Code__c != null && newCase.Reason_Code__c != oldCase.Reason_Code__c && newCase.CEC_Product__c != null){
            result = true;
        } else if(newCase.DayCode__c != oldCase.DayCode__c && newCase.CEC_Product__c != null && newCase.Reason_Code__c != null){
            result = true;
        } else if(newCase.Case_Market__c != oldCase.Case_Market__c && newCase.CEC_Product__c != null && newCase.Reason_Code__c != null){
            result = true;
        } else if(newCase.Market__c != null && newCase.Market__c != oldCase.Market__c && newCase.CEC_Product__c != null && newCase.Reason_Code__c != null){
            result = true;
        }
        System.debug('Exiting isValidCaseUpdate() method. Result = ' + result);
        return result;
    }
    
    
    /******************************************************************* 
    Purpose: 
        Method to check whether there is any data change in either 
        one of the five fields <Product Code, Reason Code, Day Code, Case Market, Market)
        for all the cases
    Parameters: 
        oldCaseMap - Map which has the old 'Case' data before doing modification.
        newCaseMap - Map which has the new 'Case' data after doing modification.
    Returns :
        List - List of Case Ids which has the modification.
    ********************************************************************/
    private List<Id> getAllModifiedCases(Map<Id, Case> oldCaseMap, Map<Id, Case> newCaseMap) {
        System.debug('Entering getAllModifiedCases() method. OldCaseMap = ' + oldCaseMap);
        System.debug('Entering getAllModifiedCases() method. newCaseMap = ' + newCaseMap);
        List<Id> allModifiedCaseIdList = new List<Id>();
        Boolean result;
        Case newCase, oldCase;
        for(Id caseIdItr : newCaseMap.keySet()) {
            oldCase = oldCaseMap.get(caseIdItr);
            newCase = newCaseMap.get(caseIdItr);                
            result = isValidCaseUpdate(oldCase, newCase);
            if(result) {
                allModifiedCaseIdList.add(caseIdItr);
            }
        }
        System.debug('Exiting getAllModifiedCases() method allModifiedCaseIdList = ' + allModifiedCaseIdList);
        return allModifiedCaseIdList;   
    }
    
    /******************************************************************* 
    Purpose: 
        Method to delete all the existing alert tracker items for the existing cases.
    Parameters: 
        allModifiedCaseIdList - List of all the Case Ids.
    ********************************************************************/
    private void deleteExistingTrackerItems(List<Id> allModifiedCaseIdList) {
        System.debug('Entering deleteExistingTrackerItems() method');
        List<cec_Alert_Tracker_Item__c> alertTrackerItems = [SELECT Id from cec_Alert_Tracker_Item__c 
                                                             WHERE Case_Id__c IN :allModifiedCaseIdList];
        delete alertTrackerItems;
        System.debug('Exiting deleteExistingTrackerItems() method');
    }
    
    /******************************************************************* 
    Purpose: 
        Method to get data for all the Alert Rules (if available) for the eligible cases.
    Parameters: 
        caseIds - List of eligible Case id which was updated to do alert checks.
        newCaseMap - Map which has the new 'Case' data after doing modification.
    Returns :
        Set<Id> - List of all the alert Rule Ids matching the case.
    ********************************************************************/
    private Set<Id> getMatchingAlertRules(List<Id> caseIds, Map<Id, Case> newCaseMap){
        System.debug('Entering  getMatchingAlertRules() method caseIds =' + caseIds);
        System.debug('Entering  getMatchingAlertRules() method newCaseMap =' + newCaseMap);
        
        // Get all the Alert Rule ID's matching for all the cases available in newCaseMap.
        Case caseObj;        
        String caseMarket; 
        Set<Id> allAlertRuleIdSet = null;
        Set<String> caseL0ProductCategoryList = new Set<String>();
        Set<String> caseL2ProductCategoryList = new Set<String>();
        Set<String> caseL4ProductCategoryList = new Set<String>();
        Set<String> caseNoProdSizeDescList = new Set<String>();        
        Set<String> caseR5ReasonCodeList = new Set<String>();
        String l0ProductCategoryConcatValue, l2ProductCategoryConcatValue, l4ProductCategoryConcatValue, r5ReasonCodeConcatValue; 
        
        for(Id caseIdItr : caseIds){
            caseObj = newCaseMap.get(caseIdItr);
            // Get L0 value. If it is null return empty.
            l0ProductCategoryConcatValue = (String.isNotBlank(caseObj.L0_Product_Category__c))?
                                            caseObj.L0_Product_Category__c:'';
            //l2ProductCategoryConcatValue = Concatenate L0 + L1 + L2 values for each case
            l2ProductCategoryConcatValue = CEC_Util.constructFinalProdCategoryValue(
                                            l0ProductCategoryConcatValue,
                                            caseObj.L1_Product_Category__c,
                                            caseObj.L2_Product_Category__c);
            // l4ProductCategoryConcatValue = Concatenate L0 + L1 + L2 + L3 + L4 values for each case
            l4ProductCategoryConcatValue = CEC_Util.constructFinalProdCategoryValue(
                                            l2ProductCategoryConcatValue, 
                                            caseObj.L3_Product_Category__c,
                                            caseObj.L4_Product_Category__c);
            // r5ReasonCodeConcatValue = Concatenate R1 + R2 + R3 + R4 + R5 values for each case
            r5ReasonCodeConcatValue = (String.isNotBlank(caseObj.Global_Reason_L1_desc__c))?
                                            caseObj.Global_Reason_L1_desc__c:'';

            r5ReasonCodeConcatValue = CEC_Util.constructFinalReasonCodeValue(r5ReasonCodeConcatValue,
                                        caseObj.Global_Reason_L2_desc__c, caseObj.Global_Reason_L3_desc__c,
                                        caseObj.Global_Reason_L4_desc__c, caseObj.Global_Reason_L5_desc__c);

            // Concatenate L0 values for each case
            caseL0ProductCategoryList.add(l0ProductCategoryConcatValue);
            caseL2ProductCategoryList.add(l2ProductCategoryConcatValue);
            caseL4ProductCategoryList.add(l4ProductCategoryConcatValue);
            caseR5ReasonCodeList.add(r5ReasonCodeConcatValue);
            // Get the Consumer Product No size info in the String list
            if(String.isNotBlank(caseObj.Consumer_Product_Descriptor_no_size__c)) {
                caseNoProdSizeDescList.add(caseObj.Consumer_Product_Descriptor_no_size__c);
            }
            
        }

        System.debug('**** caseL0ProductCategoryList = ' + caseL0ProductCategoryList) ;
        System.debug('**** caseL2ProductCategoryList = ' + caseL2ProductCategoryList) ;
        System.debug('**** caseL4ProductCategoryList = ' + caseL4ProductCategoryList) ;
        System.debug('**** caseNoProdSizeDescList = ' + caseNoProdSizeDescList) ;
        
        // Get all safety & quality alert rules matching the case product category and reason codes  
        /* The Query condition is to select all the alert rules matching the following condition.     
                1. Active - True.
                2. Type :
                    2.1 Safety : 
                        2.1.1 Product Level: 0, Check only L0 Prod Category.
                        2.1.2 Product Level : 4, Check all L0, L1, L2, L3, L4 Prod Category.
                    2.2 Quality :
                        2.2.1. Product Level: 2, Check all L0, L1, L2 Prod Category.
                        2.2.2 Product Level : 4, Check all L0, L1, L2, L3, L4 Prod Category.
                3. Case Product : not null and matches 'Consumer Product Descriptor No Size' value.
                4. Reason Code:
                    4.1 Level 5 : Check all R1, R2, R3, R4, R5 reason code values.

            High Level Query Criteria for the above mentioned points is : 1 AND (2 OR 3) AND 4

        */
        List<cec_Alert_Rule__c> alertRules =    [SELECT Id, L0_Product_Category__c, L2_Product_Category__c,
                                                L4_Product_Category__c, L5_Reason_Code__c, Market__c,
                                                All_Market__c, Group_By_Day_Code__c, X30_Days_Limit__c,
                                                Consumer_Product_Descriptor_no_size__c, Product_Level__c, Case_Product__c,
                                                Product_Category_Concat_Value__c, ReasonCode_Concat_Value__c
                                                FROM cec_Alert_Rule__c 
                                                WHERE Active__c = true AND 
                                                (((Type__c = 'Safety' AND (Product_Level__c = '0' AND Product_Category_Concat_Value__c IN :caseL0ProductCategoryList)) OR 
                                                (Type__c = 'Quality' AND (Product_Level__c = '2' AND Product_Category_Concat_Value__c IN :caseL2ProductCategoryList)) OR
                                                (Product_Level__c = '4' AND Product_Category_Concat_Value__c IN :caseL4ProductCategoryList)) OR  
                                                (Case_Product__c != null AND Consumer_Product_Descriptor_no_size__c IN : caseNoProdSizeDescList)) AND 
                                                ReasonCode_Concat_Value__c IN :caseR5ReasonCodeList];
        
        System.debug('**** Matching Alert Rules = ' + alertRules);
        // Assign the corresponding alert rule for the cases

        /** For each case, construct the Alert Rules and add it to the wrapper. Also maintain a separate copy       
            to maintain all the alert rules for all the cases for a easy DML Insert operation **/
        for(Id caseIdItr: caseIds){  
            
            caseObj = newCaseMap.get(caseIdItr); 
            
            if(caseObj.Case_Market__c != null){
                caseMarket = caseObj.Case_Market__c; 
            }else{
                caseMarket = caseObj.Market__c;  
            }            
            // Get L0 value. If it is null return empty.
            l0ProductCategoryConcatValue = (String.isNotBlank(caseObj.L0_Product_Category__c))?
                                            caseObj.L0_Product_Category__c:'';
            //l2ProductCategoryConcatValue = Concatenate L0 + L1 + L2 values for each case
            l2ProductCategoryConcatValue = CEC_Util.constructFinalProdCategoryValue(
                                            l0ProductCategoryConcatValue,
                                            caseObj.L1_Product_Category__c,
                                            caseObj.L2_Product_Category__c);
            // l4ProductCategoryConcatValue = Concatenate L0 + L1 + L2 + L3 + L4 values for each case
            l4ProductCategoryConcatValue = CEC_Util.constructFinalProdCategoryValue(
                                            l2ProductCategoryConcatValue, 
                                            caseObj.L3_Product_Category__c,
                                            caseObj.L4_Product_Category__c);
            // r5ReasonCodeConcatValue = Concatenate R1 + R2 + R3 + R4 + R5 values for each case
            r5ReasonCodeConcatValue = (String.isNotBlank(caseObj.Global_Reason_L1_desc__c))?
                                            caseObj.Global_Reason_L1_desc__c:'';

            r5ReasonCodeConcatValue = CEC_Util.constructFinalReasonCodeValue(r5ReasonCodeConcatValue,
                                        caseObj.Global_Reason_L2_desc__c, caseObj.Global_Reason_L3_desc__c,
                                        caseObj.Global_Reason_L4_desc__c, caseObj.Global_Reason_L5_desc__c);

            for(cec_Alert_Rule__c aRule: alertRules){
                
                System.debug('*****30 Days Limit Alert Rule*******'+aRule.X30_Days_Limit__c);


                if(((aRule.Product_Level__c == CEC_Constants.VALUE_ZERO && 
                        aRule.Product_Category_Concat_Value__c == l0ProductCategoryConcatValue) || 
                    (aRule.Product_Level__c == CEC_Constants.VALUE_TWO && 
                        aRule.Product_Category_Concat_Value__c == l2ProductCategoryConcatValue) ||
                    (aRule.Product_Level__c == CEC_Constants.VALUE_FOUR && 
                        aRule.Product_Category_Concat_Value__c == l4ProductCategoryConcatValue) ||
                    (aRule.Case_Product__c != null &&
                        aRule.Consumer_Product_Descriptor_no_size__c == caseObj.Consumer_Product_Descriptor_no_size__c)) && 
                    aRule.ReasonCode_Concat_Value__c == r5ReasonCodeConcatValue && 
                    (aRule.Market__c == caseMarket || aRule.All_Market__c == true)){
                       
                       if (alertRuleWrapperMap.get(aRule.Id) == null) {
                           alertRuleWrapperMap.put(aRule.Id, new AlertRuleWrapper(aRule.Id, aRule));
                       }                   
                       AlertRuleWrapper alertWrapper = alertRuleWrapperMap.get(aRule.Id);
                       alertWrapper.addCase(caseObj);
                       if(allAlertRuleIdSet == null) {
                           allAlertRuleIdSet = new Set<Id>();
                       }
                       allAlertRuleIdSet.add(aRule.Id);
                   }
            }
        }
        System.debug('Exiting getMatchingAlertRules() method allAlertRuleIdSet = ' + allAlertRuleIdSet);
        return allAlertRuleIdSet;
    }
    
    /******************************************************************* 
    Purpose: 
        Method to get data for all the Alert Actions configured for the Alert Rules
    Parameters: 
        allAlertRuleIdSet - List of all the Alert Rule Id for the cases.
    ********************************************************************/
    private void getMatchingAlertAction(Set<Id> allAlertRuleIdSet) {
        
        System.debug('Entering getMatchingAlertAction Method. allAlertRuleIdSet = ' + allAlertRuleIdSet);
        // Get all the alert actions for the alert rules.
        List<cec_Alert_Action__c> alertActionList = [SELECT Id, Alert_Rule_Id__c, Q12__c, Q2__c, Q3__c,
                                                     Q4__c, Q5__c, Q6__c, Q7__c, Q8__c,Q9__c, 
                                                     Q10__c, Q11__c,Survey_Id__c, Survey_Name__c, Type__c 
                                                     FROM cec_Alert_Action__c 
                                                     WHERE  Alert_Rule_Id__c IN :allAlertRuleIdSet]; 
        
        
        if (alertActionList != null && alertActionList.size() > 0) {
            AlertRuleWrapper alertWrapper = null;
            // Add the Alert Action to the wrapper.
            for(cec_Alert_Action__c alertAction : alertActionList) {
                alertWrapper = alertRuleWrapperMap.get(alertAction.Alert_Rule_Id__c);
                
                // If AlertWrapperMap has AlertRule not null then add the Alert Action.Else something is wrong.
                if (alertWrapper != null) {
                    
                    alertWrapper.addAlertAction(alertAction);
                    if(alertAction.Type__c == 'Questionnaire') {
                        alertWrapper.addQuestionnaireAlertAction(alertAction);   
                    }   
                }
            }
        }   
        System.debug('Exiting getMatchingAlertAction() method. alertRuleWrapperMap = ' + alertRuleWrapperMap);
    }
    
    /******************************************************************* 
    Purpose: 
        Method to create the Alert Tracker records for the cases.
    ********************************************************************/
    private void createAlertTracker(){
        System.debug('Entering createAlertTracker() method. alertRuleWrapperMap = ' + alertRuleWrapperMap);
        if(alertRuleWrapperMap.size()> 0) {
            String uniqueId;
            String dayCode;
            // To keep a copy of all the alert tracker list for all the cases for DML operation
            List<cec_Alert_Tracker__c> masterAlertTrackerList = new List<cec_Alert_Tracker__c>();
            cec_Alert_Tracker__c alertTracker;
            // Iterate for each case and for each alert rule and create the alert Tracker records.
            for (Id alertRuleID : alertRuleWrapperMap.keySet()) {                
                AlertRuleWrapper alertWrapper = alertRuleWrapperMap.get(alertRuleID);
                cec_Alert_Rule__c alertRule = alertWrapper.alertRule;
                
                if(alertWrapper.caseList != null && !alertWrapper.caseList.IsEmpty()) {
                    for(Case caseObj : alertWrapper.caseList) {
                    
                        uniqueId = null;
                        
                        // Create Unique Id based on the daycode check on the alert rule.
                        if(!alertRule.Group_By_Day_Code__c && caseObj.DayCode__c == null){
                            uniqueId = alertRule.Id + caseObj.Consumer_Product_Descriptor_no_size__c;
                        }else if(alertRule.Group_By_Day_Code__c && caseObj.DayCode__c != null){
                            uniqueId = alertRule.Id + caseObj.DayCode__c + caseObj.Consumer_Product_Descriptor_no_size__c;
                            dayCode = caseObj.DayCode__c;
                        }
                        if(uniqueId != null){
                            boolean flag = false;
                            // Skip if UNiqueId is already available.
                            for(cec_Alert_Tracker__c alertTrackerCheck:masterAlertTrackerList) {
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
                                // Add the alert tracker in the master list to do the insert
                                masterAlertTrackerList.add(alertTracker);
                            }
                            // Add the alert tracker to the map in the wrapper per Case Id.
                            alertWrapper.addAlertTracker(caseObj.Id, alertTracker);
                        }                        
                    }
                }
            }
            // Update the master Alert Tracker List for all the case and all the rules.
            if (!masterAlertTrackerList.isEmpty()) {
                upsert masterAlertTrackerList Unique_Id__c;
            }
            System.debug('Exiting createAlertTracker() method. masterAlertTrackerList = ' + masterAlertTrackerList);
        }        
    }
    
    /******************************************************************* 
    Purpose: 
        Method to create the Alert Tracker Items records for the cases.
    ********************************************************************/
    private void createAlertTrackerItems() {
        System.debug('Entering createAlertTrackerItems() method. alertRuleWrapperMap = ' + alertRuleWrapperMap);
        if(alertRuleWrapperMap.size()> 0) {
            cec_Alert_Tracker_Item__c alertTrackerItem;
            List<cec_Alert_Tracker_Item__c> masterAlertTrackerItemList = new List<cec_Alert_Tracker_Item__c>();
            // For each case and alert tracker create an alert tracker Item.
            for (Id alertRuleId : alertRuleWrapperMap.keySet()) {
                AlertRuleWrapper alertWrapper = alertRuleWrapperMap.get(alertRuleId);
                // For each alert get the caseAlertTrackerMap and create TrackerItems
                if(alertWrapper.caseAlertTrackerMap != null && alertWrapper.caseAlertTrackerMap.size() > 0) {
                    
                    for(Id caseId : alertWrapper.caseAlertTrackerMap.keySet()) {
                        List<cec_Alert_Tracker__c> alerTrackerList = alertWrapper.caseAlertTrackerMap.get(caseId);
                        for (cec_Alert_Tracker__c alertTracker : alerTrackerList) {
                            alertTrackerItem = new cec_Alert_Tracker_Item__c();     
                            alertTrackerItem.Case_Id__c = caseId;
                            alertTrackerItem.Alert_Tracker_Id__c = alertTracker.Id;
                            // Add the alert tracker item in the master list to do the insert
                            masterAlertTrackerItemList.add(alertTrackerItem);    
                            // Add the alert tracker to the wrapper per Case Id.
                            alertWrapper.addAlertTrackerItem(caseId, alertTrackerItem);                
                        }
                    }
                }    
            }
            // Update the master Alert Tracker Item List for all the case and all the rules.
            if(!masterAlertTrackerItemList.isEmpty()) {
                insert masterAlertTrackerItemList;    
            }
            System.debug('Exiting createAlertTrackerItems() method. masterAlertTrackerItemList = ' + masterAlertTrackerItemList);
        }
    } 
    
    /******************************************************************* 
    Purpose: 
        Method to update the Alert Tracker Items as Active = 'N' for the Alert Rule where '30 Days Limit' is enabled.
    ********************************************************************/
    private void updateInactiveAlertTrackerItems() {
        System.debug('Entering UpdateInactiveAlertTrackerItems() method');
        if(alertRuleWrapperMap.size()> 0) {
            Set<Id> alertRuleIdSet = New Set<Id>();
            AlertRuleWrapper alertWrapper = null;
            for (Id alertRuleId : alertRuleWrapperMap.keySet()) {           
                alertWrapper = alertRuleWrapperMap.get(alertRuleId);
                // Get alert rules which has 30 days limit check and also alerttrackerrs.
                if(alertWrapper.thirtyDaysLimitCheck) {
                    alertRuleIdSet.add(alertRuleId);
                }    
            }
            if(alertRuleIdSet.size()>0){
                List<cec_Alert_Tracker_Item__c> oldActiveAlertTrackerItemList = [SELECT Id, Active__c, Alert_Rule_Id__c 
                                                                                 FROM cec_Alert_Tracker_Item__c 
                                                                                 WHERE Active__c = TRUE
                                                                                 AND CreatedDate < LAST_N_DAYS:30 
                                                                                 AND Alert_Rule_Id__c IN :alertRuleIdSet];
                System.debug('********Active ATItems************'+oldActiveAlertTrackerItemList);
                // Update the Active field of  Alert Tracker Item as false .
                if(oldActiveAlertTrackerItemList.size()>0) {
                    List<cec_Alert_Tracker_Item__c> inactiveAlertTrackerItemList = new List<cec_Alert_Tracker_Item__c>();
                    for(cec_Alert_Tracker_Item__c alertTrackerItem : oldActiveAlertTrackerItemList){
                        alertTrackerItem.Active__c = false;
                        inactiveAlertTrackerItemList.add(alertTrackerItem);
                    }
                    System.debug('********INActive ATItems************'+inactiveAlertTrackerItemList);
                    // Update the Inactive Alert Tracker Item List for all the case and all the rules.
                    if(inactiveAlertTrackerItemList.size()>0) {
                        update inactiveAlertTrackerItemList;    
                    }
                }
            }
            System.debug('Exiting UpdateInactiveAlertTrackerItems() method');
        }
    }
    
    /******************************************************************* 
    Purpose: 
        Method to create the Case ACtion for the Alert ACtion which is of 
        Type 'Questionnaire'
    ********************************************************************/
    private void createCaseAction() {
        System.debug('Entering createCaseAction() method');
        if(alertRuleWrapperMap.size()> 0) {
            cec_Case_Action__c caseAction;
            Id alertTrackerItemId;
            List<cec_Case_Action__c> masterCaseActionList = new List<cec_Case_Action__c>();
            // For each case id and alert action create a case Action record.
            for (Id alertRuleId : alertRuleWrapperMap.keySet()) {
                AlertRuleWrapper alertWrapper = alertRuleWrapperMap.get(alertRuleId);
                // If there is a Questionnaire Alert Action and AlertTrackerItem List then create Case Action.
                if(alertWrapper.questionnaireAlertActionList != null && !alertWrapper.questionnaireAlertActionList.IsEmpty()
                   && alertWrapper.caseAlertTrackerItemMap!= null && alertWrapper.caseAlertTrackerItemMap.size() > 0) {
                       for(cec_Alert_Action__c alertAction : alertWrapper.questionnaireAlertActionList) {
                           for(Id caseId : alertWrapper.caseAlertTrackerItemMap.keySet()) {
                               // At any point of time AN alert rule for a case will have only one alerttracker item.
                               alertTrackerItemId = alertWrapper.caseAlertTrackerItemMap.get(caseId).get(0).Id;
                               caseAction = constructCaseActionObject(caseId, alertTrackerItemId, alertAction);
                               masterCaseActionList.add(caseAction);   
                           } 
                       }
                   }   
            }
            if(masterCaseActionList.size() > 0) {
                insert masterCaseActionList;
            }    
        }
        System.debug('Exiting createCaseAction() method');    
    }
    
    /******************************************************************* 
    Purpose: 
        Method to Construct the Case ACtion object
    Parameters: 
        caseId - case Id
        alertTrackerItemId - AlerTrackerItem Id
        alertAction - Alert Action of type 'Questionnaire'
    Return:
        cec_Case_Action__c - Case Action object which the required details copied from Alert ACtion.
    ********************************************************************/    
    private cec_Case_Action__c constructCaseActionObject(Id caseId, Id alertTrackerItemId, cec_Alert_Action__c alertAction) {
        System.debug('Entering constructCaseActionObject() method. caseId = ' + caseId);
        System.debug('Entering constructCaseActionObject() method. alertTrackerItemId = ' + alertTrackerItemId);
        System.debug('Entering constructCaseActionObject() method. alertAction = ' + alertAction);
        cec_Case_Action__c caseAction = new cec_Case_Action__c();        
        caseAction.Alert_Tracker_Item__c = alertTrackerItemId;        
        caseAction.Case_Id__c = caseId;
        caseAction.Q12__c = alertAction.Q12__c;
        caseAction.Q2__c = alertAction.Q2__c;
        caseAction.Q3__c = alertAction.Q3__c;
        caseAction.Q4__c = alertAction.Q4__c;
        caseAction.Q5__c = alertAction.Q5__c;
        caseAction.Q6__c = alertAction.Q6__c;
        caseAction.Q7__c = alertAction.Q7__c;
        caseAction.Q8__c = alertAction.Q8__c;
        caseAction.Q9__c = alertAction.Q9__c;
        caseAction.Q10__c = alertAction.Q10__c;
        caseAction.Q11__c = alertAction.Q11__c;
        caseAction.Survey_Id__c = alertAction.Survey_Id__c;
        caseAction.Survey_Name__c = alertAction.Survey_Name__c;
        
        System.debug('Exiting constructCaseActionObject() method. caseAction = ' + caseAction);    
        return caseAction;  
    }
    
    /******************************************************************* 
    Purpose: 
        Wrapper class to hold all the alert related data for a case.
    ********************************************************************/
    public class AlertRuleWrapper {
        // Salesforce Id for the AlertRule.
        public String alertRuleId{get; set;}
        // Alert Rule object.
        public cec_Alert_Rule__c alertRule{get;set;}
        // All the cases configured for the Alert Rule.
        public List<Case> caseList{get; set;}
        // All the Alert Action configured for the Alert rule.
        public List<cec_Alert_Action__c> alertActionList{get; set;}
        // All the Alert Action of type 'Questionnaire' configured for the Alert rule.
        public List<cec_Alert_Action__c> questionnaireAlertActionList{get; set;}
        // All the Alert Trackers created per case. Key: CaseId, Value : List
        public Map<Id, List<cec_Alert_Tracker__c>> caseAlertTrackerMap{get;set;}
        // All the Alert TrackerItems created per case. Key: CaseId, Value : List
        public Map<Id, List<cec_Alert_Tracker_Item__c>> caseAlertTrackerItemMap{get;set;}
        // 30 days Rolling check
        public Boolean thirtyDaysLimitCheck{
            get {
                if (this.alertRule != null) {
                    return this.alertRule.X30_Days_Limit__c;
                } else {
                    return false;
                }
            }
            set;
        }
        
        // Constructor
        public AlertRuleWrapper(String alertRuleId, cec_Alert_Rule__c alertRule) {
            this.alertRuleId = alertRuleId;
            this.alertRule = alertRule;
        }
        
        // Util method to add Case to the wrapper instance.
        public void addCase(Case caseObj) {
            if (this.caseList == null) {
                this.caseList = new List<Case>();
            }
            this.caseList.add(caseObj);
        }
        
        // Util method to add alertAction to the wrapper instance.
        public void addAlertAction(cec_Alert_Action__c alertAction) {
            if (this.alertActionList == null) {
                this.alertActionList = new List<cec_Alert_Action__c>();
            }
            this.alertActionList.add(alertAction);
        }
        
        // Util method to add questionnaireAlertAction to the wrapper instance.
        public void addQuestionnaireAlertAction(cec_Alert_Action__c questionnaireAlertAction) {
            if (this.questionnaireAlertActionList == null) {
                this.questionnaireAlertActionList = new List<cec_Alert_Action__c>();
            }
            this.questionnaireAlertActionList.add(questionnaireAlertAction);
        }
        
        // Util method to add alertTracker to the wrapper instance.
        public void addAlertTracker(Id caseId, cec_Alert_Tracker__c alertTracker) {
            if(this.caseAlertTrackerMap == null) {
                this.caseAlertTrackerMap = new Map<Id, List<cec_Alert_Tracker__c>>();
            }
            if (this.caseAlertTrackerMap.get(caseId) == null) {
                this.caseAlertTrackerMap.put(caseId, new List<cec_Alert_Tracker__c>());
            }
            this.caseAlertTrackerMap.get(caseId).add(alertTracker);
        }
        
        // Util method to add alertTrackerItem to the wrapper instance.
        public void addAlertTrackerItem(Id caseId, cec_Alert_Tracker_Item__c alertTrackerItem) {
            if(this.caseAlertTrackerItemMap == null) {
                this.caseAlertTrackerItemMap = new Map<Id, List<cec_Alert_Tracker_Item__c>>();
            }
            if (this.caseAlertTrackerItemMap.get(caseId) == null) {
                this.caseAlertTrackerItemMap.put(caseId, new List<cec_Alert_Tracker_Item__c>());
            }
            this.caseAlertTrackerItemMap.get(caseId).add(alertTrackerItem);
        }
    }
}