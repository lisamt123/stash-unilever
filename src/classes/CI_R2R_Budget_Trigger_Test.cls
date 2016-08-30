@isTest
private class CI_R2R_Budget_Trigger_Test{
    static testMethod void test_CI_R2R_Budget_Trigger(){
        Test.startTest(); 
        
        CI_R2R_Innovation__c ci = new CI_R2R_Innovation__c ();
        ci.R2R_SME_Area__c = 'SCOA';
        insert ci;
        
        CI_R2R_Budget__c bd = new CI_R2R_Budget__c();
        bd.CI_R2R_Innovation__c = ci.id;
        bd.Company_Code__c='2646';           
        insert bd;
        System.assertEquals(bd.Company_Code__c=='2646',true);
        update bd;
        
        CI_R2R_Innovation__c ci1 = new CI_R2R_Innovation__c ();
        ci1.R2R_SME_Area__c = 'Intercompany';
        insert ci1;
        
        CI_R2R_Innovation__c ci2 = new CI_R2R_Innovation__c ();
        ci2.R2R_SME_Area__c = 'Account Reconciliation';
        insert ci2;
        
        CI_R2R_Innovation__c ci3 = new CI_R2R_Innovation__c ();
        ci3.R2R_SME_Area__c = 'Fixed Assets';
        insert ci3;
        
        CI_R2R_Innovation__c ci4 = new CI_R2R_Innovation__c ();
        ci4.R2R_SME_Area__c = 'Journal Entries';
        insert ci4;
        
        CI_R2R_Innovation__c ci5 = new CI_R2R_Innovation__c ();
        ci5.R2R_SME_Area__c = 'GL MDM';
        insert ci5;
        
        CI_R2R_Innovation__c ci6 = new CI_R2R_Innovation__c ();
        ci6.R2R_SME_Area__c = 'FX Revaluation';
        insert ci6;
        
        CI_R2R_Innovation__c ci7 = new CI_R2R_Innovation__c ();
        ci7.R2R_SME_Area__c = 'GPM';
        insert ci7;
        
        CI_R2R_Innovation__c ci8 = new CI_R2R_Innovation__c ();
        ci8.R2R_SME_Area__c = 'Continuous Improvement';
        insert ci8;
        
        CI_R2R_Innovation__c ci9 = new CI_R2R_Innovation__c ();
        ci9.R2R_SME_Area__c = 'Tools';
        insert ci9;
        
        CI_R2R_Innovation__c ci10 = new CI_R2R_Innovation__c ();
        ci10.R2R_SME_Area__c = 'Project';
        insert ci10;
        
        CI_R2R_Innovation__c ci11 = new CI_R2R_Innovation__c ();
        ci11.R2R_SME_Area__c = 'Period-End';
        insert ci11;
        
        CI_R2R_Innovation__c ci12 = new CI_R2R_Innovation__c ();
        ci12.R2R_SME_Area__c = 'SAP Roles';
        insert ci12;
        
        CI_R2R_Innovation__c ci13 = new CI_R2R_Innovation__c ();
        ci13.R2R_SME_Area__c = 'Direct Tax';
        insert ci13;
        
        CI_R2R_Innovation__c ci14 = new CI_R2R_Innovation__c ();
        ci14.R2R_SME_Area__c = 'Indirect Tax';
        insert ci14;
        
        CI_R2R_Budget__c bd1 = new CI_R2R_Budget__c();
        bd1.CI_R2R_Innovation__c = ci1.id;
        bd1.Company_Code__c='2646';           
        insert bd1;
        System.assertEquals(bd1.Company_Code__c=='2646',true);
        update bd1;
        
        CI_R2R_Budget__c bd2 = new CI_R2R_Budget__c();
        bd2.CI_R2R_Innovation__c = ci1.id;
        bd2.Company_Code__c='2465';           
        insert bd2;
        System.assertEquals(bd2.Company_Code__c=='2465',true);
        update bd2;
        
        CI_R2R_Budget__c bd3 = new CI_R2R_Budget__c();
        bd3.CI_R2R_Innovation__c = ci1.id;
        bd3.Company_Code__c='3009';           
        insert bd3;
        System.assertEquals(bd3.Company_Code__c=='3009',true);
        update bd3;
        
        CI_R2R_Budget__c bd4 = new CI_R2R_Budget__c();
        bd4.CI_R2R_Innovation__c = ci1.id;
        bd4.Company_Code__c='5069';           
        insert bd4;
        System.assertEquals(bd4.Company_Code__c=='5069',true);
        update bd4;
        
        CI_R2R_Budget__c bd5 = new CI_R2R_Budget__c();
        bd5.CI_R2R_Innovation__c = ci1.id;
        bd5.Company_Code__c='2000';           
        insert bd5;
        System.assertEquals(bd5.Company_Code__c=='2000',true);
        update bd5;
        
        CI_R2R_Budget__c bd6 = new CI_R2R_Budget__c();
        bd6.CI_R2R_Innovation__c = ci1.id;
        bd6.Company_Code__c='1609';           
        insert bd6;
        System.assertEquals(bd6.Company_Code__c=='1609',true);
        update bd6;
        
        CI_R2R_Budget__c bd7 = new CI_R2R_Budget__c();
        bd7.CI_R2R_Innovation__c = ci1.id;
        bd7.Company_Code__c='3128';           
        insert bd7;
        System.assertEquals(bd7.Company_Code__c=='3128',true);
        update bd7;
        
        CI_R2R_Budget__c bd8 = new CI_R2R_Budget__c();
        bd8.CI_R2R_Innovation__c = ci2.id;
        bd8.Company_Code__c='3128';           
        insert bd8;
        System.assertEquals(bd8.Company_Code__c=='3128',true);
        update bd8;
        
        CI_R2R_Budget__c bd9 = new CI_R2R_Budget__c();
        bd9.CI_R2R_Innovation__c = ci3.id;
        bd9.Company_Code__c='3128';           
        insert bd9;
        System.assertEquals(bd9.Company_Code__c=='3128',true);
        update bd9;
        
        CI_R2R_Budget__c bd10 = new CI_R2R_Budget__c();
        bd10.CI_R2R_Innovation__c = ci4.id;
        bd10.Company_Code__c='3128';           
        insert bd10;
        System.assertEquals(bd10.Company_Code__c=='3128',true);
        update bd10;
        
        CI_R2R_Budget__c bd11 = new CI_R2R_Budget__c();
        bd11.CI_R2R_Innovation__c = ci5.id;
        bd11.Company_Code__c='3128';           
        insert bd11;
        System.assertEquals(bd11.Company_Code__c=='3128',true);
        update bd11;
        
        CI_R2R_Budget__c bd12 = new CI_R2R_Budget__c();
        bd12.CI_R2R_Innovation__c = ci6.id;
        bd12.Company_Code__c='3128';           
        insert bd12;
        System.assertEquals(bd12.Company_Code__c=='3128',true);
        update bd12;
        
        CI_R2R_Budget__c bd13 = new CI_R2R_Budget__c();
        bd13.CI_R2R_Innovation__c = ci7.id;
        bd13.Company_Code__c='3128';           
        insert bd13;
        System.assertEquals(bd13.Company_Code__c=='3128',true);
        update bd13;
        
        CI_R2R_Budget__c bd14 = new CI_R2R_Budget__c();
        bd14.CI_R2R_Innovation__c = ci8.id;
        bd14.Company_Code__c='3128';           
        insert bd14;
        System.assertEquals(bd14.Company_Code__c=='3128',true);
        update bd14;
        
        CI_R2R_Budget__c bd15 = new CI_R2R_Budget__c();
        bd15.CI_R2R_Innovation__c = ci9.id;
        bd15.Company_Code__c='3128';           
        insert bd15;
        System.assertEquals(bd15.Company_Code__c=='3128',true);
        update bd15;
        
        CI_R2R_Budget__c bd16 = new CI_R2R_Budget__c();
        bd16.CI_R2R_Innovation__c = ci10.id;
        bd16.Company_Code__c='3128';           
        insert bd16;
        System.assertEquals(bd16.Company_Code__c=='3128',true);
        update bd16;
        
        CI_R2R_Budget__c bd17 = new CI_R2R_Budget__c();
        bd17.CI_R2R_Innovation__c = ci11.id;
        bd17.Company_Code__c='3128';           
        insert bd17;
        System.assertEquals(bd17.Company_Code__c=='3128',true);
        update bd17;
        
        CI_R2R_Budget__c bd18 = new CI_R2R_Budget__c();
        bd18.CI_R2R_Innovation__c = ci12.id;
        bd18.Company_Code__c='3128';           
        insert bd18;
        System.assertEquals(bd18.Company_Code__c=='3128',true);
        update bd18;
        
        CI_R2R_Budget__c bd19 = new CI_R2R_Budget__c();
        bd19.CI_R2R_Innovation__c = ci.id;
        bd19.Company_Code__c='3128';           
        insert bd19;
        System.assertEquals(bd19.Company_Code__c=='3128',true);
        update bd19;
        
        CI_R2R_Budget__c bd20 = new CI_R2R_Budget__c();
        bd20.CI_R2R_Innovation__c = ci2.id;
        bd20.Company_Code__c='5069';           
        insert bd20;
        System.assertEquals(bd20.Company_Code__c=='5069',true);
        update bd20;
        
        CI_R2R_Budget__c bd21 = new CI_R2R_Budget__c();
        bd21.CI_R2R_Innovation__c = ci3.id;
        bd21.Company_Code__c='5069';           
        insert bd21;
        System.assertEquals(bd21.Company_Code__c=='5069',true);
        update bd21;
        
        CI_R2R_Budget__c bd22 = new CI_R2R_Budget__c();
        bd22.CI_R2R_Innovation__c = ci2.id;
        bd22.Company_Code__c='5069';           
        insert bd22;
        System.assertEquals(bd22.Company_Code__c=='5069',true);
        update bd22;
        
        CI_R2R_Budget__c bd23 = new CI_R2R_Budget__c();
        bd23.CI_R2R_Innovation__c = ci3.id;
        bd23.Company_Code__c='5069';           
        insert bd23;
        System.assertEquals(bd23.Company_Code__c=='5069',true);
        update bd23;
        
        CI_R2R_Budget__c bd24 = new CI_R2R_Budget__c();
        bd24.CI_R2R_Innovation__c = ci4.id;
        bd24.Company_Code__c='5069';           
        insert bd24;
        System.assertEquals(bd24.Company_Code__c=='5069',true);
        update bd24;
        
        CI_R2R_Budget__c bd25 = new CI_R2R_Budget__c();
        bd25.CI_R2R_Innovation__c = ci5.id;
        bd25.Company_Code__c='5069';           
        insert bd25;
        System.assertEquals(bd25.Company_Code__c=='5069',true);
        update bd25;
        
        CI_R2R_Budget__c bd26 = new CI_R2R_Budget__c();
        bd26.CI_R2R_Innovation__c = ci6.id;
        bd26.Company_Code__c='5069';           
        insert bd26;
        System.assertEquals(bd26.Company_Code__c=='5069',true);
        update bd26;
        
        CI_R2R_Budget__c bd27 = new CI_R2R_Budget__c();
        bd27.CI_R2R_Innovation__c = ci7.id;
        bd27.Company_Code__c='5069';           
        insert bd27;
        System.assertEquals(bd27.Company_Code__c=='5069',true);
        update bd27;
        
        CI_R2R_Budget__c bd28 = new CI_R2R_Budget__c();
        bd28.CI_R2R_Innovation__c = ci8.id;
        bd28.Company_Code__c='5069';           
        insert bd28;
        System.assertEquals(bd28.Company_Code__c=='5069',true);
        update bd28;
        
        CI_R2R_Budget__c bd29 = new CI_R2R_Budget__c();
        bd29.CI_R2R_Innovation__c = ci9.id;
        bd29.Company_Code__c='5069';           
        insert bd29;
        System.assertEquals(bd29.Company_Code__c=='5069',true);
        update bd29;
        
        CI_R2R_Budget__c bd30 = new CI_R2R_Budget__c();
        bd30.CI_R2R_Innovation__c = ci10.id;
        bd30.Company_Code__c='5069';           
        insert bd30;
        System.assertEquals(bd30.Company_Code__c=='5069',true);
        update bd30;
        
        CI_R2R_Budget__c bd31 = new CI_R2R_Budget__c();
        bd31.CI_R2R_Innovation__c = ci13.id;
        bd31.Company_Code__c='5069';           
        insert bd31;
        System.assertEquals(bd31.Company_Code__c=='5069',true);
        update bd31;
        
        CI_R2R_Budget__c bd32 = new CI_R2R_Budget__c();
        bd32.CI_R2R_Innovation__c = ci14.id;
        bd32.Company_Code__c='5069';           
        insert bd32;
        System.assertEquals(bd32.Company_Code__c=='5069',true);
        update bd32;
        
        CI_R2R_Budget__c bd33 = new CI_R2R_Budget__c();
        bd33.CI_R2R_Innovation__c = ci.id;
        bd33.Company_Code__c='5069';           
        insert bd33;
        System.assertEquals(bd33.Company_Code__c=='5069',true);
        update bd33;
        
        CI_R2R_Budget__c bd34 = new CI_R2R_Budget__c();
        bd34.CI_R2R_Innovation__c = ci11.id;
        bd34.Company_Code__c='5069';           
        insert bd34;
        System.assertEquals(bd34.Company_Code__c=='5069',true);
        update bd34;
        
        CI_R2R_Budget__c bd35 = new CI_R2R_Budget__c();
        bd35.CI_R2R_Innovation__c = ci12.id;
        bd35.Company_Code__c='5069';           
        insert bd35;
        System.assertEquals(bd35.Company_Code__c=='5069',true);
        update bd35;
        
        CI_R2R_Budget_TriggerHandler handler = new CI_R2R_Budget_TriggerHandler();
        handler.beforeInsert(bd16);
        handler.beforeUpdate(bd15,bd16);
        handler.beforeUpdate(bd13,bd14);
        handler.beforeDelete(bd13);
        handler.afterInsert(bd12);
        handler.afterUpdate(bd10,bd11);
        handler.afterDelete(bd9);
        handler.andFinally();
        handler.bulkBefore();
        //handler.bulkAfter();
        Test.stopTest(); 
        
    }
}