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
    public static final String TURNOVER ='TO';
    public static final String GROSSPROFIT ='GO';
    public static String CLASS_NAME = IPM_BD_BB_Report_Batch.class.getName();
    public static string METHOD_NAME='execute';
    public IPM_Reporting__c reportcs = IPM_Reporting__c.getValues(BB_BD_REPORT_RUNDATE); 
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

    //Contructor - @@ Param - query string from schedular class  
    global IPM_BD_BB_Report_Batch(String querystr){
        query=querystr;
    }

    //Query locator
    global Database.QueryLocator start(Database.BatchableContext BC){  
        return Database.getQueryLocator(query);
    }

    //Execute method 
    global void execute(Database.BatchableContext BC,  list<IPM_Project__c> Scope){  

        for(IPM_Project__c p:Scope){
            projectIdSet.add(p.Id);

            if(p.IPM_Project_Type__c != IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                scopeProjectList.add(p);
                projectIdMap.put(p.Id,p);               
            } 
        }
        
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
        try{   
        list<IPM_Financial__c> projectFinancialList = new list<IPM_Financial__c>([SELECT id,
                                                                                  name,
                                                                                  Financial_External_ID__c,
                                                                                  Business_Impact_Global__c,
                                                                                  Business_Impact_Regional__c,
                                                                                  Business_Impact_Local__c, 
                                                                                  Parent_Project__r.Name,
                                                                                  Regional_Project__r.id, 
                                                                                  Local_Project__r.id,
                                                                                  Parent_Project__r.id, 
                                                                                  Regional_Project__r.Name, 
                                                                                  Local_Project__r.Name,
                                                                                  Misaligned__c,
                                                                                  IPM_Auto_Aligned_Fin_TLD__c,
                                                                                  IPM_Project_Rollout__r.id,
                                                                                  IPM_CPP_Regional__c                                                                                  
                                                                                  FROM IPM_Financial__c WHERE isActive__c=true AND (Parent_Project__r.Id IN: projectIdMap.keyset() or Regional_Project__r.id IN:projectIdMap.keyset() or Local_Project__r.id IN: projectIdMap.keyset())  Limit 50000]);
        
            for(IPM_Financial__c fi:projectFinancialList){
                if(fi.Local_Project__r.id !=null && fi.Local_Project__r.Name == fi.Financial_External_ID__c){
                    projFinMap.put(fi.Local_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Regional_Project__r.id!=null &&  fi.Financial_External_ID__c ==  fi.Regional_Project__r.Name + IPM_Utils.CONSOLIDATED){
                    projFinMap.put(fi.Regional_Project__r.id,fi);
                    financialIdSet.add(fi.id);
                }else if(fi.Parent_Project__r.id != null && fi.Financial_External_ID__c == fi.Parent_Project__r.Name + IPM_Utils.CONSOLIDATED ) {
                    projFinMap.put(fi.Parent_Project__r.id,fi);
                    financialIdSet.add(fi.id);
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
                                                                                              //WHERE IPM_Financial__r.Parent_Project__r.Id IN: projectIdMap.keyset() or IPM_Financial__r.Regional_Project__r.id IN: projectIdMap.keyset() or IPM_Financial__r.Local_Project__r.id IN: projectIdMap.keyset() Limit 50000]);
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
                                                                                                    IPM_Status__c,
                                                                                                    KeyMCO__c,
                                                                                                    IPM_Company_Card__r.Name,
                                                                                                    Target_Launch_Year__c,
                                                                                                    Regional_Rollout_Phase__c,
                                                                                                    Local_Rollout_Phase__c,
                                                                                                    IPM_Project_Job_Status__c,
                                                                                                    Target_LaunchMonth__c,
                                                                                                    Target_LaunchYear__c,
                                                                                                    Regional_Rollout__r.id,
                                                                                                    IPM_Global_OR_Regional__c,
                                                                                                    IPM_Parent_Project_Name__c,
                                                                                                    IPM_Regional_PL__r.Name,
                                                                                                    Regional_Project__r.IPM_Phase__c,
                                                                                                    IPM_Project__R.IPM_Phase__c,
                                                                                                    Regional_Project__r.IPM_SourceProjectType__c,
                                                                                                    Regional_Project__r.Id                                                                    
                                                                                                    FROM IPM_Project_Rollout__c 
                                                                                                    //WHERE IPM_Project__r.id IN:rolloutprojectIdSet Limit 50000]);
                                                                                                    WHERE isActive__c=true AND (IPM_Project__r.id IN:projectIdMap.keyset() or Regional_Project__r.Id IN:projectIdMap.keyset()) Limit 50000]);
            for(IPM_Project_Rollout__c pr:projRolloutList){
                  
                  if(pr.IPM_Project_Job_Status__c!=IPM_ConstantUtils.JOB_STATUS_COMPLETED){
                    if(pr.IPM_Project__r.id != null && !projRolloutMap.containskey(pr.IPM_Project__r.id)){
                        projRolloutMap.put(pr.IPM_Project__r.id, new List<IPM_Project_Rollout__c>{pr});                              
                    }else if(pr.IPM_Project__r.id != null && projRolloutMap.containskey(pr.IPM_Project__r.id)){                            
                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.IPM_Project__r.id);
                        rolloutList.add(pr);
                        projRolloutMap.put(pr.IPM_Project__r.id, rolloutList);                                          
                    }
                    else if(pr.IPM_Project__r.id == null && pr.Regional_Project__r.Id != null && !projRolloutMap.containskey(pr.Regional_Project__r.Id)){  
                       projRolloutMap.put(pr.Regional_Project__r.Id, new List<IPM_Project_Rollout__c>{pr});  
                    }else if(pr.IPM_Project__r.id == null && pr.Regional_Project__r.Id != null && projRolloutMap.containskey(pr.Regional_Project__r.Id)){                            
                        List<IPM_Project_Rollout__c> rolloutList = projRolloutMap.get(pr.Regional_Project__r.Id);
                        rolloutList.add(pr);
                        projRolloutMap.put(pr.Regional_Project__r.Id, rolloutList);              
                    }
                   
                    if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE)
                    {                       
                        regionalRolloutset.add(pr.Id); 
                    }
                    else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){ 
                
                      ID regionalRolloutID=pr.Regional_Rollout__r.id != null?pr.Regional_Rollout__r.id:pr.Regional_Project__r.Id;
                      regionalRolloutset.add(regionalRolloutID); 
                      localRolloutIDSet.add(pr.Id);                        
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
                                                                                            Financial_External_ID__c,
                                                                                            IPM_Project_Rollout__r.Id,
                                                                                            IPM_Project_Rollout__r.Name,
                                                                                            Regional_Project__c,
                                                                                            Regional_Project__r.id, 
                                                                                            IPM_CPP_Regional__c
                                                                                            FROM IPM_Financial__c 
                                                                                            WHERE isActive__c=true AND (IPM_Project_Rollout__c IN: regionalRolloutset OR Regional_Project__c IN: regionalRolloutset)  Limit 50000]);
                                                
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
                                                                       FROM IPM_Country__c WHERE isActive__c=true AND (IPM_Local_Project__r.Id IN : projectIdMap.keyset() or Local_Rollout__r.id IN: localRolloutIDSet) Limit 50000]);
            
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
            IPM_Analytics__c a = new IPM_Analytics__c();
            a.IPM_Project_Id__c = p.id;

            if(String.isNotBlank(p.Project_External_ID__c)){
                a.IPM_External_ID__c = p.Project_External_ID__c;
            }else {
                a.IPM_External_ID__c = p.id;
            }

            a.IPM_Project_Name__c = p.name;
            a.IPM_Project_Description__c = p.IPM_Project_Description__c;
            a.IPM_Parent_Project_Name__c = p.IPM_Parent_Project__r.Name;  
            a.IPM_Project_Leader__c = p.IPM_Project_Leader__r.Name;
            a.IPM_Deputy_Project_Leader__c = p.Deputy_Project_Leader__r.Name;
            a.IPM_Finance_Member__c = p.IPM_Finance_Member__r.Name;
            a.IPM_Technical_Project_Leader__c = p.IPM_Technical_Project_Leader__r.Name;  
            a.IPM_Project_Span__c = p.IPMProject_Span__c;
            a.IPM_Project_Type__c = p.IPM_Project_Type__c;
            a.IPM_Company__c = p.IPM_Company_Card__r.Name;
            a.IPM_Category_Group__c = p.IPM_Category_Group__c;
            a.IPM_Category__c = p.IPM_Category_Text__c;
            a.IPM_Brand_Positioning__c = p.IPM_Brand_Positioning__c;
            a.IPM_Market_Place_Activity__c = p.IPM_Answer_of_Q1__c;
            a.IPM_Consumer_Value_Perception__c = p.IPM_Answer_of_Q2__c;
            a.IPM_Enabling_Technology__c = p.IPM_Answer_of_Q3__c;
            a.IPM_Strategic_Intent__c = p.IPM_Strategic_Intent__c;
            a.IPM_Project_Start_Date__c = p.IPM_Project_Start_Date__c !=null?p.IPM_Project_Start_Date__c:p.CreatedDate.date();
            a.IPM_Cluster_Project__c = p.IPM_Clusters__c;
            a.IPM_Phase__c = p.IPM_Phase__c;
            //a.IPM_Company_Priority__c = p.IPM_CPP__c; 
            a.IPM_Fast_Track_Project__c = p.IPM_Fast_Track_Project__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;             
            a.IPM_Exempt_from_Threshold__c = p.Exempt_from_Threshold__c; 
            a.IPM_Auto_Aligned_Fin_TLD__c = p.IPM_Misalligned__c; // Auto_Aligned will only be checked for local projects
            a.IPM_Stopped__c= p.Is_Archieved__c?IPM_ConstantUtils.OTIF_YES:'';
            
            if(String.isNotBlank(p.IPMProject_Span__c) && !p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) && String.isNotBlank(p.IPM_Project_Type__c) && (!p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)) &&  String.isNotBlank(p.IPM_Phase__c) && p.IPM_Phase__c.equalsignorecase(IPM_ConstantUtils.PHASE_IDEAS)){
                a.IPM_Key_NonKey__c = p.IPM_Project_Rollout__r.KeyMCO__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;
            }

            if(String.isNotBlank(p.IPMProject_Span__c) && (p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) || p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional))){
                a.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
            }else if(String.isNotBlank(p.IPMProject_Span__c) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
                a.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
                a.IPM_Market_Cluster__c = p.Market_Cluster_Name__c;                 
            }

            if(String.isNotBlank(p.IPM_Project_Type__c) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original)){
                a.IPM_Geography__c = IPM_Utils.valueGlobal;             
            }else if(String.isNotBlank(p.IPM_Project_Type__c) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
                a.IPM_Geography__c = p.Market_Cluster_Name__c;
            }else if(String.isNotBlank(p.IPM_Project_Type__c) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
                if(ipmCountryMap.containskey(p.id)){ a.IPM_Geography__c = ipmCountryMap.get(p.id);}
            }

            if(String.isNotBlank(p.IPM_Category_Text__c) && String.isNotBlank(p.IPMPlatform__c) && p.IPMPlatform__c != IPM_ConstantUtils.OPTION_NONE && p.IPM_Category_Text__c != IPM_ConstantUtils.HHC_CONSTANT && p.IPM_Category_Text__c != System.Label.IPM_Laundry){
                a.IPM_Platform__c = p.IPMPlatform__c;
            }
            // populate target launch year & month
            if(String.isNotBlank(p.IPM_Project_Type__c) && (p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) || p.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) ||(String.isNotBlank(p.IPMProject_Span__c) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)))){
                a.IPM_Target_Launch_Month_BD__c = p.IPM_Target_Launch_Month__c;
                if(p.IPM_Target_Launch_Year__c != null){
                    a.IPM_Target_Launch_Year_BD__c = integer.valueOf(p.IPM_Target_Launch_Year__c);
                }
            }
            if (String.isNotBlank(p.IPMProject_Span__c) && String.isNotBlank(p.IPM_Project_Type__c) && p.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && p.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)){
                a.IPM_Target_Launch_Month_BB__c = p.IPM_Target_Launch_Month__c;
                if(p.IPM_Target_Launch_Year__c != null){
                    a.IPM_Target_Launch_Year_BB__c = integer.valueOf(p.IPM_Target_Launch_Year__c);
                }
                //if(String.isNotBlank(string.valueof(p.IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c))){
                if(String.isNotBlank(string.valueof(p.IPM_Project_Rollout__r.Target_Launch_Date__c))){
                    a.IPM_Target_Launch_Month_BD__c = monthNameIntegerToString.get(p.IPM_Project_Rollout__r.Target_Launch_Date__c.month());
                    a.IPM_Target_Launch_Year_BD__c = p.IPM_Project_Rollout__r.Target_Launch_Date__c.Year();   
                }                  
            }

            //Global Project Business Impact Global will be copy to Global,Regional & Local project
            if(projFinmap.containskey(p.Id)){ 
                a.IPM_Business_Impact_BD__c = projFinMap.get(p.id).Business_Impact_Global__c; 
                a.IPM_Auto_Aligned_Fin_TLD_for_financial__c = projFinMap.get(p.id).Misaligned__c;
                a.IPM_Company_Priority__c = projFinMap.get(p.id).IPM_CPP_Regional__c;
            }  
            
            // Copying Milestone related fields 
            a = processMilestoneDetails(projMilestoneMap, a, p);
            // //Copying IPM Financial Year fields
            a = processFinancialDetails(projFinYrmap,  a, p);
            
            analyticreclist.add(a);  
            if(projRolloutMap.containskey(a.IPM_Project_Id__c)){
              List<IPM_Analytics__c> rollAnalyticlist = new List<IPM_Analytics__c> (addrolloutproject(a));
                if(!rollAnalyticlist.isEmpty()){
                  analyticreclist.addall(rollAnalyticlist);                
                }               
            }  

        } //End of IPM Project For loop

        if(!analyticreclist.isEmpty()){ 
            try{
                upsert analyticreclist;

                //Update the Last Run date time
                //reportcs.Last_Batch_RunDate__c = system.now();
                //update reportcs;
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


    /**************************************************************************************************
     * @Description: To get the Turnover/Grossprofit values
     * @param1: IPM_Financial_Year__c
     * @param1: String Project Span  
     * @param1: String  returnType (Values: TurnOver/GrossProfit)
     * @return: Double (turn over / gross profit value) 
     ***************************************************************************************************/

    public double getTurnOver(IPM_Financial_Year__c fr, boolean globalORregionalvalue, string returnType ){   

        double returnValue=0;
        
        if(globalORregionalvalue){
            returnValue=returnType.equalsignorecase(TURNOVER)?fr.Turnover_Global__c:fr.Gross_Profit_Global__c;
        }else{
            returnValue=returnType.equalsignorecase(TURNOVER)?fr.Turnover_Regional__c:fr.Gross_Profit_Regional__c;
        }
        return returnValue; 
    }  
    
    
    /*********************************************************************************************************************
     * @Description: To get records for each rollout project for the parent project which is in Ideas phase
     * @param1: IPM_Analytics__c (Parent prject Analytic record to be inserted)
     * @return: List<IPM_Analytics__c> records for each rollout project to be inserted in Analytic object for reporting  
     *********************************************************************************************************************/

    public List<IPM_Analytics__c> addrolloutproject (IPM_Analytics__c parentanalyticrec){         
       
        IPM_Analytics__c parent = parentanalyticrec;
        list<IPM_Analytics__c> returnList = new list<IPM_Analytics__c>();
        id regionalrolloutid;             
         
             for(IPM_Project_Rollout__c pr:projRolloutMap.get(parent.IPM_Project_Id__c)){
                    
                    IPM_Analytics__c analyticObj = new IPM_Analytics__c();
                    
                    // project Rollout related details to be copied  
                    analyticObj = setRolloutProjectdetails(analyticObj, pr, parent);
                    
                    if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE){
                  		regionalrolloutid = pr.Id;                                     
              		}else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){
              			
                 		 regionalrolloutid=pr.Regional_Project__c != null?pr.Regional_Project__r.id:pr.Regional_Rollout__r.id; 
                 	} 
              
                    string finExtId = '';
                    if(regionalrolloutid != null && rolloutFinancialmap.containskey(regionalrolloutid)){ 
                        for(IPM_Financial__c fir:rolloutFinancialmap.get(regionalrolloutid)){
                            if((pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE && fir.Financial_External_ID__c == pr.name + IPM_Utils.CONSOLIDATED) || (pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE && fir.Financial_External_ID__c == pr.name)){
                               
                                finExtId = fir.Financial_External_ID__c;                                                           
                            }                       
                        }
                    }                                           
                    // Financial related details to be copied
                    analyticObj = setRolloutFinancialdetails(analyticObj, finExtId, pr); 
                    analyticObj = setRolloutFinancialYeardetails(analyticObj, finExtId, pr); 
                    
                    returnList.add(analyticObj);              
                }
            return returnList;    
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
                                                 
        }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE ){
            analyticObj.IPM_Project_Span__c = IPM_Utils.Local;
            analyticObj.IPM_Geography__c = ipmCountryMap.containskey(pr.id)?ipmCountryMap.get(pr.id):'';
            analyticObj.IPM_Market_Cluster__c = pr.Market_Cluster_Name__c;
            analyticObj.IPM_Phase__c = pr.Regional_Project__c==null?pr.IPM_Project__r.IPM_Phase__c:pr.Regional_Project__r.IPM_Phase__c;
            analyticObj.IPM_Key_NonKey__c = pr.KeyMCO__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;
            analyticObj.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
            
        } 
        
      return analyticObj;
    }
    
    /*********************************************************************************************************************
     * @Description: To copy rollout related financial year details
     * @param1: IPM_Analytics__c, String, IPM_Project_Rollout__c
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics__c setRolloutFinancialYeardetails(IPM_Analytics__c analyticObj, String finExtId, IPM_Project_Rollout__c pr){
        if(String.isNotBlank(finExtId) && rolloutFinancialYearmap.containskey(finExtId)){
        Boolean globalORregionalValues = pr.IPM_Global_OR_Regional__c; 
            for(IPM_Financial_Year__c fr : rolloutFinancialYearmap.get(finExtId)){
                // Populating 1st Full Year Gross TO (BD)
                if(String.isNotBlank(fr.Year_Type__c) && String.isNotBlank(fr.PL_Type__c) && fr.Name.equalsignorecase(IPM_Utils.Y1) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
                    analyticObj.IPM_1st_Full_Year_Gross_TO_BD__c = globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;
                }
                // Populating 1st Full Year iTO (BD) & 1st Full Year iGP (BD)
                if(fr.Name.equalsignorecase(IPM_Utils.Y1) && (String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation)) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
                        analyticObj.IPM_1st_Full_Year_iTO_BD__c = globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;
                        analyticObj.IPM_1st_Full_Year_iGP_BD__c = globalORregionalValues?fr.Gross_Profit_Global__c:fr.Gross_Profit_Regional__c;                      
                }

                // Populating Gross TO (BD) - Y0 - Y8
                if(String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross) && String.isNotBlank(pr.Target_LaunchYear__c) && fr.Name >= pr.Target_LaunchYear__c){
 
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_3__c.intValue())){ analyticObj.IPM_Gross_TO_Y0_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);} 
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_2__c.intValue())){ analyticObj.IPM_Gross_TO_Y1_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_1__c.intValue())){ analyticObj.IPM_Gross_TO_Y2_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year())){ analyticObj.IPM_Gross_TO_Y3_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y1__c.intValue())){ analyticObj.IPM_Gross_TO_Y4_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y2__c.intValue())){ analyticObj.IPM_Gross_TO_Y5_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y3__c.intValue())){ analyticObj.IPM_Gross_TO_Y6_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y4__c.intValue())){ analyticObj.IPM_Gross_TO_Y7_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y5__c.intValue())){ analyticObj.IPM_Gross_TO_Y8_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}                                           
                } 
        
                if(String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental) && String.isNotBlank(pr.Target_LaunchYear__c) && fr.Name >= pr.Target_LaunchYear__c){

                    // Populating iTO (BD) - Y0 - Y8  
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_3__c.intValue())){ analyticObj.IPM_iTO_Y0_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y_2__c.intValue())){ analyticObj.IPM_iTO_Y1_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y_1__c.intValue())){ analyticObj.IPM_iTO_Y2_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year())){ analyticObj.IPM_iTO_Y3_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y1__c.intValue())){ analyticObj.IPM_iTO_Y4_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y2__c.intValue())){ analyticObj.IPM_iTO_Y5_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y3__c.intValue())){ analyticObj.IPM_iTO_Y6_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y4__c.intValue())){ analyticObj.IPM_iTO_Y7_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y5__c.intValue())){ analyticObj.IPM_iTO_Y8_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}


                    // Populating iGP (BD) - Y0 - Y8
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_3__c.intValue())){ analyticObj.IPM_iGP_Y0_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_2__c.intValue())){ analyticObj.IPM_iGP_Y1_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_1__c.intValue())){ analyticObj.IPM_iGP_Y2_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year())){ analyticObj.IPM_iGP_Y3_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y1__c.intValue())){ analyticObj.IPM_iGP_Y4_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y2__c.intValue())){ analyticObj.IPM_iGP_Y5_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y3__c.intValue())){ analyticObj.IPM_iGP_Y6_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y4__c.intValue())){ analyticObj.IPM_iGP_Y7_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y5__c.intValue())){ analyticObj.IPM_iGP_Y8_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}

                    }  
        
                    // Populating Y3 gTO
                    if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                    { 
                        analyticObj.IPM_Y3_gTO_BD__c = globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;
                    }                   
                    // Populating Y3 iTO                   
                    if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
                    {                       
                        analyticObj.IPM_Y3_iTO_BD__c = globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;                       
                    }
        
                }
          }   
        return analyticObj;       
  }
  
  /*********************************************************************************************************************
     * @Description: To copy rollout related financial details
     * @param1: IPM_Analytics__c, String, IPM_Project_Rollout__c
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics__c setRolloutFinancialdetails(IPM_Analytics__c analyticObj, String finExtId, IPM_Project_Rollout__c pr){
  	  	if(pr.Id != null && rolloutFinancialmap.containsKey(pr.Id)){
	  		for(IPM_Financial__c tempFin : rolloutFinancialmap.get(pr.Id)){
	  			system.debug('FinancialsList'+ tempFin +'>>>CPP'+tempFin.IPM_CPP_Regional__c);
	  			//if(finExtId == tempFin.Financial_External_ID__c){
	  				analyticObj.IPM_Company_Priority__c = tempFin.IPM_CPP_Regional__c; 
	  			//}
	  		}
	  	} 
  		return analyticObj; 
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
    
     /*********************************************************************************************************************
     * @Description: To copy financial years related details to that particular project
     * @param1: Map<Id, List<IPM_Financial_Year__c>> (Project And Its related Financial years), IPM_Analytics__c IPM Analytics , IPM Project
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/
    public IPM_Analytics__c processFinancialDetails(Map<Id, List<IPM_Financial_Year__c>> projFinYrmap, IPM_Analytics__c a, IPM_Project__c p){
        
        //Copying IPM Financial Year fields
        if(projFinYrmap.containskey(p.id) && String.isNotBlank(p.IPMProject_Span__c)){
        
            for(IPM_Financial_Year__c fr:projFinYrMap.get(p.id)){
                
                Boolean globalORregionalValues=p.IPM_Global_OR_Regional__c;
               /* if(p.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) && String.isNotBlank(p.IPM_Phase__c) && p.IPM_Phase__c.equalsignorecase(IPM_ConstantUtils.PHASE_IDEAS)){
                    globalORregionalValues = true;
                }*/
                
                // Populating 1st Full Year Gross TO (BD)
                if(String.isNotBlank(fr.Year_Type__c) && String.isNotBlank(fr.PL_Type__c) && fr.Name.equalsignorecase(IPM_Utils.Y1) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
        
                    a.IPM_1st_Full_Year_Gross_TO_BD__c= globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;                        
                }
                // Populating 1st Full Year iTO (BD) & 1st Full Year iGP (BD)
                if(fr.Name.equalsignorecase(IPM_Utils.Y1) && (String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation)) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
                    a.IPM_1st_Full_Year_iTO_BD__c=globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;
                    a.IPM_1st_Full_Year_iGP_BD__c=globalORregionalValues?fr.Gross_Profit_Global__c:fr.Gross_Profit_Regional__c;
                }
        
                // Populating Gross TO (BD) - Y0 - Y8
                if(String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross) && String.isNotBlank(p.IPM_Target_Launch_Year__c) && fr.Name >= p.IPM_Target_Launch_Year__c){
        
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_3__c.intValue())){ a.IPM_Gross_TO_Y0_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_2__c.intValue())){ a.IPM_Gross_TO_Y1_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_1__c.intValue())){ a.IPM_Gross_TO_Y2_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year())){ a.IPM_Gross_TO_Y3_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y1__c.intValue())){ a.IPM_Gross_TO_Y4_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y2__c.intValue())){ a.IPM_Gross_TO_Y5_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y3__c.intValue())){ a.IPM_Gross_TO_Y6_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y4__c.intValue())){ a.IPM_Gross_TO_Y7_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y5__c.intValue())){ a.IPM_Gross_TO_Y8_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
        
                }
        
                if(String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental) && String.isNotBlank(p.IPM_Target_Launch_Year__c) && fr.Name >= p.IPM_Target_Launch_Year__c){
        
                    // Populating iTO (BD) - Y0 - Y8  
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_3__c.intValue())){ a.IPM_iTO_Y0_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y_2__c.intValue())){ a.IPM_iTO_Y1_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y_1__c.intValue())){ a.IPM_iTO_Y2_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year())){ a.IPM_iTO_Y3_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y1__c.intValue())){ a.IPM_iTO_Y4_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y2__c.intValue())){ a.IPM_iTO_Y5_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y3__c.intValue())){ a.IPM_iTO_Y6_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y4__c.intValue())){a.IPM_iTO_Y7_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
                    else if(fr.Name == string.valueof(system.today().year() + reportcs.Y5__c.intValue())){ a.IPM_iTO_Y8_BD__c = getTurnOver(fr,globalORregionalValues,TURNOVER);}
        
        
                    // Populating iGP (BD) - Y0 - Y8
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_3__c.intValue())){ a.IPM_iGP_Y0_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_2__c.intValue())){ a.IPM_iGP_Y1_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y_1__c.intValue())){ a.IPM_iGP_Y2_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year())){ a.IPM_iGP_Y3_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y1__c.intValue())){ a.IPM_iGP_Y4_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y2__c.intValue())){ a.IPM_iGP_Y5_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y3__c.intValue())) {a.IPM_iGP_Y6_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y4__c.intValue())){ a.IPM_iGP_Y7_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
                    if(fr.Name == string.valueof(system.today().year() + reportcs.Y5__c.intValue())){ a.IPM_iGP_Y8_BD__c = getTurnOver(fr,globalORregionalValues,GROSSPROFIT);}
        
                }  
        
                // Populating Y3 gTO
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                {  
                   a.IPM_Y3_gTO_BD__c = globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;
                }                   
                // Populating Y3 iTO                   
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
                {                       
                    a.IPM_Y3_iTO_BD__c = globalORregionalValues?fr.Turnover_Global__c:fr.Turnover_Regional__c;
                }
        
            }//end of Financial Year For loop
        
        }
        return a;
    }   
}
