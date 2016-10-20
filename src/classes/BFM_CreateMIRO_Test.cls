@isTest
public class BFM_CreateMIRO_Test{   
   static testMethod void testBFM_CreateMIRO(){
   Test.startTest();
   Account acc = new Account();
       acc.name='carrier';
        acc.cnpj__c = '03189042000100';
        acc.Vendor__c='11';
        acc.Company_Code__c='12';
        insert acc;
        
         
  BFM_Shipment__c ship=new BFM_Shipment__c();
        ship.Carrier_Account__c=acc.id;
        
        insert ship;
 
 BFM_Occurrence__c occ=new BFM_Occurrence__c();
 occ.Name='test';
 occ.Approval_Date_1__c=date.newInstance(2016, 9, 15);
 occ.Shipment__c=ship.id;
 insert occ;
 
          system.assertEquals('test', occ.Name);
        
        BFM_Stage__c stg=new BFM_Stage__c();
        stg.Shipment__c=ship.id;
        insert stg;
        
        BFM_CTeSearch_CC search=new BFM_CTeSearch_CC();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.CT_e_Number__c='6456';
    
    insert cte;
    
        list<BFM_SES__c> seslst=new list<BFM_SES__c >();
        BFM_SES__c ses=new BFM_SES__c();
        ses.Occurrence__c=occ.id;
        ses.Stage__c=stg.id;
        ses.CT_E__c=cte.id;
        seslst.add(ses);
       insert seslst;
   
   
   BFM_IVA__c iva=new BFM_IVA__c();
   iva.Excluded_Base__c=123;
   iva.Other_Base__c=2132;
   iva.Tax_Base__c=4332;
   iva.SES__c=ses.id;
   insert iva;
   
   BFM_CreateMIRO miro=new BFM_CreateMIRO(iva.id,false,false);
   miro.getIVAsBySES(seslst);
   miro.createMIRO();
    Test.stopTest();
  }
}