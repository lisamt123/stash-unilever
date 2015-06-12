public with sharing class IPM_ProjectSearchCtrl{
    
    public String searchTxt{get;set;}
    public List<IPM_Project__c> projects;
    public Integer allProjects{get;set;}
    public Integer myProjects{get;set;}
    public Integer bcPendings{get;set;}
    public String aProjects{get;set;}
    public String mProjects{get;set;}
    public String bPending{get;set;}
    
    public Integer iTO1{get;set;}
    public Integer iTO2{get;set;}
    
    public String geoAll{get;set;}
    public String clusters{get;set;}
    public String mcos{get;set;}
    public String countries{get;set;}
    
    private Boolean noRecords;
    public Map<String, String> currentSort{get;set;}
    public list<String> projectPhases{get;set;}
    public String selectedPhase {get;set;}
    public Map<String, Integer> phasesCountMap{get;set;}
    public String tldFrom{get;set;}
    public String tldTo{get;set;}
    public Integer size{get;set;}
    public Date tFrm;
    public Date tTo;
    public list<IPM_GeoWrapper.clusterMCO> clusterMCOList{get;set;}
    public Boolean isAsc{get;set;}
    public Integer noOfRecords{get; set;}
    public boolean isEditable{get;set;}
    public boolean isProjectEditable{get;set;}
    public boolean isBossCardEditable{get;set;}
    public IPM_ProjectSearchCtrl() {
        noRecords = false;
        isProjectEditable=true;
        isBossCardEditable=true;
        isEditable=true;
        searchTxt = '';
        iTO1 = -1;
        iTO2 = -1;
        aProjects = 'true';
        mProjects = 'true';
        bPending = 'true';
        geoAll = 'true';
        clusters = '';
        mcos = '';
        countries = '';
        tldFrom = '';
        tldTo = '';
        isAsc = false;
        IPM_GeoWrapper geoCon = new IPM_GeoWrapper();
        clusterMCOList = geoCon.getclusterMCOWrapper();
        projects = new List<IPM_Project__c>();
        currentSort = new Map<String, String>{'thisFld' => 'IPM_Project_Name__c'};
        phasesCountMap = new Map<String, Integer>();
        projectPhases = new list<String>();
        projectPhases.addAll(IPM_Utils.getPicklistValues(new IPM_Project__c(), 'IPM_Phase__c'));
        allProjects = 0;myProjects = 0;bcPendings=0;
        projects = new List<IPM_Project__c>();
        for(String eachPhase : projectPhases) {
            phasesCountMap.put(eachPhase, 0);
        }
        for(IPM_Project__c eachProject : Database.query(query())) {
            myProjects = eachProject.OwnerId == Userinfo.getUserId() ? myProjects+1 : myProjects;
            bcPendings = eachProject.IPM_Bosscard__c != null && eachProject.IPM_Bosscard_Status__c == false ? bcPendings+1 : bcPendings;
            system.debug(eachProject.IPM_Bosscard__c + ' ** bcPendings constructor : ' + bcPendings + ' ' + eachProject.IPM_Bosscard_Status__c);
            allProjects++;
            Integer cnt = phasesCountMap != null && phasesCountMap.get(eachProject.IPM_Phase__c) != null ? phasesCountMap.get(eachProject.IPM_Phase__c)+1 : 0;
            phasesCountMap.put(eachProject.IPM_Phase__c, cnt);
        }
    getusertype();
    }
    
    public void loadProjects() {
        noRecords = true;
        getProjects();
        refresh();
    }
     
    public List<IPM_Project__c> getProjects() {
        
        allProjects = 0;myProjects = 0;bcPendings=0;
        projects = new List<IPM_Project__c>();
        for(String eachPhase : projectPhases) {
            phasesCountMap.put(eachPhase, 0);
        }
        for(IPM_Project__c eachProject : (List<IPM_Project__c>)setCon.getRecords()) {
            myProjects = eachProject.OwnerId == Userinfo.getUserId() ? myProjects+1 : myProjects;
            bcPendings = eachProject.IPM_Bosscard__c != null && eachProject.IPM_Bosscard_Status__c == false ? bcPendings+1 : bcPendings;
            system.debug('** bcPending getProject : ' + bcPendings);
            allProjects++;
            Integer cnt = phasesCountMap != null && phasesCountMap.get(eachProject.IPM_Phase__c) != null ? phasesCountMap.get(eachProject.IPM_Phase__c)+1 : 0;
            phasesCountMap.put(eachProject.IPM_Phase__c, cnt);
            projects.add(eachProject);  
        }
        
        return projects;
    }
    
    public Integer getPageNumber(){
        return setCon.getPageNumber();
    }
    
    public Integer getTotalPages(){
 
        Decimal totalSize = setCon.getResultSize();
        Decimal pageSize = setCon.getPageSize();
        Decimal pages = totalSize/pageSize;
        return (Integer)pages.round(System.RoundingMode.CEILING);
    }
    
    private string query() {
        
        system.debug('** tldFrom ' + tldFrom + ' ' + tldTo);
        if(tldFrom != '' && tldTo != '') {
            try{
                String[] tldFrm = tldFrom.split('-');   
                String[] tldT = tldTo.split('-');
                tFrm = Date.newInstance(Integer.valueOf(tldFrm[2]), IPM_Utils.monthMap.get(tldFrm[1]), Integer.valueOf(tldFrm[0]));    
                tTo = Date.newInstance(Integer.valueOf(tldT[2]), IPM_Utils.monthMap.get(tldT[1]), Integer.valueOf(tldT[0]));   
            }catch(exception e){
                tFrm = Date.newInstance(2010, 12, 12);  
                tTo = Date.newInstance(2030, 12, 12);   
            }
        }
        String soql  =  'SELECT IPM_Project_Name__c,IPM_Phase__c, IPM_Project_Leader__r.Name, IPM_Project_Gatekeeper__r.Name,ownerId,IPM_Bosscard__r.IPM_Bosscard_Logo__c,';
               soql +=  'IPM_Sub_Category__c,IPM_Category_Text__c,IPM_Project_Logo__c,IPM_Bosscard__c,IPM_Bosscard_Status__c, IPM_Bosscard__r.Name,';
               soql +=  '(SELECT Year3_ITO__c FROM IPM_Financials_Consolidated__r WHERE RecordTypeId = \'' + IPM_Utils.getFinancialRecordType('Consolidated') + '\' LIMIT 1),';
               soql += 'IPM_Target_Launch_Dates__c,IPM_Project_Description__c, (Select Country_Name__c From IPM_Countries__r) FROM IPM_Project__c ';
               soql += 'WHERE Id != NULL ';
               
       if(searchTxt != '') {
           noRecords = false;
           soql += ' AND (IPM_Project_Name__c LIKE \'%' + searchTxt + '%\' OR IPM_Project_Leader__r.Name LIKE \'%' + searchTxt + '%\'';
           soql += ' OR IPM_Bosscard__r.Name LIKE \'%' + searchTxt + '%\'';
           soql += ' OR IPM_Project_Description__c LIKE \'%' + searchTxt + '%\' OR IPM_Phase__c LIKE \'%' + searchTxt + '%\')';
       } 
       if(mProjects == 'true' && aProjects != 'true') {
           soql += ' AND OwnerId = \'' + UserInfo.getUserId() + '\'';
           noRecords = false;
       } 
       
       if(bPending == 'true' && aProjects != 'true') {
           soql += ' AND IPM_Bosscard__c != NULL AND IPM_Bosscard_Status__c = FALSE ';
           noRecords = false;
       } 
       
       if(geoAll != 'true' && countryWiseProjects() != null) {
            noRecords = false;
            soql += ' AND Id IN ' + countryWiseProjects();
       } 
       
       system.debug('** iTO1 + ' + iTO1 + ' iTO2 ' + iTO2);
       if(iTO1 >= 0 && iTO2 >= 0 && iTOWiseSearch() != null) {
            noRecords = false;
            soql += ' AND Id IN ' + iTOWiseSearch();
       }
       
       if(selectedPhase != null && IPM_Utils.convertStrToSoqlList(selectedPhase) != null) {
           noRecords = false;
           soql += ' AND IPM_Phase__c IN ' + IPM_Utils.convertStrToSoqlList(selectedPhase);
       }
       if(tldFrom != '' && tldTo != '') {
           noRecords = false;
           String fDt = DateTime.newInstance(tFrm, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
           String tDt = DateTime.newInstance(tTo, Time.newInstance(0, 0, 0, 0)).format('yyyy-MM-dd');
           soql += 'AND IPM_Target_Launch_Dates__c >=' + fDt;
           soql +=  ' AND IPM_Target_Launch_Dates__c <=' +  tDt;
       }
       if(noRecords) {
            soql +=  ' AND Id = NULL ';
       }
       if(isAsc) {
           soql += ' ORDER BY ' + currentSort.get('thisFld') + ' DESC NULLS LAST';
        } else {
           soql += ' ORDER BY ' + currentSort.get('thisFld') + ' ASC NULLS LAST';
        }
       soql += ' LIMIT 9999';
       system.debug('** soql : ' + soql);
       system.debug(noRecords + '** countryWiseProjects() : ' + countryWiseProjects());
       
       return soql;
    }
    
    private String countryWiseProjects() {
        
        String strToReturn;
        String[] clusterList = IPM_Utils.convertJSArrayToLsArray(clusters);
        String[] mcoList = IPM_Utils.convertJSArrayToLsArray(mcos);
        String[] countryList = IPM_Utils.convertJSArrayToLsArray(countries);
        Set<String> projectIds = new Set<String>();
        
        system.debug('** clusterList : ' + clusterList);
        system.debug('** mcoList : ' + mcoList);
        system.debug('** countryList : ' + countryList);
        if(clusterList.size() > 0 || mcoList.size() > 0 || countryList.size() > 0 ) {
            IPM_Country__c[] countryLst = [SELECT IPM_Project__c
                                              FROM IPM_Country__c 
                                              WHERE Geography__r.Country_Cluster__c IN :mcoList
                                                    OR Geography__r.Unilever_Cluster__c IN :clusterList
                                                    OR Geography__r.ISO_Country_Dependency_Name__c IN :countryList];
            for(IPM_Country__c eachCountry : countryLst) {
                projectIds.add(eachCountry.IPM_Project__c);
            }
        }
        
        strToReturn = IPM_Utils.convertSetToString(projectIds); 
        return IPM_Utils.convertStrToSoqlList(strToReturn);
    }
    
    private String iTOWiseSearch() {
        
        String strToReturn;
        Set<String> projectIds = new Set<String>();
        
        system.debug('** iTO1 + ' + iTO1 + ' iTO2 ' + iTO2);
        if(iTO1 >= 0 || iTO2 >= 0) {
            IPM_Financial__c[] financials = [SELECT Parent_Project__c
                                          FROM IPM_Financial__c 
                                          WHERE Year3_ITO__c >= :iTO1 AND Year3_ITO__c <= :iTO2
                                                AND RecordTypeId = :IPM_Utils.getFinancialRecordType('Consolidated')];
            for(IPM_Financial__c eachFin : financials) {
                projectIds.add(eachFin.Parent_Project__c);
            }
        }
        
        strToReturn = IPM_Utils.convertSetToString(projectIds); 
        return IPM_Utils.convertStrToSoqlList(strToReturn);
    }
    
    public void toggleSortProjects() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Project_Name__c');
        getProjects();
        refresh();
    }
    
    public void toggleSortPhases() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Phase__c');
        getProjects();
        refresh();
    }
    
    public void toggleSortPLs() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Project_Leader__r.Name');
        getProjects();
        refresh();
    }
    
    public void toggleSortGKs() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Project_Gatekeeper__r.Name');
        getProjects();
        refresh();
    }
    
    public void toggleSortITOs() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Project_Name__c');
        getProjects();
        refresh();
    }
    
    public void toggleSortTLDs() {
        
        isAsc = isAsc == true ? false : true;
        currentSort.put('thisFld', 'IPM_Target_Launch_Dates__c');
        getProjects();
        refresh();
    }
    
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null){
                size = 20;
                string queryString = query();
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                allProjects = 0;myProjects = 0;bcPendings=0;
                for(String eachPhase : projectPhases) {
                    phasesCountMap.put(eachPhase, 0);
                }
                for(IPM_Project__c eachProject : (List<IPM_Project__c>)setCon.getRecords()) {
                    myProjects = eachProject.OwnerId == Userinfo.getUserId() ? myProjects+1 : myProjects;
                    bcPendings = eachProject.IPM_Bosscard__c != null && eachProject.IPM_Bosscard_Status__c == false ? bcPendings+1 : bcPendings;
                    system.debug('** bcPending setCon : ' + bcPendings);
                    allProjects++;
                    Integer cnt = phasesCountMap != null && phasesCountMap.get(eachProject.IPM_Phase__c) != null ? 
                                      phasesCountMap.get(eachProject.IPM_Phase__c)+1 : 0;
                    phasesCountMap.put(eachProject.IPM_Phase__c, cnt);
                }
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();

            }
            return setCon;
        }
        set;
    }
    
    public void first() {
        setCon.first();
    }
  
    public void last() {
        setCon.last();
    }
     
    public Boolean hasNext{
        get{ 
            return setCon.getHasNext();
        }
        set;
    }
    
    public pageReference refresh() {
        setCon = null;
        getProjects();
        setCon.setPageNumber(1);
        return null;
    }
 
    public Boolean hasPrevious{
        get{
            return setCon.getHasPrevious();
        }
        set;
    }
 
    public Integer pageNumber{
        get{
            return setCon.getPageNumber();
        }
        set;
    }

    public void previous(){
        setCon.previous();
    }

    public void next(){
        setCon.next();
    }
//get usertype 
public void getusertype(){
list<IPM_User_Profile__c>lstuserprofile=[select id,IPM_User_Role__c,IPM_User_Function__c,Export_Porfolio_Data__c from IPM_User_Profile__c where IPM_User__c=:userinfo.getuserid() and (IPM_User_Role__c!=null or IPM_User_Function__c!=null)];
system.debug('lstuserprofile....'+lstuserprofile);
if(lstuserprofile.size()>0){
    for(IPM_User_Profile__c up:lstuserprofile){
    if(up.IPM_User_Role__c =='BD' || up.IPM_User_Role__c =='CMI'|| up.IPM_User_Role__c =='CD' || up.IPM_User_Role__c =='Finance'|| up.IPM_User_Role__c =='Supply Chain' || up.IPM_User_Role__c =='R&D' || up.IPM_User_Function__c =='Gatekeeper' || up.Export_Porfolio_Data__c ==true){
    IsProjectEditable=false;
    }
    if(up.Export_Porfolio_Data__c ==true){
    isBossCardEditable=false;
    }else{
    isBossCardEditable=true;
    }
    if(up.IPM_User_Function__c=='Project Leader'){
        isProjectEditable=true;
        isBossCardEditable=true;
    }
    }
}else{
 isProjectEditable=false;
 isBossCardEditable=false;
}
list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                        from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
 if(PermissonS.size()>0){
 isProjectEditable=true;
 isBossCardEditable=true;
 }   

if(isProjectEditable==true && isBossCardEditable==true){
//projectLabel='Create new project';
}
else if(isProjectEditable==false && isBossCardEditable==true){
//projectLabel='Create new bosscard';
}
} 
}