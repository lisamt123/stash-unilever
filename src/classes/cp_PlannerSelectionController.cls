/**
*
* Author:		Carmine Barbuto
* Date:			07/05/2014
* Description:	Class for Planner selection.
*
*
**/
public with sharing class cp_PlannerSelectionController {
	
	// PLANNER LISTS
	public List<PlannerWrapper>  categoryPlanner 	{get; set;}	
	public List<PlannerWrapper>  functionPlanner 	{get; set;}
	public List<PlannerWrapper>  expertisePlanner 	{get; set;}
	public List<PlannerWrapper>  clusterPlanner 	{get; set;}
	public List<PlannerWrapper>  mcoPlanner 		{get; set;}
	public List<PlannerWrapper>  countryPlanner 	{get; set;}

	// PLANNER LOCATION COUNT
	public Integer          	cTotal              {get; set;}
	
	// MAIN EVENT
	public cp_Event__c 			plannerEvent		{get; set;}

	// BOOLEANS
	public Boolean 				recordLocked 		{get; set;}
	public Boolean 				canEdit 			{get; set;}
	public Boolean 				isEverywhere 		{get; set;}
	public Boolean          	showWarning         {get; set;}


	// *************** MAIN LOGIC *************** //
	
	// CONSTRUCTOR
	public cp_PlannerSelectionController(Apexpages.StandardController std) {
		// Initialise...
		plannerEvent 		= [SELECT Id, HostPlanner__c, RecordTypeId FROM cp_Event__c WHERE Id =:std.getId()];
		categoryPlanner 	= new List<PlannerWrapper>();
		functionPlanner		= new List<PlannerWrapper>();
		expertisePlanner 	= new List<PlannerWrapper>();
		clusterPlanner 		= new List<PlannerWrapper>();
		mcoPlanner 			= new List<PlannerWrapper>();
		countryPlanner 		= new List<PlannerWrapper>();
		
		// Get existing data
		Set<Id> plannerIds  = new Set<Id>();
		for (cp_PlannerLocation__c curr : [SELECT Planner__c, Event__c FROM cp_PlannerLocation__c WHERE Event__c =:plannerEvent.Id]) {
			plannerIds.add(curr.Planner__c);
		}

		// Build the selection list from Planner object with pre-selected values
		for (cp_Planner__c curr : [SELECT Name, SubType__c FROM cp_Planner__c ORDER by Name LIMIT 7000]) {
			PlannerWrapper pw = new PlannerWrapper(curr.SubType__c, curr.Name, curr.Id, plannerIds.contains(curr.Id)); 
			// Add to relevant list based on Sub Type
			if (curr.SubType__c == cp_PlannerUtility.EXPERTISE)
				expertisePlanner.add(pw);
			else if (curr.SubType__c == cp_PlannerUtility.FUNCTION)
				functionPlanner.add(pw);
			else if (curr.SubType__c == cp_PlannerUtility.CATEGORY)
				categoryPlanner.add(pw);
			else if (curr.SubType__c == cp_PlannerUtility.CLUSTER)
				clusterPlanner.add(pw);
			else if (curr.SubType__c == cp_PlannerUtility.MCO)
				mcoPlanner.add(pw);
			else if (curr.SubType__c == cp_PlannerUtility.COUNTRY)
				countryPlanner.add(pw);				 

		}

		recordLocked 	= cp_RecordTypeUtil.getRecordTypeId('cp_Event__c','Event Pending') == plannerEvent.RecordTypeId ? true : false;
		canEdit 		= cp_PlannerUtility.canEditEvent(plannerEvent.HostPlanner__c, UserInfo.getUserId());
		checkEventLocations();

	}

	// CHECK IF PLANNER LOCATION IS EMPTY
    public void checkEventLocations() {
        cTotal 		= [SELECT Id FROM cp_PlannerLocation__c WHERE Event__c =: plannerEvent.Id].size();
        showWarning = cTotal == 0;
    }

    // MERGE INTO ONE PLANNER LIST
    private List<PlannerWrapper> getPlannerList() {
    	List<PlannerWrapper> allPlanners = new List<PlannerWrapper>();
		allPlanners.addAll(categoryPlanner);
		allPlanners.addAll(functionPlanner);
		allPlanners.addAll(expertisePlanner);
		allPlanners.addAll(clusterPlanner);
		allPlanners.addAll(mcoPlanner);
		allPlanners.addAll(countryPlanner);

		return allPlanners;
    }

	// SAVE ALL PLANNER LOCATIONS
	public void saveAll() {
		List<cp_PlannerLocation__c> toIns 			= new List<cp_PlannerLocation__c>();
		List<cp_PlannerLocation__c> toDel 			= new List<cp_PlannerLocation__c>();
		Set<Id> 					selPlannerIds 	= new Set<Id>();
		Set<Id>						extPlannerIds 	= new Set<Id>();
		List<PlannerWrapper> 		allPlanners 	= getPlannerList();

		// Get existing planners
		List<cp_PlannerLocation__c> ext = [SELECT Planner__c FROM cp_PlannerLocation__c WHERE Event__c = :plannerEvent.Id];
		for (cp_PlannerLocation__c curr : ext)
			extPlannerIds.add(curr.Planner__c);

		// Create planner locations (if selected and not existing)
		for (PlannerWrapper curr : allPlanners) {
            if (curr.isSelected) {
            	if (!extPlannerIds.contains(curr.recordId)) {
                	cp_PlannerLocation__c temp 	= new cp_PlannerLocation__c();
                	temp.Planner__c 			= curr.recordId;
                	temp.Event__c 				= plannerEvent.Id;
                	toIns.add(temp);
            	}
            	selPlannerIds.add(curr.recordId);                
            }      
        }

        // Save planner locations
        Savepoint sp = Database.setSavepoint();

        try {

        	// Remove planners (if existing and un-selected)
        	for (cp_PlannerLocation__c curr : ext) {
        		if (!selPlannerIds.contains(curr.Planner__c))
        			toDel.add(curr);
        	}
        	delete toDel;

        	// Insert new selection
        	insert toIns;

        	// Update Planner Event
        	update plannerEvent;

        	ApexPages.Message pageMessageAfterDMLOperation = new ApexPages.Message(ApexPages.Severity.CONFIRM, 'Saved Successfully');
            ApexPages.addMessage(pageMessageAfterDMLOperation);

        } catch (DmlException dml) {
            Database.rollback(sp);
            ApexPages.Message pageMessageAfterDMLOperation = new ApexPages.Message(ApexPages.Severity.Error, String.valueOf(dml));
            ApexPages.addMessage(pageMessageAfterDMLOperation);
        }
       
	}

	// *************** WRAPPER *************** //
	
	public class PlannerWrapper {
		public String 	type 		{get; set;}
		public String 	pvalue 		{get; set;}
		public String 	recordId 	{get; set;}
		public Boolean 	isSelected 	{get; set;}	

		public PlannerWrapper (String t, String v, String r, Boolean s) {
			this.type 		= t;
			this.pvalue 	= v;
			this.recordId 	= r;
			this.isSelected = s;
		}
	}

	// *************** JSON Methods *************** //

	// POPULATE LEFT SIDE
	public List<PlannerWrapper> getAllFunctions() {
		return functionPlanner;
	}
	public List<PlannerWrapper> getAllCategories() {
		return categoryPlanner;
	}
	public List<PlannerWrapper> getAllExpertise() {
		return expertisePlanner;
	}
	public List<PlannerWrapper> getAllClusters() {
		return clusterPlanner;
	}
	public List<PlannerWrapper> getAllMCOs() {
		return mcoPlanner;
	}
	public List<PlannerWrapper> getAllCountries() {
		return countryPlanner;
	}

	// POPULATE RIGHT SIDE
	public String getJsonTypeFunc() {
		return JSON.serialize(functionPlanner);
	}
	public String getJsonTypeCate() {
		return JSON.serialize(categoryPlanner);
	}
	public String getJsonTypeExp() {
		return JSON.serialize(expertisePlanner);
	}
	public String getJsonTypeClu() {
		return JSON.serialize(clusterPlanner);
	}
	public String getJsonTypeMco() {
		return JSON.serialize(mcoPlanner);
	}
	public String getJsonTypeCoun() {
		return JSON.serialize(countryPlanner);
	}

}