@isTest
private class BFM_PODHandlerTest{
private static testMethod void testNFSHandler(){
 Test.startTest();
 list<BFM_POD__c>podlst=new list<BFM_POD__c>();
BFM_POD__c pod=new BFM_POD__c();
//pod.NF_e_Access_Key__c
//pod.NF_e_Number__c
pod.POD_Date__c=Date.newInstance(2016 , 9,20);
podlst.add(pod);
insert podlst;


        Account acc = BFM_TestUtils.createCarrierAccount();
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
    nfs.NFS_Emission_Date_Time__c=datetime.newInstance(2016, 9, 15, 12, 30, 0);
    nfs.Vendor_s_CNPJ_or_CPF__c='12345678900000';
   // nfs.Service_Taker_Company_UF__c='12';
    nfs.Service_Taker_CNPJ__c='12345678900000';
    nfs.NFS_Link_Check_Status__c='Link Ok';
   // nfs.Service_Taker_Company_UF__c='12';
    nfs.Vendor_s_CNPJ_or_CPF__c='11';
    //insert nfs;
    nfslst.add(nfs);
    
     insert nfslst; 
        system.assertEquals('1234',nfs.NFS_Number__c);
 
     BFM_Delivery__c del=new BFM_Delivery__c();
     del.Name='Dev-00001';
     del.Stage__c=stg.id;
     insert del;

    list<BFM_SES__c> seslst=new list<BFM_SES__c>();
    
    BFM_SES__c ses=new BFM_SES__c();
    ses.NFS__c=nfs.id;
    ses.Stage__c=stg.id;
    //ses.Vendor_Code__c='11';
    seslst.add(ses);
    
    BFM_SES__c ses1=new BFM_SES__c();
    ses1.NFS__c=nfs.id;
    ses1.Stage__c=stg.id;
    //ses.Vendor_Code__c='11';
    
    insert seslst ;
    system.assertEquals(nfs.id,ses.NFS__c);
    
    
        BFM_NF_e__c nfe=new BFM_NF_e__c();
        nfe.NF_e_access_key__c='1234567890';
        nfe.Taker_CNPJ__c='12345678900000';
        nfe.Taker_Name__c=acc.id;
        nfe.SES__c=ses.id;
        nfe.NFS__c=nfs.id;
        nfe.Delivery__c=del.id;
        
        insert nfe;
        
        pod.NF_e__c=nfe.id;
        update pod;
        
        BFM_PODHandler podhandler=new BFM_PODHandler();
        podhandler.bulkAfter();
        podhandler.beforeDelete(pod);
        podhandler.afterInsert(pod);
        podhandler.afterDelete(pod); 
        
        
    
Test.stopTest();     
}
}