@isTest
public class UL_UserTestFactory {
    public static User defaultUser;
    public static User systemAdmin;
    
    //Following variable has been added to retrieve the Global picklist value for Sales Org in Org
    public static List<String> lstSalesOrg;
    
    public static String getLoggedInUserTimeZoneSidKey()
    {
        User loggedInUser = new User();
        loggedInUser = [select TimeZoneSidKey from User where id =: UserInfo.getUserId() limit 1];
        return loggedInUser.TimeZoneSidKey;
    }
    public static User buildUser(Integer i) {
        Profile p = [select id from profile where name='System Administrator' Limit 1];        
        String strUserTimeZoneSidKey = getLoggedInUserTimeZoneSidKey();
        User u = new User();
        u.FirstName         = Constants.NAME+i;
        u.LastName          = 'of Arendelle';
        u.Email             = 'elsa@disney.com';
        u.Alias             = 'elsa' + i;
        u.Username          = Constants.NAME + i + '@disney.com';
        u.LocaleSidKey      = 'en_US';
        u.TimeZoneSidKey    = strUserTimeZoneSidKey;
        u.ProfileID         =  p.id;
        u.LanguageLocaleKey = 'en_US';
        u.EmailEncodingKey  = 'UTF-8';
        return u;
    }
    public static User buildDefaultUser() {
        return buildUser(-1);    
    }
    public static User insertUser(Integer i){
        User u = buildUser(i);
        insert u;
        return u;
    }
    public static User getDefaultUser() {
        if(defaultUser == null) {
            defaultUser = insertUser(-1);   
        }
        return defaultUser;
    }
    public static List<User> buildUsers(Integer noOfUsers) {
        Profile p = [select id from profile where name='System Administrator' Limit 1];
        String strUserTimeZoneSidKey = getLoggedInUserTimeZoneSidKey();
        List<User> listUserBuild = new List<User>();
        for(Integer i=0;i<noOfUsers;i++){
            User u = new User();
            u.FirstName         = Constants.NAME+i;
            u.LastName          = 'of Arendelle';
            u.Email             = 'elsa@disney.com';
            u.Alias             = 'elsa' + i;
            u.Username          = Constants.NAME + i + '@disney.com';
            u.LocaleSidKey      = 'en_US';
            u.TimeZoneSidKey    = strUserTimeZoneSidKey;
            u.ProfileID         =  p.id;
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey  = 'UTF-8';
            listUserBuild.add(u);
        }
        return listUserBuild;
    } 
    public static List<User> insertUsers(Integer noOfUsers) 
    {
         List<User> listUser;
        if (systemAdmin==null){
            systemAdmin = [Select id, name from User where id = :Userinfo.getUserid()];
        }
        System.runAs(systemAdmin){
            listUser=  buildUsers(noOfUsers); 
            insert listUser;
            
        }
     
        return listUser;
    }
    public static User insertUserWithProfile(Integer i, String Profile) 
    {
        User user;
        if (systemAdmin==null){
            systemAdmin = [Select id, name from User where id = :Userinfo.getUserid()];
        }
        System.runAs(systemAdmin){
            user=  buildUserWithProfile(i,Profile);
            if(user != null)
            {
                insert user;
            }   
            
        }
        return user;
    }
    public static User buildUserWithProfile(Integer i, String Profile)
    {
        
        
        try
        {
            Profile p = [select id from profile where name=:Profile Limit 1];   
            String strUserTimeZoneSidKey = getLoggedInUserTimeZoneSidKey();         
            User u = new User();
            u.FirstName         = Constants.Name+i;
            u.LastName          = 'of Arendelle';
            u.Email             = 'elsa@disney.com';
            u.Alias             = 'elsa' + i;
            u.Username          = 'elsa' + i + '@disney.com';
            u.LocaleSidKey      = 'en_US';
            u.TimeZoneSidKey    = strUserTimeZoneSidKey;
            u.ProfileID         =  p.id;
            u.LanguageLocaleKey = 'en_US';
            u.EmailEncodingKey  = 'UTF-8';
            return u;
        }
        catch(Exception e)
        {
            return null;
        }
    }
    public static void insertUserPermissionset(User user, String permissionSet) 
    {
        
        if (systemAdmin==null){
            systemAdmin = [Select id, name from User where id = :Userinfo.getUserid()];
        }
        System.runAs(systemAdmin){
            PermissionSetAssignment psa=  buildAssignUserPermissionset(user,permissionSet);
            if(psa != null)
            {
                insert psa;
            }
        }
    }
    
    
    
    
    public static PermissionSetAssignment buildAssignUserPermissionset(User user, String permissionSet) 
    {
        PermissionSetAssignment psa;
        if (systemAdmin==null){
            systemAdmin = [Select id, name from User where id = :Userinfo.getUserid()];
        }
       
            try
            {
                 System.runAs(systemAdmin){
                    PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = :permissionSet];          
                    // Permission Set Assigment for the user.
                    psa = new PermissionSetAssignment(PermissionSetId = ps.Id, AssigneeId = user.id);
                    
                 }
              
            }
            catch (Exception e)
            {
                psa = null;
              
            }
          return psa;
      }
      
       public static ACCL__User_Setting__c getDefaultUserSetting(Id userId, Id OwnerId) {
        
       ACCL__User_Setting__c userSetting = new ACCL__User_Setting__c();
        
        if (systemAdmin==null){
            systemAdmin = [Select id, name from User where id = :Userinfo.getUserid()];
        }
        System.runAs(systemAdmin){
            
            //UserSetting
            userSetting.ACCL__User__c = userId; //Userinfo.getUserId();
            userSetting.OwnerId = OwnerId; 
            userSetting.ACCL__Work_Begins__c = '06:00';
            userSetting.ACCL__Work_Ends__c = '17:00';
            userSetting.ACCL__Works_On_Monday__c = true;
            userSetting.ACCL__Works_On_Tuesday__c = true;
            userSetting.ACCL__Works_On_Wednesday__c = true;
            userSetting.ACCL__Works_On_Thursday__c = true;
            userSetting.ACCL__Works_On_Friday__c = true;
            
            insert userSetting;
        
        }
        return userSetting;
      }
      
      
      /*
      Name:getSalesOrg
      Purpose:This Method has been created to fetch the picklist from Global Sales Org. 
      Author: Susmita.a.kar@Accenture.com 27/07/2016
      See: All the Test Factory relevant for Sales Org
      Note : Sales Org uses a global picklist which must be deployed with data in target environment before running
          Sales Org dependent class.
      */
      public static List<String> getSalesOrg()
      {
         if(lstSalesOrg==null)
         {
             lstSalesOrg = new List<String>();
             Schema.DescribeFieldResult F = User.ACCL__Sales_Org__c.getDescribe();
             for(Schema.PicklistEntry P : F.getPicklistValues())
             {
                lstSalesOrg.add(p.getValue());
             }
         }
         return lstSalesOrg;
      }
     
      
}