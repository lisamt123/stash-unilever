/*
	Unilever

	Class Name: AR_FinancialsController

	Created by: Sebastian Ortiz | 2013-09-15

	Description: Controller for the page AR_Financials.

	Timeline
	Date 					| Name 				| Description
	2013-09-15 17:28 (CET)	| Marc Saelzler 	| Initial development.
*/
public with sharing class AR_FinancialsController extends AR_ApplicationBaseController {
	public AR_SObjectHolder applicationObject {get;set;}
	public List<AR_SObjectHolder> financialObjectList {get;set;}
	public List<AR_SObjectHolder> competitorObjectList {get;set;}
	
	public AR_FinancialsController() {
		this.applicationObject = new AR_SObjectHolder();
		this.financialObjectList = new List<AR_SObjectHolder>();
		this.competitorObjectList = new List<AR_SObjectHolder>();
	}
	
	private void loadMyFieldSets() {
		fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
		fieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
		fieldSetMap.put('ar_Financial__c',AR_MetaDataHandler.GetAllFinancialFieldsets());
		fieldSetMap.put('ar_Competitor__c',AR_MetaDataHandler.GetAllCompetitorFieldsets());
	}
	
	public void loadMyData() {
		AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
		
		// application
		Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
		if(tmp_AppFields != null)
			applicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
		
		// financials
		Set<String> tmp_FieldsFinancialObject = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Financial__c'));
		if(tmp_FieldsFinancialObject != null) {
			financialObjectList = tmp_DataHandler.SelectFinancial(tmp_FieldsFinancialObject);
		}
		system.debug(logginglevel.info, 'FINANCIALS QUERIED: ' + financialObjectList);
		if(financialObjectList.isEmpty())
			addRowToFinancialObjectList();
		
		// competitors
		Set<String> tmp_FieldsCompetitorObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Competitor__c'));
		if(tmp_FieldsCompetitorObjectList != null) {
			competitorObjectList = tmp_DataHandler.SelectCompetitorObjectList(tmp_FieldsCompetitorObjectList);
		}
		
		if(competitorObjectList.isEmpty())
		{
			addRowToCompetitorObjectList();
		}
		
	}
	
	protected override void loadObjectsForProgressBar() {
		addFormObject('ar_Application__c', applicationObject);
		addFormList('ar_Financial__c', financialObjectList);
		addFormList('ar_Competitor__c', competitorObjectList);
	}
	
	public void saveMyData() {
		system.debug(logginglevel.info, '### Saving General Information...');
		
		// application
		system.debug(logginglevel.info, 'Saving application...');
		upsert applicationObject.obj;
		
		// financials
		system.debug(logginglevel.info, 'Saving financials...');
		List<ar_Financial__c> financialsToUpsert = new List<ar_Financial__c>();
		for(AR_SObjectHolder obj : financialObjectList)
			financialsToUpsert.add((ar_Financial__c)obj.obj);
		
		system.debug(logginglevel.info, 'Financials: ' + financialsToUpsert);
		upsert financialsToUpsert;
		
		// competitors
		List<ar_Competitor__c> toUpsert = new List<ar_Competitor__c>();
		List<ar_Competitor__c> toDelete = new List<ar_Competitor__c>();
		CleanToCompetitorObjectList();
		
		for(AR_SObjectHolder competitor : competitorObjectList) {
			if(competitor.getId() != null && competitor.getIsDeleted())
				toDelete.add((ar_Competitor__c)competitor.obj);
			else
				toUpsert.add((ar_Competitor__c)competitor.obj);
		}
		system.debug(logginglevel.info, 'Upserting competitor...');
		upsert toUpsert;
		system.debug(logginglevel.info, 'Deleting competitor...');
		delete toDelete;
		
		if(competitorObjectList.isEmpty())
		{
			addRowToCompetitorObjectList();
		}
	}
	
	private ar_Competitor__c getCleanCompetitorObject() {
		return new ar_Competitor__c(Application__c = (Id)ApplicationObject.getId());
	}
	
	public void addRowToCompetitorObjectList() {
		competitorObjectList.add(new AR_SObjectHolder(getCleanCompetitorObject()));
	}
	
	public void CleanToCompetitorObjectList() {
		ar_Competitor__c tmp_cleanobj = getCleanCompetitorObject();
		
		List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
		for(AR_SObjectHolder obj:CompetitorObjectList) {
			if(tmp_cleanobj != obj.obj) {
				tmp_newObjList.add(obj);
			}
		}
		competitorObjectList = tmp_newObjList;
	}
	
	public void addRowToFinancialObjectList()
	{
		AR_SObjectHolder tmp_cls = new AR_SObjectHolder();
		tmp_cls.obj = GetCleanFinancialObject();
		tmp_cls.obj.put('Name', String.valueof(Date.today().year()-2));
		financialObjectList.add(tmp_cls);
		
		AR_SObjectHolder tmp_cls2 = new AR_SObjectHolder();
		tmp_cls2.obj = GetCleanFinancialObject();
		tmp_cls2.obj.put('Name', String.valueof(Date.today().year()-1));
		financialObjectList.add(tmp_cls2);
		
		AR_SObjectHolder tmp_cls3 = new AR_SObjectHolder();
		tmp_cls3.obj = GetCleanFinancialObject();
		tmp_cls3.obj.put('Name', String.valueof(Date.today().year()));
		financialObjectList.add(tmp_cls3);
	}
	
	private ar_Financial__c getCleanFinancialObject() {
		system.debug(logginglevel.info, 'getCleanFinancialObject() ApplicationID ' + application.getId());
		return new ar_Financial__c(Application__c = (Id)application.getId());
	}
	
}