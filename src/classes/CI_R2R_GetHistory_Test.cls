@isTest
private class CI_R2R_GetHistory_Test {
    static testMethod void myUnitTest() {
        Test.startTest();                
        //List<CI_R2R_Innovation__History> rrlist;
        CI_R2R_Innovation__c CIR2R = new CI_R2R_Innovation__c();        
        CIR2R.Project_Category__c = 'Continuous Improvements';
        CIR2R.RAG__c = 'Green';
        CIR2R.Comments__c = 'testcomments';
        insert CIR2R;
        system.assertEquals('Green', CIR2R.RAG__c);
        
        
        List<CI_R2R_Innovation__History> inHistory = new List<CI_R2R_Innovation__History>();               
        
        PageReference pageRef = Page.CI_R2R_Comments_Section;            
        test.setcurrentpage(pageRef);       
        
               
        ApexPages.StandardController sc = new ApexPages.standardController(CIR2R);        
        CI_R2R_GetHistory Historycls = new CI_R2R_GetHistory(sc);
        CI_R2R_GetHistory.wrapper R2Rwrap = new CI_R2R_GetHistory.wrapper('name','name1','changedby','cDate');
        Historycls.getWrappervalues();
        
        Historycls.changedby = 'test1';        
        Test.stopTest();
    }
}