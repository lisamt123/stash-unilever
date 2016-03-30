/*************************************************************
*@Author :          Cognizant
*@Date :            March 2016
*@Description :     To test WU_WarehouseSearchController Class.
*************************************************************/
    
@isTest
public class WU_WarehouseSearchController_test{
    private static list<WU_Master_Warehouse__c> WarehouseCapacityList;
    static void createData()
    {
      WarehouseCapacityList = WU_TestFactory_Helper.insertWUWarehouseList(50);
    }
    
    /*************************************************************************
    *@Description : to Intialize(insert, update) the data for warehouse capacity
    ***************************************************************************/
    static testMethod void positiveScenarios(){ 
        createData();
        test.startTest();
        system.assert(!WarehouseCapacityList.isEmpty());
		WU_Master_Warehouse__c objWUMasterWarehouse = new WU_Master_Warehouse__c();
		objWUMasterWarehouse = [select id,WU_SAPCode_s__c,WU_Region__c,WU_MCO__c,WU_Network__c,WU_Country__c,WU_CityName__c from WU_Master_Warehouse__c Where WU_CityName__c != Null LIMIT 1];
		ApexPages.StandardController stdCtrl = new ApexPages.StandardController(objWUMasterWarehouse);
		WU_WarehouseSearchController objWU_WarehouseSearchController = new WU_WarehouseSearchController(stdCtrl);
		objWU_WarehouseSearchController.SearchRecords();
		objWU_WarehouseSearchController.warehouseCapacity = objWUMasterWarehouse; 
		objWU_WarehouseSearchController.redirectToReport();
        test.stopTest();
	}
}