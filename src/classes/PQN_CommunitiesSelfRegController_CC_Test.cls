@isTest
private class PQN_CommunitiesSelfRegController_CC_Test { 
     
     private static testMethod void CommunitiesSelfRegController1(){
         List<Account> listacc = new List<Account>();
         Account acc = new Account();
         acc.name='DC1';
         acc.billingcountry = 'India';
         listacc.add(acc);
         Account acc1 = new Account();
         acc1.name='DC2';
         acc1.billingcountry = 'India';
         listacc.add(acc1);
         Account acc2 = new Account();
         acc2.name='DC3';
         acc2.billingcountry = 'India';
         listacc.add(acc2);
         insert listacc;
         system.assertEquals(listacc.size(),3);
        Id sysProfileId = [SELECt Id FROM Profile WHERE name = 'System Administrator' LIMIT 1].Id; 
        
        User u = new User();
        u.Username = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@testorg.com';
        u.Email = 'randomUsername'+datetime.now().getTime()+''+ UserInfo.getOrganizationId()+'@testOrg.com';
        u.FirstName = 'First Namepqn';
        u.LastName = 'Last Namepqn';
        u.CommunityNickname = ('Some_nicknamepqn'+String.valueOf(datetime.now().getTime())).left(80);
        u.ProfileId = sysProfileId;
        u.alias = u.username.left(4);
        u.LocaleSidKey = 'en_GB';
        u.LanguageLocaleKey = 'en_US';
        u.TimeZoneSidKey = 'Europe/London';
        u.EmailEncodingKey = 'ISO-8859-1';
        insert u;
        
        
         PQN_CommunitiesSelfRegController_CC ctrl = new PQN_CommunitiesSelfRegController_CC();
         
         
         ctrl.pqnusr.DC_Country__c ='India';
         ctrl.changecountry();         
         //PQN_CommunitiesSelfRegController_CC.RequestLine wrapreq = new PQN_CommunitiesSelfRegController_CC.RequestLine(acc);
         //wrapreq.isSelected=true;        
                 
         for(PQN_CommunitiesSelfRegController_CC.RequestLine r: ctrl.RequestLines){
             r.isselected = true;
         }
         ctrl.registerUser();
         
         ctrl.pqnusr.User_Type__c = 'DC';
         ctrl.registerUser();
         
         ctrl.pqnusr.DC_Country__c =null;
         ctrl.changecountry();
         
         ctrl.pqnusr.DC_Country__c ='testc';
         ctrl.changecountry();
         ctrl.registerUser();
         
         ctrl.pqnusr.DC_Country__c ='India';
         ctrl.changecountry();
         ctrl.registerUser();
         
         PQN_CommunitiesSelfRegController_CC ctrl2 = new PQN_CommunitiesSelfRegController_CC();
         ctrl2.pqnusr.DC_Country__c ='India';
         ctrl2.changecountry();
         for(PQN_CommunitiesSelfRegController_CC.RequestLine r: ctrl2.RequestLines){
             r.isselected = true;
         }
         ctrl2.pqnusr.User_Type__c = 'DC';
         ctrl2.registerUser();
         
         
         
        
     }
}