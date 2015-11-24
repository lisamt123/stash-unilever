global class cp_EventApproval {

	private static String result;

	// Method to submit the event for approval in Apex
	// Required to enable approval to be done within an iFrame.
	webservice static String approveEvent(Id eventId) 
	{
		// Validate that a planner is invited.
		try
		{
			// Query for child planner locations.
			cp_Event__c plannerEvent = queryEvent(eventId);

			// Validate the event is valid for approval. If not, return the error messages
			validateEvent(plannerEvent, true);
			if (result != null)
			{
				return result;
			}

			// Submit the record for approval
			Approval.ProcessSubmitRequest approvalRequest = new Approval.ProcessSubmitRequest();
			approvalRequest.setComments('Submitting request for approval.');
			approvalRequest.setObjectId(eventId);
			Approval.ProcessResult approvalResult = Approval.process(approvalRequest);

			// If success, return success to the Custom Button
			if (approvalResult.isSuccess())
			{
				return 'success';
			}
			// Else return the rror which is alerted to the user
			else
			{
				return string.valueOf(approvalResult.getErrors());
			}
			
		}
		// Catch any query or approval errors
		catch (Exception ex)
		{
			return string.valueOf(ex);
		}
	}

	webservice static String saveToPlanner(Id eventId)
	{
		// Validate that a planner is invited.
		try
		{
			// Query for child planner locations.
			cp_Event__c plannerEvent = queryEvent(eventId);

			// Validate the event is applicable for Save to Planner
			validateEvent(plannerEvent, false);
			if (result != null)
			{
				return result;
			}
			
			// Set event to confirmed
			plannerEvent.Activity_Status__c =  plannerEvent.Are_Dates_Guarenteed__c == 'Yes' ? cp_PlannerUtility.CONFIRMED : cp_PlannerUtility.TENTATIVE;
			plannerEvent.RecordTypeId 		= [Select Id From RecordType Where DeveloperName = 'EventApproved'][0].Id;
			update plannerEvent;

			return 'success';

		}
		catch (Exception ex)
		{
			return string.valueOf(ex);
		}
	}

	// Run approval entry validations on the event
	private static void validateEvent(cp_Event__c plannerEvent, Boolean isApproval)
	{
		if (isApproval)
		{
			if (plannerEvent.Local_or_Global__c != 'Global')
			{
				addError(Label.cp_GlobalApprovalError);
			}

			if (plannerEvent.Activity_Status__c != 'Offline')
			{
				addError('The event must have a Submission Status of Offline.');
			}

		}
		else
		{
			if (plannerEvent.Local_or_Global__c != 'Local')
			{
				addError(Label.cp_LocalSaveError);
			}

			if (plannerEvent.Activity_Status__c == cp_PlannerUtility.CONFIRMED)
			{
				addError('The event is already Confirmed.');
			}

		}

		if (plannerEvent.Planner_Locations__r.size () == 0)
		{
			addError(Label.cp_NoPlannerSelected);
		} 
		else 
		{
			// Check that central planners have been selected for Central users
			Boolean hasCentral = false;
			for (cp_PlannerLocation__c curr : plannerEvent.Planner_Locations__r) 
			{
				if (curr.Planner__r.Type__c == 'Central')
				{
					hasCentral = true;
					break;
				}
			}
			Profile p = [SELECT Name from Profile WHERE Id =:UserInfo.getProfileId()];
			if (p.Name.contains('Central') && !hasCentral) 
			{
				addError(Label.cp_NoPlannerSelected);
			}
		}

	}

	// Append all messages into a  string to display all errors to the user if applicable
	private static void addError(String errorMessage)
	{
		if (result == null)
		{
			result = Label.cp_DefaultSubmitWarning + '\n- ' + errorMessage;
		}
		else
		{
			result += '\n- ' + errorMessage;
		}
	}

	private static cp_Event__c queryEvent(Id eventId)
	{
		return [Select 	Id
						, Activity_Status__c
						, Are_Dates_Guarenteed__c
						, Local_or_Global__c, 
						(Select Id, Planner__r.Type__c From Planner_Locations__r)
				From 	cp_Event__c 
				Where 	Id = :eventId];
	}	
}