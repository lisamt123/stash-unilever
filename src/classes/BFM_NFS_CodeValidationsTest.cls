@isTest
private class BFM_NFS_CodeValidationsTest{

private static testMethod void testNFS_CodeValidations(){
 Test.startTest();
list<BFM_NFS__c>nfslst=new list<BFM_NFS__c>();

BFM_NFS__c nfs=new BFM_NFS__c();
//nfs.Name='test';
nfs.NFS_Number__c='1234';
nfs.NFS_Series__c='123';
nfs.NFS_Emission_Date_Time__c=datetime.newInstance(2016, 9, 15, 12, 30, 0);
nfs.Vendor_s_CNPJ_or_CPF__c='12345678900000';
//nfs.Service_Taker_Company_UF__c='12';
//nfs.Service_Taker_CNPJ__c='12345678900000';
nfs.NFS_Link_Check_Status__c='Link Ok';
//nfs.Service_Taker_Company_UF__c='12';
nfs.Vendor_s_CNPJ_or_CPF__c='11';
//insert nfs;
nfslst.add(nfs);


list<BFM_NFS__c>nfslst1=new list<BFM_NFS__c>();
BFM_NFS__c nfs1=new BFM_NFS__c();
//nfs1.Name='test';
nfs1.NFS_Number__c='1234';
nfs1.NFS_Series__c='123';
nfs1.NFS_Emission_Date_Time__c=datetime.newInstance(2016, 16, 15, 12, 30, 0);
nfs1.Vendor_s_CNPJ_or_CPF__c='10';
//nfs1.Service_Taker_Company_UF__c='13';
nfs1.Service_Taker_CNPJ__c='12345678900000';
//nfs1.NFS_Link_Check_Status__c='Link Ok';
//insert nfs;
nfslst1.add(nfs1);


        insert nfslst; 
        system.assertEquals('1234',nfs.NFS_Number__c);
         insert nfslst1; 
         system.debug('nfs1 id is'+nfs.id);
         
     update nfslst1;
     system.assertEquals('1234',nfs1.NFS_Number__c);
    // delete nfslst1;
    system.debug('nfs1 id is'+nfs1.id);
    
     Account acc = BFM_TestUtils.createCarrierAccount();
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        acc.Region__c='lo';
        insert acc;
        
        BFM_Shipment__c ship=new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        //ship.Unilever_Company__c=acc.id;
        insert ship;
        
        BFM_Stage__c stg=new BFM_Stage__c();
        stg.Shipment__c=ship.id;
        stg.Unilever_Account__c = acc.Id;
        insert stg;


 

list<BFM_SES__c> seslst=new list<BFM_SES__c>();

BFM_SES__c ses=new BFM_SES__c();
ses.NFS__c=nfs.id;
ses.Stage__c=stg.id;
//ses.Vendor_Code__c='11';
seslst.add(ses);

BFM_SES__c ses1=new BFM_SES__c();
ses1.NFS__c=nfs1.id;
ses1.Stage__c=stg.id;
//ses.Vendor_Code__c='11';

insert seslst ;
system.assertEquals(nfs.id,ses.NFS__c);


list<BFM_SES__c> seslst1=new list<BFM_SES__c>();
seslst1.add(ses1);
//BFM_NFSHandler nfshandler=new BFM_NFSHandler();

BFM_NFS_CodeValidations nfscodeval=new BFM_NFS_CodeValidations();


insert seslst1 ;

update seslst1 ;
system.assertEquals(nfs1.id,ses1.NFS__c);
//delete seslst1 ;
//BFM_NFS_CodeValidations.nfsCheck(nfslst);
//BFM_NFS_CodeValidations.nfsCheck(nfslst1);


Test.stopTest();



}
}