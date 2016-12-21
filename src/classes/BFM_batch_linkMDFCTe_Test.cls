@isTest
public class BFM_batch_linkMDFCTe_Test {   
    static testMethod void testControllerWithMDFECTE(){
        Test.startTest();
        Database.QueryLocator QL;
        Database.BatchableContext BC;
        list<BFM_MDF_e__c> mdflst=new list<BFM_MDF_e__c>();
        list<BFM_CT_e__c> ctelst=new list<BFM_CT_e__c>(); 
        BFM_batch_linkMDFCTe link = new BFM_batch_linkMDFCTe();
        QL = link.start(bc);
        Account acc= new Account();
        acc.name = 'testname';
        insert acc;
        system.assertEquals('testname', acc.name);
        
        BFM_MDF_e__c mdf = new BFM_MDF_e__c();
        mdf.CT_e_Access_Key__c  = 'key';
        mdf.Carrier_Account__c = acc.id;
        insert mdf;
        system.assertEquals('key', mdf.CT_e_Access_Key__c);
        
        BFM_CT_e__c ct = new BFM_CT_e__c();
        ct.CT_e_Number__c = 'ctnumber';
        ct.CT_e_key__c = '1234567890000';
        ct.MDF_e__c = mdf.id;
        ct.Is_Duplicated__c = true;
        ct.Is_CNPJ_Invalid__c = true;
        insert ct;
        system.assertEquals('ctnumber', ct.CT_e_Number__c);
        
        Database.QueryLocatorIterator QIT =  QL.iterator();
        while(QIT.hasNext()){
            BFM_CT_e__c cte = (BFM_CT_e__c)QIT.next();
            ctelst.add(cte);
        }
        link.execute(bc,mdflst);
        link.finish(bc);    
        Test.stopTest();
    }
}