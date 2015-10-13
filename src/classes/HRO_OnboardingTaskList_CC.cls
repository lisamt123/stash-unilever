/**********************************************************************
 Name:  HRO_OnboardingTaskList_CC
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Controller class used HRO_OnboardingTaskList component 
and HRO_OverduedTasks responsible for displaying accurate 
list of tasks inside email
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0   Karol Szepietowksi        10/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

global with sharing class HRO_OnboardingTaskList_CC {
    public Date cStartDate{get;set;}
    public String cRecordId{get;set;}
    public String cLeaderName{get;set;}
    public String cOwnerName{get;set;}
    public String cOwnerId{get;set;}
    public String cPhase{get;set;}
    public String cTaskId{get;set;}
    public String cTaskLink{get;set;}
    
    public HRO_OnboardingTaskList_CC(){
        
    }
    
   /*******************************************************************
   Purpose:  Retrive Task list for particual phase                                                      
   Parameters: []
   Returns: [List<OnboardingTasksWrapper>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
    public List<OnboardingTasksWrapper> getTaskAssignedToPhase(){
        system.debug('*****HRO entering getTaskAssignedToPhase()');
        String instanceUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        List<OnboardingTasksWrapper> taskWrapperLst = new List<OnboardingTasksWrapper>();
        String searchByPhase = cPhase != null ? cPhase : getLeaderPhase();
        for(HRO_Onboarding_Task__c hroTask : [Select Name, Due_Date__c,ExternalPortalLink__c,Id,Task_Detail__c FROM HRO_Onboarding_Task__c 
                                              WHERE Phase__c =:cPhase AND Onboarding_Task_Set__c =: cRecordId]){
        
            OnboardingTasksWrapper taskWrapp = new OnboardingTasksWrapper();
            taskWrapp.taskName = hroTask.Task_Detail__c;
            taskWrapp.taskDueDate = DateTime.newInstance(hroTask.Due_Date__c.year(),hroTask.Due_Date__c.month(),hroTask.Due_Date__c.day()).format('dd MMM yyyy');
            String encodedURl = null;
                                                           
            if(hroTask.ExternalPortalLink__c != null && hroTask.ExternalPortalLink__c != ''){
                encodedURl = EncodingUtil.urlEncode(hroTask.ExternalPortalLink__c, 'UTF-8');
            }
                                                  
            taskWrapp.taskLink = instanceUrl+'/apex/HRO_TaskLinkForwarder?id='+hroTask.id+'&pageUrl='+encodedURl;
            taskWrapperLst.add(taskWrapp);                                      
        }
        system.debug('*****HRO exiting getTaskAssignedToPhase():'+JSON.serialize(taskWrapperLst));
        return taskWrapperLst;
        
    }
    
    /*******************************************************************
   Purpose:  Retrive Task which overdued due date                                                      
   Parameters: []
   Returns: [List<OnboardingTasksWrapper>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
    public List<OnboardingTasksWrapper> getOverDuedTaskList(){
        system.debug('*****HRO entering getOverDuedTaskList()');
        String instanceUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        List<OnboardingTasksWrapper> taskWrapperLst = new List<OnboardingTasksWrapper>();
        String searchByPhase = cPhase != null ? cPhase : getLeaderPhase();
        for(HRO_Onboarding_Task__c hroTask : [Select Name, Due_Date__c,ExternalPortalLink__c,Id,Task_Detail__c,OwnerId,New_Leader_Name__c FROM HRO_Onboarding_Task__c 
                                              WHERE Onboarding_Task_Set__c =: cRecordId AND Completed__c=false  AND Due_Date__c < TODAY]){
        
            OnboardingTasksWrapper taskWrapp = new OnboardingTasksWrapper();
            taskWrapp.taskName = hroTask.Task_Detail__c;
            taskWrapp.taskDueDate = DateTime.newInstance(hroTask.Due_Date__c.year(),hroTask.Due_Date__c.month(),hroTask.Due_Date__c.day()).format('dd MMM yyyy');
            String encodedURl = null;
                                                           
            if(hroTask.ExternalPortalLink__c != null && hroTask.ExternalPortalLink__c != ''){
                encodedURl = EncodingUtil.urlEncode(hroTask.ExternalPortalLink__c, 'UTF-8');
                taskWrapp.taskLink = instanceUrl+'/apex/HRO_TaskLinkForwarder?id='+hroTask.id+'&pageUrl='+encodedURl;
            }else{
                taskWrapp.taskLink =instanceUrl+'/apex/HRO_TaskLinkForwarder?id='+hroTask.id+'&selectedLeader='+EncodingUtil.urlEncode(hroTask.New_Leader_Name__c,'UTF-8');
                //return instanceUrl+'/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+cOwnerId+'&tab.HRO_HeadStart.leaderToSelect='+EncodingUtil.urlEncode(hroTask.New_Leader_Name__c, 'UTF-8');        
            }
            taskWrapperLst.add(taskWrapp);                                      
        }
        system.debug('*****HRO exiting getOverDuedTaskList():'+JSON.serialize(taskWrapperLst));
        return taskWrapperLst;
        
    }
    
    /*******************************************************************
   Purpose: Return current phase for leader                                                   
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
    public String getLeaderPhase(){
        system.debug('*****HRO entring getLeaderPhase():');
        String leaderPhase = '';
        if(cStartDate == null || cStartDate > Date.today()){
            leaderPhase = 'Pre-Boarding';
        }else if(cStartDate == Date.today()){
            leaderPhase = 'Day 1';
        }else if(cStartDate < Date.today() && cStartDate.addDays(7) >= Date.today()){
            leaderPhase = 'Week 1';
        }else if(cStartDate < Date.today() && cStartDate.addDays(28) >= Date.today()){
            leaderPhase = 'Month 1';
        }else if(cStartDate < Date.today() && cStartDate.addDays(56) >= Date.today()){
            leaderPhase = 'Month 2';
        }else if(cStartDate < Date.today() && cStartDate.addDays(84) >= Date.today()){
            leaderPhase = 'Month 3';
        }else{
            leaderPhase = 'Beyond Onboarding';
        }
                
        system.debug('*****HRO exiting getLeaderPhase():'+leaderPhase);                
        return leaderPhase;
    }
    
    /*******************************************************************
   Purpose:  Return link to headstart page for selected leader                                                     
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
    public String getHeadStartLink(){
        system.debug('*****HRO entring getHeadStartLink():');            
        String instanceUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        String output = '';
        if(cLeaderName != null){
          output = instanceUrl+'/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+cOwnerId+'&tab.HRO_HeadStart.leaderToSelect='+EncodingUtil.urlEncode(cLeaderName, 'UTF-8');         
          system.debug('*****HRO exiting getHeadStartLink():'+output);        
          return output;
        }else{
            output = instanceUrl+'/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+cOwnerId;
            system.debug('*****HRO exiting getHeadStartLink():'+output);
            return output;       
        }
        
    }
    
    /*******************************************************************
   Purpose:  Return link to task Attachment                                                  
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public String getTaskLink(){
        String instanceUrl = System.URL.getSalesforceBaseUrl().toExternalForm();
        if(cTaskLink != null){
            return instanceUrl+'/apex/HRO_TaskLinkForwarder?id='+cTaskId+'&pageUrl='+EncodingUtil.urlEncode(cTaskLink, 'UTF-8');    
        }else if(cLeaderName != null){
          return instanceUrl+'/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+cOwnerId+'&tab.HRO_HeadStart.leaderToSelect='+EncodingUtil.urlEncode(cLeaderName, 'UTF-8');       
        }else{
            return instanceUrl+'/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+cOwnerId;       
        }
        
    }
    
    
    public class OnboardingTasksWrapper{
        public String taskName{get;set;}
        public String taskDueDate{get;set;}
        public String taskLink{get;set;}
    }
    
}