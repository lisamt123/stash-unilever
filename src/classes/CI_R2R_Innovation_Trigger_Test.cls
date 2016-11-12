@isTest
private class CI_R2R_Innovation_Trigger_Test{
    static testMethod void test_CI_R2R_Innovation_Trigger(){
        Test.startTest(); 
        CI_R2R_Innovation__c ci = new CI_R2R_Innovation__c ();
        ci.R2R_SME_Area__c = 'Fixed Assets';
        insert ci;
        System.assertEquals(ci.R2R_SME_Area__c == 'Fixed Assets',true);
        update ci;
        
        CI_R2R_Innovation__c ci1 = new CI_R2R_Innovation__c ();
        ci1.R2R_SME_Area__c = 'Account Reconciliation';
        insert ci1;
        System.assertEquals(ci1.R2R_SME_Area__c == 'Account Reconciliation',true);
        update ci1;
        
        CI_R2R_Innovation__c ci2 = new CI_R2R_Innovation__c ();
        ci2.R2R_SME_Area__c = 'Continuous Improvement';
        insert ci2;
        System.assertEquals(ci2.R2R_SME_Area__c == 'Continuous Improvement',true);
        update ci2;
        
        CI_R2R_Innovation__c ci3 = new CI_R2R_Innovation__c ();
        ci3.R2R_SME_Area__c = 'Financial Reporting';
        insert ci3;
        System.assertEquals(ci3.R2R_SME_Area__c == 'Financial Reporting',true);
        update ci3;
        
        CI_R2R_Innovation__c ci4 = new CI_R2R_Innovation__c ();
        ci4.R2R_SME_Area__c = 'FX Revaluation';
        insert ci4;
        System.assertEquals(ci4.R2R_SME_Area__c == 'FX Revaluation',true);
        update ci4;
        
        CI_R2R_Innovation__c ci5 = new CI_R2R_Innovation__c ();
        ci5.R2R_SME_Area__c = 'Intercompany';
        insert ci5;
        System.assertEquals(ci5.R2R_SME_Area__c == 'Intercompany',true);
        update ci5;
        
        CI_R2R_Innovation__c ci6 = new CI_R2R_Innovation__c ();
        ci6.R2R_SME_Area__c = 'Journal Entries';
        insert ci6;
        System.assertEquals(ci6.R2R_SME_Area__c == 'Journal Entries',true);
        update ci6;
        
        CI_R2R_Innovation__c ci7 = new CI_R2R_Innovation__c ();
        ci7.R2R_SME_Area__c = 'GL MDM';
        insert ci7;
        System.assertEquals(ci7.R2R_SME_Area__c == 'GL MDM',true);
        update ci7;
        
        CI_R2R_Innovation__c ci8 = new CI_R2R_Innovation__c ();
        ci8.R2R_SME_Area__c = 'Period-End';
        insert ci8;
        System.assertEquals(ci8.R2R_SME_Area__c == 'Period-End',true);
        update ci8;
        
        CI_R2R_Innovation__c ci9 = new CI_R2R_Innovation__c ();
        ci9.R2R_SME_Area__c = 'Project';
        insert ci9;
        System.assertEquals(ci9.R2R_SME_Area__c == 'Project',true);
        update ci9;
        
        CI_R2R_Innovation__c ci10 = new CI_R2R_Innovation__c ();
        ci10.R2R_SME_Area__c = 'SAP Roles';
        insert ci10;
        System.assertEquals(ci10.R2R_SME_Area__c == 'SAP Roles',true);
        update ci10;
        
        CI_R2R_Innovation__c ci11 = new CI_R2R_Innovation__c ();
        ci11.R2R_SME_Area__c = 'Tax';
        insert ci11;
        System.assertEquals(ci11.R2R_SME_Area__c == 'Tax',true);
        update ci11;
        
        CI_R2R_Innovation__c ci12 = new CI_R2R_Innovation__c ();
        ci12.R2R_SME_Area__c = 'Tools';
        insert ci12;
        System.assertEquals(ci12.R2R_SME_Area__c == 'Tools',true);
        update ci12;
        
        CI_R2R_Innovation__c ci13 = new CI_R2R_Innovation__c ();
        ci13.R2R_SME_Area__c = 'GPM';
        insert ci13;
        System.assertEquals(ci13.R2R_SME_Area__c == 'GPM',true);
        update ci13;
        
        CI_R2R_Innovation__c ci14 = new CI_R2R_Innovation__c ();
        ci14.R2R_SME_Area__c = 'SCOA';
        insert ci14;
        System.assertEquals(ci14.R2R_SME_Area__c == 'SCOA',true);
        update ci14;
        
        CI_R2R_Innovation__c ci15 = new CI_R2R_Innovation__c ();
        ci15.R2R_SME_Area__c = 'Direct Tax';
        insert ci15;
        System.assertEquals(ci15.R2R_SME_Area__c == 'Direct Tax',true);
        update ci15;
        
        CI_R2R_Innovation__c ci16 = new CI_R2R_Innovation__c ();
        ci16.R2R_SME_Area__c = 'Indirect Tax';
        insert ci16;
        System.assertEquals(ci16.R2R_SME_Area__c == 'Indirect Tax',true);
        update ci16;
        
        CI_R2R_Innovation_TriggerHandler handler = new CI_R2R_Innovation_TriggerHandler();
        handler.beforeInsert(ci16);
        handler.beforeUpdate(ci15,ci16);
        handler.beforeUpdate(ci13,ci14);
        handler.beforeDelete(ci13);
        handler.afterInsert(ci12);
        handler.afterUpdate(ci10,ci11);
        handler.afterDelete(ci9);
        handler.andFinally();
        handler.bulkBefore();
        //handler.bulkAfter();
        Test.stopTest(); 
        
    }
}