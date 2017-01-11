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
        
        Map<String,PQN_Supplier__c> mapSupplier = new Map<String,PQN_Supplier__c>();
        Map<String,PQN_Pallet_Loss_Tree__c> mapLossTree = new Map<String,PQN_Pallet_Loss_Tree__c>();
        Map<String,PQN_Pallet_Quality_Non_Conformance__c> mapProducts = new Map<String,PQN_Pallet_Quality_Non_Conformance__c>();
        Set<String> accName = new Set<String>();
        
        Set<String> productNos = new Set<String>();
        Set<String> supplierALias = new Set<String>();
        Set<String> lossCodes = new Set<String>();
        
        for(PQN_Pallet_Quality_Non_Conformance__c xP : xPQNLIST){
                accName.add(xP.Reporting_DC__c);
                productNos.add(xP.SKU__c);
                supplierALias.add(xP.Supplier__c);
                lossCodes.add(xP.Losses__c);
         }
         for(PQN_Pallet_Quality_Non_Conformance__c xP : [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c =:productNos]){
             mapProducts.put(xP.SKU__c,xP);
         }
         for(PQN_Supplier__c xSP: [Select Id,Name,Supplier_Alias__c,Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Supplier_Alias__c =:supplierALias]){
             mapSupplier.put(xSP.Supplier_Alias__c,xSP);
         }
         for(PQN_Pallet_Loss_Tree__c xLos: [SELECT Loss_Code__c,Loss_L1__c,Loss_L2__c,Loss_L3__c,Loss_L4__c,Name FROM PQN_Pallet_Loss_Tree__c where Name=:lossCodes order by Loss_Code__c]){
             mapLossTree.put(xLos.Name ,xLos);
         }
         
         // xSuppliers= [Select Id,Name,Supplier_Alias__c,Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Supplier_Alias__c Like :tempInput ];
         // select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c
         // SELECT Loss_Code__c,Loss_L1__c,Loss_L2__c,Loss_L3__c,Loss_L4__c,Name FROM PQN_Pallet_Loss_Tree__c order by Loss_Code__c
        if(selectedFileType=='Unilever'){
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
            }else{
                
                if(mapSupplier.get(xP.Supplier__c)!=null){
                   //emptyif for checking
                   system.debug('test');
                }
                else{
                    errorDesc +='Supplier not found in system';
                }
            
            }
            
            if(xP.SKU__c.length()<1){
                errorDesc +='Product number(SKU) can not be empty';
            }else{
                
                if(mapSupplier.get(xP.SKU__c)!=null){
                  //emptyif for checking
                  system.debug('test');
                }
                else{
                    errorDesc +='Product number(SKU) not found in system';
                }
            
            }
            
            xP.Losses__c=(xP.Losses__c==null || xP.Losses__c=='') ? '0' : xP.Losses__c;
            if(xP.Losses__c.length()<1){
                errorDesc +='Loss Code can not be empty';
            }else{
                
                if(mapSupplier.get(xP.Losses__c)!=null){
                    //emptyif for checking
                    system.debug('test');
                }
                else{
                    errorDesc +='Loss Code not found in system';
                }
            
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