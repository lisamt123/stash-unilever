@isTest
private class BFM_TotalValueValidation_Test{   
    private static testMethod void testBFM_TotalValueValidation(){
    //BFM_TotalValueValidation total=new BFM_TotalValueValidation();
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
    
    list<BFM_CT_e__c>ctelst=new list<BFM_CT_e__c >();
    BFM_CT_e__c cte=new BFM_CT_e__c();
    cte.CT_e_key__c='123456';
    cte.Cte_original_Access_Key__c='123';
    cte.CNPJ_Service_Taker__c='12345678900000';
    cte.CNPJ_issuer__c='12345678900000';
    cte.CT_e_Type__c='normal';
    cte.CFOP__c='6.932';
    cte.Carrier_Account__c=acc.id;
    cte.DEFINITIVE__c=true;
    //cte.Cte_Emission_date_time__c=datetime.newInstance(2016, 10, 6, 12, 30, 0);
    ctelst.add(cte);
    try{
    	insert ctelst ;
    }catch(Exception e){}
    
    BFM_Stage__c stg=new BFM_Stage__c();
    stg.Shipment__c=shipmentRec.id;
    stg.Unilever_Account__c = acc.Id;
    insert stg;
    
    BFM_SES__c ses=new BFM_SES__c();
    ses.CT_E__c=cte.id;
    ses.Stage__c=stg.id;
    ses.Occurrence__c=occ.id;
    insert ses;
    BFM_CheckRecursive.firstRun=true;
    
    BFM_TotalValueValidation.CteTotalValueValidation(ctelst );    
    }
    }