public with sharing class AR_FixedRateCardController extends AR_ApplicationBaseController {
    public AR_SObjectHolder applicationObject {get;set;}
    public List<AR_FixedRateCardHelper> fixRateCardObjectList {get;set;}
    private Id RTArtwork;
    private Id RTTask;
    
    public AR_FixedRateCardController() {
        this.fixRateCardObjectList = new List<AR_FixedRateCardHelper>();
    }
    
    private void loadMyFieldSets() {
        fieldSetMap = new Map<String,Map<String,List<Schema.FieldSetMember>>>();
        fieldSetMap.put('ar_Application__c',AR_MetaDataHandler.GetAllApplicationFieldsets());
        this.FieldSetMap.put('ar_Fixed_Price_Rate_Card__c',AR_MetaDataHandler.GetAllFixRateCardFieldsets());
    }
    
    public void loadMyData() {
        AR_ObjectSelectHandler2 tmp_DataHandler = new AR_ObjectSelectHandler2(application.getId());
        
        // record types
        RTTask                      = tmp_DataHandler.currentRTMap.get('ar_Fixed_Price_Rate_Card__c').get('Task').Id;
        RTArtwork                   = tmp_DataHandler.currentRTMap.get('ar_Fixed_Price_Rate_Card__c').get('Artwork').Id;
        
        // application
        Set<String> tmp_AppFields = AR_MetaDataHandler.GetFieldNamesFromSelect(FieldSetMap.get('ar_Application__c'));
        if(tmp_AppFields != null)
            applicationObject = tmp_DataHandler.SelectApplication(tmp_AppFields);
            
        // rate cards
        Set<String> tmp_FieldsFixRateCardObjectList = AR_MetaDataHandler.GetFieldNamesFromSelect(fieldSetMap.get('ar_Fixed_Price_Rate_Card__c'));
        if(tmp_FieldsFixRateCardObjectList != null)
        {
            List<AR_FixedRateCardHelper> tmp_FixCardMap = tmp_DataHandler.SelectFixedRateCard(tmp_FieldsFixRateCardObjectList);
            if(tmp_FixCardMap != null)
            {
                fixRateCardObjectList = tmp_FixCardMap;
            }
            else
            {
                getFixRateCardData(); 
            }
        }
        
        if(fixRateCardObjectList == null)
        {
            this.fixRateCardObjectList = new List<AR_FixedRateCardHelper>();
        }   
    }
    
    protected override void loadObjectsForProgressBar() {
    	if(!fixRateCardObjectList.isempty())
    	{
	        List<AR_SObjectHolder> taskRecords = new List<AR_SObjectHolder>();
	        for(List<AR_SObjectHolder> records : fixRateCardObjectList.get(0).fixRateCardObjectListTask.values())
	            taskRecords.addAll(records);
	        // we are using 2 different fieldsets on the page, so they are validated separately by the progress bar
	        addFormList('ar_Fixed_Price_Rate_Card__c#Task', taskRecords);
	        addFormList('ar_Fixed_Price_Rate_Card__c#Artwork', fixRateCardObjectList.get(0).fixRateCardObjectListArtwork);
	        addFormObject('ar_Fixed_Price_Rate_Card_Location__c',fixRateCardObjectList.get(0).RateCardCountry);
        }
    }
    
    public void saveMyData() {
        system.debug(logginglevel.info, '### Saving rate cards...');
        
        ClearList();
        
        // application
        system.debug(logginglevel.info, 'Saving application...');
        upsert applicationObject.obj;
        //ar_Fixed_Price_Rate_Card_Location__c
        List<ar_Fixed_Price_Rate_Card_Location__c> CountrytoUpsert = new List<ar_Fixed_Price_Rate_Card_Location__c>();
        
        for(AR_FixedRateCardHelper FRH:fixRateCardObjectList)
        {
        	if(FRH.HasToBeInsered())
        	{
        		ar_Fixed_Price_Rate_Card_Location__c tmp_c =  (ar_Fixed_Price_Rate_Card_Location__c)FRH.RateCardCountry.obj;
        		tmp_c.Application__c = applicationObject.getId();
        		CountrytoUpsert.add(tmp_c);
        	}
        }
        upsert CountrytoUpsert;
        
        // rate cards
       List<ar_Fixed_Price_Rate_Card__c> toUpsert = new List<ar_Fixed_Price_Rate_Card__c>();
        
        for(AR_FixedRateCardHelper FRH:fixRateCardObjectList)
        {
        	toUpsert.addall(FRH.returnRateCardstoInsert());
        }
 
        upsert toUpsert;
       
    }
    
    private ar_Fixed_Price_Rate_Card__c GetCleanFixRateCardObjectArtwork () {
        return new ar_Fixed_Price_Rate_Card__c(RecordTypeId = RTArtwork,Application__c = (Id)application.getId());
    }
    
    private ar_Fixed_Price_Rate_Card__c GetCleanFixRateCardObjectTask () {
        return new ar_Fixed_Price_Rate_Card__c(RecordTypeId = RTTask,Application__c = (Id)application.getId());
    }
    
    public void GetFixRateCardData() {
        fixRateCardObjectList.add(AR_FixedDescriptionsHandler.getRateCardOptions(GetCleanFixRateCardObjectTask(),GetCleanFixRateCardObjectArtwork()));
    }
    
    public void AddRow()
    {
    	GetFixRateCardData(); 	
    }
    
    public void ClearList()
    {
    	List<AR_FixedRateCardHelper> tmp_Clear_fixRateCardObjectList = new List<AR_FixedRateCardHelper>();
    	List<ar_Fixed_Price_Rate_Card_Location__c> CountrytoDelete = new List<ar_Fixed_Price_Rate_Card_Location__c>();
    	List<ar_Fixed_Price_Rate_Card__c> toDelete = new List<ar_Fixed_Price_Rate_Card__c>();
    	for(AR_FixedRateCardHelper rh:fixRateCardObjectList)
    	{
    		if(rh.remove == false)
    		{
    			tmp_Clear_fixRateCardObjectList.add(rh);
    		}
    		else if(rh.RateCardCountry.obj.get('Id') != null)
    		{
    			CountrytoDelete.add((ar_Fixed_Price_Rate_Card_Location__c)rh.RateCardCountry.obj);
    			toDelete.addall(rh.returnRateCardstoDelete());
    		}
    	}
    	delete CountrytoDelete;
    	delete toDelete;
    	fixRateCardObjectList = tmp_Clear_fixRateCardObjectList;
    }
}