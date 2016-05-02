public with sharing class AR_UniNonUniExperienceController extends AR_ApplicationBaseController {
    public AR_SObjectHolder applicationObject {get;set;}
    public AR_SObjectHolder agencyULExperienceObject {get;set;}
    public List<AR_SObjectHolder> uniExperienceObjectList {get;set;}
    public List<AR_SObjectHolder> nonUniExperienceObjectList {get;set;}
    private String RTForExpObj;
    
    public AR_UniNonUniExperienceController() {
        this.uniExperienceObjectList = new List<AR_SObjectHolder>();
        this.nonUniExperienceObjectList = new List<AR_SObjectHolder>();
        this.applicationObject = new AR_SObjectHolder(new ar_Application__c());
        this.agencyULExperienceObject = new AR_SObjectHolder(GetCleanExperienceObject());
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        this.FieldSetMap.put('ar_Experience__c',AR_MetaDataHandler.GetAllExperienceFieldsets());
        this.fieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
    }
    
    private void loadMyData() {
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        // record type
        RTForExpObj = tmp_DataHandler.currentRTMap.get('ar_Experience__c').get('Experience').Id;
        System.debug(logginglevel.info,'### RTForExpObj' + RTForExpObj);
        
        // new experience object
        this.agencyULExperienceObject = new AR_SObjectHolder(GetCleanExperienceObject());
        
        // application
        Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
        if(tmp_AppFields != null) {
            applicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
        }
        
        // Query uni experience and non uni experience in same soql
        Set<String> tmp_FieldsUniExperienceObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Experience__c'));
        if(tmp_FieldsUniExperienceObjectList != null) {
            Map<String,List<AR_SObjectHolder>> tmp_ExpMap = tmp_DataHandler.selectAllExperienceObjects(tmp_FieldsUniExperienceObjectList);
            UniExperienceObjectList = tmp_ExpMap.get('Unilever');
            NonUniExperienceObjectList = tmp_ExpMap.get('NonUnilever');
        }
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormList('ar_Experience__c#ULExperience', uniExperienceObjectList);
        addFormList('ar_Experience__c#NonULExperience', nonUniExperienceObjectList);
    }
    
    private void saveMyData() {
        
        System.debug(logginglevel.info,'Saving application...');
        // Upsert uni experience and non uni experience in same DML
        upsert applicationObject.obj;
        
        //cleanUniExperienceObjectList();
        List<AR_SObjectHolder> tmp_newCleanListUni = new List<AR_SObjectHolder> ();
        List<AR_SObjectHolder> tmp_newCleanListNonUni = new List<AR_SObjectHolder> ();
        List<ar_Experience__c> tmp_ObjListUpsert = new List<ar_Experience__c>();
        List<ar_Experience__c> tmp_ObjListDelete = new List<ar_Experience__c>();
        for(AR_SObjectHolder obj:uniExperienceObjectList)
        {
            if(obj.getId() == null && !obj.getIsDeleted())
            {
                tmp_ObjListUpsert.add((ar_Experience__c)obj.obj);
                tmp_newCleanListUni.add(obj);
            }
            else if (!obj.getIsDeleted())
            {
                tmp_ObjListUpsert.add((ar_Experience__c)obj.obj);
                tmp_newCleanListUni.add(obj);
            }
            else if(obj.getId() != null)
            {
                tmp_ObjListDelete.add((ar_Experience__c)obj.obj);
            }
        }
        for(AR_SObjectHolder obj:nonUniExperienceObjectList)
        {
            if(obj.getId() == null && !obj.getIsDeleted())
            {
                tmp_ObjListUpsert.add((ar_Experience__c)obj.obj);
                tmp_newCleanListNonUni.add(obj);
            }
            else if (!obj.getIsDeleted())
            {
                tmp_ObjListUpsert.add((ar_Experience__c)obj.obj);
                tmp_newCleanListNonUni.add(obj);
            }
            else if(obj.getId() != null)
            {
                tmp_ObjListDelete.add((ar_Experience__c)obj.obj);
            }
        }
        
        System.debug(logginglevel.info,'### Saving experience \ntoUpsert: ' + tmp_ObjListUpsert + ' \ntoDelete: ' + tmp_ObjListDelete);
        
        upsert tmp_ObjListUpsert;
        delete tmp_ObjListDelete;
        
        uniExperienceObjectList = tmp_newCleanListUni;
        nonUniExperienceObjectList = tmp_newCleanListNonUni;
    }
    
    private ar_Experience__c GetCleanExperienceObject() {
        return new ar_Experience__c(RecordTypeId = RTForExpObj ,Application__c = (Id)application.getId());
    }
    
    // Add row
    // depending on what Experience type is selected on the form, the new entry is loaded in some of the 2 lists
    public PageReference addNewExperience() {
        system.debug(logginglevel.info, '### Adding new Experience....');
        if(((ar_Experience__c)this.agencyULExperienceObject.obj).unilever_non_unilever__c != null && ((ar_Experience__c)this.agencyULExperienceObject.obj).unilever_non_unilever__c != '') {
            if(((ar_Experience__c)this.agencyULExperienceObject.obj).unilever_non_unilever__c.equalsIgnoreCase('Unilever'))
                this.uniExperienceObjectList.add(agencyULExperienceObject); 
            else
                this.nonUniExperienceObjectList.add(agencyULExperienceObject);
            this.agencyULExperienceObject = new AR_SObjectHolder(GetCleanExperienceObject());
        }
        return null;
    }
    
    public void cleanExperienceObject()
    {
    	String Value = ((ar_Experience__c)this.agencyULExperienceObject.obj).unilever_non_unilever__c;
    	this.agencyULExperienceObject = new AR_SObjectHolder(GetCleanExperienceObject());
    	agencyULExperienceObject.obj.put('unilever_non_unilever__c',Value);
    }
}