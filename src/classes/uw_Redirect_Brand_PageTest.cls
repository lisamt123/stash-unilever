@isTest
private class uw_Redirect_Brand_PageTest {

    static testMethod void myUnitTest() {
        
        Redirect_Brand_Page Templateredirect = new Redirect_Brand_Page(new ApexPages.StandardController(new uw_Brand__c())); 
        
        
        
        Templateredirect.redirect();
        
    }
    
    
}