public with sharing class TMS_dispatchScreen_CC {
public Integer rowNum{get;set;} 
public String testdoc {get;set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList1{get; set;}
public string username {get;set;} 
public string Delay {get;set;}
public string poId {get;set;}   
public string plId {get;set;}   
public string materialcode {get; set;}
public string materialDesc {get; set;}
public Datetime trucktime {get; set;}
public String tAction{get; set;}
public string intweight {get; set;}
public string finalweight {get; set;}
public decimal initialwt {get; set;}
public decimal finalwt {get; set;}
public string finwt {get; set;}
public boolean wtpanel {get; set;}
public boolean wtpanel1 {get; set;}
public string searchCategory{get; set;}
public List<TMS_Shipment__c> uomList{get; set;}
public List<String> matDesc{get; set;}
public List<TMS_Material__c> material{get; set;}
public List<String> testString{get; set;}
public List<TMS_Shipment_Items__c> shipItem {get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList1{get; set;}
    public TMS_dispatchScreen_CC(){
        wtpanel = false;
        wtpanel1 = true;
        searchCategory = 'Manual Entry';
        testdoc = System.currentPageReference().getParameters().get('testdoc');
        material = new List<TMS_Material__c>();
        testString = new List<String>();
        matDesc = new List<String>();
                material = [select id,Name,Material_Code__c from TMS_Material__c ORDER BY Name ASC ];
        for(TMS_Material__c tmm:material)
        {
        testString.add(tmm.Material_Code__c);
        matDesc.add(tmm.Name);
        }
        DocumentList = new List<TMS_Truck_Entry_Checklist__c>();
        DocumentList = [select id,Vehicle_Number__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Shipment_Time__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        DocumentList1 = [select id,Vehicle_Number__c,Date__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Document_Validation_Time__c,Quantity_Validation_Time__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        tAction = DocumentList[0].Action__c;
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Shipment_Time__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        for(TMS_Truck_Entry_Checklist__c tms: documentList1){
                materialCode = tms.Material_Code__c;
                materialDesc = tms.Material_Description__c;
                trucktime = tms.date__c;
                initialwt = tms.initial_Wt__c;
                finalwt = tms.Final_Wt__c;
        }
        for(TMS_Truck_Entry_Checklist__c tms: documentList){
                initialwt = tms.initial_Wt__c;
                finwt = string.valueof(tms.Final_Wt__c);
        }       
    } 
     public void manualweight(){
        if(wtpanel==false && wtpanel1==true){
            wtpanel = true;
            wtpanel1 = false;
        }        
    }
   
    public pagereference acceptTruck(){
        uomList = new List<TMS_Shipment__c>();
        uomList = [SELECT UOM__c,(select UOM__c from TMS_Shipment_Items__r),Truck_Entry_Checklist__r.Name,Truck_Entry_Checklist__r.Initial_Wt__c from TMS_Shipment__c where Truck_Entry_Checklist__r.Id=:testdoc LIMIT 1];
        set<id> shipid = new set<id>();
        for(TMS_Shipment__c ship : uomList){
            shipid.add(ship.id);        
        }
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList1 = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Shipment_Time__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc LIMIT 1];
        truckList1 = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Shipment_Time__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc LIMIT 1];        
        
        for(TMS_Truck_Entry_Checklist__c tms:truckList){   
        for(TMS_Shipment_Items__c shipitem : [select TMS_Shipment__r.Name,UOM__c from TMS_Shipment_Items__c where TMS_Shipment__r.id=:shipid]){
            system.debug('UOM ->'+shipitem);
            if(shipitem.UOM__c == 'PC'){ 
                               
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Shipment Finished';
                    tms.Delay_Reason__c = delay;
                    tms.Shipment_Time__c = system.now();
                    tmsList.add(tms);                     
            }
            else if(shipitem.UOM__c == 'EA'){ 
                               
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Shipment Finished';
                    tms.Delay_Reason__c = delay;
                    tms.Shipment_Time__c = system.now();
                    tmsList.add(tms);                     
            }
            else if(shipitem.UOM__c =='CS'){ 
                               
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Shipment Finished';
                    tms.Delay_Reason__c = delay;
                    tms.Shipment_Time__c = system.now();
                    tmsList.add(tms);                     
            }
            else{
                               
                    tms.Action__c = 'Int weight';
                    tms.Status__c = 'Shipment Finished';
                    tms.Delay_Reason__c = delay;
                    tms.Shipment_Time__c = system.now();
                    tmsList.add(tms);                  
            }
          }
          
        }
        set<TMS_Truck_Entry_Checklist__c> setList = new set<TMS_Truck_Entry_Checklist__c>(tmsList);
        //system.debug('setList-->'+setList.size());
        List<TMS_Truck_Entry_Checklist__c> tmsList1 = new List<TMS_Truck_Entry_Checklist__c>(setList);
        //system.debug('tmsList1-->'+tmsList1.size());
        if(!tmsList1.isEmpty()){
            update tmsList1;
        }
        
        PageReference pg = Page.TMS_TruckSummaryScreen_VF;
        pg.setRedirect(true);
        return pg;
    }
    public pageReference qtyValidate(){
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        for(TMS_Truck_Entry_Checklist__c tms:truckList){
            //tms.Action__c = 'Exit';
            tms.Status__c = 'Qty validated';
            tms.Shipment_Time__c = system.now();
            if(intweight!=null && intweight !=null){
                tms.initial_Wt__c = Decimal.valueof(intweight);
                tms.Final_Wt__c = Decimal.valueof(finalweight);
                tms.Weight_Edited_User__c = UserInfo.getFirstName();
            }
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        PageReference pg = Page.TMS_TruckSummaryScreen_VF;
        pg.setRedirect(true);
        return pg;
    }
    public pageReference deletePORecord()
    {
        TMS_Shipment__c tpo = [Select id from TMS_Shipment__c where id=:poId];
        delete tpo;
        return null;
    }
    public pageReference deletePOLineRecord()
    {
        TMS_Shipment_Items__c tlo = [Select id from TMS_Shipment_Items__c where id=:plId];
        delete tlo;
        return null;
    }

}