public with sharing class TMS_printLoadingSlip_CC {
    public string tmscid{get;set;}
    
    public TMS_Transporter_Management_Screen__c Tmgts{get;set;}
    public TMS_Truck_Entry_Checklist__c Tsentry{get;set;}
    public List<TMS_PO_Items__c> poItem{get;set;}
    public TMS_printLoadingSlip_CC(){
        Tsentry = new TMS_Truck_Entry_Checklist__c();
        Tmgts = new TMS_Transporter_Management_Screen__c();
     tmscid = ApexPages.currentPage().getParameters().get('tid');
     Tsentry = [select id,name,Truck__c,Date_Time__c,Vehicle_Number__c,Answer__c,Question__c,Number__c,Exp_Checklist_Date__c,Depots__c,LR_Number__c,Transporter__c,Truck_Type__c,Material_Description__c,Vendor_Customer__c,Status__c,
           PO_Number__c,Action__c,Bay_Number__c,Bay_Description__c,Bay_Wait_Time__c,CreatedDate 
          from TMS_Truck_Entry_Checklist__c WHERE id=:tmscid];
      poItem = [select id,name,Material_Description__c from TMS_PO_items__c  where TMS_PO__r.Truck_Entry_Checklist__c=:tmscid];     
      
    }

}