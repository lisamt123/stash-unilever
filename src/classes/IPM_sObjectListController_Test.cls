/******************************************************************************************************************************
* @author Cognizant 
* @date 06/02/2017
* @description Test Class for IPM_sObjectListController 
*/
@isTest
private class IPM_sObjectListController_Test {

    private static testMethod void getInitializetest() {
    
        IPM_sObjectListController sObjectListController = new IPM_sObjectListController();
        sObjectListController.selectedSObject= 'IPM_Project__c';
        
        sObjectListController.associatedFieldSet = 'DefaultListView';
        sObjectListController.getInitialize();
        
        sObjectListController.refreshPageSize();
        sObjectListController.resetRecords();
        sObjectListController.previousSortColumn = 'Name';
        sObjectListController.sortColumn = 'Id';
        sObjectListController.updateSortOrder();
        sObjectListController.searchRecords();
        sObjectListController.getsObjectList();
        sObjectListController.sortColumn = 'Name';
        sObjectListController.updateSortOrder();
    }

}