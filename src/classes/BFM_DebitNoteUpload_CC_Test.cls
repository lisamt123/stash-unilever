@isTest
private class BFM_DebitNoteUpload_CC_Test{
private static testMethod void testBFM_DebitNoteUpload_CC(){
 Test.startTest();
 BFM_Occurrence__c occ=new BFM_Occurrence__c();
 occ.Name='test';
 occ.Approval_Date_1__c=date.newInstance(2016, 9, 15);
 insert occ;
 
  BFM_Debit_Note__c db=new BFM_Debit_Note__c();
 db.DN_Number__c='123355';
 db.DN_Emission_date_time__c=datetime.newInstance(2016, 9, 20, 12, 30, 0);
 db.Vendor_s_CNPJ_or_CPF__c='12345678900000';
 db.Service_Taker_CNPJ__c='12345678900000';
 db.Vendor_Code__c='11';
 db.Company_Code__c='12';
 //db.Unilever_Account__c=acc.id;
 //db.Carrier_Account__c=acc.id;
 db.Occurrence__c=occ.id;
 insert db;
// DBlist.add(db);
// insert DBlist;

BFM_POD__c pod=new BFM_POD__c();
pod.POD_Number__c='123';
insert pod;
Attachment att=new Attachment();
  
  att.parentid=db.id;
 att.Name='Unit Test Attachment';
        att.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        att.contenttype='application/pdf';
        insert att;
 ApexPages.currentpage().getParameters().put('id',db.id);
 ApexPages.currentpage().getParameters().put('obj','DebitNote');
 
 //ApexPages.currentpage().getParameters().put('id',pod.id);
 //ApexPages.currentpage().getParameters().put('obj','PODReceipt');
 BFM_DebitNoteUpload_CC debit=new BFM_DebitNoteUpload_CC();
 
        debit.newAttachment=att ;
        debit.upload();
        
         List<Attachment> attachments=[select id, name from Attachment where parent.id=:db.id];
        System.assertEquals(1, attachments.size());
debit.cancel();


        Attachment att1=new Attachment();
        att1.parentid=db.id;
         att1.Name='Unit Test Attachment';
        //att1.Body=Blob.valueOf('Unit Test Attachment Body wewqeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee');
        att1.contenttype='application/pdf';
        //insert att1;
        ApexPages.currentpage().getParameters().put('id',pod.id);
 ApexPages.currentpage().getParameters().put('obj','PODReceipt');
 BFM_DebitNoteUpload_CC debit1=new BFM_DebitNoteUpload_CC();
 
        debit1.newAttachment=att1 ;
        debit1.upload();

 Test.stopTest();
 }
 }