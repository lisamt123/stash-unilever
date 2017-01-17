/**
 * Method called from the Process Builder workflow that identifies one User Request has been approved
 * */

global with sharing class PQN_CreateCommuntiyUser {
  @InvocableMethod 
    public static void createUser(List<PQN_User_Creation_Request__c> userRequests){
        if(userRequests != null){
            PQN_User_Creation_Request__c userRequest = userRequests[0];
            System.enqueueJob(new PQN_CreateUserQueueable(userRequest.Id));
        } else{
            System.debug('User requests was null');
        }
    }
    
    
}