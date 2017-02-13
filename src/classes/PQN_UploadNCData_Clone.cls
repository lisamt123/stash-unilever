global without sharing class PQN_UploadNCData_Clone{
    
    public string selectedfile{get; set;}
    public List<selectoption> filetype{get; set;}
  
    public PQN_UploadNCData_Clone (){
        selectedfile = apexpages.currentpage().getparameters().get('fileType');
        filetype = new List<selectOption>();
        filetype.add(new SelectOption('Unilever','Unilever'));
        filetype.add(new SelectOption('Cannock','Cannock'));
        filetype.add(new SelectOption('Heilbronn','Heilbronn'));
    }
    
    @RemoteAction
    global static Database.UpsertResult[] getSheetData(List<PQN_Pallet_Quality_Non_Conformance__c> xPQN, String selectedFileType,String timeStamp) {
        Delete [select id From PQN_Pallet_Quality_Non_Conformance__c where Is_Error__c=true and createdbyid=:UserInfo.getUserId()];
        system.debug(xPQN);
        
        List<PQN_Pallet_Quality_Non_Conformance__c> xPQNLIST= xPQN;
        Map<string,PQN_DC_Hierarchy__c> mapmasterdata = new Map<string,PQN_DC_Hierarchy__c>();
        Map<string,PQN_DC_Hierarchy__c> mapdcdata = new Map<string,PQN_DC_Hierarchy__c>();
        mapmasterdata = PQN_DC_Hierarchy__c.getAll();
        
        for(PQN_DC_Hierarchy__c dc: mapmasterdata.values()){
            mapdcdata.put(dc.dc__c,dc);             
        }
        
        String errorDesc = '';
        List<Account> xAcc = new List<Account>();
        Map<String,Id> mapAcc = new Map<String,Id>();
        
        Map<String,PQN_Supplier__c> mapSupplier = new Map<String,PQN_Supplier__c>();
        Map<Decimal,PQN_Pallet_Loss_Tree__c> mapLossTree = new Map<Decimal,PQN_Pallet_Loss_Tree__c>();
        Map<String,PQN_Pallet_Quality_Non_Conformance__c> mapProducts = new Map<String,PQN_Pallet_Quality_Non_Conformance__c>();
        Set<String> accName = new Set<String>();
        
        Set<String> productNos = new Set<String>();
        Set<String> supplierALias = new Set<String>();
        Set<Decimal> lossCodes = new Set<Decimal>();
        
        for(PQN_Pallet_Quality_Non_Conformance__c xP : xPQNLIST){
                accName.add(xP.Reporting_DC__c);
                productNos.add(xP.SKU__c);
                supplierALias.add(xP.Supplier__c);
                lossCodes.add((Decimal) xP.Non_compliance_reason_code__c);
         }
         for(PQN_Pallet_Quality_Non_Conformance__c xP : [select id,Product_Category__c,Product_Name__c,Product_Group__c,SKU__c from PQN_Pallet_Quality_Non_Conformance__c where SKU__c =:productNos]){
             mapProducts.put(xP.SKU__c,xP);
         }
         for(PQN_Supplier__c xSP: [Select Id,Name,Supplier_Alias__c,Supplier_Number__c,Supplier_Type__c from PQN_Supplier__c where Supplier_Alias__c =:supplierALias]){
             mapSupplier.put(xSP.Supplier_Alias__c,xSP);
         }
         for(PQN_Pallet_Loss_Tree__c xLos: [SELECT Loss_Code__c,Loss_L1__c,Loss_L2__c,Loss_L3__c,Loss_L4__c,Name FROM PQN_Pallet_Loss_Tree__c where Loss_Code__c=:lossCodes order by Loss_Code__c]){
             mapLossTree.put(xLos.Loss_Code__c,xLos);
         }
         
        if(selectedFileType=='Unilever'){
            for(Account xA : [Select Name, Id from Account where Name=:accName]){
                mapAcc.put(xA.Name, xA.Id);
            }
        }
        if(selectedFileType=='Cannock'){
            xAcc = [Select Id,Name from Account where name ='Cannock' limit 1];
        }
        if(selectedFileType=='Heilbronn'){
            xAcc = [Select Id,Name from Account where name ='Heilbronn auto' limit 1];
        }
        Id errAccId = [Select Id,Name from Account where Name='Error DC' limit 1].Id;
        
        for(PQN_Pallet_Quality_Non_Conformance__c xP : xPQNLIST){
        
            errorDesc = '';
            if(selectedFileType=='Unilever'){    
                if(mapAcc.get(xP.Reporting_DC__c)!=null){
                    xP.Account__c =mapAcc.get(xP.Reporting_DC__c);
                    if(mapdcdata.get(xP.Reporting_DC__c)!=null){
                        xP.Region__c = mapdcdata.get(xP.Reporting_DC__c).region__c;
                        xP.DC_Country__c = mapdcdata.get(xP.Reporting_DC__c).country__c;
                        xP.Cluster__c = mapdcdata.get(xP.Reporting_DC__c).cluster__c;
                        xP.Sub_Cluster__c = mapdcdata.get(xP.Reporting_DC__c).sub_cluster__c;                 
                        xP.MCO__c = mapdcdata.get(xP.Reporting_DC__c).mco__c;
                    }
                }else{
                    xP.Account__c =errAccId;
                    errorDesc+='Reporting DC is not in system. </br>';
                }
               
            }
            if(selectedFileType=='Cannock'){
                if(xAcc.size()>0){
                    xP.Account__c =xAcc[0].Id;
                     if(mapdcdata.get('Cannock')!=null){
                        xP.Region__c = mapdcdata.get('Cannock').region__c;
                        xP.DC_Country__c = mapdcdata.get('Cannock').country__c;
                        xP.Cluster__c = mapdcdata.get('Cannock').cluster__c;
                        xP.Sub_Cluster__c = mapdcdata.get('Cannock').sub_cluster__c;                 
                        xP.MCO__c = mapdcdata.get('Cannock').mco__c;
                    }
                }else{
                    xP.Account__c =errAccId;
                    errorDesc+='Reporting DC is not in system. </br>';
                }
               
            }
            if(selectedFileType=='Heilbronn'){
            
                if(xAcc.size()>0){
                    xP.Account__c =xAcc[0].Id;
                    if(mapdcdata.get('Heilbronn auto')!=null){
                        xP.Region__c = mapdcdata.get('Heilbronn auto').region__c;
                        xP.DC_Country__c = mapdcdata.get('Heilbronn auto').country__c;
                        xP.Cluster__c = mapdcdata.get('Heilbronn auto').cluster__c;
                        xP.Sub_Cluster__c = mapdcdata.get('Heilbronn auto').sub_cluster__c;                 
                        xP.MCO__c = mapdcdata.get('Heilbronn auto').mco__c;
                    }
                }else{
                    xP.Account__c =errAccId;
                    errorDesc+='Reporting DC is not in system. </br>';
                }
            }
        
            
            
            if(xP.Supplier__c.length()<1){
                errorDesc +='Supplier can not be empty. </br>';
            }else{
                
                if(mapSupplier.get(xP.Supplier__c)!=null){
                   xP.Supplier_Number__c = mapSupplier.get(xP.Supplier__c).Supplier_Number__c;
                   xP.Supplier_type__c = mapSupplier.get(xP.Supplier__c).Supplier_type__c;
                   system.debug('test');
                }
                else{
                    errorDesc +='Supplier not found in system. </br>';
                }
            
            }
            
            xP.SKU__c=(xP.SKU__c ==null || xP.SKU__c=='') ? '0' : xP.SKU__c;            
            if(xP.SKU__c.length()<1){
                errorDesc +='Product number(SKU) can not be empty. </br>';
            }else{
                
                if(mapProducts.get(xP.SKU__c)!=null){
                   xP.Product_Category__c = mapProducts.get(xP.SKU__c).Product_Category__c;
                   xP.Product_Name__c = mapProducts.get(xP.SKU__c).Product_Name__c;
                   xP.Product_Group__c = mapProducts.get(xP.SKU__c).Product_Group__c;
                   system.debug('test');
                }
                else{
                    errorDesc +='Product number(SKU) not found in system. </br>';
                }
            
            }
            
            xP.Non_compliance_reason_code__c=(xP.Non_compliance_reason_code__c==null) ? 0 : xP.Non_compliance_reason_code__c;
            if(mapLossTree.get(xP.Non_compliance_reason_code__c)!=null){
                xP.Loss_Level_2__c= mapLossTree.get(xP.Non_compliance_reason_code__c).Loss_L2__c;
                xP.loss_level_3__c = mapLossTree.get(xP.Non_compliance_reason_code__c).Loss_L3__c;
                xP.loss_level_4__c = mapLossTree.get(xP.Non_compliance_reason_code__c).Loss_L4__c;
            }
            else{
                errorDesc +='Loss Code not found in system. </br>';
            }
            
            xP.Number_of_Pallets_Per_SKU_Non_Compliant__c=(xP.Number_of_Pallets_Per_SKU_Non_Compliant__c==null) ? 0 : xP.Number_of_Pallets_Per_SKU_Non_Compliant__c;
            if(xP.Number_of_Pallets_Per_SKU_Non_Compliant__c==0){                
                errorDesc +='Number of Pallets should not be 0 and empty. </br>';
            }
            xP.Date_Pallet_Received__c =system.today();
            
            
            if(errorDesc.length()>0){
                xP.Error_Description__c=errorDesc;
                xP.Is_Error__c=true;
                
            }
        
        }
        system.debug(xPQNLIST);
        Database.UpsertResult[] SR = Database.Upsert(xPQNLIST, false);
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
    
    @RemoteAction
    global static List<PQN_Pallet_Quality_Non_Conformance__c> sheetErrors(String timeStamp) {
      return [select id,Reporting_DC__c,Delivery_Note_Number__c,Description__c,SKU__c,Supplier__c,Supplier_Number__c, Non_compliance_reason_code__c,Number_of_Pallets_Per_SKU_Non_Compliant__c,Date_Pallet_Received__c,Comments__c,Error_Description__c,Account__c  From PQN_Pallet_Quality_Non_Conformance__c where Multi_Timestamp__c=:timeStamp AND Is_Error__c=true and createdbyid=:userinfo.getuserid()];
    }
    
    
}