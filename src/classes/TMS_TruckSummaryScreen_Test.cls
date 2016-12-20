@isTest
	private class TMS_TruckSummaryScreen_Test {
        static testMethod void myUnitTest() {
            Test.startTest();
            TMS_Vendor_Transporter_Customer_Mast__c tmsvendor = new TMS_Vendor_Transporter_Customer_Mast__c(Code__c='test',Identifier__c='t');
            insert tmsvendor;
            system.assertEquals('test', tmsvendor.Code__c);
            
            TMS_Material__c tmsmat = new TMS_Material__c(Material_Code__c = 'test');
            insert tmsmat;
            system.assertEquals('test', tmsmat.Material_Code__c);
            
            TMS_Truck_Entry_Checklist__c trucklist = new TMS_Truck_Entry_Checklist__c();
            trucklist.Vendor__c = tmsvendor.id;
            trucklist.Vehicle_Number__c = 'GA01987'; 
            trucklist.Challan_Number__c = '2132343545';
            trucklist.LR_Number__c = '9788756';
            trucklist.PO_Number__c = '123456';
            trucklist.Name = 'Zindal';
            trucklist.truck_Action__c = 'Truck on Hold';
            trucklist.Material_Desc__c = tmsmat.id;
            insert trucklist;
            system.assertEquals('Zindal',trucklist.Name);
            trucklist.truck_Action__c = 'Terminate';
            update trucklist;
            
            TMS_Bay_Master__c tmsbay = new TMS_Bay_Master__c();
            tmsbay.Name = 'test';
            tmsbay.Bay_Description__c = 'testdesc';
            tmsbay.STD_Wait_Time__c = '10';
            insert tmsbay;
            system.assertEquals('test',tmsbay.Name);
            //List<TMS_Bay_Master__c> tmbaywt=[SELECT Id, Name, Bay_Description__c, STD_Wait_Time__c 
                                     //FROM TMS_Bay_Master__c where Name=:tmstrucks[ite].selectedbay];
            
            Test.setCurrentPageReference(new PageReference('Page.TMS_TruckSummaryScreen_VF'));
            ApexPages.CurrentPage().getParameters().put('firstParam', 'id');
			//System.currentPageReference().getParameters().put('id', 'firstParam');
            //PageReference pageRef = Page.TMS_TruckSummaryScreen_VF;            
            //test.setcurrentpage(pageRef);
            TMS_TruckSummaryScreen_CC tmsscreen = new TMS_TruckSummaryScreen_CC();
			TMS_TruckSummaryScreen_CC.Tmstruck tmswrap = new TMS_TruckSummaryScreen_CC.Tmstruck(tmsbay);           
            List<selectOption> temp = tmsscreen.getchbays();
            tmsscreen.Testite='baytest';
            tmsscreen.showPopup();
            tmsscreen.showPopup1();
            tmsscreen.utmethode1();
            tmsscreen.printError();
            tmsscreen.newTruckEntry();
            tmsscreen.docValid();
            tmsscreen.timeupdate();
            tmsscreen.utmethode();
            tmsscreen.changeBay();
            tmsscreen.terminate();
            tmsscreen.QAApprove();
            tmsscreen.QAReceive();
            tmsscreen.populatebaydesc();
            Test.stopTest();
        }
}