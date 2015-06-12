public with sharing class isll_SustainExpComponentController {
	private Id groupId;
	public List<SelectOption> selectedUsers { get; set;}
	public string filterText {get;set;}
	private boolean refreshUsers;
	private boolean refreshAllUsersInGroup;
	private boolean isFiltering;
	public  boolean isEditMode {get; set;}
	public boolean SMEMode {get;set;}
	
	public isll_SustainExpComponentController(){
		groupId = isll_ChatterComponentController.isllChatterGroupID;
		
		refreshUsers = true;
		refreshAllUsersInGroup = true;
		isFiltering = false;

	}
	
	private Map<id,User> userMap{
		get{
			if(refreshUsers){
				userMap = new Map<id, User>();
				//so get all user part of the Internal Sustainable Living Lab group
				List<ID> membersInGroupIds = new List<ID>();
				for(CollaborationGroupMember aMember : [select id, MemberId from CollaborationGroupMember where CollaborationGroupId = :groupId]){
					membersInGroupIds.add(aMember.MemberId);
				}
				refreshUsers = false;
				for(User aUser :  [select 	Id, FullPhotoUrl, Name, Sustainability_Expert__c, LocaleSidKey, isll_SME__c 
									from 	User 
									where 	id in :membersInGroupIds 
										and Sustainability_Expert__c = true
										and isActive = true])
				{
					userMap.put(aUser.id, aUser);
				}
			}
			return userMap;			
		}
		set;
	}
	
	public List<ExpertsWrapper> wrappedExperts{
		
		get{
			wrappedExperts = new List<ExpertsWrapper>();
			integer counter = 0;
			for(User aUser: userMap.values()){
				if(aUser.Sustainability_Expert__c){
					boolean isFlipper = false;
					boolean isRowEnd = false;
					counter ++;
					if(counter == 1 || math.mod(counter-1, 6) == 0){
						isFlipper = true;
					}
					if(math.mod(counter+1, 6) == 1){
						isRowEnd = true;
					}
					wrappedExperts.add(new ExpertsWrapper(aUser.FullPhotoUrl,aUser.name, isFlipper, isRowEnd, aUser));
				}
			}
			return wrappedExperts;
		}
		set;
	}
	
	//get users
	public List<SelectOption> allUsersInGroup{
		get{
			if(refreshAllUsersInGroup){
				allUsersInGroup = new List<SelectOption>();
				if(!isFiltering ){
					selectedUsers = new List<SelectOption>();				
				}
				for(User aUser: userMap.values()){
					SelectOption temp = new SelectOption(aUser.id, aUser.Name);
					
					if(!isFiltering &&  ((!SMEMode && aUser.Sustainability_Expert__c) || (SMEMode &&  aUser.isll_SME__c))){
						if(null == selectedUsers){
							selectedUsers = new List<SelectOption>();
						}
						selectedUsers.add(temp);
					}
					else{
						if(String.isNotBlank(filterText)){
							if(temp.getLabel().contains(filterText)){
								allUsersInGroup.add(temp);
							}
						}
						else{
							allUsersInGroup.add(temp);
							
						}
					}
				}
				refreshAllUsersInGroup = false;
				isFiltering = false;
			}
			
			return allUsersInGroup;
		}
		set;
	}
	
	public PageReference updateUsers(){
		refreshAllUsersInGroup = false;
		Set<User> usersToUpdate = new Set<User>();
		//selectedUsers check expert box
		for(Selectoption selectedUser : selectedUsers){
			if(!SMEMode){
				if(!userMap.get(selectedUser.getValue()).Sustainability_Expert__c){
					userMap.get(selectedUser.getValue()).Sustainability_Expert__c = true;
					usersToUpdate.add(userMap.get(selectedUser.getValue()));
				}
			}
			else{
				if(!userMap.get(selectedUser.getValue()).isll_SME__c){
					userMap.get(selectedUser.getValue()).isll_SME__c = true;
					usersToUpdate.add(userMap.get(selectedUser.getValue()));
				}
			}
		}
		
		for(Selectoption selectedUser : allUsersInGroup){
			if(!SMEMode){
				if(userMap.get(selectedUser.getValue()).Sustainability_Expert__c){
					userMap.get(selectedUser.getValue()).Sustainability_Expert__c = false;
					usersToUpdate.add(userMap.get(selectedUser.getValue()));
				}
			}
			else{
				if(userMap.get(selectedUser.getValue()).isll_SME__c){
					userMap.get(selectedUser.getValue()).isll_SME__c = false;
					usersToUpdate.add(userMap.get(selectedUser.getValue()));
				}
			}
		}
		
		if(!usersToUpdate.isEmpty()){
			update new List<User>(usersToUpdate); 
			refreshUsers = true;
		}
		refreshAllUsersInGroup = !refreshAllUsersInGroup;
		
		if(!SMEMode){
			PageReference returnPage =  new PageReference(ApexPages.currentPage().getParameters().get('returnPage'));
			returnPage.setRedirect(true);
			
			return returnPage;
			
		}
		else{
			return null;
		}
	}
	
	public PageReference filter(){
		refreshAllUsersInGroup = true;
		isFiltering = true;
		return null;
	}
	
	public class ExpertsWrapper{
		public string image{get;set;}
		public string name {get;set;}
		public boolean rowFlipper {get;set;}
		public boolean rowEnd {get;set;}
		public User user {get; set;}
		
		public ExpertsWrapper(String image, String name, boolean rowFlipper, boolean rowEnd, User user){
			this.image = image;
			this.name = name;
			this.rowFlipper = rowFlipper;
			this.rowEnd  = rowEnd;
			this.user = user;
		}
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