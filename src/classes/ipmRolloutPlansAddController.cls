public with sharing class ipmRolloutPlansAddController{

    public String projectId {get; set;}
    public IPM_Project__c project {get; set;}
    public Boolean isEditable{get;set;}

    private Set<String> setCountryCodesGlobal;
    private Set<String> setCountryCodesGlobalUnselected;
    private Set<String> setCountryCodesMCOs;
    private Set<String> setCountryCodes;
    private Set<String> setCountryNoRolls;

    private Map<String, mdm_Geography__c> mapUnileverCountries;
    public Map<String, IPM_Country__c> mapIPMCountries{get;set;}

    private Map<String, GeographyWrapper> mapClusterWrappers;
    public Map<String, GeographyWrapper> mapMCOWrappers {get; set;}
    private Map<String, GeographyWrapper> mapCountryWrappers;

    public List<GeographyWrapper> lstClusterWrappers {get; set;}
    public List<GeographyWrapper> lstMCOWrappers {get; set;}
    public List<GeographyWrapper> lstCountryWrappers {get; set;}
    
    public String selectedCluster {get; set;}
    public String previouselectedMCO {get; set;}
    public String selectedMCO {get; set;}
    public String selectedCountry {get; set;}

    public Boolean selectedKey {get; set;}

    public String globalCountries{get; set;}
    public String globalUnselectedCountries{get; set;}
    public String regionalMco{get; set;}
    public String regionalCountry{get; set;}
    public String regionalNoRoll{get; set;}

    private Map<String,IPM_Project_Rollout__c> mapExistingRollouts;
    private Map<String,IPM_Country__c> mapExistingCountries;
    private Set<String> setExistingCountriesRegionalProject;

    private Map<String, IPM_Project_Rollout__c> mapUpsertRegionalRollouts;
    private Map<String, IPM_Project_Rollout__c> mapUpsertRollouts;
    private List<IPM_Country__c> lstUpsertCountries;
    private List<IPM_Project_Rollout__c> lstDeleteRollouts;
    private List<IPM_Country__c> lstDeleteCountries;

    private static String NOT_ASSIGNED_CLUSTER_CODE = 'GEO0071';
    private static String REGIONAL_ROLLOUT_RECORDTYPE;
    private static String LOCAL_ROLLOUT_RECORDTYPE;

    private static String ROLLOUT_TYPE_MCO = 'MCO';
    private static String ROLLOUT_TYPE_COUNTRY = 'Country';

    private static String ROLLOUT_STATUS_WITH_MCO = 'With MCO';
    private static String ROLLOUT_STATUS_SEPERATE = 'Seperate';
    
    private static String PROJECT_TYPE_ROLLOUT = 'Rollout';
    private static String PROJECT_SPAN_REGIONAL = 'Regional';
    private static String PROJECT_SPAN_GLOBAL = 'Global';

    public ipmRolloutPlansAddController(){
        selectedMCO = null;
        isEditable=false;

        projectId = ApexPages.currentPage().getParameters().get('Id');
        if (projectId != null){
            project = [SELECT Id, IPM_Project_Name__c,IPM_Project_Type__c, IPM_Parent_Project__c, IPMProject_Span__c, IPM_Target_Launch_Dates__c, Sustainability_Period__c, IPM_Project_Leader__c, Market_Cluster__c, Market_Cluster_Name__c
                        FROM IPM_Project__c 
                        WHERE Id=:projectId];
            getUnileverCountries();
            generateWrappers();
            generateSubWrappers();
        }
        getIpmuserType(); 
    }
    
    private void getUnileverCountries(){
        //GET A LIST OF ALL IPM COUNTRIES
        String queryString = 'SELECT ';
        //MDM Geography
        For (String field : Schema.SObjectType.mdm_Geography__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Id FROM mdm_Geography__c ORDER BY Unilever_Cluster__c,Country_Group__c,ISO_Country_Dependency_Name__c';
        
        mapUnileverCountries = new Map<String, mdm_Geography__c>();
        For(mdm_Geography__c geography : Database.query(queryString))
            mapUnileverCountries.put(geography.ISO_3166_1_Code__c, geography);
    }
    
    private void generateWrappers(){
        //GET A LIST OF ALL IPM COUNTRIES
        String queryString = 'SELECT ';
        //IPM Country
        For (String field : Schema.SObjectType.IPM_Country__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }
        queryString+= 'Local_Rollout__r.KeyMCO__c, ';
        queryString+= 'Id FROM IPM_Country__c ';
        if(project.IPMProject_Span__c== PROJECT_SPAN_REGIONAL)
            queryString+= 'WHERE IPM_Regional_Project__c=:projectId ';
        else 
            queryString+= 'WHERE IPM_Project__c =: projectId';

        mapIPMCountries = new Map<String, IPM_Country__c>();
        For(IPM_Country__c ipmCountry : Database.query(queryString))
            mapIPMCountries.put(ipmCountry.Country_Code__c, ipmCountry);
            
        mapClusterWrappers = new Map<String, GeographyWrapper>();
        mapMCOWrappers = new Map<String, GeographyWrapper>();
        mapCountryWrappers = new Map<String, GeographyWrapper>();

        lstClusterWrappers = new List<GeographyWrapper>();
        
        Set<String> setDisabledClusterCodes = new Set<String>();
        Set<String> setDisabledMCOCodes = new Set<String>();
        
        setCountryCodesGlobal = new Set<String>();
        For (mdm_Geography__c country : mapUnileverCountries.values()){
            if (country.Unilever_Cluster_Code__c != NOT_ASSIGNED_CLUSTER_CODE){
                //Cluster
                GeographyWrapper clusterWrapper = new GeographyWrapper(country.Unilever_Cluster_Code__c, country.Unilever_Cluster__c, '');
                if (mapClusterWrappers.containsKey(country.Unilever_Cluster_Code__c))
                    clusterWrapper = mapClusterWrappers.get(country.Unilever_Cluster_Code__c);

                //MCO
                GeographyWrapper mcoWrapper = new GeographyWrapper(country.Country_Group_Code__c, country.Country_Group__c, country.Unilever_Cluster_Code__c);
                if (mapMCOWrappers.containsKey(country.Country_Group_Code__c))
                    mcoWrapper = mapMCOWrappers.get(country.Country_Group_Code__c);
                
                //Country
                GeographyWrapper countryWrapper = new GeographyWrapper(country.ISO_3166_1_Code__c, country.ISO_Country_Dependency_Name__c, country.Country_Group_Code__c);
                if(mapIPMCountries.containsKey(country.ISO_3166_1_Code__c)){
                    //Key MCO
                    mcoWrapper.key = mapIPMCountries.get(country.ISO_3166_1_Code__c).Local_Rollout__r.KeyMCO__c;

                    countryWrapper.selected = TRUE;
                    countryWrapper.rolloutStatus = mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Rollout_Status__c;
                    
                    setCountryCodesGlobal.add(country.ISO_3166_1_Code__c);

                    //Existing Regional/Local Rollouts
                    if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Local_Project__c != null){
                        countryWrapper.noRolloutDisabled = true;
                        if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Rollout_Status__c == ROLLOUT_STATUS_SEPERATE)
                            countryWrapper.mcoDisabled = true;
                        else if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Rollout_Status__c == ROLLOUT_STATUS_WITH_MCO)
                            countryWrapper.countryDisabled = true;
                    }

                    //Existing Regional Rollouts for Global Projects
                    if(mapIPMCountries.get(country.ISO_3166_1_Code__c).IPM_Regional_Project__c != null && project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
                        setDisabledClusterCodes.add(country.Unilever_Cluster_Code__c);
                    }
                }
                
                if(project.IPM_Project_Type__c == 'Original' && project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
                    if(country.Unilever_Cluster_Code__c == project.Market_Cluster__c)
                        mapClusterWrappers.put(country.Unilever_Cluster_Code__c, clusterWrapper);
                } else
                    mapClusterWrappers.put(country.Unilever_Cluster_Code__c, clusterWrapper);
                
                mapMCOWrappers.put(country.Country_Group_Code__c, mcoWrapper);
                mapCountryWrappers.put(country.ISO_3166_1_Code__c, countryWrapper);
            }
        }
        
        For(GeographyWrapper clusterWrapper : mapClusterWrappers.values()){
            if(setDisabledClusterCodes.contains(clusterWrapper.code)){
                clusterWrapper.clusterDisabled = true;
                mapClusterWrappers.put(clusterWrapper.code, clusterWrapper);
            }
        }

        For(GeographyWrapper mcoWrapper : mapMCOWrappers.values()){
            if(setDisabledClusterCodes.contains(mcoWrapper.parentCode)){
                mcoWrapper.mcoDisabled = true;
                mapMCOWrappers.put(mcoWrapper.code, mcoWrapper);
                setDisabledMCOCodes.add(mcoWrapper.code);
            }
        }
        
        For (GeographyWrapper countryWrapper : mapCountryWrappers.values()){
            if(setDisabledMCOCodes.contains(countryWrapper.parentCode)){
                countryWrapper.countryDisabled = true;
                mapCountryWrappers.put(countryWrapper.code, countryWrapper);
            }
        }
        
        lstClusterWrappers = sortWrappersByName(mapClusterWrappers.values());

        //SELECT FIRST SELECTED CLUSTER
        if(project.IPM_Project_Type__c == PROJECT_TYPE_ROLLOUT && project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
            IPM_Project_Rollout__c regionalRollout = [SELECT Id, MCO__c, Market_Cluster__c, IPM_Project__c 
                                                        FROM IPM_Project_Rollout__c 
                                                        WHERE Regional_Project__c=:project.Id 
                                                        LIMIT 1];
            selectedCluster = regionalRollout.Market_Cluster__c;
        } else {
            for(GeographyWrapper clusterWrapper : lstClusterWrappers){
                if ((selectedCluster == null) || (selectedCluster == '')){
                    if(!clusterWrapper.clusterDisabled)
                        selectedCluster = clusterWrapper.code;
                }
            }

            if ((selectedCluster == NULL) || (selectedCluster == ''))
                selectedCluster = lstClusterWrappers[0].code;
        }
    }
    
    private void generateSubWrappers(){
        lstMCOWrappers = new List<GeographyWrapper>();
        lstCountryWrappers = new List<GeographyWrapper>();
        
        GeographyWrapper clusterWrapper = mapClusterWrappers.get(selectedCluster);
        if(clusterWrapper.clusterDisabled)
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO,'The Market Cluster ' + clusterWrapper.name + ' has already been created as a Regional Project. Please contact the Regional Project Manager to add/modify Local Rollouts'));
        
        //MCO SUB WRAPPERS
        For(GeographyWrapper mcoWrapper : mapMCOWrappers.values()){
            if(mcoWrapper.parentCode == selectedCluster)
                lstMCOWrappers.add(mcoWrapper);
        }

        lstMCOWrappers = sortWrappersByName(lstMCOWrappers);

        if ((selectedMCO == NULL) || (selectedMCO == '')){
            selectedMCO = lstMCOWrappers[0].code;
            previouselectedMCO = lstMCOWrappers[0].code;
        }

        //COUNTRY SUB WRAPPERS
        For(GeographyWrapper countryWrapper : mapCountryWrappers.values()){
            if(countryWrapper.parentCode == selectedMCO){
                if(setCountryCodesGlobal.contains(countryWrapper.code))
                    countryWrapper.selected = true;
                lstCountryWrappers.add(countryWrapper);
            }
        }

        lstCountryWrappers = sortWrappersByName(lstCountryWrappers);
        
        selectedKey = mapMCOWrappers.get(selectedMCO).key;
    }

    public void changeCluster(){
        if(project.IPMProject_Span__c != PROJECT_SPAN_REGIONAL)
            mapMCOWrappers.get(previouselectedMCO).key = selectedKey;
        selectedMCO = null;
        selectedKey = false;
        processCountryCodeLists();
        generateSubWrappers();
    }

    public void changeMCO(){
        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            mapMCOWrappers.get(previouselectedMCO).key = selectedKey;
        selectedKey = false;
        processCountryCodeLists();
        generateSubWrappers();
    }

    public void generateRollouts(){
        if(project.IPMProject_Span__c != PROJECT_SPAN_REGIONAL)
            mapMCOWrappers.get(previouselectedMCO).key = selectedKey;
        
        processCountryCodeLists();
        processRollouts();
    }
    
    public PageReference redirectPage(){
        PageReference rolloutPlans = Page.ipmRolloutPlans;
        rolloutPlans.getParameters().put('id', projectId);                
        rolloutPlans.getParameters().put('cancelRedirect', 'true');                
        rolloutPlans.setRedirect(true);
        return rolloutPlans;
    }

    public PageReference cancel(){
        PageReference rolloutPlans = Page.ipmRolloutPlans;
        rolloutPlans.getParameters().put('id', projectId);                
        rolloutPlans.getParameters().put('cancelRedirect', 'true');                
        rolloutPlans.setRedirect(true);
        return rolloutPlans;
    }

    private void processCountryCodeLists(){
        //INITIALISE
        if(setCountryCodesGlobal == null)
            setCountryCodesGlobal = new Set<String>();

        if(setCountryCodesGlobalUnselected == null)
            setCountryCodesGlobalUnselected = new Set<String>();

        if(setCountryCodesMCOs == null)
            setCountryCodesMCOs = new Set<String>();
        
        if(setCountryCodes == null)
            setCountryCodes = new Set<String>();
        
        if(setCountryNoRolls == null)
            setCountryNoRolls = new Set<String>();


        //PROCESS GLOBAL - ADD the values to the existing list
        if(globalCountries!=null && globalCountries!=''){
            List<String> lstTemp = globalCountries.split(','); 
            setCountryCodesGlobal.addAll(lstTemp);
        }
        system.debug('--------------------------------------- setCountryCodesGlobal BEFORE: ' + setCountryCodesGlobal);

        if(globalUnselectedCountries!=null && globalUnselectedCountries!=''){
            List<String> lstTemp = globalUnselectedCountries.split(','); 
            setCountryCodesGlobalUnselected.addAll(lstTemp);
        }
        system.debug('--------------------------------------- setCountryCodesGlobalUnselected: ' + setCountryCodesGlobalUnselected);
        
        setCountryCodesGlobal.removeAll(setCountryCodesGlobalUnselected);
        setCountryCodesGlobalUnselected.clear();

        system.debug('--------------------------------------- setCountryCodesGlobal AFTER: ' + setCountryCodesGlobal);
        system.debug('--------------------------------------- setCountryCodesGlobalUnselected AFTER: ' + setCountryCodesGlobalUnselected);


        //PROCESS REGIONAL - ADD the values to the existing list
        if(regionalMco!=null && regionalMco!=''){
            List<String> lstTemp = regionalMco.split(','); 
            setCountryCodesMCOs.addAll(lstTemp);
        }

        if(regionalCountry != null && regionalCountry != ''){
            List<String> lstTemp = regionalCountry.split(','); 
            setCountryCodes.addAll(lstTemp);
        }

        if(regionalNoRoll != null && regionalNoRoll != ''){
            List<String> lstTemp = regionalNoRoll.split(','); 
            setCountryNoRolls.addAll(lstTemp);
        }
    }

    private void processRollouts(){
        REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();

        mapExistingRollouts = new Map<String,IPM_Project_Rollout__c>();
        mapExistingCountries = new Map<String,IPM_Country__c>();
        setExistingCountriesRegionalProject = new Set<String>();

        mapUpsertRegionalRollouts = new Map<String, IPM_Project_Rollout__c>();
        mapUpsertRollouts = new Map<String, IPM_Project_Rollout__c>();
        lstUpsertCountries = new List<IPM_Country__c>();
        lstDeleteRollouts = new List<IPM_Project_Rollout__c>();
        lstDeleteCountries = new List<IPM_Country__c>();
        
        //Existing Rollouts
        String queryString = 'SELECT Id, IPM_Rollout_Project__c,Regional_Project__c,Type__c, ';
        queryString+= '(SELECT Id, Country_Code__c FROM IPM_Countries_Local__r) ';
        queryString+= 'FROM IPM_Project_Rollout__c ';
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            queryString+= 'WHERE IPM_Project__c =: projectId';
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)
            queryString+= 'WHERE Regional_Project__c =: projectId';
        
        for(IPM_Project_Rollout__c ipmRollout : Database.query(queryString)){
            mapExistingRollouts.put(ipmRollout.IPM_Rollout_Project__c, ipmRollout);
        }

        //Countries
        queryString = null;
        queryString = 'SELECT Id, Country_Code__c, Country_Name__c, Project_Country__c, IPM_Rollout_Status__c, IPM_Regional_Project__c FROM IPM_Country__c ';
        if (project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            queryString+= 'WHERE IPM_Project__c =: projectId';
        else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)
            queryString+= 'WHERE IPM_Regional_Project__c =: projectId';

        
        for (IPM_Country__c country : Database.query(queryString)){
            mapExistingCountries.put(country.Country_Code__c, country);
            if(country.IPM_Regional_Project__c != null)
                setExistingCountriesRegionalProject.add(country.Country_Code__c);
        }

        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            processGlobalMCORollouts();
        } else if (project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL) {
            processRegionalMCORollouts();
            processRegionalCountryRollouts();
            processRegionalNoRollouts();
        }

        if(mapUpsertRegionalRollouts.size() > 0)
            Database.upsert(mapUpsertRegionalRollouts.values(), IPM_Project_Rollout__c.IPM_Rollout_Project__c, false);

        if(mapUpsertRollouts.size() > 0)
            Database.upsert(mapUpsertRollouts.values(), IPM_Project_Rollout__c.IPM_Rollout_Project__c, false);

        if(lstUpsertCountries.size() > 0)
            Database.upsert(lstUpsertCountries, IPM_Country__c.Project_Country__c, false);

        if(lstDeleteRollouts.size() > 0)
            delete lstDeleteRollouts;

        if(lstDeleteCountries.size() > 0)
            Database.delete(lstDeleteCountries, false);
    }
    
    private void processGlobalMCORollouts(){
        //MCO Rollouts
        For (String countryCodeGlobal : setCountryCodesGlobal){
            //Process Countries for which Regional Project has not been created
            if(!setExistingCountriesRegionalProject.contains(countryCodeGlobal)){
                mdm_Geography__c geography = mapUnileverCountries.get(countryCodeGlobal);
                String mcoRolloutName = getKeyMCORolloutName(countryCodeGlobal);
                String regionalRolloutName = getRegionalRolloutName(countryCodeGlobal);
    
                //MCO Rollout already exists
                if (mapExistingRollouts.containsKey(mcoRolloutName)){
                    IPM_Project_Rollout__c localMCORollout = mapExistingRollouts.get(mcoRolloutName);
                    //Country already exists
                    if(mapExistingCountries.containsKey(countryCodeGlobal)){
                        //DO NOTHING
                    } 
                    //Country DOES NOT exist
                    else {
                        //Add new country to existing MCO rollout
                        IPM_Country__c ipmCountry = new IPM_Country__c(
                            Project_Country__c = getCountryExternalId(countryCodeGlobal),
                            Geography__c = geography.Id,
                            IPM_Rollout_Status__c = ROLLOUT_STATUS_WITH_MCO,
                            IPM_Project__c = project.Id,
                            Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName)
                        );
    
                        lstUpsertCountries.add(ipmCountry);
                    }
                    
                    //Update Existing MCO Rollout
                    IPM_Project_Rollout__c existingMCORollout = new IPM_Project_Rollout__c(
                        IPM_Rollout_Project__c = mcoRolloutName,
                        KeyMCO__c = mapMCOWrappers.get(geography.Country_Group_Code__c).key
                    );
                    mapUpsertRollouts.put(mcoRolloutName, existingMCORollout);
                    
                }
                //MCO Rollout DOES NOT exist
                else {
                    //Regional Rollout already exists
                    if(mapExistingRollouts.containsKey(regionalRolloutName)){
                        //DO NOTHING
                    }
                    //Regional Rollout DOES NOT exist
                    else {
                        IPM_Project_Rollout__c newRegionalRollout = new IPM_Project_Rollout__c(
                            RecordTypeId=REGIONAL_ROLLOUT_RECORDTYPE,
                            Name = regionalRolloutName,
                            IPM_Rollout_Project__c = regionalRolloutName,
                            IPM_Project__c = project.Id,
                            Market_Cluster__c = geography.Unilever_Cluster_Code__c,
                            Market_Cluster_Name__c = geography.Unilever_Cluster__c,
                            Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                        );
    
                        mapUpsertRegionalRollouts.put(regionalRolloutName, newRegionalRollout);
                    }
    
                    //New MCO Rollout
                    IPM_Project_Rollout__c newMCORollout = new IPM_Project_Rollout__c(
                        RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                        Name = mcoRolloutName,
                        IPM_Rollout_Project__c = mcoRolloutName,
                        Regional_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = regionalRolloutName),
                        Type__c = ROLLOUT_TYPE_MCO,
                        KeyMCO__c = mapMCOWrappers.get(geography.Country_Group_Code__c).key,
                        MCO__c = geography.Country_Group_Code__c,
                        MCO_Name__c = geography.Country_Group__c,
                        Market_Cluster__c = geography.Unilever_Cluster_Code__c,
                        Market_Cluster_Name__c = geography.Unilever_Cluster__c,
                        IPM_Project__c = project.Id,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
    
                    mapUpsertRollouts.put(mcoRolloutName, newMCORollout);
    
                    //New Country
                    IPM_Country__c ipmCountry = new IPM_Country__c(
                        Project_Country__c = getCountryExternalId(countryCodeGlobal),
                        Geography__c = geography.Id,
                        IPM_Rollout_Status__c = ROLLOUT_STATUS_WITH_MCO,
                        IPM_Project__c = project.Id,
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName)
                    );
    
                    lstUpsertCountries.add(ipmCountry);
                }
            }
        }
        
        Set<String> setDeleteCountryCodes = new Set<String>();
        //Delete unselected countries
        For(IPM_Country__c existingCountry : mapExistingCountries.values()){
            if(!setCountryCodesGlobal.contains(existingCountry.Country_Code__c)){
                //Country exists but is not selected
                String countryRolloutName = getCountryExternalId(existingCountry.Country_Code__c);
                lstDeleteCountries.add(existingCountry);
                setDeleteCountryCodes.add(existingCountry.Country_Code__c);
                //Country Rollout ALREADY exist
                if (mapExistingRollouts.containsKey(countryRolloutName))
                    //Delete Rollout
                    lstDeleteRollouts.add(mapExistingRollouts.get(countryRolloutName));

            }
        }

        //Check to delete MCO Rollout
        For(IPM_Project_Rollout__c ipmRollout : mapExistingRollouts.values()){
            if(ipmRollout.Type__c == 'MCO'){
                Integer remainingCountryCount = 0;
                For(IPM_Country__c ipmCountry : ipmRollout.IPM_Countries_Local__r){
                    if(!setDeleteCountryCodes.contains(ipmCountry.Country_Code__c))
                        remainingCountryCount++;
                }
                
                if(remainingCountryCount == 0)
                    lstDeleteRollouts.add(ipmRollout);
            }
        }
    }
    
    private void processRegionalMCORollouts(){
        //MCO Rollouts
        For (String countryCodeMCO : setCountryCodesMCOs){
            mdm_Geography__c geography = mapUnileverCountries.get(countryCodeMCO);
            String mcoRolloutName = getKeyMCORolloutName(countryCodeMCO);

            //MCO Rollout already exists
            if (mapExistingRollouts.containsKey(mcoRolloutName)){
                IPM_Project_Rollout__c localMCORollout = mapExistingRollouts.get(mcoRolloutName);
                //Country already exists
                if(mapExistingCountries.containsKey(countryCodeMCO)){
                    //Country exists as part of MCO Rollout
                    if(mapExistingCountries.get(countryCodeMCO).IPM_Rollout_Status__c == ROLLOUT_STATUS_WITH_MCO){
                        //DO NOTHING
                    }
                    //Country exists as part of Country Rollout
                    else {
                        lstDeleteRollouts.add(mapExistingRollouts.get(mapExistingCountries.get(countryCodeMCO).Project_Country__c));
                        IPM_Country__c existingCountry = new IPM_Country__c(
                            Project_Country__c = mapExistingCountries.get(countryCodeMCO).Project_Country__c,
                            Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName),
                            IPM_Rollout_Status__c = ROLLOUT_STATUS_WITH_MCO
                        );
                        
                        lstUpsertCountries.add(existingCountry);
                    }
                }
                //Country DOES NOT exist
                else {
                    //Add new country to existing MCO rollout
                    IPM_Country__c ipmCountry = new IPM_Country__c(
                        Project_Country__c = project.IPM_Project_Name__c + '_' + countryCodeMCO,
                        Geography__c = geography.Id,
                        IPM_Rollout_Status__c = ROLLOUT_STATUS_WITH_MCO,
                        IPM_Regional_Project__c = project.Id,
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName)
                    );

                    if(project.IPM_Project_Type__c != 'Original')
                        ipmCountry.IPM_Project__c = project.IPM_Parent_Project__c;

                    lstUpsertCountries.add(ipmCountry);
                }
            }
            //MCO Rollout DOES NOT exist
            else {
                //Country exists as part of a different rollout
                if(mapExistingCountries.containsKey(countryCodeMCO)){
                    //SHOULD NOT BE ALOWED on the UI
                }
                //Country DOES NOT exist
                else {
                    //New MCO Rollout
                    IPM_Project_Rollout__c newMCORollout;
                    if(mapUpsertRollouts.containsKey(mcoRolloutName))
                        newMCORollout = mapUpsertRollouts.get(mcoRolloutName);
                    else
                        newMCORollout = new IPM_Project_Rollout__c(
                            RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                            Name = mcoRolloutName,
                            IPM_Rollout_Project__c = mcoRolloutName,
                            Type__c = ROLLOUT_TYPE_MCO,
                            MCO__c = geography.Country_Group_Code__c,
                            MCO_Name__c = geography.Country_Group__c,
                            Market_Cluster__c = geography.Unilever_Cluster_Code__c,
                            Market_Cluster_Name__c = geography.Unilever_Cluster__c,
                            Regional_Project__c = project.Id,
                            Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                        );
                    
                    mapUpsertRollouts.put(mcoRolloutName, newMCORollout);

                    //New Country
                    IPM_Country__c ipmCountry = new IPM_Country__c(
                        Project_Country__c = project.IPM_Project_Name__c + '_' + countryCodeMCO,
                        Geography__c = geography.Id,
                        IPM_Rollout_Status__c = ROLLOUT_STATUS_WITH_MCO,
                        IPM_Regional_Project__c = project.Id,
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = mcoRolloutName)
                    );

                    if(project.IPM_Project_Type__c != 'Original')
                        ipmCountry.IPM_Project__c = project.IPM_Parent_Project__c;

                    lstUpsertCountries.add(ipmCountry);
                }
            }
        }
    }
    
    private void processRegionalCountryRollouts(){
        //Local Country Rollouts
        For(string countryCode : setCountryCodes){
            mdm_Geography__c geography = mapUnileverCountries.get(countryCode);
            String countryRolloutName = getCountryExternalId(countryCode);
            //Country Rollout ALREADY exist
            if (mapExistingRollouts.containsKey(countryRolloutName)){
                //DO NOT DO ANYTHING
            }

            //Country Rollout DOES NOT exist
            else {
                //New Country Rollout
                IPM_Project_Rollout__c newCountryRollout;
                if(mapUpsertRollouts.containsKey(countryRolloutName))
                    newCountryRollout = mapUpsertRollouts.get(countryRolloutName);
                else
                    newCountryRollout = new IPM_Project_Rollout__c(
                        RecordTypeId=LOCAL_ROLLOUT_RECORDTYPE,
                        Name = countryRolloutName,
                        IPM_Rollout_Project__c = countryRolloutName,
                        Type__c = ROLLOUT_TYPE_COUNTRY,
                        MCO__c = geography.Country_Group_Code__c,
                        MCO_Name__c = geography.Country_Group__c,
                        Market_Cluster__c = geography.Unilever_Cluster_Code__c,
                        Market_Cluster_Name__c = geography.Unilever_Cluster__c,
                        Regional_Project__c = project.Id,
                        Target_Launch_Date__c = project.IPM_Target_Launch_Dates__c
                    );
                
                mapUpsertRollouts.put(countryRolloutName, newCountryRollout);

                //Country exists (as part of another MCO rollout)
                if(mapExistingCountries.containsKey(countryCode)){
                    IPM_Country__c existingCountry = new IPM_Country__c(
                        Project_Country__c = project.IPM_Project_Name__c + '_' + countryCode,
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = countryRolloutName),
                        IPM_Rollout_Status__c = ROLLOUT_STATUS_SEPERATE
                    );
                    lstUpsertCountries.add(existingCountry);
                }
                //Country DOES NOT exist
                else {
                    //New Country
                    IPM_Country__c ipmCountry = new IPM_Country__c(
                        Project_Country__c = project.IPM_Project_Name__c + '_' + countryCode,
                        Geography__c = geography.Id,
                        IPM_Rollout_Status__c = ROLLOUT_STATUS_SEPERATE,
                        IPM_Regional_Project__c = project.Id,
                        Local_Rollout__r = new IPM_Project_Rollout__c(IPM_Rollout_Project__c = countryRolloutName)
                    );

                    if(project.IPM_Project_Type__c != 'Original')
                        ipmCountry.IPM_Project__c = project.IPM_Parent_Project__c;

                    lstUpsertCountries.add(ipmCountry);
                    
                }
            }
        }
    }
    
    private void processRegionalNoRollouts(){
        Set<String> setDeleteCountryCodes = new Set<String>();

        //Delete Rollouts
        For(string noRolloutCode : setCountryNoRolls){
            mdm_Geography__c geography = mapUnileverCountries.get(noRolloutCode);
            String countryRolloutName = getCountryExternalId(noRolloutCode);

            //Delete Country
            lstDeleteCountries.add(mapExistingCountries.get(noRolloutCode));
            setDeleteCountryCodes.add(mapExistingCountries.get(noRolloutCode).Country_Code__c);
            //Country Rollout ALREADY exist
            if (mapExistingRollouts.containsKey(countryRolloutName))
                //Delete Rollout
                lstDeleteRollouts.add(mapExistingRollouts.get(countryRolloutName));
        }

        //Check to delete MCO Rollout
        For(IPM_Project_Rollout__c ipmRollout : mapExistingRollouts.values()){
            if(ipmRollout.Type__c == 'MCO'){
                Integer remainingCountryCount = 0;
                For(IPM_Country__c ipmCountry : ipmRollout.IPM_Countries_Local__r){
                    if(!setDeleteCountryCodes.contains(ipmCountry.Country_Code__c))
                        remainingCountryCount++;
                }
                
                if(remainingCountryCount == 0)
                    lstDeleteRollouts.add(ipmRollout);
            }
        }
    }

    private String getRegionalRolloutName(String countryCode){
        mdm_Geography__c geography = mapUnileverCountries.get(countryCode);
        if(project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL)
            return project.IPM_Project_Name__c;
        else{
            String shortName = IPM_Market_Cluster_Short_Names__c.getValues(geography.Unilever_Cluster_Code__c).Short_Name__c;
            return project.IPM_Project_Name__c + '_' + shortName;
        }
    }

    private String getKeyMCORolloutName(String countryCode){
        mdm_Geography__c geography = mapUnileverCountries.get(countryCode);
        String shortName = IPM_MCO_Short_Names__c.getValues(geography.Country_Group_Code__c).Short_Name__c;
        return getRegionalRolloutName(countryCode) + '_' + shortName;
    }

    private String getCountryExternalId(String countryCode){
        return getRegionalRolloutName(countryCode) + '_' + countryCode;
    }

    //Sorting
    private List<GeographyWrapper> sortWrappersByName(List<GeographyWrapper> wrappersToSort) {
        if(wrappersToSort == null || wrappersToSort.size() <= 1){
            return wrappersToSort;
        }
        
        List<GeographyWrapper> lessWrappers = new List<GeographyWrapper>();
        List<GeographyWrapper> greaterWrappers = new List<GeographyWrapper>();

        integer pivot = wrappersToSort.size() / 2;
        
        //save the pivot and remove it from the selectOption list
        GeographyWrapper pivotWrapper = wrappersToSort[pivot];
        wrappersToSort.remove(pivot);
        
        for(GeographyWrapper wrapper : wrappersToSort){
            if(wrapper.name <= pivotWrapper.name)
            lessWrappers.add(wrapper);
            else if(wrapper.name > pivotWrapper.name)
            greaterWrappers.add(wrapper);
        }

        List<GeographyWrapper> sortedWrappers = new list<GeographyWrapper>(); 

        sortedWrappers.addAll(sortWrappersByName(lessWrappers));
        sortedWrappers.add(pivotWrapper);
        sortedWrappers.addAll(sortWrappersByName(greaterWrappers));

        return sortedWrappers;
    }

    public class GeographyWrapper{
        public String code {get; set;}
        public String name {get; set;}
        public String parentCode {get; set;}
        public String rolloutStatus {get; set;}

        public Boolean key {get; set;}
        public Boolean selected {get; set;}
        public Boolean clusterDisabled {get; set;}
        public Boolean mcoDisabled {get; set;}
        public Boolean countryDisabled {get; set;}
        public Boolean noRolloutDisabled {get; set;}

        public GeographyWrapper(String code, String name, String parentCode){
            this.code = code;
            this.name = name;
            this.parentCode = parentCode;
            this.key = false;
            this.selected = false;
            this.clusterDisabled = false;
            this.mcoDisabled = false;
            this.countryDisabled = false;
            this.noRolloutDisabled = false;
        }
    }
    
    public void getIpmuserType(){
        list<IPM_Project__c>lstofuser = [SELECT IPM_Project_Leader__c,Deputy_Project_Leader__c 
                                            FROM IPM_Project__c 
                                            WHERE (IPM_Project_Leader__c=:userinfo.getuserid() 
                                                    OR Deputy_Project_Leader__c=:userinfo.getuserid()) 
                                                AND  id=:projectId 
                                            LIMIT 1];   
        if(lstofuser.size()>0)
            isEditable=true;
        list<PermissionSetAssignment> permissionSet = [SELECT Assignee.Name, PermissionSet.Name
                                                        FROM PermissionSetAssignment 
                                                        WHERE (PermissionSet.Name='IPM_Central_Team' 
                                                                OR PermissionSet.Name='IPM_Business_Partners') 
                                                            AND Assignee.id=:userinfo.getuserid()];
        if(permissionSet.size()>0)
            isEditable=true;
    }     
}