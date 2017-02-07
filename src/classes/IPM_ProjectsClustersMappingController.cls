/***********************************************************************************************************************************************************
* @author Cognizant
* @date  01-02-2017
* @description For functionality to view cluster projects and modifying in standard cluster page
*/
public with sharing class IPM_ProjectsClustersMappingController {

    public Integer size{get; set;} //Total number of records used for pagination
    public final Integer size_constant = 5;
    public List<projectListWrapper> plwList{get;set;}
    public List<projectListWrapper> removalPlwList{get;set;}
    public Map<Id,IPM_Project__c> selectedProjectMap{get;set;}
    public Map<Id,IPM_Project__c> removalProjectMap{get;set;}
    public string searchProjectName{get;set;}
    public IPM_Clusters__c currentCluster{get;set;}
    
    public Id clusterId{
        get{
            if(clusterId == null && Apexpages.currentpage().getparameters().get('id') != null) {
                return  Id.valueOf(Apexpages.currentpage().getparameters().get('id')) ;
            }
            else { 
                return clusterId; 
            }
        }
        set;
    }
    
    /**************************************************************
    * @description: CONSTRUCTOR
    */
    public IPM_ProjectsClustersMappingController(ApexPages.StandardController controller) { 
        initializeVariables();
    }
    
    public void initializeVariables(){
        selectedProjectMap = new Map<Id,IPM_Project__c>();
        removalProjectMap = new Map<Id,IPM_Project__c>();
        size = size_constant;
    }
    
    public Decimal getCurrentClusterY3ito(){
        try{
            currentCluster = [SELECT Id, IPM_Sum_Y3iTO__c FROM IPM_Clusters__c WHERE Id = :clusterId];
            return currentCluster.IPM_Sum_Y3iTO__c;
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
            return null;
        }
    }
    
    /**************************************************************
    * @description: FUNCTIONALITIES FOR AVAILABLE PROJECTS
    */
    public void getSelectedProjects(){      
        try{            
            for(projectListWrapper p : plwList){
                if(p.isSelected){
                    selectedProjectMap.put(p.projectrecord.id,p.projectrecord);
                }
                else{
                    selectedProjectMap.remove(p.projectrecord.id);
                }            
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    public void clearSelectedProjects(){
        selectedProjectMap = new Map<Id,IPM_Project__c>();
    }
    
    public void processSelectedProjects(){                                              
        getSelectedProjects();
        try{
            if(selectedProjectMap!=null && !selectedProjectMap.isEmpty()){
                for(IPM_Project__c p : selectedProjectMap.values()){
                    p.IPM_Cluster__c = clusterId;
                }
                update selectedProjectMap.values();
                setConInCluster = null;
                setCon = null;
                clearSelectedProjects();
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    public integer getselectedProjectMapSize(){
        return selectedProjectMap.size();
    }
    
    /**************************************************************
    * @description: FUNCTIONALITIES FOR EXISTING PROJECTS
    */
    public void getRemovalProjects(){
        try{
            for(projectListWrapper p : removalPlwList){
                if(p.isSelected){
                    removalProjectMap.put(p.projectrecord.id,p.projectrecord);
                }
                else{
                    removalProjectMap.remove(p.projectrecord.id);
                }            
            }   
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }    
    
    public void clearRemovalProjects(){
        removalProjectMap = new Map<Id,IPM_Project__c>();
    }
    
    public void processRemovalProjects(){
        getRemovalProjects();
        try{
            if(removalProjectMap!=null && !removalProjectMap.isEmpty()){
                for(IPM_Project__c p : removalProjectMap.values()){
                    p.IPM_Cluster__c = Null;
                }
                update removalProjectMap.values();
                setConInCluster = null;
                setCon = null;
                clearRemovalProjects();
            }
        }
        catch(Exception ex){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.IPM_PLEASE_CONTACT_ADMINISTRATOR));
        }
    }
    
    public integer getremovalProjectMapSize(){
        return removalProjectMap.size();
    }
    
    /**************************************************************
    * @description: FUNCTIONALITIES FOR SEARCHING PROJECTS
    */
    
    public void searchProjects(){
        setCon = null;
        clearSelectedProjects();
    }
    
    /**************************************************************
    * @description: LOAD PROJECTS WRAPPER WITH AVAILABLE PROJECTS
    */
    public List<projectListWrapper> getProjects() {
        plwList = new List<projectListWrapper>();
        if(setCon != null){
            for(IPM_Project__c p : (List<IPM_Project__c>)setCon.getRecords()){
                if(selectedProjectMap.containsKey(p.id)){
                    plwList.add(new projectListWrapper(true,p));
                }
                else{
                    plwList.add(new projectListWrapper(false,p));
                }
            }
        } 
        return plwList;
    }
    
    /**************************************************************
    * @description: GET SOQL STRING BASED ON SEARCH CRITERIA
    */
    public string getQueryString(){
        string queryString = 'SELECT Id, IPM_Project_Name__c, IPMProject_Span__c, IPM_Project_Type__c, IPM_Cluster__c, IPM_Clusters__c, IPM_Project_Y3iTO__c '
                            +'FROM IPM_Project__c WHERE IPM_Project_Name_isNull__c=\''+ IPM_ConstantUtils.IPM_false +'\' AND IPM_Project_Name__c!=\''+ IPM_ConstantUtils.MASTER_PROJECT_NAME +'\' '
                            +'AND IPMProject_Span__c IN (\''+ IPM_ConstantUtils.PROJECT_SPAN_GLOBAL +'\', \''+ IPM_ConstantUtils.PROJECT_SPAN_REGIONAL +'\') AND IPM_Cluster__c=\'\' AND IPM_Project_Type__c=\''+ IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL +'\'';
        if(string.isNotBlank(searchProjectName)){
            queryString += ' AND IPM_Project_Name__c like \'%'+ String.escapeSingleQuotes(searchProjectName) +'%\'';
        }
        queryString += ' LIMIT 10000';
        return queryString;
    }    
    
    /**************************************************************
    * @description: Standard Set Controller for available projects
    */
    public ApexPages.StandardSetController setCon {
        get {
            if(setCon == null && clusterId != null){                
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(getQueryString()));                
                setCon.setPageSize(size);
            }
            return setCon;
        }
        set;
    }
    
    /**************************************************************
    * @description: Navigation for available projects
    */
    public void first() { 
        getSelectedProjects(); 
        setCon.first();  
    }  
    public void last() { 
        getSelectedProjects(); 
        setCon.last(); 
    }   
    public void previous(){ 
        getSelectedProjects(); 
        setCon.previous(); 
    }
    public void next(){ 
        getSelectedProjects(); 
        setCon.next(); 
    }
    public integer getnoOfRecords(){ 
        if(setCon!=null){
            return setCon.getResultSize();
        } 
        else {
            return 0;
        } 
    }
    public Boolean gethasNext(){ 
        if(setCon!=null){
            return setCon.getHasNext();
        } 
        else {
            return false;
        } 
    }
    public Boolean gethasPrevious(){ 
        if(setCon!=null){
            return setCon.getHasPrevious();
        } 
        else {
            return false;
        } 
    }
    public Integer getPageNumber(){ 
        if(setCon!=null){
            return setCon.getPageNumber();
        } 
        else {
            return 0;
        } 
    }
    
    
    /**************************************************************
    * @description: Standard Set Controller for EXISTING projects in currect cluster
    */
    public ApexPages.StandardSetController setConInCluster{
        get {
            if(setConInCluster == null && clusterId != null){
                string queryString = 'SELECT Id, IPM_Project_Name__c, IPMProject_Span__c, IPM_Project_Type__c, IPM_Cluster__c, IPM_Clusters__c, IPM_Project_Y3iTO__c '
                            +'FROM IPM_Project__c WHERE IPM_Project_Name_isNull__c=\''+ IPM_ConstantUtils.IPM_false +'\' AND IPM_Project_Name__c!=\''+ IPM_ConstantUtils.MASTER_PROJECT_NAME +'\' '
                            +'AND IPM_Cluster__c=\''+ clusterId +'\' LIMIT 10000';
                setConInCluster = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));                
                setConInCluster.setPageSize(size);
            }
            return setConInCluster;
        }
        set;
    }
    
    /**************************************************************
    * @description: LOAD PROJECTS WRAPPER WITH EXISTING PROJECTS
    */
    public List<projectListWrapper> getProjectsInCurrentCluster() {
        removalPlwList = new List<projectListWrapper>();
        if(setConInCluster != null){
            for(IPM_Project__c p : (List<IPM_Project__c>)setConInCluster.getRecords()){
                if(removalProjectMap.containsKey(p.id)){
                    removalPlwList.add(new projectListWrapper(true,p));
                }
                else{
                    removalPlwList.add(new projectListWrapper(false,p));
                }
            }
        }   
        return removalPlwList;
    }
    /**************************************************************
    * @description: Navigation for EXISTING projects in currect cluster
    */
    public void cfirst() { 
        getRemovalProjects(); 
        setConInCluster.first();  
    }  
    public void clast() { 
        getRemovalProjects(); 
        setConInCluster.last(); 
    }   
    public void cprevious(){ 
        getRemovalProjects(); 
        setConInCluster.previous(); 
    }
    public void cnext(){ 
        getRemovalProjects(); 
        setConInCluster.next(); 
    }
    public integer getcnoOfRecords(){ 
        if(setConInCluster!=null){
            return setConInCluster.getResultSize();
        } 
        else {
            return 0;
        } 
    }
    public Boolean getchasNext(){ 
        if(setConInCluster!=null){
            return setConInCluster.getHasNext();
        } 
        else {
            return false;
        } 
    }
    public Boolean getchasPrevious(){ 
        if(setConInCluster!=null){
            return setConInCluster.getHasPrevious();
        } 
        else {
            return false;
        } 
    }
    public Integer getcPageNumber(){ 
        if(setConInCluster!=null){
            return setConInCluster.getPageNumber();
        } 
        else {
            return 0;
        } 
    }
    
    /**************************************************************
    * @description: Projects wrapper for embedding checkbox
    */
    public with sharing class projectListWrapper{
        public boolean isSelected{get;set;}
        public IPM_Project__c projectrecord{get;set;}
        
        public projectListWrapper(boolean b, IPM_Project__c p){
            isSelected = b;
            projectrecord = p;
        }
    }

}