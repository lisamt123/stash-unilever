public with sharing class AR_CMSData {
	
	public String contentType { get;set; }
	
	public AR_CMSData(){}
	
	public List<ar_Agency_Portal_CMS__c> getCmsContent(){
		return [select 	Title__c,
						Body__c
				From 	ar_Agency_Portal_CMS__c 
				Where 	Type__c = :contentType
					and Published__c = true 
				Order By Order__c];
	}

}