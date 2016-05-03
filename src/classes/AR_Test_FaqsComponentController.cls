@isTest
private class AR_Test_FaqsComponentController {

    static testMethod void test() {
        ar_Agency_Portal_CMS__c cms1 = TestDataFactory.getCMS('FAQ', 'What do we come from?', 'No idea yet', 1);
        insert cms1;
        ar_Agency_Portal_CMS__c cms2 = TestDataFactory.getCMS('FAQ', 'What do we come from?', 'No idea yet', 2);
        insert cms2;
        
        Test.startTest();
            AR_FaqsComponentController controller = new AR_FaqsComponentController();
            system.assertEquals(2, controller.cmsContent.size(), 'not all faqs were loaded');
            
            // faq1
            AR_FaqsComponentController.Faq f1 = controller.cmsContent[0];
            system.assertEquals(false, f1.getIsEven(), 'check faq order__c');
            system.assertEquals(true, f1.getIsOdd(), 'check faq order__c');
            
            AR_FaqsComponentController.Faq f2 = controller.cmsContent[1]; 
            system.assertEquals(true, f2.getIsEven(), 'check faq order__c');
            system.assertEquals(false, f2.getIsOdd(), 'check faq order__c');
            
        Test.stopTest();
    }
}