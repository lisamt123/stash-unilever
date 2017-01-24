@isTest
private class BFM_NFEHandler_Test {
    private static testMethod void BFM_NFEHandler_TestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccountName';
        insert acc;
        BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Carrier_Account__c = acc.id;
        ship.Shipment_Number__c = '12345';
        insert ship;
        BFM_Stage__c stage = new BFM_Stage__c();
        stage.Shipment__c = ship.Id;
        stage.Total_Gross_Weight__c  =10;
        insert stage;
        BFM_Delivery__c delivery = new BFM_Delivery__c();
        delivery.Delivery_Number__c = '23456';
        delivery.Stage__c = stage.Id;
        insert delivery;
        BFM_NF_e__c nfe = new BFM_NF_e__c();
        nfe.NF_e_access_key__c = '23456789876543';
        nfe.NF_e_number__c = '3456';
        nfe.Gross_weight__c  =10;
        nfe.Delivery__c = delivery.Id;
        insert nfe;
        nfe.NF_e_access_key__c = '23456789876543';
        update nfe;
        BFM_NFEHandler nfehandler = new BFM_NFEHandler();
        nfehandler.beforeDelete(nfe);
        nfehandler.afterDelete(nfe);
		nfehandler.bulkBefore();
        nfehandler.beforeInsert(nfe);
        nfehandler.afterInsert(nfe);
    }
}