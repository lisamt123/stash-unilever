/**********************************************************************
 Name:  isll_EventHandler
 Copyright © 2013  Unilever
 ======================================================
======================================================
Purpose: The trigger handler for the isll Event object.
-------                                                             
======================================================
======================================================
History                                                            
-------                                                            
VERSION  AUTHOR            DATE              DETAIL                      Description
 1.0 -   Marc Saelzler     29/10/2013        INITIAL DEVELOPMENT         Due to issue in row 18 of 'Master List for RFC 22 10 13_2'.
 
***********************************************************************/
public class isll_EventHandler
{
	private Boolean m_isExecuting = false;
	private Integer BatchSize = 0;
	
	/*******************************************************************
       Purpose: Constructor that receives values for the class properties from the trigger and populates them.
    ********************************************************************/
	public isll_EventHandler(Boolean isExecuting, Integer size){
		m_isExecuting = isExecuting;
		BatchSize = size;
	}
	
	/*******************************************************************
       Purpose: Handler method for After Delete event
       Params:  oldMap - Map of Event__c. Corresponds to Trigger.oldMap
    ********************************************************************/	
	public void OnAfterDelete(Map<Id, Event__c> oldMap){
		
		Set<Id> deleteCarouselIdSet = new Set<Id>();
		
		for(Event__c e : oldMap.values()){
			if(e.Event_Carousel__c != null)
			{
				deleteCarouselIdSet.add(e.Event_Carousel__c);
			}
		}
		
		if(!deleteCarouselIdSet.isEmpty())
		{
			Carousel__c[] tmp_deleteCarouselList = [SELECT Id FROM Carousel__c WHERE Id IN : deleteCarouselIdSet];
			
			if(tmp_deleteCarouselList != null && !tmp_deleteCarouselList.isEmpty())
			{
				delete tmp_deleteCarouselList;
			}
		}
	}
}