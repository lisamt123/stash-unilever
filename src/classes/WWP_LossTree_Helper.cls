public with sharing class WWP_LossTree_Helper{

     public  List<List<SelectOption>> controls1(String lossname,boolean showfeature,List<SelectOption> selectbox1all,List<SelectOption> selectbox2all,List<SelectOption> selectbox3all,string selectedbox1,string selectedbox2,string selectedbox3,Map<string, set<string>> mapbox12,Map<string, set<string>> mapbox13,Map<string, set<string>> mapbox21,Map<string, set<string>> mapbox23,Map<string, set<string>> mapbox31,Map<string, set<string>> mapbox32,Map<string, set<string>> mapcombine12){
    
     String valueNone = 'None';
    String valueNull = '';
    List<List<SelectOption>> allTheSelectOptions = new List<List<SelectOption>>();
    
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
    system.debug('dhjhd'+selectbox1all);
    system.debug('dhssssjhd'+selectbox2all);
    system.debug('dhjdjjdhd'+selectbox3all);
    allTheSelectOptions.add(selectbox1all);
    allTheSelectOptions.add(selectbox2all);
    allTheSelectOptions.add(selectbox3all);
    
    return allTheSelectOptions;
    
    }
    
    public  List<List<SelectOption>> controls2(String losssubfamily ,boolean showfeature,List<SelectOption> selectbox1all,List<SelectOption> selectbox2all,List<SelectOption> selectbox3all,string selectedbox1,string selectedbox2,string selectedbox3,Map<string, set<string>> mapbox12,Map<string, set<string>> mapbox13,Map<string, set<string>> mapbox21,Map<string, set<string>> mapbox23,Map<string, set<string>> mapbox31,Map<string, set<string>> mapbox32,Map<string, set<string>> mapcombine12){
    
  List<List<SelectOption>> allTheSelectOptions = new List<List<SelectOption>>();
     String valueNone = 'None';
    String valueNull = '';
    
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
        system.debug('gdgdg'+selectbox2all);
        system.debug('fffff'+selectbox3all);
        allTheSelectOptions.add(selectbox1all);
    allTheSelectOptions.add(selectbox2all);
    allTheSelectOptions.add(selectbox3all);
    
    return allTheSelectOptions;
        
   
    
    }
    
     public List<List<SelectOption>> controls3(String lossdesc,boolean showfeature,List<SelectOption> selectbox1all,List<SelectOption> selectbox2all,List<SelectOption> selectbox3all,string selectedbox1,string selectedbox2,string selectedbox3,Map<string, set<string>> mapbox12,Map<string, set<string>> mapbox13,Map<string, set<string>> mapbox21,Map<string, set<string>> mapbox23,Map<string, set<string>> mapbox31,Map<string, set<string>> mapbox32,Map<string, set<string>> mapcombine12){
     
      List<List<SelectOption>> allTheSelectOptions = new List<List<SelectOption>>();
     String valueNone = 'None';
    String valueNull = '';
     List<SelectOption> listbox31select = new List<SelectOption>();
        List<SelectOption> listbox32select = new List<SelectOption>();
        List<SelectOption> listbox33select = new List<SelectOption>();
        showfeature = true;
        
        system.debug('ddddddddddddddddddddd'+lossdesc);
        if(lossdesc!=null && lossdesc!=valueNone){
        
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
        system.debug('dgdgd'+selectbox3all);
        system.debug('dgdgd'+listbox33select);
        
       allTheSelectOptions.add(selectbox1all);
    allTheSelectOptions.add(selectbox2all);
    allTheSelectOptions.add(selectbox3all);
    
    return allTheSelectOptions;
     }
     
     
     public list<integer> copying(List<WWP_LossTree_CC.LossTreeWrapper> listLossTreeW,string selectedbox1,string selectedbox2,string selectedbox3,String message,String successmessage){
     
     list<integer> counters = new list<integer>();
     String valueNull='';
         integer count=0;
     integer counter = 0;
     for(integer i =0 ; i < listLossTreeW.size(); i++){
     
        if(listLossTreeW[i].checkbox1){
        counter++;
        if(!listLossTreeW[i].isdisabled )
        {
           system.debug('sssss'+listLossTreeW[i].isdisabled);
                listLossTreeW[i].selectbox1 = selectedbox1;
                listLossTreeW[i].selectbox2 = selectedbox2;
                listLossTreeW[i].selectbox3 = selectedbox3;
                count++;
                counters.add(count); 
                
           }
           counters.add(counter);
            
           }}
       
     return counters;
     
     }
     
     
     
   
}