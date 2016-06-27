public class TMS_Popup_unloadLoadDone_CC {
public string tmsloadid{get;set;}
public List<TMS_Truck_Entry_Checklist__c> Tsentryload{get; set;}
public List<TMS_PO__c> po{get; set;}
public List<TMS_PO_items__c> poItem{get; set;}
public List<TMS_Shipment_Items__c> shipItem {get; set;}
public TMS_PO__c uomList{get; set;}
public TMS_Shipment__c shipList{get; set;}
    public TMS_Popup_unloadLoadDone_CC(ApexPages.StandardController controller){
        Tsentryload = new List<TMS_Truck_Entry_Checklist__c>();
        tmsloadid = ApexPages.currentPage().getParameters().get('tloadid');
        Tsentryload = [select id,name,Vehicle_Number__c,Bay_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c WHERE id=:tmsloadid]; 
        poItem = [select TMS_PO__r.id,TMS_PO__r.name,TMS_PO__r.Invoice_No__c,id,name,choosePO__c from TMS_PO_items__c  where TMS_PO__r.Truck_Entry_Checklist__c=:tmsloadid]; 
        shipItem = [select TMS_Shipment__r.id,TMS_Shipment__r.name,TMS_Shipment__r.Item_No__c,id,Name,Choose_ShipItem__c from TMS_Shipment_Items__c where TMS_Shipment__r.Truck_Entry_Checklist__c=:tmsloadid];
    }
    public void save(){
       
         
         List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
         if(!poItem.isEmpty()){
         upsert poItem;
         uomList = new TMS_PO__c();
         uomList = [SELECT UOM__c,Truck_Entry_Checklist__r.Name from TMS_PO__c where Truck_Entry_Checklist__r.Id=:Tsentryload];
        if(uomList.UOM__c=='PC')
        {
        for(TMS_Truck_Entry_Checklist__c tms:Tsentryload){
            tms.Action__c = 'Qnty Val';
            tms.Status__c = 'Unload/Load Done';
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        
        }
        else{
            for(TMS_Truck_Entry_Checklist__c tms:Tsentryload){
            tms.Action__c = 'Fin weight';
            tms.Status__c = 'Unload/Load Done';
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        }
       }
       
       if(!shipItem.isEmpty()){
         upsert shipItem;
         shipList = new TMS_Shipment__c();
         shipList = [SELECT UOM__c,Truck_Entry_Checklist__r.Name from TMS_Shipment__c where Truck_Entry_Checklist__r.Id=:Tsentryload];
        if(shipList.UOM__c=='PC')
        {
        for(TMS_Truck_Entry_Checklist__c tms:Tsentryload){
            tms.Action__c = 'Qnty Val';
            tms.Status__c = 'Unload/Load Done';
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        
        }
        else{
            for(TMS_Truck_Entry_Checklist__c tms:Tsentryload){
            tms.Action__c = 'Fin weight';
            tms.Status__c = 'Unload/Load Done';
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        }
       }
    }
}