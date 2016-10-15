/**********************************************************************
 Name:  FAU_UtilitiesTest()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose: Test Methods for FAU_Utilities                                                   
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      07/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/
@isTest
private class FAU_UtilitiesTest
{
	@isTest
	/*******************************************************************
        Purpose:  Test FAU_Utilities saveDatabase - insert
    *******************************************************************/ 
	static void testInsertSave() 
	{
		System.debug('Entering FAU_UtilitiesTest.testInsertSave');
		User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

		List<FAU_Program__c> lPrograms = new List<FAU_Program__c>();
		// Given
		for(Integer i = (300-1); i >=0 ; i--) { 
	  		FAU_Program__c program = new FAU_Program__c();
	        program.Name = 'name' + i;
	        program.FAU_Start_Date__c = system.today();
	        program.FAU_Primary_Location__c = 'location';
	        //program.FAU_Module_1_Start_Date__c = system.today().addMonths(1);
	        //program.FAU_Module_2_Start_Date__c = system.today().addMonths(2);
	        program.ownerId = user.Id;
	        lPrograms.add(program);
    	}


    	Test.startTest();

 		FAU_Utilities.saveDatabase('insert', lPrograms, false);
        
        Test.stopTest();
        
        Integer iNumberProgams = [Select Id FROM FAU_Program__c].size();
        System.assertEquals(300, iNumberProgams);

        System.debug('Exiting FAU_UtilitiesTest.testInsertSave');

	}

	/*******************************************************************
        Purpose:  Test FAU_Utilities saveDatabase - update
    *******************************************************************/ 
	static void testUpdateSave() 
	{
		System.debug('Entering FAU_UtilitiesTest.testUpdateSave');
		User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

		List<FAU_Program__c> lPrograms = new List<FAU_Program__c>();
		// Given
		for(Integer i = (300-1); i >=0 ; i--) { 
	  		FAU_Program__c program = new FAU_Program__c();
	        program.Name = 'name' + i;
	        program.FAU_Start_Date__c = system.today();
	        program.FAU_Primary_Location__c = 'location';
	        //program.FAU_Module_1_Start_Date__c = system.today().addMonths(1);
	        //program.FAU_Module_2_Start_Date__c = system.today().addMonths(2);
	        program.ownerId = user.Id;
	        lPrograms.add(program);
    	}


    	

 		FAU_Utilities.saveDatabase('insert', lPrograms, false);
        
        Test.startTest();
        	for(Integer i = (lPrograms.size()-1); i >=0 ; i--) { 
        		lPrograms[i].FAU_Primary_Location__c = 'location1';
        	}
        	FAU_Utilities.saveDatabase('update', lPrograms, false);
        Test.stopTest();
        
  
        System.assertEquals(lPrograms[0].FAU_Primary_Location__c, 'location1');

        System.debug('Exiting FAU_UtilitiesTest.testUpdateSave');

	}

	/*******************************************************************
        Purpose:  Test FAU_Utilities saveDatabase - Error
    *******************************************************************/ 
	static void testSaveError()
	{
		System.debug('Entering FAU_UtilitiesTest.testSaveError');
		User user = FAU_TestUtil.createUserWithProfile(FAU_TestUtil.PROFILE_PARTICIPANT_HOLDS);

		List<FAU_Program__c> lPrograms = new List<FAU_Program__c>();
		
		
  		FAU_Program__c program = new FAU_Program__c();
        lPrograms.add(program);
    	


    	Test.startTest();
    	System.runAs(user)
        {
	    	try{
	 			FAU_Utilities.saveDatabase('insert', lPrograms, false);
	        }catch(Exception e){
				System.debug('#### FAU_UtilitiesTest: The following exception has occurred: ' + e.getMessage());
	        }
	    }
        Test.stopTest();
        
        Integer iNumberProgams = [Select Id FROM FAU_Program__c].size();
        System.assertEquals(0, iNumberProgams);

        System.debug('Exiting FAU_UtilitiesTest.testSaveError');
	}
}