/*
    Unilever

    Class Name: AR_SupplierCodeController

    Created by: Marc Saelzler | 2013-09-15

    Description: Controller for the page AR_SupplierCode.

    Timeline
    Date                    | Name              | Description
    2013-09-15 17:00 (CET)  | Marc Saelzler     | Initial development.
*/
public with sharing class AR_SupplierCodeController extends AR_ApplicationBaseController {
    public AR_SObjectHolder applicationObject {get;set;}
    
    public AR_SupplierCodeController() {
        this.applicationObject = new AR_SObjectHolder();
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        fieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
    }
    
    public void loadMyData() {
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        // application
        Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
        if(tmp_AppFields != null)
            applicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormObject('ar_Application__c', applicationObject);
    }
    
    public void saveMyData() {
        // application
        system.debug(logginglevel.info, 'Saving application...');
        upsert applicationObject.obj;
    }
    
    public override boolean doSave()
    {
        System.debug('###overwritten save method...');
        
        String tmp_agreedResult = (String) applicationObject.obj.get('Agree_to_comply_Unilever_Supplier_Code__c');
        
        System.debug('###overwritten save method...');
        
        if(tmp_agreedResult == null || tmp_agreedResult.toLowerCase() != 'yes')
        {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Please first confirm this supplier code to continue.'));
            return false;
        }
        
        // execute as normal
        return super.doSave();
    }   
}