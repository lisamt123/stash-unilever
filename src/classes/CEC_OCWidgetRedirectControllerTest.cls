@isTest
private class CEC_OCWidgetRedirectControllerTest {
    @isTest static void test_method_one() {
         
        User u = CEC_TestDataFactory.createStandardCECTestUser();
        System.runAs(u) {
            Test.startTest();
            CEC_OCWidgetRedirectController widgetController = new CEC_OCWidgetRedirectController();
            String widgetRedirectURL = widgetController.widgetRedirect().getURL();
            System.assertEquals('/apex/th1__widget_main',widgetRedirectURL);
        
            Test.stopTest();
        }
    }
}