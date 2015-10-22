trigger SOWSplitProjectAvoid on Oblix_Marketing_SOW_Project_Splits__c (after insert, after update) {
	    
	if(Trigger.isInsert && Trigger.isAfter){
		Oblix_TR05SOWSplitProjectAvoid.SOWSplitProjectAvoid(Trigger.New);
	}
	
	if(Trigger.isUpdate && Trigger.isAfter){
		Oblix_TR05SOWSplitProjectAvoid.SOWSplitProjectAvoid(Trigger.New);
	}
}