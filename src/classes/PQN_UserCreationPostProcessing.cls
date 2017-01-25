/*********
 * Queueable class called for creation of the AccountShare records that will share the accounts on the UserRequest provided
 * 

 * */
public with sharing class PQN_UserCreationPostProcessing implements Queueable{
    private Id userId;
    private Set<Id> accountsIds;
    private Id userRequestId;
    
    /**
     * Constructor takes the Id of one user that was created previously, as well as one UserRequestId for gathering the Accounts they want to access
     * */
    public PQn_UserCreationPostProcessing (Id userId, Id userRequestId, Set<Id> accountsIds){
        this.userId = userId;
        this.accountsIds = accountsIds;
        this.userRequestId = userRequestId;
    }
    
    /**
     * execute method calls helper class BFM_AccountSharer
     * */
    public void execute(QueueableContext SC){
        PQN_User_Creation_Request__c accessRequest = [SELECT User__c
                                                        FROM PQN_User_Creation_Request__c 
                                                  WHERE Id =:userRequestId];
        accessRequest.User__c = userId;
        update accessRequest;
        
        new PQN_AccountSharer().shareAccountsReadOnly(userId, accountsIds);
        System.enqueueJob(new PQN_UserCreateAssignPermissions(accessRequest));
    }
    
    
}