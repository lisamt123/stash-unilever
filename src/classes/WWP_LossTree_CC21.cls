public with sharing class WWP_LossTree_CC21{
    public boolean showMassFeature{get; set; }
    public boolean checkdissable{get;set;}
    public Boolean nonedit { get; set; }
    public WWP_Loss_Tree__c lossTree{get; set;}
    public string message{get; set;}
    public string message1{get; set;}
    public string successmessage{get; set;}
    public string selectedWeek{get;set;}
    public string selectedplantdescription{get;set;}
    public string listSAPcodedesc{get;set;}
    public string selectedcountrydescription{get;set;}
    public Boolean isdisabled {get;set;}
    public boolean showpickVal{get;set;}
    public boolean shwmsg{get;set;}
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
    public List<SelectOption> selectbox1all{get; set;}
    public List<SelectOption> selectbox2all{get; set;}
    public List<SelectOption> selectbox3all{get; set;}
    public string selectedbox1{get;set;}
    public string selectedbox2{get;set;}
    public string selectedbox3{get;set;}
    public List<SelectOption> listPlantCodes{get; set;}
    public List<SelectOption> listUvendorcode{get; set;}
    public List<SelectOption> listWeekCodes{get; set;}
    public List<SelectOption> listPlantdescription{get; set;}
    public List<SelectOption> listcountrydescription{get; set;}
    public List<SelectOption> listSnpvendorcode{get; set;}
    public boolean dispalyAll{get; set;}
    public boolean selectallcheckbox{get; set;}
    String valueNone = 'None';
    String valueNull = '';
    public WWP_LossTree_CC21(){
         try{
         Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        lossTree = new WWP_Loss_Tree__c();
        system.debug('profile'+profileName);
        lossTree.Loss_Type__c = 'Supplier OTIF';
        // lossTree = new WWP_Loss_Tree__c(); 
         //listPlantCodes = new List<SelectOption>();
         listUvendorcode = new List<SelectOption>(); 
         listWeekCodes = new List<SelectOption>();
         listPlantdescription = new List<SelectOption>();
         listcountrydescription = new List<SelectOption>();
         listSnpvendorcode= new List<SelectOption>();
         List<WWP_Uvendor_code_mapping__c > listUvendorcodeuser= new List<WWP_Uvendor_code_mapping__c >(); 
         List<WWP_PlantCode_User_Mapping__c> plantcodeusers= new List<WWP_PlantCode_User_Mapping__c>();
         //List<WWP_SNPVendor_code_mapping__c> listSnpvendorcodeUsers= new List<WWP_SNPVendor_code_mapping__c>();
         //plantcodeusers = [Select name,user__c,Plant_code__c from WWP_PlantCode_User_Mapping__c where user__c =: userinfo.getuseremail() limit 50000];
         listUvendorcodeuser = [Select name,user__c,U_Vendor_code__c from WWP_Uvendor_code_mapping__c where user__c =: userinfo.getuseremail() limit 50000];
         //listSnpvendorcodeUsers = [Select name,user__c,SNP_Vendor_code__c from WWP_SNPVendor_code_mapping__c where user__c =: userinfo.getuseremail() limit 50000];
        // listPlantCodes.add(new SelectOption(valueNull,'--None--'));
         listWeekCodes.add(new SelectOption(valueNull,'--None--'));
         listUvendorcode.add(new SelectOption(valueNull,'--None--'));
         listSnpvendorcode.add(new SelectOption(valueNull,'--None--'));
         listPlantdescription.add(new SelectOption(valueNull,'--None--'));
         listcountrydescription.add(new SelectOption(valueNull,'--None--'));
         showpickVal = false;
         shwmsg = false;
         selectbox1all = new List<selectOption>();
         selectbox2all = new List<selectOption>();
         selectbox3all = new List<selectOption>();
         Set<string> uniqueCodes = new Set<String>();
         Set<string> uniqueUvendorCodes = new Set<String>();
       
         if(!listUvendorcodeuser.isEmpty()){             
             for(WWP_Uvendor_code_mapping__c ps: listUvendorcodeuser){
                 uniqueUvendorCodes.add(ps.U_Vendor_code__c);
                 //listPlantCodes.add(new SelectOption(ps.name,ps.name));
             }
             if(!uniqueUvendorCodes.isEmpty()){
                 for(string plantCode: uniqueUvendorCodes ){                
                 listUvendorcode.add(new SelectOption(plantCode,plantCode));
                 }    
             }             
         }else{
          shwmsg = true;
             message1 = label.WWP_Ultimate_vendor_err;
         }
         //List<WWP_Loss_Tree__c>   weeklistLossTree = [select id,name,Week__c from WWP_Loss_Tree__c where plant_code__c IN :uniqueCodes order by createddate Limit 50000 ];
          List<WWP_Loss_Tree__c>   DesclistLossTree = [select id,name,plant_description__c,Plant_Country__c,SAP_vendor_code__c from WWP_Loss_Tree__c where Ultimate_Supplier_code__c IN :uniqueUvendorCodes order by createddate Limit 50000 ];
           //system.debug('dddddddddddddddd'+weeklistLossTree.size());
           Map<String,String> weekMap = new Map<String,String>();
           Map<String,String> descMap= new Map<String,String>();
           Map<String,String> countryMap= new Map<String,String>();
           Map<String,String> SAPvMap= new Map<String,String>();
           
           
           for(WWP_Loss_Tree__c snpV:DesclistLossTree ){
                 SAPvMap.put(snpV.SAP_vendor_code__c,snpV.name);
           }             
             for(String snpvc:SAPvMap.Keyset()){
               if(snpvc!=null){
                   listSnpvendorcode.add(new SelectOption(snpvc,snpvc));
               }
             }
           
           
          /* for(WWP_Loss_Tree__c weekV:weeklistLossTree){
                 weekMap.put(weekV.Week__C,weekv.name);
           }             
             for(String week:weekMap.Keyset()){
               if(week!=null){
                   listWeekCodes.add(new SelectOption(week,week));
               }
             }*/
          for(WWP_Loss_Tree__c descriptions:DesclistLossTree ){
                 descMap.put(descriptions.plant_description__c ,descriptions.name);
           }             
             for(String desce:descMap.Keyset()){
               if(desce!=null){
                   listPlantdescription.add(new SelectOption(desce,desce));
               }
             }
              for(WWP_Loss_Tree__c descriptions:DesclistLossTree ){
                 countryMap.put(descriptions.Plant_Country__c ,descriptions.name);
           }             
             for(String countr:countryMap.Keyset()){
               if(countr!=null){
                   listcountrydescription.add(new SelectOption(countr,countr));
               }
             }
        system.debug('week'+listPlantdescription);         
         }
         catch(Exception e){
             ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,e.getmessage()));
         }
     
     
     }
     public void fetchLossTree(){
        listLossTree = new List<WWP_Loss_Tree__c>();
        listLossTreeW = new List<LossTreeWrapper>();
        listbox1all.clear();
        listbox2all.clear();
        listbox3all.clear();
        selectbox1all.clear();
        selectbox2all.clear();
        selectbox3all.clear();
        mapbox12.clear();
        mapbox13.clear();
        mapbox21.clear();
        mapbox23.clear();
        mapbox31.clear();
        mapbox32.clear();
        mapcombine12.clear();
        successmessage=valueNull;
        showpickVal = true;
        showMassFeature = false;
        Id profileId=userinfo.getProfileId();
        String profileName=[Select Id,Name from Profile where Id=:profileId].Name;
        system.debug('profilename'+profileName);
        date myDate = date.today();
        date weekStart = myDate.toStartofWeek();
        
        
       system.debug('******'+lossTree.Loss_Type__c);
        system.debug('&&&&&&&'+lossTree.Ultimate_Supplier_code__c);
        system.debug('+++++++'+listSAPcodedesc);
        system.debug('@@@@@@@'+listSAPcodedesc);
        if(lossTree.Loss_Type__c!=null && lossTree.Ultimate_Supplier_code__c!=null && listSAPcodedesc != null && selectedplantdescription != null && selectedcountrydescription != null){
            
             if(dispalyAll){
                   
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,Resource_Line__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where   Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and SAP_vendor_code__c=:listSAPcodedesc and Loss_Type__c=:losstree.loss_type__c and plant_description__c=:selectedplantdescription and Plant_Country__c =:selectedcountrydescription   and createddate >= :weekStart  LIMIT 1000];
            }
                else{
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Resource_Line__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where Loss_Type__c=:lossTree.Loss_Type__c and Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and SAP_vendor_code__c=:listSAPcodedesc and plant_description__c=:selectedplantdescription and Plant_Country__c =:selectedcountrydescription  and createddate>=:weekStart  and Loss_Type__c!=null and OTIF_supplier_update__c = false order by CreatedDate ASC LIMIT 1000];
            }
            
            shwmsg = false;
            
        }
        else if(lossTree.Loss_Type__c!=null && lossTree.Ultimate_Supplier_code__c!=null && listSAPcodedesc == null && selectedplantdescription== null && selectedcountrydescription == null){
        
        system.debug('enetred here@@@@@@@@@@@@@@@@@@');
            if(dispalyAll){
                    
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,Resource_Line__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where   Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and Loss_Type__c=:losstree.loss_type__c   and createddate >= :weekStart  LIMIT 1000];
            }
                else{
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Resource_Line__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where Loss_Type__c=:lossTree.Loss_Type__c and Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c  and createddate>=:weekStart  and Loss_Type__c!=null and OTIF_supplier_update__c = false order by CreatedDate ASC LIMIT 1000];
            }
        shwmsg = false;
        }
         else if(lossTree.Loss_Type__c!=null && lossTree.Ultimate_Supplier_code__c!=null && listSAPcodedesc != null && selectedplantdescription== null && selectedcountrydescription == null){
        
        system.debug('enetred here@@@@@@@@@@@@@@@@@@');
            if(dispalyAll){
                    
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,Resource_Line__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where   Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and Loss_Type__c=:losstree.loss_type__c and SAP_vendor_code__c =:listSAPcodedesc  and createddate >= :weekStart  LIMIT 1000];
            }
                else{
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Resource_Line__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where Loss_Type__c=:lossTree.Loss_Type__c and Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and SAP_vendor_code__c =:listSAPcodedesc  and createddate>=:weekStart  and Loss_Type__c!=null and OTIF_supplier_update__c = false order by CreatedDate ASC LIMIT 1000];
            }
        shwmsg = false;
        }
         else if(lossTree.Loss_Type__c!=null && lossTree.Ultimate_Supplier_code__c!=null && listSAPcodedesc != null && selectedplantdescription != null && selectedcountrydescription == null){
        
        system.debug('enetred here@@@@@@@@@@@@@@@@@@');
            if(dispalyAll){
                    
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,Resource_Line__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where   Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and Loss_Type__c=:losstree.loss_type__c and SAP_vendor_code__c =:listSAPcodedesc and plant_description__c=:selectedplantdescription  and createddate >= :weekStart  LIMIT 1000];
            }
                else{
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Resource_Line__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where Loss_Type__c=:lossTree.Loss_Type__c and Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and SAP_vendor_code__c =:listSAPcodedesc and plant_description__c=:selectedplantdescription  and createddate>=:weekStart  and Loss_Type__c!=null and OTIF_supplier_update__c = false order by CreatedDate ASC LIMIT 1000];
            }
        shwmsg = false;
        }
        else if(lossTree.Loss_Type__c!=null && lossTree.Ultimate_Supplier_code__c!=null && listSAPcodedesc != null && selectedplantdescription == null && selectedcountrydescription != null){
        
        system.debug('enetred here@@@@@@@@@@@@@@@@@@');
            if(dispalyAll){
                    
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,Resource_Line__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where   Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and Loss_Type__c=:losstree.loss_type__c and SAP_vendor_code__c =:listSAPcodedesc and Plant_Country__c =:selectedcountrydescription   and createddate >= :weekStart  LIMIT 1000];
            }
                else{
            listLossTree = [select id,name,Loss_Type__c,PO__c,SKU__c,Plant_Code__c,Loss_Name__c,Resource_Line__c,Loss_Sub_Family__c,createddate,Remarks__c,
                             Loss_Description__c,Planned_Receipt__c,actual_Receipt__c,MRP_Loss_Value__c,DC__c,OR__C,OR_Loss_Value__c,Planned_dispatch__c,Actual_dispatch__c,Actual_Production__c,Planned_Production__c,DC_Loss_Value__c,Week__c,PR__c,STO_So__c,SKU_description__c,Material__c,material_Description__c,Material_Type__c,Material_Group__c,PO_Line_Item_Number__c,PO_Schedule_Line_Item_Number__c,PO_Delivery_Date_as_per_Current_PO__c,PO_QTY__c,GR_Date__c,GR_QTY__c,
SUPPLIER_OTIF_QTY_COMPLIANCE__c,SUPPLIER_OTIF_TIME_COMPLIANCE__c,OVERALL_SUPPLIER_OTIF_COMPLIANCE__c  from WWP_Loss_Tree__c where Loss_Type__c=:lossTree.Loss_Type__c and Ultimate_Supplier_code__c=:lossTree.Ultimate_Supplier_code__c and SAP_vendor_code__c =:listSAPcodedesc and Plant_Country__c =:selectedcountrydescription   and createddate>=:weekStart  and Loss_Type__c!=null and OTIF_supplier_update__c = false order by CreatedDate ASC LIMIT 1000];
            }
        shwmsg = false;
        }
        else{
        system.debug('%%%%%%%%%%');
         shwmsg = true;
         message1 = label.WWP_RequiredFeilds_Err;
        }
        
         if(listLossTree.isEmpty()){
          shwmsg = true;
              message1 = label.WWP_Norecords_Err;
          }else{
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
                }else{
                    listbox12 = Mapbox12.get(w.loss_name__c);
                    listbox12.add(w.loss_sub_family__c);
                    Mapbox12.put(w.loss_name__c,listbox12);
                }                
                set<string> listbox13 = new set<string>();
                if(!Mapbox13.containsKey(w.loss_name__c)){                
                    listbox13.add(w.Loss_Description__c);
                    Mapbox13.put(w.loss_name__c,listbox13);
                }else{                    
                    listbox13 = Mapbox13.get(w.loss_name__c);
                    listbox13.add(w.Loss_Description__c);
                    Mapbox13.put(w.loss_name__c,listbox13);
                }
                set<string> listbox21 = new set<string>();
                if(!Mapbox21.containsKey(w.loss_sub_family__c)){                
                    listbox21.add(w.loss_name__c);
                    Mapbox21.put(w.loss_sub_family__c,listbox21);
                }else{
                    listbox21 = Mapbox21.get(w.loss_sub_family__c);
                    listbox21.add(w.loss_name__c);
                    Mapbox21.put(w.loss_sub_family__c,listbox21);
                }                
                set<string> listbox23 = new set<string>();
                if(!Mapbox23.containsKey(w.loss_sub_family__c)){                
                    listbox23.add(w.Loss_Description__c);
                    Mapbox23.put(w.loss_sub_family__c,listbox23);
                }else{
                    listbox23 = Mapbox23.get(w.loss_sub_family__c);
                    listbox23.add(w.Loss_Description__c);
                    Mapbox23.put(w.loss_sub_family__c,listbox23);
                }                
                set<string> listcombine12 = new set<string>();
                if(!mapcombine12.containsKey(w.loss_name__c+w.loss_sub_family__c)){ 
                listcombine12.add(w.Loss_Description__c);
                mapcombine12.put(w.loss_name__c+w.loss_sub_family__c,listcombine12);
                }else{
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
         }
         //WWP_Losstree_Copy_Component_Ctrl cmp = new WWP_Losstree_Copy_Component_Ctrl();
         //system.debug('called');
        //cmp.fetchLossTree1();
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
                selectbox1all.addAll(listbox1all);
                selectbox2all.addAll(listbox2all);
                selectbox3all.addAll(listbox3all);
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
        public boolean checkdissable{get;set;}        
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
        public decimal lossdiff {get; set;}
        public decimal lossdiffDC;
        Public decimal orVal;
        Public decimal plVal;
        public LossTreeWrapper(WWP_Loss_Tree__c lt,List<SelectOption> listbox1all,List<SelectOption> listbox2all,List<SelectOption> listbox3all,integer y){
            checkbox1 = false;
            wlt = lt;
           // remarks = lt.remarks__c;            
            //Map<string,WWP_Master_Table__c> masterTableValues= WWP_Master_Table__c.getAll();
           // orVal = masterTableValues.get(lt.Plant_Code__c).OR_Tolerance__c;
           // plVal = 1-(orVal/100) ;            
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
           /*if(lt.loss_type__c == 'Output Reliability' && lt.Planned_Production__c != null && lt.Planned_Production__c != 0){              
               lossdiff = lt.OR_Loss_Value__c/lt.Planned_Production__c;    
               //system.debug('lossdiff->' + lossdiff );
           }
           if(lt.loss_type__c == 'Output Reliability' && lt.Planned_Production__c == 0){
               lossdiff = 100;
           }
           if(lt.loss_type__c == 'Dispatch Compliance' && lt.Planned_Dispatch__c!= null && lt.Planned_Dispatch__c!= 0){              
               lossdiffDC = lt.DC_Loss_Value__c/lt.Planned_Dispatch__c;       
           }
           if(lt.loss_type__c == 'Dispatch Compliance' && lt.Planned_Dispatch__c== 0){
               lossdiffDC = 100;
           }*/
          /*if(lt.loss_type__c == 'Output Reliability' ){
          if(lossdiff <= plVal){
           isdisabled =true;
           checkdissable = true;
           Remarks = 'above target';
           }else{
           isdisabled=false;
           checkdissable = false;
           }
           }else{
           if(lossdiffDC <= 0.05){           
           isdisabled =true;
           checkdissable = true;
           }else{
           isdisabled=false;
           checkdissable = false;           
           }           
           } */          
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
        if(lossname!=null && lossname!=valueNone){
        listbox11select.add(new SelectOption(lossname,lossname));
        listLossTreeW[ite].listbox1=listbox11select;
        listLossTreeW[ite].checkbox1 = true;
        listbox12select.add(new SelectOption(valueNone,valueNone));
            listbox13select.add(new SelectOption(valueNone,valueNone));
            if(listLossTreeW[ite].selectbox2==valueNone){
                for(string s2:Mapbox12.get(lossname)){
                listbox12select.add(new SelectOption(s2,s2));
                //making true
                listLossTreeW[ite].checkbox1 = true;
                }           
                listLossTreeW[ite].listbox2=listbox12select;            
                for(string s3:Mapbox13.get(lossname)){
                    listbox13select.add(new SelectOption(s3,s3));
                    //making true
                    listLossTreeW[ite].checkbox1 = true;
                }
                listLossTreeW[ite].listbox3=listbox13select;
                listLossTreeW[ite].checkbox1 = true;
            }else{
                if(listLossTreeW[ite].selectbox2!=valueNone && listLossTreeW[ite].listbox2.size()==1){
                    for(string s3:mapcombine12.get(lossname+listLossTreeW[ite].selectbox2)){
                    listbox13select.add(new SelectOption(s3,s3));
                    //making true
                    listLossTreeW[ite].checkbox1 = true;
                    }
                    listLossTreeW[ite].listbox3=listbox13select;
                }
                if(listLossTreeW[ite].selectbox2!=valueNone && listLossTreeW[ite].listbox2.size()>1){
                    for(string s2:Mapbox12.get(lossname)){
                    listbox12select.add(new SelectOption(s2,s2));
                    //making true
                    listLossTreeW[ite].checkbox1 = true;
                    }           
                    listLossTreeW[ite].listbox2=listbox12select;                
                    for(string s3:Mapbox13.get(lossname)){
                        listbox13select.add(new SelectOption(s3,s3));
                        //making true
                        listLossTreeW[ite].checkbox1 = true;
                    }
                    listLossTreeW[ite].listbox3=listbox13select;
                }
            }
        }
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
                    //making true
                    listLossTreeW[ite].checkbox1 = true;
                }            
                listLossTreeW[ite].listbox1=listbox21select;
                listbox23select.add(new SelectOption(valueNone,valueNone));
                for(string s3:Mapbox23.get(losssubfamily)){
                    listbox23select.add(new SelectOption(s3,s3));
                    //making true
                    listLossTreeW[ite].checkbox1 = true;
                }
                listLossTreeW[ite].listbox3=listbox23select;
            }
            if(listLossTreeW[ite].listbox1.size()==1 && listLossTreeW[ite].selectbox1!=valueNone){
                listbox23select.add(new SelectOption(valueNone,valueNone));
                for(string s3:mapcombine12.get(listLossTreeW[ite].selectbox1+losssubfamily)){
                listbox23select.add(new SelectOption(s3,s3));
                //making true
                listLossTreeW[ite].checkbox1 = true;
                }
                listLossTreeW[ite].listbox3=listbox23select;    
            }
            listbox22select.add(new SelectOption(losssubfamily,losssubfamily));
                listLossTreeW[ite].listbox2=listbox22select;
                //making true
                listLossTreeW[ite].checkbox1 = true;
        }
    }    
    public void control3132(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('firstParam3'));
        string lossdesc = Apexpages.currentPage().getParameters().get('secondParam3');
        List<SelectOption> listbox31select = new List<SelectOption>();
        List<SelectOption> listbox32select = new List<SelectOption>();
        List<SelectOption> listbox33select = new List<SelectOption>();       
        if(lossdesc!=null && lossdesc!=valueNone){        
            for(string s1:Mapbox31.get(lossdesc)){
            system.debug('mmmmmmmmmmmm'+s1);
                listbox31select.add(new SelectOption(s1,s1));
                listLossTreeW[ite].selectbox1=s1;
                //making true
                listLossTreeW[ite].checkbox1 = true;
            }
            listLossTreeW[ite].listbox1=listbox31select;
            for(string s2:Mapbox32.get(lossdesc)){
                listbox32select.add(new SelectOption(s2,s2));
                listLossTreeW[ite].selectbox2=s2;
                //making true
                listLossTreeW[ite].checkbox1 = true;                
            }
            listLossTreeW[ite].listbox2=listbox32select;
                listbox33select.add(new SelectOption(lossdesc,lossdesc));
                listLossTreeW[ite].listbox3=listbox33select;
                //making true
                listLossTreeW[ite].checkbox1 = true;
          }        
     }
    //======================================================copy functionality
     /*public void copyline(){       
         string lossname = Apexpages.currentPage().getParameters().get('losssecondParam1');
         string lossfam = Apexpages.currentPage().getParameters().get('losssecondParam2');
         string lossdesc = Apexpages.currentPage().getParameters().get('losssecondParam3');
         integer count=0;
         integer counter = 0;
         for(integer i =0 ; i < listLossTreeW.size(); i++){     
        if(listLossTreeW[i].checkbox1){
        counter++;
        if(!listLossTreeW[i].isdisabled ){
           system.debug('sssss'+listLossTreeW[i].isdisabled);
                listLossTreeW[i].selectbox1 = lossname ;
                listLossTreeW[i].selectbox2 = lossfam ;
                listLossTreeW[i].selectbox3 = lossdesc ;
                count++;
           }
           }
        }
        if(counter == 0){
            message=label.WWP_selectRecord_Err;
            successmessage =valueNull;
        }else if(count == 0){
            message = label.WWp_selectedrecord_disabled;
            successmessage =valueNull;
        }
        else{
            message =valueNull;                    
        }
    }    */
    //=================================================End here    
    public void resetline(){
        integer ite = integer.valueof(Apexpages.currentPage().getParameters().get('resetite'));
        system.debug('iiiiiiiiiiiiiiiiiiii'+ite);
        listLossTreeW[ite].listbox1=listbox1all;
        listLossTreeW[ite].listbox2=listbox2all;
        listLossTreeW[ite].listbox3=listbox3all;
        listLossTreeW[ite].selectbox3=valueNone;
        listLossTreeW[ite].selectbox1=valueNone;
        listLossTreeW[ite].selectbox2=valueNone;
        listLossTreeW[ite].Remarks = valueNull;
        listLossTreeW[ite].checkbox1 = false;
     }    
    public void updateLossTree(){
    Map<string,string> lm = new Map<string,string>();
    list<WWP_losslevel_code_maping__c> sm = [select level__c,code__c from WWP_losslevel_code_maping__c]; 
        for(WWP_losslevel_code_maping__c cm:sm){
          lm.put(cm.level__c,cm.code__c) ; 
        }
    integer count=0;
        List<WWP_Loss_Tree__c> updateLTW = new List<WWP_Loss_Tree__c>();
        try{
        if(listLossTreeW!=null && !listLossTreeW.isEmpty()){
            for(LossTreeWrapper lw: listLossTreeW){
                if(lw.checkbox1){
                    WWP_Loss_Tree__c wt = new WWP_Loss_Tree__c();
                    wt.id = lw.wlt.id;
                    wt.Remarks__c = lw.Remarks;
                    if(lw.selectbox1!=valueNone){
                    wt.Loss_Name__c = lw.selectbox1;
                    if(lossTree.Loss_Type__c == 'Supplier OTIF'){
                         wt.Loss_Level1_Code__c = lm.get(lw.selectbox1);
                    }
                    }else{
                        wt.Loss_Name__c = valueNull ;
                        wt.Loss_Level1_Code__c = '';
                    }
                    if(lw.selectbox2!=valueNone){
                    wt.Loss_Sub_Family__c= lw.selectbox2;
                    if(lossTree.Loss_Type__c == 'Supplier OTIF'){
                         wt.Loss_Leve2_Code__c = lm.get(lw.selectbox2);
                    }
                    }else{
                        wt.Loss_Sub_Family__c= valueNull ;
                        wt.Loss_Leve2_Code__c = '';
                    }
                    if(lw.selectbox3!=valueNone){                    
                    wt.Loss_Description__c = lw.selectbox3;
                    if(lossTree.Loss_Type__c == 'Supplier OTIF'){
                         wt.Loss_Level3_Code__c = lm.get(lw.selectbox3);
                    }
                    }else{
                        wt.Loss_Description__c = valueNull ;
                        wt.Loss_Level3_Code__c = '';
                    }
                    updateLTW.add(wt);
                    count++;
                }  
                lw.checkbox1 = false; 
            }
            if(count == 0){
                    //fetchLossTree();                  
                    message1=label.WWP_selectRecord_Err; 
                    successmessage =valueNull;                   
                }else{
                    message1 =valueNull;                    
                } 
            if(updateLTW!=null && !updateLTW.isEmpty()){
                update updateLTW;
                fetchLossTree();
               // WWP_Losstree_Copy_Component_Ctrl cmp = new WWP_Losstree_Copy_Component_Ctrl();
               // cmp.fetchLossTree1();
                successmessage=label.WWP_RecordsUpdated_Msg;
                message1 =valueNull;
                shwmsg = true;
            }
        }
        
        }catch(Exception e){
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.Info,e.getmessage()));
        }
    }
}