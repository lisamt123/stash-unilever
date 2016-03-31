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
        							 (Select id,WU_Utilization_End_Date__c,WU_Utilization_Start_Date__c,WU_Committed_Max_PalletStorage__c,WU_Current_Pallet_Utilization__c,WU_Utilization_Type__c FROM Warehouse_Capacity_Utilizaion__r WHERE Is_In_Current_Month__c = true ORDER BY WU_Utilization_Start_Date__c DESC)
        							 FROM WU_Master_Warehouse__c
        							 WHERE Id IN :setMasterWarehouseIds];
        }
        
        if(!masterWarehouseList.isEmpty())
        {
        	for(WU_Master_Warehouse__c master : masterWarehouseList)
        	{
        		if(!master.Warehouse_Capacity_Utilizaion__r.isEmpty())
        		{
        			master.WU_Current_Utilization__c = master.Warehouse_Capacity_Utilizaion__r[0].WU_Current_Pallet_Utilization__c;
        			master.WU_FromDate__c = master.Warehouse_Capacity_Utilizaion__r[0].WU_Utilization_Start_Date__c;
        			master.WU_ToDate__c = master.Warehouse_Capacity_Utilizaion__r[0].WU_Utilization_End_Date__c;
        			master.WU_Utilization_Type__c = master.Warehouse_Capacity_Utilizaion__r[0].WU_Utilization_Type__c;
        			master.WU_Latest_Committed_Pallet__c = master.Warehouse_Capacity_Utilizaion__r[0].WU_Committed_Max_PalletStorage__c;
        			masterWarehouseListToUpdate.add(master);
        		}
        	}
        	
        	if(!masterWarehouseListToUpdate.isEmpty())
        	{
        		isUpdateFromChild = true;
        		update masterWarehouseListToUpdate;
        	}
        }
                
    }
    
    
    
}