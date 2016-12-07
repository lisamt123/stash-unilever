/***************************************************************************************************
    * Class IPM_SourcingUnitHandler
    * Trigger Handler for the IPM_SourcingUnit SObject. This class implements the ITrigger
    * interface to help ensure the trigger code is bulkified and all in one place.
****************************************************************************************************/
public with sharing class IPM_SourcingUnitHandler implements ITrigger{   
    
    // Constructor
    public IPM_SourcingUnitHandler() {
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    /**
    * bulkBefore
    *
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        //This method has been included as the class implements the ITrigger interface      
    }
    
    public void bulkAfter()
    {    
        if(trigger.isUpdate)
        {
            List<IPM_SourcingUnit__c> lstSourcingUnit = new List<IPM_SourcingUnit__c>();
            for(ID sourcingUnitID : Trigger.newMap.keySet())
            {
            	String sOldName = String.valueOf((Trigger.oldMap.get(sourcingUnitID)).get('Source_Unit_Name__c'));
            	String sNewName = String.valueOf((Trigger.newMap.get(sourcingUnitID)).get('Source_Unit_Name__c'));
            	if(!sOldName.Equals(sNewName))
            	{
            		lstSourcingUnit.add((IPM_SourcingUnit__c)Trigger.newMap.get(sourcingUnitID));
            	}
            }
            if(!lstSourcingUnit.isEmpty())
            {
            	List<IPM_SourcingPlan__c> lstSourcingPlan = [Select IPM_SourcingUnit__c,IPM_Sourcing_Unit__c From IPM_SourcingPlan__c Where IPM_Sourcing_Unit__c =: lstSourcingUnit];
            	if(!lstSourcingPlan.isEmpty())
            	{
            		for(IPM_SourcingPlan__c oSourcingPlan : lstSourcingPlan)
	            	{
	            		oSourcingPlan.IPM_SourcingUnit__c = String.valueOf((Trigger.newMap.get(oSourcingPlan.IPM_Sourcing_Unit__c)).get('Source_Unit_Name__c'));
	            	}
	            	Database.update(lstSourcingPlan);
            	}
            }
        }
    }
    
    public void beforeInsert(SObject so)
    {
        //This method has been included as the class implements the ITrigger interface        
    }
    
    public void beforeUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void beforeDelete(SObject so){    
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterUpdate(SObject oldSo, SObject so)
    {    
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /**
    * andFinally
    *
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}