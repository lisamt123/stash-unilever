public with sharing class kof_ContactTriggerHandler {
	
	public void onBeforeInsert(kof_Contact__c[] newItems, Map<Id, kof_Contact__c> itemMap) {
		Set<Id> kofAccountId = new Set<Id>(); 
		for (kof_Contact__c c : newItems) {
			kofAccountId.add(c.Organisation__c);
		}
		
		Map<Id,kof_Account__c> kofAccount = new Map<Id,kof_Account__c>([SELECT BillingCity__c, BillingCountry__c, BillingPostcode__c, 
			BillingState__c, BillingStreet__c FROM kof_Account__c WHERE Id IN :kofAccountId ]);
			
		for (kof_Contact__c c : newItems) {
			try {
				if (String.isBlank(c.MailingStreet__c) && String.isBlank(c.MailingCity__c) && String.isBlank(c.MailingPostcode__c) 
					&& String.isBlank(c.MailingState__c) && String.isBlank(c.MailingCountry__c)) {
					
					c.MailingStreet__c = (!String.isBlank(kofAccount.get(c.Organisation__c).BillingStreet__c)) 
						? kofAccount.get(c.Organisation__c).BillingStreet__c 
						: c.MailingStreet__c;
					c.MailingCity__c = (!String.isBlank(kofAccount.get(c.Organisation__c).BillingCity__c)) 
						? kofAccount.get(c.Organisation__c).BillingCity__c 
						: c.MailingCity__c;
					c.MailingPostcode__c = (!String.isBlank(kofAccount.get(c.Organisation__c).BillingPostcode__c)) 
						? kofAccount.get(c.Organisation__c).BillingPostcode__c 
						: c.MailingPostcode__c;
					c.MailingState__c = (!String.isBlank(kofAccount.get(c.Organisation__c).BillingState__c)) 
						? kofAccount.get(c.Organisation__c).BillingState__c 
						: c.MailingState__c;
					c.MailingCountry__c = (!String.isBlank(kofAccount.get(c.Organisation__c).BillingCountry__c)) 
						? kofAccount.get(c.Organisation__c).BillingCountry__c 
						: c.MailingCountry__c;
				}
			} catch(Exception e) {
				System.debug('An error occurred updating Stakeholder fields: ' + e.getMessage());
			}
		}
	}
	
}