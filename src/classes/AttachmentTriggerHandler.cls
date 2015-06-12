public class AttachmentTriggerHandler {
    
    private boolean m_isExecuting = false;

    public AttachmentTriggerHandler(boolean isExecuting){
        m_isExecuting = isExecuting;
    }

    public void OnAfterInsert(Attachment[] newAttachments){
        
        Set<Id> oopsIdsSet = new Set<Id>();
        Map<String, String> objContMap = new Map<String, String>();
        Set<String> contentIdsSet = new Set<String>{'OOPS Q1 Backup',
                                                    'OOPS Q2 Backup',
                                                    'OOPS Q3 Backup',
                                                    'OOPS Q4 Backup'};
        for(Attachment eachAttachment : newAttachments) {
            if(contentIdsSet.contains(eachAttachment.ContentType)) {
                oopsIdsSet.add(eachAttachment.parentId);
                objContMap.put(eachAttachment.ContentType, eachAttachment.parentId);
            }
        }    
        List<AF_OOPS_Actual__c> actualObjsToUpdate = new List<AF_OOPS_Actual__c>();
        List<AF_OOPS_Actual__c> actualObjs = [SELECT AF_Q1_Backup__c, AF_Q2_Backup__c,
                                              AF_Q3_Backup__c, AF_Q4_Backup__c
                                             FROM AF_OOPS_Actual__c
                                             WHERE Id IN :oopsIdsSet];
        for(AF_OOPS_Actual__c eachObj : actualObjs) {
            AF_OOPS_Actual__c actObj = new AF_OOPS_Actual__c();
            for(String eachCont : contentIdsSet) {
                if(objContMap != null && 
                    eachCont == 'OOPS Q1 Backup' && 
                    objContMap.get(eachCont) != null &&
                    objContMap.get(eachCont) == eachObj.Id) {
                    actObj = eachObj;
                    actObj.AF_Q1_Backup__c = true;
                } else if(objContMap != null && 
                    eachCont == 'OOPS Q2 Backup' && 
                    objContMap.get(eachCont) != null &&
                    objContMap.get(eachCont) == eachObj.Id) {
                    actObj = eachObj;
                    actObj.AF_Q2_Backup__c = true;
                } else if(objContMap != null && 
                    eachCont == 'OOPS Q3 Backup' && 
                    objContMap.get(eachCont) != null &&
                    objContMap.get(eachCont) == eachObj.Id) {
                    actObj = eachObj;
                    actObj.AF_Q3_Backup__c = true;
                } else if(objContMap != null && 
                    eachCont == 'OOPS Q4 Backup' && 
                    objContMap.get(eachCont) != null &&
                    objContMap.get(eachCont) == eachObj.Id) {
                    actObj = eachObj;
                    actObj.AF_Q4_Backup__c = true;
                }   
            }
            actualObjsToUpdate.add(actObj);
        }
        update actualObjsToUpdate;
    }
}