@isTest
private class BFM_Fileupload_CCTest{
private static testMethod void testBFM_Fileupload_CC(){

 Test.startTest();
 Account acc = new Account();
 acc.name='carrir';
 acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        acc.Region__c='lo';
        insert acc;
 
 BFM_File__c fileu=new BFM_File__c();
 fileu.File_Type__c='MDFE';
 insert fileu;
 
 BFM_File__c fileu1=new BFM_File__c();
 fileu1.File_Type__c='NFS';
 insert fileu1;
 
 Attachment att11=new Attachment();
 BFM_NFS__c nfs=new BFM_NFS__c();
 nfs.Carrier__c=acc.id;
 insert nfs;
 
 BFM_Fileupload_CC file11=new BFM_Fileupload_CC();
 file11.filetype='NFS';
  att11.parentid=nfs.id;
 att11.Name='Unit Test1 Attachment';
        att11.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        
        insert att11;
        //attlst.add(att);
       // insert attlst;
        file11.newAttachments.add(att11);
        file11.save();
 
 Attachment att=new Attachment();
BFM_MDF_e__c mdf=new BFM_MDF_e__c();
mdf.MDFE_Access_Key__c='123245';
mdf.Carrier_Account__c=acc.id;
insert mdf;
 list<Attachment> attlst=new list<Attachment>(); 
 BFM_Fileupload_CC file=new BFM_Fileupload_CC();
  file.filetype='MDFE';
  att.parentid=mdf.id;
 att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        
        insert att;
        //attlst.add(att);
       // insert attlst;
        file.newAttachments.add(att);
        file.save();
        
         List<Attachment> attachments=[select id, name from Attachment where parent.id=:mdf.id];
        System.assertEquals(1, attachments.size());
        //file.cancel();
        
        list<Attachment> attlst1=new list<Attachment>();
        Attachment att1=new Attachment(); 
 BFM_Fileupload_CC file1=new BFM_Fileupload_CC();
  
  att1.parentid=mdf.id;
 att1.Name='Unit Test Attachment';
        att1.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        
       
        attlst1.add(att1);
        insert attlst1;
        file.newAttachments.add(att1);
        file.save();
       // file.cancel();
         //List<Attachment> attachments1=[select id, name from Attachment where parent.id=:mdf.id];
       // System.assertEquals(1, attachments1.size());
       

 Test.stopTest();
 }
 }