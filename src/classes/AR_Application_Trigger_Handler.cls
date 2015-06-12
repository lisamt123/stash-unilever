public with sharing class AR_Application_Trigger_Handler {

    //-- SINGLETON PATTERN
    private static AR_Application_Trigger_Handler instance;
    public static AR_Application_Trigger_Handler getInstance() {
        if (instance == null) instance = new AR_Application_Trigger_Handler();
        return instance;
    }
    
    public AR_Application_Trigger_Handler() {
    }
    
    
    //-- EVENTS
    public void onAfterUpdate(final List<ar_Application__c> oldList, final List<ar_Application__c> newList,
                               final Map<Id, ar_Application__c> oldMap, final Map<ID, ar_Application__c> newMap) {

        //--- ACCOUNTS                              
        Map<Id, Account> applicationAccounts = new Map<Id,Account>();
        for(ar_Application__c app : newList) {
            if(app.status__c == 'Approved' && app.status__c != oldMap.get(app.id).status__c) {
                //  create Account
                Account acc = mapIntoAccount(app);
                
                applicationAccounts.put(app.id, acc);
            }
        }
            
        if(!applicationAccounts.isEmpty()) {
            
            try {
                // insert Accounts
                insert applicationAccounts.values();
            } catch(Exception e) {
                system.debug(logginglevel.error, 'ERROR inserting Accounts: ' + e.getMessage());
                return;
            }
            
            //--- CONTACTS
            Map<Id, Contact> applicationContacts = new Map<Id, Contact>();
            for(ar_Application__c app : newList) {
                //  create Contact
                Contact cont = mapIntoContact(app);
                // assign Account
                cont.accountId = applicationAccounts.get(app.id).id;
                // add to list
                applicationContacts.put(app.id, cont);
            }
            
            
            try {
                // insert Contacts
                insert applicationContacts.values();
                
                // Assign new contacts on the accounts
                for (Contact cont :applicationContacts.values())
                {
                	for (Account acc :applicationAccounts.values())
	                {
	                	if (acc.Id == cont.AccountId) 
	                	{	
	                		acc.Agency_Contact__c = cont.Id;
	                	}
	                }
                }
                try {
                	update applicationAccounts.values();
                } catch (Exception e) {
                	system.debug(logginglevel.error, 'ERROR updating Account: ' + e.getMessage());
                }
                
                
            } catch(Exception e) {
                system.debug(logginglevel.error, 'ERROR inserting Contact: ' + e.getMessage());
            }
            
            // ASSIGN ACCOUNT TO APPLICATIONS
            List<Id> tmp_AppId = new List<Id> ();
            List<ar_Application__c> appsUpd = new List<ar_Application__c>();
            for(ar_Application__c app : newList) {
                if(applicationAccounts.containsKey(app.id)) {
                    tmp_AppId.add(app.id);
                    appsUpd.add(new ar_Application__c(Id = app.id, Agency__c = applicationAccounts.get(app.id).id));
                }
            }
            
            try {
                // update Applications
                update appsUpd;
            } catch(Exception e) {
                system.debug(logginglevel.error, 'ERROR updating Application: ' + e.getMessage());
            }
            
            // LINK APPLICATION'S CHILD OBJECTS TO AGENCY
            Set<String> childsNames = new Set<String>{'ar_Fixed_Price_Rate_Card_Location__c','ar_Experience__c', 'ar_Insurance_and_Policy__c', 'ar_Revenue_Breakdown__c', 'ar_Competitor__c', 'ar_Financial__c',
            	'ar_Fixed_Price_Rate_Card__c', 'ar_Geography__c', 'ar_Rate_Card__c', 'ar_Shareholder__c', 'ar_Supplier_Info__c'};
            String soql = 'SELECT Id, Agency__c FROM {0} WHERE Application__c = ';
            List<SObject> childs = new List<Sobject>();
            
            system.debug(logginglevel.info, '>>> Linking child objects to Agency...');
            for(ar_Application__c app : newList) {
            	system.debug(logginglevel.info, '>>> Application ID: ' + app.id);
            	integer objectCount = 1;
	            for(String childObjName : childsNames) {
	            	String finalSoql = String.format( soql, new List<String>{childObjName} );
	            	finalSoql += '\''+app.id+'\'';
	            	system.debug(logginglevel.info, '>>> SOQL: ' + finalSoql);
	            	for(Sobject obj : Database.query(finalSoql)) {
	            		obj.put('Agency__c', applicationAccounts.get(app.id).id);
	            		// We need to split these object updates into different lists. 10 max per list
	            		childs.add(obj);
	            	}
	            	if (objectCount == 10) // 10 object limit for a single sObject list, so do the object and create a new list if 10 is reached
	            	{
	            		try {
			                update childs;
			                childs = new List<Sobject>();
			                objectCount = 0;
			            } catch(Exception e) {
			                system.debug(logginglevel.error, 'ERROR updating childs: ' + e.getMessage());
			            }
	            	}
	            	objectCount++;
	            }
	            
            }
            // update childs
            system.debug(logginglevel.info, '>>> Updating '+childs.size()+' child objects...');
            try {
                update childs;
            } catch(Exception e) {
                system.debug(logginglevel.error, 'ERROR updating childs: ' + e.getMessage());
            }
            
            // ASSIGN ATTACHMENTS TO ACCOUNT
            Map<id, list<Attachment>> tmp_AttachmentMap = new Map<id, list<Attachment>>();
            for(Attachment att:[Select ParentId,Bodylength FROM Attachment where ParentId IN :tmp_AppId])
            {
                if(!tmp_AttachmentMap.containskey(att.ParentId))
                {
                    tmp_AttachmentMap.put(att.ParentId,new  list<Attachment>());
                }
                tmp_AttachmentMap.get(att.ParentId).add(att);
            }
            
            system.debug(logginglevel.info, '#onAfterUpdate() - tmp_AttachmentMap: ' + tmp_AttachmentMap);
            
            List<Id> tmp_InserList = new List<Id> ();
            Integer tmp_AttSum = 0;
            for(String k:tmp_AttachmentMap.keyset())
            {
                for(Attachment att:tmp_AttachmentMap.get(k))
                {
                    if(tmp_AttSum+att.Bodylength > 5242880)
                    {
                        system.debug(logginglevel.info, '#Initiate attachment transfer... (> 5242880)');
                        AR_AttachmentTransferClass.transferAttachments(applicationAccounts.get(k).Id,tmp_InserList);
                        tmp_InserList.clear();
                        tmp_AttSum = 0;
                    }
                
                    tmp_InserList.add(att.Id);
                    tmp_AttSum = tmp_AttSum + att.Bodylength;
                }
                
                system.debug(logginglevel.info, '#onAfterUpdate() - tmp_InserList: ' + tmp_InserList);
                
                if(!tmp_InserList.isEmpty())
                {
                    system.debug(logginglevel.info, '#Initiate attachment transfer...');
                    List<Id> tmp_insertListParam = new List<Id>();
                    tmp_insertListParam.addAll(tmp_InserList);
                    AR_AttachmentTransferClass.transferAttachments(applicationAccounts.get(k).Id, tmp_insertListParam);
                    tmp_InserList.clear();
                    tmp_AttSum = 0;
                }
            }
        }
    }
    
    //-- PRIVATE METHODS
    private Account mapIntoAccount(ar_Application__c application) {
        system.debug(loggingLevel.info, '### Mapping Application into Account...');
        
        Map<String, Schema.SObjectField> applicationFields = Schema.SObjectType.ar_Application__c.fields.getMap();
        Map<String, Schema.SObjectField> contactFields = Schema.SObjectType.Account.fields.getMap();
        
        RecordType rtAgency = [select id from RecordType where sobjectType = 'Account' and developerName = 'Agency'];
        Account acc = new Account(Id = application.agency__c, recordTypeId = rtAgency.id);
        
        // STANDARD fields mapping
        acc.name = application.company_name__c;
        acc.ShippingStreet = application.address__c;
        acc.ShippingCity = application.town_city__c;
        acc.ShippingPostalCode = application.Postal_Code__c;
        acc.ShippingCountry = application.Country__c;
        acc.Website = application.Website__c;
        acc.Fax = application.General_Fax__c;
        acc.Phone = application.General_Phone__c;
        
        // CUSTOM fields mapping
        for(String fieldName : applicationFields.keySet()) {
            if(fieldName.toLowerCase().endsWith('__c') && contactFields.containsKey( fieldName )) {
                system.debug(loggingLevel.info, 'Mapping: ' + fieldName);
                acc.put( fieldName, application.get(fieldName));
            }
        }
        
        system.debug(loggingLevel.info, 'Account: ' + acc);
        return acc;
    }
    
    private Contact mapIntoContact(ar_Application__c application) {
        system.debug(loggingLevel.info, '### Mapping Application into Contact...');
        
        Map<String, Schema.SObjectField> applicationFields = Schema.SObjectType.ar_Application__c.fields.getMap();
        Map<String, Schema.SObjectField> contactFields = Schema.SObjectType.Contact.fields.getMap();
        
        Contact cont = new Contact();
        
        // STANDARD fields mapping
        cont.firstName = application.first_Name__c;
        cont.lastName = application.last_Name__c;
        cont.email = application.email__c;
        cont.title = application.job_title__c;
        cont.mobilePhone = application.phone_mobile__c;
        cont.phone = application.Phone_Landline__c;
        
        // CUSTOM fields mapping
        for(String fieldName : applicationFields.keySet()) {
            if(fieldName.toLowerCase().endsWith('__c') && contactFields.containsKey( fieldName )) {
                system.debug(loggingLevel.info, 'Mapping: ' + fieldName);
                cont.put( fieldName, application.get(fieldName));
            }
        }
        
        return cont;
    }
}