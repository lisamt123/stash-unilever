public with sharing class TMS_TruckSummaryScreen_CC { 
public List<Tmstruck> tmstrucks { get; set; }
public List<Tmstruck> trucks1 { get; set; }
//public string updatedtime {get;set;}
public string baypicklist {get; set;}
public string selectedbay {get; set;}
public string tmsid {get;set;}
public string printid {get; set;}
public String delrow {get;set;}
public string remrow{get; set;}
public string hold {get; set;}
public string baydes {get; set;}
public string intweigh {get; set;}
public string bayreach {get; set;}
public string load {get; set;}
public string loadComplete {get; set;}
public string finalWeigh {get; set;}
public string interim {get;set;}
public string interimExt {get; set;}
public string finalQuan {get; set;}
public string qa {get; set;}
public string printslip {get; set;}
public boolean displayPopup {get; set;} 
public boolean displayPopup1 {get; set;}
public boolean displayPopup2 {get; set;}
public string terreason {get; set;}
public string detReason {get; set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList{get; set;}
Map<string,string> mapBay = new Map<string,string>();
public List<TMS_Bay_Master__c>truckupdatelist{get;set;}
public List<TMS_Bay_Master__c>trlist{get;set;}
public Set<String> selchkboxs {get;set;}
public Boolean hasSelbox {get;set;}
public string Testite{get; set;}
Public boolean ut{get;set;}
//public id RecordTypeId{get;set;} 
public string updatedtime {get;set;}
public string selectedValue {get;set;}
public List<SelectOption> chbays;

    public List<selectOption> getchbays()
    {
        List<selectOption> options = new List<selectOption>(); 
        options.add(new selectOption('','- None-'));
        for(TMS_Bay_Master__c chbay : [Select Id, Name FROM TMS_Bay_Master__c])
        {
            options.add(new selectOption(chbay.Name, chbay.Name));
        }
        return options;
    }

public List<TMS_Truck_Entry_Checklist__c> truckList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList1{get; set;}
public List<TMS_Truck_Entry_Checklist__c> listtruckentry = new List<TMS_Truck_Entry_Checklist__c>();
//public List<RecordType> rType = new List<RecordType>();
    public TMS_TruckSummaryScreen_CC() {
        ut=false;
        selchkboxs = new Set<String>();
        tmstrucks = new List<Tmstruck>();
        delrow = System.currentPageReference().getParameters().get('delrow');
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,Truck__c,Vehicle_Number__c,Truck_Type__c,Vendor_Customer__c,Initial_Wt__c,Transporter__c,Challan_Number__c from TMS_Truck_Entry_Checklist__c where Vehicle_Number__c=:delrow];
        truckupdatelist = [select id from TMS_Bay_Master__c];
        List<TMS_Truck_Entry_Checklist__c> trucks = [select id,name,Truck__c,Date__c,Vehicle_Number__c,Truck_Type__c,
            Material_Description__c,Vendor_Customer__c,Status__c,Date_Time__c,Detention_Time__c,
           PO_Number__c,Action__c,Bay_Number__c,Bay_Description__c,Bay_Wait_Time__c,CreatedDate,Initial_Wt__c 
          from TMS_Truck_Entry_Checklist__c WHERE Status__c!='Exit' ORDER BY Date__c DESC];
        //rType = [SELECT Id, name FROM RecordType WHERE SObjectType='TMS_Truck_Entry_Checklist__c' AND Id=:RecordTypeId];
        List<TMS_Bay_Master__c> bays = [SELECT Id, Name, Bay_Description__c, STD_Wait_Time__c FROM TMS_Bay_Master__c ORDER BY Name ASC];
        List<SelectOption> options = new List<SelectOption>();
        options.add(new Selectoption('None','None'));
        for(TMS_Bay_Master__c bs : bays) {            
            options.add(new SelectOption(bs.Name,bs.Name));
            mapBay.put(bs.Name,bs.Bay_Description__c);
        }        
         integer y=0;
        for(TMS_Truck_Entry_Checklist__c trs : trucks) {            
            tmstrucks.add(new Tmstruck(trs,options,y));
            y=y+1;
        }
        
    }

    public class Tmstruck {
        public Id id { get; set; }
        public TMS_Bay_Master__c trs1{get;set;}
        public TMS_Truck_Entry_Checklist__c tcl{get;set;} 
        public string name { get; set; }
        public string vehicleno { get; set; }
        public string trucktype { get; set; }
        public string recordtype { get; set;}
        public string materialdesc { get; set; }
        public string vendor { get; set; }
        public string bay1 { get; set; }
        public string baydesc { get; set; }
        public string status { get; set; }
        public string action { get; set; }
        public datetime datetime1 { get; set;}
        public String po { get; set; }
        public string bayno {get;set;}
        public string baydes {get;set;}
        public string stdtime { get; set; }
        public boolean isSelected {get;set;}
        public string updatedtime {get;set;}
        public Decimal intialweigth {get;set;}
        public List<SelectOption> baypicklist{get; set;}
        public string selectedbay{get; set;}
        public string selectedValue {get; set;}
        public integer i{get; set;}
        //isSelected = false;
        public Tmstruck(TMS_Truck_Entry_Checklist__c trs , List<SelectOption> bayNum,integer y) {
            i=y;
            tcl = trs;
            this.id = trs.Id;
            this.name = trs.name;
            this.vehicleno = trs.Vehicle_Number__c;
            this.recordtype= trs.Truck__c;
            this.materialdesc = trs.Material_Description__c;
            this.vendor = trs.Vendor_Customer__c;
            this.status = trs.status__c;
            this.action = trs.Action__c;
            this.datetime1 = trs.Date__c;
            this.po = trs.PO_Number__c;
            this.bay1 = trs.Bay_Number__c;
            this.baydesc = trs.Bay_Description__c;
            this.intialweigth = trs.Initial_Wt__c;
            //this.stdtime = trs.Bay_Wait_Time__c;
            this.isselected = false;
            this.updatedtime = trs.Bay_Wait_Time__c;
            baypicklist = bayNum;
        }

        public Tmstruck(TMS_Bay_Master__c bs) {
            this.id = bs.Id;
            this.bayno = bs.Name;
            this.baydes = bs.Bay_Description__c;
            this.stdtime = bs.STD_Wait_Time__c;
        }
    }
    public void populatebaydesc(){
    
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('firstParam'));
        string bayno = Apexpages.currentPage().getParameters().get('secondParam');
        tmstrucks[ite].baydes = mapBay.get(bayno);        
    }
   public PageReference bayUpdate(){
       
    truckupdatelist=new List<TMS_Bay_Master__c>();
    List<Tmstruck> TempWrapper = new List<Tmstruck>();
       for(Tmstruck w :tmstrucks) { 
            if(w.isSelected){
                truckupdatelist.add(w.trs1);
            } else {
                TempWrapper.add(w);
            }
       }
         List<TMS_Truck_Entry_Checklist__c> tmstruckList = new List<TMS_Truck_Entry_Checklist__c>();
         
         integer ite = integer.valueof(Testite);
         List<TMS_Bay_Master__c> tmbaywt=[SELECT Id, Name, Bay_Description__c, STD_Wait_Time__c 
                                     FROM TMS_Bay_Master__c where Name=:tmstrucks[ite].selectedbay];
                if(tmbaywt.size()>0){                               
                 TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
                 Integer bayvalue = 0;
                 string baystr;
                 tsentrycheck.id = tmstrucks[ite].id; 
                 tsentrycheck.Bay_Number__c = tmstrucks[ite].selectedbay;
                 tsentrycheck.Bay_Description__c = tmstrucks[ite].baydes;                 
                 DateTime t = system.now();
                 Time tm = t.Time();
                 Integer i1 = t.hour()-1;
                 Integer i2 = t.minute();
                 Integer waitmin = i2 + Integer.valueof(tmbaywt[0].STD_Wait_Time__c);
                 if(waitmin>60)  // && i1>=24
                 {  
                     i1 = i1+1;
                     waitmin = waitmin-60;
                 }
                 string str = i1 +':'+ waitmin;
                 tsentrycheck.Bay_Wait_Time__c = str; 
                // tsentrycheck.Date__c=Date.today();
                 tsentrycheck.Action__c='Move To Bay';
                 //tsentrycheck.Status__c='Bay Allocated';                   
                 listtruckentry.add(tsentrycheck);
                if(listtruckentry.size()>0){
                    update listtruckentry;
                }
                Integer value = 0;
                if(listtruckentry.size()>0){
                    for(TMS_Truck_Entry_Checklist__c tmtruck :listtruckentry){ 
                        TMS_Truck_Entry_Checklist__c tmentry = new TMS_Truck_Entry_Checklist__c();
                        if(tmtruck.Bay_Description__c==null){
                        if(tmtruck.Bay_Number__c.equals(tmstrucks[ite].selectedbay)){
                            value = value+1;
                            tmentry.id = tmstrucks[ite].id;
                            tmentry.Bay_Number__c = tmtruck.Bay_Number__c + ' '+'Wait';
                            tmstruckList.add(tmentry);
                        }                        
                    } 
                    }      
                }
                if(!tmstruckList.isempty()){
                    update tmstruckList;
                }
                
                PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                pg.setRedirect(true);
                return pg;
               }       
           return null;           
     }    
     
            
     public PageReference truckonHold(){
         integer ite = integer.valueof(hold);
         hold = System.currentPageReference().getParameters().get('hold');
         truckList = new List<TMS_Truck_Entry_Checklist__c>();
         truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:hold];
         TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
         tsentrycheck.Id=tmstrucks[ite].id; 
         PageReference acctPage = new PageReference('/' + tsentrycheck.Id);
         acctPage.setRedirect(true);
         return acctPage;
                     
     }
     public PageReference intWeight(){
     
             integer ite = integer.valueof(intweigh);
             intweigh = System.currentPageReference().getParameters().get('intweigh');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:intweigh];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             //tsentrycheck.Action__c='Allocate Bay';
             tsentrycheck.Status__c='Initial Wt.done';
             truckList.add(tsentrycheck);
             update truckList;
             
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     }        
     public PageReference reachBay(){
             integer ite = integer.valueof(bayreach);
             bayreach = System.currentPageReference().getParameters().get('bayreach');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:bayreach];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Unload/Load Done';
            // tsentrycheck.Status__c='Moved To Bay';
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     } 
     public void unloadLoad(){
             integer ite = integer.valueof(load);
             load= System.currentPageReference().getParameters().get('load');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:load];
             
            /* TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Fin weight';
             //tsentrycheck.Status__c='Unload/Load Done';
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;      */   
     }
     public PageReference finalWeight(){
             integer ite = integer.valueof(finalWeigh);
             finalWeigh= System.currentPageReference().getParameters().get('finalWeigh');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:finalWeigh];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Qnty Val';
             tsentrycheck.Status__c='Final Wt.done';
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     }
     public PageReference finalQuantity(){
             integer ite = integer.valueof(finalQuan);
             finalQuan= System.currentPageReference().getParameters().get('finalQuan');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:finalQuan];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             //tsentrycheck.Action__c='Exit';
             tsentrycheck.Status__c='Qty validated';
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     } 
     public PageReference InterimExit(){
             integer ite = integer.valueof(interim);
             interim= System.currentPageReference().getParameters().get('interim');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:interim];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Interim Entry';
             //tsentrycheck.Status__c='Return frm Ext Bay';
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     }
     public PageReference interimEntry(){
             integer ite = integer.valueof(interimExt);
             interimExt= System.currentPageReference().getParameters().get('interimExt');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:interimExt];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Exit';
             tsentrycheck.Status__c='External Bay Selected';
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     } 
     public pageReference removeRow(){
             integer ite = integer.valueof(remrow);
             remrow= System.currentPageReference().getParameters().get('remrow');
             List<TMS_Truck_Entry_Checklist__c > remtruck = new List<TMS_Truck_Entry_Checklist__c >();
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c,Detention_Time__c from TMS_Truck_Entry_Checklist__c where id=:remrow];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             //tsentrycheck.Status__c='Exit';
             tsentrycheck.Exit_Time__c=system.now();
             truckList.add(tsentrycheck);
             update truckList;
             truckList1 = [select id,Vehicle_Number__c,Action__c,Status__c,Exit_Time__c,Detention_Time__c from TMS_Truck_Entry_Checklist__c where id=:truckList[0].Id];
             //TMS_Truck_Entry_Checklist__c ts = new TMS_Truck_Entry_Checklist__c();
             for(TMS_Truck_Entry_Checklist__c ts:truckList1){
             
                 if(ts.Detention_Time__c>30.00){
                     displayPopup2 = true;
                 }else{
                     tsentrycheck.Id=ts.id; 
                     tsentrycheck.status__c='Exit';
                     //tsentrycheck.Exit_Time__c=system.now();
                     truckList1.add(tsentrycheck);
                     //update truckList1;
                     PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                     pg.setRedirect(true);
                     return pg;
                 }
             }
             
             
             //PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             //pg.setRedirect(true);
             //return pg;    
             return null; 
     }
     
            
     public PageReference QAReceive(){
         List<TMS_Truck_Entry_Checklist__c> updateTEC = new List<TMS_Truck_Entry_Checklist__c>();
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                    TMS_Truck_Entry_Checklist__c tc = new TMS_Truck_Entry_Checklist__c();
                     tc.Id = tm.tcl.id;
                     tc.Status__c = 'Terminate The Truck';
                     //tc.Action__c = 'QA Accepted';
                     updateTEC.add(tc);
                 }
                 tm.isSelected = false; 
                 if(updateTEC!=null && updateTEC.size()>0){
                    update updateTEC;
                    PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                    pg.setRedirect(true);
                    return pg;
                }
                else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row to update QA Receive'));    
                 }                 
             }             
         }
         return null;
     }
     public PageReference QAApprove(){
         List<TMS_Truck_Entry_Checklist__c> updateTEC = new List<TMS_Truck_Entry_Checklist__c>();
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                    TMS_Truck_Entry_Checklist__c tc = new TMS_Truck_Entry_Checklist__c();
                     tc.Id = tm.tcl.id;
                     tc.Status__c = 'Sample Collected';
                    // tc.Action__c = 'Allocate Bay';
                     updateTEC.add(tc);
                 }
                 tm.isSelected = false; 
                 if(updateTEC!=null && updateTEC.size()>0){
                    update updateTEC;
                    PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                    pg.setRedirect(true);
                    return pg;
                }
                 else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row to update QA Approve'));    
                 }
             }            
         }
        return null;
     }
     public PageReference terminate(){
         displayPopup = false; 
         List<TMS_Truck_Entry_Checklist__c> updateTEC = new List<TMS_Truck_Entry_Checklist__c>();
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                    TMS_Truck_Entry_Checklist__c tc = new TMS_Truck_Entry_Checklist__c();
                     tc.Id = tm.tcl.id;
                     tc.Terminate_Reason__c = terreason;
                     //tc.Status__c = 'Exit';
                     tc.Action__c = 'Terminate';
                     updateTEC.add(tc);
                 }
                 tm.isSelected = false; 
                 if(updateTEC!=null && updateTEC.size()>0){
                    update updateTEC;
                    PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                    pg.setRedirect(true);
                    return pg;
                }
                 else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row to terminate the Truck'));    
                 }
             }            
         }
        return null;
     }
     public PageReference detention(){
         displayPopup2 = false; 
         integer ite = integer.valueof(remrow);
             remrow= System.currentPageReference().getParameters().get('remrow');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c,Detention_Time__c from TMS_Truck_Entry_Checklist__c where id=:remrow];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Status__c='Exit';
             tsentrycheck.Detention_Reason__c=detReason;
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;
     }
    public PageReference changeBay(){
         displayPopup1 = false; 
         //integer ite = integer.valueof(Testite);
         List<TMS_Truck_Entry_Checklist__c> updateTEC = new List<TMS_Truck_Entry_Checklist__c>();
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                    TMS_Truck_Entry_Checklist__c tc = new TMS_Truck_Entry_Checklist__c();
                     tc.Id = tm.tcl.id;
                     tc.Bay_Number__c = selectedValue;
                     updateTEC.add(tc);
                 }
                 tm.isSelected = false; 
                 if(updateTEC!=null && updateTEC.size()>0){
                    update updateTEC;
                    PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                    pg.setRedirect(true);
                    return pg;
                }
                 else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row to terminate the Truck'));    
                 }
             }            
         }
        return null;
     }
     public void utmethode()
     {    
         ut=true;
         for(Tmstruck t:tmstrucks)
         {
             if(t.isSelected==true)
             {
                 tmsid=t.id;
             }
         }
     }
     
    public void timeupdate(){
      
      if(ut==false)
      {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the assigned bay to update the time'));
      }
      
          
    }
    public pagereference docValid(){
        PageReference reRend = new PageReference('/apex/TMS_DocumentValidation_VF');
        reRend.setRedirect(true);
        return reRend;
    }
    public pageReference newTruckEntry(){
     
        PageReference reRend = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01Ic00000001ywJ&retURL=%2Fa8r%2Fo&save_new_url=%2Fa8r%2Fe%3FretURL%3D%252Fa8r%252Fo');
        reRend.setRedirect(true);
        return reRend;
  
    }
    public void showPopup(){
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                        displayPopup = true;
                    }
                  else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row to terminate the Truck'));    
                 }
              }
         }  
    }
    public void showPopup1(){
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                        displayPopup1 = true;
                    }
                  else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row to Change the Bay'));    
                 }
              }
         }  
    }
    public void utmethode1()
     {    
         ut=true;
         for(Tmstruck t:tmstrucks)
         {
             if(t.isSelected==true)
             {
                 printid=t.id;
             }
         }
     }
     public void printError(){
      
      if(ut==false)
      {
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select the assigned bay to Print'));
      }
          
    }
}