/**
*
* Author:       Carmine Barbuto
* Date:         01/05/2014
* Description:  Set default user planner. Current rule allows only one selection
*				Data model and class have been designed with a possible future
*				many-to-many relationship in mind.
*
**/
public without sharing class cp_DefaultPreferenceController {

	public List<PlannerWrapper> 	clusters 	{get; set;}
	public List<PlannerWrapper> 	mcos 		{get; set;}
	public List<PlannerWrapper> 	countries 	{get; set;}
	public List<PlannerWrapper> 	categories 	{get; set;}
	public List<PlannerWrapper> 	functions 	{get; set;}
	public List<PlannerWrapper> 	expertises 	{get; set;}

	public Boolean 			isMarket 			{get; set;}
	public String 			selectedPlanner		{get; set;}
	public String 			selectedPlannerName {get; set;}

	public cp_PlannerPreference__c 	mainPref	{get; set;}
	Map<String,PlannerWrapper> 		plannerMap 	{get; set;}

	// CONSTRUCTOR
	public cp_DefaultPreferenceController() {
		// Initialise...
		clusters 	= new List<PlannerWrapper>();
		mcos 		= new List<PlannerWrapper>();
		countries 	= new List<PlannerWrapper>();
		categories 	= new List<PlannerWrapper>();
		functions 	= new List<PlannerWrapper>();
		expertises 	= new List<PlannerWrapper>();
		plannerMap 	= new Map<String,PlannerWrapper>();

		// Check profile to hide section for Market users
		String profileName = [SELECT Name FROM Profile WHERE Id =:UserInfo.getProfileId()].Name;
		isMarket = profileName.contains(cp_PlannerUtility.MARKET) ? true : false;

		// Build planner selections
		for (cp_Planner__c curr : [SELECT Name, SubType__c FROM cp_Planner__c ORDER by Name LIMIT 5000]) {
			PlannerWrapper temp = new PlannerWrapper(curr);
			if (curr.SubType__c == cp_PlannerUtility.CLUSTER)
				clusters.add(temp);
			else if (curr.SubType__c == cp_PlannerUtility.MCO)
				mcos.add(temp);
			else if (curr.SubType__c == cp_PlannerUtility.COUNTRY)
				countries.add(temp);	
			else if (curr.SubType__c == cp_PlannerUtility.CATEGORY)
				categories.add(temp);	
			else if (curr.SubType__c == cp_PlannerUtility.FUNCTION)
				functions.add(temp);
			else if (curr.SubType__c == cp_PlannerUtility.EXPERTISE)
				expertises.add(temp);
			plannerMap.put(curr.Id,temp);		
		}

		// Find existing record
		List<cp_PlannerPreference__c> prefs = [SELECT Planner__c, Planner__r.Name FROM cp_PlannerPreference__c WHERE User__c =:UserInfo.getUserId() LIMIT 1];
		if (prefs.isEmpty()) {
			mainPref = new cp_PlannerPreference__c(User__c = UserInfo.getUserId());
		} else {
			mainPref = prefs.get(0);
			plannerMap.get(mainPref.Planner__c).selected = true;
			selectedPlannerName = 'My Planner: ' + mainPref.Planner__r.Name;
		}
	}

	// SELECT DEFAULT PLANNER
	public void selectPlanner() {
		// Blank all values - one to one relationship in current version
		// Remove this section to allow many to many
		for (PlannerWrapper curr : plannerMap.values())
			curr.selected = false;

		// Set selected planner
		plannerMap.get(selectedPlanner).selected = true;
		mainPref.Planner__c = selectedPlanner;
		selectedPlannerName = 'My Planner: ' + plannerMap.get(selectedPlanner).planner.Name;

		// Save selection
		saveSelection();
	}

	// SAVE DEFAULT PLANNER 
	public void saveSelection() {		
		Savepoint sp = Database.setSavepoint();
		try {
			upsert mainPref;
		} catch (DMLException dml) {
			Database.rollback(sp);
			Apexpages.addMessages(dml);
		}
	}

	// BACK TO PLANNER REDIRECT
    public Pagereference backToPlanner() {
    	return Page.cp_Planner;
    }


	// WRAPPER CLASS FOR SELECTION
	public class PlannerWrapper {
		public cp_Planner__c 	planner 	{get; set;}
		public Boolean 			selected 	{get; set;}

		public PlannerWrapper(cp_Planner__c p) {
			this.planner 	= p;
			this.selected 	= false;
		}
	}

}