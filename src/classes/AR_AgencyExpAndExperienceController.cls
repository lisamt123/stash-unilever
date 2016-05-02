/*
	Unilever

	Class Name: AR_UniNonUniExperienceController

	Created by: Jan Schwetasch | 2013-09-17

	Description: Controller for the page AR_AgencyExpAndExpertise.

	Timeline
	Date 					| Name 				| Description
	2013-09-17 11:12 (CET)	| Jan Schwetasch 	| Initial development.
*/

public with sharing class AR_AgencyExpAndExperienceController extends AR_ApplicationBaseController {
	public AR_SObjectHolder agencyExperienceObject {get;set;}
	private String RTForExpObj;
	
	public AR_AgencyExpAndExperienceController() 
	{
		this.agencyExperienceObject = new AR_SObjectHolder(); 
	}
	
	private void loadMyFieldSets() 
	{
		fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
		this.FieldSetMap.put('ar_Experience__c',AR_MetaDataHandler.GetAllExperienceFieldsets());
	}
	
	private void loadMyData() 
	{
		// Query experience
		AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
		RTForExpObj = tmp_DataHandler.currentRTMap.get('ar_Experience__c').get('Expertise').Id;
		
		Set<String> tmp_FieldsAgencyExperienceObject = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Experience__c'));
		if(tmp_FieldsAgencyExperienceObject != null)
		{
			agencyExperienceObject = tmp_DataHandler.selectAgencyExperience(tmp_FieldsAgencyExperienceObject);
			if(agencyExperienceObject.obj == null)
			{
				AR_SObjectHolder tmp_EClass = new AR_SObjectHolder();
				tmp_EClass.obj			= new ar_Experience__c();
			    AgencyExperienceObject  = tmp_EClass;
				AgencyExperienceObject.obj.put('RecordTypeId', RTForExpObj);
			}
		}
		
	}
	
	protected override void loadObjectsForProgressBar() {
		addFormObject('ar_Experience__c', agencyExperienceObject);
	}
	
	private void saveMyData() 
	{
		system.debug(logginglevel.info, '### Saving Agency Expertise...');
		
		//ar_Experience__c save
		agencyExperienceObject.obj.put('RecordTypeId', RTForExpObj);
		agencyExperienceObject.obj.put('Application__c' ,(Id)application.getId());
		system.debug(logginglevel.info, 'Upsert: ' + agencyExperienceObject.obj);
		upsert agencyExperienceObject.Obj;
		
		//Attachment Save
		List<Attachment> tmp_attachmentstoUpsert = new List<Attachment>();
		AgencyExperienceObject.setAllFilesParentIds();
		if(!AgencyExperienceObject.getFilesasList().isempty())
		{
			tmp_attachmentstoUpsert.addall(AgencyExperienceObject.getFilesasList());
		}
		if(!tmp_attachmentstoUpsert.isempty())
		{
			system.debug(logginglevel.info, 'Upsert Attachments: ' + tmp_attachmentstoUpsert);
			upsert tmp_attachmentstoUpsert;
		}
		AgencyExperienceObject.SetAllBodystoNull();
	}
}