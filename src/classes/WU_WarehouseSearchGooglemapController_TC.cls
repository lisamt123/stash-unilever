/* 
* Class Name       : WU_WarehouseSearchGooglemapController_TC[Here TC=Test Class]
* Description      : This class is designed to create test data for "WU_WarehouseSearchGooglemapController" controller class.
* @Author          : Cognizant
* createdDate    : 10-Nov-2016
*/
@isTest(seeAllData=false)
public class WU_WarehouseSearchGooglemapController_TC {
    
    Public Static testMethod void warehouseSearchMethod()
    {
        User usr=[Select Id from User limit 1];
        WU_Master_Warehouse__c  mstrWarehose= new WU_Master_Warehouse__c(WU_Approval_Status__c='Approved',
                                                                WU_WarehousePOC_Email__c='TestUser@cognizant.com',
                                                                WU_WarehouseManager_Email__c='TestUser@cognizant.com',
                                                                WU_Committed_Max_PalletStorage__c=99,
                                                                WU_SAPCode_s__c='test poc email template',
                                                                WU_Procurement_Manager__c=usr.id);
        insert mstrWarehose;
        
        ApexPages.StandardController stndCntrl = new ApexPages.StandardController(mstrWarehose);
        WU_WarehouseSearchGooglemapController wCntrl = new WU_WarehouseSearchGooglemapController(stndCntrl);
        wCntrl.getWarehouseList();
        wCntrl.SearchRecords();
    }
}