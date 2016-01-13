public with sharing class Oblix_NonCampaignWrapper {

	public Marketing_Basics__c nonCampaignItem {get;set;}
	public String selectedCountry { get; set; }
	public String selectedActivity { get; set; }
	public String selectedCountryActivity { get; set; }
	public String selectedAgencyDepartment { get; set; }
	public String selectedRole { get; set; }
	public String selectedHourlyRateResult { get; set; }
	public String rate { get; set; }
	public String roundedRate { get; set; }
	public Integer numberOFHoursRequired { get; set; }
	public String result { get;set; }
	public String name { get; set; }
	public String totalAmount { get; set; }


	public Boolean agencyVisible { get;set; }
	public Boolean roleVisible { get;set; }
	public Boolean valVisible { get; set; }
 

	private String ActivityName= System.Label.Oblix_Lbl_Activity;
	private String marKObjName = System.Label.Oblix_Lbl_Marketing_Basics_c;

    public Oblix_NonCampaignWrapper() {
        nonCampaignItem = new Marketing_Basics__c ();
        nonCampaignItem.RecordTypeId = Oblix_Utils.MapRecordType(marKObjName).get(ActivityName);
    }
}