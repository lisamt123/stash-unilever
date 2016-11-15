/**********************************************************************

 Name:  OV_KpiElementHandler()

 Copyright © 2015  Salesforce

 ======================================================

======================================================

Purpose:  	Trigger Handler for the OV_KPI_Element__c SObject. This class implements the OV_Trigger
			interface to help ensure the trigger code is bulkified and all in one place.
-------                                                            

======================================================

======================================================

History                                                            

-------                                                            

VERSION  AUTHOR            DATE              DETAIL            Description

1.0   Pawel Niedziela    24/09/2015      INITIAL DEVELOPMENT   Trigger Handler for the OV_KPI_Element__c SObject. 

***********************************************************************/
public with sharing class OV_KpiElementHandler implements OV_Trigger{
	
	List<OV_KPI_Element_Interest__c> kpiElementInterests = new List<OV_KPI_Element_Interest__c>();
	Map<Id, List<OV_KPI_Element_Interest__c> > elementIdToInterests = new Map<Id, List<OV_KPI_Element_Interest__c>>();
	List<List<ConnectApi.BatchInput>> listOfPacs = new List<List<ConnectApi.BatchInput>>();
	List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();
	
	// Constructor
	public OV_KpiElementHandler(){
		
	}

	/*******************************************************************

		Purpose:  This method is called prior to execution of a BEFORE trigger. Use this to cacheany data required into maps prior execution of the trigger.  
		
		Parameters: [optional]

		Returns: [optional]

		Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void bulkBefore(){
		
	}
	
	
	/*******************************************************************

		Purpose:  This method is called prior to execution of an AFTER trigger. Use this to cache any data required into maps prior execution of the trigger. 
		
		Parameters: [optional]

		Returns: [optional]

		Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void bulkAfter(){
		
		System.debug('Entering bulkAfter');
		
		if(Trigger.isUpdate){
			initKpiElementInterests();
		}
		
		System.debug('Exiting bulkAfter' );
	}
		
	
	/*******************************************************************

	   Purpose:  This method is called iteratively for each record to be inserted during a BEFORE trigger. Never execute any SOQL/SOSL etc in this and other iterative methods.                                      
	
	   Parameters: [SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void beforeInsert(SObject so){
		
	}
	
	
	/*******************************************************************

	   Purpose: This method is called iteratively for each record to be updated during a BEFORE trigger.                
	
	   Parameters: [SObject, SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void beforeUpdate(SObject oldSo, SObject so){
		
	}
	
	
	/*******************************************************************

	   Purpose: This method is called iteratively for each record to be deleted during a BEFORE trigger.
	
	   Parameters: [SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void beforeDelete(SObject so){	

	}
	
	
	/*******************************************************************

		Purpose: This method is called iteratively for each record inserted during an AFTER
		trigger. Always put field validation in the 'After' methods in case another trigger
		has modified any values. The record is 'read only' by this point.
	
	   Parameters: [SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void afterInsert(SObject so){
		
	}
	
	
	/*******************************************************************

		Purpose: This method is called iteratively for each record updated during an AFTER trigger.
	
	   Parameters: [SObject, SObject]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void afterUpdate(SObject oldSo, SObject so){
		
		System.debug('Entering afterUpdate: ' + ' oldSo: ' + oldSo + ' so: ' + so);
		
		OV_KPI_Element__c kpiElement = (OV_KPI_Element__c)so;
		//List<ConnectApi.BatchInput> batchInputs = new List<ConnectApi.BatchInput>();

		if(elementIdToInterests.containsKey(kpiElement.Id)){
			List<OV_KPI_Element_Interest__c> eList = elementIdToInterests.get(kpiElement.Id);

			for(OV_KPI_Element_Interest__c e : eList){

				ConnectApi.FeedItemInput input = createKpiUpdateNotification(e);

				ConnectApi.BatchInput batchInput = new ConnectApi.BatchInput(input);
				batchInputs.add(batchInput);         
			}
		}
		
		System.debug('Exiting afterUpdate' );
	}
	
	
	/*******************************************************************

		Purpose: This method is called iteratively for each record deleted during an AFTER trigger.
	
	   Parameters: [SObject ]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void afterDelete(SObject so){
		
	}
	
	
	/*******************************************************************

		Purpose: This method is called iteratively for each record undeleted during an AFTER trigger.
	
	   Parameters: [SObject ]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void afterUndelete(SObject so){
		
	}
	
	/*******************************************************************

		Purpose: This method is called once all records have been processed by the trigger. Use this 
					method to accomplish any final operations such as creation or updates of other records.
	
	   Parameters: [SObject ]
	
	   Returns: [void]
	
	   Throws [Exceptions]: [optional]                                                          

 	********************************************************************/
	public void andFinally(){	
		
		System.debug('Entering andFinally');
		
		List<ConnectApi.BatchInput> pack = new List<ConnectApi.BatchInput>();
		if( batchInputs.size()>0 ){
		    for(Integer j = 0 ; j < batchInputs.size() ; j++){
		        pack.add(batchInputs[j]);
		        if( j > 0  && Math.mod(j, 500) == 0 ){
		            listOfPacs.add(pack);
		            pack = new List<ConnectApi.BatchInput>();
		        }
		    }
		    if(pack.size() < 500){
		        listOfPacs.add(pack);
		    }
			Integer dmlLimit = Limits.getLimitDmlStatements();
			for(List<ConnectApi.BatchInput> p : listOfPacs){
		        if(Limits.getDmlStatements() < dmlLimit){
		            ConnectApi.ChatterFeeds.postFeedElementBatch(Network.getNetworkId(), p);
		        }
		    }
		}
		
		System.debug('Exiting andFinally' );
	}
	
	
	/*******************************************************************

		Purpose: Gathers KPI Elements to KPI Element Interests map                                                     

		Parameters: [optional]

		Returns: [void]

		Throws [Exceptions]: [optional]                                                          

	********************************************************************/
	private void initKpiElementInterests(){
		
		System.debug('Entering initKpiElementInterests');
		
		Set<Id> kpiElementIds = new Set<Id>(); 
		   
        for(Integer i = 0 ; i< Trigger.new.size() ; i++){
            OV_KPI_Element__c newRecord = (OV_KPI_Element__c)Trigger.new[i];
            kpiElementIds.add(newRecord.Id);
        }
        
        kpiElementInterests = [SELECT Id, KPI_Element__c, User__r.User__c, Wants_Notifications__c, Chatter_Message__c FROM OV_KPI_Element_Interest__c WHERE KPI_Element__c IN :kpiElementIds AND Wants_Notifications__c = true];
        
		for(OV_KPI_Element_Interest__c interest : kpiElementInterests){
            if(elementIdToInterests.containsKey(interest.KPI_Element__c)){
                List<OV_KPI_Element_Interest__c> interests = elementIdToInterests.get(interest.KPI_Element__c);
                interests.add(interest);
            }else{
                List<OV_KPI_Element_Interest__c> interests = new List<OV_KPI_Element_Interest__c>();
                interests.add(interest);
                elementIdToInterests.put(interest.KPI_Element__c, interests);
            }            
        }
        
        System.debug('Exiting initKpiElementInterests' );
	}
	
	
	/*******************************************************************

		Purpose: Creates Chatter Feed Item which will be posted.                                            

		Parameters: [OV_KPI_Element_Interest__c interest]

		Returns: [ConnectApi.FeedItemInput]

		Throws [Exceptions]: [optional]                                                          
	
	********************************************************************/
	private ConnectApi.FeedItemInput createKpiUpdateNotification(OV_KPI_Element_Interest__c interest) {
		
		System.debug('Entering createKpiUpdateNotification: ' + ' interest ' + interest);

        ConnectApi.FeedItemInput input = new ConnectApi.FeedItemInput();
        input.subjectId = interest.Id;

        ConnectApi.MessageBodyInput body = new ConnectApi.MessageBodyInput();
        body.messageSegments = new List<ConnectApi.MessageSegmentInput>();

        ConnectApi.MentionSegmentInput mentionSegment = new ConnectApi.MentionSegmentInput();
        mentionSegment.id = interest.User__r.User__c;
        body.messageSegments.add(mentionSegment);

        ConnectApi.TextSegmentInput textSegment = new ConnectApi.TextSegmentInput();
        textSegment.text = '\n ' + interest.Chatter_Message__c;

        body.messageSegments.add(textSegment);

        input.body = body;
        
        System.debug('Exiting createKpiUpdateNotification: ' + input );

        return input;
    }
}