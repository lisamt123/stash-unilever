// wrapper used to hold data for VF page
public with sharing class Oblix_NonCampaignWrapper {

	public Marketing_Basics__c nonCampaignItem {get;set;}
	public String selectedCountry { get; set; }
	public String selectedCountryname { get; set; }
	public String selectedActivity { get; set; }
	public String selectedCountryActivity { get; set; }
	public String selectedAgencyDepartment { get; set; }
	public String selectedRole { get; set; }
	public String hourlyRate { get; set; }
	public String roundedRate {get;
		set
		{
			if (String.isNotBlank(value)){
				roundedRate = String.valueOf(Math.round(Decimal.valueOf(value)));
			}
			else{
				roundedRate = '0';
			}
		} 
	}
	public Decimal hoursSelected { get; set;}
	public String result { get;set; }
	public String name { get; set; }
	public Double totalAmount { get; set;}
	public String key { get; set; }
	public Id activityId { get; set; }


	public Boolean agencyVisible { get;set; }
	public Boolean roleVisible { get;set; }
	public Boolean valVisible { get; set; }

	public Boolean isActivity;
	public Id sowId;
 

	//private String ActivityName= System.Label.Oblix_Lbl_Activity;
	//private String marKObjName = System.Label.Oblix_Lbl_Marketing_Basics_c;

    //public Oblix_NonCampaignWrapper() {
    //    nonCampaignItem = new Marketing_Basics__c ();
    //    nonCampaignItem.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
    //}

    public Oblix_NonCampaignWrapper(Id sowId, Boolean isActivity) {
        
        this.isActivity = isActivity;
        this.sowId = sowId;
        initNewSObject();
    }

    public void initNewSObject() {
    	this.nonCampaignItem = new Marketing_Basics__c ();
        this.nonCampaignItem.Oblix_SOWMarketing__c = sowId;
        if (isActivity) {
        	nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID;
    	} else {
    		nonCampaignItem.RecordTypeId = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID;
    	}
    }



    public Oblix_NonCampaignWrapper(Marketing_Basics__c nonCampaign) {

        this.name = nonCampaign.name;
        this.selectedActivity = nonCampaign.Activities__c;
        this.selectedCountryname = nonCampaign.OblixCountry__r.Name;
        this.selectedCountry = nonCampaign.OblixCountry__c;
        this.selectedAgencyDepartment = nonCampaign.Agency_Department__c;
        this.selectedRole = nonCampaign.Role_Title__c;
        this.hourlyRate = String.valueOf(nonCampaign.Hourly_Rate_or_FTE__c);
        this.roundedRate = String.valueOf(Math.round(Decimal.valueOf(this.hourlyRate)));
        this.hoursSelected = nonCampaign.No_of_Hours_Required__c;
        this.totalAmount = nonCampaign.OblixOtherItemFee__c;
        this.activityId = nonCampaign.Id;
        this.nonCampaignItem = nonCampaign;

        recalculateKey();
    }


    /**
    *
    * Used to maintain all of the user selected values but to blank out ID so that upsert call with new key can succeed
    */
    public void replaceSObjectWithClone() {
        nonCampaignItem = nonCampaignItem.clone(false, true);
    }


    public String getBasketSectionKey() {

        String basketSectionKey;

        if (nonCampaignItem.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID) {
            basketSectionKey = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME.toUpperCase();
        } else if (nonCampaignItem.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID && nonCampaignItem.Activities__c != 'Other') {
            if (nonCampaignItem.Activities__c == null) {
                return null;
            } else {
                basketSectionKey = nonCampaignItem.Activities__c.toUpperCase();
            }
        } else {
            if (nonCampaignItem.Name == null) {
                return nonCampaignItem.Activities__c.toUpperCase();
            } else {
                basketSectionKey = nonCampaignItem.Activities__c.toUpperCase() + nonCampaignItem.Name.toUpperCase();
            }
        }

        return basketSectionKey == null ? null : basketSectionKey.toUpperCase();
    }


    public String getWorklistTabKey() {

        String basketTabKey;

        if (nonCampaignItem.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_ID) {
            basketTabKey = Oblix_Utils.RT_NON_CAMPAIGN_RESOURCE_DEV_NAME.toUpperCase();
        } else {
            basketTabKey = Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_DEV_NAME.toUpperCase();
        }

        return basketTabKey.toUpperCase();
    }


    /**
    *
    * Method for updating nonCampaign wrapper fields that are not being synced with VF page via parameters
    *
    */
    public void updateFields(Oblix_SOWNonCampaignPageHelper.NonCampaignJSONWrapper jsonWrapper) {

    	name = jsonWrapper.name;

        if(NULL != jsonWrapper && NULL != jsonWrapper.otherName && !jsonWrapper.otherName.equalsIgnoreCase('')){
            name = jsonWrapper.otherName;
        }
        
        selectedActivity = jsonWrapper.selectedActivity;
        selectedAgencyDepartment = jsonWrapper.selectedAgencyDepartment;
        selectedRole = jsonWrapper.selectedRole;
        hourlyRate = jsonWrapper.hourlyRate;
        roundedRate = jsonWrapper.hourlyRate;//
        hoursSelected = jsonWrapper.hoursSelected != null ? Decimal.valueOf(jsonWrapper.hoursSelected) : 0;
        totalAmount = jsonWrapper.totalAmount != null ? Math.round(Decimal.valueof(jsonWrapper.totalAmount)) : 0;
        key = jsonWrapper.key;
        if (String.isBlank(jsonWrapper.description)) {
            nonCampaignItem.Description__c = null;
        } else {
            nonCampaignItem.Description__c = jsonWrapper.description;
        }
        //activityId = jsonWrapper.activityId;

    }



    public void recalculateKey() {
    	if (this.nonCampaignItem.RecordTypeId == Oblix_Utils.RT_NON_CAMPAIGN_ACTIVITY_ID) {
    		if (this.selectedActivity != 'Other') {
    			this.key = this.nonCampaignItem.Oblix_SOWMarketing__c + this.selectedActivity + this.selectedCountryname + this.selectedAgencyDepartment + this.selectedRole; 	
    		} else {
    			this.key = this.nonCampaignItem.Oblix_SOWMarketing__c + this.selectedActivity + this.name + this.selectedCountryname + this.selectedAgencyDepartment + this.selectedRole; 	
    		}
            
            this.isActivity = true;   
        } else {
            this.key = this.nonCampaignItem.Oblix_SOWMarketing__c + this.name + this.selectedCountryname + this.selectedAgencyDepartment + this.selectedRole;    
            this.isActivity = false; 
        }
    }



    public Marketing_Basics__c getUpdatedsObject() {

        nonCampaignItem.Non_Campaign_Key__c = this.key;
        //if(existingKeys != null && existingKeys.containsKey(nonCampaignItem.Non_Campaign_Key__c)){
        //    nonCampaignItem.No_of_Hours_Required__c = existingKeys.get(nonCampaignItem.Non_Campaign_Key__c).No_of_Hours_Required__c + this.hoursSelected;
        //    nonCampaignItem.OblixOtherItemFee__c = existingKeys.get(nonCampaignItem.Non_Campaign_Key__c).OblixOtherItemFee__c + Decimal.valueOf(this.totalAmount);
        //}else{
            nonCampaignItem.No_of_Hours_Required__c = this.hoursSelected;
            nonCampaignItem.OblixOtherItemFee__c = Decimal.valueOf(this.totalAmount);
            nonCampaignItem.Hourly_Rate_or_FTE__c = Decimal.valueOf(this.hourlyRate);
        //}

        nonCampaignItem.Activities__c = this.selectedActivity;
        nonCampaignItem.Non_campaign_title__c = this.selectedActivity;
        if(this.name != null && !this.name.equalsIgnoreCase('')){
            nonCampaignItem.Name = this.name;
        }else{
            nonCampaignItem.Name = this.selectedActivity;
        }
        nonCampaignItem.OblixCountry__c = this.selectedCountry;
        nonCampaignItem.Role_Title__c = this.selectedRole;
        nonCampaignItem.Agency_Department__c = this.selectedAgencyDepartment;
        //nonCampaignItem.recordTypeId = Schema.SObjectType.Marketing_Basics__c.getRecordTypeInfosByName().get(ActivityName).getRecordTypeId();
        //nonCampaignItem.recordTypeId = this.nonCampaignItem.RecordTypeId;
        //System.debug('### nonCampaignItem.recordtypeid: ' +nonCampaignItem.recordtypeid);
        //nonCampaignItem.Oblix_SOWMarketing__c = marketing_SOW.Id;
        
        return nonCampaignItem;

    }
}