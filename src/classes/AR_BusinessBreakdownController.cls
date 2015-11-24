/*
    Unilever

    Class Name: AR_BusinessBreakdownController

    Created by: Sebastian Ortiz | 2013-09-15

    Description: Controller for the page ar_businessBreakdown

    Timeline
    Date                    | Name              | Description
    2013-09-15 17:51 (CET)  | Marc Saelzler     | Initial development.
*/
public with sharing class AR_BusinessBreakdownController extends AR_ApplicationBaseController {
    public List<AR_SObjectHolder> revenueBreakdownObjectList {get;set;}
    
    public AR_BusinessBreakdownController() {
        this.revenueBreakdownObjectList = new List<AR_SObjectHolder>();
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        fieldSetMap.put('ar_Revenue_Breakdown__c',AR_MetaDataHandler.GetAllRevenueBreakdownFieldsets());
    }
    
    public void loadMyData() {
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        // breakdown
        Set<String> tmp_FieldsRevenueBreakdownObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Revenue_Breakdown__c'));
        if(tmp_FieldsRevenueBreakdownObjectList != null) {
            revenueBreakdownObjectList = tmp_DataHandler.SelectRevenueBreakdownObjectList(tmp_FieldsRevenueBreakdownObjectList);
        }
        
        if(revenueBreakdownObjectList.isEmpty())
        {
        	addRowToRevenueBreakdownObjectList();
        }
        
    }
    
    protected override void loadObjectsForProgressBar() {
        addFormList('ar_Revenue_Breakdown__c', revenueBreakdownObjectList);
    }
    
    public void saveMyData() {
        
        system.debug(logginglevel.info, '### Saving revenue...');
        cleanRevenueBreakdownObjectList();
        // share holders
        List<ar_Revenue_Breakdown__c> toUpsert = new List<ar_Revenue_Breakdown__c>();
        List<ar_Revenue_Breakdown__c> toDelete = new List<ar_Revenue_Breakdown__c>();
        for(AR_SObjectHolder shareHolder : revenueBreakdownObjectList) {
            if(shareHolder.getId() != null && shareHolder.getIsDeleted())
                toDelete.add((ar_Revenue_Breakdown__c)shareHolder.obj);
            else
                toUpsert.add((ar_Revenue_Breakdown__c)shareHolder.obj);
        }
        system.debug(logginglevel.info, 'Upserting revenue...');
        upsert toUpsert;
        system.debug(logginglevel.info, 'Deleting revenue...');
        delete toDelete;
        
        if(revenueBreakdownObjectList.isEmpty())
        {
        	addRowToRevenueBreakdownObjectList();
        }
        
    }
    
    private ar_Revenue_Breakdown__c getCleanRevenueBreakdownObject() {
        return new ar_Revenue_Breakdown__c(Application__c = (Id)application.getId());
    }
    
    public void addRowToRevenueBreakdownObjectList() {
        AR_SObjectHolder tmp_cls = new AR_SObjectHolder(getCleanRevenueBreakdownObject());
        revenueBreakdownObjectList.add(tmp_cls);
    }
    
    public void cleanRevenueBreakdownObjectList() {
        ar_Revenue_Breakdown__c tmp_cleanobj = getCleanRevenueBreakdownObject();
        List<AR_SObjectHolder> tmp_newObjList = new List<AR_SObjectHolder>();
        
        for(AR_SObjectHolder obj:revenueBreakdownObjectList)
        {
            if(tmp_cleanobj != obj.obj)
            {
                tmp_newObjList.add(obj);
            }
        }
        revenueBreakdownObjectList = tmp_newObjList;
    }
    
}