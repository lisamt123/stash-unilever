public with sharing virtual class Oblix_SOWNonCampaignPageHelperEXT1 extends Oblix_SOWNonCampaignPageHelperParent{


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


    public void openBasketSection() {
        if (currentSection == RESOURCE_DEV_NAME) {
            currentTab = RESOURCE_DEV_NAME;
        } else {
            currentTab = ACTIVITY_DEV_NAME;
        }
        workList.put(currentTab, basket.get(currentSection).getCopy());
    }


    public void openTab() {
        if (resourceTabSelected) {
            currentSection = RESOURCE_DEV_NAME;
            //workList.put(currentTab, basket.get(currentSection).deepClone()());
        } else {
            if (currentSection == RESOURCE_DEV_NAME) {
                currentSection = null;
                //workList.put( = new Oblix_SOWNonCampaignPageHelperParent.BasketSectionWrapper(sow.Id, 'TBC', 'TBC', 'TBC');
            }
        }
    }


    public void refreshSelectionPicklists(){
        fillCountries();
        fillAgencyDepartment();
        fillRoleTitle();
        fillRate();
    }



    public void refreshActivitySelection(){
        refreshSelectionPicklists();
        
        //If another nonCampaignWrapper was selected
        //preserve all field selections but blank out nonCampaign sObject ID
        //by cloning it
        if (currentItemKey != null) { 
            if (activityTabSelected) {
                currentActivity = createNewWrapperFromExisting(currentActivity, true);
            } else {
                currentResource = createNewWrapperFromExisting(currentResource, true);

            }
            currentItemKey = null;
        }

        if (activityTabSelected) {

            if (currentActivity.selectedActivity != currentActivity.nonCampaignItem.Activities__c) {
                //Syncing Acitvites field on Wrapper in case another value was selected on the page and mapped to sObject
                currentActivity.selectedActivity = currentActivity.nonCampaignItem.Activities__c;
                if (currentActivity.nonCampaignItem.Activities__c == 'Other') {
                    currentActivity.nonCampaignItem.Name = '';
                }
            }
            if (currentActivity.selectedActivity == 'Other' && currentActivity.name != currentActivity.nonCampaignItem.Name) {
                //Syncing Other name on Wrapper in case another value was selected on the page and mapped to sObject
                currentActivity.name = currentActivity.nonCampaignItem.Name;
            }
            currentActivity.recalculateKey();
            
            //If new select picklist configuration matches existing item from worklist, set it as current and preserve hours (UPDATE button will appear)
            if (workList.get(currentTab).items.containsKey(currentActivity.key)) {
                currentActivity = createNewWrapperFromExisting(workList.get(currentTab).items.get(currentActivity.key), false);
            } else if (basket.containsKey(currentActivity.getBasketSectionKey()) && 
                        basket.get(currentActivity.getBasketSectionKey()).items.containsKey(currentActivity.key)) {
                currentActivity = createNewWrapperFromExisting(basket.get(currentActivity.getBasketSectionKey()).items.get(currentActivity.key), false);
            }
        } else {
            if (currentResource.name != currentResource.nonCampaignItem.Name) {
                //Syncing Acitvites field on Wrapper in case another value was selected on the page and mapped to sObject
                currentResource.name = currentResource.nonCampaignItem.Name;
            }
            currentResource.recalculateKey();

            //If new select picklist configuration matches existing item from worklist, set it as current and preserve hours (UPDATE button will appear)
            if (workList.get(currentTab).items.containsKey(currentResource.key)) {
                currentResource = createNewWrapperFromExisting(workList.get(currentTab).items.get(currentResource.key), false);
            } else if (basket.containsKey(currentResource.getBasketSectionKey()) && 
                        basket.get(currentResource.getBasketSectionKey()).items.containsKey(currentResource.key)) {
                currentResource = createNewWrapperFromExisting(basket.get(currentResource.getBasketSectionKey()).items.get(currentResource.key), false);
            }
        }
    }

}