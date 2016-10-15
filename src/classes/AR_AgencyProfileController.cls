/*
	Unilever

	Class Name: AR_AgencyProfileController

	Created by: Sebastian Ortiz | 2013-09-15

	Description: Controller for the page AR_AgencyProfile.

	Timeline
	Date 					| Name 				| Description
	2013-09-15 17:51 (CET)	| Marc Saelzler 	| Initial development.
*/
public with sharing class AR_AgencyProfileController extends AR_ApplicationBaseController {
	public AR_SObjectHolder applicationObject {get;set;}
	public List<AR_SObjectHolder> projectObjectList {get;set;}
	private Id RTProject {get;set;}
	
	public AR_AgencyProfileController() {
		this.applicationObject = new AR_SObjectHolder();
		this.projectObjectList = new List<AR_SObjectHolder>();
	}
	
	public void loadMyFieldSets() {
		System.debug('## No Field sets');
		fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
		fieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
		fieldSetMap.put('ar_Experience__c',AR_MetaDataHandler.GetAllExperienceFieldsets());
	}
	
	public void loadMyData() {
		System.debug('## No Data');
		AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
		
		// record types
		RTProject = tmp_DataHandler.currentRTMap.get('ar_Experience__c').get('Project').id;
		
		// application
		Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
		if(tmp_AppFields != null)
			applicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
		
		// projects
		Set<String> tmp_FieldsAgencyExperienceObject = AR_MetaDataHandler.GetFieldNamesFromSelect(fieldSetMap.get('ar_Experience__c'));
		if(tmp_FieldsAgencyExperienceObject != null)
			projectObjectList = tmp_DataHandler.selectProjectObjectList(tmp_FieldsAgencyExperienceObject);
		
		addRowToProjectObjectList();
			
	}
	
	protected override void loadObjectsForProgressBar() {
		addFormObject('ar_Application__c', applicationObject);
		addFormList('ar_Experience__c', projectObjectList);
		
		if(projectObjectList.size() < 4)
			projectObjectList.add(new AR_SObjectHolder(getCleanProjectObject()));
	}
	
	public void saveMyData() {
		system.debug(logginglevel.info, '### Saving General Information...');
		
		System.SavePoint sp = Database.setSavepoint();
		
		//try {
			// application
			List<AR_SObjectHolder> tmp_ListHolder = projectObjectList;
			
			system.debug(logginglevel.info, 'Saving application...');
			upsert applicationObject.obj;
			
			//files
			applicationObject.setAllFilesParentIds();
			List<Attachment> files = applicationObject.getFilesasList();
			if(!files.isEmpty()) {
				system.debug(logginglevel.info, 'Saving files...');
				upsert files;
			}
			
			// empty files bodies
			applicationObject.setAllBodystoNull();
			
			// projects
			cleanProjectObjectList();
			
			// I call this after cleaning, to make sure I wont validate a list with an empty project at the end
			addFormList('ar_Experience__c', projectObjectList);
			
			List<ar_Experience__c> toUpsert = new List<ar_Experience__c>();
			List<ar_Experience__c> toDelete = new List<ar_Experience__c>();
			for(AR_SObjectHolder project : projectObjectList) {
				if(project.getId() != null && project.getIsDeleted())
					toDelete.add((ar_Experience__c)project.obj);
				else
					toUpsert.add((ar_Experience__c)project.obj);
			}
			system.debug(logginglevel.info, 'Upserting project...');
			upsert toUpsert;
			system.debug(logginglevel.info, 'Deleting project...');
			delete toDelete;
			
			// project files
			List<Attachment> tmp_attachmentstoUpsert = new List<Attachment>();
			for(AR_SObjectHolder obj:projectObjectList) {
				obj.setAllFilesParentIds();
				if(!obj.getFilesasList().isempty())
					tmp_attachmentstoUpsert.addall(obj.getFilesasList());
			}
			if(!tmp_attachmentstoUpsert.isempty()) {
				system.debug(logginglevel.info, 'Saving project files...');
				upsert tmp_attachmentstoUpsert;
			}
				
			for(AR_SObjectHolder obj:ProjectObjectList) {
				obj.SetAllBodystoNull();
			}
			
			projectObjectList = tmp_ListHolder;
		//} catch(DmlException e) {
		//	system.debug(logginglevel.error, 'ERROR saving records: ' + e.getMessage());
		//	Database.rollback(sp);
		//} catch(Exception e) {
		//	system.debug(logginglevel.error, 'ERROR saving records: ' + e.getMessage());
		//}
	}
	
	private ar_Experience__c getCleanProjectObject() {
		return new ar_Experience__c(RecordTypeId = RTProject ,Application__c = (Id)application.getId());
	}
	
	public void addRowToProjectObjectList() {
		//saveMyData();
		//AR_SObjectHolder tmp_cls = new AR_SObjectHolder(getCleanProjectObject());
		while(projectObjectList.size() < 4)
		{
			AR_SObjectHolder tmp_cls = new AR_SObjectHolder(getCleanProjectObject());
			projectObjectList.add(tmp_cls);
		}
			
		
	}
	
	public void cleanProjectObjectList() {
		ar_Experience__c tmp_cleanobj = GetCleanProjectObject();
		List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
		
		for(AR_SObjectHolder obj:ProjectObjectList) {
			if(tmp_cleanobj != obj.obj) {
				tmp_newObjList.add(obj);
			}
		}
		projectObjectList = tmp_newObjList;
	}
	
}