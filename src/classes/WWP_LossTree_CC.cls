public with sharing class WWP_LossTree_CC{

    public Boolean nonedit { get; set; }
    public WWP_Loss_Tree__c lossTree{get; set;}
     public string message{get; set;}
     public string successmessage{get; set;}
     public string selectedWeek{get;set;}
      public Boolean isdisabled {get;set;}
      
    public List<WWP_Loss_Tree__c> listLossTree{get; set;}
    public List<LossTreeWrapper> listLossTreeW{get; set;}
    Map<string, set<string>> mapbox12 = new Map<string, set<string>>();
    Map<string, set<string>> mapbox13 = new Map<string, set<string>>();
    Map<string, set<string>> mapbox21 = new Map<string, set<string>>();
    Map<string, set<string>> mapbox23 = new Map<string, set<string>>();
    Map<string, set<string>> mapbox31 = new Map<string, set<string>>();
    Map<string, set<string>> mapbox32 = new Map<string, set<string>>();
    Map<string, set<string>> mapcombine12 = new Map<string, set<string>>();
    List<SelectOption> listbox1all = new List<SelectOption>();
    List<SelectOption> listbox2all = new List<SelectOption>();
    List<SelectOption> listbox3all = new List<SelectOption>();
    public List<SelectOption> listPlantCodes{get; set;}
    public List<SelectOption> listWeekCodes{get; set;}
    public boolean dispalyAll{get; set;}
    public boolean selectallcheckbox{get; set;}
    String valueNone = 'None';
    String valueNull = '';
    
   
    
     public WWP_LossTree_CC(){
         try{
         lossTree = new WWP_Loss_Tree__c(); 
         listPlantCodes = new List<SelectOption>(); 
         listWeekCodes = new List<SelectOption>(); 
         List<WWP_PlantCode_User_Mapping__c> plantcodeusers= new List<WWP_PlantCode_User_Mapping__c>();
         plantcodeusers = [Select name,user__c,Plant_code__c from WWP_PlantCode_User_Mapping__c where user__c =: userinfo.getuseremail()];
         listPlantCodes.add(new SelectOption(valueNull,'--None--'));
          listWeekCodes.add(new SelectOption(valueNull,'--None--'));
         Set<string> uniqueCodes = new Set<String>();
         if(!plantcodeusers.isEmpty()){             
             for(WWP_PlantCode_User_Mapping__c ps: plantcodeusers){
                 uniqueCodes.add(ps.Plant_code__c);
                 //listPlantCodes.add(new SelectOption(ps.name,ps.name));
             }
             if(!uniqueCodes.isEmpty()){
                 for(string plantCode: uniqueCodes){                
                 listPlantCodes.add(new SelectOption(plantCode,plantCode));
                 }    
             }
             
         } 
         
         
         else{
             message = label.WWP_NocodeAssigned_Err;
         }
         
          List<WWP_Loss_Tree__c>   weeklistLossTree = [select id,name,Week__c from WWP_Loss_Tree__c  order by createddate Limit 50000];
           
           Map<String,String> weekMap = new Map<String,String>();
         
           for(WWP_Loss_Tree__c weekV:weeklistLossTree )
             {
                 weekMap.put(weekV.Week__C,weekv.name);
             }
             
             for(String week:weekMap.Keyset())
             {
               listWeekCodes.add(new SelectOption(week,week));
             }
         
         
         }
         catch(Exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,e.getmessage()));
         }
     }
     public void fetchLossTree(){
        listLossTree = new List<WWP_Loss_Tree__c>();
        listLossTreeW = new List<LossTreeWrapper>();
        listbox1all .clear();
        listbox2all .clear();
        listbox3all .clear();
        mapbox12.clear();
        mapbox13.clear();
        mapbox21.clear();
        mapbox23.clear();
        mapbox31.clear();
        mapbox32.clear();
        mapcombine12.clear();
        successmessage=valueNull;
        
        
        if(lossTree.Loss_Type__c!=null && lossTree.Plant_Code__c!=null && selectedWeek !=null){
            if(dispalyAll){
            system.debug(lossTree.Loss_Type__c +'>>> '+selectedWeek +'>>>>>'+lossTree.Plant_Code__c );
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c  from WWP_Loss_Tree__c where  Week__c=:selectedWeek and Plant_Code__c=:lossTree.Plant_Code__c and Loss_Type__c=:losstree.loss_type__c  Limit 1000];
            }
            else{
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c  from WWP_Loss_Tree__c where Loss_Type__c=:lossTree.Loss_Type__c and Week__c=:selectedWeek and Plant_Code__c=:lossTree.Plant_Code__c and Loss_Type__c!=null and Loss_Updated_in_Salesforce__c = false limit 1000];
            }
            
          if(listLossTree.isEmpty()){
              message = label.WWP_Norecords_Err;
          }  
        else{
        
           
             
        
            message = valueNull;
        List<WWP_LossTree__c> listCodes = WWP_LossTree__c.getAll().values();
       set<string> setbox1all = new set<string>();
                set<string> setbox2all = new set<string>();
                set<string> setbox3all = new set<string>();
        for(WWP_LossTree__c w: listCodes){
            if(w.loss_type__c == lossTree.Loss_Type__c){
               
                setbox1all.add(w.loss_name__c);
                setbox2all.add(w.loss_sub_family__c);
                setbox3all.add(w.Loss_Description__c);
                
                set<string> listbox12 = new set<string>();
                if(!Mapbox12.containsKey(w.loss_name__c)){                
                    listbox12.add(w.loss_sub_family__c);
                    Mapbox12.put(w.loss_name__c,listbox12);
                }
                else{
                    listbox12 = Mapbox12.get(w.loss_name__c);
                    listbox12.add(w.loss_sub_family__c);
                    Mapbox12.put(w.loss_name__c,listbox12);
                }
                
                set<string> listbox13 = new set<string>();
                if(!Mapbox13.containsKey(w.loss_name__c)){                
                    listbox13.add(w.Loss_Description__c);
                    Mapbox13.put(w.loss_name__c,listbox13);
                }
                else{
                    
                    listbox13 = Mapbox13.get(w.loss_name__c);
                    listbox13.add(w.Loss_Description__c);
                    Mapbox13.put(w.loss_name__c,listbox13);
                }
                
                set<string> listbox21 = new set<string>();
                if(!Mapbox21.containsKey(w.loss_sub_family__c)){                
                    listbox21.add(w.loss_name__c);
                    Mapbox21.put(w.loss_sub_family__c,listbox21);
                }
                else{
                    listbox21 = Mapbox21.get(w.loss_sub_family__c);
                    listbox21.add(w.loss_name__c);
                    Mapbox21.put(w.loss_sub_family__c,listbox21);
                }
                
                set<string> listbox23 = new set<string>();
                if(!Mapbox23.containsKey(w.loss_sub_family__c)){                
                    listbox23.add(w.Loss_Description__c);
                    Mapbox23.put(w.loss_sub_family__c,listbox23);
                }
                else{
                    listbox23 = Mapbox23.get(w.loss_sub_family__c);
                    listbox23.add(w.Loss_Description__c);
                    Mapbox23.put(w.loss_sub_family__c,listbox23);
                }
                
                set<string> listcombine12 = new set<string>();
                if(!mapcombine12.containsKey(w.loss_name__c+w.loss_sub_family__c)){ 
                listcombine12.add(w.Loss_Description__c);
                mapcombine12.put(w.loss_name__c+w.loss_sub_family__c,listcombine12);
                }
                else{
                listcombine12 = mapcombine12.get(w.loss_name__c+w.loss_sub_family__c);
                listcombine12.add(w.Loss_Description__c);
                mapcombine12.put(w.loss_name__c+w.loss_sub_family__c,listcombine12);
                }
                
                set<string> listbox31 = new set<string>();
                listbox31.add(w.loss_name__c);
                Mapbox31.put(w.Loss_Description__c,listbox31);
                set<string> listbox32 = new set<string>();
                listbox32.add(w.loss_sub_family__c);
                Mapbox32.put(w.Loss_Description__c,listbox32);
                
            }
        }
        fetchLossTreeExt(setbox1all, setbox2all, setbox3all);
       /* listbox1all.add(new SelectOption(valueNone,valueNone));
        listbox2all.add(new SelectOption(valueNone,valueNone));
        listbox3all.add(new SelectOption(valueNone,valueNone));
        for(string s1:setbox1all){
                listbox1all.add(new SelectOption(s1,s1));
                }
                for(string s2:setbox2all){
                listbox2all.add(new SelectOption(s2,s2));
                }
                if(lossTree.Loss_Type__c!='MRP Compliance'){
                for(string s3:setbox3all){
                listbox3all.add(new SelectOption(s3,s3));
                }
                } 
                integer y=-1;
         if(listLossTree!=null && !listLossTree.isEmpty()){
             for(WWP_Loss_Tree__c lt: listLossTree){
             
                LossTreeWrapper ltW = new LossTreeWrapper(lt,listbox1all,listbox2all,listbox3all,y);  
                listLossTreeW.add(ltW); 
                y=ltw.i;
            } 
         } */
         
         }
         }
         else{
             message = label.WWP_RequiredFeilds_Err;
         }
         
    }
    
    public void fetchLossTreeExt(set<string> setbox1all, set<string> setbox2all, set<string> setbox3all){
        listbox1all.add(new SelectOption(valueNone,valueNone));
        listbox2all.add(new SelectOption(valueNone,valueNone));
        listbox3all.add(new SelectOption(valueNone,valueNone));
        for(string s1:setbox1all){
                listbox1all.add(new SelectOption(s1,s1));
                }
                for(string s2:setbox2all){
                listbox2all.add(new SelectOption(s2,s2));
                }
                if(lossTree.Loss_Type__c!='MRP Compliance'){
                for(string s3:setbox3all){
                listbox3all.add(new SelectOption(s3,s3));
                }
                } 
                integer y=-1;
         if(listLossTree!=null && !listLossTree.isEmpty()){
             for(WWP_Loss_Tree__c lt: listLossTree){
             
                LossTreeWrapper ltW = new LossTreeWrapper(lt,listbox1all,listbox2all,listbox3all,y);  
                listLossTreeW.add(ltW); 
                y=ltw.i;
            } 
         } 
    }
    
    public class LossTreeWrapper {
    public list<WWP_Loss_Tree__c> redcolor {get; set;}
        public boolean isdisabled { get; set; }
        
        public boolean checkbox1{get; set;}
        public WWP_Loss_Tree__c wlt{get; set;}
        public List<SelectOption> listbox1{get; set;}
        public string selectbox1{get; set;}
        public string selectbox2{get; set;}
        public string selectbox3{get; set;}
        
        public List<SelectOption> listbox2{get; set;}
        public List<SelectOption> listbox3{get; set;}
        public integer i{get; set;}
        public decimal lossdiff {get; set;}
        public LossTreeWrapper(WWP_Loss_Tree__c lt,List<SelectOption> listbox1all,List<SelectOption> listbox2all,List<SelectOption> listbox3all,integer y){
            checkbox1 = false;
            wlt = lt;
            
            
           listbox1 = listbox1all; 
           listbox2 = listbox2all;
           listbox3 = listbox3all;
           
           if(lt.Loss_name__c!=null){          
               selectbox1 = lt.Loss_name__c;
           }           
           if(lt.Loss_sub_Family__c!=null){
               selectbox2 = lt.Loss_sub_Family__c;
           }
           if(lt.Loss_description__c!=null){
               selectbox3 = lt.Loss_description__c;
           }
          // lossdiff = 0;
           if(lt.loss_type__c == 'Output Reliability' && lt.Planned_Production__c != null && lt.Planned_Production__c != 0){              
               lossdiff = lt.OR_Loss_Value__c/lt.Planned_Production__c;       
           }
           if(lt.loss_type__c == 'Output Reliability' && lt.Planned_Production__c == 0){
               lossdiff = 100;
           }
           
           
          
           
          
           
           
           //lossdiff = 0;
           if(lt.loss_type__c == 'Dispatch Compliance' && lt.Planned_Dispatch__c!= null && lt.Planned_Dispatch__c!= 0){              
               lossdiff = lt.DC_Loss_Value__c/lt.Planned_Dispatch__c;       
           }
            
            if(lt.loss_type__c == 'Dispatch Compliance' && lt.Planned_Dispatch__c== 0){
               lossdiff = 100;
           }
           if(lossdiff < 0.95)
           {
           isdisabled =true;
           }
           else
           {
           isdisabled=false;
           }
           
           
            //lossdiff = 0;
           
            
           
         // redcolor= [select name, Plant_Code__c from WWP_Loss_Tree__c where CreatedDate > LAST_WEEK];  
            
            
            i=y+1;
            
        }
    }
    
   public class wrapAccount {
        public WWP_Loss_Tree__c acc {get; set;}
        public Boolean selected {get; set;}
 public wrapAccount(WWP_Loss_Tree__c a) {
            acc = a;
            selected = false;
        }
    }
    
    
    public void control1213(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('firstParam'));
        string lossname = Apexpages.currentPage().getParameters().get('secondParam');
        List<SelectOption> listbox12select = new List<SelectOption>();
        List<SelectOption> listbox13select = new List<SelectOption>();
        List<SelectOption> listbox11select = new List<SelectOption>();
       system.debug('sssssssssssssss'+lossname);
       
        if(lossname!=null && lossname!=valueNone){
        listbox11select.add(new SelectOption(lossname,lossname));
       listLossTreeW[ite].listbox1=listbox11select;
       
        listbox12select.add(new SelectOption(valueNone,valueNone));
            
            
            listbox13select.add(new SelectOption(valueNone,valueNone));
            if(listLossTreeW[ite].selectbox2==valueNone){
                for(string s2:Mapbox12.get(lossname)){
                listbox12select.add(new SelectOption(s2,s2));
                }           
                listLossTreeW[ite].listbox2=listbox12select;
            
                for(string s3:Mapbox13.get(lossname)){
                    listbox13select.add(new SelectOption(s3,s3));
                }
                listLossTreeW[ite].listbox3=listbox13select;
                
            }
            else{
                if(listLossTreeW[ite].selectbox2!=valueNone && listLossTreeW[ite].listbox2.size()==1){
                    for(string s3:mapcombine12.get(lossname+listLossTreeW[ite].selectbox2)){
                    listbox13select.add(new SelectOption(s3,s3));
                    }
                    listLossTreeW[ite].listbox3=listbox13select;
                }
                if(listLossTreeW[ite].selectbox2!=valueNone && listLossTreeW[ite].listbox2.size()>1){
                    for(string s2:Mapbox12.get(lossname)){
                    listbox12select.add(new SelectOption(s2,s2));
                    }           
                    listLossTreeW[ite].listbox2=listbox12select;
                
                    for(string s3:Mapbox13.get(lossname)){
                        listbox13select.add(new SelectOption(s3,s3));
                    }
                    listLossTreeW[ite].listbox3=listbox13select;
                }
            }
        }
      /*  if(lossname=='None'){
        system.debug('dddddddddddddd'+listbox2all);
            listLossTreeW[ite].listbox2=listbox2all;
            if(listLossTreeW[ite].selectbox2=='None'){
                listLossTreeW[ite].listbox3=listbox3all;
            }
        }*/
    
    }
    public void control2123(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('firstParam2'));
        string losssubfamily = Apexpages.currentPage().getParameters().get('secondParam2');
        List<SelectOption> listbox21select = new List<SelectOption>();
        List<SelectOption> listbox23select = new List<SelectOption>();
        List<SelectOption> listbox22select = new List<SelectOption>();
        
        if(losssubfamily!=null && losssubfamily!=valueNone){
            if(listLossTreeW[ite].listbox1.size()>1){
                listbox21select.add(new SelectOption(valueNone,valueNone));
                for(string s1:Mapbox21.get(losssubfamily)){
                    listbox21select.add(new SelectOption(s1,s1));
                }            
                listLossTreeW[ite].listbox1=listbox21select;
                listbox23select.add(new SelectOption(valueNone,valueNone));
                for(string s3:Mapbox23.get(losssubfamily)){
                    listbox23select.add(new SelectOption(s3,s3));
                }
                listLossTreeW[ite].listbox3=listbox23select;
                
            }
            if(listLossTreeW[ite].listbox1.size()==1 && listLossTreeW[ite].selectbox1!=valueNone){
                listbox23select.add(new SelectOption(valueNone,valueNone));
                for(string s3:mapcombine12.get(listLossTreeW[ite].selectbox1+losssubfamily)){
                listbox23select.add(new SelectOption(s3,s3));
                }
                listLossTreeW[ite].listbox3=listbox23select;    
            }
            listbox22select.add(new SelectOption(losssubfamily,losssubfamily));
                listLossTreeW[ite].listbox2=listbox22select;
            
        }
        
    
    }
    
    public void control3132(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('firstParam3'));
        string lossdesc = Apexpages.currentPage().getParameters().get('secondParam3');
        List<SelectOption> listbox31select = new List<SelectOption>();
        List<SelectOption> listbox32select = new List<SelectOption>();
        List<SelectOption> listbox33select = new List<SelectOption>();
        system.debug('ddddddddddddddddddddd'+lossdesc);
        if(lossdesc!=null && lossdesc!=valueNone){
        
            for(string s1:Mapbox31.get(lossdesc)){
            system.debug('mmmmmmmmmmmm'+s1);
                listbox31select.add(new SelectOption(s1,s1));
                listLossTreeW[ite].selectbox1=s1;
            }
            
            listLossTreeW[ite].listbox1=listbox31select;
         
            for(string s2:Mapbox32.get(lossdesc)){
                listbox32select.add(new SelectOption(s2,s2));
                listLossTreeW[ite].selectbox2=s2;
            }
            listLossTreeW[ite].listbox2=listbox32select;
                            
              
                listbox33select.add(new SelectOption(lossdesc,lossdesc));
                listLossTreeW[ite].listbox3=listbox33select;
            
                
        }
       
    
    }
    
    public void controlMRP12(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('mrpfirstParam'));
        string lossname = Apexpages.currentPage().getParameters().get('mrpsecondParam');
        List<SelectOption> listboxmrp12select = new List<SelectOption>();
        List<SelectOption> listboxmrp11select = new List<SelectOption>();
        if(lossname!=null && lossname!=valueNone){
        listboxmrp12select.add(new SelectOption(valueNone,valueNone));
            for(string s2:Mapbox12.get(lossname)){
                listboxmrp12select.add(new SelectOption(s2,s2));
            }           
            listLossTreeW[ite].listbox2=listboxmrp12select;                                    
        
            listboxmrp11select.add(new SelectOption(lossname,lossname));
            listLossTreeW[ite].listbox1=listboxmrp11select;
        } 
       /* if(lossname=='None'){
            listLossTreeW[ite].listbox2=listbox2all;           
        }*/
    }
    public void controlMRP21(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('mrpfirstParam2'));
        string lossfamily = Apexpages.currentPage().getParameters().get('mrpsecondParam2');
        List<SelectOption> listboxmrp21select = new List<SelectOption>();
        List<SelectOption> listboxmrp22select = new List<SelectOption>();
        if(lossfamily!=null && lossfamily!=valueNone){
        //listboxmrp21select.add(new SelectOption('None','None'));
            for(string s1:Mapbox21.get(lossfamily)){
                listboxmrp21select.add(new SelectOption(s1,s1));
            }           
            listLossTreeW[ite].listbox1=listboxmrp21select; 
            listboxmrp22select.add(new SelectOption(lossfamily,lossfamily));
            listLossTreeW[ite].listbox2=listboxmrp22select;                                   
        }
        /*if(lossfamily=='None'){
            listLossTreeW[ite].listbox1=listbox1all;           
        }*/
    }
    
    public void resetline(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('resetite'));
        system.debug('iiiiiiiiiiiiiiiiiiii'+ite);
        
        
        
        
        listLossTreeW[ite].listbox1=listbox1all;
        listLossTreeW[ite].listbox2=listbox2all;
        listLossTreeW[ite].listbox3=listbox3all;
        listLossTreeW[ite].selectbox3=valueNone;
        listLossTreeW[ite].selectbox1=valueNone;
        listLossTreeW[ite].selectbox2=valueNone;
        
        
    }
    public void updateLossTree(){
        integer count=0;
        List<WWP_Loss_Tree__c> updateLTW = new List<WWP_Loss_Tree__c>();
        try{
        if(listLossTreeW!=null && !listLossTreeW.isEmpty()){
            for(LossTreeWrapper lw: listLossTreeW){
                if(lw.checkbox1){
                    WWP_Loss_Tree__c wt = new WWP_Loss_Tree__c();
                    wt.id = lw.wlt.id;
                    if(lw.selectbox1!=valueNone){
                    wt.Loss_Name__c = lw.selectbox1;
                    }
                    else{
                        wt.Loss_Name__c = valueNull ;
                    }
                    if(lw.selectbox2!=valueNone){
                    wt.Loss_Sub_Family__c= lw.selectbox2;
                    }
                    else{
                        wt.Loss_Sub_Family__c= valueNull ;
                    }
                    if(lw.selectbox3!=valueNone){
                    wt.Loss_Description__c = lw.selectbox3;
                    }
                    else{
                        wt.Loss_Description__c = valueNull ;
                    }
                    updateLTW.add(wt);
                    count++;
                }  
                lw.checkbox1 = false; 
                
                
            }
            if(count == 0){ 
             
                    //fetchLossTree();                  
                    message=label.WWP_selectRecord_Err; 
                    successmessage =valueNull;                   
                }
                else{
                    message =valueNull;                    
                } 
            if(updateLTW!=null && !updateLTW.isEmpty()){
                update updateLTW;
                fetchLossTree();
                successmessage=label.WWP_RecordsUpdated_Msg;
                
                message =valueNull;
                
                
            }
        }
        
        }
        catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,e.getmessage()));
        }
    }
        
    
}