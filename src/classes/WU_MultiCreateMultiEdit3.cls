public with sharing class WU_MultiCreateMultiEdit3{

    public String loggedInUser;
    private string emailLoggedUser;
    public List<WU_Master_Warehouse__c> masterWarehouseList {get;set;}
    public List<MasterWarehouseWrapper> masterWarehouseWrapperList {get;set;}
    public MasterWarehouseWrapper wrapperInstancePopup{get;set;}
    public string selectedId{get;set;}
    public string selectedField{get;set;}
    public string selectedRecords{get;set;}
    public string EmptySpace = ' ';
    
    public map<id,WU_Master_Warehouse__c> mapWUMasterWarehouse  = new  map<id,WU_Master_Warehouse__c>();
    
    public WU_MultiCreateMultiEdit3(){
        loggedInUser = UserInfo.getUserId();
        emailLoggedUser = UserInfo.getUserEmail();
        
        masterWarehouseList = new List<WU_Master_Warehouse__c>();
        masterWarehouseWrapperList = new List<MasterWarehouseWrapper>();
        wrapperInstancePopup = new MasterWarehouseWrapper(False , new WU_Master_Warehouse__c());
        fetchLatestRecords();
        populateMasterList();    
    }
    
    
    public void fetchLatestRecords(){
        masterWarehouseList = [SELECT Id,Name,WU_Committed_Max_PalletStorage__c,WU_Current_Utilization__c,WU_SAPCode_s__c,
                               WU_ToDate__c,WU_FromDate__c,WU_Utilization_Type__c,OwnerId,WU_SAPName_s__c,WU_Average_Current_Utilization__c,
                               (Select id,Name,Master_Warehouse__c,WU_Utilization_End_Date__c,WU_Utilization_Start_Date__c,
                               WU_Current_Pallet_Utilization__c,WU_Committed_Max_PalletStorage__c FROM Warehouse_Capacity_Utilizaion__r)
                               FROM WU_Master_Warehouse__c where OwnerId = :loggedInUser or
WU_WarehousePOC_Email__c =: emailLoggedUser or WU_Warehouse_Secondary_POC_Email__c=: emailLoggedUser];
                               
       for( WU_Master_Warehouse__c objWareHouse : masterWarehouseList){
        mapWUMasterWarehouse.put(objWareHouse.id,objWareHouse);
       }
                               
    }
    
    public void populateMasterList(){
        for(WU_Master_Warehouse__c master : masterWarehouseList){
            MasterWarehouseWrapper wrapperInstance = new MasterWarehouseWrapper(False , master );
            if(!master.Warehouse_Capacity_Utilizaion__r.isEmpty()){
                for(WU_Warehouse_Capacity_Detail__c wcd : master.Warehouse_Capacity_Utilizaion__r){
                    if(master.WU_FromDate__c == wcd.WU_Utilization_Start_Date__c && master.WU_ToDate__c == wcd.WU_Utilization_End_Date__c){
                        wrapperInstance.latestDetailRecordId = wcd.Id;
                        wrapperInstance.latestDetailRecordName = wcd.Name;
                        system.debug('::::latestDetailRecordId at first fetch'+wrapperInstance.latestDetailRecordId);
                        system.debug('::::latestDetailRecordName at first fetch'+wrapperInstance.latestDetailRecordName);
                    }
                }
            }
            masterWarehouseWrapperList.add(wrapperInstance);
        }
    }
    
    public void createNewCapacityDetails(){
        List<WU_Master_Warehouse__c> toUpdateList = new List<WU_Master_Warehouse__c>();
        List<Database.SaveResult> updateMasterResult = new List<Database.SaveResult>();
        Map<String,MasterWarehouseWrapper> selectedMasterRecordsMap = new Map<String,MasterWarehouseWrapper>();
           
        for(MasterWarehouseWrapper wrap : masterWarehouseWrapperList){
            if(wrap.isSelected){
                toUpdateList.add(wrap.objWUMasterWarehouse);
                if(selectedMasterRecordsMap!=null && !selectedMasterRecordsMap.containsKey(wrap.objWUMasterWarehouse.Id)){
                    selectedMasterRecordsMap.put(wrap.objWUMasterWarehouse.Id,wrap);
                }
            }
        }
        
        if(!toUpdateList.isEmpty()){
            WU_CreateCapacityDetails.isFromMultipleScreen = true;
            try{
                updateMasterResult = Database.update(toUpdateList,false);
                String finalSuccessMessage = 'Success for records : ';
                String finalErrorMessage = 'Failed Records are :  ' ;
                Boolean isMasterSuccess = false;
                Boolean isMasterFailure = false;
                
              
                
                for(Integer i=0;i<updateMasterResult.size();i++){
                    if (updateMasterResult.get(i).isSuccess()){
                        isMasterSuccess = true;
                        if(selectedMasterRecordsMap.containsKey(updateMasterResult.get(i).getId())){
                            finalSuccessMessage = finalSuccessMessage + EmptySpace +selectedMasterRecordsMap.get(updateMasterResult.get(i).getId()).objWUMasterWarehouse.Name;
                         
                        }
                    }                              
                    else if (!updateMasterResult.get(i).isSuccess()){
                        isMasterFailure = true;
                        system.debug('::::::::In Master errorss');
                        if(selectedMasterRecordsMap.containsKey(toUpdateList.get(i).Id)){
                            system.debug('::::::::In MAster map to fetch error');
                            Database.Error MasterError = updateMasterResult.get(i).getErrors().get(0);
                            system.debug('::::::::Final Master error'+MasterError);
                            //finalErrorMessage = finalErrorMessage + selectedMasterRecordsMap.get(toUpdateList.get(i).Id).masterName + EmptySpace + 'Failed due to error'+ EmptySpace +MasterError.getMessage();
                            //finalErrorMessage = finalErrorMessage + selectedMasterRecordsMap.get(toUpdateList.get(i).Id).objWUMasterWarehouse.Name;
                            
                            finalErrorMessage = finalErrorMessage + EmptySpace +selectedMasterRecordsMap.get(toUpdateList.get(i).Id).objWUMasterWarehouse.Name 
                                                + EmptySpace + 'Failed due to error :- '+ EmptySpace +MasterError.getMessage()+'<br></br>';
                            
                            //finalErrorMessage = finalErrorMessage + selectedMasterRecordsMap.get(toUpdateList.get(i).Id).objWUMasterWarehouse.Name + EmptySpace;
                            system.debug('::::::::Error string error'+finalErrorMessage);
                        }
                    }                 
                }
                                
                
                if(isMasterSuccess){
                        ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,finalSuccessMessage));
                }
                if(isMasterFailure){
                    //finalErrorMessage = finalErrorMessage + ' Records Failed due to Error';
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,finalErrorMessage));
                }    
            }
            catch(exception ex){
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Some exception occurred'));
            }
                    
        }
        else{
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select a record'));
        }
        refresh();
    }
    
    public void updateLatestCapacityDetails(){
        List<WU_Warehouse_Capacity_Detail__c> capacityDetailToUpdateList = new List<WU_Warehouse_Capacity_Detail__c>();
        List<Database.SaveResult> updateDetailsResult = new List<Database.SaveResult>();
        Map<String,MasterWarehouseWrapper> selectedRecordsMap = new Map<String,MasterWarehouseWrapper>();
        if(!masterWarehouseWrapperList.isEmpty()){
            for(MasterWarehouseWrapper wrap : masterWarehouseWrapperList){
                if(wrap.isSelected && wrap.latestDetailRecordId != null){
                    WU_Warehouse_Capacity_Detail__c wcdToUpdate = new WU_Warehouse_Capacity_Detail__c();
                    system.debug('::::latestDetailRecordId after update clicked'+wrap.latestDetailRecordId);
                    system.debug('::::latestDetailRecordName after update clicked'+wrap.latestDetailRecordName);
                    wcdToUpdate.Id = wrap.latestDetailRecordId;
                    wcdToUpdate.WU_Utilization_Start_Date__c = wrap.objWUMasterWarehouse.WU_FromDate__c;
                    wcdToUpdate.WU_Utilization_End_Date__c = wrap.objWUMasterWarehouse.WU_ToDate__c;
                    wcdToUpdate.WU_Utilization_Type__c = wrap.objWUMasterWarehouse.WU_Utilization_Type__c;
                    wcdToUpdate.WU_Current_Pallet_Utilization__c = wrap.objWUMasterWarehouse.WU_Current_Utilization__c;
                    capacityDetailToUpdateList.add(wcdToUpdate);
                    if(selectedRecordsMap!=null && !selectedRecordsMap.containsKey(wrap.latestDetailRecordId)){
                        selectedRecordsMap.put(wrap.latestDetailRecordId,wrap);
                    }
                    
                }
            }
            
            if(!capacityDetailToUpdateList.isEmpty()){
                WU_CreateCapacityDetails.isFromMultipleScreen = true;
                try{
                    updateDetailsResult = Database.update(capacityDetailToUpdateList,false);
                    String finalSuccessRecords = 'Success for records :';
                    String finalErrorRecords = 'Failed Records are :  ' ;
                    Boolean isSuccess=false;
                    Boolean isFailure=false;

                    if(!updateDetailsResult.isEmpty()){
                        for(Integer i=0;i<updateDetailsResult.size();i++){
                            if (updateDetailsResult.get(i).isSuccess()){
                                isSuccess = true;
                                if(selectedRecordsMap.containsKey(updateDetailsResult.get(i).getId())){
                                    finalSuccessRecords = finalSuccessRecords + EmptySpace +selectedRecordsMap.get(updateDetailsResult.get(i).getId()).objWUMasterWarehouse.Name;
                                }
                            }
                            else if (!updateDetailsResult.get(i).isSuccess()){
                                isFailure = true;
                                system.debug('::::::::In errorss');
                                //Database.Error error1 = updateDetailsResult.get(i).getErrors().get(0);
                                //system.debug(':::New debug:::::Final error'+error1);
                                if(selectedRecordsMap.containsKey(capacityDetailToUpdateList.get(i).Id)){
                                    system.debug('::::::::In map to fetch error');
                                    Database.Error error = updateDetailsResult.get(i).getErrors().get(0);
                                    system.debug('::::::::Final error'+error);
                                    //finalErrorRecords = finalErrorRecords + selectedRecordsMap.get(capacityDetailToUpdateList.get(i).Id).masterName + EmptySpace + 'Failed due to error'+EmptySpace+error.getMessage();
                                    finalErrorRecords = finalErrorRecords + EmptySpace +selectedRecordsMap.get(capacityDetailToUpdateList.get(i).Id).objWUMasterWarehouse.Name + EmptySpace + 'Failed due to error :- '+EmptySpace+error.getMessage()+'<br></br>';
                                    //finalErrorRecords = finalErrorRecords + EmptySpace +selectedRecordsMap.get(capacityDetailToUpdateList.get(i).Id).objWUMasterWarehouse.Name+ EmptySpace ;
                                    system.debug('::::::::Error string error'+finalErrorRecords); 
                                }
                            }
                        }
                        if(isSuccess){
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,finalSuccessRecords));
                        }
                        if(isFailure){
                            //finalErrorRecords = finalErrorRecords + ' Records Failed due to Error';
                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,finalErrorRecords));
                        }
                    }
                }
                catch(exception ex){
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Some exception occurred'));
                }
            }
            else {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select a record'));
            }
        }
        //populateMasterList();
        refresh();
    }
    
    Public pagereference saveRecords(){
        system.debug('====In Save Method====');
        system.debug('====wrapperInstancePopup===='+ wrapperInstancePopup);
                 
        if(selectedRecords == 'selectAllRecords' ){
            for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
                if(objMasterWarehouseWrapper.isSelected || objMasterWarehouseWrapper.objWUMasterWarehouse.Id == selectedId ){
                    if(selectedField == 'startdate'){
                        objMasterWarehouseWrapper.objWUMasterWarehouse.WU_FromDate__c = wrapperInstancePopup.objWUMasterWarehouse.WU_FromDate__c ;
                    }else if(selectedField == 'enddate'){
                        objMasterWarehouseWrapper.objWUMasterWarehouse.WU_ToDate__c = wrapperInstancePopup.objWUMasterWarehouse.WU_ToDate__c ;
                    }
                    objMasterWarehouseWrapper.isSelected = TRUE;
                }
            }
        }else if(selectedRecords == 'SelectSingleRecord'){
            system.debug('====In SelectSingleRecord Method====');
            system.debug('====selectedId ===='+ selectedId );
            for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
                
                if(objMasterWarehouseWrapper.objWUMasterWarehouse.Id == selectedId ){
                    system.debug('=====objMasterWarehouseWrapper.objWUMasterWarehouse.Id======'+ objMasterWarehouseWrapper.objWUMasterWarehouse.Id );
                    if(selectedField == 'startdate'){
                        objMasterWarehouseWrapper.objWUMasterWarehouse.WU_FromDate__c = wrapperInstancePopup.objWUMasterWarehouse.WU_FromDate__c ;
                        system.debug('======objMasterWarehouseWrapper.objWUMasterWarehouse.WU_FromDate__c======'+ objMasterWarehouseWrapper.objWUMasterWarehouse.WU_FromDate__c);
                    }else if(selectedField == 'enddate'){
                        objMasterWarehouseWrapper.objWUMasterWarehouse.WU_ToDate__c = wrapperInstancePopup.objWUMasterWarehouse.WU_ToDate__c ;
                    }
                }
            }
        }
        return null;
    }
    
    public void setfieldstopopup(){
        for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
            if( objMasterWarehouseWrapper.objWUMasterWarehouse.Id == selectedId ){
                WU_Master_Warehouse__c objMasterWarehose = new WU_Master_Warehouse__c();
                if(selectedField == 'startdate'){
                    objMasterWarehose.WU_FromDate__c = objMasterWarehouseWrapper.objWUMasterWarehouse.WU_FromDate__c ;
                }else if(selectedField == 'enddate'){
                    objMasterWarehose.WU_ToDate__c = objMasterWarehouseWrapper.objWUMasterWarehouse.WU_ToDate__c ;
                }
                wrapperInstancePopup = new MasterWarehouseWrapper(objMasterWarehouseWrapper.isSelected ,objMasterWarehose ); 
            }
        }
    }
    
    public List<SelectOption> getItems() {
        Integer selectedRecordCount = 0;
        for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
            if(objMasterWarehouseWrapper.isSelected || objMasterWarehouseWrapper.objWUMasterWarehouse.Id == selectedId ){
                objMasterWarehouseWrapper.isSelected = TRUE;
                selectedRecordCount = selectedRecordCount +1;
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('selectAllRecords','Apply to selected '+selectedRecordCount +' Records'));
        options.add(new SelectOption( 'SelectSingleRecord','Apply to this record Alone'));
        return options;
    }
    
    public void refresh(){
        masterWarehouseWrapperList.clear();
        fetchLatestRecords();
        populateMasterList();
    }
    
    public class MasterWarehouseWrapper{
        public Boolean isSelected{get;set;}
        public WU_Master_Warehouse__c objWUMasterWarehouse{get;set;}
        public string latestDetailRecordId{get;set;}
        public string latestDetailRecordName{get;set;}
        public MasterWarehouseWrapper(Boolean isSelected , WU_Master_Warehouse__c objWUMasterWarehouse ){
            this.isSelected = isSelected;
            this.objWUMasterWarehouse = objWUMasterWarehouse;
        }
    }
    
    Public pagereference cancel(){
        return null;
    }
}