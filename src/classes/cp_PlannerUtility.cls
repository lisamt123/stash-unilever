/**
*
* Author:		Carmine Barbuto
* Date:			17/12/2013
* Description:	Utility class with commons methods
*				for Comms Planner development.
*
**/
public without sharing class cp_PlannerUtility {

    // GLOBAL VARIABLES
    public static String    CLUSTER     = 'Cluster';
    public static String    MCO         = 'MCO';
    public static String    COUNTRY     = 'Country';
    public static String    CATEGORY    = 'Category';
    public static String    FUNCTION    = 'Function';
    public static String    EXPERTISE   = 'Expertise';
    public static String    MARKET      = 'Market';
    public static String    CONFIRMED   = 'Confirmed';
    public static String    TENTATIVE   = 'Tentative';

    // TRIGGER LOCKS
    public static Boolean   emailSent   = false;

    // POPULATE HOST PLANNER
    public static void setHostPlanner(List<cp_Event__c> pevents) {
        // Retrieve Host Planner from current user preferences - expected only one record
        List<cp_PlannerPreference__c> prefs = [SELECT Planner__c FROM cp_PlannerPreference__c WHERE User__c =:UserInfo.getUserId() order by Name];
        
        // Set Host Planner on all events
        if (!prefs.isEmpty()) {
            for (cp_Event__c curr : pevents) {
                curr.HostPlanner__c = prefs.get(0).Planner__c;
            }
        }
    }

    // VALIDATE EDIT PERMISSION ON PLANNER EVENT
    public static Boolean canEditEvent(Id hostPlanner, Id userId) {
        Boolean canEdit = false;

        // Check planner preference first
        List<cp_PlannerPreference__c> prefs = [SELECT Planner__c FROM cp_PlannerPreference__c WHERE User__c = :userId];
        if (!prefs.isEmpty() && prefs.get(0).Planner__c == hostPlanner)
            canEdit = true;
        else {
            // Check Planner Admin permission set
            List<PermissionSetAssignment> psets = [SELECT Id 
                                                    FROM PermissionSetAssignment
                                                    WHERE 
                                                    AssigneeId = :userId AND
                                                    PermissionSetId 
                                                    IN (SELECT Id 
                                                        FROM PermissionSet 
                                                        WHERE Name = 'Planner_Administrator')];
            // Check Modify All Data permission
            User currentUser = [SELECT Profile.PermissionsModifyAllData
                                FROM User 
                                WHERE Id =: userId];
            if (!psets.isEmpty())
                canEdit = true;
            else
                canEdit = currentUser.Profile.PermissionsModifyAllData;
        }    

        return canEdit;  

    }
	
	// RETRIEVE DEFAULT PLANNER PREFERENCE (Assumption only one defined)
	public static String getDefaultPlanner(String userId) {
		cp_PlannerPreference__c userDefault;

		List<cp_PlannerPreference__c> userPref =  [SELECT Planner__c FROM cp_PlannerPreference__c WHERE User__c =:userId];
    	
        // If preference is not defined it will take the default settings										
    	if (userPref.isEmpty()) { 										
			List<cp_PlannerPreference__c> defaultPref =  [SELECT Planner__c FROM cp_PlannerPreference__c WHERE User__c = null];
    		if (!defaultPref.isEmpty())
    			 userDefault = defaultPref.get(0);										
    	} else {
    		userDefault = userPref.get(0);
    	}
				
		return userDefault.Planner__c;
	}

    // POPULATE STRING FIELDS FOR ALL PLANNERS
    public static void setPlannerTextField(Map<Id,cp_Event__c> eventMap, Boolean recordUpdate) {

        // Clean roll-up
        for (cp_Event__c curr : eventMap.values()) {
            curr.Track_Categories__c    = '';
            curr.Track_Expertise__c     = '';
            curr.Track_Functions__c     = '';
            curr.Track_Cluster__c       = '';
            curr.Track_MCO__c           = '';
            curr.Track_Country__c       = '';
        }

        // Rebuild roll-up
        for (cp_PlannerLocation__c curr : [SELECT Planner__r.Name, Planner__r.SubType__c, Event__c 
                                            FROM cp_PlannerLocation__c 
                                            WHERE Event__c IN :eventMap.values()]) {
            if (curr.Planner__r.SubType__c == cp_PlannerUtility.CLUSTER)
                eventMap.get(curr.Event__c).Track_Cluster__c += curr.Planner__r.Name+';';
            
            else if (curr.Planner__r.SubType__c == cp_PlannerUtility.MCO) 
                eventMap.get(curr.Event__c).Track_MCO__c += curr.Planner__r.Name+';';   
            
            else if (curr.Planner__r.SubType__c == cp_PlannerUtility.COUNTRY) 
                eventMap.get(curr.Event__c).Track_Country__c += curr.Planner__r.Name+';';  
            
            else if (curr.Planner__r.SubType__c == cp_PlannerUtility.CATEGORY) 
                eventMap.get(curr.Event__c).Track_Categories__c += curr.Planner__r.Name+';'; 

            else if (curr.Planner__r.SubType__c == cp_PlannerUtility.EXPERTISE) 
                eventMap.get(curr.Event__c).Track_Expertise__c += curr.Planner__r.Name+';';

            else if (curr.Planner__r.SubType__c == cp_PlannerUtility.FUNCTION) 
                eventMap.get(curr.Event__c).Track_Functions__c += curr.Planner__r.Name+';';             
        }

        // Remove last semicolon
        for (cp_Event__c curr : eventMap.values()) {
            if (curr.Track_Categories__c != '')
                curr.Track_Categories__c    = curr.Track_Categories__c.substring(0,curr.Track_Categories__c.length()-1);
            
            if (curr.Track_Expertise__c != '')
                curr.Track_Expertise__c     = curr.Track_Expertise__c.substring(0,curr.Track_Expertise__c.length()-1);
            
            if (curr.Track_Functions__c != '')
                curr.Track_Functions__c     = curr.Track_Functions__c.substring(0,curr.Track_Functions__c.length()-1);

            if (curr.Track_Cluster__c != '')
                curr.Track_Cluster__c    = curr.Track_Cluster__c.substring(0,curr.Track_Cluster__c.length()-1);  

            if (curr.Track_MCO__c != '')
                curr.Track_MCO__c    = curr.Track_MCO__c.substring(0,curr.Track_MCO__c.length()-1);

            if (curr.Track_Country__c != '')
                curr.Track_Country__c    = curr.Track_Country__c.substring(0,curr.Track_Country__c.length()-1);      

        }

        // When trigger is called from a different object (e.g. Planner)
        if (recordUpdate)
            update eventMap.values();

    }
   
}