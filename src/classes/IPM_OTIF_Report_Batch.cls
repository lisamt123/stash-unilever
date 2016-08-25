/***********************************************************************************************************
    @Description : This class is used to execute the IPM_OTIF_Report_Batch job to copy project details to
                   analytics OTIF object for the OTIF report.
    @Created Date: 15/03/2015
    @Author: Cognizant
    @Referenced: IPM_OTIF_Batch
    This class has been declared as Global as it implements Database.Batchable interface.
    This class is declared as 'without sharing' - As report needs to run without sharing as it needs to look at all records regardless of what the running user has access to
 ************************************************************************************************************/

global without sharing class IPM_OTIF_Report_Batch implements Database.Batchable<sObject> {   
    global final String query;   
    global map<id,IPM_Project__c> projectIdMap = new map<id,IPM_Project__c>(); 
    global list<IPM_Project__c> scopeProjectList = new list<IPM_Project__c>();   
    global set<id> projectIdSet = new set<id>();
    global set<id> rolloutprojectIdSet = new set<id>();
    global map<Id,list<IPM_Project_Rollout__c>> projRolloutMap; 
    global map<string,list<IPM_Financial_Year__c>> rolloutFinancialYearmap;   
    global map<id,list<IPM_Financial__c>> rolloutFinancialmap;
    global map<string,IPM_Financial__c> businessImpactMap= new map<string,IPM_Financial__c>();
    global map<Id,list<IPM_Project_Document__c>> projGateDocumentMap;
    global map<Id,list<IPM_Milestone__c>> projMilestoneMap;
    
    global Map<Id, IPM_Financial__c> projFinMap = new Map<Id, IPM_Financial__c> ();
    global Map<String, List<IPM_Financial_Year__c>> projFinYrMap =new map<String, List<IPM_Financial_Year__c>>();
    global set<id> financialIdSet = new set<id>();
    global set<id> regionalRolloutset = new set<id> ();
    global Map<Id, IPM_Financial__c> regionalProjNKFinMap = new Map<Id, IPM_Financial__c> ();
    global set<id> finIdSet = new set<id>();
    
    global list<IPM_Analytics_OTIF__c> analyticRecList; 
    global set<id> localRolloutIDSet = new set<id>();
    global Map<Id, String> ipmCountryMap = new map<Id, String>();
    public static final String OTIF_REPORT_RUNDATE='OTIF Report'; //To fetch BB BD Report last run date from custom setting
    public static String CLASS_NAME = IPM_OTIF_Report_Batch.class.getName();
    public static string METHOD_NAME='execute';
    public IPM_Reporting__c reportcs = IPM_Reporting__c.getValues(OTIF_REPORT_RUNDATE); 
    public static final Id REGIONAL_ROLLOUT_RECTYPE = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
    public static final Id LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
    public static final Id CONSOLIDATED_RECTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();
    public static final Id DEFAULT_RECTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Default').getRecordTypeId();
    private Map<Integer,String> monthNameIntegerToString = new Map<Integer,String>{
        1 => 'January',
        2 => 'February',
        3 => 'March',
        4 => 'April',
        5 => 'May',
        6 => 'June',
        7 => 'July',
        8 => 'August',
        9 => 'September',
        10 => 'October',
        11 => 'November',
        12 => 'December'
    };  
           
    private static Map<String, String> fYearTOFieldMapping; // Global, Regional Turn Over field will be mapped
    private static Map<String, String> fYearGMFieldMapping; // Global, Regional Gross Profitfield will be mapped
    
    public Map<Id, Set<Id>> regRLToNKLocalRolloutMap = new Map<Id, Set<Id>>(); // This map will store Regional Rollout Id to corresponding Non key rollout ids
    
    //Contructor - @@ Param - query string from schedular class  
    global IPM_OTIF_Report_Batch(String querystr){
        query=querystr; 
    }

    //Query locator
    global Database.QueryLocator start(Database.BatchableContext BC){  
        return Database.getQueryLocator(query);
    }
    
     
    /**************************************************************************************************
     * @Description: This method is called for Each batch of records that is passed from Schedule class.
                     This method will prepare all the IPM Project records and its related records, that will be
                     used to populate the IPM Analytic records.
                     Only modified project within span of time as per custom setting data, will be inserted 
                     and existing records of these project will be deleted.
                     IPM_Analtics__c object records will be populated that will contain all the project and its related
                     information. This object will be used for reporting. 
                     
     * @return     : None       
     * @param1     : Database.BatchableContext - Reference of Database.BatchableContext
     * @param1     : List<IPM_Project__c> This parameter specifies the number of records to pass into the execute method
    ***************************************************************************************************/
    //Execute method 
    global void execute(Database.BatchableContext BC,  list<IPM_Project__c> Scope){  

        for(IPM_Project__c p:Scope){
            projectIdSet.add(p.Id);
          
                if(p.IPM_Phase__c != null)
                {
                    scopeProjectList.add(p);
                }
                projectIdMap.put(p.Id,p);               
            
        }
        // prepare Generic Maps related to Financial Year Object and Analytic object's fields API Name 
        prepareFinancialGenericTemplate();
        //Delete existing analytics records so that the changes made to the existing projects will be recorded again
        try{  
        List<IPM_Analytics_OTIF__c> analyticsRecDelList = new list<IPM_Analytics_OTIF__c>([SELECT id
                                                                                 FROM IPM_Analytics_OTIF__c WHERE IPM_Project_Id__c IN:projectIdSet Limit 10000]);
            if(!analyticsRecDelList.isEmpty()){
                delete analyticsRecDelList;
            }
        }
        catch(Exception ex)
            {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
                 
            } 
        projFinMap = fetchConsolidatedFinancialRecords(projectIdMap); //Fetching Consolidated Financial  records        
        projFinYrMap = fetchFinancialYearRecords(financialIdSet);//Fetching Financial year records
        projMilestoneMap = fetchMilestoneRecords(projectIdMap);
        /*******************Include Gatedocument related things*************/
        projGateDocumentMap = fetchGateDocumentRecords(projectIdMap);               
        map<Id,list<IPM_Project_Document_Section_Content__c>> projDocSecContentMap = fetchProjectDocumentSectionContent(projectIdMap);
        
        projRolloutMap=fetchRolloutRecords(projectIdMap);         
        fetchRolloutFinancial();
        fetchRolloutFinancialYear();
        //Fetching country records and creating map
        fetchCountryRecords();
        //End of Map creation logic ***
        //Start - Analytics Object Record Insertion 
        analyticRecList = new list<IPM_Analytics_OTIF__c>();
        for(IPM_Project__c proj:scopeProjectList){ 
            //Copyin IPM Project field values
            IPM_Analytics_OTIF__c otifAnalyticProj = new IPM_Analytics_OTIF__c();
            otifAnalyticProj = prepareAnalyticeRecord(proj,otifAnalyticProj, projDocSecContentMap);
            analyticreclist.add(otifAnalyticProj);  
            if(projRolloutMap.containskey(otifAnalyticProj.IPM_Project_Id__c)){
              List<IPM_Analytics_OTIF__c> rollAnalyticlist = new List<IPM_Analytics_OTIF__c> (addrolloutproject(otifAnalyticProj));
                if(!rollAnalyticlist.isEmpty()){
                  analyticreclist.addall(rollAnalyticlist);                
                }               
            }  
            
            // For Non Key Financials  
            if(regionalProjNKFinMap.containskey(otifAnalyticProj.IPM_Project_Id__c)){
                IPM_Financial__c nonKeyFinancial = regionalProjNKFinMap.get(otifAnalyticProj.IPM_Project_Id__c);
                IPM_Analytics_OTIF__c nonKeyrollAnalytic = addNonKeyFinancial(otifAnalyticProj, nonKeyFinancial, proj, null,projFinYrMap);
                if(nonKeyrollAnalytic != null){
                  analyticreclist.add(nonKeyrollAnalytic);                
                } 
            }
        } //End of IPM Project For loop 

        if(!analyticreclist.isEmpty()){ 
            try{
                upsert analyticreclist;

            }
            catch(Exception ex)
            {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
            } 
        }// End - Analytics Object Record Insertion 
        
    }
    
    //finish Mehtod
    global void finish(Database.BatchableContext BC){

        //sends an email for job status, after the job is completed.
        IPM_Utils.sendApexJobStatusMail(BC);    
    }
    
    private IPM_Analytics_OTIF__c prepareAnalyticeRecord(IPM_Project__c proj, IPM_Analytics_OTIF__c otifAnalytic,  map<Id,list<IPM_Project_Document_Section_Content__c>> projDocSecContentMap){
    	
        IPM_Analytics_OTIF__c otifAnalyticProj=otifAnalytic;
		otifAnalyticProj.IPM_Project_Id__c = proj.id;
       	otifAnalyticProj.IPM_Project_Name__c = proj.IPM_Project_Name__c;
		otifAnalyticProj.IPM_Project_Phantom_Non_Key__c = IPM_ConstantUtils.Project;
		otifAnalyticProj.IPM_Project_Description__c = proj.IPM_Project_Description__c;
		otifAnalyticProj.IPM_Parent_Project_Name__c = proj.IPM_Parent_Project__r.IPM_Project_Name__c;  
		otifAnalyticProj.IPM_Project_Leader__c = proj.IPM_Project_Leader__r.Name;
		otifAnalyticProj.IPM_Deputy_Project_Leader__c = proj.Deputy_Project_Leader__r.Name;
		otifAnalyticProj.IPM_Finance_Member__c = proj.IPM_Finance_Lead__r.Name;
		otifAnalyticProj.IPM_Project_Span__c = proj.IPMProject_Span__c;
		otifAnalyticProj.IPM_Project_Type__c = proj.IPM_Project_Type__c;
		otifAnalyticProj.IPM_Company__c = proj.IPM_Company_Card__r.Name;
		otifAnalyticProj.IPM_Category_Group__c = proj.IPM_Category_Group__c;
		otifAnalyticProj.IPM_Category__c = proj.IPM_Category_Text__c;
		otifAnalyticProj.IPM_Brand_Positioning__c = proj.IPM_Brand_Positioning__c;
		otifAnalyticProj.IPM_Market_Place_Activity__c = proj.IPM_Answer_of_Q1__c;
		otifAnalyticProj.IPM_Consumer_Value_Perception__c = proj.IPM_Answer_of_Q2__c;
		otifAnalyticProj.IPM_Enabling_Technology__c = proj.IPM_Answer_of_Q3__c;
		otifAnalyticProj.IPM_Strategic_Intent__c = proj.IPM_Strategic_Intent__c;
		otifAnalyticProj.IPM_Phase__c = proj.IPM_Phase__c;
	    
	    if(String.isNotBlank(proj.IPMProject_Span__c)){
	    	if(proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) || proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
	           otifAnalyticProj.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
	           otifAnalyticProj.IPM_Market_Cluster__c = proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)?proj.Market_Cluster_Name__c:null;
	        }else if(proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
	           otifAnalyticProj.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
	           otifAnalyticProj.IPM_Market_Cluster__c = proj.Market_Cluster_Name__c;                 
	        }
	    }
	    
	    //setGeography
        //otifAnalyticProj = setGeography(proj,otifAnalyticProj);

        // populate target launch year & month
        otifAnalyticProj = setTargetLaunchYearandMonth(proj,otifAnalyticProj);
        
        //Global Project Business Impact Global will be copy to Global,Regional & Local project
        if(projFinmap.containskey(proj.Id)){ 
           otifAnalyticProj.IPM_Business_Impact__c = projFinMap.get(proj.id).Business_Impact_Global__c; 
        } 
        
        otifAnalyticProj = processMilestoneDetails(projMilestoneMap, otifAnalyticProj, proj);
        otifAnalyticProj = processProjectDocumentSectionContentDetails(projDocSecContentMap,  otifAnalyticProj, proj);
         
        if( otifAnalyticProj != null && proj != null){ 
             otifAnalyticProj = processProjectFinancial(otifAnalyticProj,  proj, projFinYrMap);
        }
	    
	    return otifAnalyticProj;
    } 
        
    private void fetchRolloutFinancial(){
    	
    	//To fetch the financials for the rollout project when it is in Ideas phase
        rolloutFinancialmap = new map<id,list<IPM_Financial__c>> ();
        try{
            list<IPM_Financial__c> projRolloutFinList = new list<IPM_Financial__c>([SELECT  id,name,Display_Name__c,Financial_External_ID__c,Business_Impact_Global__c,Business_Impact_Regional__c,Business_Impact_Local__c,Parent_Project__r.Name,Regional_Project__r.id, 
																							Local_Project__r.id,Parent_Project__r.id,Regional_Project__r.Name,Local_Project__r.Name,IPM_Auto_Aligned_Fin_TLD__c,IPM_Project_Rollout__r.id 

                                                                                            FROM IPM_Financial__c 
                                                                                            WHERE IPM_Project_Rollout__c IN: regionalRolloutset OR Regional_Project__c IN: regionalRolloutset  Limit 50000]);
                                                
            for(IPM_Financial__c fir:projRolloutFinList){
              
                if(!rolloutFinancialmap.containskey(fir.IPM_Project_Rollout__r.Id)){
                    rolloutFinancialmap.put(fir.IPM_Project_Rollout__r.Id, new List<IPM_Financial__c>{fir});
						
                }else{
                    List<IPM_Financial__c> finrList = rolloutFinancialmap.get(fir.IPM_Project_Rollout__r.Id);
                    finrList.add(fir);
                    rolloutFinancialmap.put(fir.IPM_Project_Rollout__r.Id,finrList);              
                }
                // to fetch the financials details for Regional Original Projects with Phantom Rollouts
                if(!rolloutFinancialmap.containskey(fir.Regional_Project__r.id)){
                    rolloutFinancialmap.put(fir.Regional_Project__r.id, new List<IPM_Financial__c>{fir});  
                }else{
                    List<IPM_Financial__c> finrList = rolloutFinancialmap.get(fir.Regional_Project__r.id);
                    finrList.add(fir);
                    rolloutFinancialmap.put(fir.Regional_Project__r.id,finrList);              
                }
               
                finIdSet.add(fir.id);
            }
            
        }   
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR,null,null,null,null); 
        }
    }
    
    private void fetchRolloutFinancialYear(){
    	
    	//To fetch the financial year for the rollout project when it is in Ideas phase
        rolloutFinancialYearmap = new map<string,list<IPM_Financial_Year__c>> ();
        try{
            list<IPM_Financial_Year__c> projRolloutFinYearList = new list<IPM_Financial_Year__c>([SELECT id,name,Financial_External_ID__c,IPM_Financial__r.Parent_Project__r.Id,IPM_Financial__r.Regional_Project__r.Id,IPM_Financial__r.Local_Project__r.Id,IPM_Financial__r.Id,IPM_Financial__r.Business_Impact_Global__c,
																										Year__c,Gross_Profit_Global__c,Gross_Profit_Regional__c,Gross_Profit_Local__c,Turnover_Global__c,Turnover_Local__c,Turnover_Regional__c,Turnover_Charter__c,Turnover_Contract__c,Turnover_MD__c,Turnover_MR__c,
																										Year_Type__c,GM_of_TO_Charter__c,GM_of_TO_Contract__c,GM_of_TO_MD__c,GM_of_TO_MR__c,GM_of_TO_Local__c,GM_of_TO_Global__c,GM_of_TO_Regional__c,Charter_Approved__c,Contract_Approved__c,MD_Approved__c,MR_Approved__c,PL_Type__c
                                                                                                        FROM IPM_Financial_Year__C 
                                                                                                        WHERE IPM_Financial__c IN: finIdSet Limit 50000]);
                                                
            for(IPM_Financial_Year__c fiyr:projRolloutFinYearList){
                if(!rolloutFinancialYearmap.containskey(fiyr.Financial_External_ID__c)){
                    rolloutFinancialYearmap.put(fiyr.Financial_External_ID__c, new List<IPM_Financial_Year__c>{fiyr});  
                }else{
                    List<IPM_Financial_Year__c> finyrList = rolloutFinancialYearmap.get(fiyr.Financial_External_ID__c);
                    finyrList.add(fiyr);
                    rolloutFinancialYearmap.put(fiyr.Financial_External_ID__c,finyrList);               
                }                
            }                         
        }   
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR,null,null,null,null); 
        }
    }
    
    
    private void fetchCountryRecords(){
    	try{
        List<IPM_Country__c> ipmCountryList= new list<IPM_Country__c>([SELECT Country_Code__c,Country_Name__c,IPM_Project__r.id,IPM_Project__r.IPMProject_Span__c,IPM_Local_Project__r.Id,IPM_Local_Project__r.IPMProject_Span__c,IPM_Regional_Project__r.Id,IPM_Regional_Project__r.IPMProject_Span__c,Local_Rollout__r.id
                                                                       FROM IPM_Country__c WHERE IPM_Local_Project__r.Id IN : projectIdMap.keyset() or Local_Rollout__r.id IN: localRolloutIDSet Limit 50000]);
            
            for(IPM_Country__c ic:ipmCountryList){
                if(ic.Country_Name__c != null){ 
                        if(ic.IPM_Local_Project__r.Id != null){
                            if(ipmCountryMap.containsKey(ic.IPM_Local_Project__r.Id)){
                                string countries = ipmCountryMap.get(ic.IPM_Local_Project__r.Id) + ', ' + ic.Country_Name__c;
                                ipmCountryMap.put(ic.IPM_Local_Project__r.Id, countries);
                            }
                            else{
                                ipmCountryMap.put(ic.IPM_Local_Project__r.Id, ic.Country_Name__c);                        
                            }
                        }
                    // Process countries for rollouts
                    if(ic.IPM_Local_Project__r.Id == null && ic.Local_Rollout__r.id != null){
                        if(ipmCountryMap.containsKey(ic.Local_Rollout__r.id)){
                            string countries = ipmCountryMap.get(ic.Local_Rollout__r.id) + ', ' + ic.Country_Name__c;
                            ipmCountryMap.put(ic.Local_Rollout__r.id, countries);
                        }
                        else{
                            ipmCountryMap.put(ic.Local_Rollout__r.id, ic.Country_Name__c);                        
                        }
                    }
                }
            }
            
        }
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        }
    }
    
    
    // Method to get records for Non Key Financials
    public IPM_Analytics_OTIF__c addNonKeyFinancial(IPM_Analytics_OTIF__c parentAnalytic, IPM_Financial__c nonKeyFinancial, IPM_Project__c project, IPM_Project_Rollout__c projectRollout,map<String, List<IPM_Financial_Year__c>> projFinYrMap){
		IPM_Analytics_OTIF__c parent = parentAnalytic;
        
        IPM_Analytics_OTIF__c nonKeyAnalytic = new IPM_Analytics_OTIF__c();
        nonKeyAnalytic.IPM_Project_Phantom_Non_Key__c = IPM_ConstantUtils.Nonkey;
        nonKeyAnalytic.IPM_Project_Id__c = parentAnalytic.IPM_Project_Id__c;
        nonKeyAnalytic.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
        nonKeyAnalytic.IPM_Project_Name__c = nonKeyFinancial.Display_Name__c;
        nonKeyAnalytic.IPM_Parent_Project_Name__c = parent.IPM_Project_Name__c;     
        nonKeyAnalytic.IPM_Project_Span__c = IPM_ConstantUtils.PROJECT_SPAN_LOCAL;
        nonKeyAnalytic.IPM_Project_Type__c = IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT;
        nonKeyAnalytic.IPM_Company__c = parent.IPM_Company__c;
        nonKeyAnalytic.IPM_Category_Group__c = parent.IPM_Category_Group__c;
        nonKeyAnalytic.IPM_Category__c = parent.IPM_Category__c;
        nonKeyAnalytic.IPM_Phase__c = parent.IPM_Phase__c;
        nonKeyAnalytic.IPM_Brand_Positioning__c = parent.IPM_Brand_Positioning__c;
        nonKeyAnalytic.IPM_Market_Place_Activity__c = parentAnalytic.IPM_Market_Place_Activity__c;
        nonKeyAnalytic.IPM_Consumer_Value_Perception__c = parent.IPM_Consumer_Value_Perception__c;
        nonKeyAnalytic.IPM_Enabling_Technology__c = parent.IPM_Enabling_Technology__c;
        nonKeyAnalytic.IPM_Strategic_Intent__c = parent.IPM_Strategic_Intent__c;
        nonKeyAnalytic.Contract_Full_Mix__c = parent.Contract_Full_Mix__c;
        nonKeyAnalytic.Contract_Communication__c = parent.Contract_Communication__c;
        nonKeyAnalytic.IPM_Contract_Pack__c = parent.IPM_Contract_Pack__c;
        nonKeyAnalytic.Contract_Product__c = parent.Contract_Product__c;
        nonKeyAnalytic.Comm_BET_Final_Release_Availability__c = parent.Comm_BET_Final_Release_Availability__c;
        
        nonKeyAnalytic.IPM_Target_Launch_Month_BD__c = parent.IPM_Target_Launch_Month_BD__c;
        nonKeyAnalytic.IPM_Target_Launch_Year_BD__c = parent.IPM_Target_Launch_Year_BD__c;
            
        
        
        if(regRLToNKLocalRolloutMap.containsKey(nonKeyFinancial.IPM_Project_Rollout__c)){
            String strGeography = '';
            for(Id localRolloutId : regRLToNKLocalRolloutMap.get(nonKeyFinancial.IPM_Project_Rollout__c)){
                
                if(strGeography != ''){
                    strGeography = strGeography + ', ' + ipmCountryMap.get(localRolloutId);
                }else{
                    strGeography = ipmCountryMap.get(localRolloutId);
                }
            } 
            nonKeyAnalytic.IPM_Geography__c = strGeography; 
        } 
        
        if(project!=null){
            nonKeyAnalytic.IPM_Market_Cluster__c = project.Market_Cluster_Name__c;
        }
        else if(projectRollout!=null){
            nonKeyAnalytic.IPM_Market_Cluster__c = projectRollout.Market_Cluster_Name__c;
        }
        nonKeyAnalytic =  project!=null?processProjectFinancial(nonKeyAnalytic,project,projFinYrMap):processProjectRolloutFinancial(nonKeyAnalytic, nonKeyFinancial.Financial_External_ID__c, projectRollout);
        
        return nonKeyAnalytic; 
    }
    
    /*********************************************************************************************************************
     * @Description: To get records for each rollout project for the parent project which is in Ideas phase
     * @param1: IPM_Analytics_OTIF__c (Parent prject Analytic record to be inserted)
     * @return: List<IPM_Analytics_OTIF__c> records for each rollout project to be inserted in Analytic object for reporting  
     *********************************************************************************************************************/

    public List<IPM_Analytics_OTIF__c> addrolloutproject (IPM_Analytics_OTIF__c parentAnalytic){         
       
        IPM_Analytics_OTIF__c parent = parentAnalytic;
        list<IPM_Analytics_OTIF__c> analyticRolloutList = new list<IPM_Analytics_OTIF__c>();
               
             if(projRolloutMap.containskey(parent.IPM_Project_Id__c)){
                
                 for(IPM_Project_Rollout__c pr : projRolloutMap.get(parent.IPM_Project_Id__c)){ 
                rolloutProjectHelp(pr,parent, analyticRolloutList);
            }
         }
        return analyticRolloutList;    
    }
    /***********************************************
    Description
    ************************************************/
    public void rolloutProjectHelp(IPM_Project_Rollout__c pr, IPM_Analytics_OTIF__c parent, list<IPM_Analytics_OTIF__c> analyticRolloutList)
    {
        IPM_Analytics_OTIF__c analyticObj = new IPM_Analytics_OTIF__c();
        id regionalrolloutid=null;
            
        // project Rollout related details to be copied  
        analyticObj = setRolloutProjectdetails(analyticObj, pr, parent);
            
        if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE){
            regionalrolloutid = pr.Id; 
                for(IPM_Financial__c financial : rolloutFinancialmap.get(regionalrolloutid)){
                 if(financial.Financial_External_ID__c == pr.Name + IPM_ConstantUtils.FINANCIAL_NONKEY){
                     IPM_Analytics_OTIF__c analyticNKObj = new IPM_Analytics_OTIF__c();
                     analyticNKObj = addNonKeyFinancial(analyticObj, financial, null, pr , null);
                     analyticRolloutList.add(analyticNKObj);
                     break; 
                 } 
            }    
                                            
        }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){
              regionalrolloutid=pr.Regional_Project__c != null?pr.Regional_Project__r.id:pr.Regional_Rollout__r.id; 
              // To set the CPP details - CPP BD
        } 
        rolloutProjectSubHelp(regionalrolloutid,pr,analyticObj);
        analyticRolloutList.add(analyticObj);
    }
    /***************************************************
    *************/
    public void rolloutProjectSubHelp(id regionalrolloutid, IPM_Project_Rollout__c pr, IPM_Analytics_OTIF__c analyticObject1)
    {
        string finExtId = '';
        if(regionalrolloutid != null && rolloutFinancialmap.containskey(regionalrolloutid)){ 
           for(IPM_Financial__c fir:rolloutFinancialmap.get(regionalrolloutid)){
               if((pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE && fir.Financial_External_ID__c == pr.Name + IPM_Utils.CONSOLIDATED) || (pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE && fir.Financial_External_ID__c == pr.Name)){
                   
                   finExtId = fir.Financial_External_ID__c;                                     
               }                       
           }
       }                                           
        // Financial related details to be copied  
             
        if(finExtId != ''){    
            processProjectRolloutFinancial(analyticObject1, finExtId, pr);
        }
    }
    /*********************************************************************************************************************
     * @Description: To copy rollout related financial details 
     * @param1: IPM_Analytics_OTIF__c, String, IPM_Project_Rollout__c
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/    
    public IPM_Analytics_OTIF__c setRolloutProjectdetails(IPM_Analytics_OTIF__c otifAnalyticRollOut, IPM_Project_Rollout__c pr, IPM_Analytics_OTIF__c parent){
      //copy Values from rollout record
                otifAnalyticRollOut.IPM_Project_Phantom_Non_Key__c = IPM_ConstantUtils.Phantom;
                otifAnalyticRollOut.IPM_Project_Name__c = pr.Name;
                otifAnalyticRollOut.IPM_Company__c = pr.IPM_Company_Card__r.Name; // as per the update it will be populated by Unilever report tool
                otifAnalyticRollOut.IPM_Target_Launch_Month_BD__c = pr.Target_LaunchMonth__c;
                if(pr.Target_LaunchYear__c != null){
                    otifAnalyticRollOut.IPM_Target_Launch_Year_BD__c = integer.valueOf(pr.Target_LaunchYear__c) ;
                }
                otifAnalyticRollOut.IPM_Parent_Project_Name__c = pr.IPM_Parent_Project_Name__c; 
                otifAnalyticRollOut.IPM_Project_Leader__c = pr.IPM_Regional_PL__r.Name;
                //Copy values From Parent project
                otifAnalyticRollOut.IPM_Project_Id__c = parent.IPM_Project_Id__c;                    
                otifAnalyticRollOut.IPM_Project_Description__c = parent.IPM_Project_Description__c;
                otifAnalyticRollOut.IPM_Project_Type__c = IPM_Utils.Rollout;
                otifAnalyticRollOut.IPM_Category_Group__c = parent.IPM_Category_Group__c;
                otifAnalyticRollOut.IPM_Category__c = parent.IPM_Category__c;
                otifAnalyticRollOut.IPM_Brand_Positioning__c = parent.IPM_Brand_Positioning__c;
                otifAnalyticRollOut.IPM_Market_Place_Activity__c = parent.IPM_Market_Place_Activity__c;
                otifAnalyticRollOut.IPM_Consumer_Value_Perception__c = parent.IPM_Consumer_Value_Perception__c;
                otifAnalyticRollOut.IPM_Enabling_Technology__c = parent.IPM_Enabling_Technology__c;
                otifAnalyticRollOut.IPM_Strategic_Intent__c = parent.IPM_Strategic_Intent__c;
        
        if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE){
                    otifAnalyticRollOut.IPM_Project_Span__c =IPM_Utils.Regional;
                    otifAnalyticRollOut.IPM_Geography__c = pr.Market_Cluster_Name__c;
                    otifAnalyticRollOut.IPM_Phase__c = pr.Regional_Rollout_Phase__c;
                    otifAnalyticRollOut.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
                    otifAnalyticRollOut.IPM_Market_Cluster__c = pr.Market_Cluster_Name__c;
                    
                      
        }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE ){
            otifAnalyticRollOut.IPM_Project_Span__c = IPM_Utils.Local;
            otifAnalyticRollOut.IPM_Geography__c = ipmCountryMap.containskey(pr.id)?ipmCountryMap.get(pr.id):'';
            otifAnalyticRollOut.IPM_Market_Cluster__c = pr.Market_Cluster_Name__c;
            otifAnalyticRollOut.IPM_Phase__c = pr.Regional_Project__c==null?pr.IPM_Project__r.IPM_Phase__c:pr.Regional_Project__r.IPM_Phase__c;
            otifAnalyticRollOut.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
        } 
      return otifAnalyticRollOut;
    }
    
    // Method to set project related financial records
    public IPM_Analytics_OTIF__c processProjectFinancial (IPM_Analytics_OTIF__c analyticObj, IPM_Project__c project, map<String, List<IPM_Financial_Year__c>> projFinYrMap){
        
        IPM_Analytics_OTIF__c ipmAnalytic = analyticObj;
        String strFinancialScope = IPM_ConstantUtils.IPMGLOBAL;
        
          String finExternalID= buildFinancialExternal(analyticObj);
        
        if(String.isNotBlank(project.IPM_Phase__c) && String.isNotBlank(project.IPM_ProjectGKM__c) ){
            String strKey =  project.IPM_ProjectGKM__c + IPM_ConstantUtils.HYPHEN_DELIMITER + project.IPM_Phase__c;
            
            strFinancialScope = IPM_Reporting__c.getValues(strKey).IPM_FinancialScope__c;
        }
        
        
        if(projFinYrmap.containskey(finExternalID) && project.IPM_Target_Launch_Dates__c!=null){
            for(IPM_Financial_Year__c financialYear : projFinYrMap.get(finExternalID)){
                    populateFinancialDetails(ipmAnalytic, financialYear, strFinancialScope,project.IPM_Target_Launch_Dates__c);
            }
        }
        return ipmAnalytic; 
    }
    // Method to set project rollout related financial records
    public IPM_Analytics_OTIF__c processProjectRolloutFinancial(IPM_Analytics_OTIF__c analyticObj, String financialExtId, IPM_Project_Rollout__c projectRollout){
        IPM_Analytics_OTIF__c ipmAnalytic = analyticObj; 
        String strFinancialScope = IPM_ConstantUtils.IPMGLOBAL; 
        
        // Set financial scope for Local rollouts
        if(projectRollout != null && projectRollout.Regional_Project__r != null){
            
            if(String.isNotBlank(projectRollout.Regional_Project__r.IPM_Phase__c) &&  String.isNotBlank(projectRollout.Regional_Project__r.IPM_ProjectGKM__c)){
                strFinancialScope = projectRollout.Regional_Project__r.IPM_ProjectGKM__c + IPM_ConstantUtils.HYPHEN_DELIMITER + projectRollout.Regional_Project__r.IPM_Phase__c;
                strFinancialScope = IPM_Reporting__c.getValues(strFinancialScope).IPM_FinancialScope__c;
            }
        }else if(projectRollout != null && projectRollout.IPM_Project__r != null){ // For Regional Rollouts
            
            if(String.isNotBlank(projectRollout.IPM_Project__r.IPM_Phase__c) &&  String.isNotBlank(projectRollout.IPM_Project__r.IPM_ProjectGKM__c)){
                strFinancialScope = projectRollout.IPM_Project__r.IPM_ProjectGKM__c + IPM_ConstantUtils.HYPHEN_DELIMITER + projectRollout.IPM_Project__r.IPM_Phase__c;
                strFinancialScope = IPM_Reporting__c.getValues(strFinancialScope).IPM_FinancialScope__c;
            }
        }
        
        if(rolloutFinancialYearmap.containsKey(financialExtId) && projectRollout.Target_Launch_Date__c!=null){
            // Financial year related to project rollouts
            for(IPM_Financial_Year__c financialYear : rolloutFinancialYearmap.get(financialExtId)){
                    populateFinancialDetails(ipmAnalytic, financialYear, strFinancialScope,projectRollout.Target_Launch_Date__c);
            }
        }
        return ipmAnalytic;
    }
    // Method to set the fianancial year details on IPM Analytic object
    public IPM_Analytics_OTIF__c populateFinancialDetails(IPM_Analytics_OTIF__c analyticObj, IPM_Financial_Year__c financialYear, String strScope, date targetLaunchYear){
        
        Date prepYear3=targetLaunchYear.addYears(2);
        string year3= String.ValueOf(prepYear3.year());
        IPM_Analytics_OTIF__c ipmAnalytic = analyticObj; 
        
        // Calender Financial Year Check 
        if(String.isNotBlank(financialYear.Year_Type__c) && financialYear.Year_Type__c.equalsignorecase(IPM_Utils.Calendar)){
            
            // PL Type check for Gross
            if(String.isNotBlank(financialYear.PL_Type__c) && financialYear.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
                
                ipmAnalytic = populateGrossForCalendar(ipmAnalytic, financialYear, strScope,year3);           
                
                
            } else if(String.isNotBlank(financialYear.PL_Type__c) && financialYear.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){ // PL Type check for Incremental
            
                ipmAnalytic = populateIncForCalendar(ipmAnalytic, financialYear, strScope,year3);
                
            }
        }   
        
        // Innovation Financial Year Check
        if(String.isNotBlank(financialYear.Year_Type__c) && financialYear.Year_Type__c.equalsignorecase(IPM_Utils.Innovation)){
            
            // PL Type check for Gross
            if(String.isNotBlank(financialYear.PL_Type__c) && financialYear.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
                
                ipmAnalytic = populateGrossForInnovation(ipmAnalytic, financialYear, strScope);
                
            } if(String.isNotBlank(financialYear.PL_Type__c) && financialYear.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){ // PL Type check for Incremental
                
                ipmAnalytic = populateIncForInnovation(ipmAnalytic, financialYear, strScope);
                
                
            }
        }
        return ipmAnalytic;
    }
    
    public IPM_Analytics_OTIF__c populateGrossForCalendar(IPM_Analytics_OTIF__c ipmAnalytic, IPM_Financial_Year__c fr, String strScope,string year3){
        IPM_Analytics_OTIF__c otifAnalyticObj=ipmAnalytic;
        String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
        String strFYearGMFieldName= fYearGMFieldMapping.get(strScope);
        
        if(fr.Name == year3)
            {  
                
                  otifAnalyticObj=snapshotY3Gross(fr,otifAnalyticObj);
               // Populating Y3 gTO BD   
                    otifAnalyticObj.put('IPM_Y3_gTO_BD__c', fr.get(strFYearTOFieldName));
                    otifAnalyticObj.put('Y3_GM_BD__c',fr.get(strFYearGMFieldName));
            
            }
        
        return otifAnalyticObj;
    }
    
    
    public IPM_Analytics_OTIF__c populateIncForCalendar(IPM_Analytics_OTIF__c otifAnalytic, IPM_Financial_Year__c fr, String strScope,String year3){
        
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);     
       
        if(fr.Name == year3)
        {
          // Populating Y3 iTO 
              otifAnalyticObj=snapshotY3Incremental(fr,otifAnalyticObj)  ;
             
          // Populating Y3 iTO  BD
          otifAnalyticObj.put('IPM_Y3_iTO_BD__c',fr.get(strFYearTOFieldName));
                     
        }
        return otifAnalyticObj;

    }
    
    public IPM_Analytics_OTIF__c populateGrossForInnovation(IPM_Analytics_OTIF__c otifAnalytic, IPM_Financial_Year__c fr, String strScope){
        IPM_Analytics_OTIF__c otifAnalyticObj=otifAnalytic;
        String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
        String strFYearGMFieldName = fYearGMFieldMapping.get(strScope); 
        
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
             
              // Populating Y1 gTO 
              otifAnalyticObj=snapshotY1Gross(fr,otifAnalyticObj);
             // Populating Y1 gTO BD   
               otifAnalyticObj.put('IPM_Y1_gTO_BD__c',fr.get(strFYearTOFieldName));
                otifAnalyticObj.put('IPM_Y1_GM_BD__c',fr.get(strFYearGMFieldName));
              
        }
        return otifAnalyticObj;

    }
    
    public IPM_Analytics_OTIF__c populateIncForInnovation(IPM_Analytics_OTIF__c otifAnalytic, IPM_Financial_Year__c fr, String strScope){
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
        
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
        {
          // Populating Y1 iTO 
              otifAnalyticObj=snapshotY1Incremental(fr,otifAnalyticObj);
          // Populating Y1 iTO  BD
          otifAnalyticObj.put('IPM_Y1_iTO_BD__c', fr.get(strFYearTOFieldName));
                 
        }
        return otifAnalyticObj;

    }
    
    public void prepareFinancialGenericTemplate(){

        fYearTOFieldMapping = new Map<String, String>{IPM_ConstantUtils.IPMGLOBAL => 'Turnover_Global__c', IPM_ConstantUtils.IPMREGIONAL => 'Turnover_Regional__c',IPM_ConstantUtils.IPMLOCAL => 'Turnover_Local__c'};
        fYearGMFieldMapping = new Map<String, String>{IPM_ConstantUtils.IPMGLOBAL => 'GM_of_TO_Global__c', IPM_ConstantUtils.IPMREGIONAL => 'GM_of_TO_Regional__c',IPM_ConstantUtils.IPMLOCAL => 'GM_of_TO_Local__c'};
            
        
    }
    
    /*********************************************************************************************************************
     * @Description: To copy PLType Gross Snapshot values for Y3
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic  
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    
    
     public IPM_Analytics_OTIF__c snapshotY3Gross(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalyticObj){
        
        if(fr.Charter_Approved__c){  
                  otifAnalyticObj.IPM_Charter_Y3_gTO__c =  fr.Turnover_Charter__c;                
                  otifAnalyticObj.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
           }      
             if(fr.Contract_Approved__c){
                otifAnalyticObj.IPM_Charter_Y3_gTO__c =  fr.Turnover_Charter__c;                  
                otifAnalyticObj.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
                otifAnalyticObj.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
                otifAnalyticObj.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
                  
            }   
             if(fr.MR_Approved__c){
                otifAnalyticObj.IPM_Charter_Y3_gTO__c =  fr.Turnover_Charter__c;                  
                otifAnalyticObj.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
                otifAnalyticObj.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
                otifAnalyticObj.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
                otifAnalyticObj.IPM_MR_Y3_gTO__c =fr.Turnover_MR__c;
                otifAnalyticObj.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;              
                 
            }
             if(fr.MD_Approved__c){
                otifAnalyticObj.IPM_Charter_Y3_gTO__c =  fr.Turnover_Charter__c;                  
                otifAnalyticObj.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
                otifAnalyticObj.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
                otifAnalyticObj.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
                otifAnalyticObj.IPM_MR_Y3_gTO__c =fr.Turnover_MR__c;
                otifAnalyticObj.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;
                otifAnalyticObj.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;
                otifAnalyticObj.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
                 
            }
                  
                 
          return   otifAnalyticObj;       
    }
    
     /*********************************************************************************************************************
     * @Description: To copy PLType Incremental Snapshot values for Y3
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic  
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/  
           
     public IPM_Analytics_OTIF__c snapshotY3Incremental(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalyticObj){
          
            if(fr.Charter_Approved__c){ 
                otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
            
            }
             if(fr.Contract_Approved__c){
                otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
                otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;               
            }   
             if(fr.MR_Approved__c){
                otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
                otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
                otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;               
                
            }
             if(fr.MD_Approved__c){
                otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
                otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
                otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
                otifAnalyticObj.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;               
            }
            
              
              return otifAnalyticObj;
     } 
     
      /*********************************************************************************************************************
     * @Description: To copy PLType Incremental Snapshot values for Y1
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic  
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/  
    
     public IPM_Analytics_OTIF__c snapshotY1Incremental(IPM_Financial_Year__c fr, IPM_Analytics_OTIF__c otifAnalyticObj){
        
            if(fr.Charter_Approved__c){ 
                otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 iTO             
            }
             if(fr.Contract_Approved__c){
                otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 iTO             
                otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;       //Contract Innovation Y1 iTO    
            }   
             if(fr.MR_Approved__c){
                otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 iTO             
                otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;       //Contract Innovation Y1 iTO    
                otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
                
            }
             if(fr.MD_Approved__c){
                otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 iTO             
                otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;       //Contract Innovation Y1 iTO    
                otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
                otifAnalyticObj.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;               
            }
            
           return otifAnalyticObj;
      }  
      
        /*********************************************************************************************************************
     * @Description: To copy PLType Gross Snapshot values for Y1
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic  
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/  
    

     public IPM_Analytics_OTIF__c snapshotY1Gross(IPM_Financial_Year__c fr, IPM_Analytics_OTIF__c otifAnalyticObj){
        
        
        if(fr.Charter_Approved__c){ 
                  otifAnalyticObj.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;       //Charter Innovation Y1 gTO 
                  otifAnalyticObj.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c;            
            }
             if(fr.Contract_Approved__c){
                otifAnalyticObj.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 gTO 
                otifAnalyticObj.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c; 
                otifAnalyticObj.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;
                otifAnalyticObj.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;
                
            }   
             if(fr.MR_Approved__c){
                otifAnalyticObj.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 gTO 
                otifAnalyticObj.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c; 
                otifAnalyticObj.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;
                otifAnalyticObj.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;
                otifAnalyticObj.IPM_MR_Y1_gTO__c = fr.Turnover_MR__c;                   //Market Ready Innovation Y1 gTO
                otifAnalyticObj.IPM_MR_Y1_GM__c = fr.GM_of_TO_MR__c;
            }
             if(fr.MD_Approved__c){
                otifAnalyticObj.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;     //Charter Innovation Y1 gTO 
                otifAnalyticObj.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c; 
                otifAnalyticObj.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;
                otifAnalyticObj.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;
                otifAnalyticObj.IPM_MR_Y1_gTO__c = fr.Turnover_MR__c;                   //Market Ready Innovation Y1 gTO
                otifAnalyticObj.IPM_MR_Y1_GM__c = fr.GM_of_TO_MR__c;
                otifAnalyticObj.IPM_MD_Y1_gTO__c = fr.Turnover_MD__c;
                otifAnalyticObj.IPM_MD_Y1_GM__c = fr.GM_of_TO_MD__c;
                            
            }
                    
        return otifAnalyticObj;
    } 
    
    
    /*********************************************************************************************************************
     * @Description: To copy Milestone related details to that particular project
     * @param1: Map<Id, List<IPM_Milestone__c>> (Project And Its related Milestone records), IPM_Analytics_OTIF__c IPM Analytics , IPM Project
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/
    public IPM_Analytics_OTIF__c processMilestoneDetails(map<Id,list<IPM_Milestone__c>> projMilestoneMap, IPM_Analytics_OTIF__c otifAnalytics, IPM_Project__c p){
        
        //Copying IPM Milestone fields 
        IPM_Analytics_OTIF__c otifAnalyticObj=otifAnalytics;
        if(projMilestoneMap.containskey(p.id)){ 
            for(IPM_Milestone__c mile : projMilestoneMap.get(p.id)){ 
                if(mile.IPM_Name__c.equalsignorecase(IPM_ConstantUtils.Original_SHIPTO_TRADE_TLD) || mile.IPM_Name__c.equalsignorecase(IPM_ConstantUtils.SHIPTO_TRADE_TLD)){
                   if(mile.IPM_Actual_Target_Launch_Year__c != null){
                       otifAnalyticObj.IPM_Actual_Launch_Year__c = integer.valueOf(mile.IPM_Actual_Target_Launch_Year__c);                   
                   }
                    if(mile.IPM_Actual_Target_Launch_Month__c != 'None' && mile.IPM_Actual_Target_Launch_Month__c != '' ){
                       otifAnalyticObj.IPM_Actual_Launch_Month__c = mile.IPM_Actual_Target_Launch_Month__c;
                    }
                    if(mile.IPM_Due_Date_Idea__c != null ){
                        otifAnalyticObj = setValuesForDueDateIdea(mile, otifAnalyticObj, p);
                    }
                    if(mile.IPM_Due_Date_Feasibility__c != null ){
                        otifAnalyticObj = setValuesForDueDateFeasibility(mile, otifAnalyticObj, p);
                    }
                    if(mile.IPM_Due_Date_Capability__c != null ){
                        otifAnalyticObj = setValuesForDueDateCapability(mile, otifAnalyticObj, p);
                    }
                    if(mile.IPM_Due_Date_Market_Ready__c != null ){
                        otifAnalyticObj = setValuesForDueDateMarketReady(mile, otifAnalyticObj, p); 
                    }   
                }
            }
        } //end of Milestone loop            
        
        return otifAnalyticObj;
    }
    
    /*********************************************************************************************************************
     * @Description: To copy milestone data if due date Idea is populated 
     * @param1: IPM_Milestone__c mile
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setValuesForDueDateIdea(IPM_Milestone__c mile, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;  
        if(projGateDocumentMap.containskey(p.id)){  
            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.CHARTER_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){
                    otifAnalyticObj.IPM_Charter_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Idea__c.month());
                    otifAnalyticObj.IPM_Charter_Target_Launch_Year__c = string.valueof(mile.IPM_Due_Date_Idea__c.Year());                       
                }   
            }   
        }   
        return otifAnalyticObj;
    }


    /*********************************************************************************************************************
     * @Description: To copy milestone data if due date Feasibility is populated 
     * @param1: IPM_Milestone__c mile
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setValuesForDueDateFeasibility(IPM_Milestone__c mile, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(projGateDocumentMap.containskey(p.id)){  
            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){                 
                   otifAnalyticObj.IPM_Contract_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Feasibility__c.month());
                   otifAnalyticObj.IPM_Contract_Target_Launch_Year__c = string.valueof(mile.IPM_Due_Date_Feasibility__c.Year());
                }   
            }   
        }                                  
        return otifAnalyticObj;
    }

    /*********************************************************************************************************************
     * @Description: To copy milestone data if due date Capability is populated 
     * @param1: IPM_Milestone__c mile
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setValuesForDueDateCapability(IPM_Milestone__c mile, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){    
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic; 
        if(projGateDocumentMap.containskey(p.id)){  
            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.MARKET_READY_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){                 
                    otifAnalyticObj.IPM_MR_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Capability__c.month());
                    otifAnalyticObj.IPM_MR_Target_Launch_Year__c  = string.valueof(mile.IPM_Due_Date_Capability__c.Year());  
                }   
            }   
        }                                   
        return otifAnalyticObj;
    }


    /*********************************************************************************************************************
     * @Description: To copy milestone data if due date MarketReady is populated 
     * @param1: IPM_Milestone__c mile
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setValuesForDueDateMarketReady(IPM_Milestone__c mile, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
       IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;       
       if(projGateDocumentMap.containskey(p.id)){  
            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){                    
                    otifAnalyticObj.IPM_MD_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Market_Ready__c.month());
                    otifAnalyticObj.IPM_MD_Target_Launch_Year__c = string.valueof(mile.IPM_Due_Date_Market_Ready__c.Year());   
                }   
            }   
        }                                   
        return otifAnalyticObj;
    }    
    
    
    /*********************************************************************************************************************
     * @Description: To fetch gate Dcoument  Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Project_Document__c>> gate Docuements Records
     *********************************************************************************************************************/     
    public map<Id,list<IPM_Project_Document__c>> fetchGateDocumentRecords(map<id,IPM_Project__c> projectIdMap){
        map<Id,list<IPM_Project_Document__c>> projGateDocMap = new map<id,list<IPM_Project_Document__c>>();
        try{
               for(IPM_Project_Document__c im:[SELECT id,
                                                   IPM_GateDocuments__c,
                                                   IPM_Approval_Date__c,
                                                   IPM_Project__c,
                                                   IPM_Project__r.id,
                                                   IPM_Document_Status__c
                                                   FROM IPM_Project_Document__c WHERE IPM_Project__r.id IN:projectIdMap.keyset() Limit 50000]){
                if(!projGateDocMap.containskey(im.IPM_Project__r.id)){
                    projGateDocMap.put(im.IPM_Project__r.id, new List<IPM_Project_Document__c>{im});  
                }else{
                    List<IPM_Project_Document__c> gateDocList = projGateDocMap.get(im.IPM_Project__r.id);
                    gateDocList.add(im);
                    projGateDocMap.put(im.IPM_Project__r.id, gateDocList);              
                } 
            }
        }
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null);
        }
        return projGateDocMap;
    }
    
    /*********************************************************************************************************************
     * @Description: To fetch Project Document Section Content Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Project_Rollout__c>> Project Document Section Content Records
     *********************************************************************************************************************/         
    public map<id,list<IPM_Project_Document_Section_Content__c>> fetchProjectDocumentSectionContent(map<id,IPM_Project__c> projectIdMap){
        map<id,list<IPM_Project_Document_Section_Content__c>> projDocSecContentMap = new map<id,list<IPM_Project_Document_Section_Content__c>>();
        try
        {
            for(IPM_Project_Document_Section_Content__c pDocSecContent :[SELECT id,
                                                                                  IPM_Section_Name__c,
                                                                                  IPM_OTIF_Measure__c,
                                                                                  IPM_OTIF_Status__c,
                                                                                  IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c,
                                                                                  IPM_Project_Document_Section__r.IPM_Gate_Document__c,
                                                                                  IPM_Project_Document_Section__r.IPM_Section_Name__c,
                                                                                  IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,
                                                                                  IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.Name
                                                                                  from IPM_Project_Document_Section_Content__c
                                                                                  WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c IN: projectIdMap.keyset()  Limit 50000]){                                                                                       
                if(!projDocSecContentMap.containskey(pDocSecContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c)){
                    projDocSecContentMap.put(pDocSecContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c, new List<IPM_Project_Document_Section_Content__c>{pDocSecContent});  
                }else{
                    List<IPM_Project_Document_Section_Content__c> pDocSecContentList = projDocSecContentMap.get(pDocSecContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c);
                    pDocSecContentList.add(pDocSecContent);
                    projDocSecContentMap.put(pDocSecContent.IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c, pDocSecContentList);              
                }
            }
        }
        
        catch(Exception ex){  
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        } 
        return projDocSecContentMap;
    } 
    
     /*********************************************************************************************************************
     * @Description: To copy Project Document Section Content related details
     * @param1: Map<Id, List<IPM_Project_Document_Section_Content__c>> (Project And Its related Project Document Section), IPM_Analytics_OTIF__c IPM Analytics OTIF, IPM Project
     * @return: IPM_Analytics_OTIF__c Analytic OTIF object record  
     *********************************************************************************************************************/
    public IPM_Analytics_OTIF__c processProjectDocumentSectionContentDetails(Map<Id, List<IPM_Project_Document_Section_Content__c>> projDocSecContmap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        //Copying IPM Project Document Section Content fields
        if(projDocSecContmap.containskey(p.id)){
            for(IPM_Project_Document_Section_Content__c fr:projDocSecContmap.get(p.id)){
                // Populating Y3 gTO
                if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.Charter && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)
                {
                   otifAnalyticObj.IPM_OTIF_Comment_Charter__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
                    if(fr.IPM_OTIF_Measure__c == IPM_ConstantUtils.OTIF_CONCEPT_TEST){
                       otifAnalyticObj.IPM_Concept_Test__c = fr.IPM_OTIF_Status__c;
                    } else if(fr.IPM_OTIF_Measure__c == IPM_ConstantUtils.OTIF_SCOPING_COMPLETE){
                       otifAnalyticObj.IPM_Scoping_Complete__c = fr.IPM_OTIF_Status__c;
                    }
                }
                
                otifAnalyticObj = setContractGateDcoumentDetails(fr,otifAnalyticObj);
                otifAnalyticObj = setMarketReadyGateDcoumentDetails(fr,otifAnalyticObj);                
                
                
                if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.MarketDeployment && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF)
                {
                   otifAnalyticObj.IPM_OTIF_Comment_MD__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
                   
                    if(fr.IPM_OTIF_Measure__c == IPM_ConstantUtils.OTIF_FIRST_PROD_CONF_SPEC_FINALISED){
                       otifAnalyticObj.Ist_Production_Conf_Specs_Finalised__c = fr.IPM_OTIF_Status__c;
                    }   
                }               
                
            }
        }
        return otifAnalyticObj;
    } 
    
    /*********************************************************************************************************************
     * @Description: To copy OTIF Measure value when gate document is Contract
     * @param1: IPM_Project_Document_Section_Content__c IPM Project Document Section Content, IPM_Analytics_OTIF__c IPM Analytics
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/ 
    public IPM_Analytics_OTIF__c setContractGateDcoumentDetails(IPM_Project_Document_Section_Content__c fr, IPM_Analytics_OTIF__c otifAnalytic){
        
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.Contract && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)  
            {
               otifAnalyticObj.IPM_OTIF_Comment_Contract__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
                if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_CUSTOMER_APPEAL)){
                   otifAnalyticObj.IPM_Customer_Appeal__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_CAPEX_APPROVED)){
                   otifAnalyticObj.IPM_Capex_Approved__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECHNICAL_FEASIBILITY)){
                   otifAnalyticObj.IPM_Technical_Feasibility__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_ATTRACTIVE_BUSINESS_CASE)){
                   otifAnalyticObj.IPM_Attractive_Business_Case__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_MATERIALS_SOURCING_STRATEGIES_AGREED)){
                   otifAnalyticObj.IPM_Materials_Sourcing_Strategies_Agreed__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECHNICAL_ACTION_STANDARDS_ACHIEVED_BY_LEAD_REGION)){
                   otifAnalyticObj.Tech_Action_STD_Achieved_by_Lead_Region__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_PRODUCT)){
                   otifAnalyticObj.Contract_Product__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_FULL_MIX)){
                   otifAnalyticObj.Contract_Full_Mix__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_COMMUNICATION)){
                   otifAnalyticObj.Contract_Communication__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_PACK)){
                   otifAnalyticObj.IPM_Contract_Pack__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_PRICE)){
                   otifAnalyticObj.IPM_Contract_Price__c = fr.IPM_OTIF_Status__c;
                }
            }
        return otifAnalyticObj;       
    }
    /*********************************************************************************************************************
     * @Description: To copy OTIF Measure value when gate document is MarketReady
     * @param1: IPM_Project_Document_Section_Content__c IPM Project Document Section Content, IPM_Analytics_OTIF__c IPM Analytics
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics_OTIF__c setMarketReadyGateDcoumentDetails(IPM_Project_Document_Section_Content__c fr, IPM_Analytics_OTIF__c otifAnalytic){
        
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;     
        if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.MarketReady && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)
        {
           otifAnalyticObj.IPM_OTIF_Comment_MR__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
            if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_COMMUNICATION_BET_FINAL_RELEASE_AVAILABILITY)){
               otifAnalyticObj.Comm_BET_Final_Release_Availability__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECHNICAL_AND_PRODUCTION_CAPABILITY_CONFIRMED)){
               otifAnalyticObj.Tech_Prod_Capability_Confirmed__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_SPEC_BILLS_OF_MATERIALS_IN_INTERSPEC)){
               otifAnalyticObj.Spec_Bills_of_Materials_in_Interspec__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECH_PROD_CAPABILITY_CONF_MAIN_PLANT)){
               otifAnalyticObj.Tech_Prod_Capability_Conf_Main_Plant__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_COMMUNICATION_FULL_THINK_BIG_PACK_AVAILABLE)){
               otifAnalyticObj.Comm_Full_Think_Big_Pack_Available__c = fr.IPM_OTIF_Status__c;
            }
        }
        return otifAnalyticObj;       
    }
    
    /*********************************************************************************************************************
     * @Description: To fetch Consolidated Financial Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: Map<Id, IPM_Financial__c> Consolidated Financial Records
     *********************************************************************************************************************/
    
    
       public Map<Id, IPM_Financial__c> fetchConsolidatedFinancialRecords(map<id,IPM_Project__c> projectIdMap){
                //Fetching Consolidated Financial  records
         financialIdSet = new set<id>();
        projFinMap = new map<Id,IPM_Financial__c>();  // this map will hold project id and corresponding Consolidated financial records
        regionalProjNKFinMap = new Map<Id, IPM_Financial__c>(); // this map will hold project id and corresponding Non Key financial records
        
        try{   
        list<IPM_Financial__c> projectFinancialList = new list<IPM_Financial__c>([SELECT id,
                                                                                          name,
                                                                                          Display_Name__c,
                                                                                          Financial_External_ID__c,
                                                                                          Business_Impact_Global__c,
                                                                                          Business_Impact_Regional__c,
                                                                                          Business_Impact_Local__c, 
                                                                                          Parent_Project__r.IPM_Project_Name__c,
                                                                                          Regional_Project__r.id, 
                                                                                          Local_Project__r.id,
                                                                                          Parent_Project__r.id, 
                                                                                          Regional_Project__r.IPM_Project_Name__c, 
                                                                                          Local_Project__r.IPM_Project_Name__c,
                                                                                          IPM_Auto_Aligned_Fin_TLD__c,
                                                                                          IPM_Project_Rollout__r.id,
                                                                                          Parent_Project__r.IPM_Project_Type__c,
                                                                                          Regional_Project__r.IPM_Project_Type__c,
                                                                                          Local_Project__r.IPM_Project_Type__c
                                                                                                                                                                            
                                                                                  FROM IPM_Financial__c WHERE Parent_Project__r.Id IN: projectIdMap.keyset() or Regional_Project__r.id IN:projectIdMap.keyset() or Local_Project__r.id IN: projectIdMap.keyset() Limit 50000]);
        
            for(IPM_Financial__c fi:projectFinancialList){
                if(fi.Local_Project__r.id !=null && (fi.Local_Project__r.IPM_Project_Name__c == fi.Financial_External_ID__c  || fi.Local_Project__r.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
                    projFinMap.put(fi.Local_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Regional_Project__r.id !=null &&  (fi.Financial_External_ID__c ==  fi.Regional_Project__r.IPM_Project_Name__c + IPM_Utils.CONSOLIDATED || fi.Regional_Project__r.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) ){
                    projFinMap.put(fi.Regional_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Parent_Project__r.id != null && (fi.Financial_External_ID__c == fi.Parent_Project__r.IPM_Project_Name__c + IPM_Utils.CONSOLIDATED || fi.Parent_Project__r.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)) {
                    projFinMap.put(fi.Parent_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Regional_Project__r.id !=null &&  fi.Financial_External_ID__c == fi.Regional_Project__r.IPM_Project_Name__c + IPM_ConstantUtils.FINANCIAL_NONKEY){
                     financialIdSet.add(fi.id);
                    regionalProjNKFinMap.put(fi.Regional_Project__r.id, fi);
                }
                
            }
        } 
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null);
        }
         return projFinMap;
     }
     
     
      /*********************************************************************************************************************
     * @Description: To fetch Financial Year Records
     * @param1: set<Id> financialIdSet
     * @return: Map<Id, IPM_Financial__c> Financial Year Records
     *********************************************************************************************************************/     
    public Map<String, List<IPM_Financial_Year__c>> fetchFinancialYearRecords(set<Id> financialIdSet){
         //Fetching Financial year records
        projFinYrMap = new map<String, List<IPM_Financial_Year__c>>();  //This map will hold project id and financial year records
        try{ 
        list<IPM_Financial_Year__c> projectFinancialYrList = new list<IPM_Financial_Year__c>([SELECT id,
                                                                                             name,
                                                                                            Financial_External_ID__c,
                                                                                            IPM_Financial__r.Parent_Project__r.Id,
                                                                                            IPM_Financial__r.Regional_Project__r.Id,
                                                                                            IPM_Financial__r.Local_Project__r.Id,
                                                                                            IPM_Financial__r.Id,
                                                                                            IPM_Financial__r.Business_Impact_Global__c,
                                                                                            IPM_Financial__r.Financial_External_ID__c,
                                                                                            Year__c,
                                                                                            Gross_Profit_Global__c,
                                                                                            Gross_Profit_Regional__c,
                                                                                            Gross_Profit_Local__c,
                                                                                            Turnover_Global__c,
                                                                                            Turnover_Local__c,
                                                                                            Turnover_Regional__c,
                                                                                            Turnover_Charter__c,
                                                                                            Turnover_Contract__c,
                                                                                            Turnover_MD__c,
                                                                                            Turnover_MR__c,
                                                                                            Year_Type__c,
                                                                                            GM_of_TO_Charter__c,
                                                                                            GM_of_TO_Contract__c,
                                                                                            GM_of_TO_MD__c,
                                                                                            GM_of_TO_MR__c,
                                                                                            GM_of_TO_Local__c,
                                                                                            GM_of_TO_Global__c,
                                                                                            GM_of_TO_Regional__c,
                                                                                            Charter_Approved__c,
                                                                                            Contract_Approved__c,
                                                                                            MD_Approved__c,
                                                                                            MR_Approved__c,
                                                                                            PL_Type__c FROM IPM_Financial_Year__C 
                                                                                              WHERE IPM_Financial__c IN:financialIdSet Limit 50000]);
        
            for(IPM_Financial_Year__c fy:projectFinancialYrList){
                
                //For Local Projects 
                if(fy.IPM_Financial__r.Local_Project__r.id != null){
    
                    if(!projFinYrMap.containsKey(fy.Financial_External_ID__c)){
                        projFinYrMap.put(fy.Financial_External_ID__c, new List<IPM_Financial_Year__c>{fy});
                    }
                    else{
                        list<IPM_Financial_Year__c> lstYears = projFinYrMap.get(fy.Financial_External_ID__c);
                        lstYears.add(fy);
                        projFinYrMap.put(fy.Financial_External_ID__c, lstYears);  
                    }
                } //For Regional Projects
                else if(fy.IPM_Financial__r.Regional_Project__r.id != null){
    
                    if(!projFinYrMap.containsKey(fy.Financial_External_ID__c)){
                        projFinYrMap.put(fy.Financial_External_ID__c, new List<IPM_Financial_Year__c>{fy});
                    }
                    else{
                        list<IPM_Financial_Year__c> lstYears = projFinYrMap.get(fy.Financial_External_ID__c);
                        lstYears.add(fy);
                        projFinYrMap.put(fy.Financial_External_ID__c, lstYears);
                    }
    
    
                }//For Global Projects   
                else {
    
                    if(!projfinyrmap.containsKey(fy.Financial_External_ID__c)){
                        projFinYrMap.put(fy.Financial_External_ID__c, new List<IPM_Financial_Year__c>{fy});
                    }
                    else{
                        List<IPM_Financial_Year__c> lstYears = projFinYrMap.get(fy.Financial_External_ID__c);
                        lstYears.add(fy);
                        projFinYrMap.put(fy.Financial_External_ID__c, lstYears);  
                    }
                }        
    
            }
        }
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        } 
        return projFinYrMap;
    }
   
   /*Decription: To build financial external id
   *param1: analytic obj
   *return:String
   */
   
   public String buildFinancialExternal(IPM_Analytics_Otif__c otifAnalytic){
   	
   	   String finExtID=null;
   	   IPM_Analytics_OTIF__c otifAnalyticObj=otifAnalytic;
   	
   	   if(otifAnalyticObj.IPM_Project_Phantom_Non_Key__c==IPM_ConstantUtils.Project  && otifAnalyticObj.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)
   	   {
   	   	  if(otifAnalyticObj.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)
   	   	  {
   	   	  	finExtID=otifAnalyticObj.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
   	   	  }
   	   	  else if(otifAnalyticObj.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL)
   	   	  {
   	   	  	finExtID=otifAnalyticObj.IPM_Project_Name__c+IPM_ConstantUtils.FINANCIAL_CONSOLIDATE;
   	   	  }
   	   	  else if(otifAnalyticObj.IPM_Project_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL)
   	   	  {
   	   	  	finExtID=otifAnalyticObj.IPM_Project_Name__c;
   	   	  }
   	   }
   	   else if(otifAnalyticObj.IPM_Project_Phantom_Non_Key__c==IPM_ConstantUtils.Nonkey)
   	   {
   	   	 finExtID=otifAnalyticObj.IPM_Parent_Project_Name__c+IPM_ConstantUtils.FINANCIAL_NONKEY;
   	   }
   	   else
   	   {
   	   	 finExtID=otifAnalyticObj.IPM_Project_Name__c;
   	   }
   	   
   	   return finExtID;
   	
   }
   
   
   /*********************************************************************************************************************
     * @Description: To set TargetLaunchYearandMonth
     * @param1: IPM_Project__c proj
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
    public IPM_Analytics_OTIF__c setTargetLaunchYearandMonth(IPM_Project__c proj, IPM_Analytics_OTIF__c otifAnalyticProj){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalyticProj; 
        if(String.isNotBlank(proj.IPM_Project_Type__c) && (proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) || proj.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) ||(String.isNotBlank(proj.IPMProject_Span__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)))){
           otifAnalyticObj.IPM_Target_Launch_Month_BD__c = proj.IPM_Target_Launch_Month__c;
           if(proj.IPM_Target_Launch_Year__c != null){
               otifAnalyticObj.IPM_Target_Launch_Year_BD__c = integer.valueOf(proj.IPM_Target_Launch_Year__c);
           }
              
        }
        if (String.isNotBlank(proj.IPMProject_Span__c) && String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) || proj.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
           otifAnalyticObj.IPM_Target_Launch_Month_BB__c = proj.IPM_Target_Launch_Month__c;
           if(proj.IPM_Target_Launch_Year__c != null){
               otifAnalyticObj.IPM_Target_Launch_Year_BB__c = integer.valueOf(proj.IPM_Target_Launch_Year__c);
           }
            //if(String.isNotBlank(string.valueof(proj.IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c))){
            if(String.isNotBlank(string.valueof(proj.IPM_Project_Rollout__r.Target_Launch_Date__c))){
               otifAnalyticObj.IPM_Target_Launch_Month_BD__c = monthNameIntegerToString.get(proj.IPM_Project_Rollout__r.Target_Launch_Date__c.month());
               otifAnalyticObj.IPM_Target_Launch_Year_BD__c = proj.IPM_Project_Rollout__r.Target_Launch_Date__c.Year();   
            }                  
        }
        return otifAnalyticObj;
    }   
    
    
    /*********************************************************************************************************************
     * @Description: To fetch milestone Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Milestone__c>> milestone Records
     *********************************************************************************************************************/     
    public map<Id,list<IPM_Milestone__c>> fetchMilestoneRecords(map<id,IPM_Project__c> projectIdMap){
        
       //Fetching milestone records and creating map 
        projMilestoneMap = new map<id,list<IPM_Milestone__c>>();
        try{
        list<IPM_Milestone__c> projMilestoneList = new list<IPM_Milestone__c>([SELECT id,
                                                                                       Name,
                                                                                       IPM_Type_of_gate__c,
                                                                                       IPM_Name__c,
                                                                                       IPM_Due_Date__c,                                                                            
                                                                                       IPM_Completed_on__c,
                                                                                       IPM_Proposed_Date__c,                                                                           
                                                                                       IPM_Target_Launch_Year__c,
                                                                                       IPM_Target_Launch_Month__c,
                                                                                       IPM_Actual_Target_Launch_Year__c,
                                                                                       IPM_Actual_Target_Launch_Month__c,
                                                                                       IPM_Project__r.id,
                                                                                       IPM_Type_of_Milestone__c,
                                                                                       IPM_Project__r.IPM_Project_Name__c,
                                                                                       IPM_Due_Date_Capability__c,
                                                                                       IPM_Due_Date_Feasibility__c,
                                                                                       IPM_Due_Date_Idea__c,
                                                                                       IPM_Due_Date_Market_Deployment__c,
                                                                                       IPM_Due_Date_Market_Ready__c                                                                       
                                                                               FROM IPM_Milestone__c WHERE IPM_Project__r.id IN:projectIdMap.keyset() Limit 50000]);
    
            for(IPM_Milestone__c im:projMilestoneList){
                if(String.isNotBlank(im.IPM_Type_of_Milestone__c) && (im.IPM_Type_of_Milestone__c.equalsignorecase(IPM_Utils.Standard) || im.IPM_Type_of_Milestone__c.equalsignorecase(IPM_ConstantUtils.STRING_BET))){            
                    if(!projMilestoneMap.containskey(im.IPM_Project__r.id)){
                        projMilestoneMap.put(im.IPM_Project__r.id, new List<IPM_Milestone__c>{im});  
                    }else{
                        List<IPM_Milestone__c> milestoneList = projMilestoneMap.get(im.IPM_Project__r.id);
                        milestoneList.add(im);
                        projMilestoneMap.put(im.IPM_Project__r.id, milestonelist);              
                    } 
                }
            }
        }
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null);
        }
        
        return projMilestoneMap;
    }
    
    /*********************************************************************************************************************
     * @Description: To fetch rollout Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Project_Rollout__c>> rollout Records
     *********************************************************************************************************************/         
    public map<id,list<IPM_Project_Rollout__c>> fetchRolloutRecords(map<id,IPM_Project__c> projectIdMap){
    	//Fetching rollout records for project and creating map
         projRolloutMap = new map<id,list<IPM_Project_Rollout__c>>();
         regionalRolloutset = new set<id> ();
         
        try{
            list<IPM_Project_Rollout__c> projRolloutList = new list<IPM_Project_Rollout__c>([SELECT id,name,IPM_Project__r.id,Market_Cluster_Name__c,RecordTypeId,MCO_Name__c,Regional_Project__c,Regional_Rollout__c,IPM_Status__c,KeyMCO__c,IPM_Company_Card__r.Name,IPM_Company_Card__r.IPM_Total_OpCo_Turnover__c,Target_Launch_Year__c,Regional_Rollout_Phase__c,
																									Local_Rollout_Phase__c,IPM_Project_Job_Status__c,Target_LaunchMonth__c,Target_LaunchYear__c,Regional_Rollout__r.id,Regional_Rollout__r.Name,IPM_Global_OR_Regional__c,
																									IPM_Brand__c,IPM_Parent_Project_Name__c,IPM_Regional_PL__c,IPM_Regional_PL__r.Name,IPM_Project__r.IPM_Phase__c,IPM_Project__r.IPM_ProjectGKM__c,Regional_Project__r.IPM_Phase__c,
																									Regional_Project__r.IPM_ProjectGKM__c,Regional_Project__r.IPM_SourceProjectType__c,Regional_Project__r.Id                                                                    
                                                                                                    FROM IPM_Project_Rollout__c 
                                                                                                    WHERE IPM_Project__r.id IN:projectIdMap.keyset() or Regional_Project__r.Id IN:projectIdMap.keyset() Limit 50000]);
            for(IPM_Project_Rollout__c pr:projRolloutList){
                   
                  if(pr.IPM_Project_Job_Status__c != IPM_ConstantUtils.JOB_STATUS_COMPLETED || String.isBlank(pr.IPM_Regional_PL__c)){
                    
                    if(pr.IPM_Project__r.id != null){
	                    // create map for the Rollouts of the Global Original Project
	                    if(!projRolloutMap.containskey(pr.IPM_Project__r.id) && pr.Regional_Project__r.id==null){
	                        projRolloutMap.put(pr.IPM_Project__r.id, new List<IPM_Project_Rollout__c>{pr});                              
	                    }else if(projRolloutMap.containskey(pr.IPM_Project__r.id) && pr.Regional_Project__r.id==null){                            
	                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.IPM_Project__r.id);
	                        rolloutList.add(pr);
	                        projRolloutMap.put(pr.IPM_Project__r.id, rolloutList);                                          
	                    }
	                    
	                    // create map for the Rollouts of the Regional Rollout Project
	                    else if(pr.Regional_Project__r.Id != null && !projRolloutMap.containskey(pr.Regional_Project__r.Id)){  
	                       projRolloutMap.put(pr.Regional_Project__r.Id, new List<IPM_Project_Rollout__c>{pr});  
	                    }else if(pr.Regional_Project__r.Id != null && projRolloutMap.containskey(pr.Regional_Project__r.Id)){                            
	                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.Regional_Project__r.Id);
	                        rolloutList.add(pr);
	                        projRolloutMap.put(pr.Regional_Project__r.Id, rolloutList);              
	                    }
                    } else if(pr.IPM_Project__r.id == null){
                    
	                    // create map for the Rollouts of the Regional Original Project
	                    if(pr.Regional_Project__r.Id != null && !projRolloutMap.containskey(pr.Regional_Project__r.Id)){  
	                       projRolloutMap.put(pr.Regional_Project__r.Id, new List<IPM_Project_Rollout__c>{pr});  
	                    }else if(pr.Regional_Project__r.Id != null && projRolloutMap.containskey(pr.Regional_Project__r.Id)){                            
	                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.Regional_Project__r.Id);
	                        rolloutList.add(pr);
	                        projRolloutMap.put(pr.Regional_Project__r.Id, rolloutList);              
	                    }
                    }
                   
                    if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE)
                    {                       
                        regionalRolloutset.add(pr.Id); 
                    }
                    else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){ 
                
                      ID regionalRolloutID=pr.Regional_Project__r.id != null?pr.Regional_Project__r.id:pr.Regional_Rollout__r.Id;
                      regionalRolloutset.add(regionalRolloutID); 
                      localRolloutIDSet.add(pr.Id);                        
                    } 
                    
                    // Prepare the map of Regional Rollout Id to corresponding Non-key local rollouts
                    if(pr.Regional_Rollout__c != null && !pr.KeyMCO__c){ 
                        
                        if(!regRLToNKLocalRolloutMap.containsKey(pr.Regional_Rollout__c)){
                            regRLToNKLocalRolloutMap.put(pr.Regional_Rollout__c, new set<Id>{pr.Id});
                        }else{
                            set<Id> localRolloutIdSet = regRLToNKLocalRolloutMap.get(pr.Regional_Rollout__c);
                            localRolloutIdSet.add(pr.Id);
                            regRLToNKLocalRolloutMap.put(pr.Regional_Rollout__c, localRolloutIdSet);
                        } 
                        
                    }
                 }    
            }
        }
        
        catch(Exception ex){  
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        }
        
        return projRolloutMap;
    	    	
    }
    
}
