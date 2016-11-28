@isTest
public class WU_WarehouseSearchGooglemapController_TC {

    Public Static testMethod void warehouseSearchMethod()
    {
        User u1=[Select Id from User limit 1];
        WU_Master_Warehouse__c obj = new WU_Master_Warehouse__c(WU_Approval_Status__c='Approved',
                                                                WU_WarehousePOC_Email__c='anil.singh2@cognizant.com',
                                                                WU_WarehouseManager_Email__c='anil.singh2@cognizant.com',
                                                               	WU_Committed_Max_PalletStorage__c=99,
                                                               	WU_Procurement_Manager__c=u1.id);
        insert obj;
    }
}