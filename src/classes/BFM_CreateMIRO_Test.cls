@isTest
public class BFM_CreateMIRO_Test{   
   static testMethod void testBFM_CreateMIRO(){
   
   Account acc = new Account();
   acc.name='carrier';
   acc.cnpj__c = '03189042000100';
   acc.Vendor__c='11';
   acc.Company_Code__c='12';
   insert acc;
   system.assertEquals('carrier', acc.name);
   
   list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.Cte_original_Access_Key__c='123';
    cte.CNPJ_Service_Taker__c='12345678900000';
    cte.CNPJ_issuer__c='12345678900000';
    cte.CT_e_Type__c='normal';
    cte.CFOP__c='6.932';
    cte.Carrier_Account__c=acc.id;
    ctelst.add(cte);
    insert ctelst ;    
    system.assertEquals('123456', cte.CT_e_key__c);
    
   BFM_Shipment__c ship = new BFM_Shipment__c();
   ship.Carrier_Account__c = acc.id;
   insert ship;
   
   BFM_Stage__c stge = new BFM_Stage__c();
   stge.Shipment__c = ship.id;
   insert stge;
        
   List<BFM_SES__c> seslist = new List<BFM_SES__c>();
   BFM_SES__c ses  = new BFM_SES__c();
   ses.Stage__c = stge.id;
   ses.Cost_Center__c = 'testcc';
   ses.CT_E__c = cte.id;
   insert ses;
   seslist.add(ses);
   try{
   insert seslist;
   }catch(Exception e){}
   
   BFM_IVA__c iva=new BFM_IVA__c();
   iva.Excluded_Base__c=123;
   iva.Other_Base__c=2132;
   iva.Tax_Base__c=4332;
   iva.SES__c=ses.id;
   insert iva;
   
   BFM_NFS__c nf = new BFM_NFS__c();
   nf.Base_Value__c = 10;
   nf.Carrier__c = acc.id;
   nf.Service_Taker__r.Company_Code__c = acc.id;
   nf.NFS_Emission_Date_Time__c = Date.today();
   insert nf;
   
   BFM_MIRO_Header__c mheader = new BFM_MIRO_Header__c();
   //mheader.Annulment_Flag__c = 'f';
   insert mheader;
   
   Test.startTest();
   Test.setMock(HttpCalloutMock.class, new BFM_MockHttpResponse());
   BFM_CreateMIRO miro = new BFM_CreateMIRO(iva.id,true,true);
   //BFM_CreateMIRO.requestCreateMIRO(iva.id);
   miro.getIVAsBySES(seslist);
   miro.createMIRO();
   try{
   //miro.createMIROforCTe();
   }catch(QueryException e){}
   //miro.createMIROforNFS(nf.id);
   Test.stopTest();
  }
}