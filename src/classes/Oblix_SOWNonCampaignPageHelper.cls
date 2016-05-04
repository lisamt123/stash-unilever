public with sharing class Oblix_SOWNonCampaignPageHelper {
	

    public Id sowId  {
        get{
            if(sowid == null){
                sowid = ApexPAges.currentPage().getParameters().get('sowId');
            }
            return sowId;
        }
        set;
    }

    public Boolean activityTabSelected {
        get {
            return currentTab == ACTIVITY_DEV_NAME;
        }
    }

    public Boolean resourceTabSelected {
        get {
            return currentTab == RESOURCE_DEV_NAME;
        }
    }

    public Boolean isUpdateActivity {
        get {
            if (workList != null && workList.items != null) {
                return workList.items.containsKey(currentActivity.key);
            } else {
                return false;                
            }
            //return currentActivity.nonCampaignItem.Id != null && !String.isBlank(currentActivity.nonCampaignItem.Id);
        }
    }

    public Boolean isUpdateResource {
        get { 
            if (workList != null && workList.items != null) {
                return workList.items.containsKey(currentResource.key);
            } else {
                return false;                
            }
            //return currentResource.nonCampaignItem.Id != null && !String.isBlank(currentResource.nonCampaignItem.Id);
        }
    }

    public String currentSection { //Either equals RESOURCE_DEV_NAME for dedicated resources or an uppercase value of activity name
        get {
            if (currentSection == null) {
                return null;
            }
            return currentSection.toUpperCase();
        } 
        set {
            if (value == null) {
                currentSection = null;
            } else {
                currentSection = value.toUpperCase();
            }
        }
    }
    public Integer currentSectionItemCount {
        get {
            if (workList != null && workList.items != null) {
                return workList.items.keySet().size();    
            } else {
                return 0;
            }
            
        }
    }

    public Marketing_SOW__c sow { get; set; }
    public Map<String, BasketSectionWrapper> basket {get; set; } //Container for items commited to DB
    public BasketSectionWrapper workList {get; set; } //Container for items commited to DB + new items



    public String preSelectedSection {get;set;}
    public String currentTab {get;set;}
    public String currentItemKey {get;set;}
    public Oblix_NonCampaignWrapper currentActivity {get; set;}
    public Oblix_NonCampaignWrapper currentResource {get; set;}
    public List<SelectOption> countries {get;set;}
    public List<SelectOption> agencyDepartments{get;set;}
    public List<SelectOption> agencyRoleTitle{get;set;}
    public List<SelectOption> resourceAgencyDepartment {get;set;}
    public List<SelectOption> resourceRoleTitle {get;set;}


    public String itemToRemove {get;set;}
    public String sectionToRemove {get;set;}


    public Integer totalBasketSize {get; set;}
    public Double totalBasketValue {get; set;}


    public  String ACTIVITY_DEV_NAME { 
        get {
            return Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME;
        }
    }
    public  String RESOURCE_DEV_NAME { 
        get {
            return Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME;
        }
    }
    public Id ACTIVITY_RT_ID {
        get {
            return Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;
        }
    }
    public Id RESOURCE_RT_ID {
        get {
            return Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;
        }
    }
    private static final String CALCULATOR_ROLE_RATE_RT_ID = Oblix_Utils.RT_CALCULATOR_ROLE_RATE_ID;
    private String noRole = '-Role-';


    public Oblix_SOWNonCampaignPageHelper(Marketing_SOW__c sow, String preSelectedType ) {
		
        this.sow = sow;
        this.preSelectedSection = preSelectedType;

        currentActivity = new Oblix_NonCampaignWrapper(sow.Id, true);
        currentResource = new Oblix_NonCampaignWrapper(sow.Id, false);

        initBasket();

        fillCountries();

	}


    public Map<String, BasketSectionWrapper> initBasket() {

        if (preSelectedSection == RESOURCE_DEV_NAME) {
            currentTab = RESOURCE_DEV_NAME;
        } else {
            currentTab = ACTIVITY_DEV_NAME;
        }
        currentSection = preSelectedSection;

        basket = initBasketSections(sow.Id);

        updateBasketStats();

        if (currentSection != null && basket.containsKey(currentSection)) {
            workList = basket.get(currentSection);    
        } else {
            workList = new BasketSectionWrapper(sow.Id, 'TBC', 'TBC', 'TBC');
        }

        return basket;

    }


    public static Map<String, BasketSectionWrapper> initBasketSections(Id sowId) {

        Map<String, BasketSectionWrapper> basket = new Map<String, BasketSectionWrapper>();

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
                    BasketSectionWrapper sectionWrapper = new BasketSectionWrapper(sowId, basketSectionKey, 'Dedicated Resources', Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME);
                    basket.put(basketSectionKey, sectionWrapper);
                }

            } else if (nonCampaignSObject.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID && nonCampaignSObject.Activities__c != 'Other') {
                if (!basket.containsKey(basketSectionKey)) {
                    BasketSectionWrapper sectionWrapper = new BasketSectionWrapper(sowId, basketSectionKey, nonCampaignSObject.Activities__c, Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, nonCampaignSObject.Activities__c);
                    basket.put(basketSectionKey, sectionWrapper);
                }

            } else {
                if (!basket.containsKey(basketSectionKey)) {
                    BasketSectionWrapper sectionWrapper = new BasketSectionWrapper(sowId, basketSectionKey, nonCampaignSObject.Name, Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME, nonCampaignSObject.Activities__c, nonCampaignSObject.Name);
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


        if (workList.items.containsKey(jsonItem.key)) {
            item = workList.items.get(jsonItem.key);
            item.updateFields(jsonItem);
            workList.items.put(jsonItem.key, item); //Update existing
        } else {
            if (activityTabSelected) {
                item = currentActivity;
            } else {
                item = currentResource;
            }
            item.updateFields(jsonItem);
            workList.add(item); //Add New
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
            //BasketSectionWrapper workListSection = workList.get(currentSection);
            BasketSectionWrapper basketSection = basket.get(currentSection);

            List<Marketing_Basics__c> sobjects = new List<Marketing_Basics__c>();
            for (Oblix_NonCampaignWrapper wrapper : workList.items.values()) {

                ////If item with such key already exists in the basket
                //if (basket.containsKey(wrapper.getBasketSectionKey()) && 
                //        basket.get(wrapper.getBasketSectionKey()).items.containsKey(wrapper.key)) {

                //}

                sobjects.add(wrapper.getUpdatedsObject());
            }

            System.debug('### list to upsert: ' + sobjects);
            upsert sobjects Non_Campaign_Key__c;

            basket = initBasketSections(sow.Id);
            workList = new BasketSectionWrapper(sow.Id, 'TBC', 'TBC', 'TBC');
            updateBasketStats();
        }
    }


    public void removeItem() {
        if (currentItemKey == itemToRemove) {
            currentItemKey = null;
        }

        Oblix_NonCampaignWrapper item = workList.items.get(itemToRemove);
        if (item.nonCampaignItem.Id != null) {
            delete item.nonCampaignItem;
        }

        workList.remove(itemToRemove);
        basket.get(currentSection).remove(itemToRemove);

        if (activityTabSelected) {
            currentActivity = new Oblix_NonCampaignWrapper(sow.Id, true);    
        } else {
            currentResource = new Oblix_NonCampaignWrapper(sow.Id, false);
        }

        updateBasketStats();
    }


    public void removeSection() {
        String bckpCurrentSection = currentSection;
        if (currentSection != sectionToRemove) {
            currentSection = sectionToRemove;
        } else {
            bckpCurrentSection = null; //
        }
        for (String key : workList.items.keySet()) {
            itemToRemove = key;
            removeItem(); 
        }

        basket.remove(sectionToRemove);

        currentSection = bckpCurrentSection;
    }


    public void openItemForUpdate(Boolean isActivity) {

        System.debug('### currentSection: ' + currentSection);
        System.debug('### currentItemKey: ' + currentItemKey);
        System.debug('### workList.items.keySet(): ' + workList.items.keySet());

        if (isActivity) {
            currentActivity = workList.items.get(currentItemKey).clone();
            currentActivity.replaceSObjectWithClone();
            refreshSelectionPicklists();
        } else {
            currentResource = workList.items.get(currentItemKey).clone();
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
        workList = basket.get(currentSection).clone();
    }


    public void openTab() {
        if (resourceTabSelected) {
            currentSection = RESOURCE_DEV_NAME;
            workList = basket.get(currentSection).clone();
        } else {
            if (currentSection == RESOURCE_DEV_NAME) {
                currentSection = null;
                workList = new BasketSectionWrapper(sow.Id, 'TBC', 'TBC', 'TBC');
            }
        }
    }


    public class BasketSectionWrapper {
        private Id sowId;
        public String name {get; set;}
        public String key {get; set;}
        public String recordTypeName {get; set;}
        public String activityFilter {get; set;}
        public String otherNameFilter {get; set;}
        public Map<String, Oblix_NonCampaignWrapper> items {get; set;}
        public Integer itemCount {get; set;}
        public Decimal totalValue {get; set;}

        public BasketSectionWrapper (Id sowId, String key, String label, String recordTypeName) {
            this.sowId = sowId;
            this.name = label;
            this.key = recordTypeName.toUpperCase();
            this.recordTypeName = recordTypeName;
            this.items = new Map<String, Oblix_NonCampaignWrapper>();
            this.itemCount = 0;
            this.totalValue = 0;
        }


        public BasketSectionWrapper (Id sowId, String key, String label, String recordTypeName, String activityFilter) {
            this.sowId = sowId;
            this.name = label;
            this.key = activityFilter.toUpperCase();
            this.recordTypeName = recordTypeName;
            this.activityFilter = activityFilter;
            this.items = new Map<String, Oblix_NonCampaignWrapper>();
            this.itemCount = 0;
            this.totalValue = 0;
        }


        public BasketSectionWrapper (Id sowId, String key, String label, String recordTypeName, String activityFilter, String otherNameFilter) {
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

        public Oblix_NonCampaignWrapper remove(String key) {
            Oblix_NonCampaignWrapper item = items.remove(key);
            itemCount = items.keySet().size();
            if (item != null) {
                totalValue -= item.totalAmount;    
            }
            return item;
        }

        public void reloadBasketItems() {

            itemCount = 0;
            totalValue = 0;

            List<Marketing_Basics__c> existingNonCampaigns = new List<Marketing_Basics__c>();

            if (activityFilter == null || String.isEmpty(activityFilter)) {
                existingNonCampaigns =[SELECT Id, Activities__c, Name, No_of_Hours_Required__c, 
                                                OblixCountry__c, OblixCountry__r.Name , Role_Title__c, 
                                                Agency_Department__c,OblixOtherItemFee__c, 
                                                Oblix_Hourly_Rate__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
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
                                                Oblix_Hourly_Rate__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
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
                                                Oblix_Hourly_Rate__c, RecordTypeId, Oblix_SOWMarketing__c, Description__c 
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
            }
            if (currentActivity.selectedActivity == 'Other' && currentActivity.name != currentActivity.nonCampaignItem.Name) {
                //Syncing Other name on Wrapper in case another value was selected on the page and mapped to sObject
                currentActivity.name = currentActivity.nonCampaignItem.Name;
            }
            currentActivity.recalculateKey();
            
            //If new select picklist configuration matches existing item from worklist, set it as current and preserve hours (UPDATE button will appear)
            if (workList.items.containsKey(currentActivity.key)) {
                currentActivity = createNewWrapperFromExisting(workList.items.get(currentActivity.key), false);
            }
        } else {
            if (currentResource.name != currentResource.nonCampaignItem.Name) {
                //Syncing Acitvites field on Wrapper in case another value was selected on the page and mapped to sObject
                currentResource.name = currentResource.nonCampaignItem.Name;
            }
            currentResource.recalculateKey();

            //If new select picklist configuration matches existing item from worklist, set it as current and preserve hours (UPDATE button will appear)
            if (workList.items.containsKey(currentResource.key)) {
                currentResource = createNewWrapperFromExisting(workList.items.get(currentResource.key), false);
            }
        }
    }


    private Oblix_NonCampaignWrapper createNewWrapperFromExisting(Oblix_NonCampaignWrapper wrapper, Boolean resetHours) {
        Oblix_NonCampaignWrapper newWrapper = wrapper.clone();
        newWrapper.replaceSObjectWithClone();
        if (resetHours) {
            newWrapper.hoursSelected = 0;    
        }
        return newWrapper;
    }


    public void refreshSelectionPicklists(){
        fillCountries();
        fillAgencyDepartment();
        fillRoleTitle();
        fillRate();
    }



        // Description : Method used to update Rate options in Activities form 
    public void fillRate() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillrate =+=+=+=+=+=+=+=+=+============================');
    
        List < Oblix_Calculator__c > rates = new List < Oblix_Calculator__c > ();
        System.DEBUG(' sow.Financial_Year__c ' + sow.Financial_Year__c);
        System.DEBUG(' sow.Oblix_AgencyEstimate__c ' + sow.Oblix_AgencyEstimate__c);
        System.DEBUG(' currentActivity.selectedCountry ' + currentActivity.selectedCountry);
        System.DEBUG(' currentActivity.selectedAgencyDepartment ' + currentActivity.selectedAgencyDepartment);
        System.DEBUG(' currentActivity.selectedRole ' + currentActivity.selectedRole);

        System.DEBUG(' resource.selectedCountry ' + currentResource.selectedCountry);
        System.DEBUG(' resource.selectedAgencyDepartment ' + currentResource.selectedAgencyDepartment);
        System.DEBUG(' resource.selectedRole ' + currentResource.selectedRole);
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        
        if (activityTabSelected) {
            rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : sow.Financial_Year__c and Oblix_Agency__c = : sow.Oblix_AgencyEstimate__c and OblixCountry__c = :  currentActivity.selectedCountry and Agency_Department__c = : currentActivity.selectedAgencyDepartment and Role_Title__c = :  currentActivity.selectedRole];
        }else{
            rates = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, FTE__c, Agency_Department__c, Role_Title__c, Role_Daily_Rate_EUR__c from Oblix_Calculator__c where Financial_Year__c = : sow.Financial_Year__c and Oblix_Agency__c = : sow.Oblix_AgencyEstimate__c and OblixCountry__c = :  currentResource.selectedCountry and Agency_Department__c = : currentResource.selectedAgencyDepartment and Role_Title__c = :  currentResource.selectedRole];
        }
        if (rates.size() >= 1) {
            if(activityTabSelected){
                currentActivity.hourlyRate = String.valueOf((rates[0].Role_Daily_Rate_EUR__c));//Math.round
                currentActivity.roundedRate = currentActivity.hourlyRate != null ? String.valueOf(Math.round(Decimal.valueOf(currentActivity.hourlyRate))) : '0';//
            }else{
                currentResource.hourlyRate = String.valueOf((rates[0].FTE__c));
                currentResource.roundedRate = currentResource.hourlyRate != null ? String.valueOf(Math.round(Decimal.valueOf(currentResource.hourlyRate))) : '0';//
                //this.setResourceUpdateButton = false;
            }
        }
        else{
            currentActivity.hourlyRate = '0';
            currentActivity.roundedRate = '0';
            currentResource.hourlyRate = '0';
            currentResource.roundedRate = '0';
        }
        //checkIFButtonISUpdateORAdd();

    }
    
     // Description : Method used to update roleTatle options in Activities form 
    public void fillRoleTitle() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillRoleTitle=+=+=+=+=+=+=+=+=+============================');

        
        List < Oblix_Calculator__c > RoleTitleNames = new List < Oblix_Calculator__c > ();
        //system.debug('===========newItem.OblixCountry__c'+newItem.OblixCountry__c);
        System.DEBUG(' sow.Financial_Year__c ' + sow.Financial_Year__c);
        System.DEBUG(' sow.Oblix_AgencyEstimate__c ' + sow.Oblix_AgencyEstimate__c);
        System.DEBUG(' currentActivity.selectedCountry ' + currentActivity.selectedCountry);
        System.DEBUG(' currentActivity.selectedAgencyDepartment ' + currentActivity.selectedAgencyDepartment);

        System.DEBUG(' resource.selectedCountry ' + currentResource.selectedCountry);
        System.DEBUG(' resource.selectedAgencyDepartment ' + currentResource.selectedAgencyDepartment);
        
        if (activityTabSelected) {
            RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : sow.Financial_Year__c and Oblix_Agency__c = : sow.Oblix_AgencyEstimate__c and OblixCountry__c = : currentActivity.selectedCountry and Agency_Department__c = : currentActivity.selectedAgencyDepartment];
        }else{
            currentResource.selectedCountry = Oblix_Utils.CountrryGetId(currentResource.selectedCountryName);
            RoleTitleNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c, Role_Title__c from Oblix_Calculator__c where Financial_Year__c = : sow.Financial_Year__c and Oblix_Agency__c = : sow.Oblix_AgencyEstimate__c and OblixCountry__c = : currentResource.selectedCountry and Agency_Department__c = : currentResource.selectedAgencyDepartment];
        }
        System.DEBUG(' RoleTitleNames ' + RoleTitleNames);
        
        map < String, String > roleTitlesNameMap = new map < String, String > ();
        for (Oblix_Calculator__c c: RoleTitleNames) {
            if (c.Role_Title__c != null) {
                roleTitlesNameMap.put(c.Role_Title__c, c.Role_Title__c);
            }
        }
        
        if (!roleTitlesNameMap.keyset().isEmpty()) {
            // currentActivity.selectedRole = null;
            if (activityTabSelected) {
                agencyRoleTitle = new List < SelectOption>();
                agencyRoleTitle = populateRoleTitleList(roleTitlesNameMap);
                currentActivity.roleVisible = true;
            } else {
                resourceRoleTitle = new List <SelectOption>();
                resourceRoleTitle = populateRoleTitleList(roleTitlesNameMap);
                currentResource.roleVisible = true;
                //this.setResourceUpdateButton = false;
            }

        }
        else{
            agencyRoleTitle = new List < SelectOption>();
            resourceRoleTitle = new List <SelectOption>();        
        }
        
    }

    public List<SelectOption> populateRoleTitleList(Map<String,String> roleTitlesNameMap) {
        List<SelectOption> roleTitlesToReturn = new List<SelectOption>();
        
        for (String temp: roleTitlesNameMap.keySet()) {
            // if ( activity.selectedRole==null)  activity.selectedRole= temp; //remplir automatiquement par la premiere valeur
            roleTitlesToReturn.add(new SelectOption(temp, roleTitlesNameMap.get(temp)));
        }
        roleTitlesToReturn = Oblix_Utils.selectOptionSortByLabel(roleTitlesToReturn);
        // agencyRoleTitle.add(new SelectOption('', noRole));
        roleTitlesToReturn = Oblix_Utils.setFirstValue(noRole, Oblix_Utils.selectOptionSortByLabel(roleTitlesToReturn));
        //activity.selectedRole = '';
        return roleTitlesToReturn;
        //else add error (there is no rt to select)
    }
 
    
    //Description : Method used to update Agency departements options in Activities form 
    public void fillAgencyDepartment() {
        system.debug('============+=+=+=+=+=+=+=+=+= fillAgencyDepartment=+=+=+=+=+=+=+=+=+============================');

        
        
        currentActivity.selectedCountry = currentActivity.selectedCountryName;
        currentResource.selectedCountry = currentResource.selectedCountryname;
        List < Oblix_Calculator__c > agencyDepartmentNames = new List < Oblix_Calculator__c > ();

        if (activityTabSelected) {
            agencyDepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : CALCULATOR_ROLE_RATE_RT_ID and Financial_Year__c = : sow.Financial_Year__c and Oblix_Agency__c = : sow.Oblix_AgencyEstimate__c and OblixCountry__r.name like: currentActivity.selectedCountry];
        }else{
            agencyDepartmentNames = [select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = : CALCULATOR_ROLE_RATE_RT_ID and Financial_Year__c = : sow.Financial_Year__c and Oblix_Agency__c = : sow.Oblix_AgencyEstimate__c and OblixCountry__r.name like: currentResource.selectedCountry];
        }
        System.DEBUG('SOQL : ' + 'select Financial_Year__c, Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name, Agency_Department__c from Oblix_Calculator__c where RecordTypeId = \''+ CALCULATOR_ROLE_RATE_RT_ID+'\' and Financial_Year__c = \''+ sow.Financial_Year__c + '\' and Oblix_Agency__c = \'' + sow.Oblix_AgencyEstimate__c +'\' and OblixCountry__r.name like \''+currentActivity.selectedCountry+'\'');
        

        if (!agencyDepartmentNames.isEmpty() && activityTabSelected) {
            currentActivity.selectedCountry = agencyDepartmentNames[0].OblixCountry__c;
        } else if (!agencyDepartmentNames.isEmpty() && resourceTabSelected) {
            currentResource.selectedCountry = agencyDepartmentNames[0].OblixCountry__c;
        }


        Map < String, String > agencyDepartmentMap = new Map < String, String > ();
        // agencyDepartmentMap.put('', 'Agency Department');
        
        for (Oblix_Calculator__c c: agencyDepartmentNames) {
            agencyDepartmentMap.put(c.Agency_Department__c, c.Agency_Department__c);
        }
        
        
        if (activityTabSelected) {
            agencyDepartments = new List <SelectOption>();
            agencyDepartments = populateAgencyDepartmentList(agencyDepartmentMap);
            currentActivity.agencyVisible = true;  
        } else {
            resourceAgencyDepartment = new List <SelectOption>();
            resourceAgencyDepartment = populateAgencyDepartmentList(agencyDepartmentMap);
            currentResource.agencyVisible = true;
            //this.setResourceUpdateButton = false;
        }


    }

    public List<SelectOption> populateAgencyDepartmentList(Map <String, String> agencyDepartmentMap){
        List<SelectOption> departmentsToReturn = new List<SelectOption>();
        
        if (!agencyDepartmentMap.keyset().isEmpty()) {
            for (String temp: agencyDepartmentMap.keySet()) {
                departmentsToReturn.add(new SelectOption(temp, agencyDepartmentMap.get(temp)));
            }
            departmentsToReturn = Oblix_Utils.selectOptionSortByLabel(departmentsToReturn);
            departmentsToReturn = Oblix_Utils.setFirstValue('-Agency Department-', Oblix_Utils.selectOptionSortByLabel(departmentsToReturn));
        }
        return departmentsToReturn;
    }
    
    
     
    //Description : Method used to update Countries options in Activities and resources form 
    public void fillCountries() {
        
        List <Oblix_Calculator__c> countriesNames = new List <Oblix_Calculator__c>();
        countriesNames =[select Financial_Year__c,Oblix_Agency__c, OblixCountry__c, OblixCountry__r.name from Oblix_Calculator__c where Financial_Year__c=:sow.Financial_Year__c and  Oblix_Agency__c =:sow.Oblix_AgencyEstimate__c ];
        map<String,String>  countriesMap =new map<String,String> () ;
        for (Oblix_Calculator__c c: countriesNames ){
            if (c.OblixCountry__c !=null)
               { countriesMAp.put(c.OblixCountry__r.name ,c.OblixCountry__r.name );  }
        }
        countries = new List<SelectOption>();
       
        if( !countriesMap.isEmpty()){
            for (String cID: countriesMap.keySet()){
                //if (selectedCountry ==null) {       selectedCountry = cid;  //fill the selectOption  //remplir automatiquement par la premiere valeur
                //        newItem.OblixCountry__c = cid;  } //fill the lookup
                                           
                countries.add(new SelectOption(cID,countriesMap.get(cID)));
            }
        //else add error (there is no country to select)
            
        }
        countries = Oblix_Utils.selectOptionSortByLabel(countries);
        countries = Oblix_Utils.setFirstValue('-Country-', Oblix_Utils.selectOptionSortByLabel(countries ));
        system.debug('###countries : '+countries);
        //checkIFButtonISUpdateORAdd();
        
    }


}