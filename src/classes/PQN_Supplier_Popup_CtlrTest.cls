@isTest
private class PQN_Supplier_Popup_CtlrTest{
    private static testMethod void testPQN_Supplier_popup_M1(){
     Test.startTest();
         Supplier__c s=new Supplier__c();
          s.Supplier_Number__c='123';
          s.Supplier_Type__c ='test';
         
         PQN_Pallet_Quality_Non_Conformance__c p =new PQN_Pallet_Quality_Non_Conformance__c ();
           p.Product_Category__c='testpcat';
           p.Product_Name__c='testpname';
           p.Product_Group__c='testpgrp';
           p.SKU__c ='testpsku';
       
         PQN_Supplier_Popup_Ctlr sup1=new PQN_Supplier_Popup_Ctlr();
         sup1.objectName='product';
         sup1.runQuery();
     
         PQN_Supplier_Popup_Ctlr sup2=new PQN_Supplier_Popup_Ctlr();
         sup2.objectName='supplier';
         sup2.runQuery();
         
        //PQN_Supplier_Popup_Ctlr sup3=new PQN_Supplier_Popup_Ctlr();
        //sup3.objectName='product';
       // sup3.objectName='supplier';
     Test.StopTest();
     }
  }