/*
	Unilever

	Class Name: AR_AgencyMyProfileEditProjects

	Created by: Jan Schwetasch | 2013-09-20

	Description: 

	Timeline
	Date 					| Name 				| Description
	2013-09-20				| Jan Schwetasch 	| Initial development.
*/
public with sharing class AR_AgencyMyProfileEditProjects {
	public List<AR_SObjectHolder> projectObjectList {get;set;}
	private Id RTProject {get;set;}
	public Map<String,Map<String,List<Schema.FieldSetMember>>> fieldSetMap {get;set;}
	public Id x_AccountID { get;set; }
	
	public AR_AgencyMyProfileEditProjects() {
		this.projectObjectList = new List<AR_SObjectHolder>();
	}
	public void InitPage()
	{
		loadMyFieldSets();
		loadMyData() ;
	}
	
	public void loadMyFieldSets() {
		fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
		fieldSetMap.put('ar_Experience__c',AR_MetaDataHandler.GetAllExperienceFieldsets());
	}
	
	public void loadMyData() {
		x_AccountID =  (ID)ApexPages.currentPage().getParameters().get('Id');
		AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(null);
		// record types
		RTProject = tmp_DataHandler.currentRTMap.get('ar_Experience__c').get('Project').id;
		

		List<AR_SObjectHolder> tmp_ObjData = new List<AR_SObjectHolder>();
		Set<String> tmp_FieldSet = AR_MetaDataHandler.GetFieldNamesFromSelect(fieldSetMap.get('ar_Experience__c'));
		
		String query = 'SELECT ';
		
		tmp_FieldSet.add('Name');
		//tmp_FieldSet.add('Id');
		
        for(String f : tmp_FieldSet) 
        {
            query += f + ', ';
        }
        query += 'Id FROM ar_Experience__c where Agency__c  = :x_AccountID and RecordTypeId = :RTProject ';
		
		Set<Id> prjIds = new Set<Id>();	
		for(ar_Experience__c Data:Database.query(query))
		{
			tmp_ObjData.add(new AR_SObjectHolder(Data));
			prjIds.add( data.id );
		}
		
		List<Attachment> prjFiles = tmp_DataHandler.getFiles( prjIds, false);
		for(AR_SObjectHolder prj : tmp_ObjData)
			prj.setFiles( prjFiles );
			
		projectObjectList = tmp_ObjData;
			
		if(projectObjectList.size() < 4)
			projectObjectList.add(new AR_SObjectHolder(getCleanProjectObject()));
		
	}
	
	public void saveMyData() {
			
			
			List<AR_SObjectHolder> tmp_ListHolder = projectObjectList;
			// projects
			cleanProjectObjectList();
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
		
	}
	
	private ar_Experience__c getCleanProjectObject() {
		return new ar_Experience__c(RecordTypeId = RTProject ,Agency__c = x_AccountID);
	}
	
	public void addRowToProjectObjectList() {
		saveMyData();
		AR_SObjectHolder tmp_cls = new AR_SObjectHolder(getCleanProjectObject());
		if(projectObjectList.size() < 4)
			projectObjectList.add(tmp_cls);
			
		
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