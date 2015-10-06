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

public with sharing class HRO_ManagerOverview_CX {

    public static final List<String> PHASEORDER = new List<String>{HRO_HeadStart_CX.DAY1PHASE,
                                                                   HRO_HeadStart_CX.WEEK1PHASE,
                                                                   HRO_HeadStart_CX.MONTH1PHASE,
                                                                   HRO_HeadStart_CX.MONTH2PHASE,
                                                                   HRO_HeadStart_CX.MONTH3PHASE,
                                                                   HRO_HeadStart_CX.BEONBOARDPHASE
                                                                };
    private String currentUserId{get;set;}

    public HRO_ManagerOverview_CX() {
        String currentUserId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
            currentUserId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }
        system.debug('check current user Id:'+currentUserId);
    }
    
    public String getProfileUserId(){
        
        String userId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
        	userId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }else{
            userId = UserInfo.getUserId();
        }
        return userId;
        
    }

    

    public List<MangerOverviewWrapper> getMangerOverviewList(){

        List<MangerOverviewWrapper> reportList = new List<MangerOverviewWrapper>();
        Map<String,LeaderSummarry> summarryForEachLeader = new Map<String,LeaderSummarry>();
        for(HRO_Onboarding_Task__c leaderTask : [SELECT Id, New_Leader_Name__c,Completed__c, Due_Date__c,Phase__c
                                                 FROM HRO_Onboarding_Task__c
                                                 WHERE OwnerId !=: UserInfo.getUserId() Limit 50000]){

            if(!summarryForEachLeader.containsKey(leaderTask.New_Leader_Name__c)){
                LeaderSummarry summaryRecord = new LeaderSummarry();
                summaryRecord.hasOverduedTasks = false;
                summaryRecord.uncompletedPhase = null;
                summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,1);
                summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,increaseNumOfCompletedTask(leaderTask));
                if(!summaryRecord.hasOverduedTasks && !leaderTask.Completed__c && leaderTask.Due_Date__c < Date.today()){
                    summaryRecord.hasOverduedTasks = true;
                }
                summarryForEachLeader.put(leaderTask.New_Leader_Name__c, summaryRecord);
            }else{
                LeaderSummarry summaryRecord = summarryForEachLeader.get(leaderTask.New_Leader_Name__c);
                if(summaryRecord.totalTasksInPhase.containsKey(leaderTask.Phase__c)){
                    summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,summaryRecord.totalTasksInPhase.get(leaderTask.Phase__c)+1);
                    summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,summaryRecord.totalTasksCompletedInPhase.get(leaderTask.Phase__c)+increaseNumOfCompletedTask(leaderTask));
                }else{
                    summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,1);
                    summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,increaseNumOfCompletedTask(leaderTask));
                }
                
                if(!summaryRecord.hasOverduedTasks && !leaderTask.Completed__c && leaderTask.Due_Date__c < Date.today()){
                    summaryRecord.hasOverduedTasks = true;
                }
            }
        }
        system.debug(JSON.serialize(summarryForEachLeader.values()));

        for(String leaderName : summarryForEachLeader.keySet()){
            LeaderSummarry summaryRecord = summarryForEachLeader.get(leaderName);
            summaryRecord.claculateAccurateStage();

            //if uncompleted 
            if(summaryRecord.uncompletedPhase != null){
               reportList.add(new MangerOverviewWrapper(leaderName,summaryRecord.uncompletedPhase,summaryRecord.pecentOfCompletion,summaryRecord.hasOverduedTasks));

            }
        }

        return reportList;

    }

    /**
     * 
     * { function_description }
     *
     * @param      leaderTask  { parameter_description }
     *
     * @return     { description_of_the_return_value }
     * 
     */

    public static Integer increaseNumOfCompletedTask(HRO_Onboarding_Task__c leaderTask){
        if(leaderTask.Completed__c){
            return 1;
        }else{
            return 0;
        }
    }

    
    public class LeaderSummarry{

        public Map<String,Integer> totalTasksInPhase = new Map<String,Integer>();
        public Map<String,Integer> totalTasksCompletedInPhase = new Map<String,Integer>();
        public Map<String,Decimal> percentOfCompletionInPhase = new Map<String,Decimal>();
        public Decimal pecentOfCompletion{get;set;}
        public Boolean hasOverduedTasks{get;set;}
        public String uncompletedPhase{get;set;}


        /**
         * { function_description }
         */
        public void claculateAccurateStage(){
            for(String phase : PHASEORDER){
                if(totalTasksInPhase.containsKey(phase)){

                    Decimal totalNumberOfTasks = Decimal.valueOf(totalTasksInPhase.get(phase).format());
                    Decimal totalCompletedTasks = Decimal.valueOf(totalTasksCompletedInPhase.get(phase).format());
                    system.debug(totalNumberOfTasks);
                    system.debug(totalCompletedTasks);
                    if(totalNumberOfTasks == totalCompletedTasks){
                        continue;
                    }else{
                        this.pecentOfCompletion = totalCompletedTasks.divide(totalNumberOfTasks, 2)*100;
                        this.uncompletedPhase = phase;
                        break;
                    }
                }
            }
        }

        /**
         * { function_description }
         *
         * @param phase  { parameter_description }
         *
         * @return     { description_of_the_return_value }
         */
        public Decimal calculatePercentOfCompletionForPhase(String phase){

             if(!totalTasksInPhase.containsKey(phase)){
                return 100;
             }

             Decimal totalNumberOfTasks = Decimal.valueOf(totalTasksInPhase.get(phase).format());
             Decimal totalCompletedTasks = Decimal.valueOf(totalTasksCompletedInPhase.get(phase).format());

             return totalCompletedTasks.divide(totalNumberOfTasks, 2)*100;
        }
        
    }

    /**
     * { class_description }
     */

    public class MangerOverviewWrapper{
        public String name{get;set;}
        public String phase{get;set;}
        public Decimal pecentOfCompletion{get;set;}
        public Boolean hasOverduedTasks{get;set;}


        public MangerOverviewWrapper(String cName,String cPhase,Decimal cPecentOfCompletion,Boolean cHasOverduedTasks){
            this.name = cName;
            this.phase = cPhase;
            this.pecentOfCompletion = cPecentOfCompletion;
            this.hasOverduedTasks = cHasOverduedTasks;
        }
    }
}