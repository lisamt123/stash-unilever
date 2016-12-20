public with sharing class TMS_Documentvalidation_CC {

public string intialwt {get; set;}
public string finwt {get; set;}
public string intweight {get; set;}
public string finalweight {get; set;}
public String testdoc {get;set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList1{get; set;}
List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
List<TMS_Truck_Entry_Checklist__c> tmsList1 = new List<TMS_Truck_Entry_Checklist__c>();
public TMS_PO_items__c poitemList {get; set;}
public List<TMS_PO_items__c> poItem {get; set;}
//public Integer rowNum{get;set;} 
public Integer rowNumber{get;set;} 
public List<Integer> counterId{get;set;}
public string username {get;set;} 
public string poId {get;set;}   
public string plId {get;set;}   
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
public List<TMS_PO__c> uomList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList1{get; set;}
public string delayTime {get; set;}
public Datetime trucktime {get; set;}
public string mat {get; set;}
public boolean delayreason {get; set;}
public boolean delayreason1 {get; set;}
public List<TMS_Material__c> material{get; set;}
public List<String> testString{get; set;}
public List<String> matDesc{get; set;}
public String tAction{get; set;}
public boolean wtpanel {get; set;}
public boolean wtpanel1 {get; set;}
private ApexPages.StandardController controller;  
    public TMS_Documentvalidation_CC(ApexPages.StandardController controller){
        
    } 
    
    public TMS_Documentvalidation_CC(){
        wtpanel = false;
        wtpanel1 = true;
        delayreason = true;
        delayreason1 = false;
        PoItemPanel = false;
        //this.controller = controller;
        plantcode = 'Chiplun Plant';
        counterId = new List<Integer>();
        counterId.add(1);
        //system.debug('tmsList-->'+tmsList);
        testdoc = System.currentPageReference().getParameters().get('testdoc');
        material = new List<TMS_Material__c>();
        testString = new List<String>();
        matDesc = new List<String>();
                material = [select id,Name,Material_Code__c from TMS_Material__c ORDER BY Name ASC];
        for(TMS_Material__c tmm:material)
        {
        testString.add(tmm.Material_Code__c);
        matDesc.add(tmm.Name);
        }
        
        
        DocumentList = new List<TMS_Truck_Entry_Checklist__c>();
        DocumentList = [select id,Vehicle_Number__c,Date__c,Truck__c,Name,Vendor_Customer__c,Transporter__c,Document_Validation_Time__c,Quantity_Validation_Time__c,Challan_Number__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc ];
        DocumentList1 = [select id,Vehicle_Number__c,Date__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Document_Validation_Time__c,Quantity_Validation_Time__c,TMS_ItemWeight__c,Action__c,Status__c,Material_Description__c,Material_Code__c,PO_Number__c,Invoice_number__c,Invoice_Qty__c,UOM__c,Po_Item__c,initial_Wt__c,Final_Wt__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc];
        
        tAction = DocumentList[0].Action__c;
        
        //poitemList = new List<TMS_PO_items__c>();
       // poitemList = [select id,name,Material_Description__c from TMS_PO_items__c where TMS_PO__r.Truck_Entry_Checklist__c=:testdoc];
        poItem = new List<TMS_PO_items__c>();
        poItem = [select id,choosePO__c,Po_Item__c,Invoice_Qty__c,UOM__c,Material_Description__c,Name,Initial__c,Final_Wt__c,Net_Quantity__c,TMS_PO__r.id,TMS_PO__r.Name,TMS_PO__r.PO_Number__c,TMS_PO__r.Truck_No__c,TMS_PO__r.Invoice_Qty__c,TMS_PO__r.Invoice_No__c,TMS_PO__r.UOM__c,TMS_PO__r.Plant_Code__c from TMS_PO_items__c where TMS_PO__r.Truck_No__c=:testdoc];        
        searchCategory = 'Manual Entry';
        
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
        DateTime dt = system.now(); 
        //Time myTime = dt.timeGMT();          
                       
        decimal decMinutes = ((dt.getTime())/1000/60) - ((trucktime.getTime())/1000/60);
        //system.debug('decMinutes->'+decMinutes);
        if(decminutes > 5){
            delayreason = true;
            delayreason1 = false;
        } else{
            delayreason = false;
            delayreason1 = true;
        }                   
        
    }
    
    public void manualweight(){
        if(wtpanel==false && wtpanel1==true){
            wtpanel = true;
            wtpanel1 = false;
        }        
    }
     
    public pageReference acceptTruck(){
        //system.debug('delay-->'+delay);
        uomList = new List<TMS_PO__c>();
        uomList = [SELECT UOM__c,(select UOM__c from TMS_PO_items__r),Truck_Entry_Checklist__r.Name,Truck_Entry_Checklist__r.Initial_Wt__c from TMS_PO__c where Truck_Entry_Checklist__r.Id=:testdoc LIMIT 1];
        set<id> poid = new set<id>();
        for(TMS_PO__c po : uomList){
            poid.add(po.id);        
        }
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList1 = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Weight_Edited_User__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Document_Validation_Time__c,Quantity_Validation_Time__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc LIMIT 1];
        truckList1 = [select id,PO_Number__c,Vehicle_Number__c,Weight_Edited_User__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Document_Validation_Time__c,Quantity_Validation_Time__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc LIMIT 1];        
        string mDesc;
        for(string tmsma: matdesc){
            mDesc = tmsma;
        }
        
        for(TMS_Truck_Entry_Checklist__c tms:truckList){   
        for(TMS_PO_items__c poitem : [select TMS_PO__r.Name,TMS_PO__r.Invoice_No__c,UOM__c,Po_Item__c,Material_Description__c from TMS_PO_items__c where TMS_PO__r.id=:poid]){
            
            if(poitem.UOM__c == 'PC'){                               
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Doc Validated';
                    tms.Delay_Reason__c = delay;
                    //tms.Material_Desc__c = mDesc;
                    tms.Document_Validation_Time__c = system.now();
                    tmsList.add(tms);                     
            }
            else if(poitem.UOM__c == 'EA'){ 
                               
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Doc Validated';
                    tms.Delay_Reason__c = delay;
                    //tms.Material_Desc__c = mDesc;
                    tms.Document_Validation_Time__c = system.now();
                    tmsList.add(tms);                     
            }
            else if(poitem.UOM__c == 'CS'){ 
                    //tms.Material_Desc__c = mDesc;           
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Doc Validated';
                    tms.Delay_Reason__c = delay;
                    tms.Document_Validation_Time__c = system.now();
                    tmsList.add(tms);                     
            }
            else{
                    //tms.Material_Desc__c = mDesc;           
                    tms.Action__c = 'Int weight';
                    tms.Status__c = 'Doc Validated';
                    tms.Delay_Reason__c = delay;
                    tms.Document_Validation_Time__c = system.now();
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
        system.debug('intweight-->'+intweight);
        system.debug('finalweight-->'+finalweight);
        //controller.save();
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,PO_Number__c,Vehicle_Number__c,Weight_Edited_User__c,Truck__c,Vendor_Customer__c,Transporter__c,Challan_Number__c,Action__c,Status__c,Material_Description__c,Material_Code__c,Document_Validation_Time__c,Quantity_Validation_Time__c from TMS_Truck_Entry_Checklist__c where Id=:testdoc LIMIT 1];
        for(TMS_Truck_Entry_Checklist__c tms:truckList){
            //tms.Action__c = 'Exit';
            tms.Status__c = 'Qty validated';
            tms.Quantity_Validation_Time__c = system.now();
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
        TMS_PO__c tpo = [Select id from TMS_PO__c where id=:poId];
        delete tpo;
        return null;
    }
    public pageReference deletePOLineRecord()
    {
        TMS_PO_items__c tlo = [Select id from TMS_PO_items__c where id=:plId];
        delete tlo;
        return null;
    }
}