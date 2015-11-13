/**********************************************************************
 Name:  HRO_HeadStart_CX
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Main controller for Headstart page                                                           
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0   Karol Szepietowksi        23/09/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/



global with sharing class HRO_HeadStart_CX {
    
	public String selectTaskList{get;set;}
    public String selectedLeader{get;set;}
    public Boolean isAdmin{get;set;}
    public String switchToPhase{get;set;}
    public String selectedPhaseButton{get;set;}
    public static final String PREBOARDINGPHASE = 'Pre-Boarding';
    public static final String DAY1PHASE = 'Day 1';
    public static final String WEEK1PHASE = 'Week 1';
    public static final String MONTH1PHASE = 'Month 1';
    public static final String MONTH2PHASE = 'Month 2';
    public static final  String MONTH3PHASE = 'Month 3';
    public static final String BEONBOARDPHASE = 'Beyond Onboarding';
    private static final String NEWLEADERAPINAME = 'New_Leader_Name__c';
	
    
    private Map<String,String> introductionInfoMap = new Map<String,String>{
        PREBOARDINGPHASE => Label.HROPhaseIntroInfoBeforeArrival,
        DAY1PHASE => Label.HROPhaseIntroInfoDay1,
        WEEK1PHASE => Label.HROPhaseIntroInfoWeek1,
        MONTH1PHASE => Label.HROPhaseIntroInfoMonth1,
        MONTH2PHASE => Label.HROPhaseIntroInfoMonth2,
        MONTH3PHASE => Label.HROPhaseIntroInfoMonth3,
        BEONBOARDPHASE => Label.HROPhaseIntroInfoBeonBoard
    };
	
   /*******************************************************************
   Purpose:  Property returning introduction map                                                     
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
        
    public  Map<String,String> getIntroductionInfoMap(){
        system.debug('***HRO executing getIntroductionInfoMap:'+introductionInfoMap);
        return introductionInfoMap;
    }

   /*******************************************************************
   Purpose:  Class constructor used to initialize headstart page                                                       
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/	
    public HRO_HeadStart_CX() {
        //GET THE TASKS THAT ARE DONE HERE AND MARK OFF
        
        system.debug('Entring HRO_HeadStart_CX page constructor');
        switchToPhase = null;
        
        selectTaskList ='My Task';
        List<SelectOption> leadsToDisplay = getAvailableLeaders();
        
        if(!leadsToDisplay.isEmpty()){
            if(ApexPages.currentPage().getParameters().containsKey('leaderToSelect')){
                selectedLeader = EncodingUtil.urlDecode(ApexPages.currentPage().getParameters().get('leaderToSelect'),'UTF-8');
                switchToPhase = getLeaderPhase();
                changeSelectedButton();
                
            }else{
               selectedLeader = leadsToDisplay.get(0).getvalue();
               switchToPhase = getLeaderPhase();
               changeSelectedButton();
            }
            
        }

        system.debug('Exiting HRO_HeadStart_CX page constructor');
        
    }
    
   
    /*******************************************************************
   Purpose:  Property returning user id from page parameter if exist                                                     
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public String getProfileUserId(){
        system.debug('*****HRO Entering getProfileUserId');
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
        	userId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }else{
            userId = UserInfo.getUserId();
        }
        system.debug('*****HRO Exiting getProfileUserId:'+userId);
        return userId;
        
    }
    
    /*******************************************************************
   Purpose:  Method executed once the phase button is clicked on front                                                     
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public void phaseButtonClicked(){
        system.debug('*****HRO Entering phaseButtonClicked switchToPhase:'+switchToPhase);
        if(selectedPhaseButton == 'preBoardingBtn'){
            switchToPhase=PREBOARDINGPHASE;
        }else if(selectedPhaseButton == 'dayOneBtn'){
            switchToPhase=DAY1PHASE;
        }else if(selectedPhaseButton == 'weekOneBtn'){
            switchToPhase=WEEK1PHASE;
        }else if(selectedPhaseButton == 'monthOneBtn'){
            switchToPhase=MONTH1PHASE;
        }else if(selectedPhaseButton == 'monthTwoBtn'){
            switchToPhase=MONTH2PHASE;
        }else if(selectedPhaseButton == 'monthThreeBtn'){
            switchToPhase=MONTH3PHASE;
        }else if(selectedPhaseButton == 'beyondOnboardingBtn'){
            switchToPhase=BEONBOARDPHASE;
        }    
         system.debug('*****HRO Exiting phaseButtonClicked switchToPhase:'+switchToPhase);
    }
    
    /*******************************************************************
   Purpose:  Method executed when Leader was changed in list                                                    
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public void changeSelectedButton(){
        system.debug('*****HRO Entering changeSelectedButton selectedPhaseButton:'+selectedPhaseButton);
        if(switchToPhase == PREBOARDINGPHASE){
            selectedPhaseButton = 'preBoardingBtn';
        }else if(switchToPhase == DAY1PHASE){
            selectedPhaseButton = 'dayOneBtn';
        }else if(switchToPhase == WEEK1PHASE){
            selectedPhaseButton = 'weekOneBtn';
        }else if(switchToPhase == MONTH1PHASE){
            selectedPhaseButton = 'monthOneBtn';
        }else if(switchToPhase == MONTH2PHASE){
            selectedPhaseButton = 'monthTwoBtn';
        }else if(switchToPhase == MONTH3PHASE){
            selectedPhaseButton = 'monthThreeBtn';
        }else if(switchToPhase == BEONBOARDPHASE){
            selectedPhaseButton ='beyondOnboardingBtn';
        }
        
        system.debug('*****HRO Exiting changeSelectedButton selectedPhaseButton:'+selectedPhaseButton);
    }

    /*******************************************************************
   Purpose:  Method executed when Leader was changed in list and system 
   checking the phsae for selected leader
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public void resetleaderPhase(){
        system.debug('*****HRO Entering resetleaderPhase');
        switchToPhase = null;
        switchToPhase = getLeaderPhase();
        changeSelectedButton();
        system.debug('*****HRO Exiting resetleaderPhase');
    }

    /*******************************************************************
   Purpose:  Method returnig current phase for selected leader
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public String getLeaderPhase(){
        system.debug('*****HRO Entering getLeaderPhase');
        
        List<HRO_Onboarding_Task_Set__c> userLst = [SELECT Start_Date__c FROM HRO_Onboarding_Task_Set__c WHERE New_Leader_Name__c =:selectedLeader Limit 1];
        String leaderPhase = '';


        if(switchToPhase != null){
            system.debug('Exiting getLeaderPhase :'+switchToPhase);
            return switchToPhase;
        }

        if(userLst.isEmpty()){
            leaderPhase = PREBOARDINGPHASE;
        }else{
            HRO_Onboarding_Task_Set__c currentLeader = userLst.get(0);
            if(currentLeader.Start_Date__c == null || currentLeader.Start_Date__c > Date.today()){
                leaderPhase = PREBOARDINGPHASE;
            }else if(currentLeader.Start_Date__c == Date.today()){
                leaderPhase = DAY1PHASE;
            }else if(currentLeader.Start_Date__c < Date.today() && currentLeader.Start_Date__c.addDays(7) >= Date.today()){
                leaderPhase = WEEK1PHASE;
            }else if(currentLeader.Start_Date__c < Date.today() && currentLeader.Start_Date__c.addDays(28) >= Date.today()){
                leaderPhase = MONTH1PHASE;
            }else if(currentLeader.Start_Date__c < Date.today() && currentLeader.Start_Date__c.addDays(56) >= Date.today()){
                leaderPhase = MONTH2PHASE;
            }else if(currentLeader.Start_Date__c < Date.today() && currentLeader.Start_Date__c.addDays(84) >= Date.today()){
                leaderPhase = MONTH3PHASE;
            }else{
                leaderPhase = BEONBOARDPHASE;
            }
            system.debug('check current pahase date:'+leaderPhase);
        }
        system.debug('*****HRO Exiting getLeaderPhase returned:'+leaderPhase);
        return leaderPhase;
    }
    
   /*******************************************************************
   Purpose:  Method returnig list of thask for selected leader 
	in current/selected phase
   Parameters: []
   Returns: [List<HRO_Onboarding_Task__c>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public List<HRO_Onboarding_Task__c> getOnboardingTasks(){
        system.debug('*****HRO Entering getOnboardingTasks');
        String userId = getProfileUserId();
        List<HRO_Onboarding_Task__c> onboardingTasks = new List<HRO_Onboarding_Task__c>();
        
        system.debug('check selected leader:'+selectedLeader);
        system.debug('check leaderPhase:'+getLeaderPhase());
        //add Task_Detail__c
        String query =  'select Action_Taken__c, Action_Type__c, Completed__c, Due_Date__c, '+
            'ExternalPortalLink__c, Id, New_Leader_Name__c, '+ 
            'Onboarding_Task_Set__r.OwnerId, Phase__c,Task_Detail__c from HRO_Onboarding_Task__c '+
            'WHERE Phase__c =\''+getLeaderPhase()+'\' and New_Leader_Name__c =:selectedLeader ';
        
        if(selectTaskList == 'My Task'){
            query += ' AND Onboarding_Task_Set__r.OwnerId =\'' + UserInfo.getUserId()+'\'';
        }
        query += ' ORDER by Due_Date__c,Name asc Limit 50000'; 
	
        onboardingTasks = (List<HRO_Onboarding_Task__c>)Database.query(query);                                                        

        system.debug('*****HRO Exiting getOnboardingTasks returned:'+JSON.serialize(onboardingTasks));
        
        return onboardingTasks;
        
        
    }
    
   /*******************************************************************
   Purpose:  Method returnig assigned leaders to manager in headstart 
   Parameters: []
   Returns: [List<SelectOption>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public List<SelectOption> getAvailableLeaders(){

        system.debug('*****HRO Entering getAvailableLeaders');
        List<SelectOption> options = new List<SelectOption>();

        Set<String> leadersNames = new Set<String>();
        
        for(AggregateResult agr : [Select New_Leader_Name__c, count(id) nbrOfTasks FROM 
                                                 HRO_Onboarding_Task__c  where isDeleted = false  
                                                 AND Completed__c = false
                                   				 AND Onboarding_Task_Set__r.OwnerId =: UserInfo.getUserId() 	
                                                 GROUP BY New_Leader_Name__c]){

            if(!leadersNames.contains(String.valueOf(agr.get(NEWLEADERAPINAME)))){
                options.add(new SelectOption(String.valueOf(agr.get(NEWLEADERAPINAME)),String.valueOf(agr.get(NEWLEADERAPINAME))));
                leadersNames.add(String.valueOf(agr.get(NEWLEADERAPINAME))); 
            }
              
            
             
        }
        system.debug('*****HRO Exiting getAvailableLeaders:'+options);
        return options;
        

    }

    /*******************************************************************
   Purpose:  Method marking task as completed
   Parameters: [String]
   Returns: [HRO_Onboarding_Task__c]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    @remoteAction
    global static HRO_Onboarding_Task__c markComplete(String taskId) {
        system.debug('*****HRO Entring markComplete:@taskId'+taskId);
        HRO_Onboarding_Task__c thisTask = [SELECT Id, Completed__c FROM HRO_Onboarding_Task__c WHERE Id =: taskId];
        thisTask.Completed__c = true;
        update thisTask;
        system.debug('*****HRO exiting markComplete returned:'+thisTask);
        return thisTask;
    }
    

    
}