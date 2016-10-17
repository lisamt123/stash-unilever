@isTest
private class BFM_CTeHandlerTest{
private static testMethod void testBFM_CTeHandler (){

 Test.startTest();
if(Test.isRunningTest())
{
Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        acc.Region__c='lo';
        insert acc;

BFM_Occurrence__c occ=new BFM_Occurrence__c();
occ.Approval_Date_1__c=date.newInstance(2016,10,30);
insert occ;

list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
BFM_CT_e__c cte=new BFM_CT_e__c();
cte.CT_e_key__c='123456';
cte.Cte_original_Access_Key__c='123';
cte.CNPJ_Service_Taker__c='12345678900000';
cte.CNPJ_issuer__c='12345678900000';
cte.CT_e_Type__c='normal';
cte.CFOP__c='6.932';
cte.Carrier_Account__c=acc.id;
//cte.Cte_Emission_date_time__c=datetime.newInstance(2016, 10, 6, 12, 30, 0);
ctelst.add(cte);
insert ctelst ;

BFM_Shipment__c ship=new BFM_Shipment__c();
ship.Carrier_Account__c=acc.id;
ship.Unilever_Company__c=acc.id;
insert ship;

BFM_Stage__c stg=new BFM_Stage__c();
stg.Shipment__c=ship.id;
insert stg;

BFM_SES__c ses=new BFM_SES__c();
ses.CT_E__c=cte.id;
ses.Stage__c=stg.id;
ses.Occurrence__c=occ.id;
insert ses;

BFM_Tax_Code__c tax = new BFM_Tax_Code__c();
cte.Tax_Code__c=tax.id;
cte.Tax_Code_id__c='uu';
insert cte;

cte.Link_Status__c='Link OK';
cte.CT_e_Compatible__c='adas';
update cte;



BFM_CTeHandler handler=new BFM_CTeHandler();
handler.beforeDelete(cte);
handler.afterDelete(cte);
handler.beforeUpdate(cte, cte);
handler.afterUpdate(cte, cte);
Test.stopTest();

}
}
}