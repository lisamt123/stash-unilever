/**
 * An apex page controller that exposes the site forgot password functionality
 */
public with sharing class AR_ForgotPasswordController {
    public String username {get; set;}   
       
    public AR_ForgotPasswordController() {}
    
    public PageReference forgotPassword() {
        boolean success = Site.ForgotPassword(username);
        PageReference pr = Page.AR_ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {              
            return pr;
        }
        return null;
    }
}