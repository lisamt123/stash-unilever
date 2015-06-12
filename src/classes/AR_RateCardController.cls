/*
    Unilever

    Class Name: AR_RateCardController

    Created by: Sebastian Ortiz | 2013-09-15

    Description: Controller for the page AR_RateCard

    Timeline
    Date                    | Name              | Description
    2013-09-15 17:51 (CET)  | Marc Saelzler     | Initial development.
*/
public with sharing class AR_RateCardController extends AR_ApplicationBaseController {
    public AR_SObjectHolder rateCardObject {get;set;}
    public List<AR_SObjectHolder> rateCardObjectList {get;set;}
    
    public AR_RateCardController() {
        this.rateCardObject = new AR_SObjectHolder(getCleanCardObject());
        this.rateCardObjectList = new List<AR_SObjectHolder>();
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        fieldSetMap.put('ar_Rate_Card__c',AR_MetaDataHandler.GetAllRateCardFieldsets());
    }
    
    public void loadMyData() {
        // cookie was loaded at this stage
        this.rateCardObject = new AR_SObjectHolder(getCleanCardObject());
        
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        Set<String> tmp_FieldsRateCardObjectList = AR_MetaDataHandler.getFieldNamesFromSelect(FieldSetMap.get('ar_Rate_Card__c'));
        if(tmp_FieldsRateCardObjectList != null) {
            rateCardObjectList  = tmp_DataHandler.SelectRateCardObjectList(tmp_FieldsRateCardObjectList);
        }
        
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormList('ar_Rate_Card__c', rateCardObjectList);
    }
    
    public void saveMyData() {
        system.debug(logginglevel.info, '### Saving rate cards...');
        
        // rate cards
        List<ar_Rate_Card__c> toUpsert = new List<ar_Rate_Card__c>();
        List<ar_Rate_Card__c> toDelete = new List<ar_Rate_Card__c>();
        for(AR_SObjectHolder rateCard : rateCardObjectList) {
            if(rateCard.getId() != null && rateCard.getIsDeleted())
                toDelete.add((ar_Rate_Card__c)rateCard.obj);
            else {
                toUpsert.add((ar_Rate_Card__c)rateCard.obj);
            }
        }
        system.debug(logginglevel.info, 'Upserting rate card ... ' + toUpsert);
        upsert toUpsert;
        system.debug(logginglevel.info, 'Deleting rate card...');
        delete toDelete;
    }
    
    private ar_Rate_Card__c getCleanCardObject() {
        return new ar_Rate_Card__c(Application__c = (Id)application.getId());
    }
    
    public PageReference addNewRateCardObject() {
      this.rateCardObjectList.add(rateCardObject); 
      rateCardObject = new AR_SObjectHolder(getCleanCardObject());
      return null;
     }
     
     private Map<String, String> rateRoleToDescriptionMap {
     	get {
     		if (rateRoleToDescriptionMap == null)
     		{
     			rateRoleToDescriptionMap = new Map<String, String>();
     			for (ar_Agency_Portal_CMS__c roleDesc :[Select Title__c, Body__c From ar_Agency_Portal_CMS__c Where Type__c = 'Rate Card Description'])
     			{
     				rateRoleToDescriptionMap.put(roleDesc.Title__c, roleDesc.Body__c);
     			}
     		}
     		return rateRoleToDescriptionMap;
     	}
     	set;
     }
     
     public void populateRoleDescription(){
		string roleDesc = rateRoleToDescriptionMap.get(string.valueOf(rateCardObject.obj.get('Role__c')));
     	rateCardObject.obj.put('Role_Description__c',roleDesc);
     }
}