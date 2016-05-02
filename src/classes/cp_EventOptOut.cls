/**
*
* Author:		Carmine Barbuto
* Date:			16/12/2013
* Description:	Visualforce controller to let a user opt out
*				of an Event (on behalf of a Planner).
*
**/
public without sharing class cp_EventOptOut {
    
    // MAIN OBJECTS
    public cp_Event__c 	mainEvent					{get; set;}
    public cp_Event__c	parentEvent					{get; set;}
    
    // SUPPORT VARIABLES
    public String		defaultPlanner				{get; set;}
    public String       defaultPlannerName          {get; set;}
    public String		optOutReason				{get; set;}
    public Boolean		canOptOut					{get; set;}
    public Boolean		isCalendar					{get; set;}
    
    // ERROR MANAGEMENT
    public String		errorMessage				{get; private set;}
    public Boolean		showError					{get; set;}
    public Boolean      validationError             {get; set;}

    // MAIN LISTS
    public List<cp_Event__c>			childList	{get; set;}
        
    // CONSTRUCTOR
    public cp_EventOptOut() {
    	
    	// Initialise...
    	isCalendar		= Apexpages.currentPage().getParameters().get('cal') == 'yes' ? true : false;
    	showError		= false;
    	canOptOut		= false;
        validationError = false;
    	optOutReason	= '';
    	defaultPlanner	= '';
    	errorMessage	= '';
    	childList		= new List<cp_Event__c>();
    	String eventId 	= ApexPages.currentPage().getParameters().get('Id');
    	mainEvent		= [SELECT Name, Parent_Event__c FROM cp_Event__c WHERE Id =:eventId];
    		
    	// Retrieve user default (current version: one default allowed per each user)
		defaultPlanner = cp_PlannerUtility.getDefaultPlanner(UserInfo.getUserId());
		defaultPlannerName = [SELECT Name FROM cp_Planner__c WHERE Id =:defaultPlanner].Name;

		// Check if any activated local event are available - filter related planners = defaultPlanner
        childList = [SELECT Id, Parent_Event__c, (SELECT Id FROM Planner_Locations__r WHERE Planner__c =:defaultPlanner)
                    FROM cp_Event__c 
                    WHERE Parent_Event__c = :mainEvent.Id];         
    	
    	// Check if user is allowed to opt out - match against default planer
		if (defaultPlanner != null && defaultPlanner != '') {
			showError 		= !checkOptOut(defaultPlanner);
			errorMessage 	= Label.cp_OptOutWarning;
		} else {
			showError 		= true;
			errorMessage 	= 'Planner Preference default not defined.';
		}			
									
    }
    
    // CHECK IF THE CURRENT USER IS ALLOWED TO OPT OUT - MATCH AGAINST DEFAULT PLANNER
    private Boolean checkOptOut(String planner) {
    	Boolean optOut = false;

		List<cp_PlannerLocation__c> plocs = [SELECT Id FROM cp_PlannerLocation__c 
                                            WHERE Planner__c = :planner AND (
                                            Event__c = :mainEvent.Id OR
                                            Event__c IN :childList)];	
		
		optOut = plocs.isEmpty() ? false : true;
    	
    	return optOut;
    }
   
    
    // SAVE OPT OUT
    public Pagereference saveAll() {
    	
    	Pagereference retPage = null;
    	
    	Savepoint sp = Database.setSavepoint();

        if (optOutReason != null && optOutReason != '') 
        {
    	
        	try {
                // Update visibility table
                List<cp_PlannerLocation__c> optOutPlanner = [SELECT Activate__c, OptOut__c, OptOutReason__c 
                                                            FROM cp_PlannerLocation__c 
                                                            WHERE Planner__c =:defaultPlanner
                                                            AND Event__c =:mainEvent.Id]; // Only one expected
                for (cp_PlannerLocation__c curr : optOutPlanner) {
                    curr.Activate__c        = false;
                    curr.OptOut__c          = true;
                    curr.OptOutReason__c    = optOutReason;
                }

                update optOutPlanner;                                            

        		// Delete Local activated events if any
        		List<cp_Event__c> 					toDelete 	= new List<cp_Event__c>();
         		if (!childList.isEmpty()) {
        			for (cp_Event__c curr : childList) {
        				
        				// Delete event only if default planner has been activated
        				if (curr.Planner_Locations__r.size() > 0)
        					 toDelete.add(curr); 
        					 
        			}
        			delete toDelete;
        		}
        		
        		// Redirect to event detail (or parent event if pressing from local activated - which will be removed)
        		retPage = isCalendar ? new Pagereference('/apex/cp_RecordDetail?id=' + mainEvent.Id + '&isdtp=vw') : new Pagereference('/' + mainEvent.Id);
        		
        	} catch (Exception ex) {
        		Database.rollback(sp);
        		showError 		= true;
        		errorMessage 	= 'Error while opting out. Please report to your Administrator: ' + ex.getMessage();
        	}

        } else {
            validationError     = true;
            errorMessage        = Label.cp_OptOutNoReason;
        }
    	
    	return retPage;
    }
    
    // BACK TO EVENT DETAIL
    public Pagereference back() {
    	Pagereference retPage = isCalendar ? new Pagereference('/apex/cp_RecordDetail?id=' + mainEvent.Id + '&isdtp=vw') : new Pagereference('/' + mainEvent.Id);
    	return retPage;
    }
    
}