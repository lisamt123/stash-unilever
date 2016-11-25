/**********************************************************************
Name:  CEC_ExceptionHandling
Copyright @ 2016  Unilever
======================================================================
=======================================================================
Purpose: To log exception in a custom object CEC_Exception_Log.
=======================================================================
=======================================================================
History                                                            
-------                                                            
VERSION    AUTHOR            DATE            DETAIL                   
1.0        Mahesh           Nov-2016        INITIAL DEVELOPMENT   
***********************************************************************/
public with sharing class CEC_ExceptionHandling {
	
    /****************************************************************************************************
    @Name CreateExceptionLog
    @param srcType to pass type of component.
	@param methodName to pass name of method.
	@param compName to pass name of class.
	@param RefID to pass record Id.
	@param prntCompName to pass name of parent class.
	@param errDesc to pass Exception message.
    @Description: Insert CEC_Exception_Log__c.
    
    ****************************************************************************************************/
    public static void CreateExceptionLog(String srcType, String methodName,String compName, String RefID,
                                          String errDesc){
                                             
      if(String.isNotBlank(methodName) && String.isNotBlank(compName) && String.isNotBlank(errDesc)){
              CEC_Exception_Log__c excep = new CEC_Exception_Log__c(User__c = userinfo.getUserId(),
        							 Source_Type__c =srcType,Source_Method_Name__c =methodName,
                                     Source_Component_Name__c = compName,Reference_Id__c = RefID,
                                      Error_Description__c = errDesc);
        	  insert excep;                                   
          }
        
        
    }
}