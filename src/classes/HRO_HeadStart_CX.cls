/**********************************************************************
 Name:  ConfigureOpportunity()
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
   1.0    Name        dd/mm/yyyy      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/



global with sharing class HRO_HeadStart_CX {
	
	public String selectTaskList{get;set;}
    public String selectedLeader{get;set;}
    public Boolean isAdmin{get;set;}
    public String userPhase{get;set;}
    public Id leaderId{get;set;}
    private String currentUserProfileId;
    public Id taskForUser{get;set;}
    public String currentLeaderPhase{get;set;}
    public Boolean managerMode{get;set;}
    public String switchToPhase{get;set;}
    public static String PREBOARDINGPHASE = 'Pre-Boarding';
    public static String DAY1PHASE = 'Day 1';
    public static String WEEK1PHASE = 'Week 1';
    public static String MONTH1PHASE = 'Month 1';
    public static String MONTH2PHASE = 'Month 2';
    public static String MONTH3PHASE = 'Month 3';
    public static String BEONBOARDPHASE = 'Beyond Onboarding';

    private Map<String,String> introductionHeaderMap = new Map<String,String>{
        PREBOARDINGPHASE => Label.HROPhaseIntroHeaderBeforeArrival,
        DAY1PHASE => Label.HROPhaseIntroHeaderDay1,
        WEEK1PHASE => Label.HROPhaseIntroHeaderWeek1,
        MONTH1PHASE => Label.HROPhaseIntroHeaderMonth1,
        MONTH2PHASE => Label.HROPhaseIntroHeaderMonth2,
        MONTH3PHASE => Label.HROPhaseIntroHeaderMonth3,
        BEONBOARDPHASE => Label.HROPhaseIntroHeaderBeonBoard
    };

    public Map<String,String> getIntroductionHeaderMap(){
        return introductionHeaderMap;
    }

    private Map<String,String> introductionInfoMap = new Map<String,String>{
        PREBOARDINGPHASE => Label.HROPhaseIntroInfoBeforeArrival,
        DAY1PHASE => Label.HROPhaseIntroInfoDay1,
        WEEK1PHASE => Label.HROPhaseIntroInfoWeek1,
        MONTH1PHASE => Label.HROPhaseIntroInfoMonth1,
        MONTH2PHASE => Label.HROPhaseIntroInfoMonth2,
        MONTH3PHASE => Label.HROPhaseIntroInfoMonth3,
        BEONBOARDPHASE => Label.HROPhaseIntroInfoBeonBoard
    };

    public  Map<String,String> getIntroductionInfoMap(){
        return introductionInfoMap;
    }

    /**
     * { constructor_description }
     *
     * @param      std   { parameter_description }
     */
    public HRO_HeadStart_CX(ApexPages.StandardController std) {
        //GET THE TASKS THAT ARE DONE HERE AND MARK OFF
        
        system.debug('profile opend for user:'+getProfileUserId());
        currentUserProfileId = ApexPages.currentPage().getParameters().get('sfdc.userId');
        managerMode=false;
       
        
        if(getIsManager()){
             managerMode = true;
             selectTaskList ='My Task';
             List<SelectOption> leadsToDisplay = getAvailableLeaders();
             if(!leadsToDisplay.isEmpty()){
                selectedLeader = leadsToDisplay.get(0).getvalue();
             }
        }else{
            selectedLeader = UserInfo.getName();
            userPhase = 'Day 1';
        }

        switchToPhase = null;
        
        
    }
    
   
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */
    public String getProfileUserId(){
        
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
        	userId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }else{
            userId = UserInfo.getUserId();
        }
        return userId;
        
    }
    
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */

    public  Boolean getIsManager(){
        Id hroManager = [Select id From PermissionSet Where name =: HRO_NavMenu_CC.HRMANAGER Limit 1].get(0).Id;
        if([SELECT id from PermissionSetAssignment where AssigneeId =:ApexPages.currentPage().getParameters().get('sfdc.userId') AND PermissionSetId =: hroManager].size()>0){
            return true;
        }
        return false;
    }

    /**
     * { function_description }
     */
    public void resetleaderPhase(){
        switchToPhase = null;
    }

    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */
    public String getLeaderPhase(){
        List<User> userLst = [SELECT HRO_Start_Date__c FROM User WHERE Name =:selectedLeader Limit 1];
        String leaderPhase = '';


        if(switchToPhase != null){
            return switchToPhase;
        }

        if(userLst.isEmpty()){
            leaderPhase = 'Pre-Boarding';
        }else{
            User currentLeader = userLst.get(0);
            if(currentLeader.HRO_Start_Date__c == null || currentLeader.HRO_Start_Date__c > Date.today()){
                leaderPhase = 'Pre-Boarding';
            }else if(currentLeader.HRO_Start_Date__c == Date.today()){
                leaderPhase = 'Day 1';
            }else if(currentLeader.HRO_Start_Date__c < Date.today() && currentLeader.HRO_Start_Date__c.addDays(7) >= Date.today()){
                leaderPhase = 'Week 1';
            }else if(currentLeader.HRO_Start_Date__c < Date.today() && currentLeader.HRO_Start_Date__c.addDays(30) >= Date.today()){
                leaderPhase = 'Month 1';
            }else if(currentLeader.HRO_Start_Date__c < Date.today() && currentLeader.HRO_Start_Date__c.addDays(60) >= Date.today()){
                leaderPhase = 'Month 2';
            }else if(currentLeader.HRO_Start_Date__c < Date.today() && currentLeader.HRO_Start_Date__c.addDays(90) >= Date.today()){
                leaderPhase = 'Month 3';
            }else{
                leaderPhase = 'Beyond Onboarding';
            }
            
        }    
        return leaderPhase;
    }
    
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */
    public List<HRO_Onboarding_Task__c> getOnboardingTasks(){
        String userId = getProfileUserId();
        List<HRO_Onboarding_Task__c> onboardingTasks = new List<HRO_Onboarding_Task__c>();
        if(managerMode){
            system.debug('check selected leader:'+selectedLeader);
            system.debug('check leaderPhase:'+getLeaderPhase());
            String query =  'select Action_Taken__c, Action_Type__c, Completed__c, Due_Date__c, '+
                            'ExternalPortalLink__c, Id, New_Leader_Name__c, Onboarding_Plan__c, '+ 
                            'OwnerId, Phase__c, Task_Detail__c from HRO_Onboarding_Task__c '+
                            'WHERE Phase__c =\''+getLeaderPhase()+'\' and New_Leader_Name__c =:selectedLeader ';

            if(selectTaskList == 'My Task'){
                query += ' AND OwnerId =\'' + UserInfo.getUserId()+'\'';
            }
            query += ' ORDER by Due_Date__c asc Limit 50000'; 
            

            onboardingTasks = (List<HRO_Onboarding_Task__c>)Database.query(query);                                                        

        }else{
            onboardingTasks = [select Action_Taken__c, Action_Type__c, Completed__c, Due_Date__c, 
                                                        ExternalPortalLink__c, Id, New_Leader_Name__c, Onboarding_Plan__c, 
                                                        OwnerId, Phase__c, Task_Detail__c from HRO_Onboarding_Task__c
                                                        WHERE Phase__c =:getLeaderPhase() 
                                                        AND New_Leader_Name__c =:selectedLeader
                                                        AND OwnerId =: userId
                                                        ORDER by Due_Date__c asc Limit 50000]; 

            system.debug('check selected leader:'+selectedLeader);
            system.debug('check leaderPhase:'+getLeaderPhase());   
        }
        
        system.debug(onboardingTasks);
        return onboardingTasks;
        
        
    }
    
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */
    public List<SelectOption> getItems(){
        
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('My Task','My Task'));
        options.add(new SelectOption('All Tasks','All Tasks'));
        return options;
    }
    
    /**
     * { function_description }
     *
     * @return     { description_of_the_return_value }
     */
    public List<SelectOption> getAvailableLeaders(){

        system.debug('*****HRO Entering getAvailableLeaders');
        List<SelectOption> options = new List<SelectOption>();

        Set<String> leadersNames = new Set<String>();
        Map<String,Integer> totalTasksPerLeader = new Map<String,Integer>();
        for(AggregateResult agr : [Select New_Leader_Name__c,OwnerId, count(id) nbrOfTasks FROM 
                                                 HRO_Onboarding_Task__c  where isDeleted = false  
                                                 AND Completed__c = false 
                                                 GROUP BY New_Leader_Name__c,OwnerId]){

            if(!leadersNames.contains(String.valueOf(agr.get('New_Leader_Name__c')))){
                options.add(new SelectOption(String.valueOf(agr.get('New_Leader_Name__c')),String.valueOf(agr.get('New_Leader_Name__c'))));
                leadersNames.add(String.valueOf(agr.get('New_Leader_Name__c'))); 
            }
              
            
             
        }
        
        return options;
        

    }

    /**
     * { function_description }
     *
     * @param      taskId  { parameter_description }
     */
    @remoteAction
    global static HRO_Onboarding_Task__c markComplete(String taskId) {
        HRO_Onboarding_Task__c thisTask = [SELECT Id, Completed__c FROM HRO_Onboarding_Task__c WHERE Id =: taskId];
        thisTask.Completed__c = true;
        update thisTask;
        return thisTask;
    }
    

    
}