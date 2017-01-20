@isTest
public class BFM_TriggerFactory_Test {
    private static testMethod void bfm_TriggerTestMethod(){
        Test.startTest();
        BFM_IVA__c iva = new BFM_IVA__c();
        iva.Tax_Amount__c = 100;
        iva.Tax_Base__c = 200;
        insert iva;
        //Schema.sObjectType tokenA = iva.getSObjectType();
        //BFM_TriggerFactory.createHandler(tokenA);
        Account acc = new Account();
        acc.Name ='TestAccount';
        insert acc;
        BFM_Shipment__c ship = new BFM_Shipment__c();
        ship.Carrier_Account__c = acc.Id;
        ship.Shipment_Number__c = '11111';
        insert ship;
        ship.Company_Code__c = '333';
        update ship;
        
        /*BFM_CC_e__c cce = new BFM_CC_e__c();
        cce.CC_e_Key__c = '1234567';
        insert cce;
        
        BFM_MDF_e__c mdfe = new BFM_MDF_e__c();
        mdfe.Carrier_Account__c = acc.id;
        insert mdfe;
        mdfe.Company_Code__c = '33';
        update mdfe;
        
        BFM_NFS__c nfs = new BFM_NFS__c();
        nfs.Carrier__c = acc.Id;
        insert nfs;*/
        
        BFM_Occurrence__c occ = new BFM_Occurrence__c();
        occ.Carrier_Account__c = acc.Id;
        insert occ;
        occ.Plant__c = '22';
        update occ;
        
        /*BFM_Debit_Note__c dn = new BFM_Debit_Note__c();
        dn.Carrier_Account__c = acc.id;
        dn.Occurrence__c = occ.id;
        insert dn;
        
        BFM_POD__c pod = new BFM_POD__c();
        pod.Carrier_Account__c = acc.id;
        insert pod;
         */
        BFM_UserCreationRequest__c uc = new BFM_UserCreationRequest__c();
        uc.CNPJ__c = '122222';
        insert uc;
        uc.CNPJ__c = '3333';
        update uc;
        BFM_NF_e__c nfe = new BFM_NF_e__c();
        nfe.NF_e_access_key__c = '3322234';
        insert nfe;
        
        /*BFM_MIRO_Header__c miro = new BFM_MIRO_Header__c();
        miro.Access_Key__c = '33232';
        insert miro;
        miro.Access_Key__c = '434344';
        update miro;
        */
        Test.stopTest();
    }
}