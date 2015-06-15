public without sharing class IPM_Milestones_Delete {

    public IPM_Milestones_Delete(IPM_List_Milestones controller) {
    
    }
   public String milestoneId{get;set;}
   public void deleteMilestone() {
        
        system.debug('** milestoneId : ' + milestoneId);
        List<IPM_Milestone__c> mObj = [SELECT Id FROM IPM_Milestone__c WHERE Id =:milestoneId];
        delete mObj;
        
        
    }
}