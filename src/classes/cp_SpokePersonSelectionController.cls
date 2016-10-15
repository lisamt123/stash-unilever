public class cp_SpokePersonSelectionController {
    private cp_Event__c event;
    private Map<Id,cp_ULE__c> savedRepresentatives;         
    private Map<Id,cp_ULE_Contact__c> availableRepresentatives; 
    public list<SelectOption> selectedContacts { get; set; }
    public list<SelectOption> allContacts { get; set; }
    public boolean canEdit { get; set; }
    
    // constructor
    public cp_SpokePersonSelectionController(ApexPages.StandardController  stdController) {
        this.event                    = (cp_Event__c)stdController.getRecord();
        this.savedRepresentatives     = this.getSavedRepsentative();
        this.availableRepresentatives = this.getActiveRepresentative();
        this.init();
    }
    
    public PageReference OnSave() {
    	this.savedRepresentatives     = this.getSavedRepsentative();
        this.availableRepresentatives = this.getActiveRepresentative();
        Set<String> selectedReps = new Set<String>();
        for (SelectOption so: selectedContacts) {
            selectedReps.add(so.getValue());
        }
        this.RemovedFromList(selectedReps);
        this.AddToList(selectedReps);
        this.updateTrackedField(selectedReps);
        return null;
        
    }
    
    // POPULATE TEXT AREA FIELD FOR CHATTER POST - Added by Carmine Barbuto 04/02/2013
    private void updateTrackedField(Set<String> selectedReps) {
    	String uleNames = '';
    	for (String curr : selectedReps) {
    		uleNames = uleNames + ';' + availableRepresentatives.get(curr).Name;
    	}
    	this.event.Track_ULE__c = uleNames.replaceFirst(';','');
    	try {
    		update this.event;
    	} catch (DmlException dml) {
    		Apexpages.addMessages(dml);
    	}
    }
    
    private void RemovedFromList(Set<String> selectedReps) {
       list<cp_ULE__c> removedIds = new list<cp_ULE__c>();
       for (Id repId : savedRepresentatives.keySet()) {
           if (!selectedReps.contains(String.valueOf(repId))) {
               removedIds.add(savedRepresentatives.get(repId));
           }
       }
       try {
       delete removedIds;
       } catch(Exception exp){}
    }
    
    private void AddToList(Set<String> selectedReps) {
        list<cp_ULE__c> uleList = new list<cp_ULE__c>();
        for (String contId: selectedReps) {
            if (!savedRepresentatives.containsKey((id)contId)) {
                uleList.add( new cp_ULE__c(UnileverLeadershipExecutive__c = contId,
                                        Event__c = event.Id));
            }
        }
        upsert uleList;
    }
    
    private void init() {
        selectedContacts = new list<SelectOption>();
        allContacts      = new list<SelectOption>();

        // Check if user has edit permissions
        canEdit = cp_PlannerUtility.canEditEvent(this.event.HostPlanner__c, UserInfo.getUserId());
        
        // Order A-Z on first load - Available
        List<String> orderedRepNames = new List<String>();
        for (cp_ULE_Contact__c curr : availableRepresentatives.values())
        	orderedRepNames.add(curr.Full_Name__c+'#'+curr.Id);
        orderedRepNames.sort();
        // Build multiplicklist selection - left side
        for (String curr :orderedRepNames) {
        	if (!savedRepresentatives.containsKey(curr.split('#').get(1))) {
        		cp_ULE_Contact__c cnt = availableRepresentatives.get(curr.split('#').get(1));
        		String title = cnt.Title__c == null ? '' : ', ' + cnt.Title__c;
        		String salutation = cnt.Salutation__c == null ? '' : cnt.Salutation__c + ' ';
        		allContacts.add(new SelectOption(cnt.Id, salutation + cnt.Full_Name__c + title));
        	}
        }
        
        // Order A-Z on first load - Selected
        List<String> orderedSelNames = new List<String>();
        for (cp_ULE__c curr : savedRepresentatives.values())
        	orderedSelNames.add(curr.UnileverLeadershipExecutive__r.Name+'#'+curr.UnileverLeadershipExecutive__c);
        orderedSelNames.sort();
        // Build multipicklist selection - right side
        for (String curr : orderedSelNames) {
            cp_ULE_Contact__c cnt = availableRepresentatives.get(curr.split('#').get(1));
            String title = cnt.Title__c == null ? '' : ', ' + cnt.Title__c;
        	String salutation = cnt.Salutation__c == null ? '' : cnt.Salutation__c + ' ';
            if (cnt != null) {
            	selectedContacts.add(new SelectOption(cnt.Id, salutation + cnt.Full_Name__c + title));
            }
        }

    }
    
    // cache all save representative
    private Map<Id,cp_ULE__c> getSavedRepsentative() {
        Map<Id,cp_ULE__c> savedRepsMap = new Map<Id,cp_ULE__c>();
        cp_Event__c anEvent = [Select Id, (Select id, Event__c,UnileverLeadershipExecutive__c, 
                                                UnileverLeadershipExecutive__r.Name from ULE_Event_Reps__r) 
                              from  cp_Event__c 
                             where Id = :event.id];                
	    for (cp_ULE__c ule: anEvent.ULE_Event_Reps__r) {
	        savedRepsMap.put(ule.UnileverLeadershipExecutive__c,ule);
	    }
        return savedRepsMap;
    }
    
    // cache all active represenative in the system.
    private Map<Id,cp_ULE_Contact__c> getActiveRepresentative() {
        Map<Id,cp_ULE_Contact__c> allReps = new Map<Id,cp_ULE_Contact__c>([SELECT Id, Full_Name__c, Name, Title__c, Salutation__c 
                                                    	FROM cp_ULE_Contact__c 
                                                     	WHERE (Active_ULE__c = true) 
                                                     	ORDER BY Full_Name__c asc]);
        return allReps;
    }
    
    
    
    

}