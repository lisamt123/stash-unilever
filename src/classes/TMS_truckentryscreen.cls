public with sharing class TMS_truckentryscreen {

    public TMS_truckentryscreen() {
        
    }
    public string questions {get; set;}
    public string answers {get; set;} 
    public string getQuestions {get; set;}
    public string trAns {get; set;}
    Map<string,string> oldMap = new Map<string,string>();
    Map<string,string> newMap = new Map<string,string>();
    List<string> newstrs = new List<string>();
    public string recdtype {get; set;}
    public TMS_Truck_Entry_Checklist__c truckentry {get; set;}
    public TMS_Truck_Entry_Checklist__c truckentry1 {get; set;}
    public List<TMS_Checklist__c> tmschklists {get;set;}
    public TMS_Checklist__c tmschklist1 {get;set;}
    public TMS_Truck_Entry_Checklist__c trucklist{get;set;}
    public TMS_Truck_Entry_Checklist__c truckentrylist{get;set;}
    public List<TMS_Truck_Entry_Checklist__c> trucklist1{get;set;}
    public List<TMS_Truck_Entry_Checklist__c> trkveh;
    public integer trkSize;
    public string tmsid;
    public string truckId {get; set;}
    public string rectype{get;set;}
    public boolean rfid {get; set;}
    public boolean ponumber {get; set;}
    public boolean status {get; set;}
    public boolean action {get; set;}
    public boolean challan {get; set;}
    public boolean vendor {get; set;}
    public boolean lrnum {get; set;}
    public boolean transporter {get; set;}
    public boolean matdesc {get; set;}
    public boolean license {get; set;}
    public boolean checkSameTrans{get; set;}
    public Id  teId {get; set;}
    public String newRec{get; set;}
    string getAns;
    public string isDisabled {get; set;}
    List<TMS_Vendor_Transporter_Customer_Mast__c> vendorName; 
    List<TMS_Vendor_Transporter_Customer_Mast__c> vendorName1;    
    public Map<string,TMS_Vendor_Transporter_Customer_Mast__c> allvendors;
    public Map<string,TMS_Vendor_Transporter_Customer_Mast__c> allvendors1;
    public Map<string,string> vendormap;
    public Map<string,string> vendormap1;
    public string vendname {get; set;}
    public string vendname1 {get; set;}
    string vname; 
    string transportername; 
    string materialsname;
    List<TMS_Material__c> materialname;
    public Map<string,TMS_Material__c> allmaterials;
    public Map<string,string> materialMap;
    public string materialdescname {get; set;}
    public string selectedvendor {get; set;}    
    
    TMS_Vendor_Transporter_Customer_Mast__c tmsvendor;
    TMS_Vendor_Transporter_Customer_Mast__c tmsvendor1;
    TMS_Material__c tmmat;
    
   public TMS_truckentryscreen(ApexPages.StandardController controller) {        
        recdtype = ApexPages.currentPage().getParameters().get('RecordType');
        recordtype recordname = new recordtype();
        truckentry1 = [SELECT Id, RecordTypeId, Truck__c FROM TMS_Truck_Entry_Checklist__c LIMIT 1];
        if(recdtype != null){
        recordname =[select recordtype.name from recordtype where Id=:recdtype];
        rectype = recordname.name;
        }
        else{
        recordname =[select recordtype.name from recordtype where Id=:truckentry1.RecordTypeId ];
        rectype = recordname.name;
        }        
        vendorname = new List<TMS_Vendor_Transporter_Customer_Mast__c>();
        vendorname1 = new List<TMS_Vendor_Transporter_Customer_Mast__c>();
        vendormap = new Map<string,string>();
        vendormap1 = new Map<string,string>();
        allvendors = new Map<string,TMS_Vendor_Transporter_Customer_Mast__c>(); 
        allvendors1 = new Map<string,TMS_Vendor_Transporter_Customer_Mast__c>(); 
        for(TMS_Vendor_Transporter_Customer_Mast__c tmsvendor:[select name,Identifier__c from TMS_Vendor_Transporter_Customer_Mast__c ]){            
            if(tmsvendor.Identifier__c=='C'){
                allvendors.put(tmsvendor.name,tmsvendor);
            }
            if(tmsvendor.Identifier__c=='V'){
                allvendors.put(tmsvendor.name,tmsvendor);
            }            
        }
        vendorname = allvendors.values();
        for(TMS_Vendor_Transporter_Customer_Mast__c tmsvendor1:[select name,Identifier__c from TMS_Vendor_Transporter_Customer_Mast__c]){            
            if(tmsvendor1.Identifier__c=='T'){
                allvendors1.put(tmsvendor1.name,tmsvendor1);
            }                        
        }   
        vendorname1 = allvendors1.values();        
        for(TMS_Vendor_Transporter_Customer_Mast__c ven : vendorname){            
               vendormap.put(ven.name,ven.name);            
        }
        for(TMS_Vendor_Transporter_Customer_Mast__c ven1 : vendorname1){            
               vendormap1.put(ven1.name,ven1.name);                        
        }               
        materialname = new List<TMS_Material__c>();
        allmaterials = new Map<string,TMS_Material__c>();
        materialMap = new Map<string,string>();                 
        for(TMS_Material__c tmsmat:[select id,name from TMS_Material__c]){//WHERE Material_Type__c=:recordname.name         
            allmaterials.put(tmsmat.name,tmsmat);    
        }
        materialname = allmaterials.values(); 
        for(TMS_Material__c tmat : materialname){
            materialMap.put(tmat.Name,tmat.Name);        
        }                
        rfid = true;
        ponumber = true;
        challan = true;
        vendor = true;
        lrnum = true;
        transporter = true;   
        matdesc = true;
        license = true;    
        trucklist = new TMS_Truck_Entry_Checklist__c();
        trucklist = (TMS_Truck_Entry_Checklist__c)controller.getRecord();
        tmsid=ApexPages.currentPage().getParameters().get('Id');               
        if(tmsid != null){
        truckentry = [SELECT Id, Name, Vendor__c, Detention_Reason__c, Vehicle_Number__c,owner.name, Challan_Number__c, 
                     LR_Number__c, PO_Number__c, Bay_Number__c, Bay_Description__c, Status__c, Action__c, Site__c, 
                     Material_Desc__c, Initial_Wt__c,RFID__c, Serial_Number__c, Final_Wt__c, Date_Time__c,Question__c, 
                     Truck__c, Answer__c, Reject_Reason__c, Delay_Reason__c,Exp_Checklist_Date__c,Transporters__c,Driver_License_Number__c,
                     Serial_Num__c,truck_Action__c,TMS_Current_Weight__c,recordTypeId,Relay_Item_Id__c FROM TMS_Truck_Entry_Checklist__c where id=:tmsid];
        }                  
    }    
    public void showfields(){
        vname = vendname;         
    }
    public void showfields1(){
        transportername = vendname1;      
    }
    public void showfields2(){
        materialsname = materialdescname;              
    }   
    public string myList {get{        
        isDisabled ='false';
        string myList ='';
        for(string name:vendormap.keyset()){        
            mylist = mylist+'"'+name+'"'+',';
        }           
        return mylist;        
    }set;}
    public string myList1 {get{       
        isDisabled ='false';
        string myList1 ='';
        for(string name1:vendormap1.keyset()){        
            mylist1 = mylist1+'"'+name1+'"'+',';
        }            
        return mylist1;        
    }set;}
    public string myList2 {get{        
        isDisabled ='false';
        string myList2 ='';
        for(string name2:materialMap.keyset()){        
            mylist2 = mylist2+'"'+name2+'"'+',';
        }           
        return mylist2;        
    }set;}    
    
    public void truckentryscreen(){        
        recdtype = ApexPages.currentPage().getParameters().get('RecordType');
        newRec= ApexPages.currentPage().getParameters().get('isnew');
        recordtype recordname = new recordtype();
        if(recdtype != null){
        recordname =[select recordtype.name from recordtype where Id=:recdtype];        
        rectype = recordname.name;
        }
        else{
          recordname =[select recordtype.name from recordtype where Id=:truckentry.recordTypeId];
          rectype = recordname.name; 
        }
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
            matdesc = true;
            license = true;
        }
        if(recordname.name =='Hazardous Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
            matdesc = true;
            license = true;
        }
        if(recordname.name == 'Packing Material Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
            matdesc = true;
            license = true;
        }
        if(recordname.name == 'Engineering Materials Truck'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
            matdesc = true;
            license = true;
        }
        if(recordname.name == 'RM Bulk Tankers'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
            matdesc = true;
            license = true;
        }
        if(recordname.name == 'RM Liquid Tanker'){
            rfid = true;
            ponumber = true;
            challan = true;
            vendor = true;
            lrnum = true;
            transporter = true;
            matdesc = true;
            license = true;
        }
        if(recordname.name == 'Scrap Dispatch Truck'){
            rfid = true;
            ponumber = false;
            challan = false;
            vendor = false;
            lrnum = true;
            transporter = false;
            matdesc = false;
            license = true;
        }
        if(recordname.name == 'General Vehicle'){
            rfid = true;
            ponumber = false;
            challan = false;
            vendor = false;
            lrnum = false;
            transporter = false;    
            matdesc = false;
            license = false;
        }
        if(recordname.name == 'FG Dispatch Truck'){
            rfid = true;
            ponumber = false;
            challan = false;
            vendor = true;
            lrnum = true;
            transporter = true;    
            matdesc = false;
            license = true;
        }
        if(recordname.name == 'RM Dispatch Truck'){
            rfid = true;
            ponumber = false;
            challan = false;
            vendor = true;
            lrnum = true;
            transporter = true;    
            matdesc = false;
            license = true;
        }
        
        tmschklists=[SELECT id,Name,Date__c,Expected_Answer__c,Material_Type__c,Date_Flag__c FROM TMS_Checklist__c where Material_Type__c=:rectype];
        //tmschklist1=[SELECT id,Date__c,Date_Flag__c from TMS_Checklist__c where Date_Flag__c='X'];
        /*truckentry=[SELECT Id,Name,Challan_Number__c,Vendor__c,Driver_License_Number__c,Vendor_Customer__c, Date__c,
                LR_Number__c,Transporters__c,Transporter__c,PO_Number__c,Vehicle_Number__c,RFID__c,Material_Description__c,
                Status__c,Material_Desc__c,Action__c,Relay_Item_Id__c,Initial_Wt__c,Truck__c,Reject_Reason__c,
                TMS_Current_Weight__c,TMS_ItemWeight__c,truck_Action__c,Expected_Answer__c  FROM TMS_Truck_Entry_Checklist__c LIMIT1];
        */     
        string exp = '';
        string expAns = '';
        for(TMS_Checklist__c tms: tmschklists){
            exp = exp + tms.Expected_Answer__c +'\n';
            oldMap.put(tms.name,tms.Expected_Answer__c);
        }
        
        if(exp.length()>0){
            expAns = exp.substring(0,exp.length()-1);    
        }
        getAns = expAns;        
    }
    
    public pageReference save(){
        Map<string,string> ansMap = new Map<string,string>();
        ansMap = expectedAnswers();
        
        for(string str : oldMap.keyset()){
            for(string str1 : oldMap.values()){            
                if(ansMap.containsKey(str)){
                    ansmap.remove(str1);                
                }
            }
        }        
        //string trAns;
        //string TMSID1 = ApexPages.currentPage().getParameters().get('Id');
        if(tmsid == null){
        List<TMS_Truck_Entry_Checklist__c> tmsveh1 =[select id,Vehicle_Number__c,Status__c,Action__c,RFID__c,truck_Action__c from TMS_Truck_Entry_Checklist__c 
                                                    where Vehicle_Number__c=:trucklist.Vehicle_Number__c AND Id !=:tmsid AND Status__c!='Exit' AND Action__c!='Get Detention Reason'];
                                                 
         if(tmsveh1.size()>0){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Vehicle with same number is already inside the Factory'));
           return null; 
         }                                         
      }
      trkSize = [select count() from TMS_Truck_Entry_Checklist__c where Status__c!='Exit'];
      if(trkSize>50){
           ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'Maximum Number of Trucks already inside the Factory....Please wait'));
           return null; 
         }
      //List<TMS_Truck_Entry_Checklist__c> tmsveh =[select id,Vehicle_Number__c,Status__c,RFID__c,truck_Action__c from TMS_Truck_Entry_Checklist__c where id=:tmsid AND Status__c!='Exit'];
        
      Id tmId;
      Id trId;
      Id mId;
      for(TMS_Vendor_Transporter_Customer_Mast__c tm:[select id,name from TMS_Vendor_Transporter_Customer_Mast__c where name=:vname]){
          tmId = tm.id;
      }
      for(TMS_Vendor_Transporter_Customer_Mast__c tr:[select id,name from TMS_Vendor_Transporter_Customer_Mast__c where name=:transportername]){
          trId = tr.id;
      }
      for(TMS_Material__c matr:[select id,name from TMS_Material__c where name=:materialsname]){
          mid = matr.id;          
      }
        checkSameTrans=true;                                            
        trucklist.Truck__c = rectype;
        trucklist.Answer__c = getExpectedAnswers();
        trAns = getExpectedAnswers();
        truckList.Vendor__c = tmId;
        truckList.Transporters__c = trId;
        truckList.Material_Desc__c = mId;       
        trucklist.Question__c = getQuestions();
        //string getQuestions = getQuestions();
        getQuestions = getQuestions();
        trucklist.Exp_Checklist_Date__c = getDates();
        if(trucklist.truck_Action__c == 'Accept' && trucklist.Truck__c != 'FG Dispatch Truck' && trucklist.Truck__c != 'RM Dispatch Truck' && trucklist.Truck__c != 'Scrap Dispatch Truck'){
            trucklist.Action__c = 'Doc Val';
            trucklist.Status__c = 'Arrived';
        }
        else if(trucklist.truck_Action__c == 'Accept' && trucklist.Truck__c == 'FG Dispatch Truck' ){
            trucklist.Action__c = 'Create Shipment';
            trucklist.Status__c = 'Arrived';
        }
        else if(trucklist.truck_Action__c == 'Accept' && trucklist.Truck__c == 'RM Dispatch Truck' ){
            trucklist.Action__c = 'Create Shipment';
            trucklist.Status__c = 'Arrived';
        }
        else if(trucklist.truck_Action__c == 'Accept' && trucklist.Truck__c == 'Scrap Dispatch Truck'){
            trucklist.Action__c = 'Create Shipment';
            trucklist.Status__c = 'Arrived';
        }
        if(trucklist.truck_Action__c == 'Reject'){
            upsert trucklist; 
            Pagereference pg = new Pagereference('/apex/TMS_TruckSummaryScreen_VF');
            pg.setredirect(true);
            return pg;
        }
        /*EmailTemplate emtemp = [select Id,Name from EmailTemplate where Name=:'TMS Email Template'];        
        string wId;
        if(rectype !='General Vehicle' && rectype !='FG Dispatch Truck' && rectype !='Scrap Dispatch Truck' && rectype !='RM Dispatch Truck'){
            tmsvendor = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Transporters__c];    
            tmsvendor1 = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Vendor__c];
            tmmat = [select name from TMS_Material__c where id=:trucklist.Material_Desc__c];       
        
        if(trAns != getAns){            
            Messaging.SingleEmailMessage EmailMsg = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[]{'prasanth.reddy@capgemini.com','Sharat.Sugur@unilever.com','Prem.Melvin@unilever.com','dipak.gurkha@unilever.com','sailesh.patel@unilever.com','narendra.tolambia@unilever.com','ankit.sharma@unilever.com'};
            String[] toAddresses = new String[]{'bhaskar.emani@capgemini.com'};
            EmailMsg.setToAddresses(toAddresses);
            //EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c+'\n'+'Transporter:'+tmsvendor.Name+'\n'+'Vendor:'+tmsvendor1.Name+'\n'+'Material desc:'+tmmat.Name);
            
            EmailMsg.setTemplateId(emtemp.id);
            EmailMsg.setTargetObjectId('005c0000002kQBz');
            EmailMsg.setSaveAsActivity(false);
            //EmailMsg.setwhatId(wId);
            //EmailMsg.setSubject('Incorrect Documents');
            //EmailMsg.setReplyTo('prasanth.reddy@capgemini.com;dipak.gurkha@unilever.com;sailesh.patel@unilever.com;narendra.tolambia@unilever.com;ankit.sharma@unilever.com');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailMsg});
        }
        }
        else if(rectype =='FG Dispatch Truck'){
            tmsvendor = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Transporters__c];    
            tmsvendor1 = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Vendor__c];
            //tmmat = [select name from TMS_Material__c where id=:truckentry.Material_Desc__c];       
        
        if(trAns != getAns){
            
            Messaging.SingleEmailMessage EmailMsg = new Messaging.SingleEmailMessage();
            EmailMsg.setSaveAsActivity(false);
            String[] toAddresses = new String[]{'prasanth.reddy@capgemini.com','Sharat.Sugur@unilever.com','Prem.Melvin@unilever.com','dipak.gurkha@unilever.com','sailesh.patel@unilever.com','narendra.tolambia@unilever.com','ankit.sharma@unilever.com'};
            EmailMsg.setToAddresses(toAddresses);
            //EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c+'\n'+'Transporter:'+tmsvendor.Name+'\n'+'Vendor:'+tmsvendor1.Name);
            EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c+'\n'+'Transporter:'+tmsvendor.Name+'\n'+'Vendor:'+tmsvendor1.Name);
            EmailMsg.setSubject('Incorrect Documents');
            //EmailMsg.setReplyTo('prasanth.reddy@capgemini.com;dipak.gurkha@unilever.com;sailesh.patel@unilever.com;narendra.tolambia@unilever.com;ankit.sharma@unilever.com');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailMsg});
        }
        }
        else {
            if(trAns != getAns){
            
            Messaging.SingleEmailMessage EmailMsg = new Messaging.SingleEmailMessage();
            EmailMsg.setSaveAsActivity(false);
            String[] toAddresses = new String[]{'prasanth.reddy@capgemini.com','Sharat.Sugur@unilever.com','Prem.Melvin@unilever.com','dipak.gurkha@unilever.com','sailesh.patel@unilever.com','narendra.tolambia@unilever.com','ankit.sharma@unilever.com'};
            EmailMsg.setToAddresses(toAddresses);
            EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c);
            EmailMsg.setSubject('Incorrect Documents');
            //EmailMsg.setReplyTo('prasanth.reddy@capgemini.com;dipak.gurkha@unilever.com;sailesh.patel@unilever.com;narendra.tolambia@unilever.com;ankit.sharma@unilever.com');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailMsg});
        }
        } */       
        Pagereference pg = new Pagereference('/apex/TMS_TruckSummaryScreen_VF');
        pg.setredirect(true);
        //return pg;
        
        if(trucklist.RFID__c != null){
        upsert trucklist;
            truckId = truckList.Id;
            truckentrylist = [select id,question__c,Answer__c from TMS_Truck_Entry_Checklist__c where id=:truckId];
            questions = truckentrylist.question__c;
            answers = truckentrylist.answer__c;
            system.debug('truckId-->'+truckId);
            system.debug('truckentrylist-->'+truckentrylist);
            system.debug('questions-->'+questions);
            system.debug('answers-->'+answers);
            
        EmailTemplate emtemp = [select Id,Name,ApiVersion,Body,Markup,HtmlValue from EmailTemplate where developername=:'TMS_Email_Template'];
        system.debug('emtemp-->'+emtemp.Id); 
        system.debug('emtemp-->'+emtemp.Name); 
        system.debug('emtemp-->'+emtemp.body); 
        system.debug('emtemp-->'+emtemp.HtmlValue);       
        string wId;
        if(rectype !='General Vehicle' && rectype !='FG Dispatch Truck' && rectype !='Scrap Dispatch Truck' && rectype !='RM Dispatch Truck'){
            tmsvendor = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Transporters__c];    
            tmsvendor1 = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Vendor__c];
            tmmat = [select name from TMS_Material__c where id=:trucklist.Material_Desc__c];       
        
        if(trAns != getAns){            
            Messaging.SingleEmailMessage EmailMsg = new Messaging.SingleEmailMessage();
            //String[] toAddresses = new String[]{'prasanth.reddy@capgemini.com','Sharat.Sugur@unilever.com','Prem.Melvin@unilever.com','dipak.gurkha@unilever.com','sailesh.patel@unilever.com','narendra.tolambia@unilever.com','ankit.sharma@unilever.com'};
            String[] toAddresses = new String[]{'chandana.mekala@capgemini.com'};
            EmailMsg.setToAddresses(toAddresses);
            //EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c+'\n'+'Transporter:'+tmsvendor.Name+'\n'+'Vendor:'+tmsvendor1.Name+'\n'+'Material desc:'+tmmat.Name);
            
            EmailMsg.setTemplateId(emtemp.id);
            EmailMsg.setTargetObjectId('005c0000002kQBz');
            EmailMsg.setSaveAsActivity(false);
            //EmailMsg.setwhatId(wId);
            //EmailMsg.setSubject('Incorrect Documents');
            //EmailMsg.setReplyTo('prasanth.reddy@capgemini.com;dipak.gurkha@unilever.com;sailesh.patel@unilever.com;narendra.tolambia@unilever.com;ankit.sharma@unilever.com');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailMsg});
        }
        }
        else if(rectype =='FG Dispatch Truck'){
            tmsvendor = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Transporters__c];    
            tmsvendor1 = [select name from TMS_Vendor_Transporter_Customer_Mast__c where id=:trucklist.Vendor__c];
            //tmmat = [select name from TMS_Material__c where id=:truckentry.Material_Desc__c];       
        
        if(trAns != getAns){
            
            Messaging.SingleEmailMessage EmailMsg = new Messaging.SingleEmailMessage();
            EmailMsg.setSaveAsActivity(false);
            String[] toAddresses = new String[]{'prasanth.reddy@capgemini.com','Sharat.Sugur@unilever.com','Prem.Melvin@unilever.com','dipak.gurkha@unilever.com','sailesh.patel@unilever.com','narendra.tolambia@unilever.com','ankit.sharma@unilever.com'};
            EmailMsg.setToAddresses(toAddresses);
            //EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c+'\n'+'Transporter:'+tmsvendor.Name+'\n'+'Vendor:'+tmsvendor1.Name);
            EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c+'\n'+'Transporter:'+tmsvendor.Name+'\n'+'Vendor:'+tmsvendor1.Name);
            EmailMsg.setSubject('Incorrect Documents');
            //EmailMsg.setReplyTo('prasanth.reddy@capgemini.com;dipak.gurkha@unilever.com;sailesh.patel@unilever.com;narendra.tolambia@unilever.com;ankit.sharma@unilever.com');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailMsg});
        }
        }
        else {
            if(trAns != getAns){
            
            Messaging.SingleEmailMessage EmailMsg = new Messaging.SingleEmailMessage();
            EmailMsg.setSaveAsActivity(false);
            String[] toAddresses = new String[]{'prasanth.reddy@capgemini.com','Sharat.Sugur@unilever.com','Prem.Melvin@unilever.com','dipak.gurkha@unilever.com','sailesh.patel@unilever.com','narendra.tolambia@unilever.com','ankit.sharma@unilever.com'};
            EmailMsg.setToAddresses(toAddresses);
            EmailMsg.setPlainTextBody('Truck Number:'+trucklist.Vehicle_Number__c+'\n'+'Date:'+system.now()+'\n'+'Truck Type:'+trucklist.Truck__c);
            EmailMsg.setSubject('Incorrect Documents');
            //EmailMsg.setReplyTo('prasanth.reddy@capgemini.com;dipak.gurkha@unilever.com;sailesh.patel@unilever.com;narendra.tolambia@unilever.com;ankit.sharma@unilever.com');
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] {EmailMsg});
        }
        }  
        return pg;
        }
        else if(trucklist.RFID__c == null && (trucklist.Truck__c =='General Vehicle'||trucklist.truck_Action__c =='Hold')){
        upsert trucklist;        
        
            questions = truckList.question__c;
            answers = truckList.answer__c; 
            system.debug('questions1-->'+questions);
            system.debug('answers1-->'+answers);  
        
        return pg;
        }
        /*else if(trucklist.RFID__c == null && trucklist.Truck__c =='FG Dispatch Truck'){ 
        upsert trucklist;
        return pg;
        }
        else if(trucklist.RFID__c == null && trucklist.truck_Action__c =='Hold'){
        upsert trucklist;
        return pg;
        }*/
        else{
            return null;
        }
    }
    public void getTruck(){        
        
    }  
    public string getQuestions(){
        
        string tQ = '';
        string tempq = '';
        for(TMS_Checklist__c tms: tmschklists){
            tq = tq + tms.Name +'\n';
        }        
        if(tq.length()>0){
            tempq = tq.substring(0,tq.length()-1);
        }          
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
    
    public Map<string,string> expectedAnswers(){
        //Map<string,string> ansmap = new Map<string,string>();
        for(TMS_Checklist__c tms: tmschklists){
            newMap.put(tms.Name,tms.Expected_Answer__c);
        }
        return newMap;
    }
    
    
    public string getDates(){
        string dat = '';
        string expDat = '';
        for(TMS_Checklist__c tms: tmschklists){
            dat= dat + tms.Date__c+'\n';
        }
        if(dat.length()>0){
            expDat = dat.substring(0,dat.length()-1);    
        }
        
        return expDat;
    }
    
     
    public pageReference cancel(){
        Pagereference pg = new Pagereference('/apex/TMS_TruckSummaryScreen_VF');
        pg.setredirect(true);
        return pg;
    }  
    
    public pageReference getRFID(){
        Tms_PlantCode__c mcs = Tms_PlantCode__c.getInstance();
        mcs.Plant_Code__c = mcs.Plant_Code__c.Substring(4,mcs.Plant_Code__c.length());
        mcs.Plant_Code__c = mcs.Plant_Code__c.touppercase();
        system.debug('pplant--->'+mcs.Plant_Code__c);
        Pagereference pg ;
        Integer sCount = [Select count()  from TMS_RFID__c where RFID_plant_code__c=:mcs.Plant_Code__c Limit 1]; 
       
         if(sCount >0)
         {            
        
        TMS_RFID__c rfID = [Select RFID_Card_Number__c,RFID_plant_code__c from TMS_RFID__c where RFID_plant_code__c=:mcs.Plant_Code__c Limit 1]; 
         trucklist.RFID__c = rfID.RFID_Card_Number__c;     
        delete rfID;
         }
        else
         ApexPages.addMessage(new ApexPages.message(ApexPages.Severity.ERROR,'No RFID card swipe detected. Please swipe the card again.'));
        
        return null;
        
    }
}