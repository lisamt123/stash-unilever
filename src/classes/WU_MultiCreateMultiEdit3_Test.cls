/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     To test WU_MultiCreateMultiEdit, WU_TestFactory_Helper class, WU_SerWarehousePOC Trogger
*************************************************************/

@isTest
public class WU_MultiCreateMultiEdit3_Test{
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
           WU_MultiCreateMultiEdit3 objWU_MultiCreateMultiEdit = new WU_MultiCreateMultiEdit3();
            for(WU_MultiCreateMultiEdit3.MasterWarehouseWrapper objMasterWarehouseWrapper : objWU_MultiCreateMultiEdit.masterWarehouseWrapperList ){
                objMasterWarehouseWrapper.isSelected = TRUE;
            }
           objWU_MultiCreateMultiEdit.createNewCapacityDetails();
           objWU_MultiCreateMultiEdit.getItems();
           for(WU_MultiCreateMultiEdit3.MasterWarehouseWrapper objMasterWarehouseWrapper : objWU_MultiCreateMultiEdit.masterWarehouseWrapperList ){
                objMasterWarehouseWrapper.isSelected = TRUE;
            }
           objWU_MultiCreateMultiEdit.updateLatestCapacityDetails();
           objWU_MultiCreateMultiEdit.selectedId = objWU_MultiCreateMultiEdit.masterWarehouseWrapperList[0].objWUMasterWarehouse.Id;
           objWU_MultiCreateMultiEdit.setfieldstopopup();
           objWU_MultiCreateMultiEdit.selectedRecords = 'selectAllRecords';
           objWU_MultiCreateMultiEdit.selectedField = 'utilamt';
           objWU_MultiCreateMultiEdit.saveRecords();
           objWU_MultiCreateMultiEdit.selectedRecords = 'SelectSingleRecord';
           objWU_MultiCreateMultiEdit.selectedField = 'utilamt';
           objWU_MultiCreateMultiEdit.saveRecords();
           objWU_MultiCreateMultiEdit.cancel();
        }
        test.stopTest();
    }
}