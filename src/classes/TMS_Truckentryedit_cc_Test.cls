@isTest
private class TMS_Truckentryedit_cc_Test {
    static testMethod void myUnitTest() {
        Test.startTest();
            TMS_Material__c tmsmat = new TMS_Material__c(Material_Code__c = 'test');
            insert tmsmat;
            system.assertEquals('test', tmsmat.Material_Code__c);
        
        TMS_Truck_Entry_Checklist__c trucklist = new TMS_Truck_Entry_Checklist__c();
            trucklist.Vehicle_Number__c = 'GA01987'; 
            trucklist.Challan_Number__c = '2132343545';
            trucklist.LR_Number__c = '9788756';
            trucklist.PO_Number__c = '123456';
            trucklist.Name = 'Zindal';
            trucklist.truck_Action__c = 'Truck on Hold';
            trucklist.Material_Desc__c = tmsmat.id;
            insert trucklist;
            system.assertEquals('Zindal',trucklist.Name);
         Test.setCurrentPageReference(new PageReference('Page.TMS_Truckentryedit_VF'));
         ApexPages.CurrentPage().getParameters().put('id',trucklist.Id);
         ApexPages.StandardController sc = new ApexPages.standardController(trucklist);
         TMS_Truckentryedit_cc tmstruckedit = new TMS_Truckentryedit_cc(sc);
         tmstruckedit.updatelist();
         tmstruckedit.cancel();
         Test.stopTest();
    }
}