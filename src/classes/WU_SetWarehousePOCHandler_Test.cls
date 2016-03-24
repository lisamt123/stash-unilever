/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     To test WU_SetWarehousePOCHandler, WU_TestFactory_Helper class, WU_SerWarehousePOC Trogger
*************************************************************/
    
@isTest
public class WU_SetWarehousePOCHandler_Test
{
   
    private static list<WU_Master_Warehouse__c> WarehouseCapacityList;
    
    static void createData()
    {
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
        system.runAs(WU_TestFactory_Helper.ur)
        {
        	createData();
	        test.startTest();
	        //WarehouseCapacityList=WU_TestFactory_Helper.insertWUWarehouseList(50);
	        system.assert(!WarehouseCapacityList.isEmpty());
        	WU_MultiCreateMultiEdit muliCreateEdit = new WU_MultiCreateMultiEdit();
        	system.debug(':::::::::list size is'+muliCreateEdit.masterWarehouseList.size());
        	system.assertEquals(muliCreateEdit.masterWarehouseList.size(),WarehouseCapacityList.size());
        	
        	muliCreateEdit.masterWarehouseWrapperList[0].checkbox = false;
        	muliCreateEdit.createNewCapacityDetails();
        	muliCreateEdit.updateLatestCapacityDetails();
        	muliCreateEdit.getItems();
        	muliCreateEdit.saveRecords();
        	muliCreateEdit.cancel();
        	muliCreateEdit.setfieldstopopup();
        	
       }
        test.stopTest();
    }
    
    static testMethod void positiveCreateNewCapacity()
    {
    	assignPermissionSet();
    	
    	system.runAs(WU_TestFactory_Helper.ur)
    	{
    		createData();
    		WU_MultiCreateMultiEdit muliCreateEdit = new WU_MultiCreateMultiEdit();
    		system.assertEquals(muliCreateEdit.masterWarehouseList.size(),WarehouseCapacityList.size());
    		
    		muliCreateEdit.masterWarehouseWrapperList[0].checkbox = true;
        	muliCreateEdit.masterWarehouseWrapperList[0].startDate = (muliCreateEdit.masterWarehouseWrapperList[0].startDate) +1;
        	muliCreateEdit.masterWarehouseWrapperList[0].endDate = (muliCreateEdit.masterWarehouseWrapperList[0].endDate) +1;
        	
        	muliCreateEdit.createNewCapacityDetails();
    	}
    }
    
    static testMethod void positiveUpdateCapacity()
    {
    	assignPermissionSet();
    	
    	system.runAs(WU_TestFactory_Helper.ur)
    	{
    		createData();
    		WU_MultiCreateMultiEdit muliCreateEdit = new WU_MultiCreateMultiEdit();
    		system.assertEquals(muliCreateEdit.masterWarehouseList.size(),WarehouseCapacityList.size());
    		
    		muliCreateEdit.masterWarehouseWrapperList[0].checkbox = true;
        	muliCreateEdit.masterWarehouseWrapperList[0].startDate = (muliCreateEdit.masterWarehouseWrapperList[0].startDate) +1;
        	muliCreateEdit.masterWarehouseWrapperList[0].endDate = (muliCreateEdit.masterWarehouseWrapperList[0].endDate) +1;
        	
        	muliCreateEdit.updateLatestCapacityDetails();
    	}
    }
    
    
}