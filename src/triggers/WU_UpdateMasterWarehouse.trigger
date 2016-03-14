/************************************************************
*@Author :          Cognizant
*@Date :            January 2016
*@Description :     Trigger to update total & average utilization values on master warehouse. 
*************************************************************/

trigger WU_UpdateMasterWarehouse on WU_Warehouse_Capacity_Detail__c(Before Insert, after insert, before update,after update) {
  
        //if (Trigger.isInsert && Trigger.isBefore)
        //{
        	
        //}
        if(Trigger.isUpdate && Trigger.isAfter)
        {
            WU_UpdateMasterWarehouseHandler.onAfterUpdate(trigger.oldMap, trigger.new, trigger.newMap);
        }

}