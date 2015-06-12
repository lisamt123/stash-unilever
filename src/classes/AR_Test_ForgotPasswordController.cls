@isTest
private class AR_Test_ForgotPasswordController {

    static testmethod void testForgotPasswordController() {
        // Instantiate a new controller with all parameters in the page
        AR_ForgotPasswordController controller = new AR_ForgotPasswordController();
        controller.username = 'test@salesforce.com';        
    
        System.assertEquals(controller.forgotPassword(),null); 
    }
}