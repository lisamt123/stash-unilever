/**********************************************************************
 Name:  isll_EventDetailExtention
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:the class for isll_EventDetailExtention. controller extension for the event details page                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Liza Romanenko     13/09/2013        INITIAL DEVELOPMENT          	
 
***********************************************************************/
public without sharing class isll_EventDetailExtention {

	public Event__c theEvent {get; set;}
	public List<User> experts {get; set;}
	public List<User> internalMembers {get; set;}
	public List<User> externalMembers {get; set;}
	public List<User> allExperts {get; set;}
	public List<User> allInternalMembers {get; set;}
	public List<User> allExternalMembers {get; set;}
	
	public Boolean showExperts { get { return !experts.isEmpty(); }	}
	public Boolean showInternalMembers { get { return !internalMembers.isEmpty(); }	}
	public Boolean showExternalMembers { get { return !externalMembers.isEmpty(); }	}
	
	public Boolean showExpertsViewMore { get { return experts.size() < allExperts.size(); }	}
	public Boolean showInternalMembersViewMore { get { return internalMembers.size() < allInternalMembers.size(); }	}
	public Boolean showExternalMembersViewMore { get { return externalMembers.size() < allExternalMembers.size(); }	}
	
	public Integer internalMembersAmount {get; set;}
	public Integer externalMembersAmount {get; set;}
	public Integer totalAmountOfMembers {get; set;}

	public Integer totalVisitCount 		{get;set;}
	public Integer totalPostCount 		{get;set;}
	public Integer totalCommentCount 	{get;set;}
	
	public String filter {get; set;}

	public Attachment headerImage{get; set;}
	
	public Boolean isChatterGroupExists{get; set;}
	
	public Integer daysToGo {
		get{
			return Date.today().daysBetween(theEvent.Start_Date_Time__c.date());
		}
	}
	
	public Boolean isCurrentUserModerator{get{return isll_Utility.isCurrentUserModerator();}}
	
	public boolean showJoinLink {
		get{//check if user is already a part of the event, if not then show the join me link
			List<Event_Member__c> members = [select id from  Event_Member__c where User__c = :UserInfo.getUserId() and Event__c = :theEvent.id];
			if(members.size() == 1){
				showJoinLink = false;
			}
			else{
				showJoinLink = true;
			}
			return showJoinLink;
		}
		set;}
		
	public Integer autoRefreshSeconds {get {
		Integer defaultRefreshValue = 20;
		ISLL_Custom_Settings__c isllCustomSettings = ISLL_Custom_Settings__c.getInstance('autoRefreshLiveEventPageTimer');
		if (isllCustomSettings!=null) {
		autoRefreshSeconds = (isllCustomSettings.Integer_Value__c!=null) ? isllCustomSettings.Integer_Value__c.intValue() : defaultRefreshValue;
		} else {
			autoRefreshSeconds = defaultRefreshValue;
		}
		return autoRefreshSeconds;
	} set;}

	public isll_EventDetailExtention(){
	}
	public isll_EventDetailExtention(ApexPages.StandardController standardController) {
		theEvent = (Event__c) standardController.getRecord();
		theEvent = [select 	Start_Date_Time__c, End_Date_Time__c, Chatter_Group_Name__c, IsStarted__c,
							(select id, name from Attachments) 
					from 	Event__c where id = :theEvent.id ];
		
		//get event members
		allExperts = new List<User>();
		allInternalMembers = new List<User>();
		allExternalMembers = new List<User>();
		
		for(Event_Member__c aMember : [ select id, name, User__c, User__r.Name, User__r.SmallPhotoUrl, User__r.FullPhotoUrl, User__r.LocaleSidKey, 
											Event__c, Is_Expert__c, Member_Type__c 
										from Event_Member__c 
										where Event__c = :theEvent.id order by User__r.Name]){
			
			if(aMember.Is_Expert__c){
				allExperts.add(aMember.User__r);
			} else if (aMember.Member_Type__c == 'Internal'){
				allInternalMembers.add(aMember.User__r);
			} else if (aMember.Member_Type__c == 'External'){
				allExternalMembers.add(aMember.User__r);
			}
		}
		
		experts = new List<User>();
		internalMembers = new List<User>();
		externalMembers = new List<User>();
		
		Integer size = allExperts.size() > 6 ? 6 : allExperts.size();
		for(Integer i = 0; i < size; i++){
			experts.add(allExperts[i]);
		}
		
		size = allInternalMembers.size() > 9 ? 9 : allInternalMembers.size();
		for(Integer i = 0; i < size; i++){
			internalMembers.add(allInternalMembers[i]);
		}
		
		size = allExternalMembers.size() > 6 ? 6 : allExternalMembers.size();
		for(Integer i = 0; i < size; i++){
			externalMembers.add(allExternalMembers[i]);
		}

		if(null != theEvent.Attachments && theEvent.Attachments.size() > 0){
			for(Attachment att : theEvent.Attachments){
				if(att.name.contains('Header')){
					headerImage = att;
					break;
				}
			}	
		}
		
		internalMembersAmount = allInternalMembers.size();
		externalMembersAmount = allExternalMembers.size();
		totalAmountOfMembers = allExperts.size() + allInternalMembers.size() + allExternalMembers.size();
		
		//check if Chatter Group exists
		isChatterGroupExists = true;
		List<CollaborationGroup> newChatterGroupName = [select Name from CollaborationGroup where id = :theEvent.Chatter_Group_Name__c];
		if(newChatterGroupName.isEmpty()){
			isChatterGroupExists = false;
		}

		countVisitsPostsComments();
	}
	
	public PageReference filterExperts(){
		return null;
	}
	
	public void start(){
		theEvent.IsStarted__c = true;
		update theEvent;
	}
	
	public void stop(){
		theEvent.IsStarted__c = false;
		update theEvent;
	}

	public PageReference joinEvent(){
		CollaborationGroupMember newMember;
		//add current user to chatter group
		//check if user is not in chatter group already
		List<CollaborationGroupMember> foundUsers = [select id from CollaborationGroupMember where CollaborationGroupId = : theEvent.Chatter_Group_Name__c and MemberId = : UserInfo.getUserId()];
		if(foundUsers.size()  == 0){
			newMember = new CollaborationGroupMember(CollaborationGroupId = theEvent.Chatter_Group_Name__c, MemberId = UserInfo.getUserId());
		}
		
		

		//add current user as a group memeber
		Event_Member__c eventMember = new Event_Member__c (Name = UserInfo.getName(),  User__c = UserInfo.getUserId(), Event__c = theEvent.id);

		SavePoint sp = Database.setsavepoint();
		try{
			if(null != newMember){
				insert newMember;
			}
			insert eventMember;	
		}
		catch (Exception e){
			ApexPages.Message errorMsg = new ApexPages.Message(ApexPages.Severity.ERROR,e.getMessage());
			ApexPages.addMessage(errorMsg);
			Database.rollback(sp);

		}
		PageReference ret = Page.isll_EventsDetail;
		ret.getParameters().put('id', theEvent.id);
		ret.setRedirect(true);

		system.debug(ret.getUrl());
		return  ret;

	}

	// Method fired on page load to add a unique visit if during the time of the event
	public void createUniqueVisit()
	{
		// Only count the visit if within 30 minutes before, during or 30 minutes after the event time
		if (system.now().addMinutes(30) >= theEvent.Start_Date_Time__c && system.now().addMinutes(-30) <= theEvent.End_Date_Time__c)
		{
			// Create a set of unique usernames
			Set<String> existingUsernames = new Set<String>();
			for (isll_Event_Visit__c existingVisit :[Select Name From isll_Event_Visit__c Where Event__c = :theEvent.Id])
			{
				existingUsernames.add(existingVisit.Name);
			}

			// Only create a new record if the user doesn't exist
			if (!existingUsernames.contains(UserInfo.getUserName()))
			{
				try
				{
					insert new isll_Event_Visit__c(
						Name 		= UserInfo.getUserName(),
						Event__c 	= theEvent.Id
					);
				}
				catch (Exception ex)
				{
					system.debug('### Error creating visit record: ' + ex);
				}
				
			}
		}
	}

	// Count the total number of Chatter posts and comments in the event
	public void countVisitsPostsComments()
	{
		// Get the total visit count. This is a separate query than the main event query, because we need to 
		// re-calculate it during the lifecycle of the page
		try
		{
			totalVisitCount = integer.valueOf([Select Total_Unique_Visits__c From Event__c Where Id = :theEvent.Id][0].Total_Unique_Visits__c);
		}
		catch (Exception ex)
		{
			totalVisitCount = 0;
		}

		// Count chatter post and comments
		if (theEvent.Chatter_Group_Name__c != null)
		{
			try
			{
				// Winter '14: It is not possible to use aggregate functions on FeedItem, so having to calculate numbers using standard SPQ:
				List<FeedItem> chatterPosts = [Select Id, CommentCount From FeedItem Where ParentId = :theEvent.Chatter_Group_Name__c];
				totalPostCount 		= chatterPosts.size();
				totalCommentCount 	= 0;
				for (FeedItem chatterPost :chatterPosts)
				{
					totalCommentCount = totalCommentCount + chatterPost.CommentCount;
				} 
			}
			// For any errors, default to 0
			catch (Exception ex)
			{
				totalPostCount 		= 0;
				totalCommentCount 	= 0;
				system.debug('### Error calculating posts and comments: ' + ex);
			}
		}
		// If no Chatter group, default to 0
		else 
		{
			totalPostCount 		= 0;
			totalCommentCount 	= 0;
		}
	}

	
}