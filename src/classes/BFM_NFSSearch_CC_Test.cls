@isTest
private class BFM_NFSSearch_CC_Test{   
    private static testMethod void testBFM_NFSSearch_CC(){
       Test.startTest();
       list<BFM_NFS__c>nfslst=new list<BFM_NFS__c>();

BFM_NFS__c nfs=new BFM_NFS__c();
//nfs.Name='test';
nfs.NFS_Number__c='1234';
nfs.NFS_Series__c='123';
//nfs.Shipment__c=ship.id;
nfs.NFS_Emission_Date_Time__c=datetime.newInstance(2016, 9, 15, 12, 30, 0);
nfs.Vendor_s_CNPJ_or_CPF__c='12345678900000';
//nfs.Service_Taker_Company_UF__c='12';
nfs.Service_Taker_CNPJ__c='12345678900000';
nfs.NFS_Link_Check_Status__c='Link Ok';
//nfs.Service_Taker_Company_UF__c='12';
nfs.Vendor_s_CNPJ_or_CPF__c='11';
nfs.NFS_Link_Check_Status__c='Pending link';
//insert nfs;
nfslst.add(nfs);

 insert nfslst; 
 
        BFM_NFSSearch_CC nfssearch=new BFM_NFSSearch_CC();
        nfssearch.nfs=nfs;
        nfssearch.searchnfs();
        nfssearch.searchnfsrec();
        nfssearch.FirstPage();
        nfssearch.getprev();
        nfssearch.getnxt();
       // nfssearch.previous();
        nfssearch.next();
        nfssearch.LastPage();
       Test.stopTest();
    }
    }