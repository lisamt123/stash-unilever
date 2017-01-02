@isTest
private class PQN_UserCreationPostProcessing_Test {
    private static testMethod void myTestpro(){
        PQN_User_Creation_Request__c userCreationRequest = PQN_TestLibraryUtil.createUserCreationRequest();
        insert userCreationRequest;
        user u=PQN_TestLibraryUtil.createPQNUser();
        insert u;
        account acc=PQN_TestLibraryUtil.createpqnAccount('DC1','India');
        insert acc;
        set<id> accid=new set<id>();
        accid.add(acc.id);
        test.starttest();
        
       // PQN_UserCreationPostProcessing  pqn=new PQN_UserCreationPostProcessing (u.id,userCreationRequest.id,accid);
       Queueable q= new PQN_UserCreationPostProcessing(u.id,userCreationRequest.id,accid);
        q.execute(null);
        
        test.stoptest();
        }
        }