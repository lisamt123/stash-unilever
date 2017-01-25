@isTest
public class BFM_TriggerFactory_Test {
    static testMethod void bfm_TriggerTestMethod(){
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
        delete ship;

        BFM_Occurrence__c occ = new BFM_Occurrence__c();
        occ.Carrier_Account__c = acc.Id;
        insert occ;
        occ.Plant__c = '22';
        update occ;
        delete occ;
        
        BFM_NF_e__c nfe = new BFM_NF_e__c();
        nfe.NF_e_access_key__c = '346457658765432421421432543';
        insert nfe;
        nfe.NF_e_access_key__c = '12345434543';
        update nfe;
        delete nfe;
        
        BFM_UserCreationRequest__c uc = new BFM_UserCreationRequest__c();
        uc.CNPJ__c = '122222';
        insert uc;
        uc.CNPJ__c = '3333';
        update uc;
        delete uc;
        
    BFM_TriggerFactory bfmtf = new BFM_TriggerFactory();
        BFM_TriggerFactory.getHandler(BFM_UserCreationRequest__c.sObjectType);        
        BFM_TriggerFactory.getHandler(BFM_Shipment__c.sObjectType);
        BFM_TriggerFactory.getHandler(BFM_Occurrence__c.sObjectType);
        BFM_TriggerFactory.getHandler(BFM_NF_e__c.sObjectType);
        ITrigger iTriggerMacro = BFM_TriggerFactory.getHandler(BFM_Company_Code__c.sObjectType);
        System.assertEquals(null, iTriggerMacro);
        try {
            BFM_TriggerFactory.createHandler(BFM_Company_Code__c.sObjectType);            
        } catch (Exception e) {
            System.assertEquals('No Trigger Handler registered for Object Type: BFM_Company_Code__c',e.getMessage(),'We should not find a trigger handler for the Companycode object');
        } 
        Test.stopTest();
    }   
}