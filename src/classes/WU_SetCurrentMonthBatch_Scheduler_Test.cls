/*************************************************************
*@Author :          Cognizant
*@Date :            March 2016
*@Description :     To test WU_SetCurrentMonthBatch_Scheduler Class.
*************************************************************/
    
@isTest
public class WU_SetCurrentMonthBatch_Scheduler_Test{
    private static list<WU_Master_Warehouse__c> WarehouseCapacityList;
	public static String CRON_EXP = '0 0 0 15 3 ? 2022';
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
		System.schedule('ScheduleWU_SetCurrentMonthBatch_Scheduler', CRON_EXP, new WU_SetCurrentMonthBatch_Scheduler());
        test.stopTest();
	}
}