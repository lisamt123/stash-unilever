/***********************************************************************************************************
    @Description : This class is used to execute the IPM_BD_BB_Report_Batch job to copy project details to
                   analytics object for the BD/BB alignment report.
    @Created Date: 05/10/2015
    @Author: Cognizant
    @Referenced: IPM_BD_BB_Report_Batch
    This class has been declared as Gloabl as it implements Databse.Batchable interface.
 ************************************************************************************************************/

global without sharing class IPM_BD_BB_Report_Batch implements Database.Batchable<sObject> {   

    global final String query;   
    global map<id,IPM_Project__c> projectIdMap = new map<id,IPM_Project__c>(); 
    global list<IPM_Project__c> scopeProjectList = new list<IPM_Project__c>();   
    global set<id> projectIdSet = new set<id>();
    global set<id> rolloutprojectIdSet = new set<id>();
    global map<Id,list<IPM_Project_Rollout__c>> projRolloutMap;
    global map<string,list<IPM_Financial_Year__c>> rolloutFinancialYearmap;  
    global map<id,list<IPM_Financial__c>> rolloutFinancialmap;
    global list<IPM_Analytics__c> analyticRecList;
    global set<id> localRolloutIDSet = new set<id>();
    global Map<Id, String> ipmCountryMap = new map<Id, String>();
    public static final String BB_BD_REPORT_RUNDATE='BD BB Report'; //To fetch BB BD Report last run date from custom setting
    public static String CLASS_NAME = IPM_BD_BB_Report_Batch.class.getName();
    public static string METHOD_NAME='execute';
    public IPM_Reporting__c reportcs = IPM_Reporting__c.getValues(BB_BD_REPORT_RUNDATE); 
    private static string GOLD = 'Gold';
    private static string SILVER = 'Silver';
    private static string BRONZE = 'Bronze';
    private static string N_A = 'NA';
    private static string YES = 'YES';
    private static string NO = 'NO';    
    private static string EMPTY_STRING = '';
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
	
	/* --------- Calender Year Field Maps  starts here ----------------*/
    private static Map<String, String> grossTOCalYrFieldMapping;  // Gross 		Turn Over for Calender Year
    private static Map<String, String> incTOCalYrFieldMapping;    // Incremental Turn Over for Calender Year
    private static Map<String, String> grossGPCalYrFieldMapping; // Gross       Gross Profit for Calender Year 
    private static Map<String, String> incGPCalYrFieldMapping;   // Incremental Gross Profit for Calender Year
    /* --------- Calender Year Field Maps ends here ----------------*/
    
	/* --------- Innovation Year Field Maps starts here ----------------*/    
    private static Map<String, String> grossTOInnvYrFieldMapping;   // Gross 		Turn Over for Innovation Year
    private static Map<String, String> incTOInnvYrFieldMapping;   // Incremental Turn Over for Innovation Year
    private static Map<String, String> grossGPYrFieldMapping;   // Gross       Gross Profit for Innovation Year 
    private static Map<String, String> incGPInnvYrFieldMapping;   // Incremental Gross Profit for Innovation Year
    /* --------- Innovation Year Field Maps ends here ----------------*/
    
    private static Map<String, String> fYearTOFieldMapping; // Global, Regional Turn Over field will be mapped
    private static Map<String, String> fYearGPFieldMapping; // Global, Regional Gross Profitfield will be mapped
    
    public Map<Id, Set<Id>> regRLToNKLocalRolloutMap = new Map<Id, Set<Id>>(); // This map will store Regional Rollout Id to corresponding Non key rollout ids
	
    //Contructor - @@ Param - query string from schedular class  
    global IPM_BD_BB_Report_Batch(String querystr){
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
        List<IPM_Analytics__c> analyticsRecDelList = new list<IPM_Analytics__c>([SELECT id
                                                                                 FROM IPM_Analytics__c WHERE IPM_Project_Id__c IN:projectIdSet Limit 10000]);
            if(!analyticsRecDelList.isEmpty()){
                delete analyticsRecDelList;
            }
        }
        catch(Exception ex)
            {
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null, null, null,null);
                 
            } 
        
        //Map creation logic 

        //Fetching Consolidated Financial  records
        set<id> financialIdSet = new set<id>();
        Map<Id, IPM_Financial__c> projFinMap = new map<Id,IPM_Financial__c>();  // this map will hold project id and corresponding Consolidated financial records
        Map<Id, IPM_Financial__c> regionalProjNKFinMap = new Map<Id, IPM_Financial__c>(); // this map will hold project id and corresponding Non Key financial records
        
        try{   
        list<IPM_Financial__c> projectFinancialList = new list<IPM_Financial__c>([SELECT id,
                                                                                  name,
                                                                                  Financial_External_ID__c,
                                                                                  Display_Name__c, 
                                                                                  Business_Impact_Global__c,
                                                                                  Business_Impact_Regional__c,
                                                                                  Business_Impact_Local__c, 
                                                                                  Parent_Project__r.Name,
                                                                                  Regional_Project__r.id, 
                                                                                  Local_Project__r.id,
                                                                                  Parent_Project__r.id, 
                                                                                  Regional_Project__r.Name, 
                                                                                  Regional_Project__r.IPM_Project_Type__c,
                                                                                  Parent_Project__r.IPM_Project_Type__c,
                                                                                  Local_Project__r.IPM_Project_Type__c,
                                                                                  Local_Project__r.Name,
                                                                                  Misaligned__c,
                                                                                  IPM_Auto_Aligned_Fin_TLD__c,
                                                                                  IPM_Project_Rollout__r.id,
                                                                                  IPM_CPP_Regional__c,
                                                                                  IPM_CPP_Local__c                                                                                  
                                                                                  FROM IPM_Financial__c WHERE Parent_Project__r.Id IN: projectIdMap.keyset() or Regional_Project__r.id IN:projectIdMap.keyset() or Local_Project__r.id IN: projectIdMap.keyset() Limit 50000]);
        
            for(IPM_Financial__c fi:projectFinancialList){
                if(fi.Local_Project__r.id !=null && fi.Local_Project__r.Name == fi.Financial_External_ID__c){
                    projFinMap.put(fi.Local_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Regional_Project__r.id !=null &&  fi.Financial_External_ID__c ==  fi.Regional_Project__r.Name + IPM_Utils.CONSOLIDATED ){
                    projFinMap.put(fi.Regional_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Parent_Project__r.id != null && fi.Financial_External_ID__c == fi.Parent_Project__r.Name + IPM_Utils.CONSOLIDATED ) {
                    projFinMap.put(fi.Parent_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Regional_Project__r.id !=null &&  fi.Financial_External_ID__c == fi.Regional_Project__r.Name + IPM_ConstantUtils.FINANCIAL_NONKEY){
                	regionalProjNKFinMap.put(fi.Regional_Project__r.id, fi);
                }
            }
        } 
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null);
        } 

        //Fetching Financial year records
        Map<Id, List<IPM_Financial_Year__c>> projFinYrMap = new map<Id, List<IPM_Financial_Year__c>>();  //This map will hold project id and financial year records
        try{ 
        list<IPM_Financial_Year__c> projectFinancialYrList = new list<IPM_Financial_Year__c>([SELECT id,
                                                                                              name,
                                                                                              Financial_External_ID__c,
                                                                                              IPM_Financial__r.Parent_Project__r.Id,
                                                                                              IPM_Financial__r.Regional_Project__r.Id,
                                                                                              IPM_Financial__r.Local_Project__r.Id,
                                                                                              IPM_Financial__r.Id,
                                                                                              IPM_Financial__r.Business_Impact_Global__c,
                                                                                              Year__c,
                                                                                              Gross_Profit_Global__c,
                                                                                              Gross_Profit_Regional__c,
                                                                                              Gross_Profit_Local__c,
                                                                                              Turnover_Global__c,
                                                                                              Turnover_Local__c,
                                                                                              Turnover_Regional__c,
                                                                                              Year_Type__c,
                                                                                              PL_Type__c FROM IPM_Financial_Year__C 
                                                                                              WHERE IPM_Financial__c IN:financialIdSet Limit 50000]);
        
            for(IPM_Financial_Year__c fy:projectFinancialYrList){
                
                //For Local Projects 
                if(fy.IPM_Financial__r.Local_Project__r.id != null){
    
                    if(!projFinYrMap.containsKey(fy.IPM_Financial__r.Local_Project__r.id)){
                        projFinYrMap.put(fy.IPM_Financial__r.Local_Project__r.id, new List<IPM_Financial_Year__c>{fy});
                    }
                    else{
                        list<IPM_Financial_Year__c> lstYears = projFinYrMap.get(fy.IPM_Financial__r.Local_Project__r.id);
                        lstYears.add(fy);
                        projFinYrMap.put(fy.IPM_Financial__r.Local_Project__r.id, lstYears);  
                    }
                } //For Regional Projects
                else if(fy.IPM_Financial__r.Regional_Project__r.id != null){
    
                    if(!projFinYrMap.containsKey(fy.IPM_Financial__r.Regional_Project__r.id)){
                        projFinYrMap.put(fy.IPM_Financial__r.Regional_Project__r.id, new List<IPM_Financial_Year__c>{fy});
                    }
                    else{
                        list<IPM_Financial_Year__c> lstYears = projFinYrMap.get(fy.IPM_Financial__r.Regional_Project__r.id);
                        lstYears.add(fy);
                        projFinYrMap.put(fy.IPM_Financial__r.Regional_Project__r.id, lstYears);
                    }
    
    
                }//For Global Projects   
                else {
    
                    if(!projfinyrmap.containsKey(fy.IPM_Financial__r.Parent_Project__r.id)){
                        projFinYrMap.put(fy.IPM_Financial__r.Parent_Project__r.id, new List<IPM_Financial_Year__c>{fy});
                    }
                    else{
                        List<IPM_Financial_Year__c> lstYears = projFinYrMap.get(fy.IPM_Financial__r.Parent_Project__r.id);
                        lstYears.add(fy);
                        projFinYrMap.put(fy.IPM_Financial__r.Parent_Project__r.id, lstYears);  
                    }
                }        
    
            }
        }
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        } 

        //Fetching milestone records and creating map 
        map<Id,list<IPM_Milestone__c>> projMilestoneMap = new map<id,list<IPM_Milestone__c>>();
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
                                                                               IPM_Project__r.Name                                                                       
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
        
        //Fetching rollout records for project and creating map
         projRolloutMap = new map<id,list<IPM_Project_Rollout__c>>();
         set<id> regionalRolloutset = new set<id> ();
        try{
            list<IPM_Project_Rollout__c> projRolloutList = new list<IPM_Project_Rollout__c>([SELECT id,
                                                                                                    name,
                                                                                                    IPM_Project__r.id,
                                                                                                    Market_Cluster_Name__c,
                                                                                                    RecordTypeId,
                                                                                                    MCO_Name__c,
                                                                                                    Regional_Project__c,
                                                                                                    Regional_Rollout__c,
                                                                                                    IPM_Status__c,
                                                                                                    KeyMCO__c,
                                                                                                    IPM_Company_Card__r.Name,
                                                                                                    IPM_Company_Card__r.IPM_Total_OpCo_Turnover__c,
                                                                                                    Target_Launch_Year__c,
                                                                                                    Regional_Rollout_Phase__c,
                                                                                                    Local_Rollout_Phase__c,
                                                                                                    IPM_Project_Job_Status__c,
                                                                                                    Target_LaunchMonth__c,
                                                                                                    Target_LaunchYear__c,
                                                                                                    Regional_Rollout__r.id,
                                                                                                    Regional_Rollout__r.Name,
                                                                                                    IPM_Global_OR_Regional__c,
                                                                                                    IPM_Brand__c,
                                                                                                    IPM_Parent_Project_Name__c,
                                                                                                    IPM_Regional_PL__c,
                                                                                                    IPM_Regional_PL__r.Name,
                                                                                                    IPM_Project__r.IPM_Phase__c,
		                                                                                    IPM_Project__r.IPM_ProjectGKM__c,
		                                                                                    Regional_Project__r.IPM_Phase__c,
		                                                                                    Regional_Project__r.IPM_ProjectGKM__c,                                                                                                    
                                                                                                    Regional_Project__r.IPM_SourceProjectType__c,
                                                                                                    Regional_Project__r.Id                                                                    
                                                                                                    FROM IPM_Project_Rollout__c 
                                                                                                    WHERE IPM_Project__r.id IN:projectIdMap.keyset() or Regional_Project__r.Id IN:projectIdMap.keyset() Limit 50000]);
            for(IPM_Project_Rollout__c pr:projRolloutList){
                   
                  if(pr.IPM_Project_Job_Status__c!=IPM_ConstantUtils.JOB_STATUS_COMPLETED || String.isBlank(pr.IPM_Regional_PL__c)){
                  	// create map for the Rollouts of the Global Original Project
                    if(pr.IPM_Project__r.id != null && !projRolloutMap.containskey(pr.IPM_Project__r.id) && pr.Regional_Project__r.id==null){
                        projRolloutMap.put(pr.IPM_Project__r.id, new List<IPM_Project_Rollout__c>{pr});                              
                    }else if(pr.IPM_Project__r.id != null && projRolloutMap.containskey(pr.IPM_Project__r.id) && pr.Regional_Project__r.id==null){                            
                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.IPM_Project__r.id);
                        rolloutList.add(pr);
                        projRolloutMap.put(pr.IPM_Project__r.id, rolloutList);                                          
                    }
                    // create map for the Rollouts of the Regional Original Project
                    else if(pr.IPM_Project__r.id == null && pr.Regional_Project__r.Id != null && !projRolloutMap.containskey(pr.Regional_Project__r.Id)){  
                       projRolloutMap.put(pr.Regional_Project__r.Id, new List<IPM_Project_Rollout__c>{pr});  
                    }else if(pr.IPM_Project__r.id == null && pr.Regional_Project__r.Id != null && projRolloutMap.containskey(pr.Regional_Project__r.Id)){                            
                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.Regional_Project__r.Id);
                        rolloutList.add(pr);
                        projRolloutMap.put(pr.Regional_Project__r.Id, rolloutList);              
                    }
                    // create map for the Rollouts of the Regional Rollout Project
                    else if(pr.IPM_Project__r.id != null && pr.Regional_Project__r.Id != null && !projRolloutMap.containskey(pr.Regional_Project__r.Id)){  
                       projRolloutMap.put(pr.Regional_Project__r.Id, new List<IPM_Project_Rollout__c>{pr});  
                    }else if(pr.IPM_Project__r.id != null && pr.Regional_Project__r.Id != null && projRolloutMap.containskey(pr.Regional_Project__r.Id)){                            
                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.Regional_Project__r.Id);
                        rolloutList.add(pr);
                        projRolloutMap.put(pr.Regional_Project__r.Id, rolloutList);              
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
        
        //To fetch the financials for the rollout project when it is in Ideas phase
        rolloutFinancialmap = new map<id,list<IPM_Financial__c>> ();
        set<id> finIdSet = new set<id>();
        try{
            list<IPM_Financial__c> projRolloutFinList = new list<IPM_Financial__c>([SELECT  id,
                                                                                            name,
                                                                                            RecordTypeId,  
                                                                                            Display_Name__c, 
                                                                                            Financial_External_ID__c,
                                                                                            IPM_Project_Rollout__c,
                                                                                            IPM_Project_Rollout__r.Id,
                                                                                            IPM_Project_Rollout__r.Name,
                                                                                            Regional_Project__c,
                                                                                            Regional_Project__r.id, 
                                                                                            IPM_CPP_Regional__c,
                                                                                            IPM_CPP_Local__c,
                                                                                            Year_1_iTO_Global__c,
                                                                                            Year_1_iTO_Regional__c
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
        
        //To fetch the financial year for the rollout project when it is in Ideas phase
        rolloutFinancialYearmap = new map<string,list<IPM_Financial_Year__c>> ();
        try{
            list<IPM_Financial_Year__c> projRolloutFinYearList = new list<IPM_Financial_Year__c>([SELECT    id,   
                                                                                                            name,
                                                                                                            Financial_External_ID__c,
                                                                                                            IPM_Financial__r.Parent_Project__r.Id,
                                                                                                            IPM_Financial__r.Regional_Project__r.Id,
                                                                                                            IPM_Financial__r.Local_Project__r.Id,
                                                                                                            IPM_Financial__r.Id,
                                                                                                            IPM_Financial__r.Business_Impact_Global__c,
                                                                                                            Year__c,
                                                                                                            Gross_Profit_Global__c,
                                                                                                            Gross_Profit_Regional__c,
                                                                                                            Gross_Profit_Local__c,
                                                                                                            Turnover_Global__c,
                                                                                                            Turnover_Local__c,
                                                                                                            Turnover_Regional__c,
                                                                                                            Year_Type__c,
                                                                                                            PL_Type__c
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

        //Fetching country records and creating map
          
        try{
        List<IPM_Country__c> ipmCountryList= new list<IPM_Country__c>([SELECT Country_Code__c,
                                                                       Country_Name__c,
                                                                       IPM_Project__r.id,
                                                                       IPM_Project__r.IPMProject_Span__c,
                                                                       IPM_Local_Project__r.Id,
                                                                       IPM_Local_Project__r.IPMProject_Span__c,
                                                                       IPM_Regional_Project__r.Id,
                                                                       IPM_Regional_Project__r.IPMProject_Span__c,
                                                                       Local_Rollout__r.id
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
        
        //End of Map creation logic ***

        //Start - Analytics Object Record Insertion 
        analyticRecList = new list<IPM_Analytics__c>();

        for(IPM_Project__c p:scopeProjectList){ 

            //Copyin IPM Project field values
            IPM_Analytics__c analyticObj = new IPM_Analytics__c();
            analyticObj.IPM_Project_Id__c = p.id;

            if(String.isNotBlank(p.Project_External_ID__c)){
                analyticObj.IPM_External_ID__c = p.Project_External_ID__c;
            }else {
                analyticObj.IPM_External_ID__c = p.id;
            }

            analyticObj.IPM_Project_Name__c = p.IPM_project_name__c;
            analyticObj.IPM_Project_Description__c = p.IPM_Project_Description__c;
            analyticObj.IPM_Parent_Project_Name__c = p.IPM_Parent_Project__r.IPM_project_name__c;  
            analyticObj.IPM_Project_Leader__c = p.IPM_Project_Leader__r.Name;
            analyticObj.IPM_Deputy_Project_Leader__c = p.Deputy_Project_Leader__r.Name;
            analyticObj.IPM_Finance_Member__c = p.IPM_Finance_Lead__r.Name;
            analyticObj.IPM_Technical_Project_Leader__c = p.IPM_Technical_Project_Leader__r.Name;  
            analyticObj.IPM_Project_Span__c = p.IPMProject_Span__c;
            analyticObj.IPM_Project_Type__c = p.IPM_Project_Type__c;
            analyticObj.IPM_Company__c = p.IPM_Company_Card__r.Name;
            analyticObj.IPM_Category_Group__c = p.IPM_Category_Group__c;
            analyticObj.IPM_Category__c = p.IPM_Category_Text__c;
            analyticObj.IPM_Brand_Positioning__c = p.IPM_Brand_Positioning__c;
            analyticObj.IPM_Market_Place_Activity__c = p.IPM_Answer_of_Q1__c;
            analyticObj.IPM_Consumer_Value_Perception__c = p.IPM_Answer_of_Q2__c;
            analyticObj.IPM_Enabling_Technology__c = p.IPM_Answer_of_Q3__c;
            analyticObj.IPM_Strategic_Intent__c = p.IPM_Strategic_Intent__c;
            analyticObj.IPM_Project_Start_Date__c = p.IPM_Project_Start_Date__c !=null?p.IPM_Project_Start_Date__c:p.CreatedDate.date();
            analyticObj.IPM_Cluster_Project__c = p.IPM_Clusters__c;
            analyticObj.IPM_Phase__c = p.IPM_Phase__c;
            analyticObj.IPM_Fast_Track_Project__c = p.IPM_Fast_Track_Project__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;                     
            analyticObj.IPM_Exempt_from_Threshold__c = p.Exempt_from_Threshold__c; 
            analyticObj.IPM_Stopped__c= p.Is_Archieved__c?IPM_ConstantUtils.OTIF_YES:'';
            analyticObj.IPM_Project_Route__c = p.IPM_Complexity__c;
            analyticObj.IPM_BET_Name__c = p.BET__r.Name;
            analyticObj.IPM_BET_Current_Status__c = p.BETCurrentStatus__c;
            analyticObj.IPM_BETOwner__c = p.BET__r.Owner.Name;
            
            if(String.isNotBlank(p.IPMProject_Span__c) && String.isNotBlank(p.IPM_Project_Type__c) && (p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL) || p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))){
                analyticObj.IPM_Gate_Keeping_Model__c = p.IPM_ProjectGKM__c;     
            }
            
            if(String.isNotBlank(p.IPM_Category_Text__c) && p.IPM_Category_Text__c.equalsignorecase(IPM_ConstantUtils.LAUNDRY_CONSTANT)){
            	analyticObj.IPM_Sub_Category__c =  p.IPM_Market__c; 
            }
            else if(String.isNotBlank(p.IPM_Sub_sector__c)){
            	analyticObj.IPM_Sub_Category__c =  p.IPM_Sub_sector__c; 
            }
            else{
            	analyticObj.IPM_Sub_Category__c =  p.IPM_Market__c; 
            }
                        
            if(String.isNotBlank(p.IPMProject_Span__c) && !p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) && String.isNotBlank(p.IPM_Project_Type__c) && (!p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)) &&  String.isNotBlank(p.IPM_Phase__c) && p.IPM_Phase__c.equalsignorecase(IPM_ConstantUtils.PHASE_IDEAS)){
                analyticObj.IPM_Key_NonKey__c = p.IPM_Project_Rollout__r.KeyMCO__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;
            }

            if(String.isNotBlank(p.IPMProject_Span__c) && (p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) || p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional))){
                analyticObj.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
            }
            else if(String.isNotBlank(p.IPMProject_Span__c) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local))
            {
                analyticObj.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
                analyticObj.IPM_Market_Cluster__c = p.Market_Cluster_Name__c;                 
                analyticObj.IPM_Brand__c = p.IPM_LocalProject_Brand__c;       
            }
			
            if(String.isNotBlank(p.IPM_Project_Type__c) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT)){
                analyticObj.IPM_Geography__c = p.IPMProject_Span__c.equalsignorecase(IPM_ConstantUtils.PROJECT_SPAN_GLOBAL)?IPM_Utils.valueGlobal:EMPTY_STRING;       
                analyticObj.IPM_White_Space_Project__c = p.IPM_White_Space_Project__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;     
            }
            else if(String.isNotBlank(p.IPM_Project_Type__c) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
                analyticObj.IPM_Geography__c = p.Market_Cluster_Name__c;
            }
            else if(String.isNotBlank(p.IPM_Project_Type__c) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
                if(ipmCountryMap.containskey(p.id)){ analyticObj.IPM_Geography__c = ipmCountryMap.get(p.id);}
            }

            if(String.isNotBlank(p.IPM_Category_Text__c) && String.isNotBlank(p.IPM_Platform_Formula__c)){
                analyticObj.IPM_Platform__c = p.IPM_Platform_Formula__c;
            }
            // Populate target launch year & month for Global and Regional projects
            if(String.isNotBlank(p.IPM_Project_Type__c) && (p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) || p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) ||(String.isNotBlank(p.IPMProject_Span__c) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)))){
                analyticObj.IPM_Target_Launch_Month_BD__c = p.IPM_Target_Launch_Month__c;
                if(p.IPM_Target_Launch_Year__c != null){
                    analyticObj.IPM_Target_Launch_Year_BD__c = integer.valueOf(p.IPM_Target_Launch_Year__c);
                }
            }
            // Populate target launch year & month for Local projects
            if (String.isNotBlank(p.IPMProject_Span__c) && String.isNotBlank(p.IPM_Project_Type__c) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)){
                analyticObj.IPM_Target_Launch_Month_BB__c = p.IPM_Target_Launch_Month__c;                
                
                if(p.IPM_Target_Launch_Year__c != null){
                    analyticObj.IPM_Target_Launch_Year_BB__c = integer.valueOf(p.IPM_Target_Launch_Year__c);
                }
                
                
                if(String.isNotBlank(string.valueof(p.IPM_Project_Rollout__r.Target_Launch_Date__c))){
                    analyticObj.IPM_Target_Launch_Month_BD__c = monthNameIntegerToString.get(p.IPM_Project_Rollout__r.Target_Launch_Date__c.month());
                    analyticObj.IPM_Target_Launch_Year_BD__c = p.IPM_Project_Rollout__r.Target_Launch_Date__c.Year();   
                }                  
            }

            //Global Project Business Impact Global will be copy to Global,Regional & Local project
            if(projFinmap.containskey(p.Id)){ 
                analyticObj.IPM_Business_Impact_BD__c =(String.isNotBlank(p.IPM_Project_Type__c) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))?projFinMap.get(p.id).Business_Impact_Global__c:EMPTY_STRING; 
                analyticObj.IPM_Target_Launch_Date_Aligned__c = (p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))?(projFinMap.get(p.id).Misaligned__c? NO:((p.IPM_Misalligned__c== YES) ? YES : NO)):null; // Auto_Aligned will only be checked for local projects
                analyticObj.IPM_Financials_Aligned__c = (p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))?(projFinMap.get(p.id).Misaligned__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO):null;
                // CPP BD
                analyticObj.IPM_Company_Project_Priority_BD__c = (p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))?projFinMap.get(p.id).IPM_CPP_Regional__c:null;
                //CPP BB
                analyticObj.IPM_Company_Project_Priority_BB__c = (p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && !p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL))?projFinMap.get(p.id).IPM_CPP_Local__c:null;
               
            }  
            
            
            // Copying Milestone related fields 
            analyticObj = processMilestoneDetails(projMilestoneMap, analyticObj, p);
            
            // //Copying IPM Financial Year fields
            if( analyticObj != null && p != null){ 
            	analyticObj = processProjectFinancial(analyticObj,  p, projFinYrMap);
            }
            
            analyticreclist.add(analyticObj);  
            
            if(projRolloutMap.containskey(analyticObj.IPM_Project_Id__c)){
              List<IPM_Analytics__c> rollAnalyticlist = new List<IPM_Analytics__c> (addrolloutproject(analyticObj));
                if(!rollAnalyticlist.isEmpty()){
                  analyticreclist.addall(rollAnalyticlist);                
                }               
            }  
            
            // For Non Key Financials  
            if(regionalProjNKFinMap.containskey(analyticObj.IPM_Project_Id__c)){
            	
            	IPM_Financial__c nonKeyFinancial = regionalProjNKFinMap.get(analyticObj.IPM_Project_Id__c);
            	IPM_Analytics__c nonKeyrollAnalytic = addNonKeyFinancial(analyticObj, nonKeyFinancial, p, null);
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
	
    // Method to get records for Non Key Financials
    public IPM_Analytics__c addNonKeyFinancial(IPM_Analytics__c parentAnalytic, IPM_Financial__c nonKeyFinancial, IPM_Project__c project, IPM_Project_Rollout__c projectRollout){
    	IPM_Analytics__c parent = parentAnalytic;
    	
    	IPM_Analytics__c nonKeyAnalytic = new IPM_Analytics__c();
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
    	nonKeyAnalytic.IPM_Key_NonKey__c = IPM_ConstantUtils.OTIF_NO;
    	
    	
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
    		nonKeyAnalytic.IPM_Stopped__c= parentAnalytic.IPM_Stopped__c;
    		nonKeyAnalytic.IPM_Market_Cluster__c = project.Market_Cluster_Name__c;
    	}
    	else if(projectRollout!=null){
    		nonKeyAnalytic.IPM_Market_Cluster__c = projectRollout.Market_Cluster_Name__c;
    	}
    	nonKeyAnalytic = processProjectRolloutFinancial(nonKeyAnalytic, nonKeyFinancial.Financial_External_ID__c, projectRollout);
    	
    	return nonKeyAnalytic;
    }
    
    /*********************************************************************************************************************
     * @Description: To get records for each rollout project for the parent project which is in Ideas phase
     * @param1: IPM_Analytics__c (Parent prject Analytic record to be inserted)
     * @return: List<IPM_Analytics__c> records for each rollout project to be inserted in Analytic object for reporting  
     *********************************************************************************************************************/

    public List<IPM_Analytics__c> addrolloutproject (IPM_Analytics__c parentAnalytic){         
       
        IPM_Analytics__c parent = parentAnalytic;
        list<IPM_Analytics__c> analyticRolloutList = new list<IPM_Analytics__c>();
         	   
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
    public void rolloutProjectHelp(IPM_Project_Rollout__c pr, IPM_Analytics__c parent, list<IPM_Analytics__c> analyticRolloutList)
    {
        IPM_Analytics__c analyticObj = new IPM_Analytics__c();
        id regionalrolloutid=null;
            
        // project Rollout related details to be copied  
        analyticObj = setRolloutProjectdetails(analyticObj, pr, parent);
            
        if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE){
            regionalrolloutid = pr.Id; 
            for(IPM_Financial__c financial : rolloutFinancialmap.get(regionalrolloutid)){
              	 if(financial.Financial_External_ID__c == pr.name + IPM_ConstantUtils.FINANCIAL_NONKEY){
              	     IPM_Analytics__c analyticNKObj = new IPM_Analytics__c();
              	     analyticNKObj = addNonKeyFinancial(analyticObj, financial, null, pr);
              	     analyticRolloutList.add(analyticNKObj);
              	     break; 
                 } 
            }    
                                            
        }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){
              regionalrolloutid=pr.Regional_Project__c != null?pr.Regional_Project__r.id:pr.Regional_Rollout__r.id; 
              Boolean bdGlobal=pr.IPM_Project__c != null?(pr.Regional_Project__c != null?false:true):false; 
              String localFinExternalID=pr.name;
              // To set the CPP details - CPP BD
              analyticObj = setRolloutFinancialdetails(analyticObj, regionalrolloutid, pr.IPM_Company_Card__r.IPM_Total_OpCo_Turnover__c,bdGlobal,localFinExternalID); 
        } 
        rolloutProjectSubHelp(regionalrolloutid,pr,analyticObj);
        analyticRolloutList.add(analyticObj);
    }
    /***************************************************
    *************/
    public void rolloutProjectSubHelp(id regionalrolloutid, IPM_Project_Rollout__c pr, IPM_Analytics__c analyticObject1)
    {
    	string finExtId = '';
    	if(regionalrolloutid != null && rolloutFinancialmap.containskey(regionalrolloutid)){ 
       	   for(IPM_Financial__c fir:rolloutFinancialmap.get(regionalrolloutid)){
               if((pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE && fir.Financial_External_ID__c == pr.name + IPM_Utils.CONSOLIDATED) || (pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE && fir.Financial_External_ID__c == pr.name)){
                   
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
     * @param1: IPM_Analytics__c, String, IPM_Project_Rollout__c
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/    
    public IPM_Analytics__c setRolloutProjectdetails(IPM_Analytics__c analyticObj, IPM_Project_Rollout__c pr, IPM_Analytics__c parent){
      //copy Values from rollout record
        analyticObj.IPM_Project_Name__c = pr.name;
        analyticObj.IPM_Company__c = pr.IPM_Company_Card__r.Name; // as per the update it will be populated by Unilever report tool
        analyticObj.IPM_Target_Launch_Month_BD__c = pr.Target_LaunchMonth__c;
        if(pr.Target_LaunchYear__c != null){
            analyticObj.IPM_Target_Launch_Year_BD__c = integer.valueOf(pr.Target_LaunchYear__c) ;
        }
        analyticObj.IPM_Parent_Project_Name__c = pr.IPM_Parent_Project_Name__c; 
        analyticObj.IPM_Project_Leader__c = pr.IPM_Regional_PL__r.Name;
        //Copy values From Parent project
        analyticObj.IPM_Project_Id__c = parent.IPM_Project_Id__c;                    
        analyticObj.IPM_Project_Description__c = parent.IPM_Project_Description__c;
        analyticObj.IPM_Project_Type__c = IPM_Utils.Rollout;
        analyticObj.IPM_Category_Group__c = parent.IPM_Category_Group__c;
        analyticObj.IPM_Category__c = parent.IPM_Category__c;
        analyticObj.IPM_Brand_Positioning__c = parent.IPM_Brand_Positioning__c;
        analyticObj.IPM_Market_Place_Activity__c = parent.IPM_Market_Place_Activity__c;
        analyticObj.IPM_Consumer_Value_Perception__c = parent.IPM_Consumer_Value_Perception__c;
        analyticObj.IPM_Enabling_Technology__c = parent.IPM_Enabling_Technology__c;
        analyticObj.IPM_Strategic_Intent__c = parent.IPM_Strategic_Intent__c;
        analyticObj.IPM_Exempt_from_Threshold__c = parent.IPM_Exempt_from_Threshold__c;
        analyticObj.IPM_Expected_Charter_Approval_Date__c = parent.IPM_Expected_Charter_Approval_Date__c;
        analyticObj.IPM_Charter_Approved_Date__c = parent.IPM_Charter_Approved_Date__c;  
        analyticObj.IPM_Charter_Proposed_Date__c = parent.IPM_Charter_Proposed_Date__c;
        analyticObj.IPM_Expected_Contract_Approval_Date__c = parent.IPM_Expected_Contract_Approval_Date__c;
        analyticObj.IPM_Expected_Market_Ready_Approval_Date__c = parent.IPM_Expected_Market_Ready_Approval_Date__c;
        analyticObj.IPM_Expected_Market_Deployment_App_Date__c = parent.IPM_Expected_Market_Deployment_App_Date__c;
        analyticObj.IPM_BET_First_Release_Due_Date__c = parent.IPM_BET_First_Release_Due_Date__c;
        analyticObj.IPM_BET_First_Released_On_Date__c = parent.IPM_BET_First_Released_On_Date__c;
        analyticObj.IPM_BET_Final_Release_Due_date__c = parent.IPM_BET_Final_Release_Due_date__c;
        analyticObj.IPM_BET_Final_Released_On_date__c = parent.IPM_BET_Final_Released_On_date__c;
        
        if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE){
            analyticObj.IPM_Project_Span__c =IPM_Utils.Regional;
            analyticObj.IPM_Geography__c = pr.Market_Cluster_Name__c;
            analyticObj.IPM_Phase__c = pr.Regional_Rollout_Phase__c;
            analyticObj.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
            analyticObj.IPM_Platform__c = parent.IPM_Platform__c;
            analyticObj.IPM_Stopped__c= parent.IPM_Stopped__c;
        }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE ){
            analyticObj.IPM_Project_Span__c = IPM_Utils.Local;
            analyticObj.IPM_Geography__c = ipmCountryMap.containskey(pr.id)?ipmCountryMap.get(pr.id):'';
            analyticObj.IPM_Market_Cluster__c = pr.Market_Cluster_Name__c;
            analyticObj.IPM_Phase__c = pr.Regional_Project__c==null?pr.IPM_Project__r.IPM_Phase__c:pr.Regional_Project__r.IPM_Phase__c;
            analyticObj.IPM_Key_NonKey__c = pr.KeyMCO__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;
            analyticObj.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
            analyticObj.IPM_Brand__c = pr.IPM_Brand__c;
            analyticObj.IPM_Stopped__c= parent.IPM_Stopped__c;
        } 
      return analyticObj;
    }
    
    // Method to set project related financial records
    public IPM_Analytics__c processProjectFinancial(IPM_Analytics__c analyticObj, IPM_Project__c project, map<Id, List<IPM_Financial_Year__c>> projFinYrMap){
    	
    	IPM_Analytics__c ipmAnalytic = analyticObj;
    	String strFinancialScope = IPM_ConstantUtils.IPMGLOBAL;
    	
    	if(String.isNotBlank(project.IPM_Phase__c) && String.isNotBlank(project.IPM_ProjectGKM__c) ){
    		String strKey =  project.IPM_ProjectGKM__c + IPM_ConstantUtils.HYPHEN_DELIMITER + project.IPM_Phase__c;
    		
    		strFinancialScope = IPM_Reporting__c.getValues(strKey).IPM_FinancialScope__c;
    	}
    	
    	// Financial year related to Global/Regional/Local Projects
    	if(projFinYrmap.containskey(project.id) && String.isNotBlank(project.IPMProject_Span__c)){
	    	for(IPM_Financial_Year__c financialYear : projFinYrMap.get(project.Id)){
					populateFinancialDetails(ipmAnalytic, financialYear, strFinancialScope);
	    	}
    	}
    	return ipmAnalytic; 
    }
    // Method to set project rollout related financial records
    public IPM_Analytics__c processProjectRolloutFinancial(IPM_Analytics__c analyticObj, String financialExtId, IPM_Project_Rollout__c projectRollout){
    	
    	IPM_Analytics__c ipmAnalytic = analyticObj; 
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
    	
    	
    	if(rolloutFinancialYearmap.containsKey(financialExtId)){
	    	// Financial year related to project rollouts
	    	for(IPM_Financial_Year__c financialYear : rolloutFinancialYearmap.get(financialExtId)){
					populateFinancialDetails(ipmAnalytic, financialYear, strFinancialScope);
	    	}
    	}
    	return ipmAnalytic;
    }
    // Method to set the fianancial year details on IPM Analytic object
    public IPM_Analytics__c populateFinancialDetails(IPM_Analytics__c analyticObj, IPM_Financial_Year__c financialYear, String strScope){
    	
    	IPM_Analytics__c ipmAnalytic = analyticObj; 
    	
    	// Calender Financial Year Check 
    	if(String.isNotBlank(financialYear.Year_Type__c) && financialYear.Year_Type__c.equalsignorecase(IPM_Utils.Calendar)){
    		
    		// PL Type check for Gross
    		if(String.isNotBlank(financialYear.PL_Type__c) && financialYear.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
    			
    			ipmAnalytic = populateGrossForCalendar(ipmAnalytic, financialYear, strScope);    		
    			
    			
    		} else if(String.isNotBlank(financialYear.PL_Type__c) && financialYear.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){ // PL Type check for Incremental
    		
				ipmAnalytic = populateIncForCalendar(ipmAnalytic, financialYear, strScope);
				
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
    
    public IPM_Analytics__c populateGrossForCalendar(IPM_Analytics__c ipmAnalytic, IPM_Financial_Year__c financialYear, String strScope){
    	String strAnalyticTOFieldName = grossTOCalYrFieldMapping.get(financialYear.Name);
    	String strAnalyticGPFieldName = grossGPCalYrFieldMapping.get(financialYear.Name);
    	
    	String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
    	String strFYearGPFieldName = fYearGPFieldMapping.get(strScope);
    	    	
		
		if(strAnalyticTOFieldName != null && strFYearTOFieldName != null){
			ipmAnalytic.put(strAnalyticTOFieldName, financialYear.get(strFYearTOFieldName));
		}
		if(strAnalyticGPFieldName != null && strFYearGPFieldName != null){
			ipmAnalytic.put(strAnalyticGPFieldName, financialYear.get(strFYearGPFieldName));
		}
		
		// Calendar Y3 gTO(BD) 
		if(strFYearTOFieldName != null && String.isNotBlank(financialYear.Year__c) && financialYear.Year__c == IPM_Utils.n3){
			ipmAnalytic.put( 'IPM_Y3_gTO_BD__c' , financialYear.get(strFYearTOFieldName));
		}
		
		return ipmAnalytic;
    }
    
    
    public IPM_Analytics__c populateIncForCalendar(IPM_Analytics__c ipmAnalytic, IPM_Financial_Year__c financialYear, String strScope){
    	String strAnalyticTOFieldName = incTOCalYrFieldMapping.get(financialYear.Name);
    	String strAnalyticGPFieldName = incGPCalYrFieldMapping.get(financialYear.Name); 
    	    	
		String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
    	String strFYearGPFieldName = fYearGPFieldMapping.get(strScope);
		
		
		if(strAnalyticTOFieldName != null && strFYearTOFieldName != null){
			ipmAnalytic.put(strAnalyticTOFieldName, financialYear.get(strFYearTOFieldName));	
		}
		if(strAnalyticGPFieldName != null && strFYearGPFieldName != null){
			ipmAnalytic.put(strAnalyticGPFieldName, financialYear.get(strFYearGPFieldName));
		}
		
		// Calendar Y3 iTO(BD)	
		if(strFYearTOFieldName != null && String.isNotBlank(financialYear.Year__c) && financialYear.Year__c == IPM_Utils.n3){
			ipmAnalytic.put( 'IPM_Y3_iTO_BD__c' , financialYear.get(strFYearTOFieldName));
		}
		
		return ipmAnalytic;

    }
    
    public IPM_Analytics__c populateGrossForInnovation(IPM_Analytics__c ipmAnalytic, IPM_Financial_Year__c financialYear, String strScope){
    	String strAnalyticTOFieldName = grossTOInnvYrFieldMapping.get(financialYear.Name);
    	String strAnalyticGPFieldName = grossGPYrFieldMapping.get(financialYear.Name);
    	    	
		String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
    	String strFYearGPFieldName = fYearGPFieldMapping.get(strScope);
		
		if(strAnalyticTOFieldName != null && strFYearTOFieldName != null){
			ipmAnalytic.put(strAnalyticTOFieldName, financialYear.get(strFYearTOFieldName));	
		}
		if(strAnalyticGPFieldName != null && strFYearGPFieldName != null){
			ipmAnalytic.put(strAnalyticGPFieldName, financialYear.get(strFYearGPFieldName));
		}
		
		return ipmAnalytic;

    }
    
    public IPM_Analytics__c populateIncForInnovation(IPM_Analytics__c ipmAnalytic, IPM_Financial_Year__c financialYear, String strScope){
    	String strAnalyticTOFieldName = incTOInnvYrFieldMapping.get(financialYear.Name);
    	String strAnalyticGPFieldName = incGPInnvYrFieldMapping.get(financialYear.Name);
    	    	
		String strFYearTOFieldName = fYearTOFieldMapping.get(strScope);
    	String strFYearGPFieldName = fYearGPFieldMapping.get(strScope);
		
		if(strAnalyticTOFieldName != null && strFYearTOFieldName != null){
			ipmAnalytic.put(strAnalyticTOFieldName, financialYear.get(strFYearTOFieldName));	
		}
		if(strAnalyticGPFieldName != null && strFYearGPFieldName != null){
			ipmAnalytic.put(strAnalyticGPFieldName, financialYear.get(strFYearGPFieldName));
		}
		
		return ipmAnalytic;

    }
    
	public void prepareFinancialGenericTemplate(){
	Integer startYear = reportcs.IPM_Start_Year__c.intValue();
    	
    	grossTOCalYrFieldMapping = new Map<String, String>();
    	incTOCalYrFieldMapping = new Map<String, String>();
    	grossGPCalYrFieldMapping = new Map<String, String>();
    	incGPCalYrFieldMapping = new Map<String, String>();
    	
    	grossTOInnvYrFieldMapping = new Map<String, String>();
    	incTOInnvYrFieldMapping = new Map<String, String>();
    	grossGPYrFieldMapping = new Map<String, String>();
    	incGPInnvYrFieldMapping = new Map<String, String>();
    	
    	fYearTOFieldMapping = new Map<String, String>{IPM_ConstantUtils.IPMGLOBAL => 'Turnover_Global__c', IPM_ConstantUtils.IPMREGIONAL => 'Turnover_Regional__c'};
    	fYearGPFieldMapping = new Map<String, String>{IPM_ConstantUtils.IPMGLOBAL => 'Gross_Profit_Global__c', IPM_ConstantUtils.IPMREGIONAL => 'Gross_Profit_Regional__c'};
    	String fYearFieldAPIName = '';
    	
		String strRefernceCalYear = '';
		String strRefernceInnYear = '';
		    	
    	for(integer i = 0; i <= 8; i++){

	    		strRefernceCalYear = String.valueOf(startYear + i); 
	    		
	    		fYearFieldAPIName = 'IPM_Gross_TO_Y' + String.valueOf(i) + '_BD__c';
	    		grossTOCalYrFieldMapping.put(strRefernceCalYear, fYearFieldAPIName);
	    			
				fYearFieldAPIName = 'IPM_iTO_Y' + String.valueOf(i) + '_BD__c';
	    		incTOCalYrFieldMapping.put(strRefernceCalYear, fYearFieldAPIName);
	    		
	    		fYearFieldAPIName = 'IPM_GP_Y' + String.valueOf(i) + 'BD__c';
	    		grossGPCalYrFieldMapping.put(strRefernceCalYear, fYearFieldAPIName);
	    		
	    		fYearFieldAPIName = 'IPM_iGP_Y' + String.valueOf(i) + '_BD__c';
	    		incGPCalYrFieldMapping.put(strRefernceCalYear, fYearFieldAPIName);
	    		
	    		if(i >= 1 && i < 6){
	    			strRefernceInnYear = 'Y' + string.valueOf(i);
	    			fYearFieldAPIName = 'IPM_Y'+ String.valueOf(i) + '_Gross_TO_BD__c';
	    			grossTOInnvYrFieldMapping.put(strRefernceInnYear, fYearFieldAPIName);
	    			
			    	fYearFieldAPIName = 'IPM_Y' + String.valueOf(i) + '_iTOBD__c';
			    	incTOInnvYrFieldMapping.put(strRefernceInnYear, fYearFieldAPIName);
			    	
			    	fYearFieldAPIName = 'IPM_Y' + String.valueOf(i) + '_GPBD__c';
			    	grossGPYrFieldMapping.put(strRefernceInnYear, fYearFieldAPIName);
			    	
			    	fYearFieldAPIName = 'IPM_Y' + String.valueOf(i) +'_iGP_BD__c';	
			    	incGPInnvYrFieldMapping.put(strRefernceInnYear, fYearFieldAPIName);
	    		}
    		
    	}
    	
    }
    
  
  /*********************************************************************************************************************
     * @Description: To copy rollout related financial details
     * @param1: IPM_Analytics__c, String, IPM_Project_Rollout__c
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics__c setRolloutFinancialdetails(IPM_Analytics__c analyticObj,Id regionalrolloutid, Decimal companyCardTurnOver, Boolean bdGlobal, String localFinExternalID){
      string CPP=EMPTY_STRING;
        if(regionalrolloutid != null && rolloutFinancialmap.containsKey(regionalrolloutid)){
        for(IPM_Financial__c tempFin : rolloutFinancialmap.get(regionalrolloutid)){
          if(bdGlobal && tempFin.Financial_External_ID__c==localFinExternalID)
          { 
            CPP =calculateCPP(tempFin.Year_1_iTO_Global__c, companyCardTurnOver);
          }
          else if(!bdGlobal && tempFin.Financial_External_ID__c==localFinExternalID)
          {
            CPP =calculateCPP(tempFin.Year_1_iTO_Regional__c, companyCardTurnOver); 
          
          }                 
	  			
	  			 
	  			analyticObj.IPM_Company_Project_Priority_BD__c = CPP; 
	  		}
	  	} 
  		return analyticObj;  
   
  	}
    
    /*********************************************************************************************************************
     * @Description: To calculate CPP
     * @param1: Year1BDnumber either Global Turnover or Regional Turnover
     * @param1: companycardturnover  total opco tunover of the Local Company card
     * @return: string for CPP  
     *********************************************************************************************************************/
    
    
    public string calculateCPP(Decimal year1BDNumber, Decimal companyCardTurnOver){
    	if(companyCardTurnOver != null && year1BDNumber != null){
    		if((companyCardTurnOver/1000 >= 200))
    		{
    			if ((year1BDNumber/1000 >= 10) || ( (year1BDNumber/1000) >= ((companyCardTurnOver/1000) *0.005))){
	    		return GOLD;
    			}    		  
	    	   	else if(((year1BDNumber/1000) >= (companyCardTurnOver/1000)*0.001) && ((year1BDNumber/1000) < (companyCardTurnOver/1000)*0.005)){
	    		  return SILVER;
	    		}
	    		else if(((year1BDNumber/1000) < (companyCardTurnOver/1000)*0.001)){
	    		return BRONZE;
	    		}
    		}	    	
	    	else if(companyCardTurnOver/1000 <200){
	    		if((year1BDNumber/1000) >= (companyCardTurnOver/1000)*0.001)
	    		{
	    			return SILVER;
	    		}
	    		else if((year1BDNumber/1000) < (companyCardTurnOver/1000)*0.001){
	    			return BRONZE;
	    		}
	    	}
	    	else{
	    		return N_A;
	    	}
    	}
    	return EMPTY_STRING;
    }
        
    /*********************************************************************************************************************
     * @Description: To copy Milestone related details to that particular project
     * @param1: Map<Id, List<IPM_Milestone__c>> (Project And Its related Milestone records), IPM_Analytics__c IPM Analytics , IPM Project
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/
    public IPM_Analytics__c processMilestoneDetails(map<Id,list<IPM_Milestone__c>> projMilestoneMap, IPM_Analytics__c a, IPM_Project__c p){
        
        //Copying IPM Milestone fields 
        if(projMilestoneMap.containskey(p.id)){ 
            for(IPM_Milestone__c mile : projMilestoneMap.get(p.id)){ 
                if (String.isNotBlank(mile.IPM_Type_of_gate__c)){                       

                    if(mile.IPM_Type_of_gate__c.equalsignorecase(IPM_Utils.Charter)){
                        a.IPM_Expected_Charter_Approval_Date__c = mile.IPM_Due_Date__c;
                        a.IPM_Charter_Approved_Date__c = mile.IPM_Completed_on__c;  
                        a.IPM_Charter_Proposed_Date__c = mile.IPM_Proposed_Date__c;

                    }
                    else if(mile.IPM_Type_of_gate__c.equalsignorecase(IPM_Utils.Contract)){
                        a.IPM_Expected_Contract_Approval_Date__c = mile.IPM_Due_Date__c;
                        a.IPM_Contract_Approved_Date__c = mile.IPM_Completed_on__c;
                        a.IPM_Contract_Proposed_Date__c = mile.IPM_Proposed_Date__c;
                    }
                    else if(mile.IPM_Type_of_gate__c.equalsignorecase(IPM_Utils.MarketReady)){
                        a.IPM_Expected_Market_Ready_Approval_Date__c = mile.IPM_Due_Date__c;
                        a.IPM_Market_Ready_Approved_Date__c = mile.IPM_Completed_on__c;
                        a.IPM_Market_Ready_Proposed_Date__c = mile.IPM_Proposed_Date__c;
                    }
                    else if(mile.IPM_Type_of_gate__c.equalsignorecase(IPM_Utils.MarketDeployment)){
                        a.IPM_Expected_Market_Deployment_App_Date__c = mile.IPM_Due_Date__c;
                        a.IPM_Market_Deployment_Approved_Date__c = mile.IPM_Completed_on__c;
                        a.IPM_Market_Deployment_Proposed_Date__c = mile.IPM_Proposed_Date__c;
                    }
                }         
                          
                if(mile.IPM_Name__c.equalsignorecase(IPM_Utils.TargetLaunchDateShiptoTrade)){
                    if(mile.IPM_Actual_Target_Launch_Year__c != null){
                        a.IPM_Actual_Launch_Year__c = integer.valueOf(mile.IPM_Actual_Target_Launch_Year__c);
                    }
                    a.IPM_Actual_Launch_Month__c = mile.IPM_Actual_Target_Launch_Month__c;
                    a.IPM_Actual_Launch_Date__c = mile.IPM_Completed_on__c; 
                }
                if(mile.IPM_Name__c.equalsignorecase(IPM_ConstantUtils.BET_MS_FIRST_RELEASE)){
                    a.IPM_BET_First_Release_Due_Date__c = mile.IPM_Due_Date__c;
                    a.IPM_BET_First_Released_On_Date__c = mile.IPM_Completed_on__c;     
                }
                if(mile.IPM_Name__c.equalsignorecase(IPM_ConstantUtils.BET_MS_FINAL_RELEASE)){
                    a.IPM_BET_Final_Release_Due_date__c = mile.IPM_Due_Date__c;
                    a.IPM_BET_Final_Released_On_date__c = mile.IPM_Completed_on__c;  
                }
            }
        } //end of Milestone loop           
        
        return a;
    }
}
