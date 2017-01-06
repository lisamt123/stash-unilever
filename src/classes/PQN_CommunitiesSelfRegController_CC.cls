/**
 * An apex page controller that supports self registration of users in communities that allow self registration
 */
public without sharing class PQN_CommunitiesSelfRegController_CC {

    
   // public String password {get; set {password = value == null ? value : value.trim(); } }
   // public String confirmPassword {get; set { confirmPassword = value == null ? value : value.trim(); } }
    
    public PQN_User_Creation_Request__c pqnusr {get; set;}
    public List<RequestLine> requestLines{get;set;}
    public boolean showdcs{get; set;}
    public boolean submitenabled{get; set;}
    
    public PQN_CommunitiesSelfRegController_CC() {
        pqnusr = new PQN_User_Creation_Request__c();
    }
    
   public void changecountry(){
       List<Account> listacc = new List<Account>();
       requestLines = new List<RequestLine>();
       listacc = PQN_AccountDAO.getAccountsWithDcCountry(pqnusr.DC_Country__c);
       if(listacc.isEmpty()){
           ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Selected country doesn\'t have DC\'s associated to it. Please contact Administrator');
           ApexPages.addMessage(msg);
           submitenabled = false;
       }
       else{
           showdcs = true;
           requestLines = new List<RequestLine>();
           for(Account a: listacc){
               requestLines.add(new RequestLine(a)); 
                  
           } 
           if(!requestLines.isEmpty()){
               submitenabled =true;
           }
             
       }
   }
   
    public class RequestLine{
        
        public boolean isSelected{get;set;}
        public Account branch{get;set;}
        
        public RequestLine(Account branchpqn){
            isSelected = false;
            branch = branchpqn;
        }
    }

    public PageReference registerUser() {
        
        List<User> listusers = new list<User>();
        listusers = [select id from user where userName=: pqnusr.userName__c or communityNickname =:pqnusr.Nick_name__c];

        integer errcount =0;
        if(!listusers.isEmpty()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'User exists with this username or nickname');
            ApexPages.addMessage(msg);
            errcount++;
            return null;
        }
        List<Account> desiredDCs = new List<Account>();
        if(!requestLines.isEmpty()){
            desiredDCs = getDesiredDCs();
            if(requestLines[0].branch.pqn_country__c!=pqnusr.dc_country__c){
                ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Country and DC Countries does not match. Please click Fetch DCs');
                ApexPages.addMessage(msg);
                errcount++;
                return null;
            }
        }
        else{
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Selected Country does not have any DCs');
            ApexPages.addMessage(msg);
            errcount++;
            return null;
        }
        
        
        if(desiredDCs.isEmpty()){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select atleast one DC');
            ApexPages.addMessage(msg);
            errcount++;
            return null;    
        }
        if(pqnusr.User_Type__c== 'DC' && desiredDCs.size() > 1){
            ApexPages.Message msg = new ApexPages.Message(ApexPages.Severity.ERROR,'Please select only one DC');
            ApexPages.addMessage(msg);
            errcount++;
            return null; 
        }
        if(errcount == 0){
            
        /*PQN_User_Creation_Request__c ur = new PQN_User_Creation_Request__c();
        ur.First_Name__c = pqnusr.first_Name__c;
        ur.Last_Name__c = pqnusr.last_Name__c;
        ur.Username__c = pqnusr.userName__c;
        ur.Email__c = pqnusr.email__c;
        ur.Nick_Name__c = pqnusr.Nick_name__c;
        */
        
        try{
            if(pqnusr!=null){
                insert pqnusr;
            }
             new PQN_CreateAccessRequest(pqnusr, desiredDCs).createAccessRequests();
                        
            // Create an approval request for the account
            Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
            req1.setComments('Submitting request for approval.');
            req1.setObjectId(pqnusr.id);
            Approval.ProcessResult result = Approval.process(req1);
            
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'User request got created and sent for Approval')) ; 
            
            pqnusr = new PQN_User_Creation_Request__c();
            requestLines.clear();
            submitenabled = false;
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
    
    public list<Account> getDesiredDCs(){
        list<Account> desiredDCs = new List<Account>();
        for(RequestLine reqLine: requestLines){
            if(reqLine.isSelected){
                desiredDCs.add(reqLine.branch);
            }
        }
        system.debug('--->'+desiredDCs);
        return desiredDCs;
    }    
}