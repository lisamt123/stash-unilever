/*
	Unilever

	Class Name: AR_AgencyMyProfileEditGeography

	Created by: Jan Schwetasch | 2013-09-20

	Description: 

	Timeline
	Date 					| Name 				| Description
	2013-09-20				| Jan Schwetasch 	| Initial development.
*/

public with sharing class AR_AgencyMyProfileEditGeography {
	public AR_SObjectHolder geographyObject {get;set;}
	public List<AR_SObjectHolder> geographyObjectList {get;set;}
	public Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap {get;set;}
	public Id x_AccountID { get;set; }
	
	public AR_AgencyMyProfileEditGeography() {
		this.geographyObject = new AR_SObjectHolder(getCleanGeographyObject());
		this.geographyObjectList = new List<AR_SObjectHolder>();
	}
	public void InitPage()
	{
		loadMyFieldSets();
		loadMyData();
	}
	
	private void loadMyFieldSets() {
		fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
		fieldSetMap.put('ar_Geography__c',AR_MetaDataHandler.GetAllGeographyFieldsets());
	}
	
	public void loadMyData() {
		x_AccountID =  (ID)ApexPages.currentPage().getParameters().get('Id');
		List<AR_SObjectHolder> tmp_DataList = new List<AR_SObjectHolder>();
		Set<String> tmp_FieldSet =  AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Geography__c'));
		
		String query = 'SELECT ';
		
		tmp_FieldSet.add('Name');
		//tmp_FieldSet.add('Id');
		
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Geography__c where Agency__c  = :x_AccountID ';
			
		for(ar_Geography__c Data:Database.query(query))
		{
			tmp_DataList.add(new AR_SObjectHolder(Data));
		}
		geographyObjectList = tmp_DataList;
	}
	
	public void saveMyData() {
		system.debug(logginglevel.info, '### Saving geo...');
		
		// geo
		List<ar_Geography__c> toUpsert = new List<ar_Geography__c>();
		List<ar_Geography__c> toDelete = new List<ar_Geography__c>();
		for(AR_SObjectHolder geo : geographyObjectList) {
			if(geo.getId() != null && geo.getIsDeleted())
				toDelete.add((ar_Geography__c)geo.obj);
			else {
				ar_Geography__c geo2 = (ar_Geography__c)geo.obj;
				geo2.name = geo2.Country__c;
				toUpsert.add(geo2);
			}
		}
		system.debug(logginglevel.info, 'Upserting geo...');
		upsert toUpsert;
		system.debug(logginglevel.info, 'Deleting geo...');
		delete toDelete;
	}
	private ar_Geography__c getCleanGeographyObject() {
		return new ar_Geography__c(Agency__c = x_AccountID,Local_office_working_with_UL_today__c=false);
	}
	
	public PageReference addNewGeographyObject() {
		geographyObjectList.add(geographyObject);
		GeographyObject = new AR_SObjectHolder(getCleanGeographyObject());
	  
		return null;
	}
}