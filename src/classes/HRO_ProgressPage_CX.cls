/**********************************************************************
 Name:  HRO_ProgressPage_CX()
 Copyright © 2015  Salesforce
 ======================================================
======================================================
Purpose:                                                            
Class responsible for calcualting manger progress                                                      
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL            Description
   1.0    Karol Szepietowski        13/10/2015      INITIAL DEVELOPMENT          CSR: 
***********************************************************************/

public with sharing class HRO_ProgressPage_CX {
	public static final String HRADMIN = 'HRO_HRAdmin';
    public static final String HRMANAGER = 'HRO_HeadstartManager';
    public static final String HRNEWLEADER = 'HRO_Headstart';
    public static final String USERPARAM = 'sfdc.userId';
    
    public static final List<String> PHASEORDER = new List<String>{HRO_HeadStart_CX.PREBOARDINGPHASE,
                                                                   HRO_HeadStart_CX.DAY1PHASE,
        														   HRO_HeadStart_CX.WEEK1PHASE,
                                                                   HRO_HeadStart_CX.MONTH1PHASE,
                                                                   HRO_HeadStart_CX.MONTH2PHASE,
                                                                   HRO_HeadStart_CX.MONTH3PHASE,
                                                                   HRO_HeadStart_CX.BEONBOARDPHASE
                                                                };


    private String currentUserId{get;set;}

    public List<ProgressWrapper> progressLst{get;set;}
    public Integer progressLstSize{get;set;}
    
   /*******************************************************************
   Purpose:  Class contstuctor                                                    
   Parameters: []
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public HRO_ProgressPage_CX() {
        system.debug('***HRO Entring HRO_ProgressPage_CX constructor');
        currentUserId = '';
        if(ApexPages.currentPage().getParameters().containsKey(USERPARAM)){
            currentUserId = ApexPages.currentPage().getParameters().get(USERPARAM);    
        }else{
            currentUserId = UserInfo.getUserId();
        }

        progressLst = getProgressList();
		system.debug('***HRO Exiting HRO_ProgressPage_CX constructor progressLst was set to: '+JSON.serialize(progressLst));
    }
    
    /*******************************************************************
   Purpose:  Return userid from url parameter                                                   
   Parameters: []
   Returns: [String]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public String getProfileUserId(){
        system.debug('***HRO Entirng getProfileUserId');
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey(USERPARAM)){
        	userId = ApexPages.currentPage().getParameters().get(USERPARAM);    
        }else{
            userId = UserInfo.getUserId();
        }
        system.debug('***HRO Exiting getProfileUserId:'+userId);
        return userId;
        
    }
	
    /*******************************************************************
   Purpose:  Return userid from url parameter                                                   
   Parameters: Checking if current user have an HRO Manager permission set
   assigned
   Returns: [Boolean]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public  Boolean getIsManager(){
        system.debug('***HRO Entring getIsManager');
        Id hroManager = [Select id From PermissionSet Where name =: HRMANAGER Limit 1].get(0).Id;
        List<PermissionSetAssignment> managerPermission = [SELECT id from PermissionSetAssignment where AssigneeId =:ApexPages.currentPage().getParameters().get(USERPARAM) AND PermissionSetId =: hroManager];
        if(!managerPermission.isEmpty()){
            system.debug('***HRO Exiting getIsManager:'+true);
            return true;
        }
        system.debug('***HRO Exiting getIsManager:'+false);
        return false;
    }
	
    /*******************************************************************
    Purpose:  Return 1 if task is completed and 0 if not
    Returns: [Integer]
    Throws [Exceptions]: []                                                          
    ********************************************************************/
    private Integer increaseNumOfCompletedTask(HRO_Onboarding_Task__c hroTask){
        if(hroTask.Completed__c){
            return 1;
        }else{
            return 0;
        }
    }
    
   /*******************************************************************
   Purpose:  Return manager progress on headstart program
   Returns: [List<ProgressWrapper>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    private List<ProgressWrapper> getProgressList(){
		system.debug('***HRO Entring getProgressList');
        List<ProgressWrapper> reportList = new List<ProgressWrapper>();
        Map<String,LeaderSummarry> leaderSummaryMap = new Map<String,LeaderSummarry>();
        LeaderSummarry summaryRecord = new LeaderSummarry();
        for(HRO_Onboarding_Task__c leaderTask : [SELECT Id, New_Leader_Name__c,Completed__c, Due_Date__c,Phase__c
                                                 FROM HRO_Onboarding_Task__c
                                                 WHERE Onboarding_Task_Set__r.OwnerId =: currentUserId
                                                 AND Onboarding_Task_Set__r.Start_Date__c >= LAST_N_DAYS:365 
                                                 Limit 50000]){

            if(leaderSummaryMap.containsKey(leaderTask.New_Leader_Name__c)){
            	summaryRecord = leaderSummaryMap.get(leaderTask.New_Leader_Name__c);                                           
            }else{
                summaryRecord = new LeaderSummarry();
                leaderSummaryMap.put(leaderTask.New_Leader_Name__c,summaryRecord); 
            }
                                                     
            if(summaryRecord.totalTasksInPhase.containsKey(leaderTask.Phase__c)){
                summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,summaryRecord.totalTasksInPhase.get(leaderTask.Phase__c)+1);
                summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,summaryRecord.totalTasksCompletedInPhase.get(leaderTask.Phase__c)+increaseNumOfCompletedTask(leaderTask));
            }else{
                summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,1);
                summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,increaseNumOfCompletedTask(leaderTask));
            }
            
        }

        if(!leaderSummaryMap.isEmpty()){
            Decimal totalNumberOfTasks = 0;
            Decimal totalCompletedTasks = 0;
			summaryRecord = calculateSummary(leaderSummaryMap);
            for(String userPhase : PHASEORDER){

                ProgressWrapper wrapper = new ProgressWrapper();
                wrapper.phase = userPhase;

                wrapper.perecntOfCompletion = summaryRecord.calculatePercentOfCompletionForPhase(userPhase).intValue();
                wrapper.totalTasks = summaryRecord.totalTasksInPhase.get(userPhase);
                wrapper.totalCompletedTasks = summaryRecord.totalTasksCompletedInPhase.get(userPhase);

                if(summaryRecord.totalTasksInPhase.containsKey(userPhase)){
                    totalNumberOfTasks += summaryRecord.totalTasksInPhase.get(userPhase);
                    totalCompletedTasks += summaryRecord.totalTasksCompletedInPhase.get(userPhase);
                }

                reportList.add(wrapper);
            }
            //Add overal score
            ProgressWrapper wrapper = new ProgressWrapper();
            wrapper.phase = 'Overall';
            if(totalNumberOfTasks == 0){
                wrapper.perecntOfCompletion = 100;
            }


            wrapper.perecntOfCompletion = (totalCompletedTasks.divide(totalNumberOfTasks, 2)*100).intValue();
            wrapper.totalTasks = totalNumberOfTasks.intValue();
            wrapper.totalCompletedTasks = totalCompletedTasks.intValue();
                
            reportList.add(wrapper);

        }
        
        progressLstSize = reportList.size();
        system.debug('***HRO Exiting getProgressList:'+JSON.serialize(reportList));
        return reportList;


    }
    /*******************************************************************
   Purpose:  Calculate progress for manager only for leaders which didn't completed
   the program 
   Parameters: [Map<String,LeaderSummarry>]	
   Returns: [LeaderSummarry]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    private LeaderSummarry calculateSummary(Map<String,LeaderSummarry> leadersMap){
        system.debug('***HRO Entring calculateSummary with patam @leadersMap'+leadersMap);
        LeaderSummarry finalSummary = new LeaderSummarry();
        Map<String,LeaderSummarry> finalMap = getLeadersWithUncompletedTasks(leadersMap.clone());  

        for(String mapKey : finalMap.keySet()){
            LeaderSummarry tmpSummary = finalMap.get(mapKey);
            for(String userPhase : PHASEORDER){
                //summary of total in each phase
                Integer tmpTotalInPhase = tmpSummary.totalTasksInPhase.containsKey(userPhase) ? tmpSummary.totalTasksInPhase.get(userPhase) : 0;
                Integer tmpTotalInPhaseCompleted = tmpSummary.totalTasksCompletedInPhase.containsKey(userPhase) ? tmpSummary.totalTasksCompletedInPhase.get(userPhase) : 0;
                if(finalSummary.totalTasksInPhase.containsKey(userPhase)){
                    Integer currentTotalPhase = finalSummary.totalTasksInPhase.get(userPhase);
                    finalSummary.totalTasksInPhase.put(userPhase,currentTotalPhase+tmpTotalInPhase);
                }else{
                    finalSummary.totalTasksInPhase.put(userPhase,tmpTotalInPhase);
                }
                //summarry of completed
                if(finalSummary.totalTasksCompletedInPhase.containsKey(userPhase)){
                    Integer currentTotlaCompleted = finalSummary.totalTasksCompletedInPhase.get(userPhase);
                    finalSummary.totalTasksCompletedInPhase.put(userPhase,currentTotlaCompleted+tmpTotalInPhaseCompleted);
                }else{
                    finalSummary.totalTasksCompletedInPhase.put(userPhase,tmpTotalInPhaseCompleted);
                }
            }    
        }
        system.debug('***HRO Exiting calculateSummary '+finalSummary);
        return finalSummary;
    }
    
   /*******************************************************************
   Purpose:  Returning map with leaders which didn't completed Headstart 
   Program yet.
   Parameters: [Map<String,LeaderSummarry>]		
   Returns: [Map<String,LeaderSummarry>]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    private Map<String,LeaderSummarry> getLeadersWithUncompletedTasks(Map<String,LeaderSummarry> leadersMap){
        system.debug('***HRO Entring getLeadersWithUncompletedTasks @leadersMap:'+leadersMap);
        Map<String,LeaderSummarry> finalMap = leadersMap.clone();  
        for(String mapKey : leadersMap.keySet()){
            if(checkIfCompltedProgram(leadersMap.get(mapKey))){
                finalMap.remove(mapKey);
            }
        }
        system.debug('***HRO Exiting LeadersWithUncompletedTasks '+finalMap);
        return finalMap;
    }
    
   /*******************************************************************
   Purpose:  Checking if all task for particular leader where completed
   the program 
   Returns: [Boolean]
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    private Boolean checkIfCompltedProgram(LeaderSummarry summaryForLeader){
        system.debug('***HRO Entring checkIfCompltedProgram with param @summaryForLeader'+summaryForLeader);
        for(String userPhase : PHASEORDER){
			if(summaryForLeader.totalTasksInPhase.containsKey(userPhase) &&
               (summaryForLeader.totalTasksInPhase.get(userPhase) != summaryForLeader.totalTasksCompletedInPhase.get(userPhase))){
                
                system.debug('***HRO Exiting checkIfCompltedProgram'+false);
                return false;
                
            }
        }
        system.debug('***HRO Exiting checkIfCompltedProgram'+true);
        return true;
    }

	/*******************************************************************
   Purpose: Helper class used as placeholder for returned data
   Returns: []
   Throws [Exceptions]: []                                                          
  ********************************************************************/
    public class ProgressWrapper{
        public String phase{get;set;}
        public Integer perecntOfCompletion{get;set;}
        public Integer totalTasks{get;set;}
        public Integer totalCompletedTasks{get;set;}
    }
    
    /*******************************************************************
    Purpose: Helper class used as placeholder for returned data
    Returns: []
    Throws [Exceptions]: []                                                          
  	********************************************************************/
    public class LeaderSummarry{

        public Map<String,Integer> totalTasksInPhase = new Map<String,Integer>();
        public Map<String,Integer> totalTasksCompletedInPhase = new Map<String,Integer>();
        public Map<String,Decimal> percentOfCompletionInPhase = new Map<String,Decimal>();


        /*******************************************************************
       Purpose: Helper class used as placeholder for returned data
	   Parameters:[String]	
       Returns: [Decimal]
       Throws [Exceptions]: []                                                          
      ********************************************************************/
        public Decimal calculatePercentOfCompletionForPhase(String phase){

             if(!totalTasksInPhase.containsKey(phase)){
                return 100;
             }

             Decimal totalNumberOfTasks = Decimal.valueOf(totalTasksInPhase.get(phase).format());
             Decimal totalCompletedTasks = Decimal.valueOf(totalTasksCompletedInPhase.get(phase).format());

             return totalCompletedTasks.divide(totalNumberOfTasks, 2)*100;
        }
        
    }

}