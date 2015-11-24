/*
    Unilever

    Class Name: AR_GeographyController

    Created by: Sebastian Ortiz | 2013-09-15

    Description: Controller for the page ar_geography

    Timeline
    Date                    | Name              | Description
    2013-09-15 17:12 (CET)  | Marc Saelzler     | Initial development.
*/
public with sharing class AR_GeographyController extends AR_ApplicationBaseController {
    public AR_SObjectHolder geographyObject {get;set;}
    public List<AR_SObjectHolder> geographyObjectList {get;set;}
    
    public AR_GeographyController() {
        this.geographyObject = new AR_SObjectHolder(getCleanGeographyObject());
        this.geographyObjectList = new List<AR_SObjectHolder>();
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        fieldSetMap.put('ar_Geography__c',AR_MetaDataHandler.GetAllGeographyFieldsets());
    }
    
    public void loadMyData() {
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        Set<String> tmp_FieldsGeographyObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Geography__c'));
        if(tmp_FieldsGeographyObjectList != null) {
            geographyObjectList = tmp_DataHandler.SelectGeographyObjectList(tmp_FieldsGeographyObjectList);
        }
        
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormList('ar_Geography__c', geographyObjectList);
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
        return new ar_Geography__c(Application__c = (Id)application.getId(),Local_office_working_with_UL_today__c=false);
    }
    
    public PageReference addNewGeographyObject() {
        geographyObjectList.add(geographyObject);
        GeographyObject = new AR_SObjectHolder(getCleanGeographyObject());
      
        return null;
    }
    
}