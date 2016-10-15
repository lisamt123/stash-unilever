/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     To test WU_SetWarehousePOCHandler, WU_TestFactory_Helper class, WU_SerWarehousePOC Trogger
*************************************************************/

@isTest
public class WU_CreateCapacityDetails_Test{
    private static list<WU_Master_Warehouse__c> WarehouseCapacityList;
    static void createData(){
        WarehouseCapacityList = WU_TestFactory_Helper.insertWUWarehouseList(50);
    }
    
     static void assignPermissionSet()
    {
        WU_TestFactory_Helper.assignPermSet();
    }

    /*************************************************************************
    *@Description : to Intialize(insert, update) the data for warehouse capacity
    ***************************************************************************/
    static testMethod void positiveScenarios(){ 
        assignPermissionSet();
        system.runAs(WU_TestFactory_Helper.ur){
            createData();
            test.startTest();   
            system.assert(!WarehouseCapacityList.isEmpty());
            Map<Id,WU_Master_Warehouse__c> mapNewWUMasterWarehouse = new Map<Id,WU_Master_Warehouse__c>();
            Map<Id,WU_Master_Warehouse__c> mapOldWUMasterWarehouse = new Map<Id,WU_Master_Warehouse__c>();
            
            WU_CreateCapacityDetails  objWU_CreateCapacityDetails = new WU_CreateCapacityDetails();
             
            for(WU_Master_Warehouse__c objWUMasterWarehouse : WarehouseCapacityList){
                mapOldWUMasterWarehouse.put(objWUMasterWarehouse.id,objWUMasterWarehouse);
            }
            List<WU_Master_Warehouse__c> lstWUMasterWarehouse = [select id,name,WU_FromDate__c,WU_ToDate__c,WU_Current_Utilization__c,WU_Utilization_Type__c,
                                                                 WU_Committed_Max_PalletStorage__c FROM WU_Master_Warehouse__c where id in :mapOldWUMasterWarehouse.Keyset()];
            
            for(WU_Master_Warehouse__c objWUMasterWarehouse : lstWUMasterWarehouse){
                objWUMasterWarehouse.WU_ToDate__c = objWUMasterWarehouse.WU_ToDate__c.adddays(5);
                mapNewWUMasterWarehouse.put(objWUMasterWarehouse.id,objWUMasterWarehouse);
            }
            objWU_CreateCapacityDetails.checkInsertRecordOrDisplayError(WarehouseCapacityList , mapNewWUMasterWarehouse , mapOldWUMasterWarehouse);
        }
        test.stopTest();
    }
}