trigger VPM_ReassignFailedRecordToMDMQueue on VPM_PurchasingRequests__c (before insert, before update) {
    String newMDMStatus;
    List<QueueSobject> queueList = 
        [Select Id, SobjectType, QueueId, Queue.Name From QueueSobject where Queue.Name = 'MDM Ops' Limit 1];
    try {
        if((System.Trigger.isInsert || System.Trigger.IsUpdate) && System.Trigger.isBefore) {
            for(VPM_PurchasingRequests__c newPurReq :Trigger.new) {
                
                VPM_PurchasingRequests__c oldPurReq = Trigger.oldMap.get(newPurReq.Id);
                
                if (oldPurReq.VPM_MDMInsertUpdateStatus__c != newPurReq.VPM_MDMInsertUpdateStatus__c) {
                    newMDMStatus = newPurReq.VPM_MDMInsertUpdateStatus__c;
                    if(String.isNotBlank(newMDMStatus) && 
                       newMDMStatus.equalsIgnoreCase('Failed to Submit to BPM')) {
                           newPurReq.VPM_Status__c = 'MDM Ops Review - SAP BPM submit Failed';
                           newPurReq.OwnerId = queueList.get(0).QueueId;
                       }
                    
                    if(String.isNotBlank(newMDMStatus) && 
                       newMDMStatus.equalsIgnoreCase('Submitted to BPM')) {
                           newPurReq.VPM_Status__c = 'BPM Record Submitted';
                       }
                    
                    if(String.isNotBlank(newMDMStatus) && 
                       newMDMStatus.equalsIgnoreCase('Approval Rejected in BPM')) {
                           newPurReq.VPM_Status__c = 'MDM Ops Review - SAP BPM Approval Rejected';
                           newPurReq.OwnerId = queueList.get(0).QueueId;
                       }
                }
            }
        }
    } catch(Exception e) {
    }
}