public with sharing class im_IssueTriggerHandler {

	// Validate that the user can or cannot edit certain fields for Issues on status Reviewed. Logic based on their permission set
	public static void validateIssueChanges(Map<Id,im_Issue__c> oldMap, Map<Id,im_Issue__c> newMap)
	{
		// We only need to run the custom validation if not a system administrator
		if ([Select Name From Profile Where Id = :UserInfo.getProfileId()][0].Name != 'System Administrator')
		{
			// Build a set of what permission sets the current user has assigned to him/her
			Set<String> permissionSetAssignmentsSet = new Set<String>();
			for (PermissionSetAssignment permissionSetAssignment :[Select PermissionSet.Name From PermissionSetAssignment Where AssigneeId = :UserInfo.getUserId()])
			{
				permissionSetAssignmentsSet.add(permissionSetAssignment.PermissionSet.Name);
			}
			
			// If the user doesn't have 1 of the higher permission permission sets, validate the field change
			if (!permissionSetAssignmentsSet.contains('KOFI_CIMT') && !permissionSetAssignmentsSet.contains('KOFI_APP_admin'))
			{
				List<im_Issue__c> issuesList = newMap.values();
				for (im_Issue__c issue :issuesList)
				{
					// Only validate these fields if the status is reviewed
					if (oldMap.get(issue.Id).Issue_Status__c == 'Reviewed' || oldMap.get(issue.Id).Issue_Status__c == 'Submitted')
					{
						// Error change on status
						if (oldMap.get(issue.Id).Issue_Status__c != newMap.get(issue.Id).Issue_Status__c)
						{
							newMap.get(issue.Id).Issue_Status__c.addError('You cannot edit the Issue Status once the issue has been reviewed.');
						}
						
						// Error change on severity
						if (oldMap.get(issue.Id).Issue_Severity__c != newMap.get(issue.Id).Issue_Severity__c)
						{
							newMap.get(issue.Id).Issue_Severity__c.addError('You cannot edit the Issue Severity once the issue has been reviewed.');
						}
						
					}
					
					// These users can never change the owner manually. Only when changing to the CIMT queue (generally via the custom button)
					if (oldMap.get(issue.Id).OwnerId != newMap.get(issue.Id).OwnerId)
					{
						newMap.get(issue.Id).OwnerId.addError('You cannot change the owner of issues. Please contact your administrator if you wish to do so.');
					}

				}
			}
		}
	}

}