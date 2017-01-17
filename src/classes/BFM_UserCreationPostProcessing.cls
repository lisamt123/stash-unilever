/*********
 * Queueable class called for creation of the AccountShare records that will share the accounts on the UserRequest provided
 * 
 * @author Zanquini, Vinicius
 * @date 2016/08/02
 * */
public with sharing class BFM_UserCreationPostProcessing implements Queueable{
    private Id userId;
    private Set<Id> accountsIds;
    private Id userRequestId;
    
    /**
     * Constructor takes the Id of one user that was created previously, as well as one UserRequestId for gathering the Accounts they want to access
     * */
    public BFM_UserCreationPostProcessing (Id userId, Id userRequestId, Set<Id> accountsIds){
        this.userId = userId;
        this.accountsIds = accountsIds;
        this.userRequestId = userRequestId;
    }
    
    /**
     * execute method calls helper class BFM_AccountSharer
     * */
    public void execute(QueueableContext SC){
        BFM_UserCreationRequest__c accessRequest = [SELECT Created_User__c, Tax_User__c
                                                    FROM BFM_UserCreationRequest__c 
                                                    WHERE Id =:userRequestId];
        accessRequest.Created_User__c = userId;
        update accessRequest;
        
        new BFM_AccountSharer().shareAccountsReadOnly(userId, accountsIds);
        System.enqueueJob(new BFM_UserCreationAssignPermissions(accessRequest));
    }
    
    
}