@isTest
public class BFM_OccurrenceHandler_Test {
	private static testMethod void BFM_OccurrenceHandler_TestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        BFM_Occurrence__c occ=new BFM_Occurrence__c();
        occ.Occurrence_Number__c='212312';
        occ.Carrier_Account__c = acc.id;
        occ.Carrier__c = 'carrier';
        insert occ;
        BFM_OccurrenceHandler occhandler=new BFM_OccurrenceHandler();
        occhandler.beforeInsert(occ);
        occhandler.beforeUpdate(occ, occ);
        occhandler.beforeDelete(occ);
        occhandler.bulkAfter();
        occhandler.bulkBefore();
        occhandler.afterInsert(occ);
        occhandler.afterUpdate(occ, occ);
        occhandler.afterDelete(occ);
        delete occ;
    }
}