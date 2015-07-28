public with sharing class isll_ModeratorComponentController {
	private Id groupId;
	public boolean showModerator {get;set;}
	private List<ID> membersInGroupIds;
	public String newMod {get;set;}
	public boolean isEditMode {get;set;}
	
	public isll_ModeratorComponentController(){
		groupId = isll_ChatterComponentController.isllChatterGroupID;
		
		membersInGroupIds = new List<ID>();	
		for(CollaborationGroupMember aMember : [select id, MemberId from CollaborationGroupMember where CollaborationGroupId = :groupId]){
			membersInGroupIds.add(aMember.MemberId);
		}
		
		if(null == moderator){
			showModerator = false;
		}
		else{
			showModerator = true;	
		}
		
				
	}
	
	public List<SelectOption> listOfPotentialMods{
		get{
			listOfPotentialMods = new List<SelectOption>();
			for(User aUser :usersInGroup){
				listOfPotentialMods.add(new SelectOption(aUser.id, aUser.Name));
			}
			listOfPotentialMods.add(new SelectOption('None', 'None'));
			return listOfPotentialMods;
		}
		set;
	}
	
	public PageReference updateMod(){	
		if('None' == newMod || (null == moderator) || (null != moderator && newMod != moderator.id)){
			List<User> usersToUpdate = new List<User>();
			if( null != newMod && 'None' != newMod){
				User newModUser = new User(id = newMod, is_isll_moderator__c = true);
				usersToUpdate.add(newModUser);
			}
			if(null != moderator){
				usersToUpdate.add(new User(id = moderator.id, is_isll_moderator__c = false ));			
			}
			
			update usersToUpdate;
		}
		
		
		
		PageReference returnPage =  new PageReference(ApexPages.currentPage().getParameters().get('returnPage'));
		returnPage.setRedirect(true);
		
		return returnPage;
	}
	
	public PageReference goBack(){	
		PageReference returnPage =  new PageReference(ApexPages.currentPage().getParameters().get('returnPage'));
		returnPage.setRedirect(true);
		
		return returnPage;
	}
	
	private List<User> usersInGroup{
		get{
			return [select id, FullPhotoUrl, name, Sustainability_Expert__c, is_isll_moderator__c, LocaleSidKey from User where id in : membersInGroupIds and is_isll_moderator__c = true];
		}
		set;
	}
	
	
	public User moderator{
		get{
			for(User aUser :usersInGroup){
				if (aUser.is_isll_moderator__c){
					showModerator = true;
					return aUser;
				}
			}
				showModerator = false;
				return null;
				
		}
		set;
	}
	
	public Boolean isEditable
	{
		get;
		set;
	}
	
	public Boolean getShowEditLink()
	{
		if(isEditable == null)
		{
			isEditable = false;
		}
		
		Boolean res = isEditable && isll_Utility.isCurrentUserAdmin();
		return res;
	}

}