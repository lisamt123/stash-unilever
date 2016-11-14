@isTest
private class CI_R2R_SME_GetHistory_Test{
    static testMethod void myUnitTest() {
        Test.startTest();
        List<Recordtype> rt = new List<Recordtype>();
        rt = [select id from recordtype where DeveloperName= 'CI_SME_with_CI']; 
        CI_SMS_Weekly_Update__c CISME = new CI_SMS_Weekly_Update__c();        
        //CISME.Project_Category__c= 'Continuous Improvements';
        CISME.RAG__c = 'Green';
        CISME.Comments__c = 'testcomments';
        if(!rt.isEmpty()){
        CISME.recordTypeid = rt[0].id;
        }
        insert CISME;
        system.assertEquals('Green', CISME.RAG__c);
        
        
        //List<CI_SMS_Weekly_Update__History> inHistory = new List<CI_SMS_Weekly_Update__History>();               
        
        PageReference pageRef = Page.CI_R2R_Comments_Section_for_SME;            
        test.setcurrentpage(pageRef);       
        
               
        ApexPages.StandardController sc = new ApexPages.standardController(CISME);        
        CI_R2R_SME_GetHistory Historycls = new CI_R2R_SME_GetHistory(sc);
        CI_R2R_SME_GetHistory.wrapper R2Rwrap = new CI_R2R_SME_GetHistory.wrapper('name','name1','changedby','cDate');
        Historycls.getWrappervalues();
        
        R2Rwrap.OldValue = 'test';
        Historycls.changedby = 'test1';   
        
        Test.stopTest();
    } 
    
}