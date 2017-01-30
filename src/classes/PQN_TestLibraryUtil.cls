public class PQN_TestLibraryUtil {

    
    private static Id sysProfileId = [SELECt Id FROM Profile WHERE name = 'System Administrator' LIMIT 1].Id;
    public static PQN_Supplier__c createSupplier()
    {
        PQN_Supplier__c s = new PQN_Supplier__c(Name='Test Account Name',
        Supplier_Number__c='2312',
        Supplier_Type__c='SU',
        Supplier_Cluster__c='Europe',
        Supplier_Region__c='Americas',
        Supplier_Sub_Cluster__c='brazil',
        Country__c='India');
        return s ;
    }
 
    
    public static PQN_Pallet_Quality_Non_Conformance__c createPQN_Pallet_Quality_Non_Conformance(id sid,id accid,id dcvid){
        PQN_Pallet_Quality_Non_Conformance__c PQN = new PQN_Pallet_Quality_Non_Conformance__c( 
        Region__c='Americas',
      Supplier__c=' Test Account Name', 
    Reporting_DC__c='DC1',
    //Month__c='January',
    //Year__c='2016',
    MCO__c='HUAD',
    DC_Country__c='India',
    Cluster__c='Latin America',
    Sub_Cluster__c='brazil',
    Delivery_Note_Number__c='20',
    SKU__c='153489',
    //Product_Name__c='sdfsd',
    Supplier_Region__c='Americas',
    Supplier_Cluster__c='Europe',
    Supplier_Sub_Cluster__c='brazil',
    Supplier_Country__c='India',
    Product_Group__c='Personal Care',
    Product_Name__c='DUDOV_BOT_SH_250ML_THICK_DEMOMEN_DACH',
    Product_Category__c='Hair Care',
    Date_Pallet_Received__c=date.newInstance(2017,1,15),
    Loss_Level_2__c='Configuration / Build',
    //Date_Pallet_Received__c=date.today(),
    Supplier_Number__c ='1234',
    Supplier_type__c='SU',
    Number_of_Pallets_Per_SKU_Non_Compliant__c=20,
    Non_compliance_reason_code__c=12,Account__c=accid,DC_Volumes__c=dcvid);
    //Product_Group__c='Personal Care',
    //Product_Category__c='Hair Care';
    
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
        u.country = 'India';
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
        createdcv.Year__c='2017';
        createdcv.Total_Pallets_Checked_By_DC__c=123456;
        createdcv.Total_Pallets_received_by_DC__c=654321;
        return createdcv ;
      }  
   public static PQN_Targets__c createtargets(){
       PQN_Targets__c createtar=new PQN_Targets__c();
       //createtar.Geography__c='India';
       createtar.year__c='2017';
       createtar.Region__c='Americas';
       //createtar.Target__c='India';
       createtar.Target_Reduction__c=25;
       return createtar;
       }
      public static PQN_Sourcing_Unit__c createSourcingUnit(){
      PQN_Sourcing_Unit__c source=new PQN_Sourcing_Unit__c();
      source.Month__c='1';
      source.Soucing_Unit_Number__c='10';
      source.Sourcing_Unit_Name__c='Europe';
      source.Total_Volume_Of_pallets_Shipped__c=1000;
      source.Year__c='2017';
      return source;
      }
      
       public static Contact createContact(id accid)
       {
           Contact cont=new Contact();
           cont.lastname='abc';
           cont.accountid=accid;
           return cont;
       }
       
       
        
}