/*

******************************************************************
Initial Approval Steps
******************************************************************
- User sets sync_status__c to “Clone Requested"
- Scheduled job to count the total #SOWs requiring clone, together with related Attachments, Campaigns, Non-Campaigns, Hub&Splits, and Assets
- Initiate a batch job to perform the cloning. Count and create sufficient number of job components to:
    - Set the status of SOW from “Clone Requested” to “Clone In Progress” - there will be validation to stop editing SOW and related records
    - Clone SOW, update original SOW with lookup to the “Cloned SOW” Id and stamp in the field - filter to ignore SOWs which already have this lookup populated
    - Copy attachments from Orig-Clone - to avoid reprocessing attachments keep static set of attachment Ids
    - Copy campaigns from Orig-Clone together with their Hub-Splits - populate “Original Campaign” and “Cloned Campaign” Ids - add filter to avoid these Campaigns in the next runs
    - Clone assets from Orig-Clone and populate “Cloned Asset” and “Original Asset” lookups
    - Update SOW status from “Clone In Progress” to “Clone Complete"


******************************************************************
Initial Rollover
******************************************************************
- User sets sync_status__c to “Sync Requested” on parent SOW or individual Campaigns
    - sync_status for related campaigns should go from “Sync Required” to “Sync Requested"
- Scheduled job to count the total #SOWs requiring sync, together with related Attachments, Campaigns, Hub&Splits, and Assets
- Initiate a batch job to perform the sync. Count and create sufficient number of job components to:
    - Set status from “Sync Requested” to “Sync in Progress” on the Original SOW
        - If NFY field is populated on Orig SOW then do nothing - if blank then sync is required
        - If NFY field is populated on Orig and also “Sync Requested”
        - Clone attachments which are under “Sync Requested” SOWs - to avoid reprocessing attachments keep static set of attachment Ids
        - Clone campaigns and Hub-Splits under SOWs which are “Sync In Progress” - set PFY and NFY
        - Clone assets which are under SOWs which are “Sync In Progress” - set PFY and NFY
        - Set status from “Sync in Progress” to Sync Complete on Original SOW
    - Set status from “Sync Requested” to “Sync In Progress” on Original and Related Campaigns
    - Adjust attributes for Campaigns from Orig-NFY - delete and recreate Hub&Splits - if required -
        - copy over the calculator fees and box number to PFY
        - copy the chevron box info to NFY
        - If the % complete is equal 100% then need to delete the NFY related campaign
    - Get all the related assets under Orig campaigns which are “Sync In Progress”
        - If NFY not stamped then need to clone asset and stamp on the NFY record and update NFY lookup field
    - Reset Campaign Status from “Sync In Progress” to “Sync Complete"

Oblix_SyncBatchJob jobProcessBatch = new Oblix_SyncBatchJob(5, 20, 300, 30000 );
Database.executeBatch(jobProcessBatch,1);


*/
public class Oblix_SyncBatchJob implements Database.Batchable<JobComponent>, Database.Stateful {
	
	String query;
	public String process_result;
	public Boolean job_has_error;
	public Set<Id> processed_attachment_ids;


	private static final String OBJECT_SOW = 'Marketing_SOW__c';
	private static final String OBJECT_CAMPAIGN = 'Oblix_SOW_Projects__c';
	
	// SOW FIELDS
	private static final String ORIGINAL_SOW = 'Original_SOW__c';
	private static final String CLONED_SOW = 'Cloned_SOW__c';
	private static final String SOW_PFY = 'SOW_PFY__c';
	private static final String SOW_NFY = 'SOW_NFY__c';

	private static final String PARENT_SOW_PFY = 'Financial_Year__r.SOW_PFY__c';
	private static final String PARENT_SOW_NFY = 'Financial_Year__r.SOW_NFY__c';

	private static final String PARENT_SOW_ORIGINAL = 'Financial_Year__r.Original_SOW__c';
	private static final String PARENT_SOW_CLONED = 'Financial_Year__r.Cloned_SOW__c';

	// CAMPAIGN FIELDS
	private static final String ORIGINAL_CAMPAIGN = 'Original_Campaign__c';
	private static final String CLONED_CAMPAIGN = 'Cloned_Campaign__c';
	private static final String CAMPAIGN_PFY = 'Campaign_PFY__c';
	private static final String CAMPAIGN_NFY = 'Campaign_NFY__c';

	private static final String PARENT_CAMPAIGN_PFY = 'Agency_Projects__r.Campaign_PFY__c';
	private static final String PARENT_CAMPAIGN_NFY = 'Agency_Projects__r.Campaign_NFY__c';

	private static final String PARENT_CAMPAIGN_ORIGINAL = 'Agency_Projects__r.Original_Campaign__c';
	private static final String PARENT_CAMPAIGN_CLONED = 'Agency_Projects__r.Cloned_Campaign__c';

	// ASSET FIELDS
	private static final String ORIGINAL_ASSET = 'Original_Asset__c';
	private static final String CLONED_ASSET = 'Cloned_Asset__c';
	private static final String ASSET_PFY = 'Asset_PFY__c';
	private static final String ASSET_NFY = 'Asset_NFY__c';


	public Map<Id, Id> map_sow_to_cloned_id{get;set;}
	public static Oblix_SyncBatchJob sync_job;

	
	public static List<JobComponent> list_job_components;


	private static void addJobComponent(Integer number_of_chunks, String process_name, Integer row_limit, String attrib_1, String attrib_2, String attrib_3, String attrib_4, String attrib_5){
        for (Integer i=0;i<number_of_chunks;i++){

	        /*###############################################
	            ADD JOB COMPONENT FOR THE REQUIRED PROCESS
	        #################################################*/
            list_job_components.add(new JobComponent(process_name, row_limit, i+1 , attrib_1, attrib_2, attrib_3, attrib_4, attrib_5));

        } // end for

		addEvent('ADDING PROCESS: ' + process_name + ' - #CHUNKS: ' + number_of_chunks,NULL);

	}

	public Oblix_SyncBatchJob(Integer clone_sow_size, Integer sync_sow_size ,Integer sync_campaign_size) {
		
		processed_attachment_ids = new Set<Id>();
		list_job_components = new List<JobComponent>();
		job_has_error = false;
		process_result = '\n\n';
		sync_job = this;

		if (clone_sow_size > 0){
			buildJobComponentsForCloning(clone_sow_size);
		}

		if (sync_sow_size >0 || sync_campaign_size >0 ){
			buildJobComponentsForSync(sync_sow_size, sync_campaign_size);
		}

	}
	public static void buildJobComponentsForSync(Integer sow_size, Integer campaign_size){


        // how many attachments?
        Integer total_attachments = [SELECT count() FROM Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED)];

        // find out how many campaigns are in scope?
        Integer total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];
		
        // find out how many assets are in scope?
        Integer total_assets = [SELECT count() FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

		addEvent('******************************************************************',NULL);
		addEvent('started sync batch job',NULL);
		addEvent('\nsow_size: ' + sow_size + '\ntotal_attachments: ' + total_attachments + '\ntotal_campaigns: ' + total_campaigns + '\ntotal_assets: ' + total_assets,NULL);
		addEvent('******************************************************************',NULL);


		// depending on the number of the rows passed in calculate how many job components are required
        Integer number_of_chunks = 0;

        //#################################################
        //	ADD JOB COMPONENT FOR SETTING THE STATUS TO IN PROGRESS
        //#################################################
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_REQUESTED, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, OBJECT_SOW, NULL, NULL);


        //#################################################
        //	ADD JOB COMPONENT TO SYNC SOW
        //#################################################
	    	// initial sync:
	        // 		attrib_1: SOW_PFY__c
	        // 		attrib_2: SOW_NFY__c
	        // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_SOW, Oblix_Utils.MAX_SOWS_PER_CONTEXT
        	, SOW_PFY,SOW_NFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, NULL, NULL);


        number_of_chunks = getNumberOfChuncks(total_attachments,Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT TO SYNC ATTACHMENTS
        //#################################################
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_ATTACHMENTS, Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,NULL,NULL, NULL, NULL);

 		number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT TO SYNC CAMPAIGNS
        //#################################################
			// initial sync:
            // 		attrib_1: Financial_Year__r.SOW_PFY__c
            // 		attrib_2: Financial_Year__r.SOW_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: Campaign_NFY__c
            // 		attrib_5: Campaign_PFY__c
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_CAMPAIGN, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
        	, PARENT_SOW_PFY,PARENT_SOW_NFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, CAMPAIGN_NFY, CAMPAIGN_PFY);


 		number_of_chunks = getNumberOfChuncks(total_assets,Oblix_Utils.MAX_ASSETS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT TO SYNC ASSETS
        //#################################################
			// initial sync:
            // 		attrib_1: Agency_Projects__r.Campaign_PFY__c
            // 		attrib_2: Agency_Projects__r.Campaign_NFY__c
            // 		attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            // 		attrib_4: Asset_NFY__c
            // 		attrib_5: Asset_PFY__c
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_ASSETS, Oblix_Utils.MAX_ASSETS_PER_CONTEXT
        	, PARENT_CAMPAIGN_PFY,PARENT_CAMPAIGN_NFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,ASSET_NFY ,ASSET_PFY);


        //#################################################
        //	ADD JOB COMPONENT FOR SETTING THE STATUS TO SYNC COMPLETE
        //#################################################
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, Oblix_Utils.JOB_STATUS_SYNC_COMPLETED,OBJECT_SOW, NULL, NULL);



        // find out how many campaigns are in scope?
        total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];
		
        // find out how many assets are in scope on sync campaign?
        total_assets = [SELECT count() FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

		addEvent('******************************************************************',NULL);
		addEvent('started sync on individual campaigns batch job',NULL);
		addEvent('total_campaigns: ' + total_campaigns + '\ntotal_assets: ' + total_assets,NULL);
		addEvent('******************************************************************',NULL);

        //#################################################
        //	ADD JOB COMPONENT FOR SETTING THE STATUS TO IN PROGRESS
        //  ON BOTH ORIGINAL AND CLONED(NFY) CAMPAIGNS
        //#################################################
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CAMPAIGN_SET_STATUS, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_REQUESTED, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,OBJECT_CAMPAIGN, NULL, NULL);


        //#################################################
        //	ADD JOB COMPONENT TO SYNC CAMPAIGNS
        //#################################################
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_ADJUST_CAMPAIGN, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,NULL,NULL, NULL, NULL);


 		number_of_chunks = getNumberOfChuncks(total_assets,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT TO SYNC ASSETS
        //#################################################
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_ADJUST_ASSETS, Oblix_Utils.MAX_ASSETS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,NULL,NULL, NULL, NULL);


        //#################################################
        //	ADD JOB COMPONENT FOR SETTING THE STATUS FROM IN PROGRESS
        //	TO SYNC COMPLETE
        //  ON BOTH ORIGINAL AND CLONED(NFY) CAMPAIGNS
        //#################################################
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CAMPAIGN_SET_STATUS, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, Oblix_Utils.JOB_STATUS_SYNC_COMPLETED,OBJECT_CAMPAIGN, NULL, NULL);
	}

	public static void buildJobComponentsForCloning(Integer sow_size){


        // how many attachments?
        Integer total_attachments = [SELECT count() FROM Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED)];

        // find out how many campaigns are in scope?
        Integer total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];
		
        // find out how many assets are in scope?
        Integer total_assets = [SELECT count() FROM Oblix_Project_Assets__c WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

		addEvent('******************************************************************',NULL);
		addEvent('started clone batch job',NULL);
		addEvent('sow_size: ' + sow_size + '\ntotal_attachments: ' + total_attachments + '\ntotal_campaigns: ' + total_campaigns + '\ntotal_assets: ' + total_assets,NULL);
		addEvent('******************************************************************',NULL);


		// depending on the number of the rows passed in calculate how many job components are required
        Integer number_of_chunks = 0;

        //#################################################
        //	ADD JOB COMPONENT FOR SETTING THE STATUS TO IN PROGRESS
        //#################################################
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_CLONE_REQUESTED, Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS,OBJECT_SOW, NULL, NULL);


        //#################################################
        //	ADD JOB COMPONENT FOR CLONING SOW
        //#################################################
            // clone sow:
            // 		attrib_1: Original_SOW__c
            // 		attrib_2: Cloned_SOW__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_SOW, Oblix_Utils.MAX_SOWS_PER_CONTEXT
        	, ORIGINAL_SOW, CLONED_SOW ,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, NULL, NULL);


        number_of_chunks = getNumberOfChuncks(total_attachments,Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT FOR CLONING ATTACHMENTS
        //#################################################
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_ATTACHMENTS, Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS,NULL,NULL, NULL, NULL);

 		number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT FOR CLONING CAMPAIGNS
        //#################################################
            // clone campaign:
            // 		attrib_1: Financial_Year__r.Original_SOW__c
            // 		attrib_2: Financial_Year__r.Cloned_SOW__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            // 		attrib_4: Cloned_Campaign__c
            // 		attrib_5: Original_Campaign__c
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_CAMPAIGN, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
        	, PARENT_SOW_ORIGINAL ,PARENT_SOW_CLONED,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, CLONED_CAMPAIGN, ORIGINAL_CAMPAIGN);


 		number_of_chunks = getNumberOfChuncks(total_assets,Oblix_Utils.MAX_ASSETS_PER_CONTEXT);
        //#################################################
        //	ADD JOB COMPONENT FOR CLONING ASSETS
        //#################################################
            // clone assets:
            // 		attrib_1: Agency_Projects__r.Original_Campaign__c
            // 		attrib_2: Agency_Projects__r.Cloned_Campaign__c
            // 		attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            // 		attrib_4: Cloned_Asset__c
            // 		attrib_5: Original_Asset__c

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_ASSETS, Oblix_Utils.MAX_ASSETS_PER_CONTEXT
        	, PARENT_CAMPAIGN_ORIGINAL , PARENT_CAMPAIGN_CLONED ,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, CLONED_ASSET, ORIGINAL_ASSET);


        //#################################################
        //	ADD JOB COMPONENT FOR SETTING THE STATUS TO COMPLETED
        //#################################################
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
        	, Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, Oblix_Utils.JOB_STATUS_CLONE_COMPLETED,OBJECT_SOW,NULL, NULL);


	}

	public Iterable<JobComponent> start(Database.BatchableContext BC) {
		
		return list_job_components;
	}

   	public void execute(Database.BatchableContext BC, List<JobComponent> list_scope) {
		
		sync_job = this;

		system.debug('## this is: ' + this);
		//process_result = '';
		for (JobComponent scope : list_scope){

			addEvent('scope: ' + JSON.serialize(scope),NULL);
			addEvent('EXECUTING PROCESS: ' + scope.process_name + ' - CHUNK#: ' + scope.chunk_number 
				+ ' - ATTRIB1: ' + scope.attrib_1 + ' - ATTRIB2: ' + scope.attrib_2 + ' - ATTRIB3: ' + scope.attrib_3 
				+ ' - ATTRIB4: ' + scope.attrib_4 + ' - ATTRIB5: ' + scope.attrib_5, NULL);

			if (sync_job.job_has_error){

				addEvent('ERROR OCCURED ABORTING JOB!',NULL);
				//system.debug(sync_job.process_result);
        
                // update the job status 
                //finaliseBatchJob();

                // abort the job
                system.abortJob(BC.getJobId());
			}
			else{
				//Oblix_SOWRolloverLogic.processStep(scope);
			}
		}

	}
	
	public void finish(Database.BatchableContext BC) {
		sync_job = this;
		addEvent('******************************************************************',NULL);
		addEvent('completed sync batch job',NULL);
		addEvent('******************************************************************',NULL);

		system.debug(sync_job.process_result);
		
	}


	public static void addEvent(String event_message, String dml_exception){

		sync_job.process_result += '** ' + event_message;
		if (String.isNotBlank(dml_exception)){
			sync_job.process_result += 'EXCEPTION: ' + dml_exception; 
		}

		sync_job.process_result += '\n\n';

	}

	public class JobComponent{
		public String process_name;
		public Integer query_limit;
		public Integer chunk_number;
		public String attrib_1;
		public String attrib_2;
		public String attrib_3;
		public String attrib_4;
		public String attrib_5;

		public JobComponent(String process_name, Integer query_limit, Integer chunk_number, String attrib_1, String attrib_2, String attrib_3, String attrib_4, String attrib_5){
			this.process_name = process_name;
			this.query_limit = query_limit;
			this.chunk_number = chunk_number;
			this.attrib_1 = attrib_1;
			this.attrib_2 = attrib_2;
			this.attrib_3 = attrib_3;
			this.attrib_4 = attrib_4;
			this.attrib_5 = attrib_5;
		}
	}
	

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-27
    * @description  Calculates the total number of chuncks needed to process all records
                    for a given job component
    ********************************************************************************/
    private static Integer getNumberOfChuncks(Integer totalRecords, Integer recordsPerChuncks){

        Integer numberOfChuncks = 0;

        if (NULL!= recordsPerChuncks && recordsPerChuncks >0 
                && null!=totalRecords && totalRecords > 0 ) {

                numberOfChuncks = integer.valueOf((decimal.valueOf(totalRecords)/
                        decimal.valueOf(recordsPerChuncks)).setScale(0,system.RoundingMode.CEILING)) ;
        }

        return numberOfChuncks;
    }
}