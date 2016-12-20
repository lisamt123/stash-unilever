@isTest
private class BFM_SummaryScreen_CC_Test{
    private static testMethod void testBFM_SummaryScreen_CC (){
    test.startTest();
    Account acc = new Account();
    acc.name='carrir';
    acc.cnpj__c = '03189042000100';
    acc.Vendor__c='11';
    acc.Company_Code__c='12';
    acc.Region__c='lo';
    insert acc;
    system.assertEquals('11',acc.Vendor__c);
        
    BFM_Shipment__c shipmentRec = new BFM_Shipment__c();
    shipmentRec.Shipment_Number__c='65624565';
    shipmentRec.Carrier_Account__c = acc.id;      
    insert shipmentRec;
        
    BFM_Occurrence__c occ=new BFM_Occurrence__c();
    occ.Approval_Date_1__c=date.newInstance(2016,10,30);
    occ.Carrier_Account__c = acc.id;
    occ.Shipment__c = shipmentRec.id;
    insert occ;
    
    list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.Cte_original_Access_Key__c='123';
    cte.CNPJ_Service_Taker__c='12345678900000';
    cte.CNPJ_issuer__c='12345678900000';
    cte.CT_e_Type__c='normal';
    cte.CFOP__c='6.932';
    cte.Carrier_Account__c=acc.id;
    cte.UF_Goods_Sender__c='UK';
    cte.Link_Status__c='Link OK';
    cte.Company_Code_Status__c='Company code OK';
    cte.CT_e_Duplicate_Record_Status__c='Validation OK';
    cte.CT_e_Sefaz_Check_Status__c='Sefaz Ok';
    cte.Cte_Status__c='Date Ok';
    cte.CT_e_Valid_CNPJ_Status__c='Valid CNPJ';
    //cte.Cte_Emission_date_time__c=datetime.newInstance(2016, 10, 6, 12, 30, 0);
    ctelst.add(cte);
    insert ctelst ;
    
    BFM_Shipment__c ship=new BFM_Shipment__c();
    ship.Carrier_Account__c=acc.id;
    //ship.Unilever_Company__c=acc.id;
    insert ship;
    
    BFM_Stage__c stg=new BFM_Stage__c();
    stg.Shipment__c=shipmentRec.id;
    stg.Origin_city__c='UK';
    stg.Destination_city__c='KU';
    stg.Unilever_Account__c = acc.Id;
    insert stg;
    
    list<BFM_SES__c>seslst=new list<BFM_SES__c>();
    BFM_SES__c ses=new BFM_SES__c();
    ses.CT_E__c=cte.id;
    ses.Stage__c=stg.id;
    ses.Occurrence__c=occ.id;
    ses.Gross_Value_net_tax__c=123;
    //ses.CT_E__r.Link_Status__c = ctelst;
    ses.Document_Upload_Date_Time__c=datetime.newInstance(2016, 10, 6, 12, 30, 0);
    seslst.add(ses);
    insert seslst;
    
      
    BFM_SummaryScreen_CC summary=new BFM_SummaryScreen_CC();
    summary.countLinkStatusNotOk = 0.5;
    summary.searchSES();
    summary.SESView(seslst);
    summary.redirectPage();
    test.stopTest();
    }
    }