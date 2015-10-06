public with sharing class HRO_ProgressPage_CX {

    public static final List<String> PHASEORDER = new List<String>{HRO_HeadStart_CX.PREBOARDINGPHASE,
                                                                   HRO_HeadStart_CX.DAY1PHASE,
                                                                   HRO_HeadStart_CX.MONTH1PHASE,
                                                                   HRO_HeadStart_CX.WEEK1PHASE,
                                                                   HRO_HeadStart_CX.MONTH2PHASE,
                                                                   HRO_HeadStart_CX.MONTH3PHASE,
                                                                   HRO_HeadStart_CX.BEONBOARDPHASE
                                                                };


    private String currentUserId{get;set;}

    public List<ProgressWrapper> progressLst{get;set;}
    public Integer progressLstSize{get;set;}
    public HRO_ProgressPage_CX(ApexPages.StandardController std) {
        currentUserId = '';
        if(ApexPages.currentPage().getParameters().containsKey('sfdc.userId')){
            currentUserId = ApexPages.currentPage().getParameters().get('sfdc.userId');    
        }

        progressLst = getProgressList();

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

    public  Boolean getIsManager(){
        Id hroManager = [Select id From PermissionSet Where name =: HRO_NavMenu_CC.HRMANAGER Limit 1].get(0).Id;
        if([SELECT id from PermissionSetAssignment where AssigneeId =:ApexPages.currentPage().getParameters().get('sfdc.userId') AND PermissionSetId =: hroManager].size()>0){
            return true;
        }
        return false;
    }

    private List<ProgressWrapper> getProgressList(){

        List<ProgressWrapper> reportList = new List<ProgressWrapper>();
        HRO_ManagerOverview_CX.LeaderSummarry summaryRecord = new HRO_ManagerOverview_CX.LeaderSummarry();
        for(HRO_Onboarding_Task__c leaderTask : [SELECT Id, New_Leader_Name__c,Completed__c, Due_Date__c,Phase__c
                                                 FROM HRO_Onboarding_Task__c
                                                 WHERE OwnerId =: currentUserId Limit 50000]){

            
            if(summaryRecord.totalTasksInPhase.containsKey(leaderTask.Phase__c)){
                summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,summaryRecord.totalTasksInPhase.get(leaderTask.Phase__c)+1);
                summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,summaryRecord.totalTasksCompletedInPhase.get(leaderTask.Phase__c)+HRO_ManagerOverview_CX.increaseNumOfCompletedTask(leaderTask));
            }else{
                summaryRecord.totalTasksInPhase.put(leaderTask.Phase__c,1);
                summaryRecord.totalTasksCompletedInPhase.put(leaderTask.Phase__c,HRO_ManagerOverview_CX.increaseNumOfCompletedTask(leaderTask));
            }
            
        }

        if(!summaryRecord.totalTasksInPhase.isEmpty()){
            Boolean isManager = getIsManager();
            Decimal totalNumberOfTasks = 0;
            Decimal totalCompletedTasks = 0;

            for(String userPhase : PHASEORDER){

                if(userPhase == HRO_HeadStart_CX.PREBOARDINGPHASE && !isManager){
                    continue;
                }

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
        system.debug(JSON.serialize(reportList));
        progressLstSize = reportList.size();
        return reportList;


    }



    public class ProgressWrapper{
        public String phase{get;set;}
        public Integer perecntOfCompletion{get;set;}
        public Integer totalTasks{get;set;}
        public Integer totalCompletedTasks{get;set;}
    }

}