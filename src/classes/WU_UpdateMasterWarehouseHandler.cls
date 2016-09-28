/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     Handler class for trigger WU_SetWarehousePOC
*************************************************************/
public with sharing class WU_UpdateMasterWarehouseHandler{

    private static Set<Id> setMasterWarehouseIds;
    public static Boolean isUpdateFromChild = false;
    
    private WU_UpdateMasterWarehouseHandler()
    {
        
    }
   
    
    public static void onAfterUpdate(Map<Id, WU_Warehouse_Capacity_Detail__c> oldMapItems,List<WU_Warehouse_Capacity_Detail__c> updatedItems, Map<Id, WU_Warehouse_Capacity_Detail__c> newMapItems) {
        setMasterWarehouseIds = new Set<Id>();
        List<WU_Master_Warehouse__c> masterWarehouseList = new List<WU_Master_Warehouse__c>();
        List<WU_Master_Warehouse__c> masterWarehouseListToUpdate = new List<WU_Master_Warehouse__c>();
        List<WU_Warehouse_Capacity_Detail__c> currentMonthCapacityList;
        List<WU_Warehouse_Capacity_Detail__c> pastOrFutureMonthCapacityList;
        for(WU_Warehouse_Capacity_Detail__c wcd : updatedItems)
        {
            setMasterWarehouseIds.add(wcd.Master_Warehouse__c);
        }
        if(!setMasterWarehouseIds.isEmpty())
        {
            masterWarehouseList = [SELECT id,
                                     WU_Current_Utilization__c,
                                     WU_FromDate__c,
                                     WU_ToDate__c,
                                     WU_Utilization_Type__c,
                                     WU_Latest_Committed_Pallet__c,
                                     (Select id,WU_Utilization_End_Date__c,WU_Utilization_Start_Date__c,WU_Committed_Max_PalletStorage__c,WU_Current_Pallet_Utilization__c,WU_Utilization_Type__c,Is_In_Current_Month__c FROM Warehouse_Capacity_Utilizaion__r ORDER BY WU_Utilization_Start_Date__c DESC)
                                     FROM WU_Master_Warehouse__c
                                     WHERE Id IN :setMasterWarehouseIds];
        }
        
        
        
        for(WU_Master_Warehouse__c master : masterWarehouseList)
        {
            currentMonthCapacityList = new List<WU_Warehouse_Capacity_Detail__c>();
            pastOrFutureMonthCapacityList = new List<WU_Warehouse_Capacity_Detail__c>();
            
            for(WU_Warehouse_Capacity_Detail__c details : master.Warehouse_Capacity_Utilizaion__r)
            {           
                
                if(details.Is_In_Current_Month__c)
                {
                    currentMonthCapacityList.add(details);
                }
                else
                {
                    pastOrFutureMonthCapacityList.add(details);
                }
            }
            if(!currentMonthCapacityList.isEmpty())
            {
                master.WU_Current_Utilization__c = currentMonthCapacityList[0].WU_Current_Pallet_Utilization__c;
                master.WU_FromDate__c = currentMonthCapacityList[0].WU_Utilization_Start_Date__c;
                master.WU_ToDate__c = currentMonthCapacityList[0].WU_Utilization_End_Date__c;
                master.WU_Utilization_Type__c = currentMonthCapacityList[0].WU_Utilization_Type__c;
                master.WU_Latest_Committed_Pallet__c = currentMonthCapacityList[0].WU_Committed_Max_PalletStorage__c;
                masterWarehouseListToUpdate.add(master);
            }
            else if(!pastOrFutureMonthCapacityList.isEmpty())
            {
                master.WU_Current_Utilization__c = pastOrFutureMonthCapacityList[0].WU_Current_Pallet_Utilization__c;
                master.WU_FromDate__c = pastOrFutureMonthCapacityList[0].WU_Utilization_Start_Date__c;
                master.WU_ToDate__c = pastOrFutureMonthCapacityList[0].WU_Utilization_End_Date__c;
                master.WU_Utilization_Type__c = pastOrFutureMonthCapacityList[0].WU_Utilization_Type__c;
                master.WU_Latest_Committed_Pallet__c = pastOrFutureMonthCapacityList[0].WU_Committed_Max_PalletStorage__c;
                masterWarehouseListToUpdate.add(master);
            }
            
            
        }
        
        
        
           
        if(!masterWarehouseListToUpdate.isEmpty())
        {
            //isUpdateFromChild = true;
            
            try
            {
                WU_warehousUtility.isTrggerExecuted = TRUE;
                //database.update(masterWarehouseListToUpdate,false);
                update masterWarehouseListToUpdate;
            }
            catch(exception ex)
            {
                system.debug(':::::::::exception is::'+ex);
                
            }
            
        }
       
        
        
        
                
    }
    
     public static void onBeforeUpdate(list<WU_Warehouse_Capacity_Detail__c> lstWareHouseCapacity) {
        
        set<string> setMasterWareHouseId = new set<string>();
        Map<string,List<WU_Warehouse_Capacity_Detail__c>> mapWUWarehouseCapacityDetail = new Map<string,List<WU_Warehouse_Capacity_Detail__c>>();
        
        for(WU_Warehouse_Capacity_Detail__c objWUWarehouseCapacityDetail : lstWareHouseCapacity){
            setMasterWareHouseId.add(objWUWarehouseCapacityDetail.Master_Warehouse__c);
        }
        
        list<WU_Warehouse_Capacity_Detail__c> lstWareHouseCapacityExisting  = [select id,WU_Utilization_Start_Date__c,WU_Utilization_End_Date__c,Master_Warehouse__c,WU_Utilization_Type__c
                                                                               FROM WU_Warehouse_Capacity_Detail__c Where Master_Warehouse__c IN :setMasterWareHouseId];
                                                                               
        for(WU_Warehouse_Capacity_Detail__c objWUWarehouseCapacityDetail : lstWareHouseCapacityExisting){
            if(mapWUWarehouseCapacityDetail.containsKey(objWUWarehouseCapacityDetail.Master_Warehouse__c ) ){
                mapWUWarehouseCapacityDetail.get(objWUWarehouseCapacityDetail.Master_Warehouse__c).add(objWUWarehouseCapacityDetail );
            }
            else{
                list<WU_Warehouse_Capacity_Detail__c> lstCapDetails = new list<WU_Warehouse_Capacity_Detail__c>();
                lstCapDetails.add(objWUWarehouseCapacityDetail);
                mapWUWarehouseCapacityDetail.put(objWUWarehouseCapacityDetail.Master_Warehouse__c ,lstCapDetails );
                
            }
        }
        
        for(WU_Warehouse_Capacity_Detail__c objWUWarehouseCapacityDetail : lstWareHouseCapacity){
            if( mapWUWarehouseCapacityDetail.containsKey(objWUWarehouseCapacityDetail.Master_Warehouse__c)){
                String UtilizationType='';
                Boolean isUtilizationTypeFound = False;
                for( WU_Warehouse_Capacity_Detail__c objWCDExisting : mapWUWarehouseCapacityDetail.get(objWUWarehouseCapacityDetail.Master_Warehouse__c)){
                                        
                    if(objWCDExisting.WU_Utilization_Start_Date__c == objWUWarehouseCapacityDetail.WU_Utilization_Start_Date__c &&
                       objWCDExisting.WU_Utilization_End_Date__c == objWUWarehouseCapacityDetail.WU_Utilization_End_Date__c &&
                       objWCDExisting.Id != objWUWarehouseCapacityDetail.Id ){
                           objWUWarehouseCapacityDetail.addError(Label.WU_DuplicateCapacityDetailWhileInsert);        
                    }
                    
                    system.debug('====check type===========');
                    if(objWCDExisting.WU_Utilization_Start_Date__c.Month() == objWUWarehouseCapacityDetail.WU_Utilization_Start_Date__c.Month() &&
                       objWCDExisting.WU_Utilization_End_Date__c.year() == objWUWarehouseCapacityDetail.WU_Utilization_End_Date__c.year() &&
                       objWCDExisting.Id != objWUWarehouseCapacityDetail.Id){
                            UtilizationType = objWCDExisting.WU_Utilization_Type__c;
                            isUtilizationTypeFound = TRUE;
                    }
                }
                
                if(isUtilizationTypeFound && objWUWarehouseCapacityDetail.WU_Utilization_Type__c != UtilizationType){
                    objWUWarehouseCapacityDetail.addError(Label.WU_utilizationTypeCannotChange);
                }
                
                mapWUWarehouseCapacityDetail.get(objWUWarehouseCapacityDetail.Master_Warehouse__c).add(objWUWarehouseCapacityDetail);
            }
        }
        
    }
    
         
    
}