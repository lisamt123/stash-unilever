public class BFM_SavePOD {

    private Id podId;
    
    public BFM_SavePOD(Id PodId){
        this.podId = podId;
        
    }
    
    public void sendPOD(){
        BFM_Pod__c pod = [SELECT POD_Date__c, POD_Status__c,
                          NF_e__r.Delivery__r.Delivery_Number__c,
                          NF_e__r.Delivery__r.Stage__r.Shipment__r.Shipment_Number__c FROM BFM_Pod__c WHERE Id =: podId];
        HttpResponse httpRes = BFM_GeneralServiceCalls.requestSavePOD(pod.NF_e__r.Delivery__r.Delivery_Number__c,
                                                                     pod.NF_e__r.Delivery__r.Stage__r.Shipment__r.Shipment_Number__c,
                                                                     pod.POD_Date__c,
                                                                     pod.POD_Status__c);
        if(httpRes.getStatusCode() == 200 || httpRes.getStatusCode() == 201){
            BFM_SavePODResponse response = BFM_SavePODResponse.parse(httpRes.getBody());
            if(response.SavePODResponse != null && response.SavePODResponse.errorCode != null){
                BFM_Error_Log__c newError = new BFM_Error_Log__c();
                newError.Error_code__c = response.SavePODResponse.errorCode;
                newError.Error_log__c = response.savePODResponse.errorMessage;
                newError.BFM_POD__c = podId;
                System.debug('Error: ' + response.SavePODResponse.errorCode + '	' + response.savePODResponse.errorMessage);
                
                insert newError;
            }
        } else{
            System.debug('Integration Error: ' + httpRes.getbody());
            BFM_Error_Log__c newError = new BFM_Error_Log__c();
            
            newError.Error_log__c = 'Integration error: ' + httpRes.getBody();
            newError.BFM_POD__c = podId;
            insert newError;
            
        }
    }
}