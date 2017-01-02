@isTest
Private Class PQN_UserCreateAssignPermissionsTest
{
 static testMethod void  testPQN_UserCreateAssignPermission()
{
    
    test.starttest();
        
    
       PQN_User_Creation_Request__c  userCreationRequest=PQN_TestLibraryUtil.createUserCreationRequest();
       // userCreationRequest.User_Type__c='cluster';
       insert userCreationRequest;
        
        Account dc1Account = PQN_TestLibraryUtil.createpqnAccount('DC1','India');
        insert dc1Account;
        set<id> accid=new set<id>();
        accid.add(dc1Account.id);
        User usr=PQN_TestLibraryUtil.createPQNUser();
        insert usr;     
        
         //System.enqueueJob(new PQN_UserCreateAssignPermission());
        // PQN_UserCreateAssignPermission pqn1=new PQN_UserCreateAssignPermission(userCreationRequest);
        Queueable q=new PQN_UserCreateAssignPermissions(userCreationRequest);
        q.execute(null);
        //userCreationRequest.User_Type__c='DC';
        
        test.stoptest();
        
}
}