global without sharing class PQN_UploadNCData_Clone{
    
    public string selectedfile{get; set;}
    public List<selectoption> filetype{get; set;}
  
    public PQN_UploadNCData_Clone (){
        filetype = new List<selectOption>();
        filetype.add(new SelectOption('Unilever','Unilever'));
        filetype.add(new SelectOption('Cannock','Cannock'));
        filetype.add(new SelectOption('Heilbronn','Heilbronn'));
    }
    
    @RemoteAction
    global static Database.SaveResult[] getSheetData(List<PQN_Pallet_Quality_Non_Conformance__c> xPQN, String selectedFileType) {
                
        
        List<PQN_Pallet_Quality_Non_Conformance__c> xPQNLIST= xPQN;
        String errorDesc = '';
        for(PQN_Pallet_Quality_Non_Conformance__c xP : xPQNLIST){
        
            errorDesc = '';
            xP.SKU__c=(xP.SKU__c ==null || xP.SKU__c=='') ? '0' : xP.SKU__c;
            if(xP.Supplier__c.length()<1){
                errorDesc +='Supplier__c can not be empty';
            }
            
            if(xP.SKU__c.length()<1){
                errorDesc +='SKU__c can not be empty';
            }
            if(errorDesc.length()>0){
                xP.Error_Description__c=errorDesc;
                xP.Is_Error__c=true;
                
            }
        
        }
        system.debug(xPQNLIST);
        Database.SaveResult[] SR = Database.insert(xPQNLIST, false);
        system.debug(SR);
        return SR;
    }
    
    @RemoteAction
    global static Map<String,Integer> getSheetStatus(String timeStamp) {

        Map<String,Integer> xMapStatus = new Map<String,Integer>();
        xMapStatus.put('Error',[Select Id from PQN_Pallet_Quality_Non_Conformance__c  where Is_Error__c=true and createdbyid=:userinfo.getuserid() and Multi_Timestamp__c=:timeStamp].size());
        xMapStatus.put('Success',[Select Id from PQN_Pallet_Quality_Non_Conformance__c  where Is_Error__c=false and createdbyid=:userinfo.getuserid() and Multi_Timestamp__c=:timeStamp].size());
       
        return xMapStatus;
    }
    
    
}