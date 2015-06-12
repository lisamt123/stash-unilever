public without sharing class ipmRolloutPlansTableController{
    public String projectId {get; set;}
    public IPM_Project__c project {get; set;}
    public IPM_Project_Rollout__c projRoll{get; set;}
    public boolean isEditable{get;set;}

    public List<IPM_Project_Rollout__c> lstRegionalRollouts {get; set;}
    public List<IPM_Project__c> lstRegionalProjects {get; set;}
    public Map<Id, List<Ipm_Country__c>> mapLocalRolloutCountryMapping {get; set;}

    private Set<String> setRegionalProjectNames {get; set;}

    public String selectedMCORollout {get; set;}

    public Boolean isEditMode {get; set;}

    //For Auto-Filling Project Leaders
    public List<IPM_User_Profile__c> listPL{get;set;}
    public List<IPM_User_Profile__c> listFL{get;set;}
    
    private List<IPM_Project__c> lstUpsertLocalProjects;

    //For Updating PL&FL
    private Map<String,Id> plNameMap;
    private Map<String,Id> flNameMap;

    private String REGIONAL_ROLLOUT_RECORDTYPE;
    private String LOCAL_ROLLOUT_RECORDTYPE;

    private static String ROLLOUT_TYPE_MCO = 'MCO';
    private static String ROLLOUT_TYPE_COUNTRY = 'Country';
    
    private static String PROJECT_SPAN_GLOBAL = 'Global';
    private static String PROJECT_SPAN_REGIONAL = 'Regional';
    private static String PROJECT_SPAN_LOCAL = 'Local';

    public ipmRolloutPlansTableController(){
        initialise();
    }
    
    public PageReference checkRollouts(){
        //initialise();
        String cancelRedirect = ApexPages.currentPage().getParameters().get('cancelRedirect');
        if((lstRegionalRollouts.size() <= 0) && (lstRegionalProjects.size() <= 0) && (cancelRedirect != 'true'))
            return addRollout();

        return null;
    }
    
    private void initialise(){
        projectId = ApexPages.currentPage().getParameters().get('Id');
        isEditable=false;
        getIpmuserType();
        if (projectId != null){
            project = [SELECT Id, Deputy_Project_Leader__c, IPMCompany__c, IPM_Clustering__c, IPMPlatform__c, IPMProject_Span__c, IPMProject_Type__c, IPMRegion__c, IPM_Answer_of_Q1__c, IPM_Answer_of_Q2__c, IPM_Answer_of_Q3__c, IPM_Approver_of_Charter__c, IPM_Approver_of_Contract_Market_Ready__c, IPM_Bosscard_Status__c, IPM_Bosscard__c, IPM_Brand_Positioning__c, IPM_Brand__c, IPM_Category_Group__c, IPM_Category_Icon__c,IPM_Category_Text__c,IPM_Category__c,IPM_Company_Card__c,IPM_Complexity__c,IPM_Core_Parameters__c,IPM_CPP_Change_Reason__c,IPM_CPP__c,IPM_Fast_Track_Project__c,IPM_FilledIn_Percentage__c,IPM_Finance_Member__c,IPM_GateKeeping_Model__c,IPM_Gate_Keeping_Module__c,IPM_IsCompleted__c,IPM_Market_Type__c,IPM_Market__c,IPM_Parent_Project__c,IPM_Phase__c,IPM_PM_Approach__c,IPM_Project_Description__c,IPM_Project_Gatekeeper__c,IPM_Project_Leader__c,IPM_Project_Logo_Id__c,IPM_Project_Logo__c,IPM_Project_Name__c,IPM_Project_Type__c,IPM_Sector__c,IPM_Strategic_Intent__c,IPM_Sub_Category__c,IPM_Sub_sector__c,IPM_Target_Launch_Dates__c,IPM_Target_Launch_Date__c,IPM_Technical_Project_Leader__c,IPM_UserCategory__c,Is_Archieved__c,Name,Sustainability_Period__c, 
                            (SELECT Id, IPM_Project_Name__c FROM IPM_Projects__r),
                            (SELECT Id, IPM_Document_Status__c, IPM_GateDocuments__c, IPM_Project__c, IPM_Project_Template__c, IPM_Project__r.IPMProject_Span__c, IPM_Project__r.IPM_Project_Name__c FROM Project_Documents__r)
                        FROM IPM_Project__c 
                        WHERE Id=:projectId];
            getProjectRollouts();
            getUserList();
            isEditMode = false;
        }
    }
    
    private void getUserList(){
        //For Autofilling Regional PL and Financial Lead
        listPL = [SELECT IPM_User__c, IPM_User__r.Name 
                    FROM IPM_User_Profile__c 
                    WHERE  IPM_User__r.IsActive = true 
                        AND IPM_User__r.User_License__c = 'Salesforce' 
                        AND IPM_User_Function__c = 'Project Leader'];
        listFL = [SELECT IPM_User__c, IPM_User__r.Name 
                    FROM IPM_User_Profile__c 
                    WHERE IPM_User__r.IsActive = true 
                        AND IPM_User__r.User_License__c = 'Salesforce' 
                        AND IPM_User_Role__c = 'Finance'];

        plNameMap=new Map<String,Id>();
        flNameMap=new Map<String,Id>();

        for(IPM_User_Profile__c userProfile : listPL)
            plNameMap.put(userProfile.IPM_User__r.Name, userProfile.IPM_User__c);

        for(IPM_User_Profile__c userProfile : listFL)
            flNameMap.put(userProfile.IPM_User__r.Name, userProfile.IPM_User__c);
    }
    
    private void getProjectRollouts(){
        REGIONAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Regional Rollout').getRecordTypeId();
        LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
        
        getRegionalProjectsGlobal();
        getRegionalRollouts();
        getLocalCountries();
    }
    
    private void getRegionalProjectsGlobal(){
        lstRegionalProjects = new List<IPM_Project__c>();
        setRegionalProjectNames = new Set<String>();

        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            String projectNameLike = project.IPM_Project_Name__c + '%';
            String queryString = 'SELECT Id, Name, IPM_Project_Name__c, IPM_Target_Launch_Dates__c, IPM_Project_Leader__c, IPM_Finance_Member__c, ';
            //Rollouts
            queryString+= '(SELECT ';
            For (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet()){
                if (field != 'Id')
                    queryString+= field + ', ';
            }
            queryString+= 'Id, Local_Project__r.IPM_Project_Leader__c, Local_Project__r.IPM_Finance_Member__c FROM Regional_Project_Rollout__r)';
            queryString+= ' FROM IPM_Project__c WHERE IPM_Project_Name__c LIKE: projectNameLike AND IPMProject_Span__c =: PROJECT_SPAN_REGIONAL';
            lstRegionalProjects = Database.query(queryString);
            
            For(IPM_Project__c regionalProject : lstRegionalProjects)
                setRegionalProjectNames.add(regionalProject.IPM_Project_Name__c);

        }
    }
    
    private void getRegionalRollouts(){
        String nullRegionalProject = null;
        String queryString = 'SELECT ';
        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            //IPM PROJECT ROLLOUT
            For (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet()){
                queryString+= field + ', ';
            }
            queryString+= '(SELECT ';
            For (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet()){
                if (field != 'Id')
                    queryString+= field + ', ';
            }
            queryString+= 'Id FROM Local_Rollouts__r';
            queryString+= ' WHERE Regional_Project__c =: nullRegionalProject), ';
            queryString+= 'IPM_Project__r.IPM_Phase__c FROM IPM_Project_Rollout__c WHERE IPM_Project__c =: projectId AND RecordTypeId =: REGIONAL_ROLLOUT_RECORDTYPE AND (NOT IPM_Rollout_Project__c IN: setRegionalProjectNames)';
        
        } else if(project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
            //IPM PROJECT ROLLOUT
            For (String field : Schema.SObjectType.IPM_Project_Rollout__c.fields.getMap().KeySet()){
                if (field != 'Id')
                    queryString+= field + ', ';
            }
            queryString+= 'Id FROM IPM_Project_Rollout__c WHERE Regional_Project__c =: projectId AND RecordTypeId =: LOCAL_ROLLOUT_RECORDTYPE';
        }       
        
        lstRegionalRollouts = Database.query(queryString);
    }
    
    private void getLocalCountries(){
        //IPM COUNTRIES
        String queryString = 'SELECT ';
        For (String field : Schema.SObjectType.IPM_Country__c.fields.getMap().KeySet()){
            if (field != 'Id')
                queryString+= field + ', ';
        }

        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL)
            queryString+= 'Id FROM IPM_Country__c WHERE IPM_Project__c =: projectId';
        else if(project.IPMProject_Span__c==PROJECT_SPAN_REGIONAL)
            queryString+= 'Id FROM IPM_Country__c WHERE IPM_Regional_Project__c =: projectId';

        mapLocalRolloutCountryMapping = new Map<Id, List<Ipm_Country__c>>();
        For(IPM_Country__c country : Database.query(queryString)){
            List<Ipm_Country__c> lstChildCountries = new List<Ipm_Country__c>();
            If(mapLocalRolloutCountryMapping.containsKey(country.Local_Rollout__c))
                lstChildCountries = mapLocalRolloutCountryMapping.get(country.Local_Rollout__c);
            
            lstChildCountries.add(country);
            mapLocalRolloutCountryMapping.put(country.Local_Rollout__c, lstChildCountries);
        }
    }
          
    public PageReference addRollout(){
        PageReference addRollouts;
        if(project.IPMProject_Span__c == PROJECT_SPAN_GLOBAL){
            addRollouts = Page.ipmRolloutPlansAdd;
            addRollouts.getParameters().put('id', projectId);                
            addRollouts.setRedirect(true);
        } else if(project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
            addRollouts = Page.ipmRolloutPlansRegional;
            addRollouts.getParameters().put('id', projectId);                
            addRollouts.setRedirect(true);
        }
        return addRollouts;
    }

    public void editRollout(){
    }

    /*For Saving Regional PL and Finance Member*/
    public void saveRollout(){
        lstUpsertLocalProjects = new List<IPM_Project__c>();
        List<IPM_Financial__c> lstUpsertFinancials = new List<IPM_Financial__c>();
        List<IPM_Country__c> lstUpdateCountries = new List<IPM_Country__c>();
        Set<Id> setProjectIdsForRegionalProjects = new Set<Id>();

        List<IPM_Project__c> lstRegionalProjects = new List<IPM_Project__c>();
        
        Set<String> setChildProjectNames = new Set<String>();
        For(IPM_Project__c childProject : project.IPM_Projects__r)
            setChildProjectNames.add(childProject.IPM_Project_Name__c);
        
        List<IPM_Project_Rollout__c> lstRegionalRolloutsForRegionalProjects = new List<IPM_Project_Rollout__c>();
        For(IPM_Project_Rollout__c ipmRollout : lstRegionalRollouts){
            Id plUserId = null;
            Id finUserId = null;
            iF(ipmRollout.IPM_Regional_PL_Text__c != null && ipmRollout.IPM_Regional_PL_Text__c != ''){
                if(plNameMap.containsKey(ipmRollout.IPM_Regional_PL_Text__c)){
                    ipmRollout.IPM_Regional_PL__c = plNameMap.get(ipmRollout.IPM_Regional_PL_Text__c);

                    //Regional Rollout (Convert to Projects)
                    if(!setChildProjectNames.contains(ipmRollout.IPM_Rollout_Project__c)){
                        if(ipmRollout.IPM_Project__r.IPM_Phase__c != 'Ideas')
                            lstRegionalRolloutsForRegionalProjects.add(ipmRollout);
                    }

                    //Local Rollouts (Convert to Projects)
                    if(project.IPMProject_Span__c == PROJECT_SPAN_REGIONAL){
                        plUserId = plNameMap.get(ipmRollout.IPM_Regional_PL_Text__c);
                        ipmRollout.Local_Project__r = new IPM_Project__c(IPM_Project_Name__c = ipmRollout.IPM_Rollout_Project__c);
                        
                        //Financial
                        lstUpsertFinancials.add(
                            new IPM_Financial__c(
                                Financial_External_Id__c = ipmRollout.IPM_Rollout_Project__c,
                                Local_Project__r = new IPM_Project__c(IPM_Project_Name__c = ipmRollout.IPM_Rollout_Project__c),
                                Copy_Regional_to_Local__c = TRUE
                            )
                        );
                        
                        //Country
                        For(IPM_Country__c ipmCountry : ipmRollout.IPM_Countries_Local__r){
                            ipmCountry.IPM_Local_Project__r = new IPM_Project__c(IPM_Project_Name__c = ipmRollout.IPM_Rollout_Project__c);
                            lstUpdateCountries.add(ipmCountry);
                        }
                    }
                }else{
                    ipmRollout.IPM_Regional_PL__c = null;
                    ipmRollout.IPM_Regional_PL_Text__c = '';
                }
            }

            if(ipmRollout.IPM_Finance_Member_Text__c != null && ipmRollout.IPM_Finance_Member_Text__c != ''){
                if(flNameMap.containsKey(ipmRollout.IPM_Finance_Member_Text__c)){
                    ipmRollout.Finance_Member__c = flNameMap.get(ipmRollout.IPM_Finance_Member_Text__c);
                    finUserId = plNameMap.get(ipmRollout.IPM_Finance_Member_Text__c);
                }else{
                    ipmRollout.Finance_Member__c = null;
                    ipmRollout.IPM_Finance_Member_Text__c = '';
                }
            }

            if(plUserId != null){
                processLocalRollouts(ipmRollout, plUserId, finUserId);
            }
        }
        
        if(lstUpsertLocalProjects.size() > 0)
            Database.upsert(lstUpsertLocalProjects, IPM_Project__c.IPM_Project_Name__c);
        
        if(lstUpsertFinancials.size() > 0)
            Database.upsert(lstUpsertFinancials, IPM_Financial__c.Financial_External_Id__c);
        
        if(lstUpdateCountries.size() > 0)
            update lstUpdateCountries;

        update lstRegionalRollouts;
        
        if(lstRegionalRolloutsForRegionalProjects.size() > 0){
            //Create Projects
            Database.upsert(IPM_CreateRolloutProjects.processRollouts(project, lstRegionalRolloutsForRegionalProjects), IPM_Project__c.IPM_Project_Name__c, false);

            //Create Contract Gate Document
            System.debug(project.Project_Documents__r+'project.Project_Documents__r');
            //Create Contract Document for Regional project only when the Global User is creating
            if(project.IPMProject_Span__c=='Global')   //06-04-2015 Added By Kannan
            IPM_CreateGateDocuments.createContractDocument(project.Project_Documents__r, project.IPM_GateKeeping_Model__c);

            //Financials
            Set<Id> setProjectDocumentIds = new Set<Id>();
            For(IPM_Project_Document__c projectDocument : project.Project_Documents__r)
                setProjectDocumentIds.add(projectDocument.Id);

            IPMProcessFinancials.processDocumentApprovalFinancials(setProjectDocumentIds);
        }
        
        getProjectRollouts();
    }
    
    private void processLocalRollouts(IPM_Project_Rollout__c localRollout, Id plUserId, Id finUserId){
        lstUpsertLocalProjects.add(
            new IPM_Project__c(
                IPM_Project_Name__c = localRollout.IPM_Rollout_Project__c,
                Market_Cluster__c = localRollout.Market_Cluster__c,
                IPM_Local_Project_Type__c = localRollout.Type__c,
                IPM_Target_Launch_Dates__c = localRollout.Target_Launch_Date__c,
                IPM_Parent_Project__c = project.Id,
                IPM_Project_Leader__c = plUserId,
                IPM_Finance_Member__c = finUserId,
                IPMProject_Span__c = PROJECT_SPAN_LOCAL,
                IPM_Brand_Positioning__c = project.IPM_Brand_Positioning__c,
                IPM_Brand__c = project.IPM_Brand__c,
                IPM_Category_Group__c = project.IPM_Category_Group__c,
                IPM_Category_Text__c = project.IPM_Category_Text__c,
                IPMCompany__c = project.IPMCompany__c,
                IPM_Market__c = project.IPM_Market__c,
                IPMPlatform__c = project.IPMPlatform__c,
                IPM_Sector__c = project.IPM_Sector__c,
                IPM_Sub_sector__c = project.IPM_Sub_sector__c,
                IPM_Answer_of_Q1__c = project.IPM_Answer_of_Q1__c,
                IPM_Answer_of_Q2__c = project.IPM_Answer_of_Q2__c,
                IPM_Answer_of_Q3__c = project.IPM_Answer_of_Q3__c,
                IPM_Complexity__c = project.IPM_Complexity__c,
                IPM_GateKeeping_Model__c = project.IPM_GateKeeping_Model__c,
                IPM_PM_Approach__c = project.IPM_PM_Approach__c,
                IPM_Phase__c = project.IPM_Phase__c,
                IPM_IsCompleted__c = project.IPM_IsCompleted__c,
                IPM_Strategic_Intent__c = project.IPM_Strategic_Intent__c,
                IPM_Market_Type__c = project.IPM_Market_Type__c,
                IPM_Company_Card__c = project.IPM_Company_Card__c,
                IPM_Fast_Track_Project__c = project.IPM_Fast_Track_Project__c,
                IPM_Approver_of_Contract_Market_Ready__c = project.IPM_Approver_of_Contract_Market_Ready__c,
                IPM_Approver_of_Charter__c = project.IPM_Approver_of_Charter__c,
                Sustainability_Period__c = project.Sustainability_Period__c,
                IPM_Project_Logo__c = project.IPM_Project_Logo__c,
                IPM_Project_Logo_Id__c = project.IPM_Project_Logo_Id__c,
                IPM_Project_Description__c = project.IPM_Project_Description__c,
                IPM_Project_Type__c = 'Rollout',
                IPM_Clustering__c=project.IPM_Clustering__c,
                Market_Cluster_Name__c = localRollout.Market_Cluster_Name__c
            )
        );
    }

    public void cancelRollout(){
    }
    
    public PageReference deleteMCORollout(){
        Database.delete(new IPM_Project_Rollout__c(Id = selectedMCORollout));
        getProjectRollouts();
        return null;
    }

    //Get user type
    public void getIpmuserType(){
    list<IPM_Project__c>lstofuser=[select IPM_Project_Leader__c,Deputy_Project_Leader__c from IPM_Project__c where 
                                            (IPM_Project_Leader__c=:userinfo.getuserid() or Deputy_Project_Leader__c=:userinfo.getuserid()) and  id=:projectId limit 1];
    if(lstofuser.size()>0){
        isEditable=true;
        }
    list<PermissionSetAssignment>PermissonS=[select Assignee.Name, PermissionSet.Name
                                            from PermissionSetAssignment where (PermissionSet.Name='IPM_Central_Team' or PermissionSet.Name='IPM_Business_Partners') and Assignee.id=:userinfo.getuserid()];
     if(PermissonS.size()>0){
         isEditable=true;
     }   
    }      
    
}