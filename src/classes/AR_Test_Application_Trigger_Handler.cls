@isTest
private class AR_Test_Application_Trigger_Handler {

    static testMethod void myUnitTest() {
        ar_Application__c app = TestDataFactory.getApplication();
        insert app;
        
        app = [select id, agency__c, name, status__c from ar_Application__c where id = :app.id];
        system.assertEquals('Incomplete', app.status__c);
        system.assertEquals(null, app.agency__c);
        
        // childs
        ar_Experience__c exp = TestDataFactory.getExpertise(app.id);
        insert exp;
        ar_Insurance_and_Policy__c policy = TestDataFactory.getPolicy();
        policy.application__c = app.id;
        insert policy;
        
        Attachment att;
        
        try
        {
            att = new Attachment(Name = 'TestAttachmentName', ParentId = app.Id, Body = Blob.valueOf('ATTACHMENTBODY'));
            
            insert att;
        }
        catch(Exception e)
        {
            
        }
        
        system.assertNotEquals(null, att.Id, 'Attachment could not be saved.');
        
        Test.startTest();
            // approve it
            system.debug(logginglevel.info, '#Start Approval...');
            app.status__c = 'Approved';
            update app;
        Test.stopTest();
        
        app = [select id, agency__c from ar_Application__c where id = :app.id];
        system.assertNotEquals(null, app.agency__c, 'Account was not created after approval.');
        
        Account acc = [select id, name, phone, fax, website, shippingStreet, shippingCity, shippingPostalCode, shippingCountry, 
            General_Email__c from Account where id = :app.Agency__c];
        system.debug(logginglevel.info, 'Account: ' + acc);
        system.assertNotEquals(null, acc.Name);
        
        Contact[] contacts = [select id, name, phone, mobilePhone, title, email, firstName, lastName from Contact where accountId = :acc.id];
        system.debug(logginglevel.info, 'Contacts: ' + contacts);
        system.assert(!contacts.isEmpty(), 'Contact was not created');
        
        Attachment[] attachments = [SELECT ParentId FROM Attachment WHERE ParentId =: acc.Id];
        system.assert(!attachments.isEmpty(), 'Attachment could not be found.');
        
        exp = [select id, agency__c from ar_Experience__c where id = :exp.id];
        system.assertEquals(acc.id, exp.agency__c, 'Experience child object where not linked to Agency');
        
        policy = [select id, agency__c from ar_Insurance_and_Policy__c where id = :policy.id];
        system.assertEquals(acc.id, policy.agency__c, 'Policy child object where not linked to Agency');
    }
}