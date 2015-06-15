trigger cp_ULE_Rep_Trigger on cp_ULE__c (after insert, after update, after delete) {
	List<Id> eventIds = new List<Id>();
	List<cp_Event__c> events = new List<cp_Event__c>();

	if(trigger.isInsert||trigger.isUpdate) {
		for(cp_ULE__c trig:trigger.new) {
			eventIds.add(trig.Event__c);
		}
	}
	else {
		for(cp_ULE__c trig:trigger.old) {
			eventIds.add(trig.Event__c);
		}
	}

	for(cp_Event__c event:[SELECT Unilever_Speaker_Representative__c,
								(SELECT UnileverLeadershipExecutive__r.Full_Name__c
								FROM ULE_Event_Reps__r)
							FROM cp_Event__c 
							WHERE Id IN:eventIds]) {
		event.Unilever_Speaker_Representative__c = '';
		if(event.ULE_Event_Reps__r!=null) {
			for(cp_ULE__c ule:event.ULE_Event_Reps__r) {
				event.Unilever_Speaker_Representative__c += ule.UnileverLeadershipExecutive__r.Full_Name__c + '\n';
			}
		}
		events.add(event);
	}

	update events;
}