public class TMS_truckentryscreen {
    public string recdtype {get; set;}
    public TMS_Truck_Entry_Checklist__c truckentry {get; set;}
    public List<TMS_Checklist__c> tmschklists {get;set;}
    string rectype;
    public boolean rfid {get; set;}
    public boolean ponumber {get; set;}
    public boolean status {get; set;}
    public boolean action {get; set;}
    public boolean challan {get; set;}
    public boolean vendor {get; set;}
    public boolean lrnum {get; set;}
    public boolean transporter {get; set;}
    public Id  teId {get; set;}
        
    public TMS_truckentryscreen(ApexPages.StandardController controller) {
        rfid = true;
        ponumber = true;
        challan = true;
        vendor = true;
        lrnum = true;
        transporter = true;        
    }
    public void truckentryscreen(){
        
        recdtype = ApexPages.currentPage().getParameters().get('RecordType');
        //system.debug('recdtype-->'+recdtype);
        //TMS_Truck_Entry_Checklist__c truck = [select recordtype.name from TMS_Truck_Entry_Checklist__c where recordtypeId =:recdtype LIMIT 1];         
        recordtype recordname =[select recordtype.name from recordtype where Id=:recdtype];
        //system.debug('recordname-->'+recordname);
        rectype = recordname.name;
        if(recordname.name =='Engineering Materials Truck'){
            rfid = false;
        }
        if(recordname.name =='RM Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
        }
        if(recordname.name =='Hazardous Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
        }
        if(recordname.name == 'Packing Material Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
        }
        if(recordname.name == 'Engineering Materials Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
        }
        if(recordname.name == 'RM Bulk Tankers'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
        }
        if(recordname.name == 'RM Liquid Tanker'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
        }
        if(recordname.name == 'FG Dispatch Truck'){
        
        }
        if(recordname.name == 'Scrap Dispatch Truck'){
            rfid = true;
            ponumber = false;
            challan = false;
            vendor = false;
            lrnum = true;
            transporter = false;
        }
        if(recordname.name == 'General Vehicle'){
            rfid = true;
            ponumber = false;
            challan = false;
            vendor = false;
            lrnum = false;
            transporter = false;     
        }
        
        //system.debug('rectype-->'+rectype);
        tmschklists=[SELECT id,Name, Expected_Answer__c,Material_Type__c FROM TMS_Checklist__c where Material_Type__c=:rectype];
        //system.debug('tmschklists-->'+tmschklists);
        truckentry=[SELECT Id,Name,Challan_Number__c,Vendor__c,
                LR_Number__c,Transporter__c,PO_Number__c,Vehicle_Number__c,RFID__c,
                Status__c,Material_Desc__c,Action__c,Relay_Item_Id__c,Initial_Wt__c,Truck__c,Reject_Reason__c,
                TMS_Current_Weight__c,TMS_ItemWeight__c,truck_Action__c,Expected_Answer__c  FROM TMS_Truck_Entry_Checklist__c LIMIT 1];
        truckentry.clear();
        
    }
    public pageReference save(){
        truckentry.Truck__c = rectype;
        truckentry.Answer__c = getExpectedAnswers();         
        truckentry.Question__c = getQuestions();
        upsert truckentry;
        Pagereference pg = new Pagereference('https://unilever--scpaperles.cs14.my.salesforce.com/'+truckentry.Id);
        pg.setredirect(true);
        return null;
    }
   
    public string getQuestions(){
        //system.debug('tmschklists1-->'+tmschklists);
        string tQ = '';
        string tempq = '';
        for(TMS_Checklist__c tms: tmschklists){
            tq = tq + tms.Name +'\n';
        }
        //system.debug('tq-->'+tq);
        if(tq.length()>0){
            tempq = tq.substring(0,tq.length()-1);
        }
        //system.debug('tempq-->'+tempq);    
        return tempq;                    
    }
    
    public string getExpectedAnswers(){
        string exp = '';
        string expAns = '';
        for(TMS_Checklist__c tms: tmschklists){
            exp = exp + tms.Expected_Answer__c +'\n';
        }
        if(exp.length()>0){
            expAns = exp.substring(0,exp.length()-1);    
        }
        return expAns;
    }
    
     
    public pageReference cancel(){
        Pagereference pg = new Pagereference('https://unilever--scpaperles.cs14.my.salesforce.com/a8r');
        pg.setredirect(true);
        return pg;
    }  
    
    public pageReference getRFID(){
        Pagereference pg ;
        TMS_RFID__c rfID = [Select RFID_Card_Number__c,RFID_plant_code__c from TMS_RFID__c where RFID_plant_code__c='DAPADA' Limit 1];
        truckentry.RFID__c = rfID.RFID_Card_Number__c;
        
        delete rfID;
        return null;
    }
}