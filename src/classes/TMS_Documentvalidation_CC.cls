public with sharing class TMS_Documentvalidation_CC {
public String testdoc {get;set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList1{get; set;}

List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
public List<TMS_PO_items__c> poitemList {get; set;}
public List<TMS_PO_items__c> poItem {get; set;}
//public Integer rowNum{get;set;} 
public Integer rowNumber{get;set;} 
public List<Integer> counterId{get;set;}
public string username {get;set;}   
public String Delay{get;set;}
public string searchCategory{get; set;}
public string tmspoItem {get; set;}
public string invoicenum {get; set;}
public string invoiceqty {get; set;}
public string uom {get; set;}
public decimal initialwt {get; set;}
public decimal finalwt {get; set;}
public string netqty {get; set;}
public string materialcode {get; set;}
public string materialDesc {get; set;}
public string ponumber {get; set;}
public string plantcode {get; set;}
public boolean PoItemPanel {get; set;}
public string teId {get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList{get; set;}
private ApexPages.StandardController controller;  
    public TMS_Documentvalidation_CC(ApexPages.StandardController controller){
        
    } 
    
    public TMS_Documentvalidation_CC(){
        PoItemPanel = false;
        //this.controller = controller;
        plantcode = 'Chiplun Plant';
        counterId = new List<Integer>();
        counterId.add(1);
        //system.debug('tmsList-->'+tmsList);
        testdoc = System.currentPageReference().getParameters().get('testdoc');
        DocumentList = new List<TMS_Truck_Entry_Checklist__c>();
        DocumentList = [select id,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc ];
        DocumentList1 = [select id,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        poitemList = new List<TMS_PO_items__c>();
        poItem = new List<TMS_PO_items__c>();
        poItem = [select id,choosePO__c,Po_Item__c,Material_Description__c,Name,Initial__c,Final_Wt__c,Net_Quantity__c,TMS_PO__r.id,TMS_PO__r.Name,TMS_PO__r.PO_Number__c,TMS_PO__r.Truck_No__c,TMS_PO__r.Invoice_Qty__c,TMS_PO__r.Invoice_No__c,TMS_PO__r.UOM__c,TMS_PO__r.Plant_Code__c from TMS_PO_items__c where TMS_PO__r.Truck_No__c=:testdoc];        
        searchCategory = 'Manual Entry';
        for(TMS_Truck_Entry_Checklist__c tms: documentList1){
                materialCode = tms.Material_Code__c;
                materialDesc = tms.Material_Description__c;
        }       
        //system.debug('material Code->'+materialCode);
        //system.debug('material Desc->'+materialDesc);
        
    }
    
    public void addFilter(){
        if(PoItemPanel==false){
            PoItemPanel = true;            
        }
        for(TMS_Truck_Entry_Checklist__c tms: documentList1){
                materialCode = tms.Material_Code__c;
                materialDesc = tms.Material_Description__c;
        }        
        
    }
    
    
    
    public void addFilter1(){        
        List<TMS_Truck_Entry_Checklist__c> tmsList = [select id,PO_Number__c,Material_Code__c,Material_Description__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        for(TMS_Truck_Entry_Checklist__c tms:tmsList){
            TMS_Truck_Entry_Checklist__c trms = new TMS_Truck_Entry_Checklist__c();
            trms.id = tms.id;
            trms.PO_Number__c = tms.PO_Number__c;
            //trms.Material_Code__c = tms.Material_Code__c;
            materialCode = tms.Material_Code__c;
            materialDesc = tms.Material_Description__c;
           // initialwt = tms.initial_Wt__c;
            //finalwt = tms.Final_Wt__c;
            DocumentList1.add(trms);
        }     
    }
    
    public void delRow(){
        rowNumber = Integer.valueOf(apexpages.currentpage().getparameters().get('index'));      
        //if(rownumber>documentList1.size()){
            DocumentList1.remove(rowNumber-1);            
        //}
        
    }
    
    public Boolean option {get; set;}
    
    public void selectedCheckbox(){
        if(option == true){
            PoItemPanel = true;
        }else{
            PoItemPanel = false;
        }
    }
     
    public pageReference acceptTruck(){
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        for(TMS_Truck_Entry_Checklist__c tms:truckList){
            //tms.Action__c = 'Int weight';
            tms.Status__c = 'Doc Validated';
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        PageReference pg = Page.TMS_TruckSummaryScreen_VF;
        pg.setRedirect(true);
        return pg;
    }
    public pageReference qtyValidate(){
        //controller.save();
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        for(TMS_Truck_Entry_Checklist__c tms:truckList){
            //tms.Action__c = 'Exit';
         	tms.Status__c = 'Qty validated';
            tmsList.add(tms);
        }        
        if(!tmsList.isEmpty()){
            update tmsList;
        }
        PageReference pg = Page.TMS_TruckSummaryScreen_VF;
        pg.setRedirect(true);
        return pg;
    }
    public void netQty(){
      //  Integer netquantity = Integer.valueof(initialwt)-Integer.valueof(finalwt);
        //netqty = string.valueof(netquantity);
    }
}