@isTest
public with sharing class Oblix_SOWRollOverLogic_Test {

	private static List<Asset_Scoring__c> list_of_asset_scoring;
	private static user admin_super_user;
	private static user qa1_user;
	//private static user super_user;

	private static void initialiseTestClass(){

		admin_super_user = Oblix_TestUtils.createAdminSuperUser();
        System.runAs(admin_super_user) {


        	list_of_asset_scoring = Oblix_TestUtils.createAssetScoringRecords(10);	
        	insert list_of_asset_scoring;

        	insert Oblix_TestUtils.createOblixCustomSettings();
        	insert Oblix_TestUtils.createOblixJobOrchestrationCustomSetting();
        	insert Oblix_TestUtils.createBoxRangeCalculatorRecords();
        	insert Oblix_TestUtils.createCountryCalculatorRecords();

			Oblix_CalculatorLogic.getCalculatorRecords();

    	}

    	qa1_user = Oblix_TestUtils.createQA1User();
    	//super_user = Oblix_TestUtils.createSuperUser();
    }

    private static Integer sow_requested_clone_size;
    private static Integer sow_requested_sync_size;
    private static Integer campaign_requested_sync_size;
    private static Integer assets_requested_sync_size;

    private static void checkInitialDataSetup(Integer sow_clone_size, Integer sow_sync_size, Integer campaign_sync_size, Integer asset_sync_size){


        // how many SOWs require Cloning? 
        sow_requested_clone_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

        // how many SOWs require Sync? 
        sow_requested_sync_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

        // how many campaigns require sync?
        campaign_requested_sync_size = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

		// find out how many assets are in scope?
        assets_requested_sync_size = [SELECT count() FROM Oblix_Project_Assets__c 
        	WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED
        	OR Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];
											  
        system.debug('### total sow_requested_clone_size: ' + sow_requested_clone_size + ' - sow_requested_sync_size: '
            + sow_requested_sync_size + ' - campaign_requested_sync_size' + campaign_requested_sync_size + ' - assets_requested_sync_size: ' + assets_requested_sync_size);

        system.assertEquals(sow_clone_size, sow_requested_clone_size, 'Expecing 1 clone sow actual was ' + sow_requested_clone_size);
        system.assertEquals(sow_sync_size, sow_requested_sync_size, 'Expecing 0 sync sow actual was ' + sow_requested_sync_size);
        system.assertEquals(campaign_sync_size, campaign_requested_sync_size, 'Expecing 0 campaigns actual was ' + campaign_requested_sync_size);
        system.assertEquals(asset_sync_size, assets_requested_sync_size, 'Expecing 60 campaigns actual was ' + assets_requested_sync_size);
		
    }


    private static testMethod void testSOWSync(){

    	
    	initialiseTestClass();

    	System.runAs(qa1_user){

        	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);


	    	Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


			Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

			// insert attachment
			insert Oblix_TestUtils.createAttachment(mSow.Id, 30);


			// insert non-campaign
			insert Oblix_TestUtils.createMarketingBasics(mSow.Id, 50);


			mSow = [SELECT Sync_Status__c, Name, Name_Prefix__c, Name_Suffix__c,Marketing_SOW__c.Financial_Year__c FROM Marketing_SOW__c WHERE Id =: mSow.Id];
	        system.debug('### mSow.Sync_Status__c: ' + mSow.Sync_Status__c);

			mSow.Initial_Approval_Complete__c = true;
			mSow.Name_Suffix__c = Oblix_Utils.NAME_SUFFIX_LIVE;
			mSow.SOW_Status__c = Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES;
			
			update mSow;


	        Integer i = 0;
	        // all campaigns should have the same business driver score 
	        for (Id campaign_id : map_campaigns_to_test.keySet()){

		        // set 
		        // campaign 1 to 100%
		        // campaign 2 to 60%
		        // campaign 3 to 50% and cancelled

		        // expect only campaign #2 to be copied over to next FY

	            Oblix_SOW_Projects__c project = map_campaigns_to_test.get(campaign_id);

	        	if (0==i){
	        		project.Percentage_of_Fee_for_this_FY__c = 100;
	        	}
	        	else if (1==i){
	        		project.Percentage_of_Fee_for_this_FY__c = 60;
	        	}
	        	else{
	        		project.Percentage_of_Fee_for_this_FY__c = 50;
	        		project.Campaign_Status__c = Oblix_Utils.CAMPAIGN_STATUS_CANCELLED;
	        	}
	            i++;
	        }

	        update map_campaigns_to_test.values();	

			// request cloning for this SOW
			mSow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
			
			update mSow;

	        
			mSow = [SELECT Sync_Status__c,Name_Prefix__c,Name,Financial_Year__c FROM Marketing_SOW__c WHERE Id =: mSow.Id];
	        system.debug('### mSow.Sync_Status__c: ' + mSow.Sync_Status__c);

	        system.assertEquals(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,mSow.Name_Prefix__c, 'Incorrect name prefix is set');
	        system.assertEquals(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME + Oblix_Utils.FY_SEPARATOR + Oblix_SOWHandlerLogic.getFinancialYear(mSow) + ' (' + Oblix_Utils.NAME_SUFFIX_LIVE + ')'
	        	,mSow.Name, 'Incorrect name is set');	

        	checkInitialDataSetup(0, 1, 0, 60 );
    	}



		System.runAs(admin_super_user) {


			Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);
	    	
	        system.assertEquals(18, job_process_batch.list_job_components.size(), 'Incorrect number of job components populated!');
	    	//***** EXECUTE JOB COMPONENTS
	    	processJobComponents(job_process_batch.list_job_components);


			List<Marketing_SOW__c> list_sow = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c, SOW_NFY__r.Name FROM Marketing_SOW__c LIMIT 10];
	        system.debug('### mSow result: ' + JSON.serialize(list_sow));


	        system.debug(Oblix_SyncBatchJob.sync_job.process_result);

	    	// check SOW cloned
	    	Marketing_SOW__c sow_original = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c 
	    		WHERE Name_Prefix__c =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME AND Name_Suffix__c =: Oblix_Utils.NAME_SUFFIX_LIVE AND Financial_Year__c = 'FY2016'];

	    	Marketing_SOW__c sow_cloned = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c 
	    		WHERE Name_Prefix__c =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME AND Name_Suffix__c = ''  AND Financial_Year__c = 'FY2017'];


	    	system.assertEquals(sow_cloned.Id, sow_original.SOW_NFY__c, 'Expecing NFY SOW Id to be populated');
	    	system.assertEquals(sow_original.Id, sow_cloned.SOW_PFY__c, 'Expecing PFY SOW Id to be populated');


	    	// check non-campaigns cloned
	    	List<Marketing_Basics__c> list_orignal_non_campaigns = [SELECT Name FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: sow_original.Id ];
	    	List<Marketing_Basics__c> list_cloned_non_campaigns = [SELECT Name FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: sow_cloned.Id ];

	    	system.assertEquals(50, list_orignal_non_campaigns.size(), 'Expecing #of original non-campaigns to be 50 actual: ' + list_orignal_non_campaigns.size());
	    	
	    	// non-campaign items should not get copied over
	    	system.assertEquals(0, list_cloned_non_campaigns.size(), 'Expecing #of cloned non-campaigns to be 0 actual: ' + list_cloned_non_campaigns.size());

	    	// check attachments cloned
	    	List<Attachment> list_orignal_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_original.Id ];
	    	List<Attachment> list_cloned_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_cloned.Id ];

	    	system.assertEquals(30, list_orignal_attachments.size(), 'Expected #of original attachments dont match!');
	    	system.assertEquals(30, list_cloned_attachments.size(), 'Expected #of cloned attachments dont match!');


	    	// check campaigns cloned
	    	List<Oblix_SOW_Projects__c> list_campaign_original = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c
	    		, Financial_Year__c, Financial_Year__r.Name, Financial_Year__r.Sync_Status__c
	    		, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_COMPLETED ];
	    	
	    	List<Oblix_SOW_Projects__c> list_campaign_cloned = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c
	    		, Financial_Year__c, Financial_Year__r.Name, Financial_Year__r.Sync_Status__c
	    		, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c = NULL ];


	    	system.debug('##### CAMPAIGNS ORIGINAL: ' + JSON.serialize(list_campaign_original));
	    	system.debug('##### CAMPAIGNS CLONED: ' + JSON.serialize(list_campaign_cloned));

	    	system.assertEquals(3, list_campaign_original.size(), 'Expected #of original campaign not matching actuals!');
	    	system.assertEquals(1, list_campaign_cloned.size(), 'Expected #of cloned campaign not matching actuals!');

	    	for (Oblix_SOW_Projects__c orig: list_campaign_original){
				system.assertEquals(5, orig.Marketing_SOW_Project_Splits__r.size(), 'Expected #of original splits not matching actual');
	    	}

	    	for (Oblix_SOW_Projects__c cloned: list_campaign_cloned){
				system.assertEquals(5, cloned.Marketing_SOW_Project_Splits__r.size(), 'Expected #of cloned splits not matching actual');
	    	}


	    	// check assets cloned
	    	List<Oblix_Project_Assets__c> list_assets_original = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_COMPLETED];
	    	List<Oblix_Project_Assets__c> list_assets_cloned = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c = NULL ];


	    	system.assertEquals(60, list_assets_original.size(), 'Expected #of original assets not matching actual');
	    	system.assertEquals(20, list_assets_cloned.size(), 'Expected #of cloned assets not matching actual');
	    }



    }


    private static void processJobComponents(List<Oblix_SyncBatchJob.jobComponent> job_components){

    	Test.startTest();
	        Oblix_SyncBatchJob.addEvent('******************************STARTED EXECUTING JOB STEPS STEPS******************************',NULL);
	        Oblix_SyncBatchJob batch_job = new Oblix_SyncBatchJob(1,1,1);
	        batch_job.updateJobRunningCustomSetting(true);

	        for (Oblix_SyncBatchJob.jobComponent job_component : job_components){
	            system.assertNotEquals(job_component.process_name, NULL, 'process name cannot be null! ');
	            if (Oblix_SyncBatchJob.sync_job.job_has_error){

	                Oblix_SyncBatchJob.addEvent('ERROR OCCURED ABORTING JOB!',NULL);
	            }
	            else{
	                Oblix_SyncBatchJob.addEvent('EXECUTING PROCESS: ' + job_component.process_name + ' - CHUNK#: ' + job_component.chunk_number + ' - QUERY LIMIT: ' + job_component.query_limit
	                    + ' - ATTRIB1: ' + job_component.attrib_1 + ' - ATTRIB2: ' + job_component.attrib_2 + ' - ATTRIB3: ' + job_component.attrib_3
	                    + ' - ATTRIB4: ' + job_component.attrib_4 + ' - ATTRIB5: ' + job_component.attrib_5 + ' - ATTRIB6: ' + job_component.attrib_6,NULL);
	                Oblix_SOWRolloverLogic.processStep(job_component);
	            }
	        }
	        batch_job.updateJobRunningCustomSetting(false);

	        Oblix_SyncBatchJob.addEvent('******************************COMPLETED EXECUTING JOB STEPS******************************',NULL);
	    Test.stopTest();
    }



    private static testMethod void testSOWClone(){

    	initialiseTestClass();

    	System.runAs(qa1_user){

	    	MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);


	    	Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_Utils.SOW_STATUS_DRAFT_WITH_UNILEVER, brand.id);


			Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');

			// insert attachment
			insert Oblix_TestUtils.createAttachment(mSow.Id, 40);


			// insert non-campaign
			insert Oblix_TestUtils.createMarketingBasics(mSow.Id, 50);

			// request cloning for this SOW
			mSow.Sync_Status__c = Oblix_Utils.JOB_STATUS_CLONE_REQUESTED;
			update mSow;



	        
			mSow = [SELECT Sync_Status__c FROM Marketing_SOW__c WHERE Id =: mSow.Id];
	        system.debug('### mSow.Sync_Status__c: ' + mSow.Sync_Status__c);
			
	        checkInitialDataSetup(1, 0, 0, 60 );


	    	

		}

		system.runAs(admin_super_user){

			Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);

	        system.assertEquals(16, job_process_batch.list_job_components.size(), 'Expected #of job components dont match!');

	    	//***** EXECUTE JOB COMPONENTS
	    	processJobComponents(job_process_batch.list_job_components);


	        system.debug(Oblix_SyncBatchJob.sync_job.process_result);

	    	// check SOW cloned
	    	Marketing_SOW__c sow_original = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name_Prefix__c =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME AND Name_Suffix__c =: Oblix_Utils.NAME_SUFFIX_APPROVED ];
	    	Marketing_SOW__c sow_cloned = [SELECT Name, Original_SOW__c, Cloned_SOW__c, SOW_PFY__c, SOW_NFY__c FROM Marketing_SOW__c WHERE Name_Prefix__c =: Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME AND Name_Suffix__c =:  Oblix_Utils.NAME_SUFFIX_LIVE];


	    	system.assertEquals(sow_cloned.Id, sow_original.Cloned_SOW__c, 'Expecing cloned SOW Id to be populated');
	    	system.assertEquals(sow_original.Id, sow_cloned.Original_SOW__c, 'Expecing original SOW Id to be populated');


	    	// check non-campaigns cloned
	    	List<Marketing_Basics__c> list_orignal_non_campaigns = [SELECT Name FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: sow_original.Id ];
	    	List<Marketing_Basics__c> list_cloned_non_campaigns = [SELECT Name FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: sow_cloned.Id ];

	    	system.assertEquals(50, list_orignal_non_campaigns.size(), 'Expecing #of original non-campaigns to be 50 actual: ' + list_orignal_non_campaigns.size());
	    	system.assertEquals(50, list_cloned_non_campaigns.size(), 'Expecing #of cloned non-campaigns to be 50 actual: ' + list_cloned_non_campaigns.size());

	    	// check attachments cloned
	    	List<Attachment> list_orignal_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_original.Id ];
	    	List<Attachment> list_cloned_attachments = [SELECT Name FROM Attachment WHERE ParentId =: sow_cloned.Id ];

	    	system.assertEquals(40, list_orignal_attachments.size(), 'Expected #of original attachments dont match!');
	    	system.assertEquals(40, list_cloned_attachments.size(), 'Expected #of cloned attachments dont match');


	    	// check campaigns cloned
	    	List<Oblix_SOW_Projects__c> list_campaign_original = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c
	    		, Financial_Year__c, Financial_Year__r.Name, Financial_Year__r.Sync_Status__c
	    		, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_COMPLETED ];
	    	
	    	List<Oblix_SOW_Projects__c> list_campaign_cloned = [SELECT Name, Original_Campaign__c, Cloned_Campaign__c, Campaign_PFY__c, Campaign_NFY__c
	    		, Financial_Year__c, Financial_Year__r.Name, Financial_Year__r.Sync_Status__c
	    		, (SELECT Name FROM Marketing_SOW_Project_Splits__r) FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c = NULL ];


	    	system.debug('##### CAMPAIGNS ORIGINAL: ' + JSON.serialize(list_campaign_original));
	    	system.debug('##### CAMPAIGNS CLONED: ' + JSON.serialize(list_campaign_cloned));

	    	system.assertEquals(3, list_campaign_original.size(), 'Expecing #of original campaign to be 3 actual: ' + list_campaign_original.size());
	    	system.assertEquals(3, list_campaign_cloned.size(), 'Expecing #of cloned campaign to be 3 actual: ' + list_campaign_cloned.size());

	    	for (Oblix_SOW_Projects__c orig: list_campaign_original){
				system.assertEquals(5, orig.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of original splits to be 5 actual: ' + orig.Marketing_SOW_Project_Splits__r.size());
	    	}

	    	for (Oblix_SOW_Projects__c cloned: list_campaign_cloned){
				system.assertEquals(5, cloned.Marketing_SOW_Project_Splits__r.size(), 'Expecing #of cloned splits to be 5 actual: ' + cloned.Marketing_SOW_Project_Splits__r.size());
	    	}


	    	// check assets cloned
	    	List<Oblix_Project_Assets__c> list_assets_original = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_COMPLETED ];
	    	List<Oblix_Project_Assets__c> list_assets_cloned = [SELECT Name, Original_Asset__c, Cloned_Asset__c, Asset_PFY__c, Asset_NFY__c FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c = NULL ];


	    	system.assertEquals(60, list_assets_original.size(), 'Expecing #of original assets to be 60 actual: ' + list_assets_original.size());
	    	system.assertEquals(60, list_assets_cloned.size(), 'Expecing #of cloned assets to be 60 actual: ' + list_assets_cloned.size());

		}
	
    }


}