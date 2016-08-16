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
    //global map<Id,list<IPM_Project_Rollout__c>> projRolloutMap;
    global map<Id,list<IPM_Project_Document__c>> projGateDocumentMap;
    //global map<Id,list<IPM_Project_Document_Section_Content__c>> projDocSecContentMap;
    global map<string,list<IPM_Financial_Year__c>> rolloutFinancialYearmap;  
    //global map<id,list<IPM_Financial__c>> rolloutFinancialmap;
    global list<IPM_Analytics_OTIF__c> analyticRecOTIFList;
    global set<id> localRolloutIDSet = new set<id>();
    global set<id> regionalRolloutset = new set<id> ();
    global set<id> rolloutFinIdSet = new set<id>();
    global Map<Id, String> ipmCountryMap = new map<Id, String>();
    global set<id> financialIdSet = new set<id>();
    global Map<Id, IPM_Financial__c> projFinMap = new Map<Id, IPM_Financial__c> ();
    global Map<Id, List<IPM_Financial_Year__c>> projFinYrMap =new map<Id, List<IPM_Financial_Year__c>>();
    global Map<Id, IPM_Financial__c> regionalProjNKFinMap = new Map<Id, IPM_Financial__c> ();
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
   
    public Map<Id, Set<Id>> regRLToNKLocalRolloutMap = new Map<Id, Set<Id>>(); // This map will store Regional Rollout Id to corresponding Non key rollout ids

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
         if(p.IPM_Phase__c != null)
         {
           scopeProjectList.add(p);
         }
          projectIdMap.put(p.Id,p);         
         
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
       projFinYrMap = fetchFinancialYearRecords(financialIdSet);

        //Fetching gateDocument records and creating map 
        projGateDocumentMap = fetchGateDocumentRecords(projectIdMap);   
        
        //Fetching milestone records and creating map 
        map<Id,list<IPM_Milestone__c>> projMilestoneMap = fetchMilestoneRecords(projectIdMap);
        
        //Fetching rollout records for project and creating map
        map<Id,list<IPM_Project_Rollout__c>> projRolloutMap = fetchRolloutRecords(projectIdMap);

        //Fetching IPM Project Document Section Content records for project and creating map
        map<Id,list<IPM_Project_Document_Section_Content__c>> projDocSecContentMap = fetchProjectDocumentSectionContent(projectIdMap);
        
        //To fetch the financials for the rollout project when it is in Ideas phase
        map<id,list<IPM_Financial__c>> rolloutFinancialmap = fetchRolloutFinancial(regionalRolloutset);
        
        //To Fetch Team Members        
        map<Id,list<IPM_Project_Resource__c>> projResourceMap = fetchTeamMembers(projectIdMap);
        
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
            // Copying Finance memeber related detail 
            otifAnalytic = processFinanceMemberDetails(projResourceMap, otifAnalytic, p);
            
            analyticRecOTIFList.add(otifAnalytic);  
            
            if(projRolloutMap.containskey(otifAnalytic.IPM_Project_Id__c)){
              List<IPM_Analytics_OTIF__c> rollAnalyticlist = new List<IPM_Analytics_OTIF__c> (addrolloutproject(otifAnalytic,projRolloutMap,rolloutFinancialmap));
                if(!rollAnalyticlist.isEmpty()){
                  analyticRecOTIFList.addall(rollAnalyticlist);                
                }               
            }  
            // For Non Key Financials
            if(regionalProjNKFinMap.containskey(otifAnalytic.IPM_Project_Id__c)){
               
            	
            	IPM_Financial__c nonKeyFinancial = regionalProjNKFinMap.get(otifAnalytic.IPM_Project_Id__c);
            	IPM_Analytics_OTIF__c nonKeyrollAnalytic = addNonKeyFinancial(otifAnalytic, nonKeyFinancial, p, null);
                if(nonKeyrollAnalytic != null){
                  analyticRecOTIFList.add(nonKeyrollAnalytic);                
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
    public List<IPM_Analytics_OTIF__c> addrolloutproject (IPM_Analytics_OTIF__c parentanalyticrec,map<Id,list<IPM_Project_Rollout__c>> projRolloutMap,map<id,list<IPM_Financial__c>> rolloutFinancialmap){
       
        IPM_Analytics_OTIF__c parent = parentanalyticrec;
        list<IPM_Analytics_OTIF__c> returnList = new list<IPM_Analytics_OTIF__c>();
        id regionalrolloutid = null;             
         
         for(IPM_Project_Rollout__c pr:projRolloutMap.get(parent.IPM_Project_Id__c)){
                
                IPM_Analytics_OTIF__c otifAnalyticRollOut = new IPM_Analytics_OTIF__c();
                //copy Values from rollout record
                otifAnalyticRollOut.IPM_Project_Phantom_Non_Key__c = IPM_ConstantUtils.Phantom;
                otifAnalyticRollOut.IPM_Project_Name__c = pr.name;
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
                    regionalrolloutid = pr.Id;                                     
                    // Add nonkey rollout record                    
                    for(IPM_Financial__c financial : rolloutFinancialmap.get(regionalrolloutid)){
		              	 if(financial.Financial_External_ID__c == pr.name + IPM_ConstantUtils.FINANCIAL_NONKEY){
		              	     IPM_Analytics_OTIF__c analyticNKObj = new IPM_Analytics_OTIF__c();
		              	 	 analyticNKObj = addNonKeyFinancial(otifAnalyticRollOut, financial, null, pr);
		              	 	 returnList.add(analyticNKObj);
		              	 	 
		              	 	 break; 
		                 } 
            		}
                }else if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE ){
                    otifAnalyticRollOut.IPM_Project_Span__c = IPM_Utils.Local;
                    otifAnalyticRollOut.IPM_Geography__c=ipmCountryMap.containskey(pr.id)?ipmCountryMap.get(pr.id):'';
                    otifAnalyticRollOut.IPM_Market_Cluster__c = pr.Market_Cluster_Name__c;
                    otifAnalyticRollOut.IPM_Phase__c = pr.Regional_Project__r.IPM_Phase__c;
                   // otifAnalyticRollOut.IPM_Key_NonKey__c = pr.KeyMCO__c?IPM_ConstantUtils.OTIF_YES:IPM_ConstantUtils.OTIF_NO;
                    otifAnalyticRollOut.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
                    regionalrolloutid=pr.Regional_Project__c != null?pr.Regional_Rollout__r.id:null;
                }   
                
                string finExtId = '';
                if(regionalrolloutid != null && rolloutFinancialmap.containskey(regionalrolloutid)){ 
                    for(IPM_Financial__c fir:rolloutFinancialmap.get(regionalrolloutid)){
                        if((pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE && fir.Financial_External_ID__c == pr.name+IPM_Utils.CONSOLIDATED) || (pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE && fir.Financial_External_ID__c == pr.name)){
                            finExtId = fir.Financial_External_ID__c;                                                           
                        }                       
                    }
                }                                           
                
                otifAnalyticRollOut = setRolloutFinancialdetails(otifAnalyticRollOut,finExtId,pr); 

                returnList.add(otifAnalyticRollOut);              

            }
            
        return returnList;    
    }  
    
    
    /*********************************************************************************************************************
     * @Description: To copy Milestone related details to that particular project
     * @param1: Map<Id, List<IPM_Milestone__c>> (Project And Its related Milestone records), IPM_Analytics_OTIF__c IPM Analytics , IPM Project
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/
    
     public IPM_Analytics_OTIF__c processFinanceMemberDetails(map<Id,list<IPM_Project_Resource__c>> projResourceMap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        //Copying IPM Project Resource fields 
        if(projResourceMap.containskey(p.id)){ 
            for(IPM_Project_Resource__c resource : projResourceMap.get(p.id)){ 
                if(resource.IPM_Role_Type__c.equalsignorecase(IPM_Utils.Finance)){
                	otifAnalytic.IPM_Finance_Member__c = resource.IPM_User__r.Name;
                }
           }
        } //end of IPM Project Resource loop           
        return otifAnalytic;
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
     * @Description: To copy financial years related details to that particular project
     * @param1: Map<Id, List<IPM_Financial_Year__c>> (Project And Its related Financial years), IPM_Analytics_OTIF__c IPM Analytics , IPM Project
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/
    public IPM_Analytics_OTIF__c processFinancialDetails(Map<Id, List<IPM_Financial_Year__c>> projFinYrmap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        //Copying IPM Financial Year fields
        if(projFinYrmap.containskey(p.id) && String.isNotBlank(p.IPMProject_Span__c)){
            for(IPM_Financial_Year__c fr:projFinYrMap.get(p.id)){
               
                otifAnalyticObj = setPLTypeGrossValues(fr,otifAnalyticObj, p);//Calender Yaer Projects
                               
                otifAnalyticObj = setPLTypeIncrementalValues(fr,otifAnalyticObj, p);//Calender year Projects
                
                otifAnalyticObj = setIncrementalValuesInnovationProject(fr,otifAnalytic,p);//Innovation Year Projects
                
                otifAnalyticObj = setGrossValuesInnovationProject(fr,otifAnalytic,p);//Innovation Year Projects
               otifAnalyticObj = setIncrementalValuesNonkeyProject(fr,otifAnalytic,p);//NONKEY Financial Projects----Incremental value
               otifAnalyticObj = setGrossValuesNonkeyProject(fr,otifAnalytic,p);//NONKEY Financial Projects---Gross Value
               
               
        
            }//end of Financial Year For loop
        
        }
        return otifAnalyticObj;
    }       
    /*********************************************************************************************************************
     * @Description: To copy Milestone related details to that particular project
     * @param1: Map<Id, List<IPM_Milestone__c>> (Project And Its related Milestone records), IPM_Analytics_OTIF__c IPM Analytics , IPM Project
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/
    
    public IPM_Analytics_OTIF__c processMilestoneDetails(map<Id,list<IPM_Milestone__c>> projMilestoneMap, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        
        IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic; 
        //Copying IPM Milestone fields 
        if(projMilestoneMap.containskey(p.id)){ 
            for(IPM_Milestone__c mile : projMilestoneMap.get(p.id)){ 
                if(mile.IPM_Name__c.equalsignorecase(IPM_Utils.TargetLaunchDateShiptoTrade)){
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
     * @Description: To copy OTIF Measure value when gate document is MarketReady
     * @param1: IPM_Project_Document_Section_Content__c IPM Project Document Section Content, IPM_Analytics_OTIF__c IPM Analytics
     * @return: IPM_Analytics_OTIF__c Analytic object record  
     *********************************************************************************************************************/     
    public IPM_Analytics_OTIF__c setRolloutFinancialdetails(IPM_Analytics_OTIF__c otifAnalytic, String finExtId, IPM_Project_Rollout__c pr){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(String.isNotBlank(finExtId) && rolloutFinancialYearmap.containskey(finExtId)){ 
            for(IPM_Financial_Year__c fr:rolloutFinancialYearmap.get(finExtId)){      
                otifAnalyticObj = setPLTypeGrossValuesRollout(fr,otifAnalyticObj, pr);				// Calender Year of Rollouts
                               
                otifAnalyticObj = setPLTypeIncrementalValuesRollout(fr,otifAnalyticObj, pr);  		// Calender Year of rollouts
                
                otifAnalyticObj = setIncrementalValuesInnovationRollout(fr,otifAnalyticObj, pr);	// Innovation Year of Rollout
                otifAnalyticObj = setGrossValuesInnovationRollout(fr,otifAnalyticObj, pr);			// Innovation Year Rollout
              otifAnalyticObj = setIncrementalValuesNonkeyRollout(fr,otifAnalytic,pr);			//Incremental value NONKEY Financials of Rollout
              otifAnalyticObj = setGrossValuesNonkeyRollout(fr,otifAnalytic,pr);					//Gross Value NONKEY Financials of Rollout
                 
            }
        }   
        return otifAnalyticObj;       
    }               
    
    
    
    /*********************************************************************************************************************
     * @Description: To fetch team members
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: Map<Id, IPM_Financial__c> 
     *********************************************************************************************************************/ 
      public map<Id,list<IPM_Project_Resource__c>> fetchTeamMembers(map<id,IPM_Project__c> projectIdMap){
       
        map<Id,list<IPM_Project_Resource__c>> projResourceMap = new map<id,list<IPM_Project_Resource__c>>();  // this map will hold project id and corresponding project resource
        try{ 
        for(IPM_Project_Resource__c projResource : [SELECT Id,IPM_Project__c,IPM_Project__r.id,IPM_Role_Type__c,IPM_User__r.Name                                                                                 
                                                              FROM IPM_Project_Resource__c WHERE IPM_Project__r.id IN:projectIdMap.keyset() Limit 50000]){
        	 if(!projResourceMap.containskey(projResource.IPM_Project__r.id)){
                        projResourceMap.put(projResource.IPM_Project__r.id, new List<IPM_Project_Resource__c>{projResource});   
                }else{
                    List<IPM_Project_Resource__c> resourceList = projResourceMap.get(projResource.IPM_Project__r.id);
                    resourceList.add(projResource);
                    projResourceMap.put(projResource.IPM_Project__r.id, resourceList);           
                }
            }
        } 
        catch(Exception ex){
                ExceptionLoggingHelper.createErrorLog(UserInfo.getUserId(),CLASS_NAME,METHOD_NAME,ex.getMessage(),ex, IPM_ConstantUtils.ERROR, null,null,null,null);
        } 
        return projResourceMap;
    }       
    
    
    
    
    /*********************************************************************************************************************
     * @Description: To fetch Consolidated Financial Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: Map<Id, IPM_Financial__c> Consolidated Financial Records
     *********************************************************************************************************************/ 
    public Map<Id, IPM_Financial__c> fetchConsolidatedFinancialRecords(map<id,IPM_Project__c> projectIdMap){
        financialIdSet = new set<id>();
       projFinMap = new map<Id,IPM_Financial__c>();  // this map will hold project id and corresponding Consolidated financial records
       regionalProjNKFinMap = new Map<Id, IPM_Financial__c>(); // this map will hold project id and corresponding Non Key financial records
        try{   
             for(IPM_Financial__c fi:[SELECT id,
                                          name,
                                          Display_Name__c,
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
                                          FROM IPM_Financial__c WHERE Parent_Project__r.Id IN: projectIdMap.keyset() or Regional_Project__r.id IN:projectIdMap.keyset() or Local_Project__r.id IN: projectIdMap.keyset()  Limit 50000]){
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
                else if(fi.Regional_Project__r.id !=null &&  fi.Financial_External_ID__c == fi.Regional_Project__r.Name + IPM_ConstantUtils.FINANCIAL_NONKEY){
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
    public Map<Id, List<IPM_Financial_Year__c>> fetchFinancialYearRecords(set<Id> financialIdSet){
        projFinYrMap = new map<Id, List<IPM_Financial_Year__c>>();  //This map will hold project id and financial year records
        try{              
            for(IPM_Financial_Year__c fy:[SELECT id,
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
                                                      Charter_Approved__c,
                                                      Contract_Approved__c,
                                                      MD_Approved__c,
                                                      MR_Approved__c,
	                                              PL_Type__c FROM IPM_Financial_Year__C 
                                                WHERE IPM_Financial__c IN:financialIdSet Limit 50000]){
                
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
              for(IPM_Milestone__c im:[SELECT id,
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
                                           FROM IPM_Milestone__c WHERE IPM_Project__r.id IN:projectIdMap.keyset() Limit 50000]){
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
     * @Description: To fetch rollout Records
     * @param1: map<id,IPM_Project__c> projectIdMap
     * @return: map<Id,list<IPM_Project_Rollout__c>> rollout Records
     *********************************************************************************************************************/         
    public map<id,list<IPM_Project_Rollout__c>> fetchRolloutRecords(map<id,IPM_Project__c> projectIdMap){
        map<id,list<IPM_Project_Rollout__c>> projRolloutMap = new map<id,list<IPM_Project_Rollout__c>>();
        regionalRolloutset = new set<id> ();
        try{
            for(IPM_Project_Rollout__c pr:[SELECT id,
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
	                                                Regional_Project__r.IPM_Phase__c,
	                                                IPM_Rollout_Span__c
	                                                FROM IPM_Project_Rollout__c 
                                                  //WHERE IPM_Project__r.id IN:rolloutprojectIdSet Limit 50000]);
                                                  WHERE IPM_Project__r.id IN:projectIdMap.keyset() or Regional_Project__r.Id IN:projectIdMap.keyset() Limit 50000]){
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
                    Id regRolloutId = pr.RecordTypeId == REGIONAL_ROLLOUT_RECTYPE?pr.Id:pr.Regional_Rollout__r.id;
                    regionalRolloutset.add(regRolloutId); 

                    if(pr.RecordTypeId == LOCAL_ROLLOUT_RECORDTYPE){                      
                      localRolloutIDSet.add(pr.Id);                        
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
     * @Description: To fetch rollout financial Records
     * @param1: set<id> regionalRolloutset
     * @return: map<Id,list<IPM_Financial__c>>  rollout financial Records
     *********************************************************************************************************************/             
    public map<id,list<IPM_Financial__c>> fetchRolloutFinancial(set<id> regionalRolloutset){
        map<id,list<IPM_Financial__c>> rolloutFinancialmap = new map<id,list<IPM_Financial__c>> ();
        rolloutFinIdSet = new set<id>();
        try{
            for(IPM_Financial__c fir:[SELECT  id,
                                            name,
                                            Display_Name__c,
                                            RecordTypeId,  
                                            Financial_External_ID__c,
                                            IPM_Project_Rollout__r.Id
                                            FROM IPM_Financial__c 
                                            WHERE IPM_Project_Rollout__c IN: regionalRolloutset Limit 50000]){
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
            for(IPM_Financial_Year__c fiyr:[SELECT    id,   
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
                                                    Charter_Approved__c,
                                                    Contract_Approved__c,
                                                    MD_Approved__c,
                                                    MR_Approved__c                                                                                                            
                                                    FROM IPM_Financial_Year__C 
                                                    WHERE IPM_Financial__c IN: finIdSet Limit 50000]){
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
           for(IPM_Country__c ic:[SELECT Country_Code__c,
                                           Country_Name__c,
                                           IPM_Project__r.id,
                                           IPM_Project__r.IPMProject_Span__c,
                                           IPM_Local_Project__r.Id,
                                           IPM_Local_Project__r.IPMProject_Span__c,
                                           IPM_Regional_Project__r.Id,
                                           IPM_Regional_Project__r.IPMProject_Span__c,
                                           Local_Rollout__r.id
                                           FROM IPM_Country__c WHERE (IPM_Local_Project__r.Id IN : projectIdMap.keyset() or Local_Rollout__r.id IN: localRolloutIDSet) Limit 50000]){
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
       IPM_Analytics_OTIF__c otifAnalyticProj = new IPM_Analytics_OTIF__c();
       otifAnalyticProj.IPM_Project_Id__c = proj.id;
       otifAnalyticProj.IPM_Project_Name__c = proj.name;
       otifAnalyticProj.IPM_Project_Phantom_Non_Key__c = IPM_ConstantUtils.Project;
       otifAnalyticProj.IPM_Project_Description__c = proj.IPM_Project_Description__c;
       otifAnalyticProj.IPM_Parent_Project_Name__c = proj.IPM_Parent_Project__r.Name;  
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

        if(String.isNotBlank(proj.IPMProject_Span__c) && (proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal) || proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional))){
           otifAnalyticProj.IPM_IC_NBU__c = IPM_Utils.IPM_IC;
        }else if(String.isNotBlank(proj.IPMProject_Span__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
           otifAnalyticProj.IPM_IC_NBU__c = IPM_Utils.IPM_IC_NBU;
           otifAnalyticProj.IPM_Market_Cluster__c = proj.Market_Cluster_Name__c;                 
        }
        //setGeography
        otifAnalyticProj = setGeography(proj,otifAnalyticProj);

        // populate target launch year & month
        otifAnalyticProj = setTargetLaunchYearandMonth(proj,otifAnalyticProj);

        //Global Project Business Impact Global will be copy to Global,Regional & Local project
        if(projFinmap.containskey(proj.Id)){ 
           otifAnalyticProj.IPM_Business_Impact__c = projFinMap.get(proj.id).Business_Impact_Global__c; 
        }  
        return otifAnalyticProj;
    }           
    /*********************************************************************************************************************
     * @Description: To copy PLType Gross values Calender Year ---- Project
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setPLTypeGrossValues(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
            {  
              // Populating Y3 gTO  
              otifAnalytic.IPM_Charter_Y3_gTO__c = fr.Turnover_Charter__c;
              otifAnalytic.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
              otifAnalytic.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;
              otifAnalytic.IPM_MR_Y3_gTO__c = fr.Turnover_MR__c;
              otifAnalytic.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
              otifAnalytic.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
              otifAnalytic.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
              otifAnalytic.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;  
              
              // Populating Y3 gTO BD   
               if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Local__c;
                    otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Local__c;
               } else {
                    otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Regional__c;
                    otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Regional__c;
               }
                // Populating Y3 gTO BB             
               if(p.IPMProject_Span__c == IPM_ConstantUtils.Local && p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
                    otifAnalytic.IPM_Y3_gTO_BB__c = fr.Turnover_Local__c;
                    otifAnalytic.Y3_GM_BB__c =  fr.GM_of_TO_Local__c;
                } 
            }
        return otifAnalytic;    
    }   
    /*********************************************************************************************************************
     * @Description: To copy PLType Incremental values 
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setPLTypeIncrementalValues(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
    	
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
        {
          // Populating Y3 iTO  
          otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
          otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
          otifAnalyticObj.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;
          otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
          
          // Populating Y3 iTO  BD
           if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL || || p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
                if(p.IPM_Phase__c == IPM_Utils.Ideas) {
					otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Global__c;
				}
				else {
					otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
				}
           } else if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Local__c;
           } else if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && p.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){ 
           		// Defect 3701 fix
           		otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
           }else {
                otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
           }
            // Populating Y3 iTO BB
           if(p.IPMProject_Span__c == IPM_ConstantUtils.Local && p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ROLLOUT){
                otifAnalyticObj.IPM_Y3_iTO_BB__c = fr.Turnover_Local__c;
           }           
        }
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
     * @Description: To set Geography
     * @param1: IPM_Project__c proj
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
    public IPM_Analytics_OTIF__c setGeography(IPM_Project__c proj,IPM_Analytics_OTIF__c otifAnalyticProj){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalyticProj; 
        if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.valueGlobal)){
           otifAnalyticObj.IPM_Geography__c = IPM_Utils.valueGlobal;             
        } else if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Original) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
            otifAnalyticObj.IPM_Geography__c = proj.Market_Cluster_Name__c;
        }else if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Regional)){
           otifAnalyticObj.IPM_Geography__c = proj.Market_Cluster_Name__c;
        }else if(String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local)){
            if(ipmCountryMap.containskey(proj.id)){otifAnalyticObj.IPM_Geography__c = ipmCountryMap.get(proj.id);}
        }
        return otifAnalyticObj;
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
        if (String.isNotBlank(proj.IPMProject_Span__c) && String.isNotBlank(proj.IPM_Project_Type__c) && proj.IPMProject_Span__c.equalsignorecase(IPM_Utils.Local) && proj.IPM_Project_Type__c.equalsignorecase(IPM_Utils.Rollout)){
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
     * @Description: To copy PLType Gross values 
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setPLTypeGrossValuesRollout(IPM_Financial_Year__c fr, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project_Rollout__c pr){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
            {  
              // Populating Y3 gTO  
              otifAnalyticObj.IPM_Charter_Y3_gTO__c = fr.Turnover_Charter__c;
              otifAnalyticObj.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
              otifAnalyticObj.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;
              otifAnalyticObj.IPM_MR_Y3_gTO__c = fr.Turnover_MR__c;
              otifAnalyticObj.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
              otifAnalyticObj.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
              otifAnalyticObj.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
              otifAnalyticObj.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;  
              
                // Populating Y3 gTO BD
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                {  
                    otifAnalyticObj.IPM_Y3_gTO_BD__c = fr.Turnover_Regional__c;
                    otifAnalyticObj.Y3_GM_BD__c = fr.GM_of_TO_Regional__c;
                }                   

                // Populating Y3 gTO BB
                if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross) && pr.IPM_Rollout_Span__c == IPM_ConstantUtils.Local)
                {  
                    otifAnalyticObj.IPM_Y3_gTO_BB__c = fr.Turnover_Local__c;
                    otifAnalyticObj.Y3_GM_BB__c =  fr.GM_of_TO_Local__c;
                }                   

            }
        return otifAnalyticObj;    
    }   
    /*********************************************************************************************************************
     * @Description: To copy PLType Incremental values 
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/                 
    public IPM_Analytics_OTIF__c setPLTypeIncrementalValuesRollout(IPM_Financial_Year__c fr, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project_Rollout__c pr){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
        {
          // Populating Y3 iTO  
          otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
          otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
          otifAnalyticObj.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;
          otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
          
            // Populating Y3 iTO BD                   
            if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
            {                       
                otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
            }
            // Populating Y3 iTO BB                
            if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental) && pR.IPM_Rollout_Span__c == IPM_ConstantUtils.Local)
            {  
                otifAnalyticObj.IPM_Y3_iTO_BB__c = fr.Turnover_Local__c;
            }   
        }
        return otifAnalyticObj;
    } 
    
    /*********************************************************************************************************************
     * @Description: To copy PLType Incremental values of Rollouts/Phantom from the Innovation Year Table
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project_Rollout__c pr    
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/  
	   public IPM_Analytics_OTIF__c setIncrementalValuesInnovationRollout(IPM_Financial_Year__c fr, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project_Rollout__c pr){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
        {
          // Populating Y1 iTO 
           if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
           	
           	
           	otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;		//Charter Innovation Y1 iTO	 
          	otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;		//Contract Innovation Y1 iTO	
         	otifAnalyticObj.IPM_MD_Y1_iTO__c = fr.Turnover_MD__c;					//Market Deployment Innovation Y1 iTO	
          	otifAnalyticObj.IPM_MR_Y1_iTO__c = fr.Turnover_MR__c;					//Market Ready Innovation Y1 iTO	
          
           
           } 
          
            // Populating Y1 iTO BD                   
            if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
            {                       
               otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Regional__c;		//Innovation Y1 iTO (BD)
            }
                          
            
        }
        return otifAnalyticObj;
    }  
		
		
     /*********************************************************************************************************************
     * @Description: To copy PLType Gross values of Rollouts/Phantom from the Innovation Year Table
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project_Rollout__c pr    
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
      *********************************************************************************************************************/
	     public IPM_Analytics_OTIF__c setGrossValuesInnovationRollout(IPM_Financial_Year__c fr, IPM_Analytics_OTIF__c otifAnalytic, IPM_Project_Rollout__c pr){
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
            {  
              // Populating Y1 gTO 
              if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){ 
              otifAnalyticObj.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;		//Charter Innovation Y1 gTO 
              otifAnalyticObj.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;		//Contract Innovation Y1 gTO 
              otifAnalyticObj.IPM_MD_Y1_gTO__c = fr.Turnover_MD__c;					//Market Deployment Innovation Y1 gTO 
              otifAnalyticObj.IPM_MR_Y1_gTO__c = fr.Turnover_MR__c;					//Market Ready Innovation Y1 gTO
              }
              otifAnalyticObj.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c;		//Charter Innovation Y1 GM%	
              otifAnalyticObj.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;		//Contract Innovation Y1 GM%	
              otifAnalyticObj.IPM_MD_Y1_GM__c = fr.GM_of_TO_MD__c;					//Market Deployment Innovation Y1 GM%
              otifAnalyticObj.IPM_MR_Y1_GM__c = fr.GM_of_TO_MR__c;  				//Market Ready Innovation Y1 GM%
                // Populating Y1 gTO BD
                if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
                {  
                    otifAnalyticObj.IPM_Y1_gTO_BD__c = fr.Turnover_Regional__c;		//Innovation Y1 gTO (BD)	
                    otifAnalyticObj.IPM_Y1_GM_BD__c = fr.GM_of_TO_Regional__c;		//Innovation Y1 GM% (BD)
                }                   

            }
        return otifAnalyticObj;    
    }       
      /*********************************************************************************************************************
     * @Description: To copy PLType Gross values of Project from the Innovation Year Table
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
public IPM_Analytics_OTIF__c setGrossValuesInnovationProject(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
             
              // Populating Y1 gTO 
			  if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){			   
              otifAnalytic.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;			//Charter Innovation Y1 gTO	
              otifAnalytic.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;		//Contract Innovation Y1 gTO	
              otifAnalytic.IPM_MD_Y1_gTO__c = fr.Turnover_MD__c; 					//Market Deployment Innovation Y1 gTO								
              otifAnalytic.IPM_MR_Y1_gTO__c = fr.Turnover_MR__c;					//Market Ready Innovation Y1 gTO								
			  }
			   // Populating Y1 GM% 
			  otifAnalytic.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c; 			//Charter Innovation Y1 GM%							
              otifAnalytic.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;			//Charter Innovation Y1 GM%
              otifAnalytic.IPM_MD_Y1_GM__c = fr.GM_of_TO_MD__c;						//Market Deployment Innovation Y1 GM%								
              otifAnalytic.IPM_MR_Y1_GM__c = fr.GM_of_TO_MR__c;  					//Market Ready Innovation Y1 GM%								
			  }
              // Populating Y1 gTO BD   
               if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    otifAnalytic.IPM_Y1_gTO_BD__c = fr.Turnover_Local__c; //Innovation Y1 gTO (BD)								
                    otifAnalytic.IPM_Y1_GM_BD__c = fr.GM_of_TO_Local__c;  //Innovation Y1 GM% (BD)	
               } else {
                    otifAnalytic.IPM_Y1_gTO_BD__c = fr.Turnover_Regional__c; //Innovation Y1 gTO (BD)
                    otifAnalytic.IPM_Y1_GM_BD__c = fr.GM_of_TO_Regional__c; //Innovation Y1 GM% (BD)	
               }
        return otifAnalytic;    
    }   
 /*********************************************************************************************************************
     * @Description: To copy PLType Incremental values of Projects from the Innovation Year Table
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
	   public IPM_Analytics_OTIF__c setIncrementalValuesInnovationProject(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic, IPM_Project__c p){
    	
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
        {
          // Populating Y1 iTO 
          
          if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){ 
          otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;			//Charter Innovation Y1 iTO	
          otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;			//Contract Innovation Y1 iTO	
          otifAnalyticObj.IPM_MD_Y1_iTO__c = fr.Turnover_MD__c;						//Market Deployment Innovation Y1 iTO	
          otifAnalyticObj.IPM_MR_Y1_iTO__c = fr.Turnover_MR__c;						//Market Ready Innovation Y1 iTO	
          }
          // Populating Y1 iTO  BD
           if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL|| p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
           
                otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Global__c;			//Innovation Y1 iTO (BD)
           } else if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Local__c;			//Innovation Y1 iTO (BD)
           } else {
                otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Regional__c;			//Innovation Y1 iTO (BD)
           }
                       
        }
        return otifAnalyticObj;
    }  
    
    
    
     /*********************************************************************************************************************
     * @Description: Method to get records for Non Key Financials
     * @param1: IPM_Financial_Year__c nonKeyFinancial
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c project  
     * @param4:	IPM_Project_Rollout__c projectRollout   
     * @return: IPM_Analytics_OTIF__c parentAnalytic analytic Record
     *********************************************************************************************************************/ 
     // Method to get records for Non Key Financials
    public IPM_Analytics_OTIF__c addNonKeyFinancial(IPM_Analytics_OTIF__c parentAnalytic, IPM_Financial__c nonKeyFinancial, IPM_Project__c project, IPM_Project_Rollout__c projectRollout){
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
    	nonKeyAnalytic = project!=null?processFinancialDetails(projFinYrmap,nonKeyAnalytic,project):setRolloutFinancialdetails(nonKeyAnalytic, nonKeyFinancial.Financial_External_ID__c, projectRollout);
   		return nonKeyAnalytic; 
    } 
    
   
     /*********************************************************************************************************************
     * @Description: Method for setting Incremental financial year values for nonkey financials of rollout/Phanton
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
   
        public IPM_Analytics_OTIF__c setIncrementalValuesNonkeyRollout(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic,  IPM_Project_Rollout__c pr){
    	
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
        
       	if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
      	 // Populating Y1 iTO  
          otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;			//Charter Innovation Y1 iTO	
          otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;			//Contract Innovation Y1 iTO	
          otifAnalyticObj.IPM_MD_Y1_iTO__c = fr.Turnover_MD__c;						//Market Deployment Innovation Y1 iTO	
          otifAnalyticObj.IPM_MR_Y1_iTO__c = fr.Turnover_MR__c;						//Market Ready Innovation Y1 iTO	
       	}
         // Populating Y1 iTO BD                   
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
         {                       
           otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Regional__c;		//Innovation Y1 iTO (BD)
         }
              
         }else if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
        	
         // Populating Y3 iTO  
         if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
          otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
          otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
          otifAnalyticObj.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;
          otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
         }
         
          
         // Populating Y3 iTO BD                   
            if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental))
            {                       
               otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
            }
             
        }
        return otifAnalyticObj;
    } 
    
     /*********************************************************************************************************************
     * @Description: Method for setting Gross financial year values for nonkey financials of rollout/Phanton
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/
     public IPM_Analytics_OTIF__c setGrossValuesNonkeyRollout(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic,  IPM_Project_Rollout__c pr){
    	
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
           
        if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
           	   
         // Populating Y1 gTO  
              otifAnalyticObj.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;		//Charter Innovation Y1 gTO 
              otifAnalyticObj.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;		//Contract Innovation Y1 gTO 
              otifAnalyticObj.IPM_MD_Y1_gTO__c = fr.Turnover_MD__c;					//Market Deployment Innovation Y1 gTO 
              otifAnalyticObj.IPM_MR_Y1_gTO__c = fr.Turnover_MR__c;					//Market Ready Innovation Y1 gTO
           }
         // Populating Y1 GM  
           otifAnalyticObj.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c;		//Charter Innovation Y1 GM%	
           otifAnalyticObj.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;		//Contract Innovation Y1 GM%	
           otifAnalyticObj.IPM_MD_Y1_GM__c = fr.GM_of_TO_MD__c;					//Market Deployment Innovation Y1 GM%
           otifAnalyticObj.IPM_MR_Y1_GM__c = fr.GM_of_TO_MR__c;  				//Market Ready Innovation Y1 GM%
              
        // Populating Y1 gTO BD
           if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
              {  
                otifAnalyticObj.IPM_Y1_gTO_BD__c = fr.Turnover_Regional__c;		//Innovation Y1 gTO (BD)	
                otifAnalyticObj.IPM_Y1_GM_BD__c = fr.GM_of_TO_Regional__c;		//Innovation Y1 GM% (BD)
              }        
       }else if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
        	
       // Populating Y3 gTO 
	       if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
	          otifAnalyticObj.IPM_Charter_Y3_gTO__c = fr.Turnover_Charter__c;	// Charter Calender Y3 gTo
              otifAnalyticObj.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c; //Contract Calender Y1 gTO 
              otifAnalyticObj.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;				//Market Deployment Calender Y1 gTO
              otifAnalyticObj.IPM_MR_Y3_gTO__c = fr.Turnover_MR__c;
	         } 
              
       // Populating Y3 GM      
              otifAnalyticObj.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
              otifAnalyticObj.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
              otifAnalyticObj.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
              otifAnalyticObj.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;  
              
       // Populating Y3 gTO BD
           if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) &&  fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross))
            {  
              otifAnalyticObj.IPM_Y3_gTO_BD__c = fr.Turnover_Regional__c;
              otifAnalyticObj.Y3_GM_BD__c = fr.GM_of_TO_Regional__c;
            }     
        }
        return otifAnalyticObj;
    } 
    /*********************************************************************************************************************
     * @Description: Method for setting Incremental financial year values for nonkey financials of Project
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
    public IPM_Analytics_OTIF__c setGrossValuesNonkeyProject(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic,  IPM_Project__c p){
    	
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
              // Populating Y1 gTO 
			    if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
			   	  otifAnalytic.IPM_Charter_Y1_gTO__c = fr.Turnover_Charter__c;			//Charter Innovation Y1 gTO	
	              otifAnalytic.IPM_Contract_Y1_gTO__c = fr.Turnover_Contract__c;		//Contract Innovation Y1 gTO	
	              otifAnalytic.IPM_MD_Y1_gTO__c = fr.Turnover_MD__c; 					//Market Deployment Innovation Y1 gTO								
	              otifAnalytic.IPM_MR_Y1_gTO__c = fr.Turnover_MR__c;					//Market Ready Innovation Y1 gTO	
				 }
			  // Populating Y1 GM% 							
              otifAnalytic.IPM_Charter_Y1_GM__c = fr.GM_of_TO_Charter__c; 			//Charter Innovation Y1 GM%							
              otifAnalytic.IPM_Contract_Y1_GM__c = fr.GM_of_TO_Contract__c;			//Charter Innovation Y1 GM%
              otifAnalytic.IPM_MD_Y1_GM__c = fr.GM_of_TO_MD__c;						//Market Deployment Innovation Y1 GM%								
              otifAnalytic.IPM_MR_Y1_GM__c = fr.GM_of_TO_MR__c;  					//Market Ready Innovation Y1 GM%								
              
              // Populating Y1 gTO BD   
               if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    otifAnalytic.IPM_Y1_gTO_BD__c = fr.Turnover_Local__c; //Innovation Y1 gTO (BD)								
                    otifAnalytic.IPM_Y1_GM_BD__c = fr.GM_of_TO_Local__c;  //Innovation Y1 GM% (BD)	
               } else {
                    otifAnalytic.IPM_Y1_gTO_BD__c = fr.Turnover_Regional__c; //Innovation Y1 gTO (BD)
                    otifAnalytic.IPM_Y1_GM_BD__c = fr.GM_of_TO_Regional__c; //Innovation Y1 GM% (BD)	
               }        
        }else if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Gross)){
        	  // Populating Y3 gTO 
        	 if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
        	  otifAnalytic.IPM_Charter_Y3_gTO__c = fr.Turnover_Charter__c;
              otifAnalytic.IPM_Contract_Y3_gTO__c = fr.Turnover_Contract__c;
              otifAnalytic.IPM_MD_Y3_gTO__c = fr.Turnover_MD__c;
              otifAnalytic.IPM_MR_Y3_gTO__c = fr.Turnover_MR__c;
        	  } 
              
              // Populating Y3 GM% 
              otifAnalytic.IPM_Charter_Y3_GM__c = fr.GM_of_TO_Charter__c;
              otifAnalytic.IPM_Contract_Y3_GM__c = fr.GM_of_TO_Contract__c;
              otifAnalytic.IPM_MD_Y3_GM__c = fr.GM_of_TO_MD__c;
              otifAnalytic.IPM_MR_Y3_GM__c = fr.GM_of_TO_MR__c;  
              
              // Populating Y3 gTO BD   
               if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                    otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Local__c;
                    otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Local__c;
               } else {
                    otifAnalytic.IPM_Y3_gTO_BD__c = fr.Turnover_Regional__c;
                    otifAnalytic.Y3_GM_BD__c = fr.GM_of_TO_Regional__c;
               } 
        }
        return otifAnalyticObj;
    }
    /*********************************************************************************************************************
     * @Description: Method for setting Gross financial year values for nonkey financials of Project
     * @param1: IPM_Financial_Year__c fr
     * @param2: IPM_Analytics_OTIF__c otifAnalytic
     * @param3: IPM_Project__c p     
     * @return: IPM_Analytics_OTIF__c OTIF analytic Record
     *********************************************************************************************************************/ 
       public IPM_Analytics_OTIF__c setIncrementalValuesNonkeyProject(IPM_Financial_Year__c fr,IPM_Analytics_OTIF__c otifAnalytic,  IPM_Project__c p){
    	
    	IPM_Analytics_OTIF__c otifAnalyticObj = otifAnalytic;
        if(fr.Year__c == IPM_Utils.n1 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Innovation) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
          
          if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
          // Populating Y1 iTO  
	          otifAnalyticObj.IPM_Charter_Y1_iTO__c = fr.Turnover_Charter__c;			//Charter Innovation Y1 iTO	
	          otifAnalyticObj.IPM_Contract_Y1_iTO__c = fr.Turnover_Contract__c;			//Contract Innovation Y1 iTO	
	          otifAnalyticObj.IPM_MD_Y1_iTO__c = fr.Turnover_MD__c;						//Market Deployment Innovation Y1 iTO	
	          otifAnalyticObj.IPM_MR_Y1_iTO__c = fr.Turnover_MR__c;						//Market Ready Innovation Y1 iTO	
          }
          // Populating Y1 iTO  BD
          if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL|| p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
           	  otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Global__c;			//Innovation Y1 iTO (BD)
           } else if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
              otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Local__c;			//Innovation Y1 iTO (BD)
           } else {
              otifAnalyticObj.IPM_Y1_iTO_BD__c = fr.Turnover_Regional__c;			//Innovation Y1 iTO (BD)
           }
                        
        }else if(fr.Year__c == IPM_Utils.n3 && String.isNotBlank(fr.Year_Type__c) && fr.Year_Type__c.equalsignorecase(IPM_Utils.Calendar) && String.isNotBlank(fr.PL_Type__c) && fr.Financial_External_ID__c.endswith(IPM_ConstantUtils.FINANCIAL_NONKEY) && fr.PL_Type__c.equalsignorecase(IPM_Utils.Incremental)){
        // Populating Y3 iTO
        if(fr.Charter_Approved__c == true || fr.Contract_Approved__c == true || fr.MD_Approved__c == true || fr.MR_Approved__c == true){
          otifAnalyticObj.IPM_Charter_Y3_iTO__c = fr.Turnover_Charter__c;
          otifAnalyticObj.IPM_Contract_Y3_iTO__c = fr.Turnover_Contract__c;
          otifAnalyticObj.IPM_MD_Y3_iTO__c = fr.Turnover_MD__c;
          otifAnalyticObj.IPM_MR_Y3_iTO__c = fr.Turnover_MR__c;
        }  
         
          
          // Populating Y3 iTO  BD
           if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && (p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL|| p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL)){
           
                otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Global__c;
           } else if(p.IPMProject_Span__c == IPM_ConstantUtils.Local &&  p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_OPERATIONAL){
                otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Local__c;
           } else if(p.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal && p.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && p.IPM_Phase__c != IPM_ConstantUtils.PHASE_IDEAS){ 
           		// Defect 3701 fix
           		otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
           }else {
                otifAnalyticObj.IPM_Y3_iTO_BD__c = fr.Turnover_Regional__c;
           }
        }
        return otifAnalyticObj;
    } 
                    
}