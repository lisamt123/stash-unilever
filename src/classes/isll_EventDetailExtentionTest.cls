/**********************************************************************
 Name:  isll_EventDetailExtentionTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose:the test class for isll_EventDetailExtention                                                     
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Liza Romanenko     13/09/2013        INITIAL DEVELOPMENT          	
 
***********************************************************************/
@IsTest
private class isll_EventDetailExtentionTest {
	
	static testMethod void testSaveEvent(){
		Event__c theEvent = isll_TestData.createEvent();
		insert theEvent;

		Profile prof = [SELECT Id FROM Profile WHERE Name = 'Standard User'];
		User u = isll_TestData.createUser(prof.Id);
		insert u;

		List<Event_Member__c> members = new List<Event_Member__c>();
		Event_Member__c em 	= isll_TestData.createEventMember(u.Id, theEvent.Id, u.Lastname);
		em.Is_Expert__c 	= true;
		members.add(em);
		Event_Member__c em2 = isll_TestData.createEventMember(u.Id, theEvent.Id, u.Lastname);
		em2.Member_Type__c 	= 'Internal';
		members.add(em2);
		Event_Member__c em3 = isll_TestData.createEventMember(u.Id, theEvent.Id, u.Lastname);
		em3.Member_Type__c 	= 'External';
		members.add(em3);
		insert members;
	   	
	   	ApexPages.StandardController sc = new ApexPages.standardController(theEvent);
	   	isll_EventDetailExtention ext = new isll_EventDetailExtention(sc);
	   	
	   	system.assertEquals(0, ext.daysToGo);
	   	system.assertEquals(1, ext.allExperts.size());
	   	system.assertEquals(1, ext.allInternalMembers.size());
	   	system.assertEquals(1, ext.allExternalMembers.size());
	   	
	   	ext.filterExperts();
	   	ext.start();
	   	ext.stop();
	   	ext.joinEvent();
	   	ext.createUniqueVisit();

	   	Integer refreshSections = ext.autoRefreshSeconds;
	   	Boolean showJoinLink 	= ext.showJoinLink;
	   	
	   	ext = new isll_EventDetailExtention();
	}
}