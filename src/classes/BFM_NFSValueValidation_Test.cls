@isTest
public class BFM_NFSValueValidation_Test{
 static testMethod void testBFM_NFSValueValidation(){
 
 Test.startTest();
 
 Account acc =new Account();
  acc.name='carrier';
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        insert acc;
        system.assertEquals('11',acc.Vendor__c);
        
        BFM_Shipment__c ship=new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        insert ship;
        
         BFM_Stage__c stg=new BFM_Stage__c();
        stg.Shipment__c=ship.id;
        insert stg;
        
 list<BFM_NFS__c>nfslst=new list<BFM_NFS__c >();
 BFM_NFS__c nfs=new BFM_NFS__c();
 nfs.Carrier__c=acc.id;
 nfs.NFS_Duplicate_Check_Status__c='validation ok';
 nfs.NFS_CNPJ_Check_Status__c='valid CNPJ';
 nfs.NFS_Link_Check_Status__c='link ok';
 nfs.NFS_Company_Code_Check_Status__c='company ok';
 nfs.NFS_Vendor_Check_Status__c='vendor ok';
 nfs.NFS_Date_Check_Status__c='date ok';
 nfs.Print_Requested__c=true;
 nfs.NFS_Definitive__c=true;
 nfslst.add(nfs);
 insert nfslst;
 
 
 system.assertEquals('validation ok', nfs.NFS_Duplicate_Check_Status__c);
 
 
 BFM_SES__c ses=new BFM_SES__c();
 ses.NFS__c=nfs.id;
 insert ses;
// BFM_NFSValueValidation nfsval=new BFM_NFSValueValidation(nfslst);
 BFM_NFSValueValidation.NFSTotalValueValidation(nfslst);
 
 Test.stopTest();
 }
 }