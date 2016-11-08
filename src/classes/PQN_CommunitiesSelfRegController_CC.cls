/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public with sharing class PQN_CommunitiesSelfRegController_CC {

    public String firstName {get; set;}
    public String userName {get; set;}
    public String lastName {get; set;}
    public String email {get; set;}
   // public String password {get; set {password = value == null ? value : value.trim(); } }
   // public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    public String communityNickname {get; set { communityNickname = value == null ? value : value.trim(); } }
    
    public PQN_CommunitiesSelfRegController_CC() {}
    
   

    public PageReference registerUser() {
        
        List<User> listusers = new list<User>();
        listusers = [select id from user where userName=: userName or communityNickname =:communityNickname];
        if(!listusers.isEmpty()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'User exists with this username or nickname');
            ApexPages.addMessage(msg);
            return null;
        }
        else{
        PQN_User_Creation_Request__c ur = new PQN_User_Creation_Request__c();
        ur.First_Name__c = firstName;
        ur.Last_Name__c = lastName;
        ur.Username__c = userName;
        ur.Email__c = email;
        ur.Nick_Name__c = communityNickname;
        
        try{
            insert ur;
            
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'User request got created and sent for Approval')) ;
            
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(ur.id);
            Approval.ProcessResult result = Approval.process(req1);
            //PageReference page = System.Page.PQN_CommunitiesSelfReg_VF;
               // page.setRedirect(true);
                return null;
        }
        catch(Exception e){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR, e.getmessage());
            ApexPages.addMessage(msg);
            return null;
        }
        }
        return null;  

       
        
        
        
        
                
            
       
    }
}