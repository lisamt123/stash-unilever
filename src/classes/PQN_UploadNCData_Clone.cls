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
        List<Account> xAcc = new List<Account>();
        Map<String,Id> mapAcc = new Map<String,Id>();
        Set<String> accName = new Set<String>();
        if(selectedFileType=='Unilever'){
            for(PQN_Pallet_Quality_Non_Conformance__c xP : xPQNLIST){
                accName.add(xP.Reporting_DC__c);
            }
            for(Account xA : [Select Name, Id from Account where Name=:accName]){
                mapAcc.put(xA.Name, xA.Id);
            }
        }
        if(selectedFileType=='Cannock'){
            xAcc = [Select Id,Name from Account where name ='Cannock DC' limit 1];
        }
        if(selectedFileType=='Heilbronn'){
            xAcc = [Select Id,Name from Account where name ='Heilbronn DC' limit 1];
        }
        Id errAccId = [Select Id,Name from Account where Name='Error DC' limit 1].Id;
        
        for(PQN_Pallet_Quality_Non_Conformance__c xP : xPQNLIST){
        
            errorDesc = '';
            if(selectedFileType=='Unilever'){    
                if(mapAcc.get(xP.Reporting_DC__c)!=null){
                    xP.Account__c =mapAcc.get(xP.Reporting_DC__c);
                }else{
                    xP.Account__c =errAccId;
                    errorDesc+='Reporting DC is not in system.';
                }
               
            }
            if(selectedFileType=='Cannock'){
                if(xAcc.size()>0){
                    xP.Account__c =xAcc[0].Id;
                }else{
                    xP.Account__c =errAccId;
                    errorDesc+='Reporting DC is not in system.';
                }
               
            }
            if(selectedFileType=='Heilbronn'){
            
                if(xAcc.size()>0){
                    xP.Account__c =xAcc[0].Id;
                }else{
                    xP.Account__c =errAccId;
                    errorDesc+='Reporting DC is not in system.';
                }
            }
        
            
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