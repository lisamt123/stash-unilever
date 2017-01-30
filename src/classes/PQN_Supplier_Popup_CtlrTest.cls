@isTest
private class PQN_Supplier_Popup_CtlrTest{
    private static testMethod void testPQN_Supplier_popup_M1(){
     Test.startTest();
     
         PQN_Supplier__c s=new PQN_Supplier__c();
          s.Supplier_Number__c='123';
          s.Supplier_Type__c ='test';
         
        PQN_Pallet_Quality_Non_Conformance__c p =new PQN_Pallet_Quality_Non_Conformance__c ();
            p.Product_Category__c='testpcat';
            p.Product_Name__c='testpname';
            p.Product_Group__c='testpgrp';
            p.SKU__c ='testpsku';
            
        PageReference pageRef1 = Page.PQN_Supplier_Popup;
        Test.setCurrentPage(pageRef1);
        Apexpages.currentPage().getParameters().put('object_Name','Products');
        
        PQN_Supplier_Popup_Ctlr sup1=new PQN_Supplier_Popup_Ctlr();
        sup1.runQuery();
        
        PageReference pageRef2 = Page.PQN_Supplier_Popup;
        Test.setCurrentPage(pageRef2);
        Apexpages.currentPage().getParameters().put('object_Name','Suppliers');
        
        
        PQN_Supplier_Popup_Ctlr sup2=new PQN_Supplier_Popup_Ctlr();
        sup2.runQuery();
        
        PageReference pageRef3 = Page.PQN_Supplier_Popup;
        Test.setCurrentPage(pageRef3);
        Apexpages.currentPage().getParameters().put('object_Name','Loss codes');
        
        
        PQN_Supplier_Popup_Ctlr sup3=new PQN_Supplier_Popup_Ctlr();
        
     Test.StopTest();
     }
  }