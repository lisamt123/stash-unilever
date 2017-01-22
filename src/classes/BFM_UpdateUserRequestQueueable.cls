public with sharing class BFM_UpdateUserRequestQueueable implements Queueable {
  Id userCreationRequestId;
    Id userId;
    public BFM_UpdateUserRequestQueueable(Id userCreationRequestId, Id userId){
        this.userCreationRequestId = userCreationRequestId;
        this.userId = userId;
    }
    
    public void execute(QueueableContext SC){
        BFM_UserCreationRequest__c creationRequest = [SELECT Created_User__c FROM BFM_UserCreationRequest__c WHERE Id =:this.userCreationRequestId LIMIT 1];
        creationRequest.Created_User__c = this.userId;
        update creationRequest;
    }
}