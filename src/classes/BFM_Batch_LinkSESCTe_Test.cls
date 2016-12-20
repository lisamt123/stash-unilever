@isTest
private class BFM_Batch_LinkSESCTe_Test{   
   static testMethod void testBFM_Batch_LinkSESCTe (){
   Test.startTest();
    List<BFM_CT_e__c> st=new List<BFM_CT_e__c>();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CC_e_Key__c='312312';
    insert cte;
    
    BFM_SES__c se = new BFM_SES__c();
    se.CT_E__c = cte.id;
    insert se;
    system.assertEquals(cte.id, se.CT_E__c);
    
    Database.BatchableContext bc;
    BFM_Batch_LinkSESCTe obj=new BFM_Batch_LinkSESCTe();
    obj.start(bc);
    obj.execute(bc,st);
    obj.finish(bc);
    Test.stopTest();
  }
}