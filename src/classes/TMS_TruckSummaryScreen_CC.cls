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
public string printing {get; set;}
public boolean displayPopup1 {get; set;}
public boolean displayPopup2 {get; set;}
public string terreason {get; set;}
public string detReason {get; set;}
public List<TMS_Truck_Entry_Checklist__c> DocumentList{get; set;}
public List<AggregateResult> trucksnum{get; set;}
Map<string,string> mapBay = new Map<string,string>();
public List<TMS_Bay_Master__c>truckupdatelist{get;set;}
public List<TMS_Bay_Master__c>trlist{get;set;}
public Set<String> selchkboxs {get;set;}
public Boolean hasSelbox {get;set;}
public string Testite{get; set;}
Public boolean ut{get;set;}
//public id RecordTypeId{get;set;} 
public string updatedtime {get;set;}
public string saaccept {get; set;}
public string selectedValue {get;set;}
public List<SelectOption> chbays;
string baynumupdate;
string baywaittime;
public Id truckId {get; set;}
Tms_PlantCode__c mcs = Tms_PlantCode__c.getInstance();

public AggregateResult[] rmtruck{
        get {
           return [select count(Id) co from TMS_Truck_Entry_Checklist__c where Status__c!='Exit' AND (Truck__c='RM Truck' OR Truck__c='RM Liquid Tanker' OR Truck__c='RM Dispatch Truck' OR Truck__c='RM Bulk Tankers' OR Truck__c='Hazardous Truck') AND Serial_Num__c=:mcs.Plant_Code__c];
        }
}
public AggregateResult[] fgtruck {
        get {
           return [select count(Id) co from TMS_Truck_Entry_Checklist__c where Status__c!='Exit' AND Truck__c='FG Dispatch Truck' AND Serial_Num__c=:mcs.Plant_Code__c];
        }
}
public AggregateResult[] pmtruck {
        get {
           return [select count(Id) co from TMS_Truck_Entry_Checklist__c where Status__c!='Exit' AND Truck__c='Packing Material Truck' AND Serial_Num__c=:mcs.Plant_Code__c];
        }
}
public AggregateResult[] others{
        get {
           return [select count(Id) co from TMS_Truck_Entry_Checklist__c where Status__c!='Exit' AND (Truck__c='Scrap Dispatch Truck' OR Truck__c='Trial Material Truck' OR Truck__c='Engineering Materials Truck' OR Truck__c='General Vehicle') AND Serial_Num__c=:mcs.Plant_Code__c];
        }
}
public AggregateResult[] total{
        get {
           return [select count(Id) co from TMS_Truck_Entry_Checklist__c where Status__c!='Exit' AND Serial_Num__c=:mcs.Plant_Code__c ];
        }
}

    public List<selectOption> getchbays()
    {
        List<selectOption> options = new List<selectOption>(); 
        //options.add(new selectOption('','- None-'));
        List<TMS_Bay_Master__c> bayMastersList = [Select Id,Name FROM TMS_Bay_Master__c];
        system.debug('bayMastersList-->'+bayMastersList);
        set<string> masterslist = new set<string>();
        List<TMS_Bay_Master__c> bayList = new List<TMS_Bay_Master__c>();
        for(TMS_Bay_Master__c tmsbay : bayMastersList){
            if(masterslist.contains(tmsbay.name)){
                bayList.add(tmsbay);
            }else{
                masterslist.add(tmsbay.name);
            }
        }
        List<string> baystrList = new List<string>();
        baystrList.addAll(masterslist);        
        for(string chbay : baystrList){
            options.add(new selectOption(chbay, chbay));
        }
        return options;
    }

public List<TMS_Truck_Entry_Checklist__c> truckList{get; set;}
public List<TMS_Truck_Entry_Checklist__c> truckList1{get; set;}
public List<TMS_Truck_Entry_Checklist__c> listtruckentry = new List<TMS_Truck_Entry_Checklist__c>();
//public List<RecordType> rType = new List<RecordType>();
List<TMS_Truck_Entry_Checklist__c> trucks;
public TMS_Truck_Entry_Checklist__c trucksList {get; set;}
public boolean showContent {get; set;}
public boolean showContent1 {get; set;}

    public TMS_TruckSummaryScreen_CC() {
        showContent = false;
        showContent1 = false;
        ut=false;
              
        selchkboxs = new Set<String>();
        tmstrucks = new List<Tmstruck>();
        delrow = System.currentPageReference().getParameters().get('delrow');
        Tms_PlantCode__c mcs = Tms_PlantCode__c.getInstance();
        //system.debug('msc->'+ mcs);
        truckList = new List<TMS_Truck_Entry_Checklist__c>();
        truckList = [select id,Truck__c,Vehicle_Number__c,Truck_Type__c,Vendor_Customer__c,Initial_Wt__c,Transporter__c,Challan_Number__c from TMS_Truck_Entry_Checklist__c where Vehicle_Number__c=:delrow];
        truckupdatelist = [select id from TMS_Bay_Master__c];
        trucks = [select id,name,Question__c,Answer__c,Truck__c,Date__c,Vehicle_Number__c,Truck_Type__c,
            Material_Description__c,Bay_Number_Updated__c,Vendor_Customer__c,Status__c,Date_Time__c,Detention_Time__c,Number__c,
           PO_Number__c,Action__c,Bay_Number__c,Bay_Description__c,Bay_Wait_Time__c,CreatedDate,Initial_Wt__c,Sample_Accepted_Time__c,Bay_Allocate_Time__c,Qa_Accepted_Time__c,QA_Rejected_Time__c,Interim_Entry_Time__c,Interim_Exit_Time__c 
          from TMS_Truck_Entry_Checklist__c WHERE Status__c!='Exit' AND Serial_Num__c=:mcs.Plant_Code__c ORDER BY Date__c DESC];
        trucksnum = new List<AggregateResult>();
        trucksnum = [select count(Id), truck__c from TMS_Truck_Entry_Checklist__c where Status__c!='Exit' AND Serial_Num__c=:mcs.Plant_Code__c GROUP BY Truck__c ];
        //system.debug('no.of trucks'+trucksnum);
        //rType = [SELECT Id, name FROM RecordType WHERE SObjectType='TMS_Truck_Entry_Checklist__c' AND Id=:RecordTypeId];
        string truckname;
        for(TMS_Truck_Entry_Checklist__c trss : trucks) {  
            truckname = trss.Truck__c;
        }
        system.debug('truckname-->'+truckname);
        //options.add(new Selectoption('None','None'));
        List<TMS_Bay_Master__c> bays = [SELECT Id, Name, Bay_Description__c, STD_Wait_Time__c FROM TMS_Bay_Master__c ORDER BY Name ASC];
        List<SelectOption> options = new List<SelectOption>();
        set<string> masterslist = new set<string>();
        List<TMS_Bay_Master__c> bayList = new List<TMS_Bay_Master__c>();
        for(TMS_Bay_Master__c tmsbay : bays){
            if(masterslist.contains(tmsbay.name)){
                bayList.add(tmsbay);
            }else{
                //if(truckname.contains('QC')){
                    masterslist.add(tmsbay.name);
                //}
            }
        }
        List<string> baystrList = new List<string>();
        baystrList.addAll(masterslist);
        system.debug('baystrList-->'+baystrList);  
        for(TMS_Bay_Master__c bs : bays) {       
            mapBay.put(bs.Name,bs.Bay_Description__c);
        }
        for(string chbay : baystrList){
            options.add(new SelectOption(chbay,chbay));
        }        
        integer y=0;
        system.debug('trucks-->'+trucks); 
        for(TMS_Truck_Entry_Checklist__c trs : trucks) {            
            tmstrucks.add(new Tmstruck(trs,options,y));
            y=y+1; 
            if(trs.Bay_Number_Updated__c!=null){
                system.debug('numUpdate-->'+trs.Bay_Number_Updated__c);             
                baynumupdate = trs.Bay_Number_Updated__c;           
            }                               
        }        
        system.debug('baynumupdate-->'+baynumupdate);                      
    }
        
    public void populatebaydesc(){    
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('firstParam'));
        string bayno = Apexpages.currentPage().getParameters().get('secondParam');
        tmstrucks[ite].baydes = mapBay.get(bayno);        
    }
   public PageReference bayUpdate(){ 
        system.debug('trucks-->'+trucks); 
        Tms_PlantCode__c mcs = Tms_PlantCode__c.getInstance();
        
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
         string sBay;
         
         integer ite = integer.valueof(Testite);
         List<TMS_Bay_Master__c> tmbaywt=[SELECT Id, Name, Bay_Description__c, STD_Wait_Time__c FROM TMS_Bay_Master__c where Name=:tmstrucks[ite].selectedbay];
                if(tmbaywt.size()>0){                               
                 TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
                 Integer bayvalue = 0;
                 string baystr;
                 tsentrycheck.id = tmstrucks[ite].id; 
                 tsentrycheck.Bay_Number__c = tmstrucks[ite].selectedbay;
                 sBay = tmstrucks[ite].selectedbay;
                 //system.debug('sBay-->'+sBay);
                 tsentrycheck.Bay_Description__c = tmstrucks[ite].baydes;                 
                 DateTime t = system.now();
                 Time tm = t.Time();
                 //Integer stdtime = Integer.valueof(tmbaywt[0].STD_Wait_Time__c);
                 //Time addtime = tm.addMinutes(stdtime);
                 //Time addtime1 = addtime.addMinutes(1);
                 string stdstr = string.valueof(tm).substring(0,5);
                 //tsentrycheck.Bay_Wait_Time__c = stdstr;
                 tsentrycheck.Bay_Wait_Time__c = stdstr;
                 //system.debug('baynumupdate-->'+baynumupdate);
                 
                    List<TMS_Truck_Entry_Checklist__c> tmsupdate = [select status__c,bay_Number_Updated__c,Bay_Wait_Time__c from TMS_Truck_Entry_Checklist__c WHERE Status__c!='Exit' AND Bay_Wait_Time__c!=null AND bay_number__c=:sBay AND Serial_Num__c=:mcs.Plant_Code__c ORDER BY CreatedDate DESC LIMIT 1];
                    List<TMS_Truck_Entry_Checklist__c> tmsupdate1 = [select status__c,bay_Number_Updated__c,Bay_Wait_Time__c from TMS_Truck_Entry_Checklist__c WHERE Status__c!='Exit' AND Bay_Wait_Time__c!=null AND bay_number__c=:sBay AND Serial_Num__c=:mcs.Plant_Code__c];
                    system.debug('tmsupdate1-->'+tmsupdate1.size());                    
                    List<TMS_Truck_Entry_Checklist__c> tmsupdateList = [select status__c,bay_Number_Updated__c,Bay_Wait_Time__c from TMS_Truck_Entry_Checklist__c WHERE Status__c='Exit' AND Bay_Wait_Time__c!=null AND bay_number__c=:sBay AND Serial_Num__c=:mcs.Plant_Code__c];
                    system.debug('tmsupdateList-->'+tmsupdateList.size());
                    Integer updateCount = tmsupdateList.size();
                    Integer count=tmsupdate1.size();
                    for(TMS_Truck_Entry_Checklist__c ts:tmsupdate){
                         if(ts.Bay_Wait_Time__c !=null){
                             baywaittime = ts.Bay_Wait_Time__c;      
                         }                         
                    }                    
                    system.debug('sBay-->'+sBay);                    
                    tsentrycheck.bay_Number_Updated__c = sBay; 
                    if(baywaittime !=null){                    
                    if(baynumupdate.containsAny(sBay)){                        
                    if(count>0){                        
                        tsentrycheck.bay_Number_Updated__c = sBay +' ' +'Wait' + ' ' +count;                                   
                    }
                    if(updateCount>0){
                        tsentrycheck.bay_Number_Updated__c = sBay +' ' +'Wait' + ' ' +count;                                   
                    }                    
                    string d = baywaittime;                    
                    string s = d.substring(0,2);                    
                    string s1 = d.substring(3,5);                    
                    Time newtime = Time.newInstance(Integer.valueof(s),Integer.valueof(s1),0,0);                    
                    Integer stdtime = Integer.valueof(tmbaywt[0].STD_Wait_Time__c);
                    Time waittime = newtime.addMinutes(stdtime);
                    Integer intwait = 5;
                    Time waittm = waittime.addMinutes(intwait);                    
                    string baywaitstr = string.valueof(waittm).substring(0,5);                    
                    tsentrycheck.Bay_Wait_Time__c = baywaitstr;                    
                 }
                 }                 
                 tsentrycheck.Bay_Allocate_Time__c=system.now();
                 tsentrycheck.Action__c='Move To Bay';
                 //tsentrycheck.Status__c='Bay Allocated';                   
                 listtruckentry.add(tsentrycheck);
                 if(listtruckentry.size()>0){
                    update listtruckentry;
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
         PageReference acctPage = new PageReference('/apex/TMS_Truckentryscreen?id=' + tsentrycheck.Id);
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
             tsentrycheck.Int_Weight_Time__c = system.now();
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
             //truckList1 = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c from TMS_Truck_Entry_Checklist__c where id=:bayreach];
             //truckList1 = [select id,Action__c,Bay_Number__c from TMS_Truck_Entry_Checjlist__c where Bay_Number__c=:];
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
             tsentrycheck.Time_At_Weigh_Bridge__c = system.now();
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
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c,Interim_Entry_Time__c from TMS_Truck_Entry_Checklist__c where id=:interim];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Interim Entry';
             tsentrycheck.Status__c='Return frm Ext Bay';
             tsentrycheck.Interim_Entry_Time__c = system.now();
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
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c,Interim_Exit_Time__c from TMS_Truck_Entry_Checklist__c where id=:interimExt];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             //tsentrycheck.Action__c='Exit';
             tsentrycheck.Action__c='Qnty Val';
             tsentrycheck.Status__c='External Bay Selected';
             tsentrycheck.Interim_Exit_Time__c = system.now();
             truckList.add(tsentrycheck);
             update truckList;
             PageReference pg = Page.TMS_TruckSummaryScreen_VF;
             pg.setRedirect(true);
             return pg;         
     } 
     public PageReference sampleAccept(){
             
             integer ite = integer.valueof(saaccept);
             saaccept= System.currentPageReference().getParameters().get('saaccept');
             truckList = new List<TMS_Truck_Entry_Checklist__c>();
             truckList = [select id,Vehicle_Number__c,Action__c,Status__c,Sample_Accepted_Time__c from TMS_Truck_Entry_Checklist__c where id=:saaccept];
             TMS_Truck_Entry_Checklist__c tsentrycheck = new TMS_Truck_Entry_Checklist__c();
             tsentrycheck.Id=tmstrucks[ite].id; 
             tsentrycheck.Action__c='Allocate Bay';
             tsentrycheck.Status__c='QA Accepted'; 
             tsentrycheck.Sample_Accepted_Time__c = system.now();          
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
             //tsentrycheck.Action__c='Get Detention Reason';
             tsentrycheck.Exit_Time__c=system.now();
             truckList.add(tsentrycheck);
             update truckList;
             truckList1 = [select id,Vehicle_Number__c,Action__c,TMS_T_Entry_Time__c,TMS_T_Exit_Time__c,Status__c,Exit_Time__c,Detention_Time__c from TMS_Truck_Entry_Checklist__c where id=:truckList[0].Id];
             //TMS_Truck_Entry_Checklist__c ts = new TMS_Truck_Entry_Checklist__c();
             for(TMS_Truck_Entry_Checklist__c ts:truckList1){
             
                 if(ts.TMS_T_Entry_Time__c<=510 && ts.TMS_T_Exit_Time__c<=1020){
                    /* //displayPopup2 = true;
                      tsentrycheck.Id=ts.id; 
                     tsentrycheck.Action__c='Get Detention Reason';
                     //tsentrycheck.Exit_Time__c=system.now();
                     truckList1.add(tsentrycheck);
                     //update truckList1;
                     PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                     pg.setRedirect(true);
                     return pg;*/
                     tsentrycheck.Id=ts.id; 
                     tsentrycheck.status__c='Exit';
                     //tsentrycheck.Exit_Time__c=system.now();
                     truckList1.add(tsentrycheck);
                     //update truckList1;
                     PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                     pg.setRedirect(true);
                     return pg;
                     
                 }else{
                     tsentrycheck.Id=ts.id; 
                     tsentrycheck.Action__c='Get Detention Reason';
                     //tsentrycheck.Exit_Time__c=system.now();
                     truckList1.add(tsentrycheck);
                     //update truckList1;
                     PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                     pg.setRedirect(true);
                     return pg;
                     
                    /* tsentrycheck.Id=ts.id; 
                     tsentrycheck.status__c='Exit';
                     //tsentrycheck.Exit_Time__c=system.now();
                     truckList1.add(tsentrycheck);
                     //update truckList1;
                     PageReference pg = Page.TMS_TruckSummaryScreen_VF;
                     pg.setRedirect(true);
                     return pg;*/
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
                     tc.QA_Rejected_Time__c = system.now();
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
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
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
                     tc.Action__c = 'Allocate Bay';
                     tc.Qa_Accepted_Time__c = system.now();
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
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
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
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
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
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
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
          ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select particular row for this Action'));
      }
      
          
    }
    public pagereference docValid(){
        PageReference reRend = new PageReference('/apex/TMS_DocumentValidation_VF');
        reRend.setRedirect(true);
        return reRend;
    }
    public pageReference newTruckEntry(){
     
        PageReference reRend = new PageReference('/setup/ui/recordtypeselect.jsp?ent=01Ic00000001ywJ&retURL=%2Fa8r%2Fo&save_new_url=%2Fa8r%2Fe%3FretURL%3D%252Fa8r%252Fo');
        reRend .getParameters().put('isnew','True');
        reRend.setRedirect(true);
        return reRend;
        
    //Schema.DescribeSObjectResult R = TMS_Truck_Entry_Checklist__c.SObjectType.getDescribe();
    // Add /o to end of URL to view recent
    //return new PageReference('/' + R.getKeyPrefix() + '/e');
  
    }
    public void showPopup(){
         if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                        displayPopup = true;
                    }
                  else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
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
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
                 }
              }
         }  
    }
    public void printing(){
            
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                        printid=tm.id;
                        //system.debug('printid->'+printid);
                    }
                  else{
                    ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'Please select particular row for this Action'));    
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
                 ut=false;
             }
         }
         /*if(tmstrucks!=null && tmstrucks.size()>0){
             for(Tmstruck tm: tmstrucks){                 
                 if(tm.isSelected){
                      printid=tm.id;
                    }
                 }
            }*/
     }
     public pagereference printError(){
      
          for(Tmstruck tm: tmstrucks) 
          {
              if(tm.isSelected){                 
                  //system.debug('selected-->'+tm.id); 
                                 
                  PageReference redirectPage = Page.TMS_printLoadingSlip;
                    redirectPage.setRedirect(true);
                    redirectPage.getParameters().put('tid',tm.id);
                    return redirectPage;
              }else{
                  ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please select particular row for this Action'));                     
              }
          }              
        return null;
    }
    public pageReference qaAccept(){
        if(showContent==false){
            showContent = true;
        }
        return null;
    }
    public void savedocDate(){
        string tmsid1 = Apexpages.currentPage().getParameters().get('testdoc');
        TMS_Truck_Entry_Checklist__c tmscheck=[select id,Docval_Time__c from TMS_Truck_Entry_Checklist__c where id=:tmsid1];
        //system.debug('tmscheck-->'+tmscheck);
        tmscheck.Docval_Time__c = string.valueof(system.now());
        update tmscheck;
        
      //  Pagereference  pgref = new pagereference('/apex/TMS_Documentvalidation_VF1?testdoc='+tmsid);
      //  pgref.setRedirect(true);
      //  return pgref;
        // return null;
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
        public string serial { get; set; }
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
            this.serial = trs.Number__c;
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

}