trigger IPM_UpdateMilestoneFromIPMProject on IPM_Project__c (after insert) {

if(IPM_UpdateChildIpmProjects.off_Trigger){
        return;
    }
    
    List<IPM_Milestone__c>  updatedMilestone = new List<IPM_Milestone__c>();
    
        for (IPM_Project__c recentInsertedIpmProject : Trigger.new) {
            if(recentInsertedIpmProject.CreatedDate!= null){
                  List<IPM_Milestone__c> milestones = [SELECT Id,IPM_Project_Started_Date__c FROM IPM_Milestone__c WHERE IPM_Project__c = : recentInsertedIpmProject.id];
                            for(IPM_Milestone__c milestone:milestones){
                                milestone.IPM_Project_Started_Date__c = recentInsertedIpmProject.CreatedDate.date() ;
                                updatedMilestone.add(milestone);
                            }
            }
                       
        }
        if(updatedMilestone.size()>0){
                update updatedMilestone;
        }
    
}