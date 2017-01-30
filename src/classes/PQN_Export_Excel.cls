public with sharing class PQN_Export_Excel {
    public List<PQN_Pallet_Quality_Non_Conformance__c> xPQN {set;get;}
    
    public PQN_Export_Excel(){
        String fileStatus = apexpages.currentpage().getparameters().get('filestatus');
        String timestamp = apexpages.currentpage().getparameters().get('timestamp');
        
        if(fileStatus=='error' || fileStatus=='success'){
            Boolean isError=false;
            if(fileStatus=='error'){
                isError=true;
            }            
            xPQN = new List<PQN_Pallet_Quality_Non_Conformance__c>([Select Id,Name,Cluster__c,Non_compliance_reason_code__c,Supplier__c,Description__c,Delivery_Note_Number__c,DC_Country__c,Supplier_type__c,SKU__c,Reporting_DC__c,Date_Pallet_Received__c,Error_Description__c from PQN_Pallet_Quality_Non_Conformance__c where Is_Error__c=:isError and createdbyid=:userinfo.getuserid() and Multi_Timestamp__c=:timestamp and createdbyid=:userinfo.getuserid()]);
       
        }

    }
}