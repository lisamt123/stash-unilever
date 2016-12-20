public with sharing class TMS_Truckentryedit_cc {
public TMS_Truck_Entry_Checklist__c trucklist{get;set;}
public string tmsid;
private ApexPages.StandardController controller;
    public TMS_Truckentryedit_cc(ApexPages.StandardController controller){        
        trucklist = new TMS_Truck_Entry_Checklist__c();
    	trucklist = (TMS_Truck_Entry_Checklist__c)controller.getRecord();
        tmsid=ApexPages.currentPage().getParameters().get('Id');
        trucklist = [SELECT Id, Name, Vendor__c, Detention_Reason__c, Vehicle_Number__c,owner.name, Challan_Number__c, 
                     LR_Number__c, PO_Number__c, Bay_Number__c, Bay_Description__c, Status__c, Action__c, Site__c, 
                     Material_Desc__c, Initial_Wt__c,RFID__c, Serial_Number__c, Final_Wt__c, Date_Time__c,Question__c, 
                     Truck__c, Answer__c, Reject_Reason__c, Delay_Reason__c,Transporters__c,Driver_License_Number__c,
                     Serial_Num__c,truck_Action__c,TMS_Current_Weight__c,Relay_Item_Id__c FROM TMS_Truck_Entry_Checklist__c where id=:tmsid];
    }
    public pagereference updatelist(){
    	update trucklist;
        PageReference pageRef = new PageReference('/a8r');
        pageRef.setRedirect(true);
        return pageRef;
    }
    public pagereference cancel(){
    	PageReference pageRef = new PageReference('/a8r');
        pageRef.setRedirect(true);
        return pageRef;    
    }
}