@isTest
private class BFM_companyvendorcheck_Test{
    private static testMethod void testBFM_companyvendorcheck(){
    
    Test.startTest();
    Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        acc.Region__c='lo';
        insert acc;

        list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
        BFM_CT_e__c cte1=new BFM_CT_e__c();
        cte1.CT_e_key__c='123456';
        cte1.Company_Code_Status__c='Company Code Ok';
        cte1.Cte_Status__c='Company Code Ok';
        cte1.Vendor_Code_Status__c='Vendor Ok';
        cte1.Cte_Status__c='Vendor Ok';
        cte1.Cte_original_Access_Key__c='123';
        cte1.CNPJ_Service_Taker__c='12345678900000';
        cte1.CNPJ_issuer__c='12345678900000';
        cte1.CT_e_Type__c='normal';
        cte1.CFOP__c='6.932';
        cte1.Carrier_Account__c=acc.id;
        ctelst.add(cte1);
        
        BFM_CT_e__c cte2=new BFM_CT_e__c();
        cte2.CT_e_key__c='123456';
        cte2.Company_Code_Status__c='Wrong Code Ok';
        cte2.Cte_Status__c='Wrong Code Ok';
        cte2.Vendor_Code_Status__c='Wrong Ok';
        cte2.Cte_Status__c='Wrong Ok';
        cte2.Cte_original_Access_Key__c='123';
        cte2.CNPJ_Service_Taker__c='12345678900000';
        cte2.CNPJ_issuer__c='12345678900000';
        cte2.CT_e_Type__c='normal';
        cte2.CFOP__c='6.932';
        cte2.Carrier_Account__c=acc.id;
        ctelst.add(cte2);
        
        insert ctelst ;
        
        BFM_Shipment__c ship=new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        ship.Unilever_Company__c=acc.id;
        insert ship;
        
        BFM_Stage__c stg=new BFM_Stage__c();
        stg.Shipment__c=ship.id;
        insert stg;
        
        BFM_SES__c ses=new BFM_SES__c();
        ses.CT_E__c=cte1.id;
        ses.CT_E__c=cte2.id;
        ses.Stage__c=stg.id;
        insert ses;
        
        BFM_Occurrence__c occ=new BFM_Occurrence__c();
        occ.Approval_Date_1__c=date.newInstance(2014, 9, 15);
        occ.Shipment__c=ship.id;
        
        //BFM_companyvendorcheck comp=new BFM_companyvendorcheck();
        BFM_companyvendorcheck.companycodeandvendorcheck(ctelst);
        Test.stopTest();
    }
}