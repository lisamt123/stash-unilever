@IsTest
public class Engagement_home_test {
    
    static testMethod void engagement1() {
    
        Test.startTest();

        Engagement_User_Detail__c u = new Engagement_User_Detail__c();
        u.Location__c = 'Factory';
        u.Location_Name__c = 'Baddi Beverages';
        u.Question_Number__c = 2;
        u.Username__c = 'bhavya.p@capgemini.com';
        insert u;
        System.assertEquals(u.Location__c, 'Factory'); 
        
        Engagement_RS_Names__c rnames = new Engagement_RS_Names__c();
        rnames.RS_Code__c = 'VJMADH01';
        rnames.Name = 'VJMADH01 : MURLI KRISHAN TEA MERCHENT';
        insert rnames;
               
        Engagement_home_cc ehome = new Engagement_home_cc();
        ehome.home.Location__c = 'RS';
        ehome.rs.RS_Code__c='VJMADH01';
        ehome.onload();       
        ehome.start();
        ehome.start1();
       
        ehome.home.Location__c = 'Warehouse';
        u.Question_Number__c = 1;
        update u;
        ehome.onload();       
        ehome.start();
        ehome.start1();
        
        ehome.home.Location__c = 'Factory';
        u.Question_Number__c = 0;
        update u;
        ehome.onload();       
        ehome.start();
        ehome.start1();
  
        ehome.home.Location__c = 'RS';
        ehome.rs.RS_Code__c='ABt546';
        Engagement_Question__c q = new  Engagement_Question__c();
        q.Location__c = 'Factory';
        q.Name = 'W1';
        insert q;
        ehome.onload();       
        ehome.start();
        ehome.start1();
        
        Test.stopTest(); 
    }
}