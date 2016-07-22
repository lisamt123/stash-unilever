public with sharing virtual class Oblix_SOWNonCampaignPageHelperParent {
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
            if (    workList != null && 
                    workList.containsKey(currentTab) && 
                    workList.get(currentTab).items != null &&
                    workList.get(currentTab).items.containsKey(currentActivity.key)) {
                //Check if item with this key exists in workList
                return true;
            } else if (basket != null && 
                       basket.containsKey(currentActivity.getBasketSectionKey()) && 
                       basket.get(currentActivity.getBasketSectionKey()).items != null &&
                       basket.get(currentActivity.getBasketSectionKey()).items.containsKey(currentActivity.key)) { 
                //Check if item with this key exists in basket
                return true;
            } else {
                return false;                
            }
            //return currentActivity.nonCampaignItem.Id != null && !String.isBlank(currentActivity.nonCampaignItem.Id);
        }
    }

    public Boolean isUpdateResource {
        get { 
            if (    workList != null && 
                    workList.containsKey(currentTab) && 
                    workList.get(currentTab).items != null && 
                    workList.get(currentTab).items.containsKey(currentResource.key)) {
                //Check if item with this key exists in workList
                return true;
            } else if (basket != null && 
                       basket.containsKey(currentResource.getBasketSectionKey()) && 
                       basket.get(currentResource.getBasketSectionKey()).items != null &&
                       basket.get(currentResource.getBasketSectionKey()).items.containsKey(currentResource.key)) { 
                //Check if item with this key exists in basket
                return true;
            } else {
                return false;                
            }
            //return currentResource.nonCampaignItem.Id != null && !String.isBlank(currentResource.nonCampaignItem.Id);
        }
    }

    public String currentSection { //Either equals RESOURCE_DEV_NAME for dedicated resources or an uppercase value of activity name
        get {                      //Always returns UPPERCASE value
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
    public String currentTab { //Always returns UPPERCASE value
        get {
            if (currentTab == null) {
                return null;
            }
            return currentTab.toUpperCase();
        } 
        set {
            if (value == null) {
                currentTab = null;
            } else {
                currentTab = value.toUpperCase();
            }
        }
    }
    public Integer currentSectionItemCount {
        get {
            if (workList != null && workList.containsKey(currentTab) && workList.get(currentTab).items != null) {
                return workList.get(currentTab).items.keySet().size();    
            } else {
                return 0;
            }
        }
    }

    public Marketing_SOW__c sow { get; set; }
    public Map<String, Oblix_BasketSectionWrapper> basket {get; set; } //Container for items commited to DB
    public Map<String, Oblix_BasketSectionWrapper> workList {get; set; } //Container for items commited to DB + new items



    public String preSelectedSection {get;set;}
    //public String currentTab {get;set;}
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
    public static final String CALCULATOR_ROLE_RATE_RT_ID = Oblix_Utils.RT_CALCULATOR_ROLE_RATE_ID;
    public String noRole = '-Role-';

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

    public Oblix_NonCampaignWrapper createNewWrapperFromExisting(Oblix_NonCampaignWrapper wrapper, Boolean resetHours) {
        Oblix_NonCampaignWrapper newWrapper = wrapper.clone();
        newWrapper.replaceSObjectWithClone();
        if (resetHours) {
            newWrapper.hoursSelected = 0;    
        }
        return newWrapper;
    }


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


}