@isTest
public class BFM_TriggerFactory_Test {
    private static testMethod void bfm_TriggerTestMethod(){
        Test.startTest();       
        Account acc = new Account();
        acc.Name ='TestAccount';
        insert acc;
        
        BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Carrier_Account__c = acc.Id;
        ship.Shipment_Number__c = '11111';
        insert ship;
        ship.Company_Code__c = '333';
        update ship;

        BFM_Occurrence__c occ = new BFM_Occurrence__c();
        occ.Carrier_Account__c = acc.Id;
        insert occ;
        occ.Plant__c = '22';
        update occ;
        
        BFM_UserCreationRequest__c uc = new BFM_UserCreationRequest__c();
        uc.CNPJ__c = '122222';
        insert uc;
        uc.CNPJ__c = '3333';
        update uc;
        BFM_NF_e__c nfe = new BFM_NF_e__c();
        nfe.NF_e_access_key__c = '3322234';
        insert nfe;
        nfe.NF_e_access_key__c = '3343';
        update nfe;        
        Test.stopTest();
    }
}