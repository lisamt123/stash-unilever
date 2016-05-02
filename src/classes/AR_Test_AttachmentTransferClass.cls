@isTest
private class AR_Test_AttachmentTransferClass {

    static testMethod void test() {
        ar_Application__c app = TestDataFactory.getApplication();
        insert app;
        
        Attachment a1 = new Attachment(name = 'file 1', parentId = app.id, body = Blob.valueOf('content'));
        Attachment a2 = new Attachment(name = 'file 2', parentId = app.id, body = Blob.valueOf('content'));
        insert new List<Attachment>{a1,a2};
        
        RecordType rtAgency = [select id from RecordType where sobjectType = 'Account' and developerName = 'Agency'];
        Account acc = new Account(Name = 'account 1', recordTypeId = rtAgency.id);
        insert acc;
        
        system.assertEquals(0, [select count() from Attachment where parentId = :acc.id], 'no files are expected in account');
        
        Test.startTest();
            AR_AttachmentTransferClass.transferAttachments(acc.id, new List<Id>{a1.id, a2.id});
        Test.stopTest();
        
        List<Attachment> files = [select name from Attachment where parentId = :acc.id order by createddate];
        system.assertEquals(a1.name, files[0].name, 'files were not transferred');
        system.assertEquals(a2.name, files[1].name, 'files were not transferred');
    }
}