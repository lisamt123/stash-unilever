public class BFM_UserCreationRequestAttachmentCheck {

    public static void checkAttachments(Map<Id, BFM_UserCreationRequest__c> oldMap, Map<Id, BFM_UserCreationRequest__c> newMap){
        Set<Id> requestsWithAttachments = new Set<Id>();
        for (Attachment att : [SELECT ParentId FROM Attachment WHERE parentId IN: newMap.keySet()]){
            requestsWithAttachments.add(att.parentId);
        }
        
        for(Id idRequestUpdated: trigger.newMap.keySet()){
            //if it doesn`t have an attachment and was approved, throw an error
            if(!requestsWithAttachments.contains(idRequestUpdated) && oldMap.get(idRequestUpdated).Request_Approved__c == false
               && newMap.get(idRequestUpdated).Request_Approved__c == true){
                   newMap.get(idRequestUpdated).addError(Label.BFM_Approval_No_Attachment_Found);
            }
        }
        
    }
}