@isTest
private class AR_Test_CMSData {

    static testMethod void test() {
        
        ar_Agency_Portal_CMS__c cms = TestDataFactory.getCMS('FAQ', 'What do we come from?', 'No idea yet', 1);
        insert cms;
        
        Test.startTest();
            AR_CMSData cmsData = new AR_CMSData();
            cmsData.contentType = 'FAQ';
            List<ar_Agency_Portal_CMS__c> results = cmsData.getCmsContent();
        Test.stopTest();
        
        system.assertEquals(cms.id, results[0].id, 'Cms content was not retrieved.');
    }
}