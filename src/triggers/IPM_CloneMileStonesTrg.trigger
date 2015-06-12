trigger IPM_CloneMileStonesTrg on IPM_Project__c (after insert, after update) {
    if(trigger.isInsert){
        IPM_ProjectUtility.cloneMileStones(trigger.new);
    }
    
    if(trigger.isUpdate){
        Map<id,String> mpPhases = new Map<Id,String>();
        for(IPM_Project__c proj: trigger.new){
            if(proj.IPM_Phase__c != trigger.oldMap.get(proj.Id).IPM_Phase__c)
                mpPhases.put(proj.Id,trigger.oldMap.get(proj.Id).IPM_Phase__c);
        }
        if(mpPhases.size()>0)
        IPM_ProjectUtility.MarkMileStonesComplete(mpPhases);
    }
}