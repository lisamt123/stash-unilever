/***********************************************************************************************************
    @Description : This class is used to execute the IPM_OTIF_Report_Batch job to copy project details to
                   analytics OTIF object for the OTIF report.
    @Created Date: 15/03/2015
    @Author: Cognizant
    @Referenced: IPM_OTIF_Batch
    This class has been declared as Gloabl as it implements Databse.Batchable interface.
    This class is declared as 'without sharing' - As report needs to run without sharing as it needs to look at all records regardless of what the running user has access to
 ************************************************************************************************************/

global without sharing class IPM_OTIF_Report_Batch implements Database.Batchable<sObject> { 

    global final String query;  
    global map<id,IPM_Project__c> projectIdMap = new map<id,IPM_Project__c>(); 
    global list<IPM_Project__c> scopeProjectList = new list<IPM_Project__c>();   
    global set<id> projectIdSet = new set<id>();
    global set<id> rolloutprojectIdSet = new set<id>();
    global map<Id,list<IPM_Project_Rollout__c>> projRolloutMap;
    global map<Id,list<IPM_Project_Document__c>> projGateDocumentMap;
    global map<Id,list<IPM_Project_Document_Section_Content__c>> projDocSecContentMap;
    global map<string,list<IPM_Financial_Year__c>> rolloutFinancialYearmap;  
    global map<id,list<IPM_Financial__c>> rolloutFinancialmap;
    global list<IPM_Analytics_OTIF__c> analyticRecOTIFList;
    global set<id> localRolloutIDSet = new set<id>();
    global set<id> regionalRolloutset = new set<id> ();
    global set<id> rolloutFinIdSet = new set<id>();
    global Map<Id, String> ipmCountryMap = new map<Id, String>();
    global set<id> financialIdSet = new set<id>();
    global Map<Id, IPM_Financial__c> projFinMap = new Map<Id, IPM_Financial__c> ();
    public static final String TURNOVER ='TO';
    public static final String GROSSPROFIT ='GO';
    public static String CLASS_NAME = IPM_OTIF_Report_Batch.class.getName();
    public static string METHOD_NAME='execute';
    public static final Id REGIONAL_ROLLOUT_RECTYPE = Schema.SObjectType.IPM_Project_Rollout__c.RecordTypeInfosByName.get('Regional Rollout').RecordTypeId;
    public static final Id LOCAL_ROLLOUT_RECORDTYPE = Schema.SObjectType.IPM_Project_Rollout__c.getRecordTypeInfosByName().get('Local Rollouts').getRecordTypeId();
    public static final Id CONSOLIDATED_RECTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get('Consolidated').getRecordTypeId();
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
    global IPM_OTIF_Report_Batch(String querystr){
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
        
        //Map creation logic 

        //Fetching Consolidated Financial  records
        projFinMap = fetchConsolidatedFinancialRecords(projectIdMap);

        //Fetching Financial year records
        Map<Id, List<IPM_Financial_Year__c>> projFinYrMap = fetchFinancialYearRecords(financialIdSet);

        //Fetching gateDocument records and creating map 
        projGateDocumentMap = fetchGateDocumentRecords(projectIdMap);   
        
        //Fetching milestone records and creating map 
        map<Id,list<IPM_Milestone__c>> projMilestoneMap = fetchMilestoneRecords(projectIdMap);
        
        //Fetching rollout records for project and creating map
        projRolloutMap = fetchRolloutRecords(projectIdMap);

        //Fetching IPM Project Document Section Content records for project and creating map
        projDocSecContentMap = fetchProjectDocumentSectionContent(projectIdMap);
        
        //To fetch the financials for the rollout project when it is in Ideas phase
        rolloutFinancialmap = fetchRolloutFinancial(regionalRolloutset);
        //To fetch the financial year for the rollout project when it is in Ideas phase
        rolloutFinancialYearmap = fetchRolloutFinancialYear(rolloutFinIdSet);

        //Fetching country records and creating map
        ipmCountryMap = fetchCountryRecords(projectIdMap);
        
        //End of Map creation logic ***     

        //Start - Analytics Object Record Insertion 
        analyticRecOTIFList = new list<IPM_Analytics_OTIF__c>();
        

        for(IPM_Project__c p:scopeProjectList){ 

            //Copyin IPM Project field values
            IPM_Analytics_OTIF__c otifAnalytic = copyProjectFieldValues(p);
            
            
            // Copying Milestone related fields 
            otifAnalytic = processMilestoneDetails(projMilestoneMap, otifAnalytic, p);
            //Copying IPM Financial Year fields
            otifAnalytic = processFinancialDetails(projFinYrmap,  otifAnalytic, p);
            //Copying ProjectDocumentSectionContentDetails
            otifAnalytic = processProjectDocumentSectionContentDetails(projDocSecContentMap,  otifAnalytic, p);
            
            analyticRecOTIFList.add(otifAnalytic);  
            
            if(projRolloutMap.containskey(otifAnalytic.IPM_Project_Id__c)){
              List<IPM_Analytics_OTIF__c> rollAnalyticlist = new List<IPM_Analytics_OTIF__c> (addrolloutproject(otifAnalytic));
                if(!rollAnalyticlist.isEmpty()){
                  analyticRecOTIFList.addall(rollAnalyticlist);                
                }               
            }  

        } //End of IPM Project For loop

        if(!analyticRecOTIFList.isEmpty()){ 
            try{
                upsert analyticRecOTIFList;
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
    /*********************************************************************************************************************
     * @Description: To get records for each rollout project for the parent project which is in Ideas phase
     * @param1: IPM_Analytics_OTIF__c (Parent prject Analytic record to be inserted)
     * @return: List<IPM_Analytics_OTIF__c> records for each rollout project to be inserted in Analytic object for reporting  
     *********************************************************************************************************************/
    public List<IPM_Analytics_OTIF__c> addrolloutproject (IPM_Analytics_OTIF__c parentanalyticrec){         
       
        IPM_Analytics_OTIF__c parent = parentanalyticrec;
        list<IPM_Analytics_OTIF__c> returnList = new list<IPM_Analytics_OTIF__c>();
        id regionalrolloutid;             
         
         for(IPM_Project_Rollout__c pr:projRolloutMap.get(parent.IPM_Project_Id__c)){
                
                IPM_Analytics_OTIF__c otifAnalytic = new IPM_Analytics_OTIF__c();
                //copy Values from rollout record
                otifAnalytic.IPM_Project_Name__c = pr.name;
                otifAnalytic.IPM_Company__c = pr.IPM_Company_Card__r.Name; // as per the update it will be populated by Unilever report tool
                otifAnalytic.IPM_Target_Launch_Month_BD__c = pr.Target_LaunchMonth__c;
                otifAnalytic.IPM_Target_Launch_Year_BD__c = pr.Target_LaunchYear__c ;
                otifAnalytic.IPM_Parent_Project_Name__c = pr.IPM_Parent_Project_Name__c; 
                otifAnalytic.IPM_Project_Leader__c = pr.IPM_Regional_PL__r.Name;
                //Copy values From Parent project
                otifAnalytic.IPM_Project_Id__c = parent.IPM_Project_Id__c;                    
                otifAnalytic.IPM_Project_Description__c = parent.IPM_Project_Description__c;
                otifAnalytic.IPM_Project_Type__c = IPM_Utils.Rollout;
                otifAnalytic.IPM_Category_Group__c = parent.IPM_Category_Group__c;
                otifAnalytic.IPM_Category__c = parent.IPM_Category__c;
                otifAnalytic.IPM_Brand_Positioning__c = parent.IPM_Brand_Positioning__c;
                otifAnalytic.IPM_Market_Place_Activity__c = parent.IPM_Market_Place_Activity__c;
                otifAnalytic.IPM_Consumer_Value_Perception__c = parent.IPM_Consumer_Value_Perception__c;
                otifAnalytic.IPM_Enabling_Technology__c = parent.IPM_Enabling_Technology__c;
                otifAnalytic.IPM_Strategic_Intent__c = parent.IPM_Strategic_Intent__c;
                
                if(pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE){
                    otifAnalytic.IPM_Project_Span__c =IPM_Utils.Regional;
                    otifAnalytic.IPM_Geography__c = pr.Market_Cluster_Name__c;
                    otifAnalytic.IPM_Phase__c = pr.Regional_Rollout_Phase__c;
                    otifAnalytic.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
                    regionalrolloutid = pr.Id;                                     
                }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE ){
                    otifAnalytic.IPM_Project_Span__c = IPM_Utils.Local;
                    otifAnalytic.IPM_Geography__c=ipmCountryMap.containskey(pr.id)?ipmCountryMap.get(pr.id):'';
                    otifAnalytic.IPM_Market_Cluster__c = pr.Market_Cluster_Name__c;
                    otifAnalytic.IPM_Phase__c = pr.Local_Rollout_Phase__c;
                   // otifAnalytic.IPM_Key_NonKey__c = pr.KeyMCO__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;
                    otifAnalytic.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
                    regionalrolloutid=pr.Regional_Project__c != null?pr.Regional_Rollout__r.id:null;
                }   
                
                Boolean globalORregionalValues=pr.IPM_Global_OR_Regional__c;
                
                string finExtId = '';
                if(regionalrolloutid != null && rolloutFinancialmap.containskey(regionalrolloutid)){ 
                    for(IPM_Financial__c fir:rolloutFinancialmap.get(regionalrolloutid)){
                        if((pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE && fir.Financial_External_ID__c == pr.name+IPM_Utils.CONSOLIDATED) || (pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE && fir.Financial_External_ID__c == pr.name)){
                            finExtId = fir.Financial_External_ID__c;                                                           
                        }                       
                    }
                }                                           
                
                otifAnalytic = setRolloutFinancialdetails(otifAnalytic,finExtId,pr); 

                returnList.add(otifAnalytic);              

            }
            
        return returnList;    
    }  
    
     /*********************************************************************************************************************
     * @Description: To copy Project Document Section Content related details
     * @param1: Map<Id, List<IPM_Project_Document_Section_Content__c>> (Project And Its related Project Document Section), IPM_Analytics_OTIF__c IPM Analytics OTIF, IPM Project
     * @return: IPM_Analytics_OTIF__c Analytic OTIF object record  
     *********************************************************************************************************************/
    public IPM_Analytics_OTIF__c processProjectDocumentSectionContentDetails(Map<Id, List<IPM_Project_Document_Section_Content__c>> projDocSecContmap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        //Copying IPM Project Document Section Content fields
        if(projDocSecContmap.containskey(p.id)){
            for(IPM_Project_Document_Section_Content__c fr:projDocSecContmap.get(p.id)){
                // Populating Y3 gTO
                if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.Charter && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)
                {
                   otifAnalytic.IPM_OTIF_Comment_Charter__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
                    if(fr.IPM_OTIF_Measure__c == IPM_ConstantUtils.OTIF_CONCEPT_TEST){
                       otifAnalytic.IPM_Concept_Test__c = fr.IPM_OTIF_Status__c;
                    } else if(fr.IPM_OTIF_Measure__c == IPM_ConstantUtils.OTIF_SCOPING_COMPLETE){
                       otifAnalytic.IPM_Scoping_Complete__c = fr.IPM_OTIF_Status__c;
                    }
                }
                
                otifAnalytic = setContractGateDcoumentDetails(fr,otifAnalytic);
                otifAnalytic = setMarketReadyGateDcoumentDetails(fr,otifAnalytic);                

                if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.MarketDeployment && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)
                {
                   otifAnalytic.IPM_OTIF_Comment_MD__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
                    if(fr.IPM_OTIF_Measure__c == IPM_ConstantUtils.OTIF_FIRST_PROD_CONF_SPEC_FINALISED){
                       otifAnalytic.Ist_Production_Conf_Specs_Finalised__c = fr.IPM_OTIF_Status__c;
                    }   
                }               
                
            }
        }
        return otifAnalytic;
    }   
     /*********************************************************************************************************************
     * @Description: To copy financial years related details to that particular project
     * @param1: Map<Id, List<IPM_Financial_Year__c>> (Project And Its related Financial years), IPM_Analytics__c IPM Analytics , IPM Project
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/
    public IPM_Analytics_OTIF__c processFinancialDetails(Map<Id, List<IPM_Financial_Year__c>> projFinYrmap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        //Copying IPM Financial Year fields
        if(projFinYrmap.containskey(p.id) && String.isNotBlank(p.IPMProject_Span__c)){
            for(IPM_Financial_Year__c fr:projFinYrMap.get(p.id)){
                // Populating Y3 gTO
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                {  
                  otifAnalytic.IPM_Charter_Y3_gTO__c = fr.Turnover_Charter__c;
                  otifAnalytic.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
                  otifAnalytic.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;
                  otifAnalytic.IPM_MR_Y3_gTO__c = fr.Turnover_MR__c;
                  otifAnalytic.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
                  otifAnalytic.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
                  otifAnalytic.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
                  otifAnalytic.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;                  
                }                   
                // Populating Y3 iTO                   
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
                {                       
                  otifAnalytic.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
                  otifAnalytic.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
                  otifAnalytic.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;
                  otifAnalytic.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
                }
                
                // Populating Y3 gTO BD
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                {  
                  /* if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL|| p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
                   
                        otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Global__c;
                        otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Global__c;
                   } else */
                   if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                        otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Local__c;
                        otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Local__c;
                   } else {
                        otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Regional__c;
                        otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Regional__c;
                   }
                   
                }                   
                // Populating Y3 iTO BD                   
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
                {                       
                   if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL|| p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
                   
                        otifAnalytic.IPM_Y3_iTO_BD__c = fr.Turnover_Global__c;
                   } else if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                        otifAnalytic.IPM_Y3_iTO_BD__c = fr.Turnover_Local__c;
                   } else {
                        otifAnalytic.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
                   }
                    
                }
                    // Populating Y3 gTO BB
                    if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross) && p.IPMProject_Span__c == IPM_ConstantUtils.Local)
                    {  
                       if(p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
                            otifAnalytic.IPM_Y3_gTO_BB__c = fr.Turnover_Local__c;
                            otifAnalytic.Y3_GM_BB__c =  fr.GM_of_TO_Local__c;
                       } 
                    }                   
                    // Populating Y3 iTO BB                
                    if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental) && p.IPMProject_Span__c == IPM_ConstantUtils.Local)
                    {                       
                       if(p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
                            otifAnalytic.IPM_Y3_iTO_BB__c = fr.Turnover_Local__c;
                       } 
                    }
        
            }//end of Financial Year For loop
        
        }
        return otifAnalytic;
    }       
    /*********************************************************************************************************************
     * @Description: To copy Milestone related details to that particular project
     * @param1: Map<Id, List<IPM_Milestone__c>> (Project And Its related Milestone records), IPM_Analytics__c IPM Analytics , IPM Project
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/
    
    public IPM_Analytics_OTIF__c processMilestoneDetails(map<Id,list<IPM_Milestone__c>> projMilestoneMap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        //Copying IPM Milestone fields 
        if(projMilestoneMap.containskey(p.id)){ 
            for(IPM_Milestone__c mile : projMilestoneMap.get(p.id)){ 
                if(mile.IPM_Name__c.equalsignorecase(IPM_Utils.TargetLaunchDateShiptoTrade)){
                   otifAnalytic.IPM_Actual_Launch_Year__c = mile.IPM_Actual_Target_Launch_Year__c;
                    if(mile.IPM_Actual_Target_Launch_Month__c != 'None' && mile.IPM_Actual_Target_Launch_Month__c != '' ){
                       otifAnalytic.IPM_Actual_Launch_Month__c = mile.IPM_Actual_Target_Launch_Month__c;
                    }
                    //a.IPM_Actual_Launch_Date__c = mile.IPM_Completed_on__c; 
                    if(mile.IPM_Due_Date_Idea__c != null ){
                        if(projGateDocumentMap.containskey(p.id)){  
                            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.CHARTER_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){
                                    otifAnalytic.IPM_Charter_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Idea__c.month());
                                    otifAnalytic.IPM_Charter_Target_Launch_Year__c = string.valueof(mile.IPM_Due_Date_Idea__c.Year());                       
                                }   
                            }   
                        }
                    }
                    if(mile.IPM_Due_Date_Feasibility__c != null ){
                        if(projGateDocumentMap.containskey(p.id)){  
                            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.CONTRACT_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){                 
                                   otifAnalytic.IPM_Contract_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Feasibility__c.month());
                                   otifAnalytic.IPM_Contract_Target_Launch_Year__c = string.valueof(mile.IPM_Due_Date_Feasibility__c.Year());
                                }   
                            }   
                        }                                  
                    }
                    if(mile.IPM_Due_Date_Capability__c != null ){
                        if(projGateDocumentMap.containskey(p.id)){  
                            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.MARKET_READY_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){                 
                                    otifAnalytic.IPM_MR_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Capability__c.month());
                                    otifAnalytic.IPM_MR_Target_Launch_Year__c  = string.valueof(mile.IPM_Due_Date_Capability__c.Year());  
                                }   
                            }   
                        }                                   
                    }
                    if(mile.IPM_Due_Date_Market_Ready__c != null ){
                        if(projGateDocumentMap.containskey(p.id)){  
                            for(IPM_Project_Document__c pGateDoc : projGateDocumentMap.get(p.id)){ 
                                if(pGateDoc.IPM_GateDocuments__c.equalsignorecase(IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE) && pGateDoc.IPM_Document_Status__c.contains(IPM_ConstantUtils.STATUS_APPROVED)){                    
                                    otifAnalytic.IPM_MD_Target_Launch_Month__c = monthNameIntegerToString.get(mile.IPM_Due_Date_Market_Ready__c.month());
                                    otifAnalytic.IPM_MD_Target_Launch_Year__c = string.valueof(mile.IPM_Due_Date_Market_Ready__c.Year());   
                                }   
                            }   
                        }                                   
                    }   
                }
           }
        } //end of Milestone loop           
        return otifAnalytic;
    }

    /*********************************************************************************************************************
     * @Description: To copy OTIF Measure value when gate document is Contract
     * @param1: IPM_Project_Document_Section_Content__c IPM Project Document Section Content, IPM_Analytics__c IPM Analytics
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/ 
    public IPM_Analytics_OTIF__c setContractGateDcoumentDetails(IPM_Project_Document_Section_Content__c fr, IPM_Analytics_OTIF__c otifAnalytic){
        if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.Contract && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)  
            {
               otifAnalytic.IPM_OTIF_Comment_Contract__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
                if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_CUSTOMER_APPEAL)){
                   otifAnalytic.IPM_Customer_Appeal__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_CAPEX_APPROVED)){
                   otifAnalytic.IPM_Capex_Approved__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECHNICAL_FEASIBILITY)){
                   otifAnalytic.IPM_Technical_Feasibility__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_ATTRACTIVE_BUSINESS_CASE)){
                   otifAnalytic.IPM_Attractive_Business_Case__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_MATERIALS_SOURCING_STRATEGIES_AGREED)){
                   otifAnalytic.IPM_Materials_Sourcing_Strategies_Agreed__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECHNICAL_ACTION_STANDARDS_ACHIEVED_BY_LEAD_REGION)){
                   otifAnalytic.Tech_Action_STD_Achieved_by_Lead_Region__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_BASES_II)){
                   otifAnalytic.IPM_Base_II__c = fr.IPM_OTIF_Status__c;
                } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_BASES_I)){
                   otifAnalytic.IPM_Base_I__c = fr.IPM_OTIF_Status__c;
                } 
            }
        return otifAnalytic;       
    }
    /*********************************************************************************************************************
     * @Description: To copy OTIF Measure value when gate document is MarketReady
     * @param1: IPM_Project_Document_Section_Content__c IPM Project Document Section Content, IPM_Analytics__c IPM Analytics
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics_OTIF__c setMarketReadyGateDcoumentDetails(IPM_Project_Document_Section_Content__c fr, IPM_Analytics_OTIF__c otifAnalytic){    
        if(fr.IPM_Project_Document_Section__r.IPM_Gate_Document__c == IPM_Utils.MarketReady && fr.IPM_Project_Document_Section__r.IPM_Section_Name__c == IPM_ConstantUtils.OTIF_STATUS)
        {
           otifAnalytic.IPM_OTIF_Comment_MR__c = fr.IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c;
            if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_COMMUNICATION_BET_FINAL_RELEASE_AVAILABILITY)){
               otifAnalytic.Comm_BET_Final_Release_Availability__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECHNICAL_AND_PRODUCTION_CAPABILITY_CONFIRMED)){
               otifAnalytic.Tech_Prod_Capability_Confirmed__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_SPEC_BILLS_OF_MATERIALS_IN_INTERSPEC)){
               otifAnalytic.Spec_Bills_of_Materials_in_Interspec__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_TECH_PROD_CAPABILITY_CONF_MAIN_PLANT)){
               otifAnalytic.Tech_Prod_Capability_Conf_Main_Plant__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_BASES_III)){
               otifAnalytic.IPM_Bases_III__c = fr.IPM_OTIF_Status__c;
            } else if(fr.IPM_OTIF_Measure__c.equalsignorecase(IPM_ConstantUtils.OTIF_COMMUNICATION_FULL_THINK_BIG_PACK_AVAILABLE)){
               otifAnalytic.Comm_Full_Think_Big_Pack_Available__c = fr.IPM_OTIF_Status__c;
            }
        }
        return otifAnalytic;       
    }               
    /*********************************************************************************************************************
     * @Description: To copy OTIF Measure value when gate document is MarketReady
     * @param1: IPM_Project_Document_Section_Content__c IPM Project Document Section Content, IPM_Analytics__c IPM Analytics
     * @return: IPM_Analytics__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics_OTIF__c setRolloutFinancialdetails(IPM_Analytics_OTIF__c otifAnalytic, String finExtId, IPM_Project_Rollout__c pr){
        if(String.isNotBlank(finExtId) && rolloutFinancialYearmap.containskey(finExtId)){ 
            for(IPM_Financial_Year__c fr:rolloutFinancialYearmap.get(finExtId)){        
                
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c))
                { 
                    if(fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
                        // Populating Y3 gTO
                       otifAnalytic.IPM_Charter_Y3_gTO__c = fr.Turnover_Charter__c;
                       otifAnalytic.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
                       otifAnalytic.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;
                       otifAnalytic.IPM_MR_Y3_gTO__c = fr.Turnover_MR__c;
                       otifAnalytic.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
                       otifAnalytic.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
                       otifAnalytic.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
                       otifAnalytic.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;
                    } else if(fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
                        // Populating Y3 iTO                   
                       otifAnalytic.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
                       otifAnalytic.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
                       otifAnalytic.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;
                       otifAnalytic.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;                                      
                    }
                } 
                // Populating Y3 gTO BD
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                {  
                    otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Regional__c;
                    otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Regional__c;
                }                   
                // Populating Y3 iTO BD                   
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
                {                       
                    otifAnalytic.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
                }
                // Populating Y3 gTO BB
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross) && pr.IPM_Rollout_Span__c == IPM_ConstantUtils.Local)
                {  
                    otifAnalytic.IPM_Y3_gTO_BB__c = fr.Turnover_Local__c;
                    otifAnalytic.Y3_GM_BB__c =  fr.GM_of_TO_Local__c;
                }                   
                // Populating Y3 iTO BB                
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental) && pR.IPM_Rollout_Span__c == IPM_ConstantUtils.Local)
                {  
                    otifAnalytic.IPM_Y3_iTO_BB__c = fr.Turnover_Local__c;
                }               
            }
        }   
        return otifAnalytic;       
    }               
    /*********************************************************************************************************************
     * @Description: To fetch Consolidated Financial Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: Map<Id, IPM_Financial__c> Consolidated Financial Records
     *********************************************************************************************************************/ 
    public Map<Id, IPM_Financial__c> fetchConsolidatedFinancialRecords(map<id,IPM_Project__c> projectIdMap){
        financialIdSet = new set<id>();
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
                                                                                  IPM_Auto_Aligned_Fin_TLD__c,
                                                                                  IPM_Project_Rollout__r.id                                                                                  
                                                                                  FROM IPM_Financial__c WHERE Parent_Project__r.Id IN: projectIdMap.keyset() or Regional_Project__r.id IN:projectIdMap.keyset() or Local_Project__r.id IN: projectIdMap.keyset()  Limit 50000]);
        
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
        return projFinMap;
    }       
    /*********************************************************************************************************************
     * @Description: To fetch Financial Year Records
     * @param1: set<Id> financialIdSet
     * @return: Map<Id, IPM_Financial__c> Financial Year Records
     *********************************************************************************************************************/     
    public Map<Id, List<IPM_Financial_Year__c>> fetchFinancialYearRecords(set<Id> financialIdSet){
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
        return projFinYrMap;
    }       
    /*********************************************************************************************************************
     * @Description: To fetch milestone Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Milestone__c>> milestone Records
     *********************************************************************************************************************/     
    public map<Id,list<IPM_Milestone__c>> fetchMilestoneRecords(map<id,IPM_Project__c> projectIdMap){
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
                                                                               IPM_Project__r.Name,
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
     * @Description: To fetch gate Dcoument  Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Project_Document__c>> gate Docuements Records
     *********************************************************************************************************************/     
    public map<Id,list<IPM_Project_Document__c>> fetchGateDocumentRecords(map<id,IPM_Project__c> projectIdMap){
        map<Id,list<IPM_Project_Document__c>> projGateDocMap = new map<id,list<IPM_Project_Document__c>>();
        try{
        list<IPM_Project_Document__c> projGateDocList = new list<IPM_Project_Document__c>([SELECT id,
                                                                               IPM_GateDocuments__c,
                                                                               IPM_Approval_Date__c,
                                                                               IPM_Project__c,
                                                                               IPM_Project__r.id,
                                                                               IPM_Document_Status__c
                                                                               FROM IPM_Project_Document__c WHERE IPM_Project__r.id IN:projectIdMap.keyset() Limit 50000]);
    
            for(IPM_Project_Document__c im:projGateDocList){
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
     * @Description: To fetch rollout Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Project_Rollout__c>> rollout Records
     *********************************************************************************************************************/         
    public map<id,list<IPM_Project_Rollout__c>> fetchRolloutRecords(map<id,IPM_Project__c> projectIdMap){
        map<id,list<IPM_Project_Rollout__c>> projRolloutMap = new map<id,list<IPM_Project_Rollout__c>>();
        regionalRolloutset = new set<id> ();
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
                                                                                                    Regional_Project__r.IPM_SourceProjectType__c,
                                                                                                    Regional_Project__r.Id,
                                                                                                    IPM_Rollout_Span__c
                                                                                                    FROM IPM_Project_Rollout__c 
                                                                                                    //WHERE IPM_Project__r.id IN:rolloutprojectIdSet Limit 50000]);
                                                                                                    WHERE IPM_Project__r.id IN:projectIdMap.keyset() or Regional_Project__r.Id IN:projectIdMap.keyset() Limit 50000]);
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
                    Id RegionalRolloutId = pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE?pr.Id:pr.Regional_Rollout__r.id;
                    regionalRolloutset.add(RegionalRolloutId); 

                    if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){                      
                      localRolloutIDSet.add(pr.Id);                        
                    }
                 }    
            }
        }
        
        catch(Exception ex){  
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null); 
        } 
        return projRolloutMap;
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
            list<IPM_Project_Document_Section_Content__c> projectDocumentSectionContentList = new list<IPM_Project_Document_Section_Content__c>([SELECT id,
                                                                                              IPM_Section_Name__c,
                                                                                              IPM_OTIF_Measure__c,
                                                                                              IPM_OTIF_Status__c,
                                                                                              IPM_Project_Document_Section__r.IPM_Gate_Document_Summary__c,
                                                                                              IPM_Project_Document_Section__r.IPM_Gate_Document__c,
                                                                                              IPM_Project_Document_Section__r.IPM_Section_Name__c,
                                                                                              IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c,
                                                                                              IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__r.Name
                                                                                              from IPM_Project_Document_Section_Content__c
                                                                                              WHERE IPM_Project_Document_Section__r.IPM_Project_Document__r.IPM_Project__c IN: projectIdMap.keyset()  Limit 50000]);        
                
            for(IPM_Project_Document_Section_Content__c pDocSecContent :projectDocumentSectionContentList){                                                                                       
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
     * @Description: To fetch rollout financial Records
     * @param1: set<id> regionalRolloutset
     * @return: map<Id,list<IPM_Financial__c>>  rollout financial Records
     *********************************************************************************************************************/             
    public map<id,list<IPM_Financial__c>> fetchRolloutFinancial(set<id> regionalRolloutset){
        map<id,list<IPM_Financial__c>> rolloutFinancialmap = new map<id,list<IPM_Financial__c>> ();
        rolloutFinIdSet = new set<id>();
        try{
            list<IPM_Financial__c> projRolloutFinList = new list<IPM_Financial__c>([SELECT  id,
                                                                                            name,
                                                                                            RecordTypeId,  
                                                                                            Financial_External_ID__c,
                                                                                            IPM_Project_Rollout__r.Id
                                                                                            FROM IPM_Financial__c 
                                                                                            WHERE IPM_Project_Rollout__c IN: regionalRolloutset Limit 50000]);
                                                
            for(IPM_Financial__c fir:projRolloutFinList){
                if(!rolloutFinancialmap.containskey(fir.IPM_Project_Rollout__r.Id)){
                    rolloutFinancialmap.put(fir.IPM_Project_Rollout__r.Id, new List<IPM_Financial__c>{fir});  
                }else{
                    List<IPM_Financial__c> finrList = rolloutFinancialmap.get(fir.IPM_Project_Rollout__r.Id);
                    finrList.add(fir);
                    rolloutFinancialmap.put(fir.IPM_Project_Rollout__r.Id,finrList);              
                }
                rolloutFinIdSet.add(fir.id);
            }
        }   
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR,null,null,null,null); 
        }
        return rolloutFinancialmap;
    }   
    /*********************************************************************************************************************
     * @Description: To fetch rollout financial Year Records
     * @param1: set<id> finIdSet
     * @return: map<Id,list<IPM_Financial_Year__c>>  rollout financial Year Records
     *********************************************************************************************************************/             
    public map<string,list<IPM_Financial_Year__c>> fetchRolloutFinancialYear(set<Id> finIdSet){
        map<string,list<IPM_Financial_Year__c>> rolloutFinancialYearmap = new map<string,list<IPM_Financial_Year__c>> ();
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
                                                                                                            PL_Type__c,
                                                                                                            Turnover_Charter__c,
                                                                                                            Turnover_Contract__c,
                                                                                                            Turnover_MD__c,
                                                                                                            Turnover_MR__c,
                                                                                                            GM_of_TO_Charter__c,
                                                                                                            GM_of_TO_Contract__c,
                                                                                                            GM_of_TO_MD__c,
                                                                                                            GM_of_TO_MR__c,
                                                                                                            GM_of_TO_Local__c,
                                                                                                            GM_of_TO_Global__c,
                                                                                                            GM_of_TO_Regional__c                                                                                                            
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
        return rolloutFinancialYearmap;
    }       
    /*********************************************************************************************************************
     * @Description: To fetch Country Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,String>  country Records
     *********************************************************************************************************************/                 
    public Map<Id, String> fetchCountryRecords(map<id,IPM_Project__c> projectIdMap){
        Map<Id, String> ipmCountryMap = new map<Id, String>();
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
                                                                       FROM IPM_Country__c WHERE (IPM_Local_Project__r.Id IN : projectIdMap.keyset() or Local_Rollout__r.id IN: localRolloutIDSet) Limit 50000]);
            
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
        return ipmCountryMap;
    }       
    /*********************************************************************************************************************
     * @Description: To copy project field values to OTIF analytic record
     * @param1: IPM_Project__c p
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c copyProjectFieldValues(IPM_Project__c proj){
        IPM_Analytics_OTIF__c otifAnalytic = new IPM_Analytics_OTIF__c();
       otifAnalytic.IPM_Project_Id__c = proj.id;
       otifAnalytic.IPM_Project_Name__c = proj.name;
       otifAnalytic.IPM_Project_Description__c = proj.IPM_Project_Description__c;
       otifAnalytic.IPM_Parent_Project_Name__c = proj.IPM_Parent_Project__r.Name;  
       otifAnalytic.IPM_Project_Leader__c = proj.IPM_Project_Leader__r.Name;
       otifAnalytic.IPM_Deputy_Project_Leader__c = proj.Deputy_Project_Leader__r.Name;
       otifAnalytic.IPM_Finance_Member__c = proj.IPM_Finance_Member__r.Name;
       otifAnalytic.IPM_Project_Span__c = proj.IPMProject_Span__c;
       otifAnalytic.IPM_Project_Type__c = proj.IPM_Project_Type__c;
       otifAnalytic.IPM_Company__c = proj.IPM_Company_Card__r.Name;
       otifAnalytic.IPM_Category_Group__c = proj.IPM_Category_Group__c;
       otifAnalytic.IPM_Category__c = proj.IPM_Category_Text__c;
       otifAnalytic.IPM_Brand_Positioning__c = proj.IPM_Brand_Positioning__c;
       otifAnalytic.IPM_Market_Place_Activity__c = proj.IPM_Answer_of_Q1__c;
       otifAnalytic.IPM_Consumer_Value_Perception__c = proj.IPM_Answer_of_Q2__c;
       otifAnalytic.IPM_Enabling_Technology__c = proj.IPM_Answer_of_Q3__c;
       otifAnalytic.IPM_Strategic_Intent__c = proj.IPM_Strategic_Intent__c;
       otifAnalytic.IPM_Phase__c = proj.IPM_Phase__c;

        if(String.isNotBlank(proj.IPMProject_Span__c) && (proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) || proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional))){
           otifAnalytic.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
        }else if(String.isNotBlank(proj.IPMProject_Span__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
           otifAnalytic.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
           otifAnalytic.IPM_Market_Cluster__c = proj.Market_Cluster_Name__c;                 
        }

        if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
           otifAnalytic.IPM_Geography__c = IPM_Utils.valueGlobal;             
        } else if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
            otifAnalytic.IPM_Geography__c = proj.Market_Cluster_Name__c;
        }else if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
           otifAnalytic.IPM_Geography__c = proj.Market_Cluster_Name__c;
        }else if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
            if(ipmCountryMap.containskey(proj.id)){otifAnalytic.IPM_Geography__c = ipmCountryMap.get(proj.id);}
        }

        // populate target launch year & month
        if(String.isNotBlank(proj.IPM_Project_Type__c) && (proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) || proj.IPM_Project_Type__c.equalsignorecase(IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL) ||(String.isNotBlank(proj.IPMProject_Span__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)))){
           otifAnalytic.IPM_Target_Launch_Month_BD__c = proj.IPM_Target_Launch_Month__c;
           otifAnalytic.IPM_Target_Launch_Year_BD__c = proj.IPM_Target_Launch_Year__c;   
        }
        if (String.isNotBlank(proj.IPMProject_Span__c) && String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)){
           otifAnalytic.IPM_Target_Launch_Month_BB__c = proj.IPM_Target_Launch_Month__c;
           otifAnalytic.IPM_Target_Launch_Year_BB__c = proj.IPM_Target_Launch_Year__c;
            //if(String.isNotBlank(string.valueof(proj.IPM_Parent_Project__r.IPM_Project_Rollout__r.Target_Launch_Date__c))){
            if(String.isNotBlank(string.valueof(proj.IPM_Project_Rollout__r.Target_Launch_Date__c))){
               otifAnalytic.IPM_Target_Launch_Month_BD__c = monthNameIntegerToString.get(proj.IPM_Project_Rollout__r.Target_Launch_Date__c.month());
               otifAnalytic.IPM_Target_Launch_Year_BD__c = string.valueof(proj.IPM_Project_Rollout__r.Target_Launch_Date__c.Year());   
            }                  
        }

        //Global Project Business Impact Global will be copy to Global,Regional & Local project
        if(projFinmap.containskey(proj.Id)){ 
           otifAnalytic.IPM_Business_Impact__c = projFinMap.get(proj.id).Business_Impact_Global__c; 
        }  
        return otifAnalytic;
    }           
}