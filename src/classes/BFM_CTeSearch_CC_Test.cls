@isTest
private class BFM_CTeSearch_CC_Test{   
    private static testMethod void testctesearch(){
    Test.startTest();
    BFM_CTeSearch_CC search=new BFM_CTeSearch_CC();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.CT_e_Number__c='6456';
    
    insert cte;
      system.assertEquals('123456', cte.CT_e_key__c);
   
    //cte.Name =CTE-0000390;
    search.cte=cte;
    cte.CT_e_Number__c ='123';
   // search.OffsetSize=10;
    search.searchCTe();
    search.FirstPage();
    //search.previous();
    search.next();
    search.LastPage();
    search.getprev();
    search.getnxt();
   
    Test.stopTest();
    }
    }