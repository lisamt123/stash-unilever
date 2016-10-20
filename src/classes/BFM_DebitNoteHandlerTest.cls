@isTest
private class BFM_DebitNoteHandlerTest {
private static testMethod void testDebitNoteHandler(){
 Test.startTest();
 list<BFM_Debit_Note__c>DBlist=new list<BFM_Debit_Note__c>();
 
  Account acc = new Account();
  acc.name='carrier';
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        insert acc;
        
  BFM_Shipment__c ship=new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        
        insert ship;
 
 BFM_Occurrence__c occ=new BFM_Occurrence__c();
 occ.Name='test';
 occ.Approval_Date_1__c=date.newInstance(2016, 9, 15);
 occ.Shipment__c=ship.id;
 insert occ;
 
         
        
        BFM_Stage__c stg=new BFM_Stage__c();
        stg.Shipment__c=ship.id;
        insert stg;
        
        
        
        BFM_SES__c ses=new BFM_SES__c();
        ses.Occurrence__c=occ.id;
        ses.Stage__c=stg.id;
       insert ses;
 
 BFM_Debit_Note__c db=new BFM_Debit_Note__c();
 db.DN_Number__c='123355';
 db.DN_Emission_date_time__c=datetime.newInstance(2016, 9, 20, 12, 30, 0);
 db.Vendor_s_CNPJ_or_CPF__c='12345678900000';
 db.Service_Taker_CNPJ__c='12345678900000';
 db.Vendor_Code__c='11';
 db.Company_Code__c='12';
 db.Unilever_Account__c=acc.id;
 db.Carrier_Account__c=acc.id;
 db.Occurrence__c=occ.id;
 DBlist.add(db);
 insert DBlist;
 
   system.assertEquals('123355', db.DN_Number__c);
 list<BFM_Debit_Note__c>DBlist1=new list<BFM_Debit_Note__c>();
 
 BFM_Debit_Note__c db1=new BFM_Debit_Note__c();
 db1.DN_Number__c='123355';
 db1.DN_Emission_date_time__c=datetime.newInstance(2016, 9, 19, 12, 30, 0);
 db1.Vendor_s_CNPJ_or_CPF__c='12345678909';
 db1.Service_Taker_CNPJ__c='12345678909';
 db1.Vendor_Code__c='13';
 db1.Company_Code__c='16';
 db1.Unilever_Account__c=acc.id;
 db1.Carrier_Account__c=acc.id;
 db1.Occurrence__c=occ.id;
 DBlist1.add(db1);
 insert DBlist1;
 update DBlist1;
 
 /*Account acc1 = BFM_TestUtils.createCarrierAccount();
        acc1.cnpj__c = '03189042000100';
        acc1.Vendor__c='18';
        acc1.Company_Code__c='19';
        insert acc1;
        
          BFM_Shipment__c ship1=new BFM_Shipment__c();
        ship1.Carrier_Account__c=acc1.id;
        insert ship1;
        
        BFM_Stage__c stg1=new BFM_Stage__c();
        stg1.Shipment__c=ship1.id;
        insert stg1;
        
        BFM_Occurrence__c occ1=new BFM_Occurrence__c();
 occ1.Name='test';
 occ1.Approval_Date_1__c=date.newInstance(2016, 45, 70);
 insert occ1;
        
        BFM_SES__c ses1=new BFM_SES__c();
        ses.Occurrence__c=occ1.id;
        ses.Stage__c=stg1.id;
       insert ses1;*/
 
 
 
 
 BFM_DebitNoteHandler DN=new BFM_DebitNoteHandler();
 DN.bulkAfter();
 DN.beforeDelete(db1);
 DN.afterDelete(db1);
 DN.afterInsert(db1);
 DN.afterUpdate(db1, db1);
 
Test.stopTest();
}
}