public with sharing class Oblix_SOWNonCampaignPageHelper extends Oblix_SOWNonCampaignPageHelperEXT1{
	

    

    public Oblix_SOWNonCampaignPageHelper(Marketing_SOW__c sow, String preSelectedType ) {
		
        this.sow = sow;
        this.preSelectedSection = preSelectedType;

        currentActivity = new Oblix_NonCampaignWrapper(sow.Id, true);
        currentResource = new Oblix_NonCampaignWrapper(sow.Id, false);

        initBasket();

        fillCountries();

	}


    public Map<String, Oblix_BasketSectionWrapper> initBasket() {

        if (preSelectedSection == RESOURCE_DEV_NAME) {
            currentTab = RESOURCE_DEV_NAME;
        } else {
            currentTab = ACTIVITY_DEV_NAME;
        }
        currentSection = preSelectedSection;

        basket = initBasketSections(sow.Id);

        updateBasketStats();

        workList = new Map<String, Oblix_BasketSectionWrapper>();
        workList.put(ACTIVITY_DEV_NAME.toUpperCase(), new Oblix_BasketSectionWrapper(sow.Id, ACTIVITY_DEV_NAME.toUpperCase(), ACTIVITY_DEV_NAME, 'TBC'));
        workList.put(RESOURCE_DEV_NAME.toUpperCase(), new Oblix_BasketSectionWrapper(sow.Id, RESOURCE_DEV_NAME.toUpperCase(), RESOURCE_DEV_NAME, 'TBC'));

        if (basket.containsKey(currentSection)) {
            Oblix_BasketSectionWrapper workListSection = basket.get(currentSection).getCopy();
            workList.put(currentTab, workListSection);
        }

        return basket;

    }


    public static Map<String, Oblix_BasketSectionWrapper> initBasketSections(Id sowId) {

        Map<String, Oblix_BasketSectionWrapper> basket = new Map<String, Oblix_BasketSectionWrapper>();

        List<Marketing_Basics__c> existingNonCampaigns = [SELECT   Id, Activities__c, Name, No_of_Hours_Required__c, 
                                                                    OblixCountry__c, OblixCountry__r.Name , Role_Title__c, 
                                                                    Agency_Department__c,OblixOtherItemFee__c, 
                                                                    Oblix_Hourly_Rate__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
                                                             FROM 
                                                                    Marketing_Basics__c 
                                                             WHERE 
                                                                    Oblix_SOWMarketing__c =: sowId ];

        for (Marketing_Basics__c nonCampaignSObject : existingNonCampaigns) {

            Oblix_NonCampaignWrapper nonCampaignWrapper = new Oblix_NonCampaignWrapper(nonCampaignSObject);
            String basketSectionKey = nonCampaignWrapper.getBasketSectionKey();

            if (nonCampaignSObject.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID) {
                if (!basket.containsKey(basketSectionKey)) {
                    Oblix_BasketSectionWrapper sectionWrapper = new Oblix_BasketSectionWrapper(sowId, basketSectionKey, 'Dedicated Resources', Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME);
                    basket.put(basketSectionKey, sectionWrapper);
                }

            } else if (nonCampaignSObject.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID && nonCampaignSObject.Activities__c != 'Other') {
                if (!basket.containsKey(basketSectionKey)) {
                    Oblix_BasketSectionWrapper sectionWrapper = new Oblix_BasketSectionWrapper(sowId, basketSectionKey, nonCampaignSObject.Activities__c, Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, nonCampaignSObject.Activities__c);
                    basket.put(basketSectionKey, sectionWrapper);
                }

            } else {
                if (!basket.containsKey(basketSectionKey)) {
                    Oblix_BasketSectionWrapper sectionWrapper = new Oblix_BasketSectionWrapper(sowId, basketSectionKey, nonCampaignSObject.Name, Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, nonCampaignSObject.Activities__c, nonCampaignSObject.Name);
                    basket.put(basketSectionKey, sectionWrapper);
                }
            }

            basket.get(basketSectionKey).add(nonCampaignWrapper);
        }

        return basket;

    }


    public void updateBasketStats() {
        totalBasketSize = 0;
        totalBasketValue = 0;

        List<Oblix_NonCampaignWrapper> items = new List<Oblix_NonCampaignWrapper>();

        for (String key : basket.keySet()) {
            items.addAll(basket.get(key).items.values());
        }

        for (Oblix_NonCampaignWrapper item : items) {
            totalBasketSize++;
            if(item.totalAmount != null)
                totalBasketValue += item.totalAmount;
        }
    }


    public void addToWorkList(String jsonWrapper) {
        NonCampaignJSONWrapper jsonItem = (NonCampaignJSONWrapper)JSON.deserialize(jsonWrapper, NonCampaignJSONWrapper.class);

        if (jsonItem.isActivity) {
            if (jsonItem.selectedActivity != 'Other') {
                currentSection = jsonItem.selectedActivity;
            } else {
                currentSection = jsonItem.selectedActivity+jsonItem.otherName;
            }
        } else {
            currentSection = RESOURCE_DEV_NAME;
        }

        Oblix_NonCampaignWrapper item;// = basket.get(currentTab).get(jsonItem.key);


        if (workList.get(currentTab).items.containsKey(jsonItem.key)) {
            item = workList.get(currentTab).items.get(jsonItem.key);
            item.updateFields(jsonItem);
            workList.get(currentTab).updateItem(item); //Update existing
        } else {
            if (activityTabSelected) {
                item = currentActivity;
            } else {
                item = currentResource;
            }
            item.updateFields(jsonItem);
            workList.get(currentTab).add(item); //Add New
        }   

        if (activityTabSelected) {
            currentActivity = new Oblix_NonCampaignWrapper(sow.Id, true);
        } else {
            currentResource = new Oblix_NonCampaignWrapper(sow.Id, false);
        }
        currentItemKey = null;
    }


    public void saveWorkList() {

        if (!String.isBlank(currentSection)) {
            Oblix_BasketSectionWrapper workListSection = workList.get(currentTab);
            //Oblix_SOWNonCampaignPageHelperParent.BasketSectionWrapper basketSection = basket.get(currentSection);

            List<Marketing_Basics__c> sobjects = new List<Marketing_Basics__c>();
            for (Oblix_NonCampaignWrapper wrapper : workListSection.items.values()) {

                ////If item with such key already exists in the basket
                //if (basket.containsKey(wrapper.getBasketSectionKey()) && 
                //        basket.get(wrapper.getBasketSectionKey()).items.containsKey(wrapper.key)) {

                //}

                sobjects.add(wrapper.getUpdatedsObject());
            }

            System.debug('### list to upsert: ' + sobjects);
            upsert sobjects Non_Campaign_Key__c;

            basket = initBasketSections(sow.Id);
            workList.put(currentTab, new Oblix_BasketSectionWrapper(sow.Id, currentTab, currentTab, 'TBC'));
            updateBasketStats();
        }
    }


    public void removeItem() {
        if (currentItemKey == itemToRemove) {
            currentItemKey = null;
        }

        Oblix_NonCampaignWrapper item = null;

        if (workList.get(ACTIVITY_DEV_NAME.toUpperCase()).items.containsKey(itemToRemove)) {
            item = workList.get(ACTIVITY_DEV_NAME.toUpperCase()).items.get(itemToRemove);
        } else if (workList.get(RESOURCE_DEV_NAME.toUpperCase()).items.containsKey(itemToRemove)) {
            item = workList.get(RESOURCE_DEV_NAME.toUpperCase()).items.get(itemToRemove);
        } else if (basket.containsKey(currentSection) && basket.get(currentSection).items.containsKey(itemToRemove)) {
            //If deleting the whole section - use currentSection to find corresponding basket section
            item = basket.get(currentSection).items.get(itemToRemove);
        }


        if (item.nonCampaignItem.Id != null) {
            delete item.nonCampaignItem;
        }
        if (workList.containsKey(item.getWorklistTabKey())) {
            workList.get(item.getWorklistTabKey()).remove(itemToRemove);    
        }
        if (basket.containsKey(item.getBasketSectionKey())) {
            basket.get(item.getBasketSectionKey()).remove(itemToRemove);    
        }
        

        if (activityTabSelected) {
            currentActivity = new Oblix_NonCampaignWrapper(sow.Id, true);    
        } else {
            currentResource = new Oblix_NonCampaignWrapper(sow.Id, false);
        }

        updateBasketStats();
    }


    public void removeSection() {
        String bckpCurrentSection = currentSection;
        String bckpCurrentTab = currentTab;
        if (currentSection != sectionToRemove) {
            currentSection = sectionToRemove;
        } else {
            bckpCurrentSection = null; //
        }
        for (Oblix_NonCampaignWrapper item : basket.get(sectionToRemove).items.values()) {
            itemToRemove = item.key;
            currentTab = item.getWorklistTabKey();
            removeItem(); 
        }

        basket.remove(sectionToRemove);

        currentSection = bckpCurrentSection;
        currentTab = bckpCurrentTab;
    }


    public void openItemForUpdate(Boolean isActivity) {

        System.debug('### currentSection: ' + currentSection);
        System.debug('### currentItemKey: ' + currentItemKey);
        System.debug('### workList.get(currentTab).items.keySet(): ' + workList.get(currentTab).items.keySet());

        if (isActivity) {
            currentActivity = workList.get(currentTab).items.get(currentItemKey).clone();
            currentActivity.replaceSObjectWithClone();
            refreshSelectionPicklists();
        } else {
            currentResource = workList.get(currentTab).items.get(currentItemKey).clone();
            currentResource.replaceSObjectWithClone();
            refreshSelectionPicklists();
        }
    }




    public Class NonCampaignJSONWrapper{
        public String selectedCountry;
        public String selectedActivity;
        public String name;
        public String selectedAgencyDepartment;
        public String selectedRole;
        public String hourlyRate;
        public String hoursSelected;
        public Double totalAmount;
        public String key;
        public String activityId;
        public String otherName;
        public Boolean isActivity;
        public String description;
    }


}