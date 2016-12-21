public with sharing class BFM_ValidateFiscalDocuments {

    private Set<Id> ctesIds;
    private Map<String,Id> accessKeyById;
    private boolean isSuccess;
    public BFM_ValidateFiscalDocuments(Set<Id> ctesIds){
        this.ctesIds = ctesIds;
        this.accessKeyById = new Map<String,Id> ();
    }
    public boolean isSuccess(){
        return this.isSuccess == null? false: this.isSuccess;
    }
    
    // TODO : CHECK BUSINESS RULE REGARDING CHECK THE FISCAL DOCUMENT - DOES IT SHOULD BE SENDING ONLY THE CTE KEY?
    public boolean callValidateFiscalDocuments(){
        List<String> accessKeys = new List<String>();
        isSuccess = true;
        for (BFM_CT_e__c cte :[SELECT CT_e_Key__c FROM BFM_CT_e__c WHERE Id IN :ctesIds]){
            accessKeys.add(cte.CT_e_Key__c);
            accessKeyById.put(cte.CT_e_Key__c, cte.Id);
            system.debug(accessKeys);
        }
        
        HttpResponse hResponse = BFM_GeneralServiceCalls.validateFiscalDocuments(accessKeys);
        List<BFM_CT_e__c> returningCTes;
        if(hResponse.getStatusCode() == 200 || hResponse.getStatusCode() == 201){
            returningCTes = new List<BFM_CT_e__c>();
            BFM_ValidateFiscalDocumentsResponse response = BFM_ValidateFiscalDocumentsResponse.parse(hResponse.getBody());
            for(BFM_ValidateFiscalDocumentsResponse.Cte oneCteResponse :response.ValidateFiscalDocumentResponse.cte){
                BFM_CT_e__c newCte = new BFM_CT_e__c();
                newCte.Id = accessKeyById.get(oneCteResponse.accessKey);
                newCte.SEFAZ_Return_Status__c =  oneCteResponse.itemErrorMessage;
                returningCTes.add(newCTe);
            }
            Database.saveResult[] updateCtesResult = Database.update(returningCTes);
            for(Database.saveResult updateResult :updateCtesResult){
                if(!updateResult.isSuccess()){
                    BFM_Error_Log__c errorLog = new BFM_Error_Log__c();
                    errorLog.BFM_CT_e__c = updateResult.getId();
                    errorLog.Error_log__c = 'Error updating with validation status: ';
                    for(Database.Error error :updateResult.getErrors() ){
                        errorLog.Error_log__c += '\n ' + error.getStatusCode() + ' - ' + error.getMessage();
                    }
                    isSuccess = false;
                }
            }
        } else{
            isSuccess = false;
            generateIntegrationFailureErrorLogs(hResponse.getStatusCode(), hResponse.getStatus());
            
        }
        return isSuccess;
    }
    
    @ TestVisible
    private void generateIntegrationFailureErrorLogs(Integer statusCode, String status){
        List<BFM_Error_Log__c> integrationErrorLogs = new List<BFM_Error_Log__c>();
        for(Id idCte: ctesIds){
            BFM_Error_Log__c errorLog = new BFM_Error_Log__c();
            errorLog.Error_Log__c = 'Integration failed: Status ' + statusCode + ' : ' +status;
            errorLog.BFM_CT_e__c = idCte;
            integrationErrorLogs.add(errorLog);
        }
        
        insert integrationErrorLogs;
    }
}