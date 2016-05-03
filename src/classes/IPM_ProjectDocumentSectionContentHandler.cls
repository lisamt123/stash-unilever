/****************************************************************************************************************************
@Author Cognizant
@name IPM_ProjectDocumentSectionContentHandler
@CreateDate 28/11/2015
@Description Trigger Handler for the IPM_Project_Document_Section_Content__c SObject.
@Version 1.0
@reference  
*/
public with sharing class IPM_ProjectDocumentSectionContentHandler implements ITrigger {

	
	public static Boolean SKIP_TRIGGER_EXECUTION = false;
	
	// Constructor
    public IPM_ProjectDocumentSectionContentHandler()
    { 
        ExceptionLoggingHelper.initializeExceptionLog(); 
    }
    
    /***********************************************************************************************************************************
    * bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore()
    {
		list<IPM_Project_Document_Section_Content__c> projDocSecConList = new list<IPM_Project_Document_Section_Content__c>();
    	list<id> projDocSecIdList = new list<id>();
    	
    	if(Trigger.isInsert)
        {
        	for(IPM_Project_Document_Section_Content__c seccon : (List<IPM_Project_Document_Section_Content__c>)Trigger.New)
            {
            	if(seccon.IPM_Project_Document_Section__c != null){
            		projDocSecConList.add(seccon);
            		projDocSecIdList.add(seccon.IPM_Project_Document_Section__c);            		
            	}	
            }
        	
        	if(!projDocSecConList.isEmpty()){
        		IPM_ProjectDocSecContentTriggerHandler PThandler = new IPM_ProjectDocSecContentTriggerHandler();
        		PThandler.UpdateRecordOwner(projDocSecConList,projDocSecIdList); 
        	}
        } 
    }
        
    /***********************************************************************************************************************************
    * bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter()
    {	
  		//This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * beforeInsert
    * This method is called iteratively for each record to be inserted during a BEFORE
    * trigger.
    */
    public void beforeInsert(SObject so){
    	//This method has been included as the class implements the ITrigger interface 
    }
    
    /***********************************************************************************************************************************
    * beforeUpdate
    * This method is called iteratively for each record to be updated during a BEFORE
    * trigger.
    */
    public void beforeUpdate(SObject oldSo, SObject so){
    	//This method has been included as the class implements the ITrigger interface 
    }    
        
    /***********************************************************************************************************************************
    * beforeDelete
    * This method is called iteratively for each record to be deleted during a BEFORE
    * trigger.
    */
    public void beforeDelete(SObject so){
   		//This method has been included as the class implements the ITrigger interface 
    }   
    
    /***********************************************************************************************************************************
    * afterInsert
    * This method is called iteratively for each record to be inserted during a AFTER
    * trigger.
    */        
    public void afterInsert(SObject so)
    {
    	//This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * afterUpdate
    * This method is called iteratively for each record to be updaetd during a AFTER
    * trigger.
    */  
    public void afterUpdate(SObject oldSo, SObject so)
    {  
    	//This method has been included as the class implements the ITrigger interface
    	
    }
    
    /***********************************************************************************************************************************
    * afterDelete
    * This method is called iteratively for each record to be deleted during a AFTER
    * trigger.
    */      
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */    
    public void andFinally()
    {
    	//This method has been included as the class implements the ITrigger interface
    }
}