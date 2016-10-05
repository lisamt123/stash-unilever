@isTest
private class CI_R2R_Budget_Trigger_Test{
    static testMethod void test_CI_R2R_Budget_Trigger(){
        Test.startTest(); 
        
        list<CI_R2R_Budget_Mapping__c> maplist = new list<CI_R2R_Budget_Mapping__c>();
        CI_R2R_Budget_Mapping__c bm= new CI_R2R_Budget_Mapping__c();
        bm.Name = 'Test1';
        bm.Company_Code__c = '2646';
        bm.ICC_Number__c = 'ICC14131';
        bm.R2R_SME_Area__c = 'SCOA';
        bm.Cost_Centre__c = '19193';
        maplist.add(bm);  
        
        insert maplist;
        System.assertEquals(bm.Company_Code__c == '2646',true);
        
        CI_R2R_Innovation__c ci = new CI_R2R_Innovation__c ();
        ci.R2R_SME_Area__c = 'SCOA';
        insert ci;
        
        CI_R2R_Budget__c bd = new CI_R2R_Budget__c();
        bd.CI_R2R_Innovation__c = ci.id;
        bd.Company_Code__c='2646'; 
        bd.Cost_Centre__c = '19193';
        insert bd;        
        system.debug('bd-->'+bd);
        
        System.assertEquals(bd.Company_Code__c=='2646',true);
        update bd;
        for(CI_R2R_Budget__c b2 : [select id,ICC_Number2__c from CI_R2R_Budget__c where id =: bd.id ]){      
            system.debug('bd1-->'+b2.ICC_Number2__c);
        }
        
        Test.stopTest(); 
        
    }
 
}