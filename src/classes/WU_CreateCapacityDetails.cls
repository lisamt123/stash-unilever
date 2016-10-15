public class WU_CreateCapacityDetails 
{
    public static Boolean isFromMultipleScreen = false;
    public Set<String> masterWarehouseIdSet;
    public List<WU_Master_Warehouse__c> masterWarehouseList;
    public WU_Warehouse_Capacity_Detail__c warehouseCapacityDetail;
    public List<WU_Warehouse_Capacity_Detail__c> warehouseCapacityDetailListToInsert;
    
    
    public WU_CreateCapacityDetails()
    {
        masterWarehouseIdSet = new Set<String>(); 
        masterWarehouseList = new List<WU_Master_Warehouse__c>();
        warehouseCapacityDetailListToInsert = new List<WU_Warehouse_Capacity_Detail__c>();
    }

    //@InvocableMethod
    public void checkInsertRecordOrDisplayError(List<WU_Master_Warehouse__c> updatedMasterWarehouses, Map<Id, WU_Master_Warehouse__c> masterMap, Map<Id, WU_Master_Warehouse__c> masterMapOld) 
    {
        //Set<String> masterWarehouseIdSet = new Set<String>();       
        //List<WU_Master_Warehouse__c> masterWarehouseList = new List<WU_Master_Warehouse__c>();
        //WU_Warehouse_Capacity_Detail__c warehouseCapacityDetail;
        //List<WU_Warehouse_Capacity_Detail__c> warehouseCapacityDetailListToInsert = new List<WU_Warehouse_Capacity_Detail__c>();
        
        for(Id masterId : masterMap.keySet())
        {
            if((masterMapOld.get( masterId ).WU_FromDate__c != masterMap.get( masterId ).WU_FromDate__c )
                    ||(masterMapOld.get( masterId ).WU_ToDate__c != masterMap.get( masterId ).WU_ToDate__c )
                    ||(masterMapOld.get( masterId ).WU_Current_Utilization__c != masterMap.get( masterId ).WU_Current_Utilization__c )
                    ||(masterMapOld.get( masterId ).WU_Utilization_Type__c != masterMap.get( masterId ).WU_Utilization_Type__c )
              )
              {
                masterWarehouseIdSet.add(masterId);
              }
        }
        
        fetchRecordDetails();
        checkDetailsRecords(masterMap);
        
        if(!warehouseCapacityDetailListToInsert.isEmpty())
            {
                WU_SetWarehousePOCHandler.isInserted = true;
                insert warehouseCapacityDetailListToInsert;
            }
    }
   
   public void fetchRecordDetails()
   {
        if(!masterWarehouseIdSet.isEmpty())
            {
                masterWarehouseList = [Select id, 
                                            name,
                                            WU_Committed_Max_PalletStorage__c,
                                            WU_Current_Utilization__c,
                                            WU_ToDate__c,
                                            WU_FromDate__c,
                                            WU_Utilization_Type__c,
                                            (Select id,WU_Utilization_End_Date__c,WU_Utilization_Start_Date__c,WU_Utilization_Type__c,Is_In_Current_Month__c from Warehouse_Capacity_Utilizaion__r )
                                            From WU_Master_Warehouse__c
                                            where id in :masterWarehouseIdSet];
            
            }
   }
   
   public void checkDetailsRecords(Map<Id, WU_Master_Warehouse__c> masterMap)
   {
        //if(!masterWarehouseList.isEmpty())
            //{
                for(WU_Master_Warehouse__c masterWH : masterWarehouseList)
                {
                    boolean isDetailExist = false;
                    system.debug('Iterating on master list');
                        if(!masterWH.Warehouse_Capacity_Utilizaion__r.isEmpty())
                        {
                            system.debug('Iterating on detail list');
                            for(WU_Warehouse_Capacity_Detail__c wcd : masterWH.Warehouse_Capacity_Utilizaion__r)
                            {
                                system.debug('::::::::::In For');
                                if(wcd.WU_Utilization_Start_Date__c==masterWH.WU_FromDate__c && wcd.WU_Utilization_End_Date__c ==  masterWH.WU_ToDate__c 
                                    && masterMap!=null && masterMap.containsKey(masterWH.Id))
                                {
                                    system.debug('Dates match');
                                    system.debug('wcd.WU_Utilization_Start_Date__c'+wcd.WU_Utilization_Start_Date__c);
                                    system.debug('masterWH.WU_FromDate__c'+masterWH.WU_FromDate__c);
                                    system.debug('wcd.WU_Utilization_End_Date__c'+wcd.WU_Utilization_End_Date__c);
                                    system.debug('masterWH.WU_ToDate__c'+masterWH.WU_ToDate__c);
                                    isDetailExist = true;
                                    //if(masterMap!=null && masterMap.containsKey(masterWH.Id))
                                    //{
                                        try
                                        {
                                            system.debug('In Try.....');
                                            masterMap.get(masterWH.Id).addError(Label.WU_DuplicateCapacityDetailWhileInsert);
                                        }
                                        catch(exception ex)
                                        {
                                            system.debug('In Catch.....'+ex.getMessage());
                                        }
                                   // }
                                }
                                
                                else if(wcd.WU_Utilization_Start_Date__c.Month()==masterWH.WU_FromDate__c.Month() 
                                    && wcd.WU_Utilization_Start_Date__c.Year()==masterWH.WU_FromDate__c.Year()
                                    && masterWH.WU_Utilization_Type__c!=wcd.WU_Utilization_Type__c
                                    //&& wcd.Is_In_Current_Month__c
                                    && masterMap!=null && masterMap.containsKey(masterWH.Id)
                                  )
                                  {
                                    isDetailExist = true;
                                    //if(masterMap!=null && masterMap.containsKey(masterWH.Id))
                                    //{
                                        system.debug(':::::::Utilization Type of master'+masterWH.WU_Utilization_Type__c+'::::::Of Detail'+wcd.WU_Utilization_Type__c);
                                        try
                                        {
                                        masterMap.get(masterWH.Id).addError(Label.WU_utilizationTypeCannotChange);
                                        }
                                        catch(exception ex)
                                        {
                                            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Error,Label.WU_utilizationTypeCannotChange));
                                        }
                                        break;
                                    //}   
                                  }
                            }
                        }
                    
                    if(!isDetailExist)
                    {
                        warehouseCapacityDetail = new WU_Warehouse_Capacity_Detail__c();
                        warehouseCapacityDetail.Master_Warehouse__c = masterWH.id;
                        warehouseCapacityDetail.WU_Committed_Max_PalletStorage__c = masterWH.WU_Committed_Max_PalletStorage__c;
                        warehouseCapacityDetail.WU_Current_Pallet_Utilization__c = masterWH.WU_Current_Utilization__c;
                        warehouseCapacityDetail.WU_Utilization_End_Date__c = masterWH.WU_ToDate__c;
                        warehouseCapacityDetail.WU_Utilization_Start_Date__c = masterWH.WU_FromDate__c;
                        warehouseCapacityDetail.WU_Utilization_Type__c = masterWH.WU_Utilization_Type__c;
                        warehouseCapacityDetailListToInsert.add(warehouseCapacityDetail); 
                    }
                }
            //}
   }
}