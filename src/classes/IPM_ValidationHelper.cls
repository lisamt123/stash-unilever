/*************************************************************************************************************
* @author:Cognizant
* @date: 19/01/2016
* @description: Helper methods used to validate different scenario.
*/
public with sharing class IPM_ValidationHelper {
    
  	private static final String CONSOLIDATED_FINANCIAL_RECORDTYPE = Schema.SObjectType.IPM_Financial__c.getRecordTypeInfosByName().get(IPM_ConstantUtils.CONSOLIDATED_FINANCIAL_RT).getRecordTypeId();
    
    /*
    	This method validates the following and returns projects which meet the validation 
    	1. 14 days before gate submission date is due
    	@param Map of IPM_Project__c to be validated
  		@return  Map of IPM_Projects which meet the validation 
    */
    private static Map<ID,IPM_Project__c> getProjectsOfInvalidMilestones( Map<ID,IPM_Project__c> ipmProjectMap ){
        // milestones need to be retrieved 
        List<String> milestoneNames = new List<String>{IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.CONTRACT_GATE_APPROVAL_MILESTONE,IPM_ConstantUtils.MARKET_READY_GATE_APPROVAL_MILESTONE};
        Map<ID,IPM_Project__c> projMap =  new Map<ID,IPM_Project__c>();
        Date projectMilestoneDate = null;
        IPM_Project__c ipmProj = null;
        // retrieve milestones for the given projects. SOQL is used in 'for' loop so that only 200 records will be processed at a time.        
        for(IPM_Milestone__c milestone: [Select IPM_Project__c, Id,IPM_Name__c,IPM_Active__c, IPM_Due_Date__c from IPM_Milestone__c where IPM_Project__c in : ipmProjectMap.keySet() and IPM_Active__c = true and IPM_Name__c in: milestoneNames limit 50000]) {
        	projectMilestoneDate = null;
        	// if the 'project id' is present in 'projMap' dont process it again
            if( projMap.isEmpty() || !projMap.keySet().contains(milestone.IPM_Project__c) ) {
                ipmProj = ipmProjectMap.get(milestone.IPM_Project__c);
                if(milestone.IPM_Due_Date__c != null && milestone.IPM_Name__c==IPM_ConstantUtils.CHARTER_GATE_APPROVAL_MILESTONE && ipmProj.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS) {
                    projectMilestoneDate = milestone.IPM_Due_Date__c;
                } else if(milestone.IPM_Due_Date__c != null && milestone.IPM_Name__c==IPM_ConstantUtils.CONTRACT_GATE_APPROVAL_MILESTONE && ipmProj.IPM_Phase__c==IPM_ConstantUtils.PHASE_FEASIBILITY) {
                    projectMilestoneDate = milestone.IPM_Due_Date__c;
                } else if(milestone.IPM_Due_Date__c != null && milestone.IPM_Name__c==IPM_ConstantUtils.MARKET_READY_GATE_APPROVAL_MILESTONE && ipmProj.IPM_Phase__c==IPM_ConstantUtils.PHASE_CAPABILITY) {
                    projectMilestoneDate = milestone.IPM_Due_Date__c;
                }
	            // if the milestone is before 14 days add it to map
	            if(projectMilestoneDate!=null && projectMilestoneDate < System.now().addDays(14)) {
	                projMap.put(ipmProj.id,ipmProj);
	            }
        	}
        
        }
        return projMap;
    }
   /*
    	This method validates ideas projects for the following and returns projects which meet the validation 
    	1. TO, iTO, GP and PBO are '0' in financials
    	@param Map of regional/local IPM_Project__c to be validated and Map of validated IPM_Project__c
  		@return  Map of IPM_Projects which meet the validation 
    */
    private static Map<ID,IPM_Project__c> processIdeasFinancials(Map<ID,IPM_Project__c> ideasProjects, Map<ID,IPM_Project__c> invalidProjMap ) {
        // retrieve financials for the given projects. SOQL is used in 'for' loop so that only 200 records will be processed at a time.        
        for(IPM_Financial__c ipmFin: [   Select IPM_Project_Rollout__r.IPM_Project__c,Financial_External_ID__c, 
                                                (   Select 
                                                        Year__c,
                                                        PL_Type__c,
                                                        Profit_Before_Overheads_Global__c,
                                                        Profit_Before_Overheads_Local__c,
                                                        Profit_Before_Overheads_Regional__c,
                                                        Turnover_Global__c,
                                                        Turnover_Local__c,
                                                        Turnover_Regional__c,
                                                        Gross_Profit_Global__c,
                                                        Gross_Profit_Local__c,
                                                        Gross_Profit_Regional__c 
                                                    From IPM_Financial_Years__r )   
                                                From 
                                                	IPM_Financial__c 
                                                where 
                                                	RecordTypeId != :CONSOLIDATED_FINANCIAL_RECORDTYPE and
                                                	isActive__c=true and 
                                                	IPM_Project_Rollout__c in 
                                                    (   Select  
                                                            id 
                                                        From 
                                                            IPM_Project_Rollout__c 
                                                        where 
                                                            IPM_Project__c  in :ideasProjects.keySet() and 
                                                            IPM_Rollout_Span__c=:IPM_ConstantUtils.ROLLOUT_SPAN_REGIONAL ) limit 10000]) {
            // if the 'project id' is present in 'invalidProjMap' dont process financial record again
            if(invalidProjMap.isEmpty() ||  !invalidProjMap.keySet().contains(ipmFin.IPM_Project_Rollout__r.IPM_Project__c)) {
            	IPM_Project__c ipmProj = ideasProjects.get(ipmFin.IPM_Project_Rollout__r.IPM_Project__c);
            	for(IPM_Financial_Year__c finYear:ipmFin.IPM_Financial_Years__r) {
	           		if(validateFinancialData(finYear,ipmProj)) {
	                	// if the financial year has got invalid data it to map
	            		invalidProjMap.put(ipmProj.id, ipmProj);
	                	break;
	              	}
	          	}
            }
        }
        return invalidProjMap;
    }
   /*
    	This method validates global projects for the following and returns projects which meet the validation 
    	1. TO, iTO, GP and PBO are '0' in financials
    	@param Map of global IPM_Project__c to be validated and Map of validated IPM_Project__c
  		@return  Map of IPM_Projects which meet the validation 
    */
	private static Map<ID,IPM_Project__c> processGlobalFinancials(Map<ID,IPM_Project__c> globalProjects, Map<ID,IPM_Project__c> invalidProjMap ) {
       // retrieve financials for the given projects. SOQL is used in 'for' loop so that only 200 records will be processed at a time.        
        for(IPM_Financial__c ipmFin: [   Select Regional_Project__r.IPM_Parent_Project__c,Parent_Project__c ,Financial_External_ID__c, 
                                                (   Select 
                                                        Year__c,
                                                        PL_Type__c,
                                                        Profit_Before_Overheads_Global__c,
                                                        Profit_Before_Overheads_Local__c,
                                                        Profit_Before_Overheads_Regional__c,
                                                        Turnover_Global__c,
                                                        Turnover_Local__c,
                                                        Turnover_Regional__c,
                                                        Gross_Profit_Global__c,
                                                        Gross_Profit_Local__c,
                                                        Gross_Profit_Regional__c 
                                                    From IPM_Financial_Years__r )   
                                                From 
                                                	IPM_Financial__c 
                                                where 
                                                	RecordTypeId != :CONSOLIDATED_FINANCIAL_RECORDTYPE and
                                                	isActive__c=true and 
                                                	IPM_Key_Financial__c!=true and
													Parent_Project__c  in :globalProjects.keySet() limit 10000]) {
            // if the 'project id' is present in 'invalidProjMap' dont process financial record again
            if(invalidProjMap.isEmpty() ||  !invalidProjMap.keySet().contains(ipmFin.Parent_Project__c)) {
            	for(IPM_Financial_Year__c finYear:ipmFin.IPM_Financial_Years__r) {
	           		IPM_Project__c ipmProj = globalProjects.get(ipmFin.Parent_Project__c);
            		if(validateFinancialData(finYear,ipmProj)) {
	                	// if the financial year has got invalid data it to map
	            		invalidProjMap.put(ipmProj.id, ipmProj);
	                	break;
	              	}
	          	}
            }
        }
        return invalidProjMap;
    }
   /*
    	This method validates regional/local projects for the following and returns projects which meet the validation 
    	1. TO, iTO, GP and PBO are '0' in financials
    	@param Map of regional/local IPM_Project__c to be validated and Map of validated IPM_Project__c
  		@return  Map of IPM_Projects which meet the validation 
    */
    private static Map<ID,IPM_Project__c> processRegionalOrLocalFinancials(Map<ID,IPM_Project__c> regionalOrLocalProjects, Map<ID,IPM_Project__c> invalidProjMap ) {
       // retrieve financials for the given projects. SOQL is used in 'for' loop so that only 200 records will be processed at a time.        
        for(IPM_Financial__c ipmFin: [   Select Regional_Project__c,Local_Project__c,Financial_External_ID__c, 
                                                	(Select 
                                                        Year__c,
                                                        PL_Type__c,
                                                        Profit_Before_Overheads_Global__c,
                                                        Profit_Before_Overheads_Local__c,
                                                        Profit_Before_Overheads_Regional__c,
                                                        Turnover_Global__c,
                                                        Turnover_Local__c,
                                                        Turnover_Regional__c,
                                                        Gross_Profit_Global__c,
                                                        Gross_Profit_Local__c,
                                                        Gross_Profit_Regional__c 
                                                    From IPM_Financial_Years__r )   
                                                From 
                                                	IPM_Financial__c 
                                                where 
                                                	RecordTypeId != :CONSOLIDATED_FINANCIAL_RECORDTYPE and
                                                	isActive__c=true and 
                                                	(Regional_Project__c  in :regionalOrLocalProjects.keySet() or Local_Project__c  in :regionalOrLocalProjects.keySet()) limit 10000]) {
            // handle local projects first
            if(ipmFin.Local_Project__c!=null) {
	            // if the 'project id' is present in 'invalidProjMap' dont process financial record again
            	if(invalidProjMap.isEmpty() || !invalidProjMap.keySet().contains(ipmFin.Local_Project__c)) {
	            	for(IPM_Financial_Year__c finYear:ipmFin.IPM_Financial_Years__r) {
		           		IPM_Project__c ipmProj = regionalOrLocalProjects.get(ipmFin.Local_Project__c);
            			if(validateFinancialData(finYear,ipmProj)) {
		                	// if the financial year has got invalid data it to map
	            			invalidProjMap.put(ipmProj.id, ipmProj);
	                		break;
		              	}
		          	}
	            }
            } else if(ipmFin.Regional_Project__c!=null) {
	            // if the 'project id' is present in 'invalidProjMap' dont process financial record again
            	if(invalidProjMap.isEmpty() || !invalidProjMap.keySet().contains(ipmFin.Regional_Project__c)) {
	            	IPM_Project__c ipmProj = regionalOrLocalProjects.get(ipmFin.Regional_Project__c);
            		for(IPM_Financial_Year__c finYear:ipmFin.IPM_Financial_Years__r) {
		           		if(validateFinancialData(finYear,ipmProj)) {
		                	// if the financial year has got invalid data it to map
	            			invalidProjMap.put(ipmProj.id, ipmProj);
	                		break;
		              	}
		          	}
	            }
            }
        }
    	return invalidProjMap;

    }
   /*
    	This method validates the following and returns projects which meet the validation 
    	1. TO, iTO, GP and PBO are '0' in financials
    	@param Map of IPM_Project__c to be validated
  		@return  List of IPM_Projects which meet the validation 
    */
    private static List<IPM_Project__c> getProjectsOfInvalidFinancials( Map<ID,IPM_Project__c> projMap ) {
        Map<ID,IPM_Project__c> invalidProjMap = new Map<ID,IPM_Project__c>();
        Map<ID,IPM_Project__c> ideasProjects = new Map<ID,IPM_Project__c>();
        Map<ID,IPM_Project__c> globalProjects = new Map<ID,IPM_Project__c>();
        Map<ID,IPM_Project__c> regionalOrLocalProjects = new Map<ID,IPM_Project__c>();
        for(IPM_Project__c ipmProj: projMap.values()) {
            // prepare 3 sets of projects based on its phase, type and span
            // association of financial records are different in each case.
            if( ipmProj.IPM_Phase__c==IPM_ConstantUtils.PHASE_IDEAS && ipmProj.IPM_Project_Type__c==IPM_ConstantUtils.PROJECT_TYPE_ORIGINAL && ipmProj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL) {
                // Ideas phase global original projects
                ideasProjects.put(ipmProj.id,ipmProj);
            } else if(ipmProj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_GLOBAL){
            	// non ideas global projects
                globalProjects.put(ipmProj.id,ipmProj);
            } else if(ipmProj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_REGIONAL || ipmProj.IPMProject_Span__c==IPM_ConstantUtils.PROJECT_SPAN_LOCAL){
            	// non ideas regional and local projects
                regionalOrLocalProjects.put(ipmProj.id,ipmProj);
            }
        }
        if(!ideasProjects.isEmpty()) {
        	// Get the projects which meet financial validation
             invalidProjMap = processIdeasFinancials(ideasProjects,invalidProjMap);
        }
        if(!globalProjects.isEmpty()) {
             // Get the projects which meet financial validation
            invalidProjMap = processGlobalFinancials(globalProjects,invalidProjMap);
        }
        if(!regionalOrLocalProjects.isEmpty()) {
             // Get the projects which meet financial validation
            invalidProjMap = processRegionalOrLocalFinancials(regionalOrLocalProjects,invalidProjMap);
        }
        return invalidProjMap.values();
    }
    /*
    	This method validates the passed argument for invalid value 
    	@param Financial year data in Decimal to be validated
  		@return  result  
    */
    
    private static Boolean validateFinYearDataValue( Decimal finYearDataValue ){
        Boolean result = false;
        if(finYearDataValue == null || finYearDataValue == IPM_ConstantUtils.INVALID_VALUE){
    		result = true;
   		}
        return result;
    }
   /*
    	This method validates the following and returns boolean result 
    	1. TO, iTO, GP and PBO are '0' in financials
    	@param IPM_Financial_Year__c and  IPM_Project__c to be validated
  		@return  result which meets the validation 
    */
    private static Boolean validateFinancialData( IPM_Financial_Year__c finYear, IPM_Project__c ipmProject ) {
    	Boolean result = false;
    	if(ipmProject!=null) {
	    	String projSpan = ipmProject.IPMProject_Span__c;
	    	if(	finYear.Year__c != IPM_ConstantUtils.Y0_YEARINDEX && 
	    		( finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_GROSS || finYear.PL_Type__c == IPM_ConstantUtils.PL_TYPE_INCREMENTAL ) &&
	    		( validateFinYearDataValue((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_PROFIT_BEFORE_OVERHEADS + projSpan + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)) ||
	    		  validateFinYearDataValue((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_TURNOVER + projSpan + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX)) ||
	    		  validateFinYearDataValue((Decimal) finYear.get(IPM_ConstantUtils.FIELD_LITERAL_GROSS_PROFIT + projSpan + IPM_ConstantUtils.CUSTOM_FIELD_SUFFIX))
	    		)
	    	  ) {
	    		result = true;
	    	}
    	}
    	return result;
    }
   /*
    	This method validates the following and returns projects which meet the validation 
    	1. 14 days before gate submission date is due
    	2. TO, iTO, GP and PBO are '0' in financials
    	@param List of IPM_Project__c to be validated
  		@return  List of IPM_Projects which meet the validation 
    */
    public static List<IPM_Project__c> validateMilestoneAndFinacialData( List<IPM_Project__c> projList ) {
        List<IPM_Project__c> projHasInvalidFinData = new List<IPM_Project__c>();
        // create a map of projects
        Map<ID,IPM_Project__c> projMap = new Map<ID,IPM_Project__c>(projList);
        // Get the projects which meet submission due date validation (14 days before gate submission date is due)
        Map<ID,IPM_Project__c> projMilestoneProjMap = getProjectsOfInvalidMilestones(projMap);
        if(!projMilestoneProjMap.isEmpty()) {
			// Get the projects which meet financial validation (TO, iTO, GP and PBO are '0' in financials)
			// Here we are passing the projects which didnt meet gate submission due date validation instead of passing all the projects.
			// This is will help reducing heap size during the process
			projHasInvalidFinData = getProjectsOfInvalidFinancials(projMilestoneProjMap);
	    }
       	return  projHasInvalidFinData;
    }

}
