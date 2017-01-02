public class PQN_TestLibraryUtil {

    
    private static Id sysProfileId = [SELECt Id FROM Profile WHERE name = 'System Administrator' LIMIT 1].Id;
    public static PQN_Supplier__c createSupplier()
    {
        PQN_Supplier__c s = new PQN_Supplier__c(Name='Test Account Name',
        Supplier_Number__c='2312',
        Supplier_Type__c='DC');
        return s ;
    }
 
    
    public static PQN_Pallet_Quality_Non_Conformance__c createPQN_Pallet_Quality_Non_Conformance(id sid,id accid,id dcvid){
        PQN_Pallet_Quality_Non_Conformance__c PQN = new PQN_Pallet_Quality_Non_Conformance__c( 
        Region__c='Europe',
    Reporting_DC__c='DC1',
    //Month__c='January',
    //Year__c='2016',
    MCO__c='HUAD',
    DC_Country__c='India',
    Cluster__c='Europe',
    Delivery_Note_Number__c='20',
    SKU__c='153489',
    Product_Name__c='sdfsd',
    Date_Pallet_Received__c=date.newInstance(2016,1,15),
    //Date_Pallet_Received__c=date.today(),
    Supplier_Number__c ='1234',
    Supplier_type__c='DC',
    Non_compliance_reason_code__c=12,Account__c=accid,DC_Volumes__c=dcvid);
        return  PQN;
    }
    
    public static user createPQNUser(){
        User u = new User();
        u.Username = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@randomOrg.com';
        u.Email = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@randomOrg.com';
        u.FirstName = 'First Name';
        u.LastName = 'Last Name';
        u.CommunityNickname = ('Some_nickname'+String.valueOf(datetime.now().getTime())).left(80);
        u.ProfileId = PQN_TestLibraryUtil.sysProfileId;
        u.alias = u.username.left(4);
        u.LocaleSidKey = 'en_GB';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'Europe/London';
        u.EmailEncodingKey = 'ISO-8859-1';
        return u;
    }
     public static Account createpqnAccount(string name,string country){
        Account acc = new Account(Name = name,billingcountry = country);
        return acc;
    }
    

    public static PQN_User_Creation_Request__c createUserCreationRequest(){
       PQN_User_Creation_Request__c userCreationRequest = new PQN_User_Creation_Request__c();
        userCreationRequest.Last_Name__c = 'Test Last Name';
        userCreationRequest.First_Name__c = 'Test first Name';
        userCreationRequest.Email__c = 'email@testEmail.notreal.com';
        userCreationRequest.Nick_name__c = 'PRandomCommunityNickname';
        userCreationRequest.dc_country__c = 'India';
        userCreationRequest.User_Type__c='DC';
        userCreationRequest.Username__c = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@randomOrg.com';
        return userCreationRequest;
    }
    public static PQN_User_Account_Request__c createAccountAccessRequest(Id idUserCreationRequest, Id idAccount){
        PQN_User_Account_Request__c accountAccessRequest = new PQN_User_Account_Request__c();
        accountAccessRequest.Account__c = idAccount;
        accountAccessRequest.PQN_User_Creation_Request__c = idUserCreationRequest;
        return accountAccessRequest;
    }
   public static PQN_DC_Volumes__c createDCvolumes(){
        PQN_DC_Volumes__c createdcv = new PQN_DC_Volumes__c();
        createdcv.Month__c='January';
        createdcv.Reporting_DC__c='DC1';
        createdcv.Year__c='2016';
        createdcv.Total_Pallets_Checked_By_DC__c=123456;
        createdcv.Total_Pallets_received_by_DC__c=654321;
        return createdcv ;
      }  
   public static PQN_Targets__c createtargets(){
       PQN_Targets__c createtar=new PQN_Targets__c();
       createtar.Geography__c='India';
       createtar.year__c='2016';
       createtar.Region__c='Europe';
       //createtar.Target__c='India';
       createtar.Target_Reduction__c=25;
       return createtar;
       }
       
       
        
}