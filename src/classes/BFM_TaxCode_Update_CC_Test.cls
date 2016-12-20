@isTest
private class BFM_TaxCode_Update_CC_Test {
    static testMethod void Taxcodeupdate(){
    Account acc = new account();
    acc.name='carrier';
    acc.cnpj__c = '03189042000100';
    acc.Vendor__c='11';
    acc.Company_Code__c='12';
    acc.Region__c='lo';
    insert acc;
    system.assertEquals('11', acc.Vendor__c);
  
    BFM_Shipment__c shipmentRec = new BFM_Shipment__c();
    shipmentRec.Shipment_Number__c='65624565';
    shipmentRec.Carrier_Account__c = acc.id;      
    insert shipmentRec;
        
    BFM_Occurrence__c occ=new BFM_Occurrence__c();
    occ.Approval_Date_1__c=date.newInstance(2016,10,30);
    occ.Carrier_Account__c = acc.id;
    occ.Shipment__c = shipmentRec.id;
    insert occ;
    
    BFM_Tax_Code__c tax = new BFM_Tax_Code__c();
    tax.Name = 'test';
    insert tax;
    
    list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.Cte_original_Access_Key__c='123';
    cte.CNPJ_Service_Taker__c='12345678900000';
    cte.CNPJ_issuer__c='12345678900000';
    cte.CT_e_Type__c='normal';
    cte.CFOP__c='6.932';
    cte.Carrier_Account__c=acc.id;
    cte.Tax_Code__c = tax.Id; 
    ctelst.add(cte);
    insert ctelst;
        
    BFM_Stage__c stg=new BFM_Stage__c();
    stg.Shipment__c=shipmentRec.id;
    stg.Unilever_Account__c = acc.Id;
    insert stg;
    
    list<BFM_SES__c>seslst=new list<BFM_SES__c >();
    BFM_SES__c ses=new BFM_SES__c();
    ses.CT_E__c=ctelst[0].id;
    ses.Stage__c=stg.id;
    ses.Occurrence__c=occ.id;
    seslst.add(ses);
    insert seslst;

    BFM_TaxCode_Update_CC taxupdate = new BFM_TaxCode_Update_CC();
    //BFM_TaxCode_Update_CC.CTeWrapper wrap = new BFM_TaxCode_Update_CC.CTeWrapper(ctelst[0]);
    taxupdate.cteUpdate();
    taxupdate.back();
    }
}