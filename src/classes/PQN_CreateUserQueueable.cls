public with sharing class PQN_CreateUserQueueable implements Queueable {

    Id userRequestId;
     public PQN_CreateUserQueueable(Id userRequestId){
        this.userRequestId = userRequestId;    
    }
    public void execute(QueueableContext SC){
        PQN_User_Creation_Request__c usrreq = new PQN_User_Creation_Request__c();
        usrreq = [select id,Last_Name__c,First_Name__c,Nick_Name__c,Username__c,email__c,user__c,DC_Country__c,
                    Region__c,Cluster__c,Sub_Cluster__c,(SELECT Account__c,Account__r.parentid FROM PQN_User_Account_Requests__r),MCO__c from PQN_User_Creation_Request__c where id =:userRequestId];
        User usr = createUser(usrreq);
        try{
            insert usr;
            if(usr.id!=null){
            
               // usrreq.user__c = usr.id;
               // update usrreq;
                
                Set<Id> accountsIds = new Set<Id>();
                for(PQN_User_Account_Request__c accessRequest : [SELECT Account__c
                                                                    FROM PQN_User_Account_Request__c 
                                                                    WHERE PQN_User_Creation_Request__c  =:userRequestId]){
                    accountsIds.add(accessRequest.Account__c);                                                
                }
                 if(!Test.isRunningTest()){
                    System.enqueueJob(new PQN_UserCreationPostProcessing(usr.Id, userRequestId, accountsIds));
                }
                
              /*  string psname ='PQN_DC_Community_Set';
                PermissionSet ps = new PermissionSet();
                 if(psName!=''){
                     ps = [select id from PermissionSet where name=: psName limit 1];
                 }
                 if(ps!=null){
                     PermissionSetAssignment psa = new PermissionSetAssignment();
                     psa.AssigneeId = usr.id;
                     psa.PermissionSetId = ps.id;
                     insert psa;
                 }
                */    
            }
        }
        catch(Exception e){
            if(usr.contactId != null){
                Contact contactToDelete = new Contact(Id = usr.ContactId);
                delete contactToDelete;
            }
        }
    }
    private user createUser(PQN_User_Creation_Request__c userRequest){
        Profile communityProfile = [SELECT Id FROM Profile WHERE Name ='Partner Community User' LIMIT 1];
        //List<Account> listaccount = new List<Account>();
        Account acc = new Account();
        for(PQN_User_Account_Request__c ar: userrequest.PQN_User_Account_Requests__r){ 
            acc.id = ar.account__c;     
        }
       // listaccount = [select id,name from Account where name =: userRequest.DC_Country__c];
        contact con = new contact();
        con.lastname = userRequest.Last_Name__c;
        con.FirstName = userRequest.First_Name__c;
        if(acc.id!=null){
            con.accountid = acc.id;
        }
        if(con.accountid!=null){
            insert con;
        } 
        User u = new User();
        if(con!=null){
        
        u.Username = userRequest.Username__c;
        u.Email = userRequest.email__c;
        u.FirstName = userRequest.First_Name__c;
        u.LastName = userRequest.Last_Name__c;
        u.CommunityNickname = userRequest.Nick_Name__c;
        u.ProfileId = communityProfile.Id;
        u.alias = u.username.left(4);
        u.LocaleSidKey = 'en_GB';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'Europe/London';
        u.EmailEncodingKey = 'ISO-8859-1';
        
            u.contactid = con.id;
        }
        
        return u;      
    }
}