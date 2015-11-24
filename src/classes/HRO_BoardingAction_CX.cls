/**********************************************************************
 Name:  HRO_BoardingAction_CX()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
-------                                                            
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        01/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

public with sharing class HRO_BoardingAction_CX {
    @testVisible
    private List<HRO_Onboarding_Plan__c> listOfTemplateTasks{get;set;}
    public HRO_Onboarding_Plan__c planInfo{get;set;}
    public Boolean isSalesforce1{get;set;}
    public String userId{get;set;}
	private static final String SELECTEDLEADERPARAM = '&tab.HRO_HeadStart.leaderToSelect=';
    /*******************************************************************
   Purpose:  Class constructor                                                   
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/ 

    public HRO_BoardingAction_CX(ApexPages.StandardSetController ctrl){
        system.debug('****HRO Entring HRO_BoardingAction_CX class constructor');
        planInfo = new HRO_Onboarding_Plan__c();
        userId = UserInfo.getUserId();
        if(Test.isRunningTest()){
            isSalesforce1 = false;
        }
        system.debug('****HRO Exiting HRO_BoardingAction_CX class constructor');
    }
    
    /*******************************************************************
   Purpose:  StandardSet controller constructor                                                   
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/ 

    public HRO_BoardingAction_CX(ApexPages.StandardController crl){
        system.debug('****HRO Entring HRO_BoardingAction_CX class constructor for standardSet');
        planInfo = new HRO_Onboarding_Plan__c();
        userId = UserInfo.getUserId();
        if(Test.isRunningTest()){
            isSalesforce1 = false;
        }
        system.debug('****HRO Exiting HRO_BoardingAction_CX class constructor for standardSet');
    }
    
   /*******************************************************************
   Purpose:  Retrive user id from url                                                   
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/ 

    public String getProfileUserId(){
        system.debug('***HRO getProfileUserId entring');
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
            userId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }else{
            userId = UserInfo.getUserId();
        }
        system.debug('***HRO getProfileUserId exit returned:'+userId);
        return userId;
        
    }
    
   /*******************************************************************
   Purpose:  Retrive available Onboarding Task Templates                                                  
   Parameters: []
   Returns: [List<HRO_Onboarding_Plan__c>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/

    public List<HRO_Onboarding_Plan__c> getPreBoardingTasks(){
        system.debug('***HRO getPreBoardingTasks entring');
        listOfTemplateTasks = new List<HRO_Onboarding_Plan__c>();
        for(HRO_Onboarding_Plan__c template : [Select Id,Due__c, Link__c,Name, New_Leader__c, Phase__c, Start_Date__c, Task_type__c,Task_Description__c from HRO_Onboarding_Plan__c Order by Due__c,Name asc LIMIT 2000]){
            listOfTemplateTasks.add(template);
        }
        system.debug('***HRO getPreBoardingTasks exit return following list:'+listOfTemplateTasks);
        
        return listOfTemplateTasks;
    }

    /*******************************************************************
   Purpose:  Creating task for new leader                                              
   Parameters: []
   Returns: [PageReference]
   Throws [Exceptions]: []                                                          
  ********************************************************************/

    public PageReference savePreBoarding(){
        system.debug('*****HRO Entering savePreBoarding');
        createPreBoardingTasks();
        system.debug('*****HRO Exiting savePreBoarding');
        if(!isSalesforce1){
            return new PageReference('/_ui/core/userprofile/UserProfilePage?tab=HRO_HeadStart&sfdc.userId='+UserInfo.getUserId()+SELECTEDLEADERPARAM+EncodingUtil.urlEncode(planInfo.New_Leader__c, 'UTF-8'));    
        }else{
            return null; 
        }           
    }
    
    
    /*******************************************************************
   Purpose:  Creating task for new leader                                              
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public void createPreBoardingTasks(){

        system.debug('*****HRO Entering createPreBoardingTasks');

        List<HRO_Onboarding_Task__c> tasksToCreate = new List<HRO_Onboarding_Task__c>();
        
        HRO_Onboarding_Task_Set__c hroTaskSet = new HRO_Onboarding_Task_Set__c();
        hroTaskSet.Start_Date__c = planInfo.Start_Date__c;
        hroTaskSet.New_Leader_Name__c = planInfo.New_Leader__c;
        hroTaskSet.OwnerId = UserInfo.getUserId();
        insert hroTaskSet;
        for(HRO_Onboarding_Plan__c p : listOfTemplateTasks){
            HRO_Onboarding_Task__c managerTask = new HRO_Onboarding_Task__c();
            managerTask.Action_Type__c = p.Task_type__c;
            managerTask.Completed__c = false;
            managerTask.Due_Date__c = planInfo.Start_Date__c.addDays(Integer.valueOf(p.Due__c));
            //managerTask.OwnerId = UserInfo.getUserId();
            managerTask.New_Leader_Name__c = planInfo.New_Leader__c;
            //managerTask.Onboarding_Plan__c =  p.id;
            managerTask.Onboarding_Task_Set__c = hroTaskSet.id;
            managerTask.Phase__c = p.Phase__c;
            managerTask.Task_Detail__c = p.Task_Description__c;
            managerTask.ExternalPortalLink__c = p.Link__c;
            
            tasksToCreate.add(managerTask);
        }
        try{
            system.debug('task to insert:'+tasksToCreate);
            insert tasksToCreate;
        }catch(Exception ex){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Following error occured wile creating tasks :'+ex));
        }

         system.debug('*****Exiting createPreBoardingTasks folowing task were created:'+tasksToCreate);
        
        
    }
}