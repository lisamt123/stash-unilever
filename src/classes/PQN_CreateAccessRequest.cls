public without sharing class PQN_CreateAccessRequest {
    
    private PQN_User_Creation_Request__c newUserRequest;
    private List<Account> accounts;
    public PQN_CreateAccessRequest(PQN_User_Creation_Request__c newUserRequest, List<Account> accounts){
        this.accounts = accounts;
        this.newUserRequest = newUserRequest;
    }
    
    public void createAccessRequests(){
        List<PQN_User_Account_Request__c> accessRequests = new List<PQN_User_Account_Request__c>();
        
        for(Account Branch: accounts){
            PQN_User_Account_Request__c newAccessRequest = new PQN_User_Account_Request__c(
                                        Account__c = Branch.Id,
                                        PQN_User_Creation_Request__c = newUserRequest.Id);
            accessRequests.add(newAccessRequest);
        }
        insert accessRequests;
        

    }

    
}