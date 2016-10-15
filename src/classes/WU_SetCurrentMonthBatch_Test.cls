/*************************************************************
*@Author :          Cognizant
*@Date :            March 2016
*@Description :     To test WU_SetCurrentMonthBatch Class.
*************************************************************/
    
@isTest
public class WU_SetCurrentMonthBatch_Test{
    private static list<WU_Master_Warehouse__c> WarehouseCapacityList;
    static void createData()
    {
      WarehouseCapacityList = WU_TestFactory_Helper.insertWUWarehouseList(50);
	  /*
	  WU_Warehouse_Capacity_Detail__c objWUWarehouseCapacityDetail = new WU_Warehouse_Capacity_Detail__c();
	  objWUWarehouseCapacityDetail.Master_Warehouse__c = WarehouseCapacityList[0].Id;
	  objWUWarehouseCapacityDetail.WU_Utilization_Type__c = 'Daily';
	  objWUWarehouseCapacityDetail.WU_Current_Utilization__c = 
	  objWUWarehouseCapacityDetail.WU_Utilization_Start_Date__c = Date.today();
	  objWUWarehouseCapacityDetail.WU_Utilization_End_Date__c = Date.today() ;
	  insert objWUWarehouseCapacityDetail;
	  */
	  
    }
    
    /*************************************************************************
    *@Description : to Intialize(insert, update) the data for warehouse capacity
    ***************************************************************************/
    static testMethod void positiveScenarios(){ 
        createData();
        test.startTest();
        system.assert(!WarehouseCapacityList.isEmpty());
		WU_SetCurrentMonthBatch objWUSetCurrentMonthBatch = new WU_SetCurrentMonthBatch();
		Database.executeBatch(objWUSetCurrentMonthBatch);
        test.stopTest();
	}
}