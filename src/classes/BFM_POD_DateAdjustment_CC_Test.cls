@isTest
public class BFM_POD_DateAdjustment_CC_Test{
    private static testMethod void testBFM_POD_DateAdjustment_CC(){
    test.startTest();
    list<BFM_POD__c> podlst = new list<BFM_POD__c>();
    BFM_POD__c pod = new BFM_POD__c();          
    pod.POD_Date__c=Date.newInstance(2016,9,20);
    podlst.add(pod);    
    insert podlst;
        
    list<BFM_NFS__c>nfslst=new list<BFM_NFS__c>();

    BFM_NFS__c nfs=new BFM_NFS__c();
    nfs.Name='test';
    nfs.NFS_Number__c='1234';
    nfs.NFS_Series__c='123';
    nfs.Vendor_s_CNPJ_or_CPF__c='12345678900000';
    nfs.NFS_Link_Check_Status__c='Link Ok';
   // nfs.Service_Taker_Company_UF__c='12';
    //insert nfs;
    nfslst.add(nfs);
    
    insert nfslst; 
    system.assertEquals('test',nfs.Name); 
    
    BFM_NF_e__c nfe=new BFM_NF_e__c();
    nfe.NF_e_access_key__c='1234567890';
    nfe.Taker_CNPJ__c='12345678900000';
        
    nfe.NFS__c=nfs.id;
        
    insert nfe;
        
    pod.NF_e__c=nfe.id;
    update pod;
        
    BFM_POD_DateAdjustment_CC podHandler = new BFM_POD_DateAdjustment_CC();
    podHandler.podUpdate();
    podHandler.back(); 
    test.stopTest();
    }
}