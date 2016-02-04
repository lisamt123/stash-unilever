/*******************************************************************************************************
* @author:Cognizant
* @date:4/02/2015
* @description:insert or update eco design records and used in gate document section(Research and Development)
*/ 
public with sharing class IPM_EcoDesignSection {
    /*******************************************************************************************************
    * @description:checking whether current logged in user has permission to insert or update eco design 
    *               records
    */
    public boolean isEditable{get;set;}
    /*******************************************************************************************************
    * @description:hold current project id from url parameter
    */
    public String projId{get;set;}
    /*******************************************************************************************************
    * @description:hold section id to insert or update or display eco design record
    */
    public Id ProdocSecId{get;set;}
    public List<IPM_Country__c> countriesList {get; set;} //Contains All Header Countries
    public final IPM_Project__c project;
    public List<CountryAssessmentWrap> countryAssessmentWrapListEICountries {get;set;}
    public List<CountryAssessmentWrap> countryAssessmentWrapListNonEICountries {get;set;}
    public final Map<String,List<IPM_Assessment__c>> countryAssessmentMap ;
    public final Map<String, IPM_Country__c> countryMap ;
	public final Set<String> nonEICountryWithIdeasPhase ;
    public final IPM_Project_Type__c projectType ;
    public integer noOfEICountries {get;set;}
    public integer noOfNonEICountries {get;set;}
    public boolean noRolloutSubmittedYet {get;set;}
    public boolean firstSyncToEcoDesign {get;set;}
    public static final String GKM1 = 'GKM1';
    public static final String GKM2 = 'GKM2';
    public static final String GKM4 = 'GKM4';
    public static final String ROLLOUT = 'Rollout';
    public Id ProjDocumentSecId;
    public String projDocName;
    public IPM_Project_Document_Section__c projDocSec;
    public String projPhaseForCurrentDoc = '';
    /*******************************************************************************************************
    * @description:initialise variables and get eco design data based on project document section id
    * @param:
    * @param:
    * @return:null
    */ 
    public IPM_EcoDesignSection() {
        projId=Apexpages.currentpage().getparameters().get('Id');
        ProjDocumentSecId=Apexpages.currentpage().getparameters().get('projDocSecId');
        projDocName = Apexpages.currentpage().getparameters().get('printDoc');
		if(projDocName == null && ProjDocumentSecId != null){
        	projDocSec = [Select id,IPM_Gate_Document__c from IPM_Project_Document_Section__c WHERE Id =:ProjDocumentSecId Limit 1][0];
        	projDocName = projDocSec.IPM_Gate_Document__c;
        }
        if(projDocName != null){
        	if(IPM_ConstantUtils.CHARTER_GATE.equalsIgnoreCase(projDocName)){
	        	projPhaseForCurrentDoc = IPM_ConstantUtils.PHASE_IDEAS;
	        }
	        else if(IPM_ConstantUtils.CONTRACT_GATE.equalsIgnoreCase(projDocName)){
	        	projPhaseForCurrentDoc = IPM_ConstantUtils.PHASE_FEASIBILITY;
	        }
	        else if(IPM_ConstantUtils.MARKET_READY_GATE.equalsIgnoreCase(projDocName)){
	        	projPhaseForCurrentDoc = IPM_ConstantUtils.PHASE_CAPABILITY;
	        }
	        else if(IPM_ConstantUtils.MARKET_DEPLOYMENT_GATE.equalsIgnoreCase(projDocName)){
	        	projPhaseForCurrentDoc = IPM_ConstantUtils.PHASE_MARKET_READY;
	        }
        }

        countryAssessmentMap = new Map<String,List<IPM_Assessment__c>>();
        countryMap = new Map<String, IPM_Country__c>();
		nonEICountryWithIdeasPhase = new Set<String>();
        noOfEICountries = 0;
        noOfNonEICountries = 0;
        Boolean hasLeadSKU = false;
        noRolloutSubmittedYet = false;
        firstSyncToEcoDesign = false;
        if(String.isNotBlank(projId)) {
            project = [Select id, IPM_Project_Type__c,IPM_GateKeepingModel__c,First_Sync_To_EcoDesign__c,IPM_GateKeeping_Model__c,IPMProject_Span__c,IPM_Phase__c,Success_Timestamp_EcoDesign__c,IPM_CompanyCardText__c  From IPM_Project__c Where id =:projId Limit 1];
            countriesList = [Select IPM_Project__c, Country_Name__c, IS_EI_Country__c,CreatedDate,
                           IPM_Regional_Proj_Association_Timestamp__c,IPM_Local_Project_Association_Timestamp__c
                           From IPM_Country__c 
                           Where (IPM_Project__c=:projId OR IPM_Local_Project__c =:projId 
                                           OR IPM_Regional_Project__c =:projId) AND isActive__c = true Order by IS_EI_Country__c desc,
                                           Country_Name__c asc LIMIT 10000];     
        }

		if(projPhaseForCurrentDoc.equalsIgnorecase(IPM_ConstantUtils.BLANK)){
			projPhaseForCurrentDoc = project.IPM_Phase__c;
		}
        projectType = IPM_Utils.retrieveProjectType(project);
        if(countriesList.isEmpty()) {
            noRolloutSubmittedYet = true;
        }
        for(IPM_Country__c con : countriesList){
            countryMap.put(con.Country_Name__c,con);
            countryAssessmentMap.put(con.Country_Name__c, new List<IPM_Assessment__c>()) ;
        }
        if(!countriesList.isEmpty()) { 
            countryAssessmentWrapListEICountries = new List<CountryAssessmentWrap>();   
            countryAssessmentWrapListNonEICountries = new List<CountryAssessmentWrap>();    
            //GKM 1 - Consolidated view of Regional Rollout Environment Impact Assessments in Global Original Project   
            if((project.IPM_Phase__c == IPM_ConstantUtils.FEASIBILITY_PHASE || project.IPM_Phase__c == IPM_ConstantUtils.PHASE_CAPABILITY) && project.IPM_GateKeepingModel__c == GKM1){
            	for(IPM_Assessment__c assessmentEle : [Select IPM_SKU_Type__c, IPM_New_SKU__c, IPM_Assessment_Water_PCU__c, IPM_Assessment_Waste_PCU__c, IPM_New_SKU_Sourcing__c, 
	                                                    IPM_Assessment_GHG_PCU__c, IPM_Assessment_Water_PCU_Percentage__c, IPM_Assessment_Waste_PCU_Percentage__c,  
	                                                    IPM_Assessment_GHG_PCU_Percentage__c, IPM_Global_Category_Average_View_Water__c, IPM_Global_Category_Average_View_Waste__c, 
	                                                    IPM_Sustainable_Sourcing__c, IPM_Global_Category_Average_View_GHG__c, IPM_Country__r.Country_Name__c, 
	                                                    IPM_Country__c, IPM_Comparison_SKU__c, IPM_Comparison_Rep_GTU_Water_PCU__c, IPM_Comparison_SKU_Waste__c, 
	                                                    IPM_Comparison_SKU_Sourcing__c, IPM_Comparison_Rep_GTU_GHG_PCU__c,IPM_Comparison_Rep_GTU_Waste_PCU__c,IPM_Country__r.IS_EI_Country__c,
	                                                    IPM_Is_Lead_Assessment__c ,IPM_Country_Category_Avg_Waste_PCU__c,IPM_Country_Category_Avg_Water_PCU__c,
	                                                    IPM_Country_Category_Avg_GHG_PCU__c,Project_Phase__c,IPM_Is_Category_Avg_Based__c,IPM_SKU_Name__c,
	                                                    IPM_Comparison_Rep_GTU_Name__c,IPM_Project__r.IPMProject_Span__c From IPM_Assessment__c 
	                                                    Where IPM_Country__c IN:countriesList and Project_Phase__c =:projPhaseForCurrentDoc 
	                                                    Order by IPM_SKU_Type__c asc LIMIT 50000]) {
	                if(assessmentEle.IPM_Project__r.IPMProject_Span__c != IPM_ConstantUtils.PROJECT_SPAN_LOCAL) {
	                	countryAssessmentMap.get(assessmentEle.IPM_Country__r.Country_Name__c).add(assessmentEle);
	                }       	
	            }
            }
            else {
            for(IPM_Assessment__c assessmentEle : [Select IPM_SKU_Type__c, IPM_New_SKU__c, IPM_Assessment_Water_PCU__c, IPM_Assessment_Waste_PCU__c, IPM_New_SKU_Sourcing__c, 
                                                    IPM_Assessment_GHG_PCU__c, IPM_Assessment_Water_PCU_Percentage__c, IPM_Assessment_Waste_PCU_Percentage__c,  
                                                    IPM_Assessment_GHG_PCU_Percentage__c, IPM_Global_Category_Average_View_Water__c, IPM_Global_Category_Average_View_Waste__c, 
                                                    IPM_Sustainable_Sourcing__c, IPM_Global_Category_Average_View_GHG__c, IPM_Country__r.Country_Name__c, 
                                                    IPM_Country__c, IPM_Comparison_SKU__c, IPM_Comparison_Rep_GTU_Water_PCU__c, IPM_Comparison_SKU_Waste__c, 
                                                    IPM_Comparison_SKU_Sourcing__c, IPM_Comparison_Rep_GTU_GHG_PCU__c,IPM_Comparison_Rep_GTU_Waste_PCU__c,IPM_Country__r.IS_EI_Country__c,
                                                    IPM_Is_Lead_Assessment__c ,IPM_Country_Category_Avg_Waste_PCU__c,IPM_Country_Category_Avg_Water_PCU__c,
                                                    IPM_Country_Category_Avg_GHG_PCU__c,Project_Phase__c,IPM_Is_Category_Avg_Based__c,IPM_SKU_Name__c,
                                                    IPM_Comparison_Rep_GTU_Name__c From IPM_Assessment__c 
                                                    Where IPM_Country__c IN:countriesList and Project_Phase__c =:projPhaseForCurrentDoc 
                                                    And IPM_Project__c =:projId Order by IPM_SKU_Type__c asc LIMIT 50000]) {
                countryAssessmentMap.get(assessmentEle.IPM_Country__r.Country_Name__c).add(assessmentEle);                                          
            }
            if(project.IPM_Phase__c == IPM_ConstantUtils.FEASIBILITY_PHASE && project.IPM_GateKeepingModel__c == GKM4){
            	for(IPM_Assessment__c assessmentEle : [Select Id,IPM_SKU_Type__c,IPM_Country__r.Country_Name__c From IPM_Assessment__c 
                                                       Where IPM_Country__c IN:countriesList and Project_Phase__c =:IPM_ConstantUtils.PHASE_IDEAS Order by IPM_SKU_Type__c asc LIMIT 50000]) {
				    nonEICountryWithIdeasPhase.add(assessmentEle.IPM_Country__r.Country_Name__c);
		            }
	            }
            }
        }
        if(projectType != null) { 
            for(String countryName : countryAssessmentMap.keySet()) {
                hasLeadSKU = false;
                if(project.Success_Timestamp_EcoDesign__c != null && 
                    (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_GLOBAL && 
                    countryMap.get(countryName).CreatedDate < project.Success_Timestamp_EcoDesign__c) ||
                    (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_REGIONAL && 
                    countryMap.get(countryName).IPM_Regional_Proj_Association_Timestamp__c < project.Success_Timestamp_EcoDesign__c) ||
                    (project.IPMProject_Span__c == IPM_ConstantUtils.PROJECT_SPAN_LOCAL && 
                    countryMap.get(countryName).IPM_Local_Project_Association_Timestamp__c < project.Success_Timestamp_EcoDesign__c)
                    ) {
                    if(countryMap.get(countryName).IS_EI_Country__c) { 
                        if(countryAssessmentMap.get(countryName).isEmpty()) {
                            countryAssessmentWrapListEICountries.add(new CountryAssessmentWrap(countryName,countryAssessmentMap.get(countryName),true,++noOfEICountries,hasLeadSKU));
                        }
                        else {
                            for(IPM_Assessment__c assmnt :countryAssessmentMap.get(countryName)) {
                                hasLeadSKU = assmnt.IPM_Is_Lead_Assessment__c;
                            }
                            countryAssessmentWrapListEICountries.add(new CountryAssessmentWrap(countryName,countryAssessmentMap.get(countryName),false,++noOfEICountries,hasLeadSKU));
                        }
                    }   
                    else if(!countryAssessmentMap.get(countryName).isEmpty()) {
                        for(IPM_Assessment__c assmnt :countryAssessmentMap.get(countryName)) {
                            hasLeadSKU = assmnt.IPM_Is_Lead_Assessment__c;
                        }
                        countryAssessmentWrapListNonEICountries.add(new CountryAssessmentWrap(countryName,countryAssessmentMap.get(countryName),false,++noOfNonEICountries,hasLeadSKU));
                    }
					else if(countryAssessmentMap.get(countryName).isEmpty() && project.IPM_Phase__c == IPM_ConstantUtils.FEASIBILITY_PHASE && !nonEICountryWithIdeasPhase.isEmpty()) {
						if( nonEICountryWithIdeasPhase.contains(countryName))
						countryAssessmentWrapListNonEICountries.add(new CountryAssessmentWrap(countryName,countryAssessmentMap.get(countryName),true,++noOfNonEICountries,hasLeadSKU));
                    }
                } 
            }
        }
        checkTakeMeEcoDesginButtonVisible();
    }
    
    public void checkTakeMeEcoDesginButtonVisible() {
        if(project.First_Sync_To_EcoDesign__c && project.IPM_Project_Type__c == IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL 
            && project.IPMProject_Span__c == IPM_ConstantUtils.SpanGlobal  && project.IPM_Phase__c == IPM_ConstantUtils.PHASE_IDEAS &&  
            (project.IPM_GateKeepingModel__c == GKM1 || project.IPM_GateKeepingModel__c == GKM2)) {
                firstSyncToEcoDesign = true;    
        }
        else if(project.IPM_Project_Type__c == ROLLOUT) {
			firstSyncToEcoDesign = true;
	    }
        else if(project.First_Sync_To_EcoDesign__c && project.IPM_GateKeepingModel__c == GKM4) {
                firstSyncToEcoDesign = true;    
        }
    }
    public class CountryAssessmentWrap {
        public String country {get;set;}
        public List<IPM_Assessment__c> assessmentList{get;set;}
        public boolean eiWithNoAssessment {get;set;}
        public Integer counter { get; set; }
        public boolean hasLeadSKU {get;set;}
        public CountryAssessmentWrap(String con, List<IPM_Assessment__c> assessmentLst,boolean noAssessment, Integer countr, Boolean LeadSKU) {
            hasLeadSKU = LeadSKU;
            counter = countr;
            country = con;
            assessmentList = assessmentLst;
            eiWithNoAssessment = noAssessment; 
        }
    }
}