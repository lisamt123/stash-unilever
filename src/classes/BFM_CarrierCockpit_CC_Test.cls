@isTest
private class BFM_CarrierCockpit_CC_Test{
    private static testMethod void testBFM_CarrierCockpit_CC (){
    
    Test.startTest();
    BFM_Shipment__c ship=new BFM_Shipment__c();
    ship.Shipment_Number__c='1234';
    ship.Carrier_Account__c='0018A000007SARV';
    ship.Unilever_Company__c='0018A000007SARV';
    ship.Pricing_Calculation_Date__c=date.newInstance(2014, 9, 15);

    //ship.Shipment_Start__c=date.newInstance(2014, 9, 10);
    insert ship;
    
    list<BFM_Stage__c> stglst=new list<BFM_Stage__c>();
    BFM_Stage__c stg=new BFM_Stage__c();
    //stg.Carrier_Account__c='0018A000007SARV';
    stg.Destination_city__c='france';
    stg.Gross_value_from_cost_preview__c= 10;
    stg.Shipment__c=ship.id;
    stglst.add(stg);
    insert stglst;
    
    ApexPages.StandardController sc = new ApexPages.standardController(stg);
    BFM_CarrierCockpit_CC cock=new BFM_CarrierCockpit_CC(sc);     
    
    Test.stopTest();
    }
    }