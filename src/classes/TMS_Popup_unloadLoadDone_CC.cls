public class TMS_Popup_unloadLoadDone_CC {
public string tmsloadid{get;set;}
public List<TMS_Truck_Entry_Checklist__c> Tsentryload{get; set;}
    public List<TMS_PO__c> po{get; set;}
    public List<TMS_PO_items__c> poItem{get; set;}
    public TMS_Popup_unloadLoadDone_CC(ApexPages.StandardController controller){
        Tsentryload = new List<TMS_Truck_Entry_Checklist__c>();
     	tmsloadid = ApexPages.currentPage().getParameters().get('tloadid');
     	Tsentryload = [select id,name,Vehicle_Number__c,Bay_Number__c from TMS_Truck_Entry_Checklist__c WHERE id=:tmsloadid]; 
        //po = new List<TMS_PO__c>();
        poItem = [select TMS_PO__r.id,TMS_PO__r.name,TMS_PO__r.Invoice_No__c,id,name,choosePO__c from TMS_PO_items__c  where TMS_PO__r.Truck_Entry_Checklist__c=:tmsloadid];
        //system.debug('po->'+po);
        
    }
    public void save(){
       upsert poItem;
        
    }
}