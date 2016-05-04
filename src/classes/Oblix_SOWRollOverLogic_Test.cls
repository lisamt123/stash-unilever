@isTest
public with sharing class Oblix_SOWRollOverLogic_Test {

	private static List<Asset_Scoring__c> list_of_asset_scoring;

	private static void initialiseTestClass(){

		User u = Oblix_TestUtils.createTestUser();
        System.runAs(u) {


        	list_of_asset_scoring = Oblix_TestUtils.createAssetScoringRecords(10);	
        	insert list_of_asset_scoring;

        	insert Oblix_TestUtils.createOblixCustomSettings();
        	insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
        	insert Oblix_TestUtils.createCountryCalculatorRecords();

			Oblix_CalculatorLogic.getCalculatorRecords();

    	}
    }


    private static void testSOWSync(){

    	initialiseTestClass();


    	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);


    	Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


		Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

		mSow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
		update mSow;

		// insert attachment
		List<Attachment> list_attach = new List<Attachment>();   	
		for (Integer i=0; i < 20; i++){
			list_attach.add(new Attachment(Name = 'Unite Test Attachment '+i, Body = Blob.valueOf('Unit Test Attachment Body'), ParentId = mSow.Id ));
		}

        insert list_attach;

		List<Oblix_Project_Assets__c> list_assets_in_basket = new List<Oblix_Project_Assets__c>();
		Oblix_SOW_Projects__c project;
		
		update map_campaigns_to_test.values();


        // how many SOWs require Cloning? 
        Integer sow_requested_clone_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

        // how many SOWs require Sync? 
        Integer sow_requested_sync_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

        // how many campaigns require sync?
        Integer campaign_requested_sync_size = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

		// find out how many assets are in scope?
        Integer assets_requested_sync_size = [SELECT count() FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];
											  
        system.debug('### total sow_requested_clone_size: ' + sow_requested_clone_size + ' - sow_requested_sync_size: '
            + sow_requested_sync_size + ' - campaign_requested_sync_size' + campaign_requested_sync_size + ' - assets_requested_sync_size: ' + assets_requested_sync_size);

        system.assertEquals(3, campaign_requested_sync_size, 'Expecing 3 campaigns actual was ' + campaign_requested_sync_size);

		Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);
    	
        system.assertEquals(11, Oblix_SyncBatchJob.list_job_components.size(), 'Expecing 11 job components actual was ' + Oblix_SyncBatchJob.list_job_components.size());


    	//Database.executeBatch(job_process_batch,1);

		Oblix_SyncBatchJob.addEvent('******************************STARTED EXECUTING STEPS******************************',NULL);

    	for (Oblix_SyncBatchJob.jobComponent job_component : Oblix_SyncBatchJob.list_job_components){
        	system.assertNotEquals(job_component.process_name, NULL, 'process name cannot be null! ');
        	if (Oblix_SyncBatchJob.sync_job.job_has_error){

				Oblix_SyncBatchJob.addEvent('ERROR OCCURED ABORTING JOB!',NULL);
			}
			else{
				Oblix_SOWRolloverLogic.processStep(job_component);
				Oblix_SyncBatchJob.addEvent('EXECUTING PROCESS: ' + job_component.process_name + ' - CHUNK#: ' + job_component.chunk_number 
					+ ' - ATTRIB1: ' + job_component.attrib_1 + ' - ATTRIB2: ' + job_component.attrib_2 + ' - ATTRIB3: ' + job_component.attrib_3 ,NULL);
			}
    	}
		Oblix_SyncBatchJob.addEvent('******************************COMPLETED EXECUTING STEPS******************************',NULL);

        system.debug(Oblix_SyncBatchJob.sync_job.process_result);

    	// check SOW cloned
    	Marketing_SOW__c sow_original = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME ];
    	Marketing_SOW__c sow_cloned = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME + 'CLONED'];


    	system.assertEquals(sow_cloned.Id, sow_original.Cloned_SOW__c, 'Expecing cloned SOW Id to be populated');
    	system.assertEquals(sow_original.Id, sow_cloned.Original_SOW__c, 'Expecing original SOW Id to be populated');

    	// check SOW cloned
    	List<Attachment> list_orignal_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_original.Id ];
    	List<Attachment> list_cloned_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_cloned.Id ];

    	system.assertEquals(20, list_orignal_attachments.size(), 'Expecing #of original attachments to be 20 actual: ' + list_orignal_attachments.size());
    	system.assertEquals(20, list_cloned_attachments.size(), 'Expecing #of cloned attachments to be 20 actual: ' + list_cloned_attachments.size());


    	List<String> list_original_campaign_names = new List<String>();
    	List<String> list_cloned_campaign_names = new List<String>();
    	for (Integer i=1; i<=3; i++){
    		list_original_campaign_names.add('TEST_CAMPAIGN_' + Datetime.now().format('M/d/yyyy') + '_' +i);
    		list_cloned_campaign_names.add('TEST_CAMPAIGN_' + Datetime.now().format('M/d/yyyy') + '_' +i+'CLONED');
    	}

    	system.debug('#### TESTING: ' + JSON.serialize([SELECT Name FROM Oblix_SOW_Projects__c]));
    	system.debug('#### TESTING: ' + JSON.serialize(list_original_campaign_names));

    	// check campaigns cloned
    	List<Oblix_SOW_Projects__c> list_campaign_original = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Name in: list_original_campaign_names ];
    	List<Oblix_SOW_Projects__c> list_campaign_cloned = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Name in: list_cloned_campaign_names];


    	system.assertEquals(3, list_campaign_original.size(), 'Expecing #of original campaign to be 3 actual: ' + list_campaign_original.size());
    	system.assertEquals(3, list_campaign_cloned.size(), 'Expecing #of cloned campaign to be 3 actual: ' + list_campaign_cloned.size());

    	for (Oblix_SOW_Projects__c orig: list_campaign_original){
			system.assertEquals(5, orig.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of original splits to be 5 actual: ' + orig.Marketing_SOW_Project_Splits__r.size());
    	}

    	for (Oblix_SOW_Projects__c cloned: list_campaign_cloned){
			system.assertEquals(5, cloned.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of cloned splits to be 5 actual: ' + cloned.Marketing_SOW_Project_Splits__r.size());
    	}


    	// check assets cloned
    	List<Oblix_Project_Assets__c> list_assets_original = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Name in: list_original_campaign_names];
    	List<Oblix_Project_Assets__c> list_assets_cloned = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Name in: list_cloned_campaign_names];


    	system.assertEquals(60, list_assets_original.size(), 'Expecing #of original assets to be 60 actual: ' + list_assets_original.size());
    	system.assertEquals(60, list_assets_cloned.size(), 'Expecing #of cloned assets to be 60 actual: ' + list_assets_cloned.size());

    }




    private static testMethod void testCampaignsSync(){

    	initialiseTestClass();


    	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);


    	Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


		Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

		// insert attachment
		List<Attachment> list_attach = new List<Attachment>();   	
		for (Integer i=0; i < 20; i++){
			list_attach.add(new Attachment(Name = 'Unite Test Attachment '+i, Body = Blob.valueOf('Unit Test Attachment Body'), ParentId = mSow.Id ));
		}

        insert list_attach;

		List<Oblix_Project_Assets__c> list_assets_in_basket = new List<Oblix_Project_Assets__c>();
		Oblix_SOW_Projects__c project;

		// all campaigns should have the same business driver score 
		for (Id campaign_id : map_campaigns_to_test.keySet()){

			project = map_campaigns_to_test.get(campaign_id);

			project.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
			
		}	
		
		update map_campaigns_to_test.values();


        // how many SOWs require Cloning? 
        Integer sow_requested_clone_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

        // how many SOWs require Sync? 
        Integer sow_requested_sync_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

        // how many campaigns require sync?
        Integer campaign_requested_sync_size = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

		// find out how many assets are in scope?
        Integer assets_requested_sync_size = [SELECT count() FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];
											  
        system.debug('### total sow_requested_clone_size: ' + sow_requested_clone_size + ' - sow_requested_sync_size: '
            + sow_requested_sync_size + ' - campaign_requested_sync_size' + campaign_requested_sync_size + ' - assets_requested_sync_size: ' + assets_requested_sync_size);

        system.assertEquals(3, campaign_requested_sync_size, 'Expecing 3 campaigns actual was ' + campaign_requested_sync_size);

		Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);
    	
        system.assertEquals(4, Oblix_SyncBatchJob.list_job_components.size(), 'Expecing 4 job components actual was ' + Oblix_SyncBatchJob.list_job_components.size());


    	//Database.executeBatch(job_process_batch,1);

		Oblix_SyncBatchJob.addEvent('******************************STARTED EXECUTING STEPS******************************',NULL);

    	for (Oblix_SyncBatchJob.jobComponent job_component : Oblix_SyncBatchJob.list_job_components){
        	system.assertNotEquals(job_component.process_name, NULL, 'process name cannot be null! ');
        	if (Oblix_SyncBatchJob.sync_job.job_has_error){

				Oblix_SyncBatchJob.addEvent('ERROR OCCURED ABORTING JOB!',NULL);
			}
			else{
				Oblix_SOWRolloverLogic.processStep(job_component);
				Oblix_SyncBatchJob.addEvent('EXECUTING PROCESS: ' + job_component.process_name + ' - CHUNK#: ' + job_component.chunk_number 
					+ ' - ATTRIB1: ' + job_component.attrib_1 + ' - ATTRIB2: ' + job_component.attrib_2 + ' - ATTRIB3: ' + job_component.attrib_3 ,NULL);
			}
    	}
		Oblix_SyncBatchJob.addEvent('******************************COMPLETED EXECUTING STEPS******************************',NULL);

        system.debug(Oblix_SyncBatchJob.sync_job.process_result);

    	// check SOW cloned
    	Marketing_SOW__c sow_original = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME ];
    	Marketing_SOW__c sow_cloned = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME + 'CLONED'];


    	system.assertEquals(sow_cloned.Id, sow_original.Cloned_SOW__c, 'Expecing cloned SOW Id to be populated');
    	system.assertEquals(sow_original.Id, sow_cloned.Original_SOW__c, 'Expecing original SOW Id to be populated');

    	// check SOW cloned
    	List<Attachment> list_orignal_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_original.Id ];
    	List<Attachment> list_cloned_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_cloned.Id ];

    	system.assertEquals(20, list_orignal_attachments.size(), 'Expecing #of original attachments to be 20 actual: ' + list_orignal_attachments.size());
    	system.assertEquals(20, list_cloned_attachments.size(), 'Expecing #of cloned attachments to be 20 actual: ' + list_cloned_attachments.size());


    	List<String> list_original_campaign_names = new List<String>();
    	List<String> list_cloned_campaign_names = new List<String>();
    	for (Integer i=1; i<=3; i++){
    		list_original_campaign_names.add('TEST_CAMPAIGN_' + Datetime.now().format('M/d/yyyy') + '_' +i);
    		list_cloned_campaign_names.add('TEST_CAMPAIGN_' + Datetime.now().format('M/d/yyyy') + '_' +i+'CLONED');
    	}

    	system.debug('#### TESTING: ' + JSON.serialize([SELECT Name FROM Oblix_SOW_Projects__c]));
    	system.debug('#### TESTING: ' + JSON.serialize(list_original_campaign_names));

    	// check campaigns cloned
    	List<Oblix_SOW_Projects__c> list_campaign_original = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Name in: list_original_campaign_names ];
    	List<Oblix_SOW_Projects__c> list_campaign_cloned = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Name in: list_cloned_campaign_names];


    	system.assertEquals(3, list_campaign_original.size(), 'Expecing #of original campaign to be 3 actual: ' + list_campaign_original.size());
    	system.assertEquals(3, list_campaign_cloned.size(), 'Expecing #of cloned campaign to be 3 actual: ' + list_campaign_cloned.size());

    	for (Oblix_SOW_Projects__c orig: list_campaign_original){
			system.assertEquals(5, orig.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of original splits to be 5 actual: ' + orig.Marketing_SOW_Project_Splits__r.size());
    	}

    	for (Oblix_SOW_Projects__c cloned: list_campaign_cloned){
			system.assertEquals(5, cloned.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of cloned splits to be 5 actual: ' + cloned.Marketing_SOW_Project_Splits__r.size());
    	}


    	// check assets cloned
    	List<Oblix_Project_Assets__c> list_assets_original = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Name in: list_original_campaign_names];
    	List<Oblix_Project_Assets__c> list_assets_cloned = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Name in: list_cloned_campaign_names];


    	system.assertEquals(60, list_assets_original.size(), 'Expecing #of original assets to be 60 actual: ' + list_assets_original.size());
    	system.assertEquals(60, list_assets_cloned.size(), 'Expecing #of cloned assets to be 60 actual: ' + list_assets_cloned.size());

    }


    private static void testSOWClone(){

    	initialiseTestClass();


    	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);


    	Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


		Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

		mSow.Sync_Status__c = Oblix_Utils.JOB_STATUS_CLONE_REQUESTED;
		update mSow;


		// insert attachment

		List<Attachment> list_attach = new List<Attachment>();   	
		for (Integer i=0; i < 20; i++){
			list_attach.add(new Attachment(Name = 'Unite Test Attachment '+i, Body = Blob.valueOf('Unit Test Attachment Body'), ParentId = mSow.Id ));
		}
        insert list_attach;

		List<Oblix_Project_Assets__c> list_assets_in_basket = new List<Oblix_Project_Assets__c>();
		Oblix_SOW_Projects__c project;

        // how many SOWs require Cloning? 
        Integer sow_requested_clone_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

        // how many SOWs require Sync? 
        Integer sow_requested_sync_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

        // how many campaigns require sync?
        Integer campaign_requested_sync_size = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

		// find out how many assets are in scope?
        Integer assets_requested_sync_size = [SELECT count() FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];
											  
        system.debug('### total sow_requested_clone_size: ' + sow_requested_clone_size + ' - sow_requested_sync_size: '
            + sow_requested_sync_size + ' - campaign_requested_sync_size' + campaign_requested_sync_size + ' - assets_requested_sync_size: ' + assets_requested_sync_size);

        system.assertEquals(3, campaign_requested_sync_size, 'Expecing 3 campaigns actual was ' + campaign_requested_sync_size);

		Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);
    	
        system.assertEquals(11, Oblix_SyncBatchJob.list_job_components.size(), 'Expecing 11 job components actual was ' + Oblix_SyncBatchJob.list_job_components.size());


    	//Database.executeBatch(job_process_batch,1);

		Oblix_SyncBatchJob.addEvent('******************************STARTED EXECUTING STEPS******************************',NULL);

    	for (Oblix_SyncBatchJob.jobComponent job_component : Oblix_SyncBatchJob.list_job_components){
        	system.assertNotEquals(job_component.process_name, NULL, 'process name cannot be null! ');
        	if (Oblix_SyncBatchJob.sync_job.job_has_error){

				Oblix_SyncBatchJob.addEvent('ERROR OCCURED ABORTING JOB!',NULL);
			}
			else{
				Oblix_SOWRolloverLogic.processStep(job_component);
				Oblix_SyncBatchJob.addEvent('EXECUTING PROCESS: ' + job_component.process_name + ' - CHUNK#: ' + job_component.chunk_number 
					+ ' - ATTRIB1: ' + job_component.attrib_1 + ' - ATTRIB2: ' + job_component.attrib_2 + ' - ATTRIB3: ' + job_component.attrib_3 ,NULL);
			}
    	}
		Oblix_SyncBatchJob.addEvent('******************************COMPLETED EXECUTING STEPS******************************',NULL);

        system.debug(Oblix_SyncBatchJob.sync_job.process_result);

    	// check SOW cloned
    	Marketing_SOW__c sow_original = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME ];
    	Marketing_SOW__c sow_cloned = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME + 'CLONED'];


    	system.assertEquals(sow_cloned.Id, sow_original.Cloned_SOW__c, 'Expecing cloned SOW Id to be populated');
    	system.assertEquals(sow_original.Id, sow_cloned.Original_SOW__c, 'Expecing original SOW Id to be populated');

    	// check SOW cloned
    	List<Attachment> list_orignal_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_original.Id ];
    	List<Attachment> list_cloned_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_cloned.Id ];

    	system.assertEquals(20, list_orignal_attachments.size(), 'Expecing #of original attachments to be 20 actual: ' + list_orignal_attachments.size());
    	system.assertEquals(20, list_cloned_attachments.size(), 'Expecing #of cloned attachments to be 20 actual: ' + list_cloned_attachments.size());


    	List<String> list_original_campaign_names = new List<String>();
    	List<String> list_cloned_campaign_names = new List<String>();
    	for (Integer i=1; i<=3; i++){
    		list_original_campaign_names.add('TEST_CAMPAIGN_' + Datetime.now().format('M/d/yyyy') + '_' +i);
    		list_cloned_campaign_names.add('TEST_CAMPAIGN_' + Datetime.now().format('M/d/yyyy') + '_' +i+'CLONED');
    	}

    	system.debug('#### TESTING: ' + JSON.serialize([SELECT Name FROM Oblix_SOW_Projects__c]));
    	system.debug('#### TESTING: ' + JSON.serialize(list_original_campaign_names));

    	// check campaigns cloned
    	List<Oblix_SOW_Projects__c> list_campaign_original = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Name in: list_original_campaign_names ];
    	List<Oblix_SOW_Projects__c> list_campaign_cloned = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Name in: list_cloned_campaign_names];


    	system.assertEquals(3, list_campaign_original.size(), 'Expecing #of original campaign to be 3 actual: ' + list_campaign_original.size());
    	system.assertEquals(3, list_campaign_cloned.size(), 'Expecing #of cloned campaign to be 3 actual: ' + list_campaign_cloned.size());

    	for (Oblix_SOW_Projects__c orig: list_campaign_original){
			system.assertEquals(5, orig.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of original splits to be 5 actual: ' + orig.Marketing_SOW_Project_Splits__r.size());
    	}

    	for (Oblix_SOW_Projects__c cloned: list_campaign_cloned){
			system.assertEquals(5, cloned.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of cloned splits to be 5 actual: ' + cloned.Marketing_SOW_Project_Splits__r.size());
    	}


    	// check assets cloned
    	List<Oblix_Project_Assets__c> list_assets_original = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Name in: list_original_campaign_names];
    	List<Oblix_Project_Assets__c> list_assets_cloned = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Name in: list_cloned_campaign_names];


    	system.assertEquals(60, list_assets_original.size(), 'Expecing #of original assets to be 60 actual: ' + list_assets_original.size());
    	system.assertEquals(60, list_assets_cloned.size(), 'Expecing #of cloned assets to be 60 actual: ' + list_assets_cloned.size());

	
    }


}