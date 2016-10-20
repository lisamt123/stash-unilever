@isTest
private class BFM_ErrorLogSearch_CC_Test{
    private static testMethod void testBFM_ErrorLogSearch_CC (){
    
    Test.startTest();
    BFM_Error_Log__c err=new BFM_Error_Log__c();
    err.Reason__c='wqeqwe';
    insert err;
     system.assertEquals('wqeqwe', err.Reason__c);
    
    BFM_ErrorLogSearch_CC error=new BFM_ErrorLogSearch_CC();
    error.errlog=err;
    error.searcherrorlog();
    error.errorlogsearch();
    error.FirstPage();
    error.next();
    error.LastPage();
    error.getprev();
    error.getnxt();
    
    Test.stopTest();
    }
    }