@isTest
private class BFM_Batch_LinkSESCTe_Test{   
   static testMethod void testBFM_Batch_LinkSESCTe (){
   Test.startTest();
    List<BFM_CT_e__c> st=new List<BFM_CT_e__c>();
    Database.BatchableContext bc;
    BFM_Batch_LinkSESCTe obj=new BFM_Batch_LinkSESCTe();
    obj.start(bc);
    obj.execute(bc,st);
    obj.finish(bc);
    Test.stopTest();
  }
}