public with sharing class Oblix_BasketSectionWrapper {
	private Id sowId;
    public String name {get; set;}
    public String key {get; set;}
    public String recordTypeName {get; set;}
    public String activityFilter {get; set;}
    public String otherNameFilter {get; set;}
    public Map<String, Oblix_NonCampaignWrapper> items {get; set;}
    public Integer itemCount {get; set;}
    public Decimal totalValue {get; set;}

    public Oblix_BasketSectionWrapper (Id sowId, String key, String label, String recordTypeName) {
        this.sowId = sowId;
        this.name = label;
        this.key = recordTypeName.toUpperCase();
        this.recordTypeName = recordTypeName;
        this.items = new Map<String, Oblix_NonCampaignWrapper>();
        this.itemCount = 0;
        this.totalValue = 0;
    }


    public Oblix_BasketSectionWrapper (Id sowId, String key, String label, String recordTypeName, String activityFilter) {
        this.sowId = sowId;
        this.name = label;
        this.key = activityFilter.toUpperCase();
        this.recordTypeName = recordTypeName;
        this.activityFilter = activityFilter;
        this.items = new Map<String, Oblix_NonCampaignWrapper>();
        this.itemCount = 0;
        this.totalValue = 0;
    }


    public Oblix_BasketSectionWrapper (Id sowId, String key, String label, String recordTypeName, String activityFilter, String otherNameFilter) {
        this.sowId = sowId;
        this.name = label;
        this.key = activityFilter.toUpperCase()+otherNameFilter.toUpperCase();
        this.recordTypeName = recordTypeName;
        this.activityFilter = activityFilter;
        this.otherNameFilter = otherNameFilter;
        this.items = new Map<String, Oblix_NonCampaignWrapper>();
        this.itemCount = 0;
        this.totalValue = 0;
    }


    public void add(Oblix_NonCampaignWrapper item) {
        items.put(item.key, item);
        itemCount = items.keySet().size();
        if(item.totalAmount != null)
            totalValue += item.totalAmount;
    }

    public void updateItem(Oblix_NonCampaignWrapper item) {
        Oblix_NonCampaignWrapper oldItem = items.get(item.key);

        if(oldItem.totalAmount != null)
            totalValue -= oldItem.totalAmount;

        items.put(item.key, item);
        itemCount = items.keySet().size();

        if(item.totalAmount != null)
            totalValue += item.totalAmount;
    }

    public Oblix_NonCampaignWrapper remove(String key) {
        System.debug('### remove - key = ' + key);
        Oblix_NonCampaignWrapper item = items.remove(key);
        System.debug('### remove - item = ' + item);
        itemCount = items.keySet().size();
        if (item != null) {
            totalValue -= item.totalAmount;    
        }
        return item;
    }
/*
    public void reloadBasketItems() {

        itemCount = 0;
        totalValue = 0;

        List<Marketing_Basics__c> existingNonCampaigns = new List<Marketing_Basics__c>();

        if (activityFilter == null || String.isEmpty(activityFilter)) {
            existingNonCampaigns =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, 
                                            OblixCountry__c, OblixCountry__r.Name , Role_Title__c, 
                                            Agency_Department__c,OblixOtherItemFee__c, 
                                            Hourly_Rate_or_FTE__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
                                     FROM 
                                            Marketing_Basics__c 
                                     WHERE 
                                            Oblix_SOWMarketing__c =: this.sowId 
                                     AND
                                            RecordType.DeveloperName =: recordTypeName];
        } else if (otherNameFilter == null || String.isEmpty(otherNameFilter)){

            existingNonCampaigns =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, 
                                            OblixCountry__c, OblixCountry__r.Name , Role_Title__c, 
                                            Agency_Department__c,OblixOtherItemFee__c, 
                                            Hourly_Rate_or_FTE__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
                                     FROM 
                                            Marketing_Basics__c 
                                     WHERE 
                                            Oblix_SOWMarketing__c =: this.sowId 
                                     AND
                                            RecordType.DeveloperName =: recordTypeName
                                     AND
                                            Activities__c = :activityFilter];
        } else {
            existingNonCampaigns =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, 
                                            OblixCountry__c, OblixCountry__r.Name , Role_Title__c, 
                                            Agency_Department__c,OblixOtherItemFee__c, 
                                            Hourly_Rate_or_FTE__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
                                     FROM 
                                            Marketing_Basics__c 
                                     WHERE 
                                            Oblix_SOWMarketing__c =: this.sowId 
                                     AND
                                            RecordType.DeveloperName =: recordTypeName
                                     AND
                                            Activities__c = :activityFilter
                                     AND 
                                            Name = :otherNameFilter];
        }

        for (Marketing_Basics__c nonCampaign : existingNonCampaigns) {
            Oblix_NonCampaignWrapper nonCampaignWrapper = new Oblix_NonCampaignWrapper(nonCampaign);
            this.add(nonCampaignWrapper);
        }
    }
*/
    public Oblix_BasketSectionWrapper getCopy() {
        Oblix_BasketSectionWrapper wrapper = this.clone();
        wrapper.items = items.clone();
        for (String key : wrapper.items.keySet()) {
            wrapper.items.put(key, wrapper.items.get(key).clone());
        }
        return wrapper;
    }
}