@isTest
private class BFM_CCeHandler_Test{
    private static testMethod void testBFM_CCeHandler(){
    
    Test.startTest();
    BFM_CC_e__c cce=new BFM_CC_e__c();
    cce.CC_e_Key__c='212312';
    cce.CNPJ_Issuer__c='12345678900000';
    cce.CNPJ_Service_Taker__c='12345678900000';
    insert cce;
    BFM_CCeHandler ccehandler=new BFM_CCeHandler();
    ccehandler.beforeUpdate(cce,cce);
    ccehandler.afterUpdate(cce,cce);
    delete cce;
      Test.stopTest();
    }
    }