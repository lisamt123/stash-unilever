public with sharing class WWP_Losstree_Copy_Component_Ctrl {
  
    public boolean showMassFeature{get; set; }
    public boolean showfeature{get;set;}
    public string selectedbox1{get;set;}
    public string selectedbox2{get;set;}
    public string selectedbox3{get;set;}
    public List<SelectOption> selectbox1all{get; set;}
    public List<SelectOption> selectbox2all{get; set;}
    public List<SelectOption> selectbox3all{get; set;}
    String valueNone = 'None';
    String valueNull = '';
    public boolean dispalyAll{get; set;}
    public List<WWP_Loss_Tree__c> listLossTree{get; set;}
    //public List<LossTreeWrapper> listLossTreeW{get; set;}
    Map<string, set<string>> mapbox12 ;
    Map<string, set<string>> mapbox13 ;
    Map<string, set<string>> mapbox21 ;
    Map<string, set<string>> mapbox23 ;
    Map<string, set<string>> mapbox31 ;
    Map<string, set<string>> mapbox32 ;
    Map<string, set<string>> mapcombine12 ;
    
        List<SelectOption> listbox1all ;
    List<SelectOption> listbox2all;
    List<SelectOption> listbox3all;

    public string getSelectedType{get;set;}
    public string resetd{get;set;}
    
   public WWP_Losstree_Copy_Component_Ctrl(){
       system.debug('called constructor');
       system.debug('called resetor');
       showMassFeature = false;
       showfeature = false;
       listbox1all = new List<SelectOption>();
       listbox2all = new List<SelectOption>();
       listbox3all = new List<SelectOption>();
          mapbox12 = new Map<string, set<string>>();
          mapbox13 = new Map<string, set<string>>();
          mapbox21 = new Map<string, set<string>>();
          mapbox23 = new Map<string, set<string>>();
          mapbox31 = new Map<string, set<string>>();
          mapbox32 = new Map<string, set<string>>();
          mapcombine12 = new Map<string, set<string>>();
          selectbox1all = new List<selectOption>();
          selectbox2all = new List<selectOption>();
          selectbox3all = new List<selectOption>();
          //fetchLossTree();
          showfeature = false;
          }
          public void showPanelmassUpdate(){
          system.debug('entered');
    if(showMassFeature){
           system.debug('true');
            showfeature = true;
        }
        else{
            showfeature = false;
            system.debug('false');
        }
        
        fetchLossTree1(); 
     }
    public void fetchLossTree1(){
    system.debug('entering hereeeeeeee');
       selectbox1all.clear();
       selectbox2all.clear();
       selectbox3all.clear();
       listbox1all.clear();
       listbox2all.clear();
       listbox3all.clear();
       mapbox12.clear();
       mapbox13.clear();
       mapbox21.clear();
       mapbox23.clear();
       mapbox31.clear();
       mapbox32.clear();
       mapcombine12.clear();
       List<WWP_LossTree__c> listCodes = WWP_LossTree__c.getAll().values();
       system.debug('fdfdfd'+getSelectedType);
       set<string> setbox1all = new set<string>();
       set<string> setbox2all = new set<string>();
       set<string> setbox3all = new set<string>();
       for(WWP_LossTree__c w: listCodes){
            if(w.loss_type__c== getSelectedType){ 
                system.debug('satisfied');              
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
                system.debug('listbox31-->'+listbox31);
                Mapbox31.put(w.Loss_Description__c,listbox31);                
                set<string> listbox32 = new set<string>();
                listbox32.add(w.loss_sub_family__c);
                Mapbox32.put(w.Loss_Description__c,listbox32);
                system.debug('Mapbox31@@@'+Mapbox31);  
               }
            }          
         system.debug('setbox3all-->'+setbox3all);    
        fetchLossTreeExt(setbox1all,setbox2all,setbox3all);
    }
   
    public void fetchLossTreeExt(set<string> setbox1all, set<string> setbox2all, set<string> setbox3all){
        listbox1all.add(new SelectOption(valueNone,valueNone));
        listbox2all.add(new SelectOption(valueNone,valueNone));
        listbox3all.add(new SelectOption(valueNone,valueNone));
        system.debug('setbox3all-->'+setbox3all);
        system.debug('listbox3all-->'+listbox3all);
                for(string s1:setbox1all){
                listbox1all.add(new SelectOption(s1,s1));
                }
                for(string s2:setbox2all){
                listbox2all.add(new SelectOption(s2,s2));
                }
                if(getSelectedType !='MRP Compliance'){
                for(string s3:setbox3all){
                listbox3all.add(new SelectOption(s3,s3));
                }
                }
                selectbox1all.addAll(listbox1all);
                selectbox2all.addAll(listbox2all);
                selectbox3all.addAll(listbox3all);
                
                integer y=-1;
        /* if(listLossTree!=null && !listLossTree.isEmpty()){
             for(WWP_Loss_Tree__c lt: listLossTree){             
                LossTreeWrapper ltW = new LossTreeWrapper(lt,listbox1all,listbox2all,listbox3all,y);  
                listLossTreeW.add(ltW); 
                y=ltw.i;
            } 
         } */
    }
  /*  public class LossTreeWrapper {
    public list<WWP_Loss_Tree__c> redcolor {get; set;}
        public boolean isdisabled { get; set; }        
        public boolean checkbox1{get; set;}
        public WWP_Loss_Tree__c wlt{get; set;}
        public List<SelectOption> listbox1{get; set;}
        public string selectbox1{get; set;}
        public string selectbox2{get; set;}
        public string selectbox3{get; set;}
        public string Remarks{get;set;}
        public List<SelectOption> listbox2{get; set;}
        public List<SelectOption> listbox3{get; set;}
        public integer i{get; set;}
        public LossTreeWrapper(WWP_Loss_Tree__c lt,List<SelectOption> listbox1all,List<SelectOption> listbox2all,List<SelectOption> listbox3all,integer y){           
           listbox1 = listbox1all; 
           listbox2 = listbox2all;
           listbox3 = listbox3all;           
        }
    }*/
    public void controls11(){
    system.debug('entered here.,.,.,.,.,');
    fetchLossTree1();
    system.debug('getSelectedType-->'+getSelectedType);
        string lossname = Apexpages.currentPage().getParameters().get('firstParams1');
        system.debug('lossname');
        List<SelectOption> listbox12select = new List<SelectOption>();
        List<SelectOption> listbox13select = new List<SelectOption>();
        List<SelectOption> listbox11select = new List<SelectOption>();
        system.debug('sssssssssssssss'+lossname);
        showfeature = true;       
        if(lossname!=null && lossname!=valueNone){
        listbox11select.add(new SelectOption(lossname,lossname));
        selectbox1all=listbox11select;
        listbox12select.add(new SelectOption(valueNone,valueNone));            
            listbox13select.add(new SelectOption(valueNone,valueNone));
            if(selectedbox2==valueNone){
                for(string s2:Mapbox12.get(lossname)){
                listbox12select.add(new SelectOption(s2,s2));
                }           
                selectbox2all=listbox12select;
            
                for(string s3:Mapbox13.get(lossname)){
                    listbox13select.add(new SelectOption(s3,s3));
                    
                }
                selectbox3all=listbox13select;
                system.debug('selectbox3all---->'+selectbox3all);
            }
            else{
                if(selectedbox2!=valueNone && selectbox2all.size()==1){
                    for(string s3:mapcombine12.get(lossname+selectedbox2)){
                    listbox13select.add(new SelectOption(s3,s3));
                    }
                    selectbox3all=listbox13select;
                }
                if(selectedbox2!=valueNone && selectbox2all.size()>1){
                    for(string s2:Mapbox12.get(lossname)){
                    listbox12select.add(new SelectOption(s2,s2));
                    }           
                    selectbox2all=listbox12select;
                
                    for(string s3:Mapbox13.get(lossname)){
                        listbox13select.add(new SelectOption(s3,s3));
                    }
                    selectbox3all=listbox13select;
                }
            }
        }
     
    }    
    
    public void controls22(){
    system.debug('entered here2.,.,.,.,.,');
    fetchLossTree1();
        string losssubfamily = Apexpages.currentPage().getParameters().get('firstParams2');
        List<SelectOption> listbox21select = new List<SelectOption>();
        List<SelectOption> listbox23select = new List<SelectOption>();
        List<SelectOption> listbox22select = new List<SelectOption>();
        showfeature = true;
        if(losssubfamily!=null && losssubfamily!=valueNone){
            if(selectbox1all.size()>1){
                listbox21select.add(new SelectOption(valueNone,valueNone));
                for(string s1:Mapbox21.get(losssubfamily)){
       
                    listbox21select.add(new SelectOption(s1,s1));
                }            
                selectbox1all=listbox21select;
                listbox23select.add(new SelectOption(valueNone,valueNone));
                for(string s3:Mapbox23.get(losssubfamily)){
                    listbox23select.add(new SelectOption(s3,s3));
                }
                selectbox3all=listbox23select;                
            }
            if(selectbox1all.size()==1 && selectedbox1!=valueNone){
                listbox23select.add(new SelectOption(valueNone,valueNone));
                for(string s3:mapcombine12.get(selectedbox1+losssubfamily)){
                listbox23select.add(new SelectOption(s3,s3));
                }
                selectbox3all=listbox23select;    
            }
            listbox22select.add(new SelectOption(losssubfamily,losssubfamily));
                selectbox2all=listbox22select;
            
        }        
    
    }   
    
    public void controls33(){
    system.debug('entered here3.,.,.,.,.,');
        fetchLossTree1(); 
        system.debug('Mapbox31--->'+Mapbox31);
        string lossdesc = Apexpages.currentPage().getParameters().get('firstParams3');
        List<SelectOption> listbox31select = new List<SelectOption>();
        List<SelectOption> listbox32select = new List<SelectOption>();
        List<SelectOption> listbox33select = new List<SelectOption>();
        showfeature = true;       
                       
        system.debug('Mapbox31@@@'+Mapbox31.get(lossdesc));
        system.debug('ddddddddddddddddddddd'+lossdesc);
        
        if(lossdesc!=null && lossdesc!=valueNone){
            system.debug('Mapbox31-->'+Mapbox31.get(lossdesc));           
            for(string s1:Mapbox31.get(lossdesc)){
            system.debug('mmmmmmmmmmmm'+s1);
                listbox31select.add(new SelectOption(s1,s1));
                selectedbox1=s1;
            }
            selectbox1all=listbox31select;                     
            for(string s2:Mapbox32.get(lossdesc)){
                listbox32select.add(new SelectOption(s2,s2));
                selectedbox2=s2;                
            }            
            selectbox2all=listbox32select;                    
            listbox33select.add(new SelectOption(lossdesc,lossdesc));
            selectbox3all=listbox33select;
        }
        
    }
   public void resetd(){
   
       /*selectbox1all.clear();
       selectbox2all.clear();
       selectbox3all.clear();

       selectbox1all=listbox1all;
       selectbox2all=listbox2all;
       selectbox3all=listbox3all;
        selectedbox1=valueNone;
        selectedbox2=valueNone;
        selectedbox3=valueNone;*/
        
        fetchLossTree1();
        selectedbox1=valueNone;
        selectedbox2=valueNone;
        selectedbox3=valueNone;
        system.debug('ggg');
     /*PageReference pageRef = new PageReference(ApexPages.currentPage().getUrl());
       pageRef.setRedirect(false);
       showMassFeature = false;
       //fetchLossTree();
       return pageRef;*/
       
       //return null;
      
       }
    
}