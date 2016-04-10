/**
    @Description: Single page controller class for the all Project Search Ctrl
    @Author: Cognizant Technology
    @Date: Jan 2014
**/
public with sharing class IPM_ProjectSearchCtrl{
    
    public String searchTxt{get;set;} //Search text
    public List<IPM_Project__c> projects; //List of projects which gets displayed as a search results
    public Integer allProjects{get;set;} // number of all projects in the page
    public Integer myProjects{get;set;} // number of projects that current user has
    public Integer bcPendings{get;set;} // number of projects with pending bosscards
    public String aProjects{get;set;} // Checked all project sent from page to controller
    public String mProjects{get;set;} // Checked my project sent from page to controller
    public Integer originalProjects{get;set;} // Number of original projects
    public Integer rolloutProjects{get;set;} // Number of rollout projects
    public Integer operationalProjects{get;set;} // Number of operational projects
    public Integer activeProjects{get;set;} //Number of active projects
    public Integer stoppedProjects{get;set;} // Number of stopped projects
    //public String bPending{get;set;} // Checked bosscard project sent from page to controller
    public set<String> masterBrandArr{get;set;} //Brings out the master data from the brand
    public list<IPM_Country__c> allCountries{get;set;}
    public String bPositionings{get;set;} //Array of selected brand positionings to be selected for a project.
    
    public Map<String, Integer> clusterCountMap{get;set;}//Counter collection which counts the number of projects per cluster
    public Map<String, Integer> mcoCountMap{get;set;}//Counter collection which counts the number of projects per mco
    public Map<String, Integer> countryCountMap{get;set;}//Counter collection which counts the number of projects per country
    private String str_Hyphen;
    
    public Integer iTO1{get;set;} //ITO field variable lower bound
    public Integer iTO2{get;set;} //ITO field variable upper bound
    
    public String geoAll{get;set;} //Checked parameter if the user is searching for Geographical location wise projects
    public String clusters{get;set;} //Cluster to be searched
    public String mcos{get;set;} //MCOs to be searched
    public String countries{get;set;} //countries to be searched
    
    private Boolean noRecords; //internal variables which is true when the search results displayes no records
    public Map<String, String> currentSort{get;set;} //sorting variable where the current sort fits in
    public list<String> projectPhases{get;set;} //list of all the phases that can get for projects.
    public String selectedPhase {get;set;} //seleted phase
    public String selectedProjType {get;set;} //seleted project type
    public String selectedActiveProject{get;set;}
    public Boolean selectedStoppedProject{get;set;}
    public Map<String, Integer> phasesCountMap{get;set;} //Ordering map phase wise
    public String tldFrom{get;set;} //Target Launch Date lower bound
    public String tldTo{get;set;} // TLD upper bound
    public Integer size{get;set;} //page size
    public Date tFrm; //inputs accepted from user for TLD FROm
    public Date tTo; //inputs accepted from user for TLD TO
    public list<IPM_ClusterMCO> clusterMCOList{get;set;} //Wrapped data of Cluster MCO & Country
    public Boolean isAsc{get;set;}//bool value for ascending or descending othterwise
    public Integer noOfRecords{get; set;} //Total number of records used for pagination
    public boolean isEditable{get;set;}  //used by security
    public boolean isProjectEditable{get;set;} //used for security purpose
    public boolean isBossCardEditable{get;set;}//used for security
    public static final String TRUE_STR = 'true';
    public static final String FALSE_STR = 'false';
    public static final String THISFLD_STR = 'thisFld';
    public static final String IPM_PROJECT_NAME_C_STR = 'IPM_Project_Name__c';
    public Set<string> shareProjIdSet;
    public Map<Id,Decimal> projIdYear3iTO{get; set;}
    public string projIdString;
    public IPM_Project__c projectForTLDFrom{get;set;}
    public IPM_Project__c projectForTLDTo{get;set;}
    //public boolean checkFilter{get;set;}
    public Integer unAssignedCount{get;set;}
    Set<String> clusterSet = new Set<String>();
    public String unassigned{get;set;}
    //constructor
    public IPM_ProjectSearchCtrl() {
        String browserType = Apexpages.currentPage().getHeaders().get('USER-AGENT'); //gets the browser name 
        if(String.isNotBlank(browserType) && browserType.contains('MSIE')){ // browser values can be taken from salesforce custom setting if required
            Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE= edge');  // apply IE hack in the constructor
        }

        List<IPM_Country__c> lstCountires = new List<IPM_Country__c>();
        //Initialising variables
        masterBrandArr = IPM_Utils.getMasterBrandData();
        str_Hyphen = '-';
        bPositionings = IPM_ConstantUtils.BLANK;
        noRecords = false;
        isProjectEditable=false;
        isBossCardEditable=false;
        isEditable=false;
        searchTxt = IPM_ConstantUtils.BLANK;
        iTO1 = -1;
        iTO2 = -1;
        aProjects = TRUE_STR;
        mProjects = TRUE_STR;
        //bPending = TRUE_STR;
        geoAll = TRUE_STR;
        clusters = IPM_ConstantUtils.BLANK;
        mcos = IPM_ConstantUtils.BLANK;
        countries = IPM_ConstantUtils.BLANK;
        tldFrom = IPM_ConstantUtils.BLANK;
        tldTo = IPM_ConstantUtils.BLANK;
        isAsc = false;
        //checkFilter = false;
        
        selectedProjType = 'All';
        selectedPhase = 'all';
        selectedActiveProject = TRUE_STR;
        selectedStoppedProject = true;
        unassigned = TRUE_STR;
        
        IPM_GeoWrapper geoCon = new IPM_GeoWrapper();
        clusterCountMap = new Map<String, Integer>(); //Key = 'cluster'
        mcoCountMap = new Map<String, Integer>(); //Key = 'cluster-mco'
        countryCountMap = new Map<String, Integer>(); //Key = 'cluster-mco-country'
        allCountries = new list<IPM_Country__c>();
        Apexpages.currentPage().getHeaders().put('X-UA-Compatible', 'IE=edge');//prevent browser incomptibility
        clusterMCOList = geoCon.getclusterMCOWrapper();//initialising geographical data
        projects = new List<IPM_Project__c>();
        //Lets add all the countries with 0 values so we increment them as we find respective projects for respective area

        for(IPM_ClusterMCO eachCluster : clusterMCOList) {
            clusterCountMap.put(eachCluster.clusterName, 0);
            for(IPM_MCO eachMCO : eachCluster.mcos) {
                mcoCountMap.put(eachCluster.clusterName + str_hyphen + eachMCO.mcoName, 0);
                for(MDO_Geography__c eachCountry : eachMCO.countries) {
                    countryCountMap.put(eachCluster.clusterName + str_hyphen + eachMCO.mcoName 
                                                  + str_hyphen + eachCountry.Name, 0);
                }
            }
        }
        
        //this field will actually define what is the current sorting column applies to, default is Project name
        currentSort = new Map<String, String>{THISFLD_STR => IPM_PROJECT_NAME_C_STR};
        phasesCountMap = new Map<String, Integer>();
        projectPhases = new list<String>();
        projectPhases.addAll(IPM_Utils.getPicklistValues(new IPM_Project__c(), 'IPM_Phase__c'));//Adds all the general phases & ordering
        allProjects = 0;myProjects = 0;bcPendings=0;originalProjects = 0; rolloutProjects = 0; operationalProjects = 0; activeProjects =0; stoppedProjects=0;unAssignedCount=0;
        projects = new List<IPM_Project__c>();
        for(String eachPhase : projectPhases) {
            phasesCountMap.put(eachPhase, 0);
        }
        
        //gives back ids of the projects which belongs to current user or he/she is a team member
        shareProjIdSet =  new  Set<string>();
        for(IPM_Project_Resource__c res : [SELECT Id,IPM_User__c,IPM_Project__c FROM IPM_Project_Resource__c WHERE IPM_User__c  =:userinfo.getuserid()]){
            shareProjIdSet.add(res.IPM_Project__c);
        }
        
        for(IPM_Project__c project : [Select Id from IPM_Project__c where
                                                        IPM_Project_Leader__c  =:userinfo.getuserid() OR
                                                        Deputy_Project_Leader__c=:userinfo.getuserid() OR
                                                        IPM_Technical_Project_Leader__c =:userinfo.getuserid() OR
                                                        IPM_Project_Gatekeeper__c =:userinfo.getuserid() OR
                                                        IPM_Finance_Member__c = : UserInfo.getUserId() LIMIT 9999 ]){
             shareProjIdSet.add(project.Id);                                                    
        }
        shareProjIdSet.remove(null);
        shareProjIdSet.remove('');
        //Initialise everything to the projectList variable from the query
        for(IPM_Project__c eachProject : Database.query(query())) {
            
            myProjects = (eachProject.OwnerId == Userinfo.getUserId() || (shareProjIdSet != null && !shareProjIdSet.isEmpty() && shareProjIdSet.contains(eachProject.id)))? myProjects+1 : myProjects;
            originalProjects =  eachProject.IPM_Project_Type__c ==  IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL ?  originalProjects + 1 : originalProjects;
            rolloutProjects =  eachProject.IPM_Project_Type__c ==  IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT ?  rolloutProjects + 1 : rolloutProjects;
            operationalProjects =  eachProject.IPM_Project_Type__c ==  IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL ?  operationalProjects + 1 : operationalProjects;
            
            activeProjects = !eachProject.Is_Archieved__c ? activeProjects + 1: activeProjects;
            stoppedProjects = eachProject.Is_Archieved__c ? stoppedProjects + 1: stoppedProjects;
            
            bcPendings = eachProject.IPM_Bosscard__c != null && !eachProject.IPM_Bosscard_Status__c? bcPendings+1 : bcPendings;
            allProjects++;
            Integer cnt = phasesCountMap != null && phasesCountMap.get(eachProject.IPM_Phase__c) != null ? phasesCountMap.get(eachProject.IPM_Phase__c)+1 : 0;
            phasesCountMap.put(eachProject.IPM_Phase__c, cnt);
            
            lstCountires = eachProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL ? eachProject.IPM_Countries__r : lstCountires ;
            lstCountires = eachProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL ? eachProject.IPM_Countries1__r : lstCountires ;
            lstCountires = eachProject.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL ? eachProject.IPM_Countries2__r : lstCountires ;
                
            Map<string, boolean> mapCountryAdded = new Map<String, boolean>();mapCountryAdded.put('a',true);
            Map<string, boolean> mapMCOAdded = new Map<String, boolean>();mapMCOAdded.put('a',true);
            Map<string, boolean> mapClusterAdded = new Map<String, boolean>();mapClusterAdded .put('a',true);
            
            for(IPM_Country__c eachCountry : lstCountires) {
                              
                String countryKey = eachCountry.Market_Cluster_Name__c + str_hyphen + eachCountry.MCO_Name__c + str_hyphen + eachCountry.Country_Name__c;
                if(countryCountMap != NULL && !mapCountryAdded.containsKey(countryKey) && countryCountMap.containsKey(countryKey)){
                    countryCountMap.put(countryKey, countryCountMap.get(countryKey)+1);
                    mapCountryAdded.put(countryKey , true);
                }
                   
                String mcoKey = eachCountry.Market_Cluster_Name__c + str_hyphen + eachCountry.MCO_Name__c ;
                if(mcoCountMap!= NULL && !mapMCOAdded.containsKey(mcoKey) && mcoCountMap.containsKey(mcoKey)){
                    mcoCountMap.put(mcoKey, mcoCountMap.get(mcoKey)+1);
                    mapMCOAdded.put(mcoKey, true);
                }
                    
                String clusterKey = eachCountry.Market_Cluster_Name__c;
                if(clusterCountMap != NULL && !mapClusterAdded.containsKey(clusterKey) && clusterCountMap.containsKey(clusterKey)){
                    clusterCountMap.put(clusterKey, clusterCountMap.get(clusterKey)+1);
                    mapClusterAdded.put(clusterKey, true);
                }
            }
            
            if( lstCountires.isEmpty()){
                unAssignedCount++;
            }
            allCountries.addAll(eachProject.IPM_Countries__r);//we need collection of all countries with all projects for future use and to display
        }
        
        clusterCountMap.put('Unassigned',unAssignedCount);
        getusertype();//security
        projectForTLDFrom = new IPM_Project__c();
        projectForTLDTo = new IPM_Project__c();
    }
    
    /*******************************************************************************************************
    * @description: It loads the projects whenever the submit or any action happens from the page.
    */
    public void loadProjects() {
        noRecords = true;
        getProjects();
        refresh();
    }
     
    /**************************************************************
    * @description: initialises project property getter with standard set controller 
    */
    public List<IPM_Project__c> getProjects() {
        
        projects = new List<IPM_Project__c>();
        for(IPM_Project__c eachProject : (List<IPM_Project__c>)setCon.getRecords()) {
            projects.add(eachProject);  
        }
        return projects;
    }
    
    /**************************************************************
    * @description: PageNumber property getter with Page number
    * @return: page number
    */
    public Integer getPageNumber(){
        return setCon.getPageNumber();
    }
    
    /**************************************************************
    * @description: total pages property getter
    * @return: number
    */
    public Integer getTotalPages(){
 
        Decimal totalSize = setCon.getResultSize();
        Decimal pageSize = setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    /**************************************************************
    * @description: dynamic query method preparation happens here
    * @return: query string
    */
    private string query() {
        noRecords = false;
        //map conataining project id and  iTO value
        projIdString = iTOWiseSearch();
        
        string shareProj = IPM_ConstantUtils.BLANK;
        if(shareProjIdSet != null && !shareProjIdSet.isEmpty()){
                string strToReturn = IPM_Utils.convertSetToString(shareProjIdSet); 
                shareProj = IPM_Utils.convertStrToSoqlList(strToReturn);
        }
        
    String soql  =  'SELECT IPM_Project_Name__c,IPM_Phase__c,IPM_IsSaved__c, IPM_Project_Leader__r.Name, IPM_Project_Gatekeeper__r.Name,ownerId,IPM_Bosscard__r.IPM_Bosscard_Logo__c,IPM_Project_Type__c,';
           soql +=  'IPM_Sub_Category__c,IPM_Category_Text__c,IPM_Project_Logo__c,IPM_Bosscard__c,IPM_Bosscard_Status__c, IPM_Bosscard__r.Name,IPMProject_Span__c,Is_Archieved__c,IPM_Brand_Positioning__c,';
           soql +=  '(SELECT Year3_ITO__c,Year_3_iTO_Charter__c,Year_3_iTO_Global__c FROM IPM_Financials_Consolidated__r WHERE RecordTypeId = \'' + IPM_Utils.getFinancialRecordType('Consolidated') + '\' LIMIT 1),';
           soql += 'IPM_Target_Launch_Dates__c,IPM_Project_Description__c, (Select Country_Name__c, MCO_Name__c, Market_Cluster_Name__c  From IPM_Countries__r),(Select Country_Name__c, MCO_Name__c, Market_Cluster_Name__c  From IPM_Countries1__r),(Select Country_Name__c, MCO_Name__c, Market_Cluster_Name__c  From IPM_Countries2__r) FROM IPM_Project__c ';
           soql += 'WHERE Id != NULL ';
       
       /*******************************************************
       Prepare the search query for input from search box
       *******************************************************/   
       if(String.IsNotBlank(searchTxt)) {
           noRecords = !noRecords ? false : noRecords;
           soql += ' AND (IPM_Project_Name__c LIKE \'%' + String.escapeSingleQuotes(searchTxt) + '%\' OR IPM_Project_Leader__r.Name LIKE \'%' + String.escapeSingleQuotes(searchTxt) + '%\'';
           soql += ' OR IPM_Bosscard__r.Name LIKE \'%' + String.escapeSingleQuotes(searchTxt) + '%\'';
           soql += ' OR IPM_Project_Description__c LIKE \'%' + String.escapeSingleQuotes(searchTxt) + '%\' OR IPM_Phase__c LIKE \'%' + String.escapeSingleQuotes(searchTxt) + '%\')';
       } 
       
        /*******************************************************
       Prepare the search query for type filter 
       *******************************************************/
       //when All Projects = False & My Projects = True, then give my projects
       if( aProjects != TRUE_STR && mProjects == TRUE_STR) {
           soql += ' AND ( OwnerId = \'' + UserInfo.getUserId() + '\'';
           if (String.IsBlank(shareProj)){
                soql += ')';
           }
           else{
                soql += ' OR Id IN ' + shareProj + ')';
           }
           noRecords = !noRecords ? false : noRecords;
       } 
       
       //Prepare the search query when All Projects = False & My Projects = False, then give no projects
       if(mProjects == FALSE_STR && aProjects == FALSE_STR) {
            noRecords = true;
       }
       
       /*******************************************************
       =>Prepare the search query for Project Type Filter
       1) If 'All' is selected, do nothing in SOQL
       2) If 'All' is not selected, but individual Project Type options are selected, prepare the filter clause
       3) If nothing is selected from Project Type filter, give no records.
       *******************************************************/ 
       if(string.isNotBlank(selectedProjType) ) {
            list<string> projTypeList = IPM_Utils.convertJSArrayToLsArray(selectedProjType);
            set <string> projTypeSet = new set <string> ();
            projTypeSet.addAll(projTypeList);
            //if 'All' is selected then ignore else include the selected
            if(!projTypeSet.contains('All')){
                soql += ' AND IPM_Project_Type__c IN ' + IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(selectedProjType));
            }
            noRecords = !noRecords ? false : noRecords;
       }else{
            noRecords = true;
            soql += ' AND IPM_Project_Type__c = NULL ';
       }
       
       /*******************************************************
       =>Prepare the search query for Current Status Filter
      *******************************************************/ 
       //Active = True , Stopped=True means All=true so ingore filter in SOQL
       //Active = False , Stopped=False
       if(selectedActiveProject == FALSE_STR && !selectedStoppedProject){   
            noRecords = true;
       }
        //Active = True , Stopped=False
       if(selectedActiveProject == TRUE_STR && !selectedStoppedProject){
            noRecords = !noRecords ? false : noRecords;
            soql += ' AND  Is_Archieved__c = false AND IPM_Phase__c != \''+ IPM_ConstantUtils.PHASE_PLE + '\'';
       }
       //Active = False , Stopped=True
       if(selectedActiveProject == FALSE_STR && selectedStoppedProject){
           noRecords = !noRecords ? false : noRecords;
           soql += ' AND Is_Archieved__c = true';
       }
       
       /*******************************************************
       =>Prepare the search query for Phase Filter
       1) If 'All' is selected, do nothing in SOQL
       2) If 'All' is not selected, but individual Phase options are selected, prepare the filter clause
       3) If nothing is selected from Phase filter, give no records.
       *******************************************************/ 
       
       if(string.isNotBlank(selectedPhase)) {
            list<string> projPhaseList = IPM_Utils.convertJSArrayToLsArray(selectedPhase);
            set <string> projPhaseSet = new set <string> ();
            projPhaseSet.addAll(projPhaseList);
            if(!projPhaseSet.contains('all')){
                noRecords = !noRecords ? false : noRecords;
                soql += ' AND IPM_Phase__c IN ' + IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(selectedPhase));
            }
       }else {
            noRecords = true;
            soql += ' AND IPM_Phase__c = NULL ';
       }
       
       /*******************************************************
       =>Prepare the search query for Geography Filter
       Different scenarios that are covered by below code blocks are:-
       1) geoAll = true ignore filter in SOQL
       2) geoAll = false , specific countries are selected, unassigned = selected
       3) geoAll = false , specific countries are selected, unassigned = unselected
       4) geoAll = false , specific countries are not selected, unassigned = selected
       5) geoAll = false and none is selected
       *******************************************************/ 
       clusterSet.addAll(IPM_Utils.convertJSArrayToLsArray(clusters));
       
       if(geoAll == TRUE_STR){
           noRecords = !noRecords ? false : noRecords;
       }
            
       if(geoAll != TRUE_STR && String.IsNotBlank(countries) ) {
            noRecords = !noRecords ? false : noRecords;
            soql += ' AND ( Id IN ' + countryWiseProjects() ;
            if(unassigned == FALSE_STR){
                soql += ') ';
            }
       }
                
      if(geoAll != TRUE_STR && unassigned == TRUE_STR) {
            if(countries == IPM_ConstantUtils.BLANK){
               soql += ' AND Id NOT IN ' + countryWiseProjects();
            }
            else{
                    clusters = mcos = countries = IPM_ConstantUtils.BLANK;
                    soql  += ' OR  Id NOT IN ' + countryWiseProjects() + ') ';
            }
            noRecords = !noRecords ? false : noRecords;
       }
       
       if(geoAll != TRUE_STR && String.IsBlanK(countries) && unassigned == FALSE_STR){
            noRecords = true;
       }
       
       /*******************************************************
       =>Prepare the search query when Target Launch Dates are specified to filter out
       *******************************************************/ 
       if(projectForTLDFrom != null && projectForTLDTo != null && projectForTLDFrom.IPM_Target_Launch_Dates__c != null && projectForTLDTo.IPM_Target_Launch_Dates__c != null){
           noRecords = !noRecords ? false : noRecords;
           String fDt = DateTime.newInstance(projectForTLDFrom.IPM_Target_Launch_Dates__c, Time.newInstance(0, 0, 0, 0)).format(IPM_ConstantUtils.DATE_FORMAT);//yyyy-MM-dd
           String tDt = DateTime.newInstance(projectForTLDTo.IPM_Target_Launch_Dates__c, Time.newInstance(0, 0, 0, 0)).format(IPM_ConstantUtils.DATE_FORMAT);
           soql += 'AND IPM_Target_Launch_Dates__c >=' + fDt;
           soql +=  ' AND IPM_Target_Launch_Dates__c <=' +  tDt;
       }
       
       /*******************************************************
       =>Prepare the search query when Brands are specified to filter out
       *******************************************************/ 
       if(bPositionings != IPM_ConstantUtils.BLANK) {
            noRecords = !noRecords ? false : noRecords;
            soql += ' AND IPM_Brand_Positioning__c IN ' + IPM_Utils.convertStrToSoqlList(String.escapeSingleQuotes(bPositionings));
       }
       
       /*******************************************************
       =>Prepare the search query when iTO Ranges are specified to filter out
       *******************************************************/ 
       if(iTO1 >= 0 && iTO2 >= 0 && projIdString != IPM_ConstantUtils.BLANK  && projIdString != null) {
            noRecords = !noRecords ? false : noRecords;
            soql += ' AND Id IN ' + projIdString;
       }
       
       if(noRecords) {
            soql +=  ' AND Id = NULL ';
       }
       
       if(isAsc) {
           soql += ' ORDER BY ' + currentSort.get(THISFLD_STR) + ' DESC NULLS LAST';
        } else {
           soql += ' ORDER BY ' + currentSort.get(THISFLD_STR) + ' ASC NULLS LAST';
        }
       soql += ' LIMIT 9999';
       system.debug(bPositionings + ' ** soql : ' + soql);
       noRecords = false;
       return soql;
    }
    
    /**************************************************************
    * @description: country, cluster & mco wise preparating as an input from the page and concatenating to the soql query.
    * @return: string which adds up to the query in IN clause
    */
    private String countryWiseProjects() {
        
        String strToReturn = IPM_ConstantUtils.BLANK;
        String[] clusterList = IPM_Utils.convertJSArrayToLsArray(clusters);
        String[] mcoList = IPM_Utils.convertJSArrayToLsArray(mcos);
        String[] countryList = IPM_Utils.convertJSArrayToLsArray(countries);
        IPM_Country__c[] countryLst = new list<IPM_Country__c>();
        Set<String> projectIds = new Set<String>();
                clusterSet.addAll(clusterList);
                
        if( clusterList.size() > 0 || mcoList.size() > 0 || countryList.size() > 0  ) {
            countryLst = [SELECT IPM_Project__c, IPM_Regional_Project__c, IPM_Local_Project__c
                                  FROM IPM_Country__c 
                                  WHERE Country_Name__c IN :countryList
                                        LIMIT 50000];
        } 
        else if( unassigned == TRUE_STR || ( clusterList.size() == 0 && mcoList.size() == 0 && countryList.size() == 0 )) {
            countryLst = [SELECT IPM_Project__c,IPM_Regional_Project__c, IPM_Local_Project__c FROM IPM_Country__c LIMIT 50000];
        }
        
        
        for(IPM_Country__c eachCountry : countryLst) {
            if(eachCountry.IPM_Project__c != null){
                projectIds.add(eachCountry.IPM_Project__c);
            } 
            if(eachCountry.IPM_Regional_Project__c != null){
                projectIds.add(eachCountry.IPM_Regional_Project__c);
            } 
            if(eachCountry.IPM_Local_Project__c != null){
                projectIds.add(eachCountry.IPM_Local_Project__c);
            } 
        }
        strToReturn = IPM_Utils.convertSetToString(projectIds); 
        return IPM_Utils.convertStrToSoqlList(strToReturn);
    }
    
    
    /**************************************************************
    * @description: method which receives the inputs from upper and lower bound ito ranges & searches in the financial object
    * @return: gives back ids of the projects which lies within the range of iTOs
    */
    private string iTOWiseSearch() {
        
        String strToReturn;
        Decimal iTOValue = 0.00;
        Set<String> projectIds = new Set<String>();
       
        // get project id and its ito year value map
        projIdYear3iTO = IPM_Utils.createProjectITOValueMap();
        
        if(projIdYear3iTO != null && !projIdYear3iTO.isEmpty()){
            for(Id projId : projIdYear3iTO.keySet()){
                iTOValue = projIdYear3iTO.get(projId);  
                //add project ids to set, whose iTO range is between the user specified range
                if(iTO1 >= 0 && iTO2 >= 0 && iTOValue >= Decimal.valueOf(iTO1) &&  iTOValue <= Decimal.valueOf(iTO2)){
                        projectIds.add(projId);
                }
            }
        }
        // convert the roject id set to query string
        if(projectIds != null && !projectIds.isEmpty()){    
            string idTostring = IPM_Utils.convertSetToString(projectIds);
            strToReturn = IPM_Utils.convertStrToSoqlList(idTostring);
        }else{
            strToReturn =IPM_ConstantUtils.BLANK;
        }
        return strToReturn;
    }
    
    /**************************************************************
    * @description: toggling sort with project name and adding back to the currentSort map & ordering the result
    */
    public void toggleSortProjects() {
        
        isAsc = isAsc? false : true;
        currentSort.put(THISFLD_STR, IPM_PROJECT_NAME_C_STR);
        getProjects();
        refresh();
    }
    
    /**************************************************************
    * @description: toggling sort with phase and adding back to the currentSort map & ordering the result
    */
    public void toggleSortPhases() {
        
        isAsc = isAsc? false : true;
        currentSort.put(THISFLD_STR, 'IPM_Phase__c');
        getProjects();
        refresh();
    }
    
    /**************************************************************
    * @description: toggling sort with Project Leaders and adding back to the currentSort map & ordering the result
    */
    public void toggleSortPLs() {
        
        isAsc = isAsc? false : true;
        currentSort.put(THISFLD_STR, 'IPM_Project_Leader__r.Name');
        getProjects();
        refresh();
    }
    
    /**************************************************************
    * @description: toggling sort with Gate Keeper and adding back to the currentSort map & ordering the result
    */
    public void toggleSortGKs() {
        
        isAsc = isAsc? false : true;
        currentSort.put(THISFLD_STR, 'IPM_Project_Gatekeeper__r.Name');
        getProjects();
        refresh();
    }
    
    /**************************************************************
    * @description: toggling sort with iTO and adding back to the currentSort map & ordering the result (this is functionality tht needs to be rebuilt)
    */
    public void toggleSortITOs() {
        
        isAsc = isAsc? false : true;
        currentSort.put(THISFLD_STR, IPM_PROJECT_NAME_C_STR);
        getProjects();
        refresh();
    }
    
    /**************************************************************
    * @description: toggling sort with TLD and adding back to the currentSort map & ordering the result
    */
    public void toggleSortTLDs() {
        
        isAsc = isAsc? false : true;
        currentSort.put(THISFLD_STR, 'IPM_Target_Launch_Dates__c');
        getProjects();
        refresh();
    }
    
    /**************************************************************
    * @description: Standard Set Controller for standard pagination setup, the getter & setter
    */
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null){
                size = 20;
                string queryString = query();
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
            }
            return setCon;
        }
        set;
    }
    /**************************************************************
    * @description: The first most page 
    */
    public void first() {
        setCon.first();
    }
  
    /**************************************************************
    * @description: Last page
    */
    public void last() {
        setCon.last();
    }
    
    /**************************************************************
    * @description: Boolean property which returns true if it has next page?
    */ 
    public Boolean hasNext{
        get{ 
            return setCon.getHasNext();
        }
        set;
    }
    
    /**************************************************************
    * @description: Reinitialising the variables
    * @return: PageReference which is null
    */
    public pageReference refresh() {
        setCon = null;
        getProjects();
        setCon.setPageNumber(1);
        geoAll = TRUE_STR;
        clusters = IPM_ConstantUtils.BLANK;
        mcos = IPM_ConstantUtils.BLANK;
        countries = IPM_ConstantUtils.BLANK;
        return null;
    }
    
    /**************************************************************
    * @description:  Boolean property which returns true if it has previous page?
    */
    public Boolean hasPrevious{
        get{
            return setCon.getHasPrevious();
        }
        set;
    }
    /**************************************************************
    * @description:  Property for page number variable?
    */
    public Integer pageNumber{
        get{
            return setCon.getPageNumber();
        }
        set;
    }
    /**************************************************************
    * @description:  previous page navigation property
    */
    public void previous(){
        setCon.previous();
    }
    
    /**************************************************************
    * @description:  next page navigation property
    */
    public void next(){
        setCon.next();
    }
    
    /**************************************************************
    * @description: get User type, Used for security (Author: Pratyusha)
    */
    public void getusertype(){
        list<IPM_User_Profile__c>lstuserprofile=[SELECT IPM_User_Role__c,IPM_User_Function__c,Export_Porfolio_Data__c 
                                                 FROM IPM_User_Profile__c 
                                                 WHERE IPM_User__c=:userinfo.getuserid() AND (IPM_User_Role__c!=null or IPM_User_Function__c!=null) LIMIT 50000];
        
         if(lstuserprofile != null && !lstuserprofile.isEmpty()){
            for(IPM_User_Profile__c up:lstuserprofile){
                if(up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_BD || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_CMI|| 
                    up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_CD || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_FINANCE|| 
                    up.IPM_User_Role__c == IPM_ConstantUtils.IPM_ROLE_SUPPLY_CHAIN || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_RD || 
                    up.IPM_User_Function__c == IPM_ConstantUtils.GATEKEEPER_CONSTANT || up.IPM_User_Role__c == IPM_ConstantUtils.FUNCTIONAL_ROLE_BB){
                    IsProjectEditable=false;
                    isBossCardEditable=false;
                }
                
                if(up.IPM_User_Function__c==IPM_ConstantUtils.TEAM_PROJECT_LEADER || up.IPM_User_Function__c==IPM_ConstantUtils.TEAM_DEPUTY_PROJECT_LEADER){
                    isProjectEditable=true;isBossCardEditable=true;
                }
            }
        }
        else{
            isProjectEditable=false;
            isBossCardEditable=false;
        }
        if(!isProjectEditable || !isBossCardEditable){
            //security for central team and BP users
            IPM_CustomPermission cpr = new IPM_CustomPermission();
            boolean isCentralTeam=false;
            boolean isBPUser=false;
            isCentralTeam = cpr.hasPermission(IPM_ConstantUtils.IPM_CENTRALTEAM_PERMISSION);
            isBPUser=cpr.hasPermission(IPM_ConstantUtils.IPM_BUSINESSPARTNER_PERMISSION);
            if(isCentralTeam || isBPUser){
                isProjectEditable=true;
                isBossCardEditable=true;
            }        
        }   
        if(isProjectEditable || isBossCardEditable){
            isEditable=true;
        }
    }
    
    public class IPM_GeoWrapper {
    
    private Map<String, Set<String>> clusterMCOMap; //internally used map to store mcos cluster wise
    //private Map<String, MDO_Geography__c[]> mcoCountryMap;//internally used map to store countries mco wise
    private list<IPM_ClusterMCO> clusterMCOWrapperList;//final returning variable to the external classes from a method
    
    //constructor
    public IPM_GeoWrapper() {
        
        //initialise them!
        clusterMCOMap = new Map<String, Set<String>>();
        //mcoCountryMap = new Map<String, MDO_Geography__c[]>();
    }
    
    /*******************************************************************************************************
    * @description: the getter of the clusterMCOwrapper 
    * @returns : wrapped list of clusterMCOs
    */
    public list<IPM_ClusterMCO> getclusterMCOWrapper() {
      list<IPM_MCO> mcoList;
      for(MDO_Geography__c geography : [SELECT  Name, parent_L2__c, geography_type__c, parent_L2__r.Name,Status__c FROM MDO_Geography__c limit 1000]){
      }
      
      list<MDO_Geography__c> goegraphiesMCO = [SELECT  Name, parent_L2__r.Name
                                               FROM MDO_Geography__c where geography_type__c = 'Country Group' and Status__c = 'Active' and parent_L2__c <> ''
                                               LIMIT 500];//extract the data from the master-data object MDO_Geography__c
        for(MDO_Geography__c eachCountry : goegraphiesMCO) { //Add Clusters
            if(!clusterMCOMap.containsKey(eachCountry.parent_L2__r.Name)) {
                Set<String> tmpLst = new Set<String>();
                tmpLst.add(eachCountry.Name);
                clusterMCOMap.put(eachCountry.parent_L2__r.Name, tmpLst);
            } else {
                clusterMCOMap.get(eachCountry.parent_L2__r.Name).add(eachCountry.Name);
            }
        }
        
        list<MDO_Geography__c> goegraphiesCountry = [SELECT  Name, parent_L2__r.Name
                                               FROM MDO_Geography__c where geography_type__c = 'Country' and Status__c = 'Active' and parent_L2__c <> ''
                                               LIMIT 500];//extract the data from the master-data object MDO_Geography__c
        clusterMCOWrapperList = new list<IPM_ClusterMCO>();//this is clustermcowrapper list used internally
        String[] sortedCluster = new list<String>();//sorted Clusters which would help us in definning them on the page.
        sortedCluster.addAll(clusterMCOMap.keySet());
        sortedCluster.sort();//sort them
        
        // Now that we have all information in various variables, now lets try to club 'em together to make a 3-tier Cluster-->MCO-->Country wrapper
        for(String eachCluster : sortedCluster) {
            mcoList = new list<IPM_MCO>();
            for(String eachMCO : IPM_Utils.convertSetToSortedList(clusterMCOMap.get(eachCluster))) {
                MDO_Geography__c[] countryList = new list<MDO_Geography__c>();
                for(MDO_Geography__c eachCountry : goegraphiesCountry) {
                    if(eachMCO == eachCountry.parent_L2__r.Name) {
                        countryList.add(eachCountry);
                    }
                }
                mcoList.add(new IPM_MCO(eachMCO, countryList));
            }
            clusterMCOWrapperList.add(new IPM_ClusterMCO(eachCluster, mcoList));
        }
        mcoList = new list<IPM_MCO>();
        clusterMCOWrapperList.add(new IPM_ClusterMCO('Unassigned', mcoList));
        return clusterMCOWrapperList;
    }
    }
    
    /***************************************************************
    * @description: wrapper class which will contain cluster-MCOs
    */
    public class IPM_ClusterMCO{
        
        public String clusterName {get; set;}//name of the cluster
        public list<IPM_MCO> mcos {get; set;}//mco list associated to a cluster
 
        public IPM_ClusterMCO(String c, list<IPM_MCO> mS) {
            clusterName = c;
            mcos = mS;
        }
    }
    
     /***************************************************************
    * @description: wrapper class which will contain mco-countries
    */
    public class IPM_MCO {
        
        public String mcoName {get; set;}//mco Name
        public list<MDO_Geography__c> countries {get; set;}//countries associated to that mco
 
        public IPM_MCO(String m, list<MDO_Geography__c> cS) {
            mcoName = m;
            countries = cS;
        }
    } 
}