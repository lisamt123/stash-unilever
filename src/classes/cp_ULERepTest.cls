@isTest
private class cp_ULERepTest {
    
    @isTest static void test1() {
        cp_Event__c evt = cp_TestData.getTestPlannerEvent();
        insert evt;
        
        cp_ULE_Contact__c c = new cp_ULE_Contact__c();
        c.Name = 'teteet';
        c.Active_ULE__c = true;
        insert c;
        
        cp_ULE__c ule = new cp_ULE__c();
        ule.Event__c = evt.Id;
        ule.UnileverLeadershipExecutive__c = c.Id;
        insert ule;
        
        Test.startTest();
        evt = [SELECT Unilever_Speaker_Representative__c FROM cp_Event__c WHERE Id =: evt.Id];
        //System.assertEquals(evt.Unilever_Speaker_Representative__c, 'teteet');    
        Test.stopTest();
    }
    
}