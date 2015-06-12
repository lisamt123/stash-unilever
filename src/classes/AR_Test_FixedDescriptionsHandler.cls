@isTest
private class AR_Test_FixedDescriptionsHandler {

    static testMethod void testFixRateCards() {
        Map<String,Id> rts = new Map<String,id>();
        for(RecordType rt : [select developerName, id from RecordType where SobjectType = 'ar_Fixed_Price_Rate_Card__c' and developerName in ('Artwork','Task')]) {
            rts.put(rt.developerName, rt.id);
        }
        
        // to map values from custom settings       
        ar_Fixed_Price_Rate_Card__c rc1 = new ar_Fixed_Price_Rate_Card__c(RecordTypeId = rts.get('Task'));
        ar_Fixed_Price_Rate_Card__c rc2 = new ar_Fixed_Price_Rate_Card__c(RecordTypeId = rts.get('Artwork'));
        
        // custom settings questions    
        AR_Fixed_Rate_Card_Questions__c q1 = TestDataFactory.getFixRateCardQuestion('Design', 'Design', 'Design', 1);
        insert q1;
        AR_Fixed_Rate_Card_Questions__c q2 = TestDataFactory.getFixRateCardQuestion('Design', 'Design', 'Artwork', 2);
        insert q2;
        
        
        Test.startTest();
            // query custom settings
            AR_FixedRateCardHelper res = AR_FixedDescriptionsHandler.getRateCardOptions(rc1, rc2);
        Test.stopTest();
        
        // get object mapped not in map anymore
       /* AR_SObjectHolder h1 = res.get('Design')[0];
        AR_SObjectHolder h2 = res.get('Artwork')[0];
        
        system.assertEquals(q1.name, h1.obj.get('Name'), 'value was not mapped from custom setting');
        system.assertEquals(q2.name, h2.obj.get('Name'), 'value was not mapped from custom setting');*/
    }
    
    static testMethod void testInsuranceSettins() {
        Map<String,Id> rts = new Map<String,id>();
        for(RecordType rt : [select developerName, id from RecordType where SobjectType = 'ar_Insurance_and_Policy__c' and developerName in ('Insurance','Policy')]) {
            rts.put(rt.developerName, rt.id);
        }
        
        // to map values from custom settings       
        ar_Insurance_and_Policy__c i1 = new ar_Insurance_and_Policy__c(RecordTypeId = rts.get('Insurance'));
        
        // custom settings questions    
        AR_Insurance_Policy__c s1 = TestDataFactory.getInsuranceSetting('Insurance 1');
        insert s1;
        
        Test.startTest();
            // query custom settings
            List<AR_SObjectHolder> res = AR_FixedDescriptionsHandler.getInsuranceOptions(i1);
        Test.stopTest();
        
        // get object mapped
        AR_SObjectHolder h1 = res[0];
        
        system.assertEquals(s1.name, h1.obj.get('Insurance_Type__c'), 'value was not mapped from custom setting');
    }
    
    static testMethod void testPolicySettins() {
        Map<String,Id> rts = new Map<String,id>();
        for(RecordType rt : [select developerName, id from RecordType where SobjectType = 'ar_Insurance_and_Policy__c' and developerName in ('Insurance','Policy')]) {
            rts.put(rt.developerName, rt.id);
        }
        
        // to map values from custom settings       
        ar_Insurance_and_Policy__c i1 = new ar_Insurance_and_Policy__c(RecordTypeId = rts.get('Policy'));
        
        // custom settings questions    
        AR_Insurance_Policy__c s1 = TestDataFactory.getPolicySetting('Policy 1');
        insert s1;
        
        Test.startTest();
            // query custom settings
            List<AR_SObjectHolder> res = AR_FixedDescriptionsHandler.getPolicies(i1);
        Test.stopTest();
        
        // get object mapped
        AR_SObjectHolder h1 = res[0];
        
        system.assertEquals(s1.name, h1.obj.get('Policy__c'), 'value was not mapped from custom setting');
    }
}