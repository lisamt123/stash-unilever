@IsTest
/**********************************************************************
Name: ICB_RecordTypeMemory_Test
Copyright © 2016 Salesforce
======================================================
======================================================
Purpose:
Class responsible for test: ICB_RecordTypeMemory.
======================================================
======================================================
History
VERSION AUTHOR    		DATE 		DETAIL 			Description
 1.0    Carlos Carvalho 13/06/2016  Class creation  
***********************************************************************/
public class ICB_RecordTypeMemory_Test {
	
    /*******************************************************************
    Purpose: Test Class ICB_RecordTypeMemory_Test
    Parameters: [NONE]
	Returns: [VOID]
	Throws [Exceptions]: [NONE]  
    ********************************************************************/
    private static testMethod void recordTypeMemory_Test(){
        List< RecordType > lstRT = [Select Id, SobjectType, DeveloperName From RecordType Where isActive = true limit 1];
        if( !lstRT.isEmpty() ){
        	system.assert(lstRT[0].Id == ICB_RecordTypeMemory.getRecType( lstRT[0].SobjectType, lstRT[0].DeveloperName ));
        }
    }
    
}