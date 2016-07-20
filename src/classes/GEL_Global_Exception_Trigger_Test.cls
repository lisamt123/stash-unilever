@isTest
private class GEL_Global_Exception_Trigger_Test{
    static testMethod void test_GEL_Global_Exception_Trigger(){
        Test.startTest(); 
        list<Global_Exception_Users__c> globalList = new list<Global_Exception_Users__c>();
        
        Global_Exception_Users__c geu = new Global_Exception_Users__c();
        geu.name = 'bank';
        geu.Email__c='Veptestuse12312r@test.com';
        globalList.add(geu);  
             
        insert globalList ;
        System.assertEquals(geu.name == 'bank',true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
        list<user> user1 = new list<user>();
        User u = new User(LastName = 'Testing', 
                                 Username = 'Veptestuse12312r@test.com', 
                                 Email = 'Veptestuser@test.com', 
                                 Alias = 'vept', 
                                 TimeZoneSidKey = 'Europe/London', 
                                 LocaleSidKey = 'en_GB', 
                                 EmailEncodingKey = 'UTF-8', 
                                 ProfileId = p.Id, 
                                 LanguageLocaleKey = 'en_US'
                                 );  
        user1.add(u);                         
        insert user1;
        System.assert(u.id != null);
        update user1;
        
        GEL_Global_Exception_Log__c gel = new GEL_Global_Exception_Log__c();        
        gel.Process__c = 'Bank Statements';
        insert gel;
        System.assertEquals(gel.Process__c == 'Bank Statements',true);
        update gel;
        
        Test.stopTest(); 
    }
}