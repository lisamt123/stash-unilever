/**
    About
    -----
    Description: Class Oblix_Ctrl07ProjectEdit_CC 
    Created for: OBLIX Project
    Create date: Oct 23, 2015
    Created by Asmae ESSBAI
    Author : @Asmae
    Details
    -------
    
       Update History
    --------------    
*/
    public with sharing class Oblix_Ctrl07ProjectEdit_CC {
        
        public id projectId {get;set;}         
        public list<Oblix_Project_Assets__c> lstAssets {get;set;}
        public boolean isEdit {get;set;}
        public User userConnected {get;set;}
        public Oblix_SOW_Projects__c project {get;set;}
        public Oblix_SOW_Projects__c pr {get;set;}
        public set<string> setRecordType  {get;set;}
        public map<string,list<Oblix_Project_Assets__c>> mapRTAssets {get;set;}
        public Oblix_Project_Assets__c asset {get;set;}
        public map<string,string> mapRTIdCSS {get;set;}
        public map<string,string> mapStageIdCSS {get;set;}
        public string setIdCss {get;set;}
        public string recordType {get;set;}
        public string subCat {get;set;}
        public string complexity {get;set;}
        public list<Oblix_Project_Assets__c> lstAssetsForCard {get;set;}
        public map<string,Oblix_Project_Assets__c> mapRTSUBCatAsset {get;set;}
        public map<string,list<string>> mapRTSUBCat {get;set;}
        public list<RecordType> recordTypes {get;set;}
        public list<string> lstRecordType {get;set;}
        public list<Decimal> lstAES {get;set;}
        public Oblix_Project_Assets__c assetJoe {get;set;}
        public integer mynumber {get;set;}
        public list<string> lstStage {get;set;}
        public Map<String, set<String>> mapRelatedCntries {get;set;}       
        public Map<String,String> mapRegionCntries {get;set;}
        public Oblix_Project_Assets__c  assetInstance  {get;set;}
        public set<string> lstRegion {get;set;}
        public list<MDO_Geography__c> lstCountries {get;set;}
        public map<string,ID> mapIdCSSCountryRegion {get;set;}
        public string lstIdCSSSelected {get;set;}
        public List<Oblix_Marketing_SOW_Project_Splits__c> lstProjectSplitHubs {get;set;}
        private list<string> lstSelectedRegion ;
        public Oblix_Marketing_SOW_Project_Splits__c agencySplitInstanceJS {get;set;}
        public map<string,integer> feePercentages {get;set;}
        public map<string,string> mapScoreDesc {get;set;}
        public set<string> lstNameCountries {get;set;}
        public Oblix_Marketing_SOW_Project_Splits__c  split {get;set;}
        public list<Oblix_Marketing_SOW_Project_Splits__c> splitToInsert {get;set;}
        public list<Oblix_Marketing_SOW_Project_Splits__c> splitToUpdate {get;set;}
        public list<Oblix_Marketing_SOW_Project_Splits__c> splitToDelete {get;set;}
        public string idSplit {get;set;}
        public integer counterAsset {get;set;}

        public Oblix_Ctrl07ProjectEdit_CC (){
            lstStage = new list<string>();
            setRecordType  = new set<string>();
            mapRegionCntries = new Map<String,String>();
            setIdCss = '';   
            counterAsset = 0;         
            splitToInsert = new list<Oblix_Marketing_SOW_Project_Splits__c>();
            splitToUpdate = new list<Oblix_Marketing_SOW_Project_Splits__c>();
            splitToDelete = new list<Oblix_Marketing_SOW_Project_Splits__c>();
            split = new Oblix_Marketing_SOW_Project_Splits__c();
            lstNameCountries = new set<string>();
            lstSelectedRegion = new list<string>();
            mapScoreDesc = new map<string,string>();
            agencySplitInstanceJS = new Oblix_Marketing_SOW_Project_Splits__c();
            feePercentages = new map<string,integer>();              
            mapIdCSSCountryRegion = new map<string,ID>();
            mapRelatedCntries = new Map<String, set<String>>();
            lstRecordType = new list<string>();
            lstAES = new list<Decimal>();
            lstAssetsForCard = new list<Oblix_Project_Assets__c>();          
            if(projectId == null) isEdit = false;      
            if(projectId != null) isEdit = true;  
            mapRTSUBCatAsset = new map<string,Oblix_Project_Assets__c>(); 
            lstAssets = new list<Oblix_Project_Assets__c>();
            mapRTAssets = new map<string,list<Oblix_Project_Assets__c>>();
            mapRTIdCSS = new map<string,string>();
            mapStageIdCSS = new map<string,string>();
            mapRTSUBCat = new map<string,list<string>>();
            asset = new Oblix_Project_Assets__c();    
            asset.Sub_Category__c = 'Origination';
            assetInstance = new Oblix_Project_Assets__c();  
            lstRegion = new set<string>();
            mynumber = 6;   
            init();
        }
       
        public void init(){
        
            Id idUser = UserInfo.getUserId();
            userConnected = [Select Name from User where Id =: idUser ];
            projectId = ApexPAges.currentPage().getParameters().get('projectId');
            lstCountries = [Select m.parent_L6__c, m.parent_L5__c, m.parent_L4__c, m.parent_L3__c, m.parent_L2__c, 
                      m.parent_L1__c, m.geography_type__c, m.Name, m.Id, parent_L5__r.Name From MDO_Geography__c m where geography_type__c ='Country'
                      ];
            for(MDO_Geography__c country : lstCountries){
                   lstRegion.add(country.parent_L5__r.Name);
                   if(country.parent_L5__c != null){
                       if(!mapRelatedCntries.containsKey(country.parent_L5__r.Name)){
                          mapRelatedCntries.put(country.parent_L5__r.Name,new set<string>());                         
                       }else{
                          mapRelatedCntries.get(country.parent_L5__r.Name).add(country.Name);                         
                       } 
                        mapIdCSSCountryRegion.put(country.name,country.id);
                        if(mapIdCSSCountryRegion.get(country.parent_L5__r.Name) == null){
                            mapIdCSSCountryRegion.put(country.parent_L5__r.Name,country.parent_L5__r.id);
                            mapRegionCntries.put(country.name,country.parent_L5__r.id);
                            lstNameCountries.add(country.name);
                        }
                    }
            }            
            lstStage = Oblix_Utils.getStageList();
            feePercentages.put(lstStage[0],10);
            feePercentages.put(lstStage[1],30);
            feePercentages.put(lstStage[2],60);
            feePercentages.put(lstStage[3],85);
            feePercentages.put(lstStage[4],100);
            for(string stage:lstStage){
                mapStageIdCSS.put(stage,stage.replaceAll(' & ','_').replaceAll(' ','_'));
            } 
            recordTypes = [SELECT Name FROM RecordType WHERE sObjectType = 'Oblix_Project_Assets__c' and name != 'Admin' Order by name];
            
            if(projectId == null){
                 project = new Oblix_SOW_Projects__c ();
                 project.Financial_Year__c = ApexPAges.currentPage().getParameters().get('sowId');               
            }else{
                project = [Select Id,Name, Innovation_Projects__c ,Campaign_Fees_Total__c,Completed_Stage__c,Financial_Year__r.currency__c,Projected_Stage__c,BET_first_release__c,Value_to_be_paid_in_Current_FY__c,Campaign_Status__c,Preview_Date__c,Start_of_TV_production__c,Final_release__c,Live_Date__c,Live_date_Asset_delivery__c, Date_for_Assets_to_be_in_BET__c,Timescale_Notes__c, Brand_Led_Growth__c, Project_Scale_1__c, Project_Scale_2__c, Campaign_Idea__c, Project_Finish_Date__c,Project_Stage__c,Platform__c,CreatedById, Project_Start_Date__c,CreatedDate,OblixRegion__c,Project_Priority__c,Project_Completion_Date__c,Description__c,OblixCountries__c,First_Air_Date__c,Production_Completion_Date__c, Financial_Year__c from Oblix_SOW_Projects__c where id=:projectId];               
                lstAssets = [select Id,Agency_Projects__r.id,Channels__c,RecordType.Name,Asset_Picklist__c,Name,RecordTypeId,Sub_Category__c,FULL_Description__c from Oblix_Project_Assets__c];               
                lstProjectSplitHubs = [Select Id, Name, OblixCountry__c, Project_Splits__c, Percentage__c from Oblix_Marketing_SOW_Project_Splits__c where Project_Splits__c =: projectId];                               
                if(lstProjectSplitHubs.size() < 5) {
                    counterAsset = 5;
                }else{
                    counterAsset = lstProjectSplitHubs.size();
                }
                for(integer i=0;i<5;i++){
                    if(lstProjectSplitHubs.size() < 5 || lstProjectSplitHubs.isEmpty()){
                        Oblix_Marketing_SOW_Project_Splits__c FiveAgencySplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
                        FiveAgencySplitInstance.Project_Splits__c = projectId;
                        lstProjectSplitHubs.add(FiveAgencySplitInstance);
                    }
                }
                for(recordType rec:recordTypes){
                    lstRecordType.add(rec.name);
                }
                if(project.OblixCountries__c != null){
                    lstSelectedRegion = project.OblixCountries__c.split(',');
                }
                if(project.OblixRegion__c != null){
                    lstSelectedRegion.addAll(project.OblixRegion__c.split(',')); 
                }               
                system.debug('### mapIdCSSCountryRegion :'+mapIdCSSCountryRegion);
                lstIdCSSSelected = '';
                for(string slctedRegionOrCountry :lstSelectedRegion){
                     lstIdCSSSelected = lstIdCSSSelected + mapIdCSSCountryRegion.get(slctedRegionOrCountry)+',';
                }                
                // add the stage checkbox 
                lstIdCSSSelected = lstIdCSSSelected + getSelectedStageCheckbox(project.Projected_Stage__c,project.Completed_Stage__c);
                lstIdCSSSelected = lstIdCSSSelected.removeEnd(',');
                system.debug('### lstIdCSSSelected :'+lstIdCSSSelected);
                if(lstAssets.isEmpty() == false){
                    for(Oblix_Project_Assets__c asset:lstAssets){
                        setRecordType.add(asset.RecordType.Name); 
                        //setIdCss.add((asset.RecordType.Name).replaceAll(' ',''));
                        if(mapRTIdCSS.get(asset.RecordType.Name) == null)
                        mapRTIdCSS.put(asset.RecordType.Name,(asset.RecordType.Name).replaceAll(' ',''));
                    }   
                    for(string x:setRecordType){
                         setIdCss = setIdCss+'"'+x.replaceAll(' ','')+'",';
                    }     
                    setIdCss = '['+setIdCss.removeEnd(';')+']';           
                    for(Oblix_Project_Assets__c asset:lstAssets){
                        if(!(mapRTAssets).containsKey(asset.RecordType.Name))mapRTAssets.put(asset.RecordType.Name,new list<Oblix_Project_Assets__c>());
                        mapRTAssets.get(asset.RecordType.Name).add(asset);    
                    }                                       
                }
                getScoreDescription();
                for(string rec:lstRecordType){
                    if(mapRTAssets.get(rec) == null ) {mapRTAssets.put(rec,new list<Oblix_Project_Assets__c>());}
                    if(mapRTIdCSS.get(rec) == null ) {mapRTIdCSS.put(rec,(rec).replaceAll(' ',''));}
                    mapRTSUBCat.put(rec,Oblix_Utils.lstSubCatPerRecT(rec));
                    for(string sub:Oblix_Utils.lstSubCatPerRecT(rec)){
                        string x = rec+'_'+sub+'_1';
                        string x1 = rec+'_'+sub+'_2';
                        string x2 = rec+'_'+sub+'_3';
                        mapRTSUBCatAsset.put(x,new Oblix_Project_Assets__c());  
                        mapRTSUBCatAsset.put(x1,new Oblix_Project_Assets__c());  
                        mapRTSUBCatAsset.put(x2,new Oblix_Project_Assets__c());  
                    }
                }
            }
        }
        public void setInfoTimeLine(){
            // nothing juste saving the mapping values 
            if(projectId != null){
                update project;
            }
        }
        public void setInfoCountries(){
            // nothing juste saving the mapping values 
             /*if(project.OblixCountries__c != '' || project.OblixCountries__c != null){
             list<string> country = new list<string>();            
             country = project.OblixCountries__c.split(',');
             list<MDO_Geography__c>  countries =[Select name,parent_L5__r.Name From MDO_Geography__c m where geography_type__c ='Country' and Name In:country];              
                 for(MDO_Geography__c  con:countries){
                     system.debug('### con.name+ :'+con.name);      
                     if(project.OblixRegion__c.contains(con.parent_L5__r.Name) == true) {
                         project.OblixCountries__c = project.OblixCountries__c.remove(''+con.name);
                         project.OblixCountries__c = project.OblixCountries__c.replaceAll(',,',',');
                         project.OblixCountries__c = project.OblixCountries__c.removeEnd(',');
                         project.OblixCountries__c = project.OblixCountries__c.removeStart(',');
                         system.debug('### project.OblixRegion__c.contains(con.parent_L5__r.Name) :'+project.OblixRegion__c.contains(con.parent_L5__r.Name));
                         system.debug('### project.OblixCountries__c :'+project.OblixCountries__c.remove(con.parent_L5__r.Name+','));
                     }
                 }
             }*/
             system.debug('### ');
             if(projectId != null){
                update project;
            }
        }
        public void getScoreDescription(){
                   
            list<Asset_Scoring__c> scores = [select name,Sub_Category__c,Type__c,Description__c from Asset_Scoring__c];
            system.debug('### scores  : '+scores );
            for(Asset_Scoring__c sc:scores){
                if((sc.name).contains('1') == true){
                    mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'1',sc.Description__c);
                }else{
                     mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'1','0');
                }
                if((sc.name).contains('2') == true){
                    mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'2',sc.Description__c);
                }else{
                     mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'2','0');
                }
                if((sc.name).contains('3') == true){
                    mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'3',sc.Description__c);
                }else{
                     mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'3','0');
                }
                if((sc.name).contains('4') == true){
                    mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'4',sc.Description__c);
                }else{
                     mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'4','0');
                }
                if((sc.name).contains('5') == true){
                    mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'5',sc.Description__c);
                }else{
                     mapScoreDesc.put(sc.Type__c+sc.Sub_Category__c+'5','0');
                }
                mapScoreDesc.put('Stimulus Materials - Research requirementsStimulus requirements1','0'); 
                mapScoreDesc.put('Stimulus Materials - Research requirementsStimulus requirements2','0'); 
                mapScoreDesc.put('Stimulus Materials - Research requirementsStimulus requirements3','0');
                mapScoreDesc.put('Stimulus Materials - Research requirementsStimulus requirements4','0'); 
                mapScoreDesc.put('Stimulus Materials - Research requirementsStimulus requirements5','0'); 
            }
         
        }
        public void setInfoDrivers(){
             if(projectId != null){
                update project;
            }
        }
        public void setInfoStages(){
            if(projectId != null){
                update project;
            }
        }
        // the asset list in the card when we click on the record accordion
        public void getAssetRecordType(){
        
            list<Oblix_Project_Assets__c> lstAsset = [select Id,Agency_Projects__r.id,Channels__c,RecordType.Name,Quantity__c ,Asset_Picklist__c,Name,RecordTypeId,Sub_Category__c,FULL_Description__c from Oblix_Project_Assets__c where Agency_Projects__r.id =:project.id  and RecordType.Name=:recordType limit 15];  
            lstAssetsForCard.addAll(lstAsset);
        }
        public pageReference setAgencyHubOnComplete(){
         try{                
                update splitToUpdate;  
                delete splitToDelete;              
                insert splitToInsert;
                System.debug('###splitToInsert: '+splitToInsert); 
            }catch(Exception e){
                   System.debug('###Error Occured : '+splitToUpdate);   
            }
            return new pageReference('/apex/Oblix_VF08_ProjectEdit?projectId='+project.Id);
        }
        public void setInfoSplitHub(){
        
        try{
             if(projectId != null){
                agencySplitInstanceJS.Project_Splits__c = projectId;  
                system.debug('###### '+agencySplitInstanceJS);    
                
                if(idSplit InstanceOf ID){      
                  agencySplitInstanceJS.id = Id.valueOf(idSplit);                 
                  if(agencySplitInstanceJS.Percentage__c != 0){                   
                    splitToUpdate.add(agencySplitInstanceJS);
                  }
                  if(agencySplitInstanceJS.Percentage__c == 0){  
                        splitToDelete.add(agencySplitInstanceJS);
                  }
                  
                }
                if(idSplit == '' && agencySplitInstanceJS.Percentage__c != 0){ 
                      splitToInsert.add(agencySplitInstanceJS);
                    
                }
                
            
            } 
            }catch(Exception e){
                   System.debug('###Error Occured : '+e.getMessage());   
            }
            idSplit = '';
            agencySplitInstanceJS = new Oblix_Marketing_SOW_Project_Splits__c();
        }
        public void setMoreDetails(){
           
        }
        
        public pageReference SaveProjectAction(){
           try{
               if(projectId != null){
                    update project;
                    return new pageReference('/apex/Oblix_VF07_ProjectView?projectId='+project.Id);
                }else{           
                    insert project;
                    return new pageReference('/apex/Oblix_VF06_SOWView?sowId='+project.Financial_Year__c);
                }    
                  /*  System.debug('###Project before: '+assetJoe); 
                    System.debug('###Project before: '+project); 
                   
                   System.debug('###project after: '+project);  */  
            }catch(Exception e){
                   System.debug('###Error Occured : '+e.getMessage());   
                   return null;
            }
            
        }
        public pageReference InsertProjectAction(){
               try{
                    insert project;
                }catch(Exception e){
                   System.debug('###Error Occured : '+e.getMessage());   
                }
                return new pageReference('/apex/Oblix_VF08_ProjectEdit?projectId='+project.Id);           
        }
        public pageReference BackAction(){
           if(project.Id == null){
               return new pageReference('/apex/Oblix_VF06_SOWView?sowId='+project.Financial_Year__c);
           }else{
                return new pageReference('/apex/Oblix_VF07_ProjectView?projectId='+project.Id);
           }
            return null;
        }
        public void EditAction(){
            isEdit = true;
        }
        
        public void ValueDriversUpdate(){
            system.debug('###project.Campaign_Idea__c :'+project.Campaign_Idea__c );
            //pr.Campaign_Idea__c = pr.Campaign_Idea__c;
        }
        public void AddAgencySplit(){
            Oblix_Marketing_SOW_Project_Splits__c agencySplitInstance = new Oblix_Marketing_SOW_Project_Splits__c();
            agencySplitInstance.Project_Splits__c = projectId;
            lstProjectSplitHubs.add(agencySplitInstance);
        }
        public void AddToProjectAction(){                 
            //Id recordType  = ApexPages.currentPage().getParameters().get('recordType');
            //string subCat = ApexPages.currentPage().getParameters().get('subCat');        
           /* System.debug('###recordType : '+recordType);
            System.debug('###subCat : '+subCat);
            System.debug('###complexity: '+complexity);
             System.debug('###assetInstance.quantity: '+assetInstance.quantity);
            System.debug('###Oblix_Quantity__c: '+assetJoe.Oblix_Quantity__c); 
            */
            complexity = '%'+complexity;
            list<Asset_Scoring__c> lstscore = [select id from Asset_Scoring__c where Sub_Category__c =:assetInstance.Sub_Category__c and Type__c =:assetInstance.Asset_Type__c and Name like :complexity];
            RecordType  recordT = [SELECT Name,id FROM RecordType WHERE sObjectType = 'Oblix_Project_Assets__c' and name =: recordType];
            //assetInstance.Sub_Category__c = subCat;
            assetInstance.Agency_Projects__c = project.id;
            assetInstance.RecordTypeId = recordT.id;
            //assetInstance.Asset_Type__c = recordType;
            if(!lstscore.isEmpty()){
                assetInstance.FULL_Description__c = lstscore[0].id;
            }
            //assetInstance.assetWrapp.Agency_Projects__c = project.id;
            //assetInstance.assetWrapp.Sub_Category__c = subCat;
            //assetInstance.assetWrapp.quantity__c = assetInstance.quantity;
           insert assetInstance;
           Oblix_Project_Assets__c getAssetName = [select Name,Oblix_Quantity__c,Quantity__c,Sub_Category__c,Asset_Type__c from Oblix_Project_Assets__c where id =:assetInstance.id];
           lstAssetsForCard.add(getAssetName);
           assetInstance = new Oblix_Project_Assets__c ();
          /*
           
            System.debug('###mapRTSUBCatAsset.get : '+mapRTSUBCatAsset.get(recordType+'_'+subCat+'_'+complexity).Oblix_Quantity__c);
            
           //assetInstance.assetWrapp.Asset_Type__c = recordType;
            //
            lstAssetsForCard.add(mapRTSUBCatAsset.get(recordType+'_'+subCat+'_'+complexity));
            insert  mapRTSUBCatAsset.get(recordType+'_'+subCat+'_'+complexity);*/
            
            
            //assetInstance = new assetWrapper();
            //asset = new Oblix_Project_Assets__c();   
        }
        public string getSelectedStageCheckbox(string projected,string Completed){
            string lstProjectedItems = '';
            string lstCompletedItems = '';
            if(projected == 'Projected Briefing'){
                lstProjectedItems = 'Projected_Briefing';
            } 
            if(projected == 'Projected Strategy & Planning'){
                lstProjectedItems = 'Projected_Briefing' + ',Projected_Strategy_Planning';
            } 
            if(projected == 'Projected Creative Ideation'){
                lstProjectedItems = 'Projected_Briefing' + ',Projected_Strategy_Planning'+',Projected_Creative_Ideation';
            } 
            if(projected == 'Projected Creative Execution'){
                lstProjectedItems = 'Projected_Briefing' + ',Projected_Strategy_Planning'+',Projected_Creative_Ideation'+',Projected_Creative_Execution';
            }
            
            if(projected == 'Projected Production'){
                lstProjectedItems = 'Projected_Briefing' + ',Projected_Strategy_Planning'+',Projected_Creative_Ideation'+',Projected_Creative_Execution'+',Projected_Production';
            }           
            if(Completed == 'Completed Briefing'){
                lstCompletedItems = 'Completed_Briefing' ;
            } 
            if(Completed == 'Completed Strategy & Planning'){
                lstCompletedItems = 'Completed_Briefing' + ',Completed_Strategy_Planning';
            } 
            if(Completed == 'Completed Creative Ideation'){
                lstCompletedItems = 'Completed_Briefing' + ',Completed Strategy_Planning'+',Completed_Creative_Ideation';
            } 
            if(Completed == 'Completed Creative Execution'){
                lstCompletedItems = 'Completed_Briefing' + ',Completed_Strategy_Planning'+',Completed_Creative_Ideation'+',Completed_Creative_Execution';
            }
            if(Completed == 'Completed Production'){
                lstCompletedItems = 'Completed_Briefing' + ',Completed_Strategy_Planning'+',Completed_Creative_Ideation'+',Completed_Creative_Execution'+',Completed_Production';
            } 
            system.debug('###lst Stage :'+lstCompletedItems +','+lstProjectedItems); 
            if(lstProjectedItems != '' && lstCompletedItems != ''){
                return (lstCompletedItems +','+lstProjectedItems) ;  
            }
            else if(lstProjectedItems == ''){
                return lstCompletedItems ;  
            }
            else if(lstCompletedItems != ''){
                return lstProjectedItems ;  
            }else{
                return '';  
             }                     
        }
        public class assetWrapper {
        
            public Oblix_Project_Assets__c assetWrapp {get;set;}
            public string keyAsset {get;set;}
            public decimal quantity {get;set;}
            
            public assetWrapper (){
                assetWrapp = new Oblix_Project_Assets__c();
                keyAsset = '';
                quantity = 0;
            }
        
        }
      
    }