/**
* @author Cognizant
* @date 23/04/2015
* @description This is a test class to verify the changing of multi currency on the user object
*/

@isTest
public class UserTrigger_Test {
    
    public static final string EMPTY_STRING = '';
    public static final String BLANK_SPACE = ' ';
    //TO query the profile
    public static Set<String> profiles = new Set<String>{ 'System Administrator','Unilever - Force MultiApp Standard' };
    public static List<Profile> profileList = [SELECT Id, Name FROM Profile WHERE Name IN :profiles ORDER BY Name asc];

    static testMethod  void TestMultiCurrency()
    {
        
        String uniqueUserEMailId = getUniqueUsername();
        
        User normaluser = new User(Alias = uniqueUserEMailId.substring(18,23), Email=uniqueUserEMailId, 
        EmailEncodingKey=IPM_ConstantUtils.USER_EMAIL_ENCODE, LastName='Normal', LanguageLocaleKey=IPM_ConstantUtils.USER_LOCALEKEY, 
        LocaleSidKey='en_US', ProfileId = profileList[1].Id, 
        TimeZoneSidKey=IPM_ConstantUtils.USER_TIMEZONEKEY, UserName=uniqueUserEMailId+'Normal', 
        isActive =true);
        
        Insert normaluser;
        
        List<User> myusers = new list<User>([select id,LastName from user where id=:normaluser.Id]);
        system.assertEquals(myusers.size(), 1,'Normal User not created');
        system.assertEquals(myusers[0].LastName, 'Normal','User not created'); 
        
        User sysadmin = new User(Alias = uniqueUserEMailId.substring(18,23), Email=uniqueUserEMailId, 
        EmailEncodingKey=IPM_ConstantUtils.USER_EMAIL_ENCODE, LastName='Admin', LanguageLocaleKey=IPM_ConstantUtils.USER_LOCALEKEY, 
        LocaleSidKey='en_US', ProfileId = profileList[0].Id, 
        TimeZoneSidKey=IPM_ConstantUtils.USER_TIMEZONEKEY, UserName=uniqueUserEMailId+'Admin', 
        isActive =true);
        
        Insert sysadmin;
        
        List<User> myusers1 = new list<User>([select id,LastName from user where id=:sysadmin.Id]);
        system.assertEquals(myusers1.size(), 1,'Sys admin User not created');
        system.assertEquals(myusers1[0].LastName, 'Admin','User not created');    
        
        test.startTest();
        //Update MultiCurrency for Normal User
        system.RunAs(sysadmin){
        normaluser.DefaultCurrencyIsoCode='USD';
        
        Update normaluser;
        
        List<User> myusers2 = new list<User>([select id,DefaultCurrencyIsoCode from user where id=:normaluser.id]);
        system.assertEquals(myusers2[0].DefaultCurrencyIsoCode, 'USD','Currency Not changed'); 
            
        }
        system.RunAs(sysadmin){
        
        //Update Cannot Change Multicurrency Field
         normaluser.CannotChangeMC__c=true;
        
        Update normaluser;
        
        List<User> myusers3 = new list<User>([select id,DefaultCurrencyIsoCode from user where id=:normaluser.id]);
        system.assertEquals(myusers3[0].DefaultCurrencyIsoCode, 'EUR','Currency Not changed to Euro'); 
        test.stopTest();
        }
            
        
    }
    

    public static String getUniqueUsername() {
        String orgId = UserInfo.getOrganizationId();
        String dateString = String.valueof(Datetime.now()).replace(BLANK_SPACE,EMPTY_STRING).replace(':',EMPTY_STRING).replace('-',EMPTY_STRING);
        Integer randomInt = Integer.valueOf(math.rint(math.random()*1000000));
        String uniqueName = orgId + dateString + randomInt;
        
        return (uniqueName + '@bosscard' + orgId + '.org');
    }

}