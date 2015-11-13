/**********************************************************************

 Name:  OV_Trigger()

 Copyright © 2015  Salesforce

 ======================================================

======================================================

Purpose:     Interface containing methods Trigger Handlers must implement to enforce best practice
				and bulkification of triggers.                                                       

-------                                                            

======================================================

======================================================

History                                                            

-------                                                            

VERSION  AUTHOR            DATE              DETAIL            Description

1.0   Pawel Niedziela    24/09/2015      INITIAL DEVELOPMENT    Interface containing methods Trigger Handlers must implement to enforce best practice and bulkification of triggers. 

***********************************************************************/
public interface OV_Trigger {


	/*******************************************************************

		Purpose:  This method is called prior to execution of a BEFORE trigger. Use this to cacheany data required into maps prior execution of the trigger.  
		
		Parameters: [optional]

		Returns: [optional]

		Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void bulkBefore();
	
	

	/*******************************************************************

		Purpose:  This method is called prior to execution of an AFTER trigger. Use this to cache any data required into maps prior execution of the trigger. 
		
		Parameters: [optional]

		Returns: [optional]

		Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void bulkAfter();
	
	
	
	/*******************************************************************

	   Purpose:  This method is called iteratively for each record to be inserted during a BEFORE trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.                                      
	
	   Parameters: [SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void beforeInsert(SObject so);



	/*******************************************************************

	   Purpose: This method is called iteratively for each record to be updated during a BEFORE trigger.                
	
	   Parameters: [SObject, SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void beforeUpdate(SObject oldSo, SObject so);



	/*******************************************************************

	   Purpose: This method is called iteratively for each record to be deleted during a BEFORE trigger.
	
	   Parameters: [SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void beforeDelete(SObject so);
 
 
 
	/*******************************************************************

		Purpose: This method is called iteratively for each record inserted during an AFTER
		trigger. Always put field validation in the 'After' methods in case another trigger
		has modified any values. The record is 'read only' by this point.
	
	   Parameters: [SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void afterInsert(SObject so);



	/*******************************************************************

		Purpose: This method is called iteratively for each record updated during an AFTER trigger.
	
	   Parameters: [SObject, SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void afterUpdate(SObject oldSo, SObject so);



	/*******************************************************************

		Purpose: This method is called iteratively for each record deleted during an AFTER trigger.
	
	   Parameters: [SObject ]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void afterDelete(SObject so);
 
 
 
	/*******************************************************************

		Purpose: This method is called iteratively for each record undeleted during an AFTER trigger.
	
	   Parameters: [SObject ]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void afterUndelete(SObject so);



	/*******************************************************************

		Purpose: This method is called once all records have been processed by the trigger. Use this 
					method to accomplish any final operations such as creation or updates of other records.
	
	   Parameters: [SObject ]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	void andFinally();
}