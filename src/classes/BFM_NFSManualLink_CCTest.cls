@isTest
private class BFM_NFSManualLink_CCTest{
private static testMethod void testBFM_NFSManualLink_CC(){
 Test.startTest();
 
  Account acc =new Account();
  acc.name='carrier';
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        insert acc;
        
        BFM_Shipment__c ship=new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        insert ship;
        
         BFM_Stage__c stg=new BFM_Stage__c();
        stg.Shipment__c=ship.id;
        insert stg;

        
        
 list<BFM_NFS__c>nfslst=new list<BFM_NFS__c>();

BFM_NFS__c nfs=new BFM_NFS__c();
//nfs.Name='test';
nfs.NFS_Number__c='1234';
nfs.NFS_Series__c='123';
nfs.Shipment__c=ship.id;
nfs.NFS_Emission_Date_Time__c=datetime.newInstance(2016, 9, 15, 12, 30, 0);
nfs.Vendor_s_CNPJ_or_CPF__c='12345678900000';
//nfs.Service_Taker_Company_UF__c='12';
nfs.Service_Taker_CNPJ__c='12345678900000';
nfs.NFS_Link_Check_Status__c='Link Ok';
//nfs.Service_Taker_Company_UF__c='12';
nfs.Vendor_s_CNPJ_or_CPF__c='11';
nfs.NFS_Link_Check_Status__c='Pending link';
nfs.Carrier__c=acc.id;
//insert nfs;
nfslst.add(nfs);

 insert nfslst; 
        system.assertEquals('1234',nfs.NFS_Number__c);
        
         


 
BFM_NFS__c nfs1=new BFM_NFS__c();
//nfs.Name='test';
nfs1.NFS_Number__c='1234';
nfs1.NFS_Series__c='123';
nfs1.Shipment__c=ship.id;
nfs1.NFS_Emission_Date_Time__c=datetime.newInstance(2016, 9, 15, 12, 30, 0);
nfs1.Vendor_s_CNPJ_or_CPF__c='12345678900000';
//nfs.Service_Taker_Company_UF__c='12';
nfs1.Service_Taker_CNPJ__c='12345678900000';
nfs1.NFS_Link_Check_Status__c='Link Ok';
//nfs.Service_Taker_Company_UF__c='12';
nfs1.Vendor_s_CNPJ_or_CPF__c='11';
nfs1.NFS_Link_Check_Status__c='Pending link';
nfs1.Carrier__c=acc.id;
insert nfs1;
//nfslst.add(nfs);
list<BFM_SES__c> seslst=new list<BFM_SES__c>();

BFM_SES__c ses=new BFM_SES__c();
//ses.NFS__c=nfs.id;
ses.Stage__c=stg.id;
//ses.Vendor_Code__c='11';
seslst.add(ses);

BFM_SES__c ses1=new BFM_SES__c();
ses1.NFS__c=nfs1.id;
ses1.Stage__c=stg.id;
//ses1.Vendor_Code__c='11';
insert ses1;

insert seslst ;
//system.assertEquals(nfs.id,ses.NFS__c);
BFM_NFSManualLink_CC nfsmanual=new BFM_NFSManualLink_CC();
nfsmanual.linkNFS_SES();
 Test.stopTest();
 }
 }