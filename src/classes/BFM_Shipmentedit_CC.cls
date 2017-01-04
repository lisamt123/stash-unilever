public without sharing class BFM_Shipmentedit_CC {
    public BFM_Shipment__c ship{get;set;}
    public string shipId;
    public BFM_Shipmentedit_CC(ApexPages.StandardController controller){
    	shipId=ApexPages.CurrentPage().getParameters().get('id');
        ship=[SELECT Id, Name, Carrier_Account__c, ANTT__c, Display__c, Pricing_Calculation_Date__c, Shipment_Number__c, 
              Shipment_Type__c, Unilever_Company__c, Vehicle_Plate__c, X6th_flag__c, Created_Date__c, Last_Shipment_Update__c, 
              Shipment_Start__c,Shipment_Status__c, Company_Code__c FROM BFM_Shipment__c where Id=:shipId];
    }
    public pagereference updateship(){
        pagereference pgref;
        if (BFM_Shipment__c.sObjectType.getDescribe().isUpdateable()){
        	update ship;			
            pgref = new PageReference('/' + shipId);
            pgref.setRedirect(true);
        }        
		return pgref;
    }
    public pagereference cancel(){
        PageReference pgref = new PageReference('/' + shipId);
        pgref.setRedirect(true);
        return pgref;
    }
}