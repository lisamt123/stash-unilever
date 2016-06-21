public class TMS_dispatchScreen_CC {
public Integer rowNum{get;set;} 
public String testdoc {get;set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList{get; set;}
public string username {get;set;} 
    public string Delay {get;set;}
public string searchCategory{get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList{get; set;}
    public TMS_dispatchScreen_CC(){
        searchCategory = 'Manual Entry';
        testdoc = System.currentPageReference().getParameters().get('testdoc');
        DocumentList = new List<TMS_Truck_Entry_Checklist__c>();
        DocumentList = [select id,Vehicle_Number__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
    } 
   
    public pagereference acceptTruck(){
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        for(TMS_Truck_Entry_Checklist__c tms:truckList){
            tms.Action__c = 'Truck on Hold';
            tms.Status__c = 'Shipment done';
            tmsList.add(tms);   
            update tmsList;
        }
        PageReference pg = Page.TMS_TruckSummaryScreen_VF;
        pg.setRedirect(true);
        return pg;
        return null;
    }

}