public with sharing class AR_GeneralInformationController extends AR_ApplicationBaseController {
    public AR_SObjectHolder applicationObject {get;set;}
    public List<AR_SObjectHolder> shareholderObjectList {get;set;}
    
    public AR_GeneralInformationController() {
        this.applicationObject = new AR_SObjectHolder();
        this.shareholderObjectList = new List<AR_SObjectHolder>();
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        fieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
        fieldSetMap.put('ar_Shareholder__c',AR_MetaDataHandler.GetAllShareholderFieldsets());
    }
    
    public void loadMyData() {
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        // application
        Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
        if(tmp_AppFields != null)
            applicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
        
        // share holders
        Set<String> tmp_FieldsShareholder = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Shareholder__c'));
        if(tmp_FieldsShareholder != null)
            shareholderObjectList = tmp_DataHandler.SelectShareholder(tmp_FieldsShareholder);
         
        if(shareholderObjectList.isempty())
        {
        	addRowToShareholderObjectList();
        }
        
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormObject('ar_Application__c', applicationObject);
        addFormList('ar_Shareholder__c', shareholderObjectList);
    }
    
    public void saveMyData() {
        system.debug(logginglevel.info, '### Saving General Information...');
        
        // application
        system.debug(logginglevel.info, 'Saving application...');
        upsert applicationObject.obj;
        
        //files
        applicationObject.setAllFilesParentIds();
        List<Attachment> files = applicationObject.getFilesasList();
        
        System.Debug('#files: ' + files);
        
        if(!files.isEmpty()) {
            system.debug(logginglevel.info, 'Saving files...');
            upsert files;
        }
        
        // empty files bodies
        applicationObject.setAllBodystoNull();
        
        // share holders
        cleanShareholderObjectList();
        
        List<ar_Shareholder__c> toUpsert = new List<ar_Shareholder__c>();
        List<ar_Shareholder__c> toDelete = new List<ar_Shareholder__c>();
        for(AR_SObjectHolder shareHolder : shareholderObjectList) {
            if(shareHolder.getId() != null && shareHolder.getIsDeleted())
                toDelete.add((ar_Shareholder__c)shareHolder.obj);
            else
                toUpsert.add((ar_Shareholder__c)shareHolder.obj);
        }
        system.debug(logginglevel.info, 'Upserting share holder...');
        upsert toUpsert;
        system.debug(logginglevel.info, 'Deleting share holder...');
        delete toDelete;
        
        if(shareholderObjectList.isempty())
        {
        	addRowToShareholderObjectList();
        }
    }
    
    private ar_Shareholder__c getCleanShareholderObject() {
        return new ar_Shareholder__c(Application__c = application.getId());
    }
    
    public void addRowToShareholderObjectList() {
        shareholderObjectList.add(new AR_SObjectHolder(getCleanShareHolderObject()));
    }
    
    public void cleanShareholderObjectList() {
        ar_Shareholder__c tmp_cleanobj = getCleanShareholderObject();
        List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
        
        for(AR_SObjectHolder obj : shareholderObjectList) {
            if(tmp_cleanobj != obj.obj) {
                tmp_newObjList.add(obj);
            }
        }
        shareholderObjectList = tmp_newObjList;
    }
    // This method adds a row to the list of AR_Shareholder__c after a click on add row has happened.
    
    
    // This method removes a row from the list of AR_Shareholder__c after a click on remove has happened.
    
    
}