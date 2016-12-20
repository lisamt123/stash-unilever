public class TMS_Popup_unloadLoadDone_CC {
public string tmsloadid{get;set;}
public List<TMS_Truck_Entry_Checklist__c> Tsentryload{get; set;}
public List<TMS_PO__c> po{get; set;}
public List<TMS_PO_items__c> poItem{get; set;}
public List<TMS_PO_items__c> poItem1{get; set;}
public List<TMS_Shipment_Items__c> shipItem {get; set;}
public List<TMS_Shipment_Items__c> shipItem1 {get; set;}
public List<TMS_PO__c> uomList{get; set;}
public List<TMS_Shipment__c> uomShipList{get; set;}
public TMS_Shipment__c shipList{get; set;}
    public TMS_Popup_unloadLoadDone_CC(ApexPages.StandardController controller){
        Tsentryload = new List<TMS_Truck_Entry_Checklist__c>();
        tmsloadid = ApexPages.currentPage().getParameters().get('tloadid');
        Tsentryload = [select id,name,Vehicle_Number__c,Bay_Number__c,Action__c,Status__c,Unload_Load_Done_Time__c from TMS_Truck_Entry_Checklist__c WHERE id=:tmsloadid]; 
        poItem = [select TMS_PO__r.id,TMS_PO__r.name,TMS_PO__r.PO_Number__c,TMS_PO__r.Invoice_No__c,id,name,Material_Description__c,Quantity_Rcvd__c,choosePO__c,Invoice_Qty__c,UOM__c,Po_Item__c from TMS_PO_items__c  where TMS_PO__r.Truck_Entry_Checklist__c=:tmsloadid AND choosePO__c = false ORDER BY createdDate DESC]; 
        shipItem = [select TMS_Shipment__r.id,TMS_Shipment__r.name,Item_No__c,id,Name,Quantity_Rcvd__c,UOM__c,Choose_ShipItem__c,Material_Description__c from TMS_Shipment_Items__c where TMS_Shipment__r.Truck_Entry_Checklist__c=:tmsloadid AND Choose_ShipItem__c = false ORDER BY createdDate DESC];
    }
    public void save(){       
        List<TMS_Truck_Entry_Checklist__c> tmsList = new List<TMS_Truck_Entry_Checklist__c>();     
        if(!poItem.isEmpty()){        
        upsert poItem;
        uomList = new List<TMS_PO__c>();
        uomList = [SELECT UOM__c,(select UOM__c from TMS_PO_items__r),Truck_Entry_Checklist__r.Name from TMS_PO__c where Truck_Entry_Checklist__r.Id=:tmsloadid LIMIT 1];
        set<id> poid = new set<id>();
        for(TMS_PO__c po : uomList){
            poid.add(po.id);        
        }
        system.debug('poitem1-->'+poitem.size());
        
        if(poitem.size()>=1){
            for(TMS_Truck_Entry_Checklist__c tms: Tsentryload){
                for(TMS_PO_items__c poit :poItem){
                system.debug('poit-->'+poit);
                if(poit.choosePO__c!=true){                
                if(poit.UOM__c == 'PC'){
                system.debug('entred');                
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Unload/Load Done';
                    tmsList.add(tms);
                }
                else if(poit.UOM__c == 'EA'){
                system.debug('entred');                
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Unload/Load Done';
                    tmsList.add(tms);
                }
                else if(poit.UOM__c == 'CS'){
                system.debug('entred');                
                    tms.Action__c = 'Allocate Bay';
                    tms.Status__c = 'Unload/Load Done';
                    tmsList.add(tms);
                }
                else{
                system.debug('entered else');
                    tms.Action__c = 'Int weight';
                    tms.Status__c = 'Unload/Load Done';
                    tmsList.add(tms);
                }
                }else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Choose PO'));
                     } 
                }
            }
            if(!tmsList.isEmpty()){
                update tmsList;
            }
        } 
        List<TMS_Truck_Entry_Checklist__c> tmstruckList = new List<TMS_Truck_Entry_Checklist__c>();
        system.debug('Tsentryload-->'+Tsentryload);
        system.debug('poitem-->'+poitem.size());
        if(poitem.size()<=1){
        system.debug('poid-->'+poid);
        for(TMS_Truck_Entry_Checklist__c tms: Tsentryload){ 
            for(TMS_PO_items__c poi: [select TMS_PO__r.Name,UOM__c,choosePO__c from TMS_PO_items__c where TMS_PO__r.id=:poid ORDER BY CreatedDate DESC]){            
            if(poi.choosePO__c == true){
            if(poi.UOM__c == 'PC'){ 
                    tms.Action__c = 'Qnty Val';
                    tms.Status__c = 'Unload/Load Done';
                    tms.Unload_Load_Done_Time__c = system.now();
                    tmstruckList.add(tms);                     
            }
            else if(poi.UOM__c == 'EA'){ 
                    tms.Action__c = 'Qnty Val';
                    tms.Status__c = 'Unload/Load Done';
                    tms.Unload_Load_Done_Time__c = system.now();
                    tmstruckList.add(tms);                     
            }
            else if(poi.UOM__c == 'CS'){ 
                    tms.Action__c = 'Qnty Val';
                    tms.Status__c = 'Unload/Load Done';
                    tms.Unload_Load_Done_Time__c = system.now();
                    tmstruckList.add(tms);                     
            }
            else{
                    system.debug('entered TON'); 
                    tms.Action__c = 'Fin weight';
                    tms.Status__c = 'Unload/Load Done';
                    tms.Unload_Load_Done_Time__c = system.now();
                    tmstruckList.add(tms);                  
                }
              }
            }
            }
        set<TMS_Truck_Entry_Checklist__c> setList = new set<TMS_Truck_Entry_Checklist__c>(tmstruckList);        
        List<TMS_Truck_Entry_Checklist__c> tmstruckentryList = new List<TMS_Truck_Entry_Checklist__c>(setList);        
        if(!tmstruckentryList.isEmpty()){
            update tmstruckentryList;
        } 
        }
        }
        
        List<TMS_Truck_Entry_Checklist__c> tmsList1 = new List<TMS_Truck_Entry_Checklist__c>(); 
        if(!shipItem.isEmpty()){             
            upsert shipItem;             
            uomShipList = new List<TMS_Shipment__c>();
            uomShipList = [SELECT UOM__c,(select UOM__c from TMS_Shipment_Items__r),Truck_Entry_Checklist__r.Name from TMS_Shipment__c where Truck_Entry_Checklist__r.Id=:tmsloadid LIMIT 1];
        
            set<id> shipid = new set<id>();
            for(TMS_Shipment__c ship : uomShipList){
                shipid.add(ship.id);        
            }
            
            if(shipItem.size()>=1){ 
            system.debug('Tsentryload-->'+Tsentryload);            
            for(TMS_Truck_Entry_Checklist__c tms: Tsentryload){
                for(TMS_Shipment_Items__c ship : [select TMS_Shipment__r.Name,UOM__c,Choose_ShipItem__c from TMS_Shipment_Items__c where TMS_Shipment__r.id=:shipid ORDER BY CreatedDate DESC]){
                    system.debug('entered');  
                    if(ship.Choose_ShipItem__c!= true){                 
                    if(ship.UOM__c=='PC'){
                    system.debug('enteredddddd');
                        tms.Action__c = 'Allocate Bay';
                        tms.Status__c = 'Unload/Load Done';
                        tmsList1.add(tms);
                    }
                    else if(ship.UOM__c=='EA'){
                    system.debug('enteredddddd');
                        tms.Action__c = 'Allocate Bay';
                        tms.Status__c = 'Unload/Load Done';
                        tmsList1.add(tms);
                    }
                    else if(ship.UOM__c=='CS'){
                    system.debug('enteredddddd');
                        tms.Action__c = 'Allocate Bay';
                        tms.Status__c = 'Unload/Load Done';
                        tmsList1.add(tms);
                    }
                    else{
                        tms.Action__c = 'Int weight';
                        tms.Status__c = 'Unload/Load Done';
                        tmsList1.add(tms);
                    }  
                  } 
                  else{
                        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please Choose PO'));
                     }                  
                }
            }
            set<TMS_Truck_Entry_Checklist__c> settruck = new set<TMS_Truck_Entry_Checklist__c>(tmsList1);
            List<TMS_Truck_Entry_Checklist__c> truckTms = new List<TMS_Truck_Entry_Checklist__c>(settruck);
            system.debug('tmsList1-->'+tmsList1); 
                if(!truckTms.isEmpty()){
                    update truckTms;
                }
            }
          List<TMS_Truck_Entry_Checklist__c> tmstruckList1 = new List<TMS_Truck_Entry_Checklist__c>();   
          if(shipitem.size()<=1){
          for(TMS_Truck_Entry_Checklist__c tms: Tsentryload){   
            for(TMS_Shipment_Items__c shipitem2 : [select TMS_Shipment__r.Name,UOM__c,Choose_ShipItem__c from TMS_Shipment_Items__c where TMS_Shipment__r.id=:shipid ORDER BY CreatedDate DESC]){
                system.debug('shipitem2-->'+shipitem2.UOM__c); 
                if(shipitem2.Choose_ShipItem__c == true){              
                if(shipitem2.UOM__c == 'PC'){ 
                        tms.Action__c = 'Qnty Val';
                        tms.Status__c = 'Unload/Load Done';
                        tms.Unload_Load_Done_Time__c = system.now();
                        tmstruckList1.add(tms);                     
                }
                else if(shipitem2.UOM__c == 'EA'){ 
                        tms.Action__c = 'Qnty Val';
                        tms.Status__c = 'Unload/Load Done';
                        tms.Unload_Load_Done_Time__c = system.now();
                        tmstruckList1.add(tms);                     
                }
                else if(shipitem2.UOM__c == 'CS'){ 
                        tms.Action__c = 'Qnty Val';
                        tms.Status__c = 'Unload/Load Done';
                        tms.Unload_Load_Done_Time__c = system.now();
                        tmstruckList1.add(tms);                     
                }
                else{                        
                        tms.Action__c = 'Fin weight';
                        tms.Status__c = 'Unload/Load Done';
                        tms.Unload_Load_Done_Time__c = system.now();
                        tmstruckList1.add(tms);
                    } 
                   }                 
                }
              }              
            }
            set<TMS_Truck_Entry_Checklist__c> setList1 = new set<TMS_Truck_Entry_Checklist__c>(tmstruckList1);        
            List<TMS_Truck_Entry_Checklist__c> tmstruckentryList1 = new List<TMS_Truck_Entry_Checklist__c>(setList1);            
            if(!tmstruckentryList1.isEmpty()){
                update tmstruckentryList1;
            }  
        }     
    }         
}