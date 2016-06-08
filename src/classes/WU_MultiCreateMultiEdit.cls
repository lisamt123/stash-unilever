public class WU_MultiCreateMultiEdit 
{
    public String loggedInUser;
    public List<WU_Master_Warehouse__c> masterWarehouseList {get;set;}
    public List<MasterWarehouseWrapper> masterWarehouseWrapperList {get;set;}
    public MasterWarehouseWrapper wrapperInstance;
    public String actionPerform{get;set;}
    
    public WU_Master_Warehouse__c warehouseObj;
    public string selectedId{get;set;}
    public string selectedField{get;set;}
    public string selectedRecords{get;set;}
    public MasterWarehouseWrapper wrapperInstancePopup{get;set;}
    
    
    public WU_MultiCreateMultiEdit()
    {
        
        loggedInUser = UserInfo.getUserId();
        masterWarehouseList = new List<WU_Master_Warehouse__c>();
        masterWarehouseWrapperList = new List<MasterWarehouseWrapper>();
        
        wrapperInstancePopup = new MasterWarehouseWrapper();
        
        
        fetchLatestRecords();
        populateMasterList();               
                       
    }
    
    public void fetchLatestRecords()
    {
        masterWarehouseList = [SELECT Id,
                                    Name,
                                    WU_Committed_Max_PalletStorage__c,
                                    WU_Current_Utilization__c,
                                    WU_SAPCode_s__c,
                                    WU_SAPName_s__c,
                                    WU_ToDate__c,
                                    WU_FromDate__c,
                                    WU_Utilization_Type__c,
                                    OwnerId,
                                    (Select id,Name,Master_Warehouse__c,WU_Utilization_End_Date__c,WU_Utilization_Start_Date__c,WU_Current_Pallet_Utilization__c,WU_Committed_Max_PalletStorage__c FROM Warehouse_Capacity_Utilizaion__r)
                                    FROM WU_Master_Warehouse__c where OwnerId = :loggedInUser];
    }
    
    public void populateMasterList()
    {
        //if(!masterWarehouseList.isEmpty())
        //{
            for(WU_Master_Warehouse__c master : masterWarehouseList)
            {
                wrapperInstance = new MasterWarehouseWrapper();
                wrapperInstance.masterWHId = master.Id;
                wrapperInstance.masterName = master.Name;
                wrapperInstance.committedPallet = master.WU_Committed_Max_PalletStorage__c;
                wrapperInstance.currentUtilization = master.WU_Current_Utilization__c;
                wrapperInstance.sapCode = master.WU_SAPCode_s__c;
                wrapperInstance.sapName = master.WU_SAPName_s__c;
                wrapperInstance.endDate = master.WU_ToDate__c;
                wrapperInstance.startDate = master.WU_FromDate__c;
                wrapperInstance.utilizationTypeList = fetchUtilizationType();
                wrapperInstance.selectedUtilizationType = master.WU_Utilization_Type__c;
                if(!master.Warehouse_Capacity_Utilizaion__r.isEmpty())
                {
                    for(WU_Warehouse_Capacity_Detail__c wcd : master.Warehouse_Capacity_Utilizaion__r)
                    {
                        if(master.WU_FromDate__c==wcd.WU_Utilization_Start_Date__c && master.WU_ToDate__c==wcd.WU_Utilization_End_Date__c)
                        {
                            wrapperInstance.latestDetailRecordId = wcd.Id;
                            wrapperInstance.latestDetailRecordName = wcd.Name;
                            system.debug('::::latestDetailRecordId at first fetch'+wrapperInstance.latestDetailRecordId);
                            system.debug('::::latestDetailRecordName at first fetch'+wrapperInstance.latestDetailRecordName);
                        }
                    }
                    
                }
                masterWarehouseWrapperList.add(wrapperInstance);
                
            }
        //}            
        
    }
    
    public void refresh()
    {
        masterWarehouseWrapperList.clear();
        fetchLatestRecords();
        populateMasterList();
        
    }
    
        
    
    public List<SelectOption> fetchUtilizationType()
    {
        List<SelectOption> options = new List<SelectOption>(); 
        List<String> typeList = new List<String>();
        WU_UtilizationType__c typeInstance =  WU_UtilizationType__c.getInstance('UtilizationType');
        if(typeInstance != null)
        {
            String typeStr = typeInstance.Type__c;
            typeList =  typeStr.split(';');
            for(String str : typeList)
            {
                options.add(new SelectOption( str.trim(),str.trim()));
            }
        }
        return options;
    }
    
        
    public void createNewCapacityDetails()
    {
        List<WU_Master_Warehouse__c> toUpdateList = new List<WU_Master_Warehouse__c>();
        List<Database.SaveResult> updateMasterResult = new List<Database.SaveResult>();
        Map<String,MasterWarehouseWrapper> selectedMasterRecordsMap = new Map<String,MasterWarehouseWrapper>();
        //if(!masterWarehouseWrapperList.isEmpty())
        //{
            for(MasterWarehouseWrapper wrap : masterWarehouseWrapperList)
            {
                if(wrap.checkbox)
                {
                    WU_Master_Warehouse__c masterWH = new WU_Master_Warehouse__c();
                    masterWH.Id = wrap.masterWHId;
                    masterWH.WU_FromDate__c = wrap.startDate;
                    masterWH.WU_ToDate__c = wrap.endDate;
                    masterWH.WU_Utilization_Type__c = wrap.selectedUtilizationType;
                    masterWH.WU_Current_Utilization__c = wrap.currentUtilization;
                    toUpdateList.add(masterWH);
                    if(selectedMasterRecordsMap!=null && !selectedMasterRecordsMap.containsKey(wrap.masterWHId))
                    {
                        selectedMasterRecordsMap.put(wrap.masterWHId,wrap);
                    }
                }
            }
            if(!toUpdateList.isEmpty())
            {
                WU_CreateCapacityDetails.isFromMultipleScreen = true;
                try
                {
                    updateMasterResult = Database.update(toUpdateList,false);
                    String finalSuccessMessage = 'Success for records :';
                    String finalErrorMessage = 'Failed records are : ';
                    Boolean isMasterSuccess=false;
                    Boolean isMasterFailure=false;
                    
                    //if(!updateMasterResult.isEmpty())
                    //{
                        for(Integer i=0;i<updateMasterResult.size();i++)
                        {

                                            if (updateMasterResult.get(i).isSuccess())
                                            {
                                                isMasterSuccess = true;
                                                if(selectedMasterRecordsMap.containsKey(updateMasterResult.get(i).getId()))
                                                {
                                                        finalSuccessMessage = finalSuccessMessage + ' ' +selectedMasterRecordsMap.get(updateMasterResult.get(i).getId()).masterName;
                                                }
                                            }
                                            
                                            else if (!updateMasterResult.get(i).isSuccess())
                                            {
                                                isMasterFailure = true;
                                                system.debug('::::::::In Master errorss');
                                                if(selectedMasterRecordsMap.containsKey(toUpdateList.get(i).Id))
                                                {
                                                        system.debug('::::::::In MAster map to fetch error');
                                                        Database.Error MasterError = updateMasterResult.get(i).getErrors().get(0);
                                                        system.debug('::::::::Final Master error'+MasterError);
                                                        //finalErrorMessage = finalErrorMessage + selectedMasterRecordsMap.get(toUpdateList.get(i).Id).masterName +' ' + 'Failed due to error'+' '+MasterError.getMessage();
                                                        finalErrorMessage = finalErrorMessage +' '+selectedMasterRecordsMap.get(toUpdateList.get(i).Id).masterName;
                                                        system.debug('::::::::Error string error'+finalErrorMessage);
                                                }
                                                
                                            }
                                
                                        }
                                        if(isMasterSuccess)
                                        {
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,finalSuccessMessage));
                                        }
                                        if(isMasterFailure)
                                        {
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,finalErrorMessage));
                                        }
                    //}
                }
                catch(exception ex)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Some exception occurred'));
                }
                
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select a record'));
            }
        //}
        
        refresh();
        
        //populateMasterList();
        
    }
    
    public void updateLatestCapacityDetails()
    {
        List<WU_Warehouse_Capacity_Detail__c> capacityDetailToUpdateList = new List<WU_Warehouse_Capacity_Detail__c>();
        List<Database.SaveResult> updateDetailsResult = new List<Database.SaveResult>();
        Map<String,MasterWarehouseWrapper> selectedRecordsMap = new Map<String,MasterWarehouseWrapper>();
        
        if(!masterWarehouseWrapperList.isEmpty())
        {
            for(MasterWarehouseWrapper wrap : masterWarehouseWrapperList)
            {
                if(wrap.checkbox && wrap.latestDetailRecordId!=null)
                {
                    WU_Warehouse_Capacity_Detail__c wcdToUpdate = new WU_Warehouse_Capacity_Detail__c();
                    system.debug('::::latestDetailRecordId after update clicked'+wrap.latestDetailRecordId);
                    system.debug('::::latestDetailRecordName after update clicked'+wrap.latestDetailRecordName);
                    wcdToUpdate.Id = wrap.latestDetailRecordId;
                    wcdToUpdate.WU_Utilization_Start_Date__c = wrap.startDate;
                    wcdToUpdate.WU_Utilization_End_Date__c = wrap.endDate;
                    wcdToUpdate.WU_Utilization_Type__c = wrap.selectedUtilizationType;
                    wcdToUpdate.WU_Current_Pallet_Utilization__c = wrap.currentUtilization;
                    capacityDetailToUpdateList.add(wcdToUpdate);
                    if(selectedRecordsMap!=null && !selectedRecordsMap.containsKey(wrap.latestDetailRecordId))
                    {
                        selectedRecordsMap.put(wrap.latestDetailRecordId,wrap);
                    }
                }
            }
            if(!capacityDetailToUpdateList.isEmpty())
            {
                WU_CreateCapacityDetails.isFromMultipleScreen = true;
                try
                {
                    updateDetailsResult = Database.update(capacityDetailToUpdateList,false);
                    String finalSuccessRecords = 'Success for records :';
                    String finalErrorRecords = 'Failed records are : ';
                    Boolean isSuccess=false;
                    Boolean isFailure=false;
                    
                    if(!updateDetailsResult.isEmpty())
                    {
                        for(Integer i=0;i<updateDetailsResult.size();i++)
                        {

                                            if (updateDetailsResult.get(i).isSuccess())
                                            {
                                                isSuccess = true;
                                                if(selectedRecordsMap.containsKey(updateDetailsResult.get(i).getId()))
                                                {
                                                        finalSuccessRecords = finalSuccessRecords + ' ' +selectedRecordsMap.get(updateDetailsResult.get(i).getId()).masterName;
                                                }
                                            }
                                            
                                            else if (!updateDetailsResult.get(i).isSuccess())
                                            {
                                                isFailure = true;
                                                system.debug('::::::::In errorss');
                                                //Database.Error error1 = updateDetailsResult.get(i).getErrors().get(0);
                                                //system.debug(':::New debug:::::Final error'+error1);
                                                if(selectedRecordsMap.containsKey(capacityDetailToUpdateList.get(i).Id))
                                                {
                                                        system.debug('::::::::In map to fetch error');
                                                        Database.Error error = updateDetailsResult.get(i).getErrors().get(0);
                                                        system.debug('::::::::Final error'+error);
                                                        //finalErrorRecords = finalErrorRecords + selectedRecordsMap.get(capacityDetailToUpdateList.get(i).Id).masterName +' ' + 'Failed due to error'+' '+error.getMessage();
                                                        finalErrorRecords = finalErrorRecords + ' '+selectedRecordsMap.get(capacityDetailToUpdateList.get(i).Id).masterName;
                                                        system.debug('::::::::Error string error'+finalErrorRecords); 
                                                }
                                                
                                            }
                                
                                        }
                                        if(isSuccess)
                                        {
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,finalSuccessRecords));
                                        }
                                        if(isFailure)
                                        {
                                                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,finalErrorRecords));
                                        }
                                        
                                        
                        
                    }
                }
                catch(exception ex)
                {
                    ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Some exception occurred'));
                }
                
            }
            else
            {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,'Please Select a record'));
            }
        }
        //populateMasterList();
        refresh();
    }
    
    public class MasterWarehouseWrapper
    {
        public Boolean checkbox {get;set;}
        public String masterName {get;set;}
        public String masterWHId {get;set;}
        public Decimal committedPallet {get;set;}
        public Decimal currentUtilization {get;set;}
        public String sapCode {get;set;}
        public String sapName {get;set;}
        public Date endDate {get;set;}
        public Date startDate {get;set;}
        public List<SelectOption> utilizationTypeList {get;set;}
        public String selectedUtilizationType {get;set;}
        
        public String latestDetailRecordId {get;set;}
        public String latestDetailRecordName {get;set;}
        
        public MasterWarehouseWrapper()
        {
            checkbox = false;
            utilizationTypeList = new List<SelectOption>();
            latestDetailRecordId = null;
        }
    }
    
    Public pagereference saveRecords(){
        if(selectedRecords == 'selectAllRecords' ){
            for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
                if(objMasterWarehouseWrapper.checkbox || objMasterWarehouseWrapper.masterWHId == selectedId ){
                    if(selectedField == 'utiltype'){
                        objMasterWarehouseWrapper.selectedUtilizationType = wrapperInstancePopup.selectedUtilizationType ;
                    }else if(selectedField == 'startdate'){
                        objMasterWarehouseWrapper.startDate = wrapperInstancePopup.startDate ;
                    }else if(selectedField == 'enddate'){
                        objMasterWarehouseWrapper.endDate = wrapperInstancePopup.endDate ;
                    }else if(selectedField == 'utilamt'){
                        objMasterWarehouseWrapper.currentUtilization = wrapperInstancePopup.currentUtilization ;
                    }
                    objMasterWarehouseWrapper.checkbox = TRUE;
                }
            }
        }else if(selectedRecords == 'SelectSingleRecord'){
            for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
                if(objMasterWarehouseWrapper.masterWHId == selectedId ){
                    if(selectedField == 'utiltype'){
                        objMasterWarehouseWrapper.selectedUtilizationType = wrapperInstancePopup.selectedUtilizationType ;
                    }else if(selectedField == 'startdate'){
                        objMasterWarehouseWrapper.startDate = wrapperInstancePopup.startDate ;
                    }else if(selectedField == 'enddate'){
                        objMasterWarehouseWrapper.endDate = wrapperInstancePopup.endDate ;
                    }else if(selectedField == 'utilamt'){
                        objMasterWarehouseWrapper.currentUtilization = wrapperInstancePopup.currentUtilization ;
                    }
                }
            }
        
        }
        return null;
    }

    Public pagereference cancel(){
        return null;
    }
    
    public void setfieldstopopup(){
            /*
            warehouseObj = [SELECT Id,Name,WU_Committed_Max_PalletStorage__c,WU_Current_Utilization__c,WU_SAPCode_s__c,WU_SAPName_s__c,WU_ToDate__c,WU_FromDate__c,
                            WU_Utilization_Type__c,OwnerId,WU_Total_Utilization__c FROM WU_Master_Warehouse__c where id = :selectedId];
                            
            wrapperInstancePopup = new MasterWarehouseWrapper(); 
            wrapperInstancePopup.masterWHId = warehouseObj.Id;
            wrapperInstancePopup.masterName = warehouseObj.Name;
            wrapperInstancePopup.committedPallet = warehouseObj.WU_Committed_Max_PalletStorage__c;
            wrapperInstancePopup.currentUtilization = warehouseObj.WU_Current_Utilization__c;
            wrapperInstancePopup.sapCode = warehouseObj.WU_SAPCode_s__c;
            wrapperInstancePopup.sapName = warehouseObj.WU_SAPName_s__c;
            wrapperInstancePopup.endDate = warehouseObj.WU_ToDate__c;
            wrapperInstancePopup.startDate = warehouseObj.WU_FromDate__c;
            wrapperInstancePopup.utilizationTypeList = fetchUtilizationType();
            wrapperInstancePopup.selectedUtilizationType = warehouseObj.WU_Utilization_Type__c;
            */
            wrapperInstancePopup = new MasterWarehouseWrapper(); 
            for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
            if( objMasterWarehouseWrapper.masterWHId == selectedId ){
                wrapperInstancePopup.masterWHId = objMasterWarehouseWrapper.masterWHId ;
                wrapperInstancePopup.masterName = objMasterWarehouseWrapper.masterName ;
                wrapperInstancePopup.committedPallet = objMasterWarehouseWrapper.committedPallet ;
                wrapperInstancePopup.currentUtilization = objMasterWarehouseWrapper.currentUtilization ;
                wrapperInstancePopup.sapCode = objMasterWarehouseWrapper.sapCode ;
                wrapperInstancePopup.sapName = objMasterWarehouseWrapper.sapName ;
                wrapperInstancePopup.endDate = objMasterWarehouseWrapper.endDate ;
                wrapperInstancePopup.startDate = objMasterWarehouseWrapper.startDate ;
                wrapperInstancePopup.utilizationTypeList = objMasterWarehouseWrapper.utilizationTypeList ;
                wrapperInstancePopup.selectedUtilizationType = objMasterWarehouseWrapper.selectedUtilizationType ;   
            }
        }
            
    }
    
    public List<SelectOption> getItems() {
        Integer selectedRecordCount = 0;
        for(MasterWarehouseWrapper objMasterWarehouseWrapper : masterWarehouseWrapperList){
            if(objMasterWarehouseWrapper.checkbox || objMasterWarehouseWrapper.masterWHId == selectedId ){
                objMasterWarehouseWrapper.checkbox = TRUE;
                selectedRecordCount = selectedRecordCount +1;
            }
        }
        List<SelectOption> options = new List<SelectOption>();
        options.add(new SelectOption('selectAllRecords','Apply to selected '+selectedRecordCount +' Records'));
        options.add(new SelectOption( 'SelectSingleRecord','Apply to this record Alone'));
        return options;
    }
    
}