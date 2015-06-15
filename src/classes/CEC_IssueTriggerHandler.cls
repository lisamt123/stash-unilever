/**********************************************************************
 Name:  CEC_IssueTriggerHandler ()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  for Issue                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                  Description
   1.0 -   Aalokkumar       19/09/2014       INITIAL DEVELOPMENT          Rule Matching  
****************************************************************************/

public with sharing class CEC_IssueTriggerHandler { 
  
//For Rule Matching 
  public void forAfterInsert(map<id,cec_Issue__c> IssueNewMap){
system.debug('~~~~~Entering cec_Issue__c: '+ ' IssueNewMap'+IssueNewMap);

//pass old map and new map for CEC_CaseFrequentCallerHelper class    
   CEC_IssueRuleMatchingHelper oCEC_IssueRuleMatchingHelper = new CEC_IssueRuleMatchingHelper();
    oCEC_IssueRuleMatchingHelper.ruleMatch(IssueNewMap);

system.debug('~~~~~Exiting  CEC_IssueTriggerHandler: ');    
    
  }      

}