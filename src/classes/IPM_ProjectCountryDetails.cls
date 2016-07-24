/****************************************************************************
@Description : To Update project details
@Created Date: July 2015
@Author: Cognizant
@Referenced: IPM_CountryHandler
****************************************************************************/
public with sharing class IPM_ProjectCountryDetails{
    
    @TestVisible Boolean isGlobalDeveloped = false; 
    Boolean isRegionalDeveloped = false;
    Boolean isLocalDeveloped = false;
    
    private static final string PROJECT_RESOURCE_GUEST = 'Guest';
    private static final String PROJECT_TYPE_ORIGINAL = 'Original';
    private static final String ROLLOUT_SPAN_REGIONAL = 'Regional';
    private static final String PROJECT_MEMBER_FILTER_RD_USERS = 'RnDUsers';
    private static final String PROJECT_MEMBER_FILTER_ALL_USERS = 'All';
    private static final String COUNTRY_FIELD_COUNTRY_CODE ='Country_Code__c';
    public static boolean isDevelopedPresent = false;
    public static boolean isDevelopingPresent = false;
    public static Map<Id, Boolean> isDevelopedPresentMap = new Map<Id, Boolean>();
    public static Map<Id, Boolean> isDevelopingPresentMap = new Map<Id, Boolean>();
    public static Boolean SKIP_TRIGGER_EXECUTION = false;
    public static Boolean checkAtLeastOneAssmntPerEICountryVar = false;
    
    /****************************************************************************
    @Description : Rollouts - Update the MarketType field of project from Countries
    @Params insertedCountries:  The list of countries upserted or deleted through trigger  
    @Params isDelete:   To distinguish if the operation is delete from trigger      
    *****************************************************************************/
    
    public static void updateProjectMarketType(List<IPM_Country__c> triggeredCountries, boolean isDelete){
        List<IPM_Project__c> lstUpdateProjects = new List<IPM_Project__c>();
        Set<Id> setCountryProjectIds = new Set<Id>();
        Set<Id> setCountryRegionalProjectIds = new Set<Id>();
        Set<Id> setCountryLocalProjectIds = new Set<Id>();
        Map<Id, Boolean> mapProjIsDeveloped = new Map<Id, Boolean>();
        
        //Get project Ids of the deleting countries
        for(IPM_Country__c country: triggeredCountries){
            if(country.IPM_Project__c != Null){ 
                setCountryProjectIds.add(country.IPM_Project__c);
            }
            if(country.IPM_Regional_Project__c != Null){  
                setCountryRegionalProjectIds.add(country.IPM_Regional_Project__c);
            }
            if(country.IPM_Local_Project__c != Null){ 
                setCountryLocalProjectIds.add(country.IPM_Local_Project__c);
            }
        }
            
        List<IPM_Project__c> lstProjects = new List<IPM_Project__c>();
        
        //GLOBAL
        if(!setCountryProjectIds.isEmpty()){
           mapProjIsDeveloped = IPM_ProjectCountryDetails.processProjects(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL, isDelete, setCountryProjectIds, triggeredCountries);
        }    
        //REGIONAL
        if(!setCountryRegionalProjectIds.isEmpty()){
           mapProjIsDeveloped = IPM_ProjectCountryDetails.processProjects(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL, isDelete, setCountryRegionalProjectIds, triggeredCountries);                               
        }    
        //LOCAL
        if(!setCountryLocalProjectIds.isEmpty()){
           mapProjIsDeveloped = IPM_ProjectCountryDetails.processProjects(IPM_ConstantUtils.PROJECT_SPAN_LOCAL, isDelete, setCountryLocalProjectIds, triggeredCountries);
        }
        
        Set<Id> projIds = new Set<Id>();
        if(!mapProjIsDeveloped.isEmpty()){
            projIds.addAll(mapProjIsDeveloped.keySet());  
            lstProjects = [Select Id, IPM_Market_Type__c FROM IPM_Project__c WHERE id IN: projIds LIMIT 50000];
            
            if(!lstProjects.isEmpty()){
                for(IPM_Project__c proj: lstProjects ){
                    //REQ02192 changes--start
                    if(mapProjIsDeveloped.get(proj.Id)){//isDeveloped Calculated for the project is true
                        // if Delete-- make it Developing n emerging
                        if(isDelete){
                            if(isDevelopedPresentMap.isEmpty() && IsDevelopingPresentMap.isEmpty()){//Deleting last country
                                proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPED;
                                lstUpdateProjects.add(proj);
                            }
                            else if(!isDevelopedPresentMap.get(proj.Id) && IsDevelopingPresentMap.get(proj.Id)){
                                proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPING;
                                lstUpdateProjects.add(proj);
                            } 
                        }
                        //Add-- if it is not Deleloped then make it developed
                        else if(!isDelete && proj.IPM_Market_Type__c != IPM_ConstantUtils.MARKETTYPE_DEVELOPED){
                            proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPED;
                            lstUpdateProjects.add(proj);
                        }
                    }
                    else{
                        // if Delete-- make it Developing n emerging
                        if(isDelete){
                            if(isDevelopedPresentMap.isEmpty() && IsDevelopingPresentMap.isEmpty()){//deleting last country
                                proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPED;
                                lstUpdateProjects.add(proj);
                            }
                            else if(!isDevelopedPresentMap.get(proj.Id) && !IsDevelopingPresentMap.get(proj.Id)){
                                proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPED;
                                lstUpdateProjects.add(proj);
                            }
                            else if(!IsDevelopingPresentMap.get(proj.Id)){
                                proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPING;
                                lstUpdateProjects.add(proj);
                            }
                        }
                        //Add-- if it is not Delevoping then make it Delevoping
                        else if(!isDelete && proj.IPM_Market_Type__c != IPM_ConstantUtils.MARKETTYPE_DEVELOPING){
                            proj.IPM_Market_Type__c = IPM_ConstantUtils.MARKETTYPE_DEVELOPING;
                            lstUpdateProjects.add(proj);
                        }
                    }//REQ02192 changes--end
                }
            }
        }
        
        if(!lstUpdateProjects.isEMpty()){
            Update lstUpdateProjects;
        }
                 
    }
    
    /****************************************************************************
    @Description : Rollouts - Calculate the MarketType value for each project in the Countries
    @Params projectSpan:  Span of the country project  
    @Params isDelete:   To distinguish if the operation is delete from trigger  
    @Params setCountryProjectIds:   Set of project Ids of the country
    @Params triggeredCountries:   List of countries passed from the trigger to process
    *****************************************************************************/
   
    public static Map<Id, Boolean> processProjects(String projectSpan, Boolean isDelete, Set<Id> setCountryProjectIds, List<IPM_Country__c> triggeredCountries){
        Map<Id, Boolean> mapProjIsDeveloped = new Map<Id, Boolean>();
        if(!setCountryProjectIds.isEmpty()){
            
            List<IPM_Project__c> lstCountryProjects = new List<IPM_Project__c>();
            //Get the projects of all the deleting countries
            lstCountryProjects = [SELECT Id, Name, IPM_Market_Type__c FROM IPM_Project__c WHERE Id IN: setCountryProjectIds LIMIT 50000];    
            
            //DEF1267 changes
            List<IPM_Country__c> lstCountries = new List<IPM_Country__c>();
            if(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL.equalsIgnoreCase(projectSpan)){                
                lstCountries = [SELECT Id, Name, IPM_Project__c, MDO_Geography__c FROM IPM_Country__c WHERE IPM_Project__c IN: setCountryProjectIds LIMIT 50000 ];
            }else if(IPM_ConstantUtils.PROJECT_SPAN_REGIONAL.equalsIgnoreCase(projectSpan)){
                lstCountries = [SELECT Id, Name, IPM_Project__c, MDO_Geography__c FROM IPM_Country__c WHERE IPM_Regional_Project__c IN: setCountryProjectIds LIMIT 50000 ];
            }else if(IPM_ConstantUtils.PROJECT_SPAN_LOCAL.equalsIgnoreCase(projectSpan)){
                lstCountries = [SELECT Id, Name, IPM_Project__c, MDO_Geography__c FROM IPM_Country__c WHERE IPM_Local_Project__c IN: setCountryProjectIds LIMIT 50000 ];
            }
            
            Set<Id> lstCountryGeoIdsofTriggeredCountries = new Set<Id>();
            Set<Id> lstCountryGeoIdsofOtherCountries = new Set<Id>();
            Map<Id, IPM_Country__c> countriesIdsMap = new Map<Id, IPM_Country__c>(); 
            Map<Id, IPM_Country__c> triggeredCountriesIdsMap = new Map<Id, IPM_Country__c>(); 
            List<IPM_Country__c> lstResultofTriggeredCountries = new List<IPM_Country__c>();
            List<IPM_Country__c> lstResultofOtherCountries = new List<IPM_Country__c>();
            //REQ02192 changes---start
            if(isDelete){
                //Remove list of triggered countries from the globalcountries list                                                  
                for(IPM_Country__c country: lstCountries){
                    countriesIdsMap.put(country.Id, country);
                    for(IPM_Country__c trigCountry : triggeredCountries){  
                        if(trigCountry.Id == country.Id){
                            lstCountryGeoIdsofTriggeredCountries.add(country.MDO_Geography__c);
                            lstResultofTriggeredCountries.add(country);
                            triggeredCountriesIdsMap.put(trigCountry.Id, trigCountry);
                        }
                    }  
                }
            }
            else{
                Set<Id> lstUpsertCountryGeoIds = new Set<Id>();
                List<IPM_Country__c> lstUpsertCountries = new List<IPM_Country__c>();
                lstCountries.addAll(triggeredCountries);
                for(IPM_Country__c country: lstCountries){
                    if(country.MDO_Geography__c != Null){
                        lstUpsertCountryGeoIds.add(country.MDO_Geography__c);
                        lstUpsertCountries.add(country);
                    }  
                }
                lstCountryGeoIdsofTriggeredCountries = lstUpsertCountryGeoIds;
                lstResultofTriggeredCountries = lstUpsertCountries;
            }                                        
            
            Set<Id> sameCountriesIds = new Set<Id>();
            if(triggeredCountriesIdsMap != null && !triggeredCountriesIdsMap.isEmpty()){
                for(Id tempId : triggeredCountriesIdsMap.keyset()){
                    if(countriesIdsMap.containsKey(tempId)){
                        sameCountriesIds.add(tempId);
                    }
                }
            }
            
            //check if both map same 
            if(!countriesIdsMap.equals(triggeredCountriesIdsMap)){
                if(sameCountriesIds != null && !sameCountriesIds.isEmpty()){
                    for(Id tempId : sameCountriesIds){
                        countriesIdsMap.remove(tempId);
                    }
                }
                
                if(countriesIdsMap != null && !countriesIdsMap.isEmpty()){
                    for(Id tempId : countriesIdsMap.keyset()){
                        lstCountryGeoIdsofOtherCountries.add(countriesIdsMap.get(tempId).MDO_Geography__c);
                        lstResultofOtherCountries.add(countriesIdsMap.get(tempId));
                    }
                }
            }
            
            List<MDO_Market__c> marketListofTriggeredCountries = new List<MDO_Market__c>(); 
            List<MDO_Market__c> marketListofOtherCountries = new List<MDO_Market__c>(); 
            
            
            marketListofTriggeredCountries = getMarketList(lstCountryGeoIdsofTriggeredCountries);
            if(marketListofTriggeredCountries != null && !marketListofTriggeredCountries.isEmpty()){
                for(IPM_Project__c proj: lstCountryProjects){
                  //Get all the countries under the Global project
                    mapProjIsDeveloped.put(proj.Id, false);
                    for(MDO_Market__c tempMarket: marketListofTriggeredCountries){
                        //Check if there is no other country with Geography Market Type 'Developed' under the project
                        if(IPM_ConstantUtils.MARKETTYPE_DEVELOPED.equalsIgnoreCase(tempMarket.Type__c)){
                            //exit once true
                            mapProjIsDeveloped.put(proj.Id, true);   
                        }                                           
                    }
                }
            }
            
            marketListofOtherCountries = getMarketList(lstCountryGeoIdsofOtherCountries);
            if(marketListofOtherCountries != null && !marketListofOtherCountries.isEmpty()){
                for(IPM_Project__c proj: lstCountryProjects){
                    IsDevelopedPresentMap.put(proj.Id, false);
                    IsDevelopingPresentMap.put(proj.Id, false);    
                    for(MDO_Market__c tempMarket: marketListofOtherCountries){
                        //Check if there is no other country with Geography Market Type 'Developed' under the project
                        if(IPM_ConstantUtils.MARKETTYPE_DEVELOPED.equalsIgnoreCase(tempMarket.Type__c)){
                            IsDevelopedPresentMap.put(proj.Id, true);  
                        }                    
                        if(system.Label.IPM_Emerging.equalsIgnoreCase(tempMarket.Type__c)){
                            IsDevelopingPresentMap.put(proj.Id, true);  
                        }
                    }
                }
            }
        }//REQ02192 changes--end
        return mapProjIsDeveloped;
    }
    
    
    private static List<MDO_Market__c> getMarketList(Set<Id> lstCountryGeoIds){
        Set<Id> marketIds = new Set<Id>();
        List<MDO_Market__c> marketList = new List<MDO_Market__c>();
        List<MDO_MarketGeographys__c> lstCountryGeos = new List<MDO_MarketGeographys__c>();
        lstCountryGeos = [Select Geography_ID__c, Market_ID__c from MDO_MarketGeographys__c WHERE Geography_ID__c IN: lstCountryGeoIds LIMIT 50000];
        if(lstCountryGeos != null && !lstCountryGeos.isEmpty()){
            for(MDO_MarketGeographys__c temp : lstCountryGeos){
                marketIds.add(temp.Market_ID__c);
            }
        }
        
        if(marketIds != null && !marketIds.isEmpty()){
            marketList = [Select type__c from MDO_Market__c where id in : marketIds LIMIT 50000];
        }
        return marketList;
    }
   
    /****************************************************************************
    @Description : Set Sync status on projects. Sync status distinguishes which projects should be synced to EcoDesign
    When countries get updated with lookup value of either Global/Regional/Local Projects
    only then the corresponding projects will be synced to EcoDesign
    @Params OldCountryValuesMap:  Map of Trigger.Old passed from trigger  
    @Params triggeredCountries:   List of Trigger.new countries passed from the trigger to process
    *****************************************************************************/
    
    public static void setSyncProjAftUpdate( Map<Id, IPM_Country__c> OldCountryValuesMap, List<IPM_Country__c> triggeredCountries){
        
        //Regional/Local Project Ids will be populated on countries only when the country record is updated.
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();//List containing all Projects which needs to be updated with sync flags
        Set<Id> globalProjectIds = new Set<Id>();
        Set<Id> regionalOrLocalProjectIds = new Set<Id>();
        Set<Id> allProjectIds = new Set<Id>(); //Set containg all the filtered project Ids
        Map<Id,String> projCountryCodesMap =  new Map<Id,String>(); //Map of Project id and semicolon seperated country codes
        Map<Id,List<IPM_Project_Resource__c>> projMembersMap =  new Map<Id,List<IPM_Project_Resource__c>>(); //Map of Project Id and semicolon seperated Project Members
        Map<Id,Boolean> projectIdToSyncMap =  new Map<Id,Boolean>(); //Map of Project Id and Boolean(Whetehr the project is to be synced or not)
        
        //Fetch set of Global/Regional/Local project Ids populated in the IPM_country__c records
        for(IPM_Country__c c: triggeredCountries){
            
            If(c.IPM_Project__c != null && String.isNotBlank(String.valueOf(c.IPM_Project__c)) && OldCountryValuesMap.get(c.id) != null && OldCountryValuesMap.get(c.id).IPM_Project__c != c.IPM_Project__c){
                globalProjectIds.add(c.IPM_Project__c);
                
                //to sync the old project as well
                if(OldCountryValuesMap.get(c.id) != null && OldCountryValuesMap.get(c.id).IPM_Project__c!= null){
                    globalProjectIds.add(OldCountryValuesMap.get(c.id).IPM_Project__c);
                }
            }
            
            If(c.IPM_Regional_Project__c != null && String.isNotBlank(String.valueOf(c.IPM_Regional_Project__c)) && OldCountryValuesMap.get(c.id) != null &&  OldCountryValuesMap.get(c.id).IPM_Regional_Project__c != c.IPM_Regional_Project__c ){
                regionalOrLocalProjectIds.add(c.IPM_Regional_Project__c);
                
                //to sync the old project as well
                if(OldCountryValuesMap.get(c.id)!=null && OldCountryValuesMap.get(c.id).IPM_Regional_Project__c!= null){
                    regionalOrLocalProjectIds.add(OldCountryValuesMap.get(c.id).IPM_Regional_Project__c);
                }
            }
            
            If(c.IPM_Local_Project__c != null && String.isNotBlank(String.valueOf(c.IPM_Local_Project__c)) && OldCountryValuesMap.get(c.id) != null && OldCountryValuesMap.get(c.id).IPM_Local_Project__c != c.IPM_Local_Project__c){
                regionalOrLocalProjectIds.add(c.IPM_Local_Project__c);
                
                //to sync the old project as well
                if(OldCountryValuesMap.get(c.id) != null && OldCountryValuesMap.get(c.id).IPM_Local_Project__c!= null){
                    regionalOrLocalProjectIds.add(OldCountryValuesMap.get(c.id).IPM_Local_Project__c);
                }
            }
            
        }
        
        
        //Collect all the project IDs in a single set
        allProjectIds.addAll(globalProjectIds);
        allProjectIds.addAll(regionalOrLocalProjectIds);
        
        if(allProjectIds != null && !allProjectIds.isEmpty()){ // required
            //fetch the maps
            Map<Id,List<IPM_Country__c>> projIdCountryListMap = getProjectIdCountryListMap(allProjectIds);
            projCountryCodesMap = getProjectIdCountriesMap(projIdCountryListMap,COUNTRY_FIELD_COUNTRY_CODE);
            projMembersMap = getProjectIdMembersListMap(allProjectIds, PROJECT_MEMBER_FILTER_ALL_USERS);
            projectIdToSyncMap = getProjectIdToSyncMap(allProjectIds);
            
            
            
            //List of global projects to be updated (if any) with sync flag and first sync flag
            //Global project lookup on the country won't be updated in normal scenario
            if(globalProjectIds!=null && !globalProjectIds.isEmpty()){
                for(String gpId : globalProjectIds ){
                    if(projectIdToSyncMap.get(gpId) && projCountryCodesMap!=null && !projCountryCodesMap.isEmpty() && projCountryCodesMap.get(gpId) != null){
                        if(projMembersMap != null && !projMembersMap.isEmpty()  && projMembersMap.get(gpId)!= null && !projMembersMap.get(gpId).isEmpty()){
                            toUpdateProjList.add( new IPM_Project__c(Id = gpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(gpId), Project_Members__c = getProjectMembersNames(projMembersMap.get(gpId)) ));
                        }
                        else{
                            toUpdateProjList.add( new IPM_Project__c(Id = gpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(gpId) ));
                        }
                        
                    }
                    
                }
            }
            
            //List of regional projects to be updated with sync flag
            if(regionalOrLocalProjectIds!=null && !regionalOrLocalProjectIds.isEmpty()){
                for(String rlpId : regionalOrLocalProjectIds ){
                    if(projectIdToSyncMap.get(rlpId) && projCountryCodesMap!=null && !projCountryCodesMap.isEmpty() && projCountryCodesMap.get(rlpId) != null ){
                        if(projMembersMap!=null && !projMembersMap.isEmpty()  && projMembersMap.get(rlpId) != null && !projMembersMap.get(rlpId).isEmpty()){
                            toUpdateProjList.add( new IPM_Project__c(Id = rlpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(rlpId), Project_Members__c = getProjectMembersNames(projMembersMap.get(rlpId)) ));
                        }
                        else{
                            toUpdateProjList.add( new IPM_Project__c(Id = rlpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(rlpId) ));
                        }
                        
                    }
                    
                }
            }
            
            //Update The List
            if(toUpdateProjList!=null && !toUpdateProjList.isEmpty()){
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                update toUpdateProjList;
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
            }
        }
    }
    
    
    /****************************************************************************
    @Description : Set Sync Project status as ready on a project
    Sync status distinguishes which projects/Countries should be synced to EcoDesign 
    @Params triggeredCountries:   List of Trigger.new countries passed from the trigger to process
    *****************************************************************************/
    public static void setSyncProjAftInsert(List<IPM_Country__c> triggeredCountries){
        //Global Project Id will be populated only on after insert of country records.
        
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();//List containing all Projects which needs to be updated with sync flags
        Set<Id> globalProjectIds = new Set<Id>();
        Set<Id> regionalOrLocalProjectIds = new Set<Id>();
        
        Set<Id> allProjectIds = new Set<Id>(); //Set containg all the filtered project Ids
        Map<Id,String> projCountryCodesMap =  new Map<Id,String>(); //Map of Project id and semicolon seperated country codes
        Map<Id,List<IPM_Project_Resource__c>> projMembersMap =  new Map<Id,List<IPM_Project_Resource__c>>(); //Map of Project Id and semicolon seperated Project Members
        Map<Id,Boolean> projectIdToSyncMap =  new Map<Id,Boolean>(); //Map of Project Id and Boolean(Whetehr the project is to be synced or not)
        
        //Fetch set of Global project Ids populated in the IPM_country__c records
        if(triggeredCountries != null){
            for(IPM_Country__c c: triggeredCountries){
            
                If(c.IPM_Project__c != null && String.isNotBlank(String.valueOf(c.IPM_Project__c))){
                    globalProjectIds.add(c.IPM_Project__c);
                }
                
                If(c.IPM_Regional_Project__c != null && String.isNotBlank(String.valueOf(c.IPM_Regional_Project__c))){
                    regionalOrLocalProjectIds.add(c.IPM_Regional_Project__c);
                }
                
                If(c.IPM_Local_Project__c != null && String.isNotBlank(String.valueOf(c.IPM_Local_Project__c))){
                    regionalOrLocalProjectIds.add(c.IPM_Local_Project__c);
                }
            }
        }
        
        
        
        //Collect all the project IDs in a single set
        allProjectIds.addAll(globalProjectIds);
        allProjectIds.addAll(regionalOrLocalProjectIds);
        
        if(allProjectIds != null && !allProjectIds.isEmpty()){
            
            //fetch the maps
            Map<Id,List<IPM_Country__c>> projIdCountryListMap = getProjectIdCountryListMap(allProjectIds);
            projCountryCodesMap = getProjectIdCountriesMap(projIdCountryListMap, COUNTRY_FIELD_COUNTRY_CODE);
            projMembersMap = getProjectIdMembersListMap(allProjectIds, PROJECT_MEMBER_FILTER_ALL_USERS);
            projectIdToSyncMap = getProjectIdToSyncMap(allProjectIds);
            
            //List of regional projects to be updated with sync flag and first sync flag
            if(!globalProjectIds.isEmpty()){
                for(String gpId : globalProjectIds ){
                    if(projectIdToSyncMap.get(gpId) && projCountryCodesMap != null && String.isNotBlank(projCountryCodesMap.get(gpId))){
                        if(projMembersMap != NULL && !projMembersMap.isEmpty()){
                            toUpdateProjList.add( new IPM_Project__c(Id = gpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(gpId), Project_Members__c = getProjectMembersNames(projMembersMap.get(gpId)) ));
                        }
                        else{
                            toUpdateProjList.add( new IPM_Project__c(Id = gpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(gpId) ));
                        }
                    }                    
                }
            }
            
            //List of regional projects to be updated with sync flag
            if(!regionalOrLocalProjectIds.isEmpty()){
                for(String rlpId : regionalOrLocalProjectIds ){
                    if(projectIdToSyncMap.get(rlpId) && projCountryCodesMap != null && !projCountryCodesMap.isEmpty() && projCountryCodesMap.get(rlpId)!=null){
                        if(projMembersMap != NULL && !projMembersMap.isEMpty()){
                            toUpdateProjList.add( new IPM_Project__c(Id = rlpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(rlpId), Project_Members__c = getProjectMembersNames(projMembersMap.get(rlpId))  ));
                        }
                        else{
                            toUpdateProjList.add( new IPM_Project__c(Id = rlpId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(rlpId)  ));
                        }
                    }                    
                }
            }

            
            //Update The List
            if(!toUpdateProjList.isEmpty()){
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
                update toUpdateProjList;
                IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;                
            }
        }        
    }
    
    /****************************************************************************
    @Description : Set Sync project status as ready on Projects after countries are deleted
    @Params triggeredCountries:   List of Trigger.new countries passed from the trigger to process
    *****************************************************************************/
    public static void setSyncProjectAftDelete(List<IPM_country__c> deletedCountries){
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();//List containing all Projects which needs to be updated with sync flags
        Set<Id> projIdSet = new Set<Id>();
        Map<Id,String> projCountryCodesMap =  new Map<Id,String>(); //Map of Project id and semicolon seperated country codes
        Map<Id,Boolean> projectIdToSyncMap =  new Map<Id,Boolean>(); //Map of Project Id and Boolean(Whetehr the project is to be synced or not)
        
        //find the project Is of the deleted countries
        for(IPM_country__c deletedCountry : deletedCountries ){
            If(deletedCountry.IPM_Project__c != null && String.isNotBlank(String.valueOf(deletedCountry.IPM_Project__c))){
                projIdSet.add(deletedCountry.IPM_Project__c);
            }
            
            If(deletedCountry.IPM_Regional_Project__c != null && String.isNotBlank(String.valueOf(deletedCountry.IPM_Regional_Project__c))){
                projIdSet.add(deletedCountry.IPM_Regional_Project__c);
            }
            
            If(deletedCountry.IPM_Local_Project__c != null && String.isNotBlank(String.valueOf(deletedCountry.IPM_Local_Project__c))){
                projIdSet.add(deletedCountry.IPM_Local_Project__c);
            }
        }
        
        //fetch the maps
        Map<Id,List<IPM_Country__c>> projIdCountryListMap = getProjectIdCountryListMap(projIdSet);
        projCountryCodesMap = getProjectIdCountriesMap(projIdCountryListMap,COUNTRY_FIELD_COUNTRY_CODE);
        projectIdToSyncMap = getProjectIdToSyncMap(projIdSet);
        
        if(projIdSet!=null && !projIdSet.isEmpty()){
            for(String projId : projIdSet){
                if(projectIdToSyncMap.get(projId)){
                    
                    if(projCountryCodesMap != null && !projCountryCodesMap.isEmpty() && projCountryCodesMap.get(projId) != null){
                        toUpdateProjList.add( new IPM_Project__c(Id = projId, EcoDesign_Sync_Status__c = IPM_ConstantUtils.ECODESIGN_SYNC_STATUS_READY, Project_Countries__c =  projCountryCodesMap.get(projId)));
                    }
                    
                }
                
            }
        }
        
        //update the projects
        if(!toUpdateProjList.isEmpty()){
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            update toUpdateProjList;
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
        } 
        
    }
    
    /****************************************************************************
    @Description : post a feed Item for the project with @mention when a country is added or removed from the rollout
    @Params affectedCountries:  Trigger.old(In case of Trigger.isDelete) or Trigger.new(In case of Trigger.isInsert)
    @Params Operation : Operation performed (Insert/Delete)
    *****************************************************************************/
    public static void notifyLeadRnD(List<IPM_Country__c> affectedCountries, String operation) {
        Map<Id,String> projIdchatterMessageMap = new Map<Id,String>();
        Map<Id,Set<Id>> subjectIdMentionIdSetMap = new Map<Id,Set<Id>>();
        Map<Id,Set<Id>> probableSubjectIdMentionIdSetMap = new Map<Id,Set<Id>>();
        Map<String,String> projIdAffectedCountriesMap = new Map<String,String>();
        Map<Id,List<IPM_Project_Resource__c>> projectIdRnDMembersListMap =  new Map<Id,List<IPM_Project_Resource__c>>();
        //Map<Id,IPM_Project__c> projIdAffectedProjMap = new Map<Id,IPM_Project__c>();
        
        //fetch map of Affected project Id and Its project based on the countries inserted/deleted
        Map<Id,IPM_Project__c> projIdAffectedProjMap = fetchProjIdAffectedProjMap(affectedCountries);      
        
        if(projIdAffectedProjMap!= null && !projIdAffectedProjMap.isEmpty()){
            
            if(affectedCountries != null && !affectedCountries.isEmpty()){
                //fetch the Map of project Id and The Affected countries. used to prepare comma seperated list of the countries inserted/deleted for the project
                projIdAffectedCountriesMap = fetchProjIdAffectedCountriesMap(affectedCountries,projIdAffectedProjMap);
                
                //fetch map of the project Id and Its Project Resources. used to find the lead R&D Project resources
                projectIdRnDMembersListMap = getProjectIdMembersListMap(projIdAffectedProjMap.keySet(), PROJECT_MEMBER_FILTER_RD_USERS);
                
                //fetch map of the Project Id and set of Id of Lead R&D project resources
                if(projectIdRnDMembersListMap != null && !projectIdRnDMembersListMap.isEmpty()){
                    probableSubjectIdMentionIdSetMap = IPM_ChatterUtilsHelper.fetchProjIdLeadRnDMemberIdSetMap(projectIdRnDMembersListMap);
                }
            }
            
            //fetch subjectIdMentionIdSetMap from the probable ones
            for(IPM_Project__c proj : projIdAffectedProjMap.Values() ){
                if(probableSubjectIdMentionIdSetMap != null && !probableSubjectIdMentionIdSetMap.isEmpty()){
                    if((PROJECT_TYPE_ORIGINAL.equalsIgnoreCase(proj.IPM_Project_Type__c)) || ROLLOUT_SPAN_REGIONAL.equalsIgnoreCase(proj.IPMProject_Span__c) || proj.IPM_GateKeepingModel__c == 'GKM3' || proj.IPM_GateKeepingModel__c == 'GKM4'){
                        subjectIdMentionIdSetMap.put(proj.Id,probableSubjectIdMentionIdSetMap.get(proj.Id));
                    }
                }
            }
    
            //fetch map of the Project Id and the chatter message for the project to be posted
            if(projIdAffectedCountriesMap != null && !projIdAffectedCountriesMap.isEmpty()){
                projIdchatterMessageMap = IPM_ChatterUtilsHelper.getprojIdchatterMessageMap(probableSubjectIdMentionIdSetMap,projIdAffectedCountriesMap,projIdAffectedProjMap, operation);
            }
            
            //call method to post the chatter Message
            if(projIdchatterMessageMap != null && !projIdchatterMessageMap.isEmpty() ){
                IPM_ChatterUtils.postChatterFeedWithMention(projIdAffectedProjMap.keySet(), projIdchatterMessageMap, subjectIdMentionIdSetMap );
            }
            
        }
    }
    
    /****************************************************************************
    @Description : populate Map of country Id and its related country codes
    @Params projIdSet:   the set of IDs of the projects which need to be updated with sync flag.
    *****************************************************************************/
    public static void checkIsEICountry(List<IPM_Country__c> incomingCountries ){
        
        Set<String> EICountriesSet = new Set<String>();
        
        //fetch all country names in lowercase
        List<IPM_USLP_Country__c> uslpCountries = [Select Name From IPM_USLP_Country__c LIMIT 50000];
        for(IPM_USLP_Country__c country :uslpCountries){
            EICountriesSet.add(country.Name.toLowerCase());
        }

        if(EICountriesSet != null && !EICountriesSet.isEmpty()){
            for(IPM_Country__c incomingCountry : incomingCountries){
                //Check if the incoming country Name is present in the Masterdata custom object (IPM_USLP_Country__c)
                if(EICountriesSet != null && !EICountriesSet.isEmpty() && String.isNotBlank(String.valueOf(incomingCountry.Country_Name__c)) && EICountriesSet.contains(incomingCountry.Country_Name__c.toLowerCase())){
                    incomingCountry.IS_EI_Country__c = TRUE;
                }
            }
        }
        
    }
    
    
    /****************************************************************************
    @Description : check if the Projects have at least one assessment for them
    @Params projIdSet:   the set of IDs of the projects which need to be updated with IPM_Exists_AtLeast_OneAssmntPerEICountry__c flag.
                @Update: As per new requirement for Release 2.0- Now this method will not enforce Assessment validation only for EI Countries.
                                                All Countries' Assessment will be considered irrespective of whether they are EI or non-EI.
    *****************************************************************************/
    
    public static void checkAtLeastOneAssmntPerEICountry(Set<Id> projIdSet ){       
        List<IPM_Project__c> projList  = [Select Id,IPM_Phase__c, IPM_Exists_AtLeast_OneAssmntPerEICountry__c, (Select Id, Name,IPM_Country__c,IPM_Country__r.IS_EI_Country__c,IPM_Country__r.Country_Name__c,Project_Phase__c from IPM_Assessments__r Where IPM_Country__c != null ) from IPM_Project__c Where Id IN:projIdSet LIMIT 50000];
        List<IPM_Project__c> toUpdateProjList = new List<IPM_Project__c>();    
        
        //find all Projects which have an assessment for the current project phase
                                if(projList != null && !projList.isEmpty()){
            for(IPM_Project__c proj : projList){
                if(proj.IPM_Assessments__r != null && !proj.IPM_Assessments__r.isEmpty()){
                    for(IPM_Assessment__c assmnt : proj.IPM_Assessments__r){
                        if( assmnt.IPM_Country__c != null && String.isNotBlank(proj.IPM_Phase__c) && String.isNotBlank(assmnt.Project_Phase__c) && String.valueOf(proj.IPM_Phase__c).equalsIgnoreCase(assmnt.Project_Phase__c) ){
                            toUpdateProjList.add(new IPM_Project__c( Id = proj.Id, IPM_Exists_AtLeast_OneAssmntPerEICountry__c = true ));
                        	break;
                        }
                    }
                }
            }
        }
                                
        //update the project with appropriate value of IPM_Exists_AtLeast_OneAssmntPerEICountry__c flag
        if(toUpdateProjList != null && !toUpdateProjList.isEmpty()){
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = true;
            Update toUpdateProjList;
            IPM_ProjectHelper.SKIP_TRIGGER_EXECUTION = false;
        }
        checkAtLeastOneAssmntPerEICountryVar = true;
    }
    
    /****************************************************************************
    @Description : populate Map of country Id and its related country codes
    @Params projIdSet:   the set of IDs of the projects which need to be updated with sync flag.
    *****************************************************************************/
    public static Map<Id,String> getProjectIdCountriesMap(Map<Id,List<IPM_Country__c>> projIdCountryListMap, String countryField ){
        //Map<Id,List<IPM_Country__c>> projIdCountryListMap = getProjectIdCountryListMap(projIdSet);
        Map<Id,String> projCountryValueMap = new Map<Id,String>();
        
        if(projIdCountryListMap != null && !projIdCountryListMap.isEmpty() ){
            for(Id projId : projIdCountryListMap.keySet() ){
                for(IPM_Country__c country : projIdCountryListMap.get(projId) ){
                    
                    
                    if(!projCountryValueMap.containsKey(projId)){
                        projCountryValueMap.put(projId,country.get(countryField) + IPM_ConstantUtils.SEMICOLON);
                    }
                    else{
                        projCountryValueMap.put(projId,projCountryValueMap.get(projId)+country.get(countryField) + IPM_ConstantUtils.SEMICOLON);
                    }
                }
                
            }
        }
        
                
        if(projCountryValueMap != null && !projCountryValueMap.isEmpty()){
            for(Id projId: projCountryValueMap.keySet()){
                projCountryValueMap.put(projId,projCountryValueMap.get(projId).removeEnd(IPM_ConstantUtils.SEMICOLON));
            }
            
            return projCountryValueMap;
        }
        else{
            return null;
        }
        
    }
    
    
    /****************************************************************************
    @Description : populate Map of project Id and its related countries
    @Params projIdSet:   the set of IDs of the projects which need to be updated with sync flag.
    *****************************************************************************/    
   public static Map<Id,List<IPM_Country__c>> getProjectIdCountryListMap(Set<Id> projIdSet){

        Map<Id,List<IPM_Country__c>> projCountryListMap = new Map<Id,List<IPM_Country__c>>();
       
        for(IPM_Country__c country : [select id, IPM_Project__c,IPM_Regional_Project__c, IPM_Local_Project__c,Country_Name__c,Country_Code__c from IPM_Country__c 
                                        where ( IPM_Project__c in:projIdSet or IPM_Regional_Project__c in:projIdSet OR IPM_Local_Project__c in:projIdSet ) AND isActive__c = true LIMIT 50000 ]){

            if(country.IPM_Project__c!=null && projIdSet.contains(country.IPM_Project__c)){
                if(!projCountryListMap.containsKey(country.IPM_Project__c)){
                    projCountryListMap.put(country.IPM_Project__c,new List<IPM_Country__c>{country});
                }
                else{
                    projCountryListMap.get(country.IPM_Project__c).add(country);
                }
            }
            
            if(country.IPM_Regional_Project__c!=null  && projIdSet.contains(country.IPM_Regional_Project__c) ){
                if(!projCountryListMap.containsKey(country.IPM_Regional_Project__c)){
                    projCountryListMap.put(country.IPM_Regional_Project__c,new List<IPM_Country__c>{country});
                }
                else{
                    projCountryListMap.get(country.IPM_Regional_Project__c).add(country);
                }
            }
            
            if(country.IPM_Local_Project__c!=null  && projIdSet.contains(country.IPM_Local_Project__c)){
                if(!projCountryListMap.containsKey(country.IPM_Local_Project__c)){
                    projCountryListMap.put(country.IPM_Local_Project__c,new List<IPM_Country__c>{country});
                }
                else{
                    projCountryListMap.get(country.IPM_Local_Project__c).add(country);
                }
            }
            
                
        }
        if(projCountryListMap != null && !projCountryListMap.isEmpty()){
             return projCountryListMap;
        }
        else{
            return null;
        }
  
    }
    
    
    /****************************************************************************
    @Description : populate Map of country Id and its related Project Resources
    @Params projIdSet:   the set of IDs of the projects which need to be updated with sync flag.
    *****************************************************************************/
    public static Map<Id,List<IPM_Project_Resource__c>> getProjectIdMembersListMap(Set<Id> projIdSet, String filter){
        List<IPM_Project__c> projList = new List<IPM_Project__c>();
        if(filter.equalsIgnoreCase(PROJECT_MEMBER_FILTER_ALL_USERS)){
            projList = [Select Id, (Select Id,IPM_User__r.Name,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resources__r Limit 50000) from IPM_Project__c Where Id IN :projIdSet LIMIT 50000];
        }
        
        else if(filter.equalsIgnoreCase(PROJECT_MEMBER_FILTER_RD_USERS)){
            projList = [Select Id, (Select Id,IPM_User__r.Name,IPM_Project_Role_Owner__c,IPM_Role_Type__c from IPM_Project_Resources__r WHERE (IPM_Role_Type__c = 'R&D') limit 50000) from IPM_Project__c Where Id IN :projIdSet LIMIT 50000];
        }
        
        //String memberList = '';
        Map<Id,List<IPM_Project_Resource__c>> projMembersListMap = new Map<Id,List<IPM_Project_Resource__c>>();
        List<IPM_Project_Resource__c> membersList = new List<IPM_Project_Resource__c>();
        if(projList != null && !projList.isEmpty()){
            for(IPM_Project__c proj : projList){
                if(proj.IPM_Project_Resources__r != null && !proj.IPM_Project_Resources__r.isEmpty()){
                    for(IPM_Project_Resource__c member : proj.IPM_Project_Resources__r){
                        membersList.add(member);
                    }
                }
                if(membersList!=null && !membersList.isEmpty()){
                    projMembersListMap.put(proj.id,membersList);
                }
            }
            if(projMembersListMap != null && !projMembersListMap.isEmpty()){
                return projMembersListMap;
            }
            else{
                return null;
            }
        }
        else{
            return null;
        }
        
    }
    
    
    /****************************************************************************
    @Description : populate Map of country Id and its related Project Resources Name (Comma Seperated)
    @Params projIdSet:   the set of IDs of the projects which need to be updated with sync flag.
    *****************************************************************************/
    public static String getProjectMembersNames(List<IPM_Project_Resource__c> projResources){
        String memberList = IPM_ConstantUtils.BLANK;
        if(projResources!= null){
            for(IPM_Project_Resource__c member : projResources){
                if(!PROJECT_RESOURCE_GUEST.equalsIgnoreCase(member.IPM_Role_Type__c) ){
                    memberList = memberList + member.IPM_User__r.Name + IPM_ConstantUtils.SEMICOLON;
                }
                
            }
            if(memberList!=null && memberList!=''){
                memberList = memberList.removeEnd(IPM_ConstantUtils.SEMICOLON);
            }
            return memberList;
        }
        else
            return IPM_ConstantUtils.BLANK;
        
        
    }
    
    
    
    /****************************************************************************
    @Description : Check whether the project is eligible to be synced to EcoDesign. (TRUE =Yes & FALSE=No) 
    @Params ProjectToEvaluate:   the project record which needs to be checked for sync eligibility
    *****************************************************************************/
    public static Boolean isProjectReadyToSyncToEcoDesign(IPM_Project__c projectToEvaluate) {
        //Check the sync flag according to criteria specified in Custom Setting 'IPM Project Type'
        if((IPM_Utils.retrieveProjectType(projectToEvaluate) == null || !IPM_Utils.retrieveProjectType(projectToEvaluate).IPM_Dont_Sync_Proj_To_EcoDesign__c) && projectToEvaluate.IPM_ProjectSubType__c != IPM_ConstantUtils.IPM_BLG && projectToEvaluate.IPM_Project_Type__c != IPM_ConstantUtils.ECODESIGN_PROJECT_TYPE_OPERATIONAL){
            return TRUE;
        }
        else{
            return FALSE;
        }
    }
    
    /****************************************************************************
    @Description : Returns map of the project Id and Its Sync eligibility
    @Params ProjectsToEvaluate:  Set Of Project Ids
    *****************************************************************************/
    public static Map<Id,Boolean> getProjectIdToSyncMap(Set<Id> projectsToEvaluate) {
        Map<Id,IPM_Project__c> projIdProjectMap =new Map<Id,IPM_Project__c> ([Select Id,IPM_Project_Type__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,IPM_ProjectSubType__c, IPM_Answer_of_Q1__c, IPM_CompanyCardText__c From IPM_Project__c Where Id IN :projectsToEvaluate LIMIT 50000 ]);
        Map<Id,Boolean> projectIdToSyncMap =  new Map<Id,Boolean>(); //Map of Project Id and Boolean(Whetehr the project is to be synced or not)
        
        for(IPM_Project__c project: projIdProjectMap.values()){
            projectIdToSyncMap.put(project.Id,isProjectReadyToSyncToEcoDesign(project));
        }
        if(projectIdToSyncMap != null && !projectIdToSyncMap.isEmpty()){
            return projectIdToSyncMap;
        }
        else{
            return null;
        }
        
    }
    
    
    /****************************************************************************
    @Description : Returns map of the project Id and the countries inserted or deleted
    @Params affectedCountries:  Trigger.old(In case of Trigger.isDelete) or Trigger.new(In case of Trigger.isInsert)
    @Params projIdAffectedProjMap : Map of projectId and the Project
    *****************************************************************************/
    public static Map<String, String> fetchProjIdAffectedCountriesMap(List<IPM_Country__c> affectedCountries, Map<Id,IPM_Project__c> projIdAffectedProjMap) { 
        Map<String,String> projIdAffectedCountriesMap = new Map<String,String>();
        
        for(String projId : projIdAffectedProjMap.keySet()){
            String countriesAffected = IPM_ConstantUtils.BLANK;
            if(projIdAffectedProjMap != null && !projIdAffectedProjMap.isEmpty() ){
                for(IPM_country__c country:affectedCountries){
                    if(country.IPM_Project__c != null && projIdAffectedProjMap.get(country.IPM_Project__c) != null && projIdAffectedProjMap.get(country.IPM_Project__c).IPMProject_Span__c != null && projIdAffectedProjMap.get(country.IPM_Project__c).IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && country.IPM_Project__c == projId ){
                        countriesAffected = countriesAffected + country.Country_Name__c+IPM_ConstantUtils.SEMICOLON;
                    }
                    if(country.IPM_Regional_Project__c != null && projIdAffectedProjMap.get(country.IPM_Regional_Project__c) != null && projIdAffectedProjMap.get(country.IPM_Regional_Project__c).IPMProject_Span__c != null && projIdAffectedProjMap.get(country.IPM_Regional_Project__c).IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && country.IPM_Regional_Project__c == projId){
                        countriesAffected = countriesAffected + country.Country_Name__c+IPM_ConstantUtils.SEMICOLON;
                    }
                    if(country.IPM_Local_Project__c != null && projIdAffectedProjMap.get(country.IPM_Local_Project__c) != null && projIdAffectedProjMap.get(country.IPM_Local_Project__c).IPMProject_Span__c != null && projIdAffectedProjMap.get(country.IPM_Local_Project__c).IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && country.IPM_Local_Project__c == projId){
                        countriesAffected = countriesAffected + country.Country_Name__c+IPM_ConstantUtils.SEMICOLON;
                    }
                }
                if(countriesAffected != null && countriesAffected != ''){
                    projIdAffectedCountriesMap.put(projId,countriesAffected.removeEnd(IPM_ConstantUtils.SEMICOLON));
                }
                
            }
        }
        
        if(projIdAffectedCountriesMap != null && !projIdAffectedCountriesMap.isEmpty()){
            return projIdAffectedCountriesMap;
        }
        else{
          return null;
        }
        
        
     }
    
    
    /****************************************************************************
    @Description : Returns map of the project Id and the project affected due to inserted or deleted countries
    @Params affectedCountries:  Trigger.old(In case of Trigger.isDelete) or Trigger.new(In case of Trigger.isInsert)
    *****************************************************************************/
    public static Map<Id,IPM_Project__c> fetchProjIdAffectedProjMap(List<IPM_Country__c> affectedCountries){
        Set<String> projIdsSet = new Set<String>();
        for(IPM_Country__c country:affectedCountries){
            if(country.IPM_Project__c != null){
                projIdsSet.add(country.IPM_Project__c);
            }
            if(country.IPM_Regional_Project__c != null){
                projIdsSet.add(country.IPM_Regional_Project__c);
            }
            if(country.IPM_Local_Project__c != null){
                projIdsSet.add(country.IPM_Local_Project__c);
            }
        }
        
        
        if(projIdsSet != null && !projIdsSet.isEmpty()){
            return new Map<Id,IPM_Project__c>([Select Id,First_Sync_To_EcoDesign__c,IPM_Project_Type__c,IPM_GateKeepingModel__c,IPMProject_Span__c,IPM_Phase__c,IPM_ProjectSubType__c, IPM_Answer_of_Q1__c, IPM_Project_Name__c, IPM_Project_Leader__r.Name from IPM_Project__c where Id IN :projIdsSet LIMIT 50000]);
        }
        else{
            return null;
        }
        
     }

    /****************************************************************************
    @Description : Update countries in Financial
    @Params insertedCountries:  The list of countries upserted or deleted through trigger  
    @Params isDelete:   To distinguish if the operation is delete from trigger      
    *****************************************************************************/
    public static void updateCountriesToFinancials(List<IPM_Country__c> triggeredCountries, boolean isDelete){
        
        Set<Id> setTriggeredCountryIds =  new Set<Id>();
        for(IPM_Country__c country: triggeredCountries){
            setTriggeredCountryIds.add(country.Id);
        }
        
        List<IPM_Country__c> lstLocCountries = new List<IPM_Country__c>();
        lstLocCountries = [SELECT Id, Name, Country_Name__c, Local_Rollout__c FROM IPM_Country__c WHERE Id IN : setTriggeredCountryIds LIMIT 50000];
                
        Set<Id> setCountryRolloutIds =  new Set<Id>();
        for(IPM_Country__c country: lstLocCountries){
            setCountryRolloutIds.add(country.Local_Rollout__c);
        }
        
        List<IPM_Project_Rollout__c> lstLocalRollouts = new List<IPM_Project_Rollout__c>();
        lstLocalRollouts = [Select Id, Name, Regional_Rollout__c, (SELECT Id, Name, Country_Name__c from IPM_Countries_Local__r) from IPM_Project_Rollout__c where Id IN: setCountryRolloutIds LIMIT 50000];        
        
        
        Map<Id,List<IPM_Country__c>> locRolloutTolstCountriesMap = new Map<Id,List<IPM_Country__c>>();  
        Set<Id> setRegionalRolloutIds =  new Set<Id>();        
        for(IPM_Project_Rollout__c locRollout: lstLocalRollouts){
            List<IPM_Country__c> lstCountries = new List<IPM_Country__c>(); 
            setRegionalRolloutIds.add(locRollout.Regional_Rollout__c);
            for(IPM_Country__c country: locRollout.IPM_Countries_Local__r){
                lstCountries.add(country);
            }
            if(!locRolloutTolstCountriesMap.containsKey(locRollout.Id)){
                locRolloutTolstCountriesMap.put(locRollout.Id, lstCountries);
            }           
            
        }
        
    }
 
    /****************************************************************************
    @Description : update the country with the association timestamps for regional and local projects
    @Params incomingCountries:  The list of countries being inserted
    @Params oldCountriesMap : trigger.oldMap
    @Params TriggerEvent:   To distinguish if the operation of the trigger    
    *****************************************************************************/
    public static void setProjAssociationTimestamp(List<IPM_Country__c> incomingCountries, Map<Id,IPM_Country__c> oldCountriesMap, String TriggerEvent){
        for(IPM_Country__c country : incomingCountries){
            if(system.label.IPM_Insert.equalsIgnoreCase(TriggerEvent)){
                if(country.IPM_Regional_Project__c != null){
                    country.IPM_Regional_Proj_Association_Timestamp__c = System.Now();
                }
            }
            
            if(system.label.IPM_Update.equalsIgnoreCase(TriggerEvent)){
                if(oldCountriesMap != null && !oldCountriesMap.isEmpty()){
                    if(oldCountriesMap.get(country.id).IPM_Regional_Project__c != country.IPM_Regional_Project__c){
                        country.IPM_Regional_Proj_Association_Timestamp__c = System.Now();
                    }
                    
                    if(oldCountriesMap.get(country.id).IPM_Local_Project__c != country.IPM_Local_Project__c){
                        country.IPM_Local_Project_Association_Timestamp__c = System.Now();
                    }
    
                }
            }
        }
        
    }
    
    
    /****************************************************************************
    @Description : update the project document section status if existaAtLeastOneAssmntPerEICountry Flag is changed
    @Params incomingCountries:  The list of countries being inserted
    @Params oldCountriesMap : trigger.oldMap
    @Params TriggerEvent:   To distinguish if the operation of the trigger    
    *****************************************************************************/
    public static void setEISectionStatus(List<IPM_Project__c> projectsWithChangedExistsAtLeastOneAssmntFlag){
        List<IPM_Project_Document_Section__c> toUpdateProjDocSecList = new List<IPM_Project_Document_Section__c>();
        List<String> projectNameList =  new List<String>();
        IPM_Project_Document_Section__c latestProjDocSec;
        Map<IPM_Project__c,IPM_Project_Document_Section__c> projCurrentProjDocSecMap = new Map<IPM_Project__c,IPM_Project_Document_Section__c>();
        
        //Find list of all Names of projects for which projdoc sections are to be retrieved
        for(IPM_Project__c proj : projectsWithChangedExistsAtLeastOneAssmntFlag){
            projectNameList.add(proj.IPM_Project_Name__c);
        }
        
        //list of all project document sections
        List<IPM_Project_Document_Section__c> projDocSecList = [Select Id, IPM_Project_Name__c,IPM_Gate_Document__c,IPM_Functional_Input_Status__c,IPM_Section_Status__c, createddate from IPM_Project_Document_Section__c where IPM_Project_Name__c IN:projectNameList and IPM_Master_Section_External_Id__c = 'Environmental_Impact'];
        
        //create map of project and its current project document section
        for(IPM_Project__c proj : projectsWithChangedExistsAtLeastOneAssmntFlag){
            for(IPM_Project_Document_Section__c projDocSec : projDocSecList){
                latestProjDocSec = null;
                if(projDocSec.IPM_Project_Name__c == proj.IPM_Project_Name__c){
                    if(latestProjDocSec == null){
                        latestProjDocSec = projDocSec;
                    }
                    else if(projDocSec.Createddate > latestProjDocSec.CreatedDate){
                        latestProjDocSec = projDocSec;
                    }
                }
            }
            if(latestProjDocSec != null){
                projCurrentProjDocSecMap.put(proj,latestProjDocSec);
            }
        }
        
        //update the IPM_Section_Status__c
        for(IPM_Project__c proj : projectsWithChangedExistsAtLeastOneAssmntFlag){
            IPM_Project_Document_Section__c projDocSection = projCurrentProjDocSecMap.get(proj);
            if(projDocSection!=null) {
                if(proj.IPM_Exists_AtLeast_OneAssmntPerEICountry__c){   
                    if(projDocSection.IPM_Functional_Input_Status__c == IPM_ConstantUtils.SECTION_STATUS_FILLED){
                        toUpdateProjDocSecList.add(new IPM_Project_Document_Section__c(id=projDocSection.Id, IPM_Section_Status__c = IPM_ConstantUtils.SECTION_STATUS_FILLED));
                    }
                }
                else if(!proj.IPM_Exists_AtLeast_OneAssmntPerEICountry__c){
                    if(projDocSection.IPM_Section_Status__c == IPM_ConstantUtils.SECTION_STATUS_FILLED){
                        toUpdateProjDocSecList.add(new IPM_Project_Document_Section__c(id=projDocSection.Id, IPM_Section_Status__c = IPM_ConstantUtils.STATUS_NOT_STARTED));
                    }
                }
            }
        }
        
        if(toUpdateProjDocSecList !=null && !toUpdateProjDocSecList.isEmpty()){
            update toUpdateProjDocSecList;
        }
    
    }
    
      /*************************************************************************************************************
	  * @description:Assign Company Card to rollouts
	  */
	 public static void assignCompanyCardLocal(Map<id,IPM_Country__c> countyrMap)
	{
	  List<IPM_Country__c>countryList=new list<IPM_Country__c>();
	  countryList=[select Local_Rollout__c,Local_Rollout__r.IPM_Small_C__c,Country_Name__c from IPM_Country__c where 
					id IN:countyrMap.keyset() LIMIT 5000]; 
	  List<IPM_Company_Card__c>companyCardLst=new List<IPM_Company_Card__c>(); 
	  companyCardLst=[select Id,IPM_MCO__c,IPM_CompanyCard_Type__c,IPM_Managed_Category__c,RecordType.Name,IPM_TxtGeographical_Scope__c from IPM_Company_Card__c 
	  where RecordType.Name=:IPM_ConstantUtils.COMPANY_CARD_RECORD_TYPE_LOCAL Limit 5000];
										   
	  
	  List<IPM_Project_Rollout__c>rolloutList=new List<IPM_Project_Rollout__c>();
	  IPM_Project_Rollout__c newRollout;
	  Set<id> rolloutIdSet=new Set<id>();


		
	  for(IPM_Country__c country : countryList)
	  {
		for(IPM_Company_Card__c companyCard : companyCardLst)
		{
		  
		  
		  
		  if(companyCard.IPM_Managed_Category__c!=null && country.Local_Rollout__r.IPM_Small_C__c!=null && 
			companyCard.IPM_TxtGeographical_Scope__c!=null && country.Country_Name__c!=null && 
			companyCard.IPM_TxtGeographical_Scope__c.contains(country.Country_Name__c) && 
				   companyCard.IPM_Managed_Category__c.contains(country.Local_Rollout__r.IPM_Small_C__c) && 
				   country.Local_Rollout__c !=null)
			  
		  
		  {
			if(!rolloutIdSet.contains(country.Local_Rollout__c)){
		   
			newRollout=new IPM_Project_Rollout__c();
			
			
			newRollout.IPM_Company_Card__c=companyCard.Id; //assigning company card to rollout
			newRollout.id=country.Local_Rollout__c; 
			rolloutList.add(newRollout);
			rolloutIdSet.add(newRollout.id);
			} 
		  }
		  
		}
		
	  
	  
	 
	  
	}
	 if(!rolloutList.isEmpty()){
		 IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true; // for skipping trigger execution
							
						
	  update rolloutList;
	 
	  IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
	 }
	 }
    /**********************************************************************************************
      *@Description:Assign brand to MCO Rollout based on project brand position and rllout country
      *@Param:List of ipm country
      ***********************************************************************************************/
      public static void assignBrandToRollout(List<IPM_Country__c>countryList){
        map<string,string> brandPosMap = new map<string,string>();//map of country name and brand positioning
        map<id,set<string>> brandsMap = new map<id,set<string>>();
        for(IPM_Country__c country :countryList){
        	if(country.IPM_Brand_Position__c !=null)
        	{ 
            	brandPosMap.put(country.Country_Name__c,country.IPM_Brand_Position__c);
        	}
        } 
        //get all brand values based on country and brand positioning.
        List<MDO_BrandPositions__c>brandPosList = New list<MDO_BrandPositions__c>();
        brandPosList=[SELECT id,brand_position_id__r.Name,geo_id__r.Name,brand_id__r.Name FROM MDO_BrandPositions__c where 
                         geo_id__r.Name IN :brandPosMap.Keyset() AND brand_position_id__r.Name IN :brandPosMap.values() ORDER BY brand_id__r.Name ASC NULLS LAST
                         LIMIT 50000];
        
        for(IPM_Country__c country :countryList) 
        {
            brandsMap.put(country.Local_Rollout__c,new set<string>());
			for(MDO_BrandPositions__c  brandPos:brandPosList)
            {
                
                if(brandPos.brand_id__r.Name != null && !brandsMap.get(country.Local_Rollout__c).contains(brandPos.brand_id__r.Name) && country.Country_Name__c !=null && country.Country_Name__c.equals(brandPos.geo_id__r.Name) 
                && country.IPM_Brand_Position__c !=null && country.IPM_Brand_Position__c.equals(brandPos.brand_position_id__r.Name))
                {
                    brandsMap.get(country.Local_Rollout__c).add(brandPos.brand_id__r.Name); 
				} 
			}
           
        }
        assignBrandToRolloutSplit(countryList,brandsMap);
    }
    /**************************************************************************************************************
    @Description:split assignBrandToRollout method, assign brand value to local rollout while adding country or 
	* 			 updating country.
	@Param:list of country,map of rollout id and set of brand values
    ***************************************************************************************************************/
    public static void assignBrandToRolloutSplit(List<IPM_Country__c>countryList,map<id,set<string>> brandsMap)
    {
    	map<id,IPM_Project_Rollout__c> rolloutMap=new map<id,IPM_Project_Rollout__c>();//list of rollout which all need to update with brand value.
        IPM_Project_Rollout__c newRollout;// declaration of local rollout
    	for(IPM_Country__c country :countryList)
        {
            if(!rolloutMap.containsKey(country.Local_Rollout__c)){
				newRollout=new IPM_Project_Rollout__c();
				newRollout.id=country.Local_Rollout__c; 
				if(brandsMap.get(country.Local_Rollout__c).isEmpty())
				{
					newRollout.IPM_Brand__c = system.label.IPM_Brand_Not_Found;
				}
				else if(brandsMap.get(country.Local_Rollout__c).contains(country.IPM_Brand_Position__c))
				{
					newRollout.IPM_Brand__c = country.IPM_Brand_Position__c;	
				}
				else
				{
					for(string brands: brandsMap.get(country.Local_Rollout__c)){
						newRollout.IPM_Brand__c = brands;
						break;
					}
				}
				rolloutMap.put(newRollout.id,newRollout);
			}
		}  
        
        if(!rolloutMap.isEmpty())
		{
           IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = true; // for skipping trigger execution
           update rolloutMap.values();
           IPM_RolloutTriggerHandler.SKIP_TRIGGER_EXECUTION = false;
        }	
    
    }   
      /*************************************************************************************************************
      *@Description:Returns the selectoptions for brands available to a local project 
      *@Param:Local project 
      *************************************************************************************************************/ 
       public static Set<selectoption> getAvailableBrands(IPM_project__c localProject){ 
		
			Set<selectoption> brandOptions = new Set<selectoption>();
			
			if(!String.isBlank(localProject.IPM_LocalProject_Brand__c))
			{
				brandOptions.add(new selectoption(localProject.IPM_LocalProject_Brand__c,localProject.IPM_LocalProject_Brand__c));    
			}
	        
			Map<String,IPM_Country__c> countryMap = new Map<String,IPM_Country__c>();
			
			for(IPM_Country__c country: [SELECT IPM_Brand_Position__c,Country_Name__c,Local_Rollout__c  FROM IPM_Country__c WHERE isActive__c=true AND Local_Rollout__c=: localProject.IPM_Project_Rollout__c LIMIT 50000])
			{
				countryMap.put(country.Country_Name__c,country);  
			}
	        
			for(MDO_BrandPositions__c  brandPos:[SELECT Id,brand_position_id__r.Name,geo_id__r.Name,brand_id__r.Name FROM MDO_BrandPositions__c where 
												 brand_position_id__r.Name =: localProject.IPM_Brand_Positioning__c AND geo_id__r.Name IN :countryMap.keyset() ORDER BY brand_id__r.Name ASC LIMIT 50000])
			{
				if(!String.isBlank(brandPos.brand_id__r.Name)&& brandPos.brand_id__r.Name!=localProject.IPM_LocalProject_Brand__c)
				{
					IPM_Country__c country = countryMap.get(brandPos.geo_id__r.Name);  
					
					if(country.IPM_Brand_Position__c!=null && country.IPM_Brand_Position__c.equals(brandPos.brand_position_id__r.Name) )
					{
						brandOptions.add(new selectoption(brandPos.brand_id__r.Name,brandPos.brand_id__r.Name));
					}   
				}
				
			}  
			
			return brandOptions;
            
    	} 
  }