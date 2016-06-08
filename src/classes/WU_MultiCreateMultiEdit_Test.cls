/*************************************************************
*@Author :          Cognizant
*@Date :            December 2015
*@Description :     To test WU_SetWarehousePOCHandler, WU_TestFactory_Helper class, WU_SerWarehousePOC Trogger
*************************************************************/

@isTest
public class WU_MultiCreateMultiEdit_Test{
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
           WU_MultiCreateMultiEdit objWU_MultiCreateMultiEdit = new WU_MultiCreateMultiEdit();
            for(WU_MultiCreateMultiEdit.MasterWarehouseWrapper objMasterWarehouseWrapper : objWU_MultiCreateMultiEdit.masterWarehouseWrapperList ){
                objMasterWarehouseWrapper.checkbox = TRUE;
            }
           objWU_MultiCreateMultiEdit.createNewCapacityDetails();
           objWU_MultiCreateMultiEdit.getItems();
           for(WU_MultiCreateMultiEdit.MasterWarehouseWrapper objMasterWarehouseWrapper : objWU_MultiCreateMultiEdit.masterWarehouseWrapperList ){
                objMasterWarehouseWrapper.checkbox = TRUE;
            }
           objWU_MultiCreateMultiEdit.updateLatestCapacityDetails();
           objWU_MultiCreateMultiEdit.selectedId = objWU_MultiCreateMultiEdit.masterWarehouseWrapperList[0].masterWHId;
           WU_UtilizationType__c objWUUtilizationType = new WU_UtilizationType__c(name = 'UtilizationType' , Type__c = 'Daily;Weekly;Monthly' );
           insert objWUUtilizationType;
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