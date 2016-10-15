/**********************************************************************
 Name:  isll_EventControllerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:the test class for isll_EventController                                                        
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Shyam Bhundia     27/08/2013        INITIAL DEVELOPMENT         Story id:USLL-55  	
 
***********************************************************************/
@IsTest
private class isll_EventControllerTest {
	
	
	static testMethod void testSaveEvent(){
		Event__c theEvent = isll_TestData.createEvent();

	    ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    controller.newChatterGroupName = 'Test chatter group_INTEST';

	    Test.startTest();
	   		controller.save();
	    Test.stopTest();
	    
	    system.debug(ApexPages.getMessages());
	   	List<Event__c> insertedEvents  = [select id, name from Event__c where name = : theEvent.Name];

	   	system.assertEquals(1,insertedEvents.size());
	   	system.assertEquals(1, [select id from CollaborationGroup where name = 'Test chatter group_INTEST'].size());
	}

	static testMethod void testUpdateAttachmentEvent(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

		Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Attachment attachment = isll_TestData.createAttachment(theEvent.id) ;
    	attachment.Name = 'attachment Old_Header';
    	insert attachment;

	    ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    controller.newChatterGroupName = 'Test chatter group_INTEST';

	    controller.attachment.Name = 'attachment';
		controller.attachment.Body =  Blob.valueOf('attach body');

	    Test.startTest();
	   		controller.save();
	    Test.stopTest();
	    
	    List<Attachment> relatedAttachments = [select id from Attachment where parentId = : theEvent.id];

	    system.assertEquals(1, relatedAttachments.size());
	   	
	}


	static testMethod void testSaveEventError(){
		Event__C theEvent = new Event__c();
		theEvent.Event_Description__c = 'Test Description';

	    ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    controller.newChatterGroupName = 'Test chatter group_INTEST';

	    Test.startTest();
	   		controller.save();
	    Test.stopTest();

	   	List<Event__c> insertedEvents  = [select id, name from Event__c where name = : theEvent.Name];

	   	system.assertEquals(0,insertedEvents.size());
	   	system.assertEquals(0, [select id from CollaborationGroup where name = 'Test chatter group_INTEST'].size());
	   	system.assertEquals(2,ApexPages.getMessages().size());
	}
	
	static testMethod void testAttendeeEmails(){
	    CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'Standard User'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

		List<Event_Member__c> membersToInsert = new List<Event_Member__c>();

		for(User aUser : usersToInsert){
			membersToInsert.add(isll_TestData.createEventMember(aUser.Id, theEvent.Id, aUser.Lastname));
		}

		for(integer i = 0; i < 5; i++){
			membersToInsert[i].Member_Type__c = 'External';
		}
		insert membersToInsert;

		ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);

		test.startTest();
			String attendeeEmails = controller.attendeeEmails;
			List<SelectOption> expertsList = controller.potentialExpertUserList;
		test.stopTest();

		system.assert(String.isNotBlank(attendeeEmails));
		List<String> splitAddresses = attendeeEmails.split(', ');
		system.assertEquals(5, splitAddresses.size());

		system.assert(String.isNotBlank(controller.externalAttendeeEmails));
		List<String> splitExAddresses = controller.externalAttendeeEmails.split(', ');
		system.assertEquals(5, splitExAddresses.size());

		system.assertEquals(10, expertsList.size());

	}

	static testMethod void testUserList(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'Standard User'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

		ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    controller.search = 'LastName';

		test.startTest();
		List<SelectOption> userList = controller.userList;
		test.stopTest();

		system.assertEquals(10, userList.size());

	}


	static testMethod void testAddInternalUser(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'Standard User'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

		ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    controller.search = 'LastName';

	    controller.selectedUsers.add(controller.userList[0]);
	    controller.selectedUsers.add(controller.userList[1]);


		test.startTest();
			controller.addMembersToGroup();
		test.stopTest();

		List<Event_Member__c> eventMembers = [select id from Event_Member__c where Event__c = :theEvent.id];

		system.assertEquals(2, eventMembers.size());
	}

	static testMethod void testRemoveInternalUser(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'Standard User'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

	    List<Event_Member__c> toAdd = new List<Event_Member__c>();
	    toAdd.add(isll_TestData.createEventMember(usersToInsert[0].id, theEvent.Id, usersToInsert[0].LastName));
		toAdd.add(isll_TestData.createEventMember(usersToInsert[1].id, theEvent.Id, usersToInsert[1].LastName));
	    insert toAdd;

	    List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();
	    groupMembers.add(isll_TestData.createCollaborationGroupMember(usersToInsert[0].id, grp.Id));
	    groupMembers.add(isll_TestData.createCollaborationGroupMember(usersToInsert[1].id, grp.Id));
	    insert groupMembers;

	    ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    controller.search = 'LastName';

	    system.debug('controller.selectedUsers1: '+controller.selectedUsers);
	    controller.selectedUsers.remove(0);
	    system.debug('controller.selectedUsers2: '+controller.selectedUsers);
	    //controller.selectedUsers.add(new SelectOption(controller.userList[0].getValue(), 'name'));

		test.startTest();
			controller.addMembersToGroup();
		test.stopTest();

		List<Event_Member__c> eventMembers = [select id from Event_Member__c where Event__c = :theEvent.id];

		system.assertEquals(1, eventMembers.size());
	}

	static testMethod void testExternalUserList(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'ISLL External Event Member'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

		ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);

		test.startTest();
		List<SelectOption> userList = controller.externalUserList;
		test.stopTest();

		system.assert(userList.size() >= 10);

	}

	static testMethod void testAddExternalUser(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'ISLL External Event Member'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

		ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);

	    controller.selectedExternalUsers.add(controller.externalUserList[0]);
	    controller.selectedExternalUsers.add(controller.externalUserList[1]);

		test.startTest();
			controller.addExternalMemberToGroup();
		test.stopTest();

		List<Event_Member__c> eventMembers = [select id from Event_Member__c where Event__c = :theEvent.id and Member_Type__c = 'External'];

		system.assertEquals(2, eventMembers.size());
	}

	static testMethod void testRemoveExternalUser(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'Standard User'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

	    List<Event_Member__c> toAdd = new List<Event_Member__c>();
	    Event_Member__c em1 = isll_TestData.createEventMember(usersToInsert[0].Id, theEvent.Id, usersToInsert[0].LastName);
	    em1.Member_Type__c	= 'External';
	  	toAdd.add(em1);
	  	Event_Member__c em2 = isll_TestData.createEventMember(usersToInsert[1].Id, theEvent.Id, usersToInsert[1].LastName);
	    em2.Member_Type__c	= 'External';
	  	toAdd.add(em2);
	    insert toAdd;

	    List<CollaborationGroupMember> groupMembers = new List<CollaborationGroupMember>();
	    groupMembers.add(isll_TestData.createCollaborationGroupMember(usersToInsert[0].id, grp.Id));
	    groupMembers.add(isll_TestData.createCollaborationGroupMember(usersToInsert[1].id, grp.Id));
	    insert groupMembers;

	    ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);

	    controller.selectedExternalUsers.remove(0);

		test.startTest();
			controller.addExternalMemberToGroup();
		test.stopTest();

		List<Event_Member__c> eventMembers = [select id from Event_Member__c where Event__c = :theEvent.id and Member_Type__c = 'External'];

		system.assertEquals(1, eventMembers.size());
	}

	static testMethod void testAddExpert(){
		CollaborationGroup grp = isll_TestData.createChatterGroup('Test chatter group');              
	    insert grp;

	    Event__c theEvent = isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		theEvent.Chatter_Group_Name__c = grp.id;
		insert theEvent;

		Profile prof = [select id from Profile where name = 'Standard User'];
		List<User> usersToInsert = isll_TestData.createBulkUser(prof.Id, 10);
		insert usersToInsert;

		List<Event_Member__c> membersToInsert = new List<Event_Member__c>();

		for (User aUser : usersToInsert) {
			membersToInsert.add(isll_TestData.createEventMember(aUser.Id, theEvent.Id, aUser.Lastname));
		}

		for (integer i = 0; i < 5; i++) {
			membersToInsert[i].Member_Type__c = 'External';
		}
		insert membersToInsert;

		ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	    isll_EventController controller = new isll_EventController(sc);
	    system.debug('controller.potentialExpertUserList: '+controller.potentialExpertUserList);
	    controller.updatePotentialExpertUserList = false;
		controller.expertUserList.add(controller.potentialExpertUserList[0]);
	    controller.expertUserList.add(controller.potentialExpertUserList[1]);

	    system.debug('poten size b: '+controller.potentialExpertUserList.size());
	    controller.potentialExpertUserList.remove(0);
	    controller.potentialExpertUserList.remove(0);
	    system.debug('poten size a: '+controller.potentialExpertUserList.size());


		test.startTest();
			controller.addExpertsToGroup();
		test.stopTest();

		List<Event_Member__c> eventMembers = [select id from Event_Member__c where Event__c = :theEvent.id and Is_Expert__c = true];

		system.assertEquals(2, eventMembers.size());

	}

	static testMethod void testCalendarFunctionality(){
		List<Event__c> events = new List<Event__c>();
		
		Event__c ev1 	= isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		events.add(ev1);
		Event__c ev2 	= isll_TestData.createEvent(datetime.now().addMonths(2),datetime.now().addMonths(2));
		events.add(ev2);
		Event__c ev3 	= isll_TestData.createEvent(datetime.now().addMonths(3),datetime.now().addMonths(3));
		events.add(ev3);
		Event__c ev4 	= isll_TestData.createEvent(datetime.now().addMonths(-1),datetime.now().addMonths(-1));
		events.add(ev4);
		insert events;
		
		isll_EventController controller = new isll_EventController();
		Map<String,List<Event__c>> calendar = controller.calendar;
		system.assertEquals(3, calendar.size());
		
		List<Event__c> pastEvents = controller.pastEvents;
		system.assertEquals(1, pastEvents.size());
		
		pastEvents = controller.allPastEvents;
		system.assertEquals(1, pastEvents.size());
		
		List<String> selectedMonthes = controller.selectedMonths;
		system.assertEquals(3, selectedMonthes.size());
		
		system.assert(!controller.showPrewBtn);
		
		Apexpages.currentPage().getParameters().put('month', controller.currentMonth);
		Apexpages.currentPage().getParameters().put('year', controller.currentYear);
		controller.nextMonth();
		Integer nextMonth = Date.today().month() != 12 ? Date.today().month() + 1 : 1;
		system.assertEquals(nextMonth, controller.currentDate.month());
		
		system.assert(controller.showPrewBtn);
		
		Apexpages.currentPage().getParameters().put('month', controller.currentMonth);
		Apexpages.currentPage().getParameters().put('year', controller.currentYear);
		controller.prewMonth();
		system.assertEquals(Date.today().month(), controller.currentDate.month());
	
	}
	
	static testMethod void testLiveEvents(){
		List<Event__c> events = new List<Event__c>();
		
		Event__c ev1 	= isll_TestData.createEvent(datetime.now().addMonths(1),datetime.now().addMonths(1));
		events.add(ev1);
		Event__c ev2 	= isll_TestData.createEvent(datetime.now().addMonths(-1),datetime.now().addMonths(1));
		events.add(ev2);
		insert events;
		
		isll_EventController controller = new isll_EventController();
		List<Event__c> liveEvents = controller.liveEvents;
		system.assertEquals(1, liveEvents.size());
	}
}