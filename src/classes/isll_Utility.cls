/**********************************************************************
 Name:  isll_Utility
 Copyright © 2013  Unilever
======================================================
Purpose:                                                            
Class contains helper methods for isll functionality
======================================================
History
-------
VERSION     AUTHOR              DATE            DETAIL              Description
   1.0      Liza Romanenko      08/08/2013      INITIAL DEVELOPMENT 
***********************************************************************/
public with sharing class isll_Utility {
	
	public static String AdminPermissionSetName = 'isll_CMS_Admin';
	public static String ModeratorPermissionSetName = 'ISLL_Moderator';
	public static String NOT_ARCHIVED_NEWS_AMOUNT_CS = 'NotArchivedNews';
	
	
	public static Id adminPermissionSetId {
		get{
			if(adminPermissionSetId == null){
				try{
					PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = : AdminPermissionSetName];
					adminPermissionSetId = ps.Id;
				} catch(Exception ex) {}
			}
			return adminPermissionSetId;
		} set;
	}
	
	public static Set<Id> moderatorSetIds
	{
		get
		{
			if(moderatorSetIds == null || moderatorSetIds.isEmpty())
			{
				Set<Id> aIds = new Set<Id>();
				
				for(PermissionSetAssignment psa : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :moderatorPermissionSetId])
				{
					aIds.add(psa.AssigneeId);
				}
				
				moderatorSetIds = aIds;
			}
			
			return moderatorSetIds;
		}
		
		set;
	}
	
	public static Set<Id> adminSetIds {
		get{
			if(adminSetIds == null || adminSetIds.isEmpty()){
				Set<Id> aIds = new Set<Id>();
				for(PermissionSetAssignment psa : [SELECT AssigneeId FROM PermissionSetAssignment WHERE PermissionSetId = :adminPermissionSetId]){
					aIds.add(psa.AssigneeId);
				}
				adminSetIds = aIds;
			}
			
			return adminSetIds;
		} set;
	}
	
	public static Id moderatorPermissionSetId
	{
		get
		{
			if(moderatorPermissionSetId == null)
			{
				try
				{
					PermissionSet ps = [SELECT Id FROM PermissionSet WHERE Name = : ModeratorPermissionSetName];
					moderatorPermissionSetId = ps.Id;
				}
				catch(Exception ex) {}
			}
			
			return moderatorPermissionSetId;
		}
		
		set;
	}
	
	public static Boolean isCurrentUserAdmin(){
		return adminSetIds.contains(system.Userinfo.getUserId());
	}
	
	public static Boolean isCurrentUserModerator()
	{
		return moderatorSetIds.contains(system.Userinfo.getUserId());
	}
	
	public static Integer notArchivedNewsAmount {
		get {
			Integer defaultValue = 6;
			ISLL_Custom_Settings__c isllCustomSettings = ISLL_Custom_Settings__c.getInstance(NOT_ARCHIVED_NEWS_AMOUNT_CS);
			if (isllCustomSettings!=null) {
				notArchivedNewsAmount = (isllCustomSettings.Integer_Value__c!=null) ? isllCustomSettings.Integer_Value__c.intValue() : defaultValue;
			} else {
				notArchivedNewsAmount = defaultValue;
			}
			return notArchivedNewsAmount;
		} set;
	}
			
}