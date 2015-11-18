/****************************************************************************************************************************************
* @Autor Cognizant
* @Created Date date 29/07/2015
* @Description Trigger Handler for the IPM_Assessment__c SObject. This class implements the ITrigger
               interface to help ensure the trigger code is bulkified and all in one place.
               */
public with sharing class IPM_AssesmentHandler implements ITrigger{   
    // Constructor
    public IPM_AssesmentHandler(){
        ExceptionLoggingHelper.initializeExceptionLog();
    }
    
    /***********************************************************************************************************************************
    * bulkBefore
    * This method is called prior to execution of a BEFORE trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkBefore(){
        //This method has been included as the class implements the ITrigger interface
        If(Trigger.isInsert){
        	//Insert the Incoming assessments and all the logic associated with it(Validate the assessments and delete previous assessments)
        	IPM_AssesmentHandler_Helper.insertAssessments( (List<IPM_Assessment__c>) Trigger.new);        	
        }
    }
    /***********************************************************************************************************************************
    * bulkAfter
    * This method is called prior to execution of a AFTER trigger. Use this to cache
    * any data required into maps prior execution of the trigger.
    */
    public void bulkAfter(){
    	If(Trigger.isInsert){
        	//check if at least one Assessment exists for each EI Country for their respective projects
        	IPM_AssesmentHandler_Helper.checkAtLeastOneAssmntPerEICountry( (List<IPM_Assessment__c>) Trigger.New);        	
        }
        If(Trigger.isDelete){
        	//check if at least one Assessment exists for each EI Country for their respective projects
        	IPM_AssesmentHandler_Helper.checkAtLeastOneAssmntPerEICountry( (List<IPM_Assessment__c>) Trigger.old);        	
        }
        
    }
    
    public void beforeInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface  
    }
    
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
    
    public void afterInsert(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterUpdate(SObject oldSo, SObject so){   
        //This method has been included as the class implements the ITrigger interface
    }
    
    public void afterDelete(SObject so){
        //This method has been included as the class implements the ITrigger interface
    }
    
    /***********************************************************************************************************************************
    * andFinally
    * This method is called once all records have been processed by the trigger. Use this 
    * method to accomplish any final operations such as creation or updates of other records.
    */
    public void andFinally(){
        //Added by Devendra - call method to insert all exception logs got while excecution of trigger
        ExceptionLoggingHelper.insertLogRecordList();
    }
}