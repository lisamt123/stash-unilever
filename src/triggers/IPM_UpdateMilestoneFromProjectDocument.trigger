/**
    Author: Aswin
    Date: 16/12/2014
*/
trigger IPM_UpdateMilestoneFromProjectDocument on IPM_Project_Document__c (after insert, after update,before insert, before update) {
               
           String[] fieldNames = new String[] {'IPM_Approval_Date__c'};
            List<IPM_Milestone__c>  updatedMilestone = new List<IPM_Milestone__c>();
            IPM_Project_Document__c oldIpmProjectDocument = new IPM_Project_Document__c();      
            for (IPM_Project_Document__c recentIpmProjectDocument : Trigger.new) {
                if(recentIpmProjectDocument!= null){
                    if(recentIpmProjectDocument.Id!= null){
                        if(Trigger.old!=null){
                            if(Trigger.oldMap.get(recentIpmProjectDocument.Id)!= null){
                            oldIpmProjectDocument = Trigger.oldMap.get(recentIpmProjectDocument.Id);
                            }
                        }
                    }
                }
                for (String ipmApprovalDate : fieldNames) {
                    if (recentIpmProjectDocument.get(ipmApprovalDate) != oldIpmProjectDocument.get(ipmApprovalDate)) {
                        if(recentIpmProjectDocument.get('IPM_Project__c')!= null){
                            List<IPM_Milestone__c> milestones = [SELECT Id,IPM_Completed_On__c FROM IPM_Milestone__c WHERE IPM_Project__c = : recentIpmProjectDocument.IPM_Project__c and IPM_Type_of_gate__c = 'Charter'];
                            for(IPM_Milestone__c milestone:milestones){
                                milestone.IPM_Completed_On__c = recentIpmProjectDocument.IPM_Approval_Date__c;
                                milestone.IPM_Completed__c = true;
                                updatedMilestone.add(milestone);
                            }
                            
                            
                        }
                        
                    }
                    
                    
                }
            }     

    if(updatedMilestone.size()>0){
        update updatedMilestone;
    }


}