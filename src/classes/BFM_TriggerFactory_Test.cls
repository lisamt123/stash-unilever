@isTest
public class BFM_TriggerFactory_Test {
    private static testMethod void bfm_cceTestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount';
        insert acc;
        BFM_CC_e__c cce = new BFM_CC_e__c();
        cce.Carrier__c = acc.Id;
        insert cce;
        BFM_TriggerFactory.createHandler(BFM_CC_e__c.sObjectType);
    }
    private static testMethod void bfm_cceUpdateTestMethod(){
        BFM_CC_e__c cce = [select id,CC_e_Key__c from BFM_CC_e__c limit 1 ];
        cce.CC_e_Key__c = '33432233';
        update cce;
        BFM_TriggerFactory.createHandler(BFM_CC_e__c.sObjectType);
    }
    
    private static testMethod void bfm_cteTestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount1';
        insert acc;
        BFM_CT_e__c cte = new BFM_CT_e__c();
        cte.Carrier_Account__c = acc.Id;
        cte.CT_e_key__c = '123456789';
        insert cte;
        BFM_TriggerFactory.createHandler(BFM_CT_e__c.sObjectType);
    }
    private static testMethod void bfm_cteUpdateTestMethod(){
        BFM_CT_e__c cte = [select id,CT_e_key__c from BFM_CT_e__c limit 1 ];
        cte.CT_e_key__c = '33432233';
        update cte;
        BFM_TriggerFactory.createHandler(BFM_CT_e__c.sObjectType);
    }
    private static testMethod void bfm_mdfeTestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount2';
        insert acc;
        BFM_MDF_e__c mdfe = new BFM_MDF_e__c();
        mdfe.Carrier_Account__c = acc.Id;
        mdfe.CT_e_Access_Key__c = '12123456789';
        insert mdfe;
        BFM_TriggerFactory.createHandler(BFM_MDF_e__c.sObjectType);
    }
     private static testMethod void bfm_NfsTestMethod(){
        BFM_NFS__c nfs = new BFM_NFS__c();
        nfs.NFS_Number__c = '237384748';
        insert nfs;
        BFM_TriggerFactory.createHandler(BFM_NFS__c.sObjectType);
    }
    private static testMethod void bfm_dnTestMethod(){
        Account acc = new Account();
        acc.Name = 'TestAccount2';
        insert acc;
        BFM_Debit_Note__c dn = new BFM_Debit_Note__c();
        dn.Carrier_Account__c = acc.id;
        insert dn;
        BFM_TriggerFactory.createHandler(BFM_Debit_Note__c.sObjectType);
    }
}