/**********************************************************************
 Name:  isll_EventHandlerTest
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The test class for the isll event handler
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Marc Saelzler     29/10/2013        INITIAL DEVELOPMENT         Due to issue in row 18 of 'Master List for RFC 22 10 13_2'.
 
***********************************************************************/
@IsTest
private class isll_EventHandlerTest
{
	private static Event__c[] x_events;
	private static Carousel__c[] x_carousels;
	
	static private void initData()
	{
		x_carousels = new Carousel__c[]{};
		for(integer i = 0; i < 2; i++)
		{
			Carousel__c tmp_carousel 		= new Carousel__c();
			tmp_carousel.Name 				= 'CarouselTest' + i;
			x_carousels.add(tmp_carousel);
		}
		insert x_carousels;
		
		x_events = new Event__c[]{};
		for(integer i = 0; i < 2; i++)
		{
			Event__c tmp_event 				= isll_TestData.createEvent();
			tmp_event.Chatter_Group_Name__c = 'ChatterTestGroup' + i;
			tmp_event.Event_Carousel__c 	= x_carousels.get(i).id;	
			x_events.add(tmp_event);
		}
		insert x_events;
	}
	
	static testMethod void deleteEvents()
	{
		initData();
		
		Set<Id> tmp_carouselIdSet = new Set<Id>();
		for(Carousel__c tmp_carousel : x_carousels)
		{
			tmp_carouselIdSet.add(tmp_carousel.id);
		}
		
		Set<Id> tmp_eventIdSet = new Set<Id>();
		for(Event__c tmp_event : x_events)
		{
			tmp_eventIdSet.add(tmp_event.id);
		}
		
		delete x_events;
		
		Event__c[] tmp_events = [SELECT Id FROM Event__c WHERE Id IN : tmp_eventIdSet];
		
		system.assert(tmp_events.isEmpty());
		
		Carousel__c[] tmp_carousels = [SELECT Id FROM Carousel__c WHERE Id IN : tmp_carouselIdSet];
		
		system.assert(tmp_carousels.isEmpty());
	}
	
}