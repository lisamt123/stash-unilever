@isTest(seeAllData=true)
private class CI_R2R_Budget_Trigger_Test{
    static testMethod void test_CI_R2R_Budget_Trigger(){
        Test.startTest(); 
        
        list<CI_R2R_Budget_Mapping__c> maplist = new list<CI_R2R_Budget_Mapping__c>();
        CI_R2R_Budget_Mapping__c bm= new CI_R2R_Budget_Mapping__c();
        bm.Name = '1test';
        bm.Company_Code__c = '2646';
        bm.R2R_SME_Area__c = 'SCOA';
        maplist.add(bm);  
        
        insert maplist;
        System.assertEquals(bm.Company_Code__c == '2646',true);
        
        CI_R2R_Innovation__c ci = new CI_R2R_Innovation__c ();
        ci.R2R_SME_Area__c = 'SCOA';
        insert ci;
        
        CI_R2R_Budget__c bd = new CI_R2R_Budget__c();
        bd.CI_R2R_Innovation__c = ci.id;
        bd.Company_Code__c='2646';           
        insert bd;
        System.assertEquals(bd.Company_Code__c=='2646',true);
        update bd;
        
        
        Test.stopTest(); 
        
    }
}