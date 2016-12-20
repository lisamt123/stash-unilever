public class TMS_TruckTurnAroundTimeReport_CC {
    public List<truckWrapper> truckWrapList {get; set;} 
    public date fromDate {get; set;}
    public date toDate {get; set;} 
    DateTime fDate;
    DateTime TDate;
    public pageReference getValues(){
        
        fDate = datetime.newInstance(fromDate.year(),fromDate.month(),fromDate.day());
        TDate = datetime.newInstance(toDate.year(),toDate.month(),toDate.day());
        system.debug('fDate-->'+fDate);
        system.debug('TDate-->'+TDate);
        return null;
    }  
    public List<truckWrapper> getTruckList(){
       
        string plantvalue;
        string trucktypevalue;
        string trucknumber;
        string serialvalue;
        string transporter;
        string intimevalue;
        string outtimevalue;
        string detentionvalue;
        string rejectreason;
        string terminatereason;
        string docvalue;
        string bayallocate;
        string sampleaccept;
        string qaaccept;
        string unloadtime;
        string interimvalue;
        string interimentryvalue;
        string quantityvalue;
        Integer truckexit;
        Integer stddocval;
        Integer stddocval1;
        Integer stdDocval2;
        Integer stdDocval3;
        Integer stdDocval4;
        Integer stdDocval5;
        Integer stdDocval6;
        Integer stddocvaltime;
        Integer loadtime;
        Integer loadtime1;
        Integer loadtime2;
        Integer loadtime3;
        Integer loadtime4;
        Integer loadtime5;
        Integer loadtime6;
        Integer unloadtimeval;
        Integer bayassign;
        Integer bayassign1;
        Integer bayassign2;
        Integer bayassign3;
        Integer bayassign4;
        Integer bayassign5;
        Integer bayassign6;
        Integer bayassigntime;
        Integer quantity;
        Integer quantity1;
        Integer quantity2;
        Integer quantity3;
        Integer quantity4;
        Integer quantity5;
        Integer quantity6;
        Integer quantitytime;
        Integer qcsample;
        Integer qcsample1;
        Integer qcsample2;
        Integer qcsample3;
        Integer qcsample4;
        Integer qcsample5;
        Integer qcsample6;
        Integer qcsampletime;
        Integer iexit;
        Integer iexit1;
        Integer iexit2;
        Integer iexit3;
        Integer iexit4;
        Integer iexit5;
        Integer iexit6;
        Integer interexit;
        DateTime docvaldelaytime;
        DateTime bayallocatedelaytime;
        Decimal docvalidationdelaytime=0;
        Decimal sampleacceptedtime=0;
        Decimal qaacceptedtime=0;
        Decimal bayreachloadunloadtime=0;
        decimal interimexittime = 0;
        decimal interimentrytime = 0;
        truckWrapList = new List<truckWrapper>();
        for(TMS_Activity_Standard_Time__c std:[select Doc_Vald__c,Truck_Type__c,Unldg_Ldg_Cmp__c,Bay_Assgn__c,Qty_Validation__c,Qc_Sample__c,Intm_Exit__c from TMS_Activity_Standard_Time__c]){
            if(std.Truck_Type__c =='RM Truck'){
                stddocval = Integer.valueof(std.Doc_Vald__c);
                loadtime = Integer.valueof(std.Unldg_Ldg_Cmp__c); 
                bayassign = Integer.valueof(std.Bay_Assgn__c); 
                quantity = Integer.valueof(std.Qty_Validation__c);
                qcsample = Integer.valueof(std.Qc_Sample__c);
                iexit = Integer.valueof(std.Intm_Exit__c);              
            }
            if(std.Truck_Type__c =='FG Dispatch Truck'){
                stddocval1 = Integer.valueof(std.Doc_Vald__c);
                loadtime1 = Integer.valueof(std.Unldg_Ldg_Cmp__c);
                bayassign1 = Integer.valueof(std.Bay_Assgn__c);
                quantity1 = Integer.valueof(std.Qty_Validation__c);
                qcsample1 = Integer.valueof(std.Qc_Sample__c);
                iexit1 = Integer.valueof(std.Intm_Exit__c);  
            }
            if(std.Truck_Type__c =='Packing Material Truck'){
                stddocval2 = Integer.valueof(std.Doc_Vald__c);
                loadtime2 = Integer.valueof(std.Unldg_Ldg_Cmp__c);
                bayassign2 = Integer.valueof(std.Bay_Assgn__c);
                quantity2 = Integer.valueof(std.Qty_Validation__c);
                qcsample2 = Integer.valueof(std.Qc_Sample__c);
                iexit2 = Integer.valueof(std.Intm_Exit__c);  
            }
            if(std.Truck_Type__c =='RM Dispatch Truck'){
                stddocval3 = Integer.valueof(std.Doc_Vald__c);
                loadtime3 = Integer.valueof(std.Unldg_Ldg_Cmp__c);
                bayassign3 = Integer.valueof(std.Bay_Assgn__c);
                quantity3 = Integer.valueof(std.Qty_Validation__c);
                qcsample3 = Integer.valueof(std.Qc_Sample__c);
                iexit3 = Integer.valueof(std.Intm_Exit__c);  
            }
            if(std.Truck_Type__c =='RM Liquid Tanker'){
                stddocval4 = Integer.valueof(std.Doc_Vald__c);
                loadtime4 = Integer.valueof(std.Unldg_Ldg_Cmp__c);
                bayassign4 = Integer.valueof(std.Bay_Assgn__c);
                quantity4 = Integer.valueof(std.Qty_Validation__c);
                qcsample4 = Integer.valueof(std.Qc_Sample__c);
                iexit4 = Integer.valueof(std.Intm_Exit__c);  
            }
            if(std.Truck_Type__c =='RM Slob Truck'){
                stddocval5 = Integer.valueof(std.Doc_Vald__c);
                loadtime5 = Integer.valueof(std.Unldg_Ldg_Cmp__c);
                bayassign5 = Integer.valueof(std.Bay_Assgn__c);
                quantity5 = Integer.valueof(std.Qty_Validation__c);
                qcsample5 = Integer.valueof(std.Qc_Sample__c);
                iexit5 = Integer.valueof(std.Intm_Exit__c);  
            }
            if(std.Truck_Type__c =='Scrap Dispatch Truck'){
                stddocval6 = Integer.valueof(std.Doc_Vald__c);
                loadtime6 = Integer.valueof(std.Unldg_Ldg_Cmp__c);
                bayassign6 = Integer.valueof(std.Bay_Assgn__c);
                quantity6 = Integer.valueof(std.Qty_Validation__c);
                qcsample6 = Integer.valueof(std.Qc_Sample__c); 
                iexit6 = Integer.valueof(std.Intm_Exit__c); 
            }
        }
        
        string soql = 'select Plant__c,Truck__c,Vehicle_Number__c,Serial_Num__c,Time_At_Bay_Reached__c,Transporters__r.name,Date__c,Exit_Time__c,Detention_Time__c,Reject_Reason__c,Terminate_Reason__c,Document_Validation_Time__c,Sample_Accepted_Time__c,Bay_Allocate_Time__c,Qa_Accepted_Time__c,Unload_Load_Done_Time__c,Interim_Entry_Time__c,Interim_Exit_Time__c,Quantity_Validation_Time__c,Truck_Exit__c,Status__c from TMS_Truck_Entry_Checklist__c WHERE CreatedDate>=:fDate AND CreatedDate<=:TDate ORDER BY Date__c DESC LIMIT 1000';
        list<TMS_Truck_Entry_Checklist__c> truckentryList = database.query(soql);
        
        for(TMS_Truck_Entry_Checklist__c tms : truckentryList){
            
            if(tms.Plant__c=='HPC Dapada'){
                if(tms.Truck__c =='RM Truck'){                    
                    stddocvaltime = stddocval;
                    unloadtimeval = loadtime;
                    bayassigntime = bayassign;
                    quantitytime = quantity;
                    qcsampletime = qcsample;
                    interexit = iexit;
                }
                if(tms.Truck__c =='FG Dispatch Truck'){                    
                    stddocvaltime = stddocval1;
                    unloadtimeval = loadtime1;
                    bayassigntime = bayassign1;
                    quantitytime = quantity1;
                    qcsampletime = qcsample1;
                    interexit = iexit1;
                }
                if(tms.Truck__c =='Packing Material Truck'){                    
                    stddocvaltime = stddocval2;
                    unloadtimeval = loadtime2;
                    bayassigntime = bayassign2;
                    quantitytime = quantity2;
                    qcsampletime = qcsample2;
                    interexit = iexit2;
                }
                if(tms.Truck__c =='RM Dispatch Truck'){                    
                    stddocvaltime = stddocval3;
                    unloadtimeval = loadtime3;
                    bayassigntime = bayassign3;
                    quantitytime = quantity3;
                    qcsampletime = qcsample3;
                    interexit = iexit3;
                }
                if(tms.Truck__c =='RM Liquid Tanker'){                    
                    stddocvaltime = stddocval4;
                    unloadtimeval = loadtime4;
                    bayassigntime = bayassign4;
                    quantitytime = quantity4;
                    qcsampletime = qcsample4;
                    interexit = iexit4;
                }
                if(tms.Truck__c =='RM Slob Truck'){                    
                    stddocvaltime = stddocval5;
                    unloadtimeval = loadtime5;
                    bayassigntime = bayassign5;
                    quantitytime = quantity5;
                    qcsampletime = qcsample5;
                    interexit = iexit5;
                }
                if(tms.Truck__c =='Scrap Dispatch Truck'){                    
                    stddocvaltime = stddocval6;
                    unloadtimeval = loadtime6;
                    bayassigntime = bayassign6;
                    quantitytime = quantity6;
                    qcsampletime = qcsample6;
                    interexit = iexit6;
                }
                if(tms.Truck__c !='FG Dispatch Truck' && tms.Truck__c !='RM Truck' && tms.Truck__c !='Packing Material Truck'&&tms.Truck__c !='RM Dispatch Truck' && tms.Truck__c !='RM Liquid Tanker'&&tms.Truck__c !='RM Slob Truck' &&tms.Truck__c !='Scrap Dispatch Truck'){
                    
                    stddocvaltime = 0;
                    unloadtimeval = 0;
                    bayassigntime = 0;
                    quantitytime = 0;
                }
                   /* delay time in mins  start */
                    docvaldelaytime = tms.Document_Validation_Time__c;                    
                    bayallocatedelaytime = tms.Bay_Allocate_Time__c; 
                    system.debug('bayallocatedelaytime-->'+bayallocatedelaytime);
                    DateTime sampletime = tms.Sample_Accepted_Time__c;
                    system.debug('sampletime-->'+sampletime);
                    DateTime qaaccepttime = tms.Qa_Accepted_Time__c;
                    system.debug('qaaccepttime-->'+qaaccepttime);
                    DateTime bayreachtime = tms.Time_At_Bay_Reached__c;
                    DateTime unloadedtime = tms.Unload_Load_Done_Time__c;
                    DateTime interimtime = tms.Interim_Exit_Time__c;
                    DateTime intentrytime = tms.Interim_Entry_Time__c;
                    if(docvaldelaytime !=null && bayallocatedelaytime!=null){
                        docvalidationdelaytime = ((bayallocatedelaytime.getTime())/1000/60) - ((docvaldelaytime.getTime())/1000/60);                        
                    }
                    if(bayallocatedelaytime!=null && sampletime!=null){
                        sampleacceptedtime = ((bayallocatedelaytime.getTime())/1000/60) - ((sampletime.getTime())/1000/60);
                    }
                    if(sampletime!=null && qaaccepttime!=null){
                        qaacceptedtime = ((sampletime.getTime())/1000/60) - ((qaaccepttime.getTime())/1000/60);
                        system.debug('qaacceptedtime--->'+qaacceptedtime);
                    }
                    if(bayreachtime!=null && unloadedtime!=null){
                        bayreachloadunloadtime = ((bayreachtime.getTime())/1000/60) - ((unloadedtime.getTime())/1000/60);
                    }
                    if(bayallocatedelaytime!=null && interimtime!=null){
                        interimexittime = ((bayallocatedelaytime.getTime())/1000/60) - ((interimtime.getTime())/1000/60);
                    }
                    if(intentrytime!=null && interimtime!=null){
                        interimentrytime = ((interimtime.getTime())/1000/60) - ((intentrytime.getTime())/1000/60);
                    }
                    if(docvaldelaytime ==null && bayallocatedelaytime==null){
                        docvalidationdelaytime = 0;                        
                    }
                    if((docvaldelaytime ==null && bayallocatedelaytime!=null) || (docvaldelaytime !=null && bayallocatedelaytime==null)){
                        docvalidationdelaytime = 0;                        
                    }
                    if(bayallocatedelaytime==null && sampletime==null){
                        sampleacceptedtime = 0;                        
                    }
                    if((bayallocatedelaytime ==null && sampletime!=null) || (bayallocatedelaytime!=null && sampletime==null)){
                        sampleacceptedtime = 0;                        
                    }
                    /*if(bayallocatedelaytime==null && qaaccepttime==null){
                        qaacceptedtime = 0;                        
                    }
                    if((bayallocatedelaytime ==null && qaaccepttime!=null) || (bayallocatedelaytime!=null && qaaccepttime==null)){
                        qaacceptedtime = 0;                        
                    }*/
                    if(sampletime==null && qaaccepttime==null){
                        qaacceptedtime = 0;
                    }
                    if((sampletime ==null && qaaccepttime!=null) || (sampletime!=null && qaaccepttime==null)){
                        qaacceptedtime = 0;                        
                    }
                    if(bayreachtime==null && unloadtime==null){
                        bayreachloadunloadtime= 0;
                    }
                    if((bayreachtime==null && unloadedtime!=null) || (bayreachtime!=null && unloadedtime==null)){
                        bayreachloadunloadtime = 0;                        
                    }
                    if(bayallocatedelaytime==null && interimtime==null){
                        interimexittime = 0;
                    } 
                    if((bayallocatedelaytime ==null && interimtime!=null) || (bayallocatedelaytime!=null && interimtime==null)){
                        interimexittime = 0;                        
                    }
                    if(intentrytime==null && interimtime==null){
                        interimentrytime = 0;
                    } 
                    if((intentrytime==null && interimtime!=null) || (intentrytime!=null && interimtime==null)){
                        interimentrytime = 0;                        
                    }
                   /* delay time in mins end */            
                    plantvalue = tms.Plant__c;
                    trucktypevalue = tms.Truck__c;
                    trucknumber = tms.Vehicle_Number__c;
                    serialvalue = tms.Serial_Num__c;
                    transporter = tms.Transporters__r.name;
                    intimevalue = string.valueof(tms.Date__c);
                    outtimevalue = string.valueof(tms.Exit_Time__c);
                    detentionvalue = string.valueof(tms.Detention_Time__c);
                    rejectreason = tms.Reject_Reason__c;
                    terminatereason = tms.Terminate_Reason__c;
                    docvalue = string.valueof(tms.Document_Validation_Time__c);
                    bayallocate = string.valueof(tms.Bay_Allocate_Time__c);
                    sampleaccept = string.valueof(tms.Sample_Accepted_Time__c);
                    qaaccept = string.valueof(tms.Qa_Accepted_Time__c);
                    unloadtime = string.valueof(tms.Unload_Load_Done_Time__c);
                    interimvalue = string.valueof(tms.Interim_Exit_Time__c);
                    interimentryvalue = string.valueof(tms.Interim_Entry_Time__c);
                    quantityvalue = string.valueof(tms.Quantity_Validation_Time__c);
                    truckexit = Integer.valueof(tms.Truck_Exit__c);                
                    truckWrapList.add(new truckWrapper(plantvalue,trucktypevalue,trucknumber,transporter,serialvalue,intimevalue,outtimevalue,detentionvalue,rejectreason,terminatereason,docvalue,bayallocate,sampleaccept,qaaccept,unloadtime,interimvalue,interimentryvalue,quantityvalue,truckexit,stddocvaltime,unloadtimeval,bayassigntime,quantitytime,qcsampletime,interexit,docvalidationdelaytime,sampleacceptedtime,qaacceptedtime,bayreachloadunloadtime,interimexittime,interimentrytime));
            }
        }       
        
        return truckWrapList;
    }
    public class truckWrapper{
        public string plantname {get; set;}
        public string trucktype {get; set;}
        public string trucknum {get; set;}
        public string serialnum {get; set;}
        public string transport {get; set;}
        public string intime {get; set;}
        public string outtime {get; set;}
        public string detention {get; set;}
        public string reject {get; set;}
        public string terminate {get; set;}
        public string doctime {get; set;}
        public string baytime {get; set;}
        public string sample {get; set;}
        public string qaaccept {get; set;}
        public string unload {get; set;}
        public string interim {get; set;}
        public string interimentry {get; set;}
        public string quantity {get; set;}
        public Integer texit {get; set;}        
        public Integer stddoc {get; set;}
        public Integer loadval {get; set;}
        public Integer bayassign {get; set;}
        public Integer stdquantity {get; set;}
        public Integer qcsample {get; set;}
        public Integer iexit {get; set;}
        public decimal docdelaytime {get; set;}
        public decimal sampleacceptdelaytime {get; set;}
        public decimal qaaccptime {get; set;}
        public decimal bayreachtime {get; set;}
        public decimal interimtime {get; set;}
        public decimal inentrytime {get; set;}
        public truckWrapper(string p,string t,string tn,string tran,string s,string i,string o,string d,string r,string te,string doc,string bayalloc,string sam,string qa,string u,string ir,string entry,string qn,Integer ex,Integer val,integer lo,Integer bay,Integer quan,Integer qcs,Integer ie,decimal docdelay,decimal samdelay,decimal qaa,decimal bayreach,decimal rim,decimal ientry){
            plantname = p;
            trucktype = t;
            trucknum=tn;
            transport = tran;
            serialnum = s;
            intime = i;
            outtime = o;
            detention = d;
            reject = r;
            terminate =te;
            doctime = doc;
            baytime = bayalloc;
            sample = sam;
            qaaccept = qa;
            unload = u;
            interim = ir;
            interimentry = entry;
            quantity = qn;
            texit = ex;           
            stddoc =val;
            loadval =lo;
            bayassign = bay;
            stdquantity = quan;
            qcsample = qcs;
            iexit = ie;
            docdelaytime = docdelay;
            sampleacceptdelaytime = samdelay;
            qaaccptime= qaa;
            bayreachtime = bayreach;
            interimtime = rim;
            inentrytime = ientry;
        }        
    }        
    public pageReference exportExcel(){
          pageReference pg = new pageReference('/apex/TMS_TruckTurnAroundTimeReport1_VF');
          pg.setRedirect(true);
          return pg;
    }
}