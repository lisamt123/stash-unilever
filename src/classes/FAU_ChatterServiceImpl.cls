/********************************************************************
 Name:  FAU_ChatterServiceImpl()
 Copyright © 2014  Unilever
 ======================================================
======================================================
Purpose:  This class handles the Chatter Setup & Membership functionality.                                                      
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                 Description
   1.0   Jack Dermody      18/09/2014        INITIAL DEVELOPMENT           
***********************************************************************/

public without sharing class FAU_ChatterServiceImpl
	implements FAU_ChatterService
{
	/*******************************************************************
       Purpose:     Commit the Chatter Groups to the Database
    ********************************************************************/

	public void commitChatterGroups(List<CollaborationGroup> chatterGroups, List<FAU_Program__c> programs)
	{
		
		for(FAU_Program__c program : programs)
		{
			programByName.put(program.Name, program);
		}
		databaseSave(chatterGroups);
	}
	
	/*******************************************************************
       Purpose:     Create Chatter Groups
    ********************************************************************/
	public CollaborationGroup createChatterGroup(FAU_Program__c program, Id ownerId)
	{
		return buildChatterGroup(program.Name, ownerId);
	} 

	/*******************************************************************
       Purpose:     Build Chatter Group
    ********************************************************************/
	public CollaborationGroup buildChatterGroup(String name, Id ownerId)
	{
		 return buildPrivateChatterGroup(name, ownerId, 'Private');
	}


	/*******************************************************************
       Purpose:     Build Private Chatter Group
    ********************************************************************/
	private CollaborationGroup buildPrivateChatterGroup(String name, Id ownerId, String collaborationType)
	{
		System.debug('#### FAU_ChatterServiceImpl.buildPrivateChatterGroup: enter');
		CollaborationGroup chatterGroup = new CollaborationGroup();
   		chatterGroup.Name = name;      
   		chatterGroup.CollaborationType = collaborationType;
   		chatterGroup.OwnerId = ownerId;
   		chatterGroup.Description = 'Chatter Group for ' + name + 'participants';          
    	return chatterGroup;
	}

	/*******************************************************************
       Purpose:     Commit Chatter Memeber 
    ********************************************************************/
	public static void commitChatterMember(List<CollaborationGroupMember> lCollaborationGroupMembers)
	{
		try
		{
			insert lCollaborationGroupMembers;
		}catch (Exception e)
		{
    		System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
		}
	}

	@TestVisible	
	/*******************************************************************
       Purpose:     Commit the Chatter Group to the Database
    ********************************************************************/
	private void databaseSave(List<CollaborationGroup> chatterGroups) 
	{
		try
		{
			Database.SaveResult[] results = Database.insert(chatterGroups, ALLOW_PARTIAL_SUCCESS);
		    
		    handleChatterGroupSaveResults(results, chatterGroups);

		}
		catch (Exception e)
		{
    		System.debug(e.getTypeName() + ' - ' + e.getCause() + ': ' + e.getMessage());
		}
	}

	/*******************************************************************
       Purpose:     Handle Chatter Group Save Results
    ********************************************************************/
	private void handleChatterGroupSaveResults(Database.SaveResult[] results,
												 List<CollaborationGroup> chatterGroups)
	{
		Integer resultsLength = (results == null) ? 0 : results.size();
        for (Integer i = 0; i < resultsLength; i++)
        {
        	Database.SaveResult result = results[i];
        	CollaborationGroup chatterGroup = chatterGroups.get(i);
            if (result.isSuccess())
            {
            	linkChatterGroupToProgram(result, chatterGroup);
            }
            else
            {
            	handleChatterGroupSaveErrors(result, chatterGroup);
            }
		}
	}

	/*******************************************************************
       Purpose:     Handle Chatter Group Save Results
    ********************************************************************/
	private void linkChatterGroupToProgram(Database.SaveResult result, CollaborationGroup chatterGroup)
	{
		System.debug('#### FAU_ChatterServiceImpl.linkChatterGroupToProgram enter');
		System.debug('#### FAU_ChatterServiceImpl.linkChatterGroupToProgram chatterGroup.Name: ' + chatterGroup.Name);
		FAU_Program__c programToUpdate = programByName.get(chatterGroup.Name);
    	programToUpdate.FAU_Participant_Chatter_Group_Id__c = result.getId();
	}

	/*******************************************************************
       Purpose:     Handle Chatter Group Save Errors
    ********************************************************************/
	private void handleChatterGroupSaveErrors(Database.SaveResult result, CollaborationGroup chatterGroup)
	{
		String errorMessage = (new DatabaseErrors('A Problem occured creating chatter group', result.getErrors())).toString();
		System.debug(LoggingLevel.ERROR, errorMessage);
		chatterGroup.addError(errorMessage);
	}

	//Private Variables
	private Map<String, FAU_Program__c> programByName = new Map<String, FAU_Program__c>();

	private static final Boolean ALLOW_PARTIAL_SUCCESS = false;


	/*******************************************************************
       Purpose:     Database Errors Class
    ********************************************************************/
	public class DatabaseErrors
	{
		public DatabaseErrors(String prefix, List<Database.Error> errors)
		{
			this.errors = new List<String>();
			this.errors.add(prefix);
			for(Database.Error databaseError : errors)
			{
				this.errors.add(new DatabaseError(databaseError).toString());
			}
		}

		override public String toString()
		{
			return String.join(this.errors, '\n'); 
		}

		
		private List<String> errors;
	}


	public class DatabaseError
	{

		DatabaseError(Database.Error error)
		{
			this.error = error;
		}

		override public String toString()
		{
			return error.getStatusCode() + ' - ' + error.getMessage();
		}

		private Database.Error error;
	}
}