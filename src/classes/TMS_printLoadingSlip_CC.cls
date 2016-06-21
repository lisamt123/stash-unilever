public class TMS_printLoadingSlip_CC {
    public string tmscid{get;set;}
    public TMS_Transporter_Management_Screen__c Tmgts{get;set;}
    public TMS_Truck_Entry_Checklist__c Tsentry{get;set;}
    public TMS_printLoadingSlip_CC(){
        Tsentry = new TMS_Truck_Entry_Checklist__c();
        Tmgts = new TMS_Transporter_Management_Screen__c();
     tmscid = ApexPages.currentPage().getParameters().get('tid');
     Tsentry = [select id,name,Truck__c,Date_Time__c,Vehicle_Number__c,Depots__c,LR_Number__c,Transporter__c,Truck_Type__c,Material_Description__c,Vendor_Customer__c,Status__c,
           PO_Number__c,Action__c,Bay_Number__c,Bay_Description__c,Bay_Wait_Time__c,CreatedDate 
          from TMS_Truck_Entry_Checklist__c WHERE id=:tmscid];
          
     
    }

}