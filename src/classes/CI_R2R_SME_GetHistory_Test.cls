@isTest
private class CI_R2R_SME_GetHistory_Test{
    static testMethod void myUnitTest() {
        Test.startTest(); 
        CI_SMS_Weekly_Update__c CISME = new CI_SMS_Weekly_Update__c();        
        //CISME.Project_Category__c= 'Continuous Improvements';
        CISME.RAG__c = 'Green';
        CISME.Comments__c = 'testcomments';
        insert CISME;
        system.assertEquals('Green', CISME.RAG__c);
        
        
        List<CI_SMS_Weekly_Update__History> inHistory = new List<CI_SMS_Weekly_Update__History>();               
        
        PageReference pageRef = Page.CI_R2R_Comments_Section_for_SME;            
        test.setcurrentpage(pageRef);       
        
               
        ApexPages.StandardController sc = new ApexPages.standardController(CISME);        
        CI_R2R_SME_GetHistory Historycls = new CI_R2R_SME_GetHistory(sc);
        CI_R2R_SME_GetHistory.wrapper R2Rwrap = new CI_R2R_SME_GetHistory.wrapper('name','name1','changedby','cDate');
        Historycls.getWrappervalues();
        
        Historycls.changedby = 'test1';   
        
        Test.stopTest();
    } 
}