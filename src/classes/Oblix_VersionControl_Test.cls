@isTest
public with sharing class Oblix_VersionControl_Test {
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

    private static testMethod void testStartAndStopJobs(){
        
        String cron_job = 'TEST JOB SCHEDULED';

        Oblix_VersionControl.cron_job_name = cron_job;

        Test.startTest();
            Oblix_VersionControl.scheduleJobs();
        Test.stopTest();

        String all_cron_jobs = cron_job + '%';

        List<CronTrigger> running_job = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE: all_cron_jobs];
        
        system.assertEquals(60, running_job.size(), 'Expected number of cron jobs do not match!');
        Oblix_VersionControl.cancelJobs();

        List<CronTrigger> abort_job = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE: all_cron_jobs];
        
        system.assertEquals(0, abort_job.size(), 'Expected number of cron jobs do not match!');


    }

    private static testMethod void testSOWSync(){
        
        initialiseTestClass();

        System.runAs(qa1_user){

            MDO_Brand__c brand = Oblix_TestUtils.createBrand(Oblix_TestUtils.DEFAULT_BRAND_NAME, Oblix_TestUtils.BRAND_STATUS_ACTIVE);


            Marketing_SOW__c mSow = Oblix_TestUtils.createTestMarketingSow(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME, Oblix_TestUtils.SOW_STATUS_OPEN, brand.id);


            Map<Id, Oblix_SOW_Projects__c> map_campaigns_to_test = Oblix_TestUtils.insertCampaignsWithRelatedRecords(3,20,5,mSow.Id,'Total turnover >€400m', 'Global campaign (all market clusters)', 'Up to 4 locations', 'New – Multi channel');
            system.assert(true,map_campaigns_to_test!=null);
            // insert attachment
            insert Oblix_TestUtils.createAttachment(mSow.Id, 30);


            // insert non-campaign
            insert Oblix_TestUtils.createMarketingBasics(mSow.Id, 50);


            mSow = [SELECT Sync_Status__c, Name, Name_Prefix__c, Name_Suffix__c,Marketing_SOW__c.Financial_Year__c FROM Marketing_SOW__c WHERE Id =: mSow.Id];
            system.debug('### mSow.Sync_Status__c: ' + mSow.Sync_Status__c);

            // request cloning for this SOW
            mSow.Sync_Status__c = Oblix_Utils.JOB_STATUS_SYNC_REQUESTED;
            
            update mSow;

            
            mSow = [SELECT Sync_Status__c,Name_Prefix__c,Name,Financial_Year__c FROM Marketing_SOW__c WHERE Id =: mSow.Id];
            system.debug('### mSow.Sync_Status__c: ' + mSow.Sync_Status__c);

            system.assertEquals(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME,mSow.Name_Prefix__c, 'Incorrect name prefix is set');
            system.assertEquals(Oblix_TestUtils.DEFAULT_MARKETING_SOW_NAME + Oblix_Utils.FY_SEPARATOR + Oblix_SOWHandlerLogic.getFinancialYear(mSow)
                ,mSow.Name, 'Incorrect name is set');   

            checkInitialDataSetup(0, 1, 0, 60 );
        }



        System.runAs(admin_super_user) {

            Test.startTest();
                Oblix_VersionControl.checkAndInitialiseBatchJob();
            Test.stopTest();
            
            Set<string> set_async_status = new Set<string>{'Queued','Processing','Preparing','Holding'};
            Integer running_job = [SELECT count() From AsyncApexJob WHERE  ApexClass.Name = 'Oblix_SyncBatchJob' AND JobType = 'BatchApex' AND Status in: set_async_status];


            system.assertEquals(0,running_job, 'There should be no jobs running');


        }
    }

    


}