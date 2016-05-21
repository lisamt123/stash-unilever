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
public with sharing class Oblix_SyncBatchJob implements Database.Batchable<JobComponent>, Database.Stateful {
    
    String query;
    public String process_result;
    public Boolean job_has_error;
    public Set<Id> processed_attachment_ids;
    public Set<Id> processed_non_campaign_ids;


    public static final String OBJECT_SOW = 'Marketing_SOW__c';
    public static final String OBJECT_CAMPAIGN = 'Oblix_SOW_Projects__c';
    
    private static final String EVENT_ADD = '******************************************************************';
    
    // SOW FIELDS
    public static final String ORIGINAL_SOW = 'Original_SOW__c';
    public static final String CLONED_SOW = 'Cloned_SOW__c';
    public static final String SOW_PFY = 'SOW_PFY__c';
    public static final String SOW_NFY = 'SOW_NFY__c';
    public static final String ATTACHMENT_CLONED = 'Attachments_Cloned__c';
    public static final String SOW_STATUS_FIELD = 'SOW_Status__c';

    // CAMPAIGN FIELDS
    public static final String PARENT_SYNC_FIELD = 'Financial_Year__r.Sync_Status__c';
    public static final String PARENT_SOW_STATUS_FIELD = 'Financial_Year__r.SOW_Status__c';
    public static final String SYNC_FIELD = 'Sync_Status__c';
    public static final String CAMPAIGN_ATTRIBUTE_UPDATE = 'Campaign_Attributes_Updated__c';
    public static final String SYNC_STEP_FIELD = 'Sync_Step__c';
    public static final String SYNC_STEP_COMPLETED = 'Completed';

    public static final String ORIGINAL_CAMPAIGN = 'Original_Campaign__c';
    public static final String CLONED_CAMPAIGN = 'Cloned_Campaign__c';
    public static final String CAMPAIGN_PFY = 'Campaign_PFY__c';
    public static final String CAMPAIGN_NFY = 'Campaign_NFY__c';

    // ASSET FIELDS
    public static final String ORIGINAL_ASSET = 'Original_Asset__c';
    public static final String CLONED_ASSET = 'Cloned_Asset__c';
    public static final String ASSET_PFY = 'Asset_PFY__c';
    public static final String ASSET_NFY = 'Asset_NFY__c';

    public static final String TRUE_VALUE = 'true';
    public static final String FALSE_VALUE = 'false';

    public Map<Id, Id> map_sow_to_cloned_id{get;set;}
    public static Oblix_SyncBatchJob sync_job = null;

    
    public List<JobComponent> list_job_components;


    private static void addJobComponent(Integer number_of_chunks, String process_name, Integer row_limit, String attrib_1
        , String attrib_2, String attrib_3, String attrib_4, String attrib_5, String attrib_6){

        for (Integer i=0;i<number_of_chunks;i++){

            /*###############################################
                ADD JOB COMPONENT FOR THE REQUIRED PROCESS
            #################################################*/
            sync_job.list_job_components.add(new JobComponent(process_name, row_limit, i+1 , attrib_1, attrib_2, attrib_3, attrib_4, attrib_5, attrib_6));

        } // end for

        addEvent('ADDING PROCESS: ' + process_name + ' - #CHUNKS: ' + number_of_chunks,NULL);

    }

    public Oblix_SyncBatchJob(Integer clone_sow_size, Integer sync_sow_size ,Integer sync_campaign_size) {
        
        processed_attachment_ids = new Set<Id>();
        processed_non_campaign_ids = new Set<Id>();
        list_job_components = new List<JobComponent>();
        job_has_error = false;
        process_result = '\n\n';
        sync_job = this;

        system.debug('### started batch - sync_sow_size: ' + sync_sow_size + ' - clone_sow_size: ' + clone_sow_size + ' - sync_campaign_size : ' +sync_campaign_size );

        if (clone_sow_size > 0){
            buildJobComponentsForCloning(clone_sow_size);
        }

        if (sync_sow_size >0 || sync_campaign_size >0 ){
            buildJobComponentsForSync(sync_sow_size, sync_campaign_size);
        }
        //system.debug(sync_job.process_result);

    }
    

    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-27
    * @description  Calculates the total number of chuncks needed to process all records
                    for a cloning sows when triggered during initial approval
    ********************************************************************************/
    public static void buildJobComponentsForCloning(Integer sow_size){


        addEvent(EVENT_ADD,NULL);
        addEvent('started building job components to clone SOWs',NULL);


        // depending on the number of the rows passed in calculate how many job components are required
        Integer number_of_chunks = 0;

        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE SOW STATUS 
        //  TO IN PROGRESS
        //#################################################

            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            // set sow status:
            //      attrib_1: 'clone requested'
            //      attrib_2: 'clone in progress'
            //      attrib_3: SOW
            //      attrib_4: Sync_Status__c
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_CLONE_REQUESTED, Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS,OBJECT_SOW, SYNC_FIELD, NULL,NULL);



        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE CAMPAIGN STATUS 
        //  TO IN PROGRESS
        //#################################################
        
        // find out how many campaigns are in scope?
        Integer total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS 
            OR Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //  set campaign status - all campaigns below parent sow
            //      attrib_1: 'clone in progress' - parent status
            //      attrib_2: 'clone in progress' - set campaign status
            //      attrib_3: SOW
            //      attrib_4: parent SOW
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS,OBJECT_CAMPAIGN, PARENT_SYNC_FIELD, NULL,NULL);



        //#################################################
        //  ADD JOB COMPONENT FOR CLONING SOW
        //#################################################
            // clone sow:
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_6: Process type (Initial Approval)
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_SOW, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , ORIGINAL_SOW, CLONED_SOW ,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, NULL, NULL, Oblix_Utils.PROCESS_TYPE_INITIAL_APPROVAL);


        //#################################################
        //  ADD JOB COMPONENT FOR CLONING CAMPAIGNS
        //#################################################

        // find out how many campaigns are in scope - don't go via parent SOW to collect older/failed campaigns
        total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS
            OR Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

            // clone campaign:
            //      attrib_1: Original_SOW__c
            //      attrib_2: Cloned_SOW__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: Cloned_Campaign__c
            //      attrib_5: Original_Campaign__c
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_CAMPAIGN, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , ORIGINAL_SOW ,CLONED_SOW,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, CLONED_CAMPAIGN, ORIGINAL_CAMPAIGN, Oblix_Utils.PROCESS_TYPE_INITIAL_APPROVAL);



        //#################################################
        //  ADD JOB COMPONENT FOR CLONING ATTACHMENTS
        //#################################################
        // how many attachments?
        Integer total_attachments = [SELECT count() FROM Attachment WHERE ParentId in (SELECT id from Marketing_SOW__c 
            WHERE (Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS
            OR Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED) AND Attachments_Cloned__c = false)];

        number_of_chunks = getNumberOfChuncks(total_attachments,Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_ATTACHMENTS, Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT
            , ORIGINAL_SOW ,CLONED_SOW,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, Oblix_Utils.SOW_STATUS_APPROVED_BY_AGENCY, NULL,NULL);



        //#################################################
        //  ADD JOB COMPONENT FOR SETTING ATTACHMENT CLONED
        //	AGAINST THE PARENT SOWS
        //#################################################
        // how many attachments?
            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: attachment_cloned/attribute updated? value to be set true/false
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag        
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
        
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS ,TRUE_VALUE,Oblix_Utils.SOW_STATUS_APPROVED_BY_AGENCY, OBJECT_SOW, ATTACHMENT_CLONED,SOW_STATUS_FIELD);


        //#################################################
        //  ADD JOB COMPONENT FOR CLONING NON-CAMPAIGNS
        //#################################################
        // how many non campaigns?
        Integer total_non_campaigns = [SELECT count() FROM Marketing_Basics__c 
            WHERE Oblix_SOWMarketing__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS
            OR Oblix_SOWMarketing__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

        number_of_chunks = getNumberOfChuncks(total_non_campaigns,Oblix_Utils.MAX_NON_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_NON_CAMPAIGN, Oblix_Utils.MAX_NON_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS,NULL,NULL, NULL, NULL,NULL);


        //#################################################
        //  ADD JOB COMPONENT FOR CLONING ASSETS
        //#################################################

        // find out how many assets are in scope?
        Integer total_assets = [SELECT count() FROM Oblix_Project_Assets__c 
            WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS
            OR Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];
    
        number_of_chunks = getNumberOfChuncks(total_assets,Oblix_Utils.MAX_ASSETS_PER_CONTEXT);

            // clone assets:
            //      attrib_1: Agency_Projects__r.Original_Campaign__c
            //      attrib_2: Agency_Projects__r.Cloned_Campaign__c
            //      attrib_3: JOB_STATUS_CLONE_IN_PROGRESS
            //      attrib_4: Cloned_Asset__c
            //      attrib_5: Original_Asset__c

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_ASSETS, Oblix_Utils.MAX_ASSETS_PER_CONTEXT
            , ORIGINAL_CAMPAIGN , CLONED_CAMPAIGN ,Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, CLONED_ASSET, ORIGINAL_ASSET,NULL);


        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE CAMPAIGN STATUS 
        //  TO CLONE COMPLETE
        //#################################################
            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //  set campaign status - all campaigns below parent sow
            //      attrib_1: 'clone in progress' - campaign status
            //      attrib_2: 'clone complete' - campaign status
            //      attrib_3: campaign
            //      attrib_4: sync status

        // find out how many campaigns are in scope - collect older/failed campaigns
        total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS
            OR Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];
        
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);


        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, Oblix_Utils.JOB_STATUS_CLONE_COMPLETED,OBJECT_CAMPAIGN, SYNC_FIELD, NULL,NULL);

        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE SOW STATUS 
        //  TO CLONE COMPLETE
        //#################################################
            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //  set sow status
            //      attrib_1: 'clone in progress' - sow status
            //      attrib_2: 'clone complete' - sow status
            //      attrib_3: sow
            //      attrib_4: sync status

        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS, Oblix_Utils.JOB_STATUS_CLONE_COMPLETED,OBJECT_SOW,SYNC_FIELD, NULL,NULL);

        addEvent('sow_size: ' + sow_size + '\ntotal_non_campaigns: ' + total_non_campaigns + '\ntotal_attachments: ' + total_attachments + '\ntotal_campaigns: ' + total_campaigns + '\ntotal_assets: ' + total_assets,NULL);
        addEvent(EVENT_ADD,NULL);

    }


    /*******************************************************************************
    * @author       Execloud ©
    * @date         2016-04-27
    * @description  Calculates the total number of chuncks needed to process all records
                    for a syncing sows and campaigns during rollover transition
    ********************************************************************************/
    public static void buildJobComponentsForSync(Integer sow_size, Integer campaign_size){


        addEvent(EVENT_ADD,NULL);
        addEvent('started building job components to sync SOWs',NULL);


        // depending on the number of the rows passed in calculate how many job components are required
        Integer number_of_chunks = 0;


        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE SOW STATUS 
        //  TO IN PROGRESS
        //#################################################

            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            // set sow status:
            //      attrib_1: 'sync requested'
            //      attrib_2: 'sync in progress'
            //      attrib_3: SOW
            //      attrib_4: Sync_Status__c
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_REQUESTED, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, OBJECT_SOW, SYNC_FIELD, NULL, NULL);



        //#################################################
        //  ADD JOB COMPONENT TO SYNC SOW
        //#################################################
            // initial sync:
            //      attrib_1: SOW_PFY__c
            //      attrib_2: SOW_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_6: Process type (rollover)
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_SOW, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , SOW_PFY,SOW_NFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, NULL, NULL, Oblix_Utils.PROCESS_TYPE_ROLLOVER);


        //#################################################
        //  ADD JOB COMPONENT TO SYNC ATTACHMENTS
        //#################################################
        // how many attachments?
        Integer total_attachments = [SELECT count() FROM Attachment WHERE ParentId in (SELECT id FROM Marketing_SOW__c 
            WHERE (Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED) AND Attachments_Cloned__c = false)];

        number_of_chunks = getNumberOfChuncks(total_attachments,Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_CLONE_ATTACHMENTS, Oblix_Utils.MAX_ATTACHMENTS_PER_CONTEXT
            , SOW_PFY,SOW_NFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES, NULL, NULL);


        //#################################################
        //  ADD JOB COMPONENT FOR SETTING ATTACHMENT CLONED
        //	AGAINST THE PARENT SOWS
        //#################################################
        // how many attachments?
            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: attachment_cloned/attribute updated? value to be set true/false
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag        
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
        
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS ,TRUE_VALUE,Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES, OBJECT_SOW, ATTACHMENT_CLONED,SOW_STATUS_FIELD);



        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE CAMPAIGN STATUS 
        //  TO SYNC IN PROGRESS - PARENT SOW HAS SYNC REQUESTED 
        //  FIRST TIME THE USER CLICKS INITIATE ROLLOVER
        //#################################################
            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            // set campaign status on children of sow in progress:
            //      attrib_1: 'sync in progress'
            //      attrib_2: 'sync in progress'
            //      attrib_3: campaign
            //      attrib_4: Sync_Status__c
        // find out how many campaigns are in scope - collect older/failed campaigns
        Integer total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR  Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];
        
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,OBJECT_CAMPAIGN, PARENT_SYNC_FIELD,NULL ,NULL);



        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE CAMPAIGN STATUS 
        //  TO SYNC IN PROGRESS - INDIVIDUAL CAMPAIGNS ARE
        //  MARKED AS SYNC REQUESTED
        //#################################################
            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //  set campaign status individual campaigns
            //      attrib_1: 'sync requested' - campaign status
            //      attrib_2: 'sync in progress' - campaign status
            //      attrib_3: Campaign
            //      attrib_4: sync status
            //      attrib_5: pfy campaign

        // find out how many campaigns are in scope - don't go via parent SOW to collect older/failed campaigns
        total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED
            OR Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS];
        
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_SOWS_PER_CONTEXT);


        // because we are updating the original campaigns as well as the cloned campaigns, devide rows_per_context by 2
        // to make sure we are not running out of DML rows]
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Integer.valueOf(Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT / 2)
            , Oblix_Utils.JOB_STATUS_SYNC_REQUESTED, Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,OBJECT_CAMPAIGN, SYNC_FIELD,CAMPAIGN_PFY ,NULL);




        //#################################################
        //  ADD JOB COMPONENT TO SYNC CAMPAIGNS
        //  THIS SHOULD PICK UP CAMPAIGNS INDIVIDUALLY 
        //  MARKED TO SYNC OR CAMPAIGNS MARKED AS SYNC AS A 
        //  RESULT OF PARENT SOW MARKED AS SYNC
        //#################################################
            // initial sync:
            //      attrib_1: 
            //      attrib_2: SOW_PFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: 
            //      attrib_5: 
            //      attrib_6: Type of process

        // find out how many campaigns are in scope?
        total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR  Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED
            OR Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR  Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);


        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_ADJUST_CAMPAIGN, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , SOW_NFY,CAMPAIGN_PFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, NULL, NULL,Oblix_Utils.PROCESS_TYPE_ROLLOVER);


        //#################################################
        //  ADD JOB COMPONENT TO SYNC ASSETS
        //#################################################     
            // initial sync:
            //      attrib_1: Campaign_PFY__c
            //      attrib_2: Campaign_NFY__c
            //      attrib_3: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_4: Asset_NFY__c
            //      attrib_5: Asset_PFY__c
        // find out how many assets are in scope?
        Integer total_assets = [SELECT count() FROM Oblix_Project_Assets__c 
            WHERE Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR Agency_Projects__r.Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED
            OR Agency_Projects__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR Agency_Projects__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

        number_of_chunks = getNumberOfChuncks(total_assets,Oblix_Utils.MAX_ASSETS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SYNC_ASSETS, Oblix_Utils.MAX_ASSETS_PER_CONTEXT
            , CAMPAIGN_PFY,CAMPAIGN_NFY,Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS,ASSET_NFY ,ASSET_PFY,NULL);



        //#################################################
        //  ADD JOB COMPONENT FOR SETTING SYNC STEP
        //	BACK TO BLANK FOR CAMPAIGNS WHICH ALREADY BEEN PROCESSED
        //#################################################
        // how many attachments?
            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: value to be set BLANK
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag        
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
        
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS ,SYNC_STEP_COMPLETED,Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES, OBJECT_CAMPAIGN, SYNC_STEP_FIELD,PARENT_SOW_STATUS_FIELD);



        //#################################################
        //  ADD JOB COMPONENT FOR RECALCULATING CAMPAIGN FEES 
        //	BASED ON PFY AND CFY CALCULATOR
        //#################################################
        // how many attachments?
            // job component attribute list
            //      attrib_1: JOB_STATUS_SYNC_IN_PROGRESS
            //      attrib_2: 
            //      attrib_3: 
            //      attrib_4: 
            //      attrib_5: 
            //      attrib_6: 

        // find out how many campaigns are in scope
        total_campaigns = [SELECT count() FROM Oblix_SOW_Projects__c 
            WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR  Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED
            OR Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS
            OR  Financial_Year__r.Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];
        
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_RECALCULATE_FEES_PFY, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS ,NULL,NULL, NULL, NULL,NULL);


        //#################################################
        //  ADD JOB COMPONENT FOR SETTING FLAG 'ATTRIBUTES UPDATED' 
        //	BACK TO FALSE FOR CAMPAIGNS WHICH ALREADY BEEN PROCESSED
        //#################################################
        // how many attachments?
            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: attachment_cloned/attribute updated? value to be set true/false
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag        
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
        
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS ,FALSE_VALUE,Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES, OBJECT_CAMPAIGN, CAMPAIGN_ATTRIBUTE_UPDATE,PARENT_SOW_STATUS_FIELD);



        //#################################################
        //  ADD JOB COMPONENT FOR SETTING SYNC STEP
        //	BACK TO BLANK FOR CAMPAIGNS WHICH ALREADY BEEN PROCESSED
        //#################################################
        // how many attachments?
            // job component attribute list
            //      attrib_1: sync status
            //      attrib_2: value to be set BLANK
            //      attrib_3: original status
            //      attrib_4: object type
            //      attrib_5: field used for flag        
            //      attrib_6: field used for checking sow status (either Financial_Year__r.SOW_Status__c or SOW_Status__c)
        
        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_PROCESSING_FLAG, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS ,SYNC_STEP_COMPLETED,NULL, OBJECT_CAMPAIGN, SYNC_STEP_FIELD,NULL);


        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE CAMPAIGN STATUS 
        //  TO SYNC COMPLETE
        //#################################################
            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            //  set campaign status - all campaigns below parent sow
            //      attrib_1: 'sync in progress' - campaign status
            //      attrib_2: 'sync completed' - campaign status to be
            //      attrib_3: Campaign
            //      attrib_4: sync status




        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, Oblix_Utils.JOB_STATUS_SYNC_COMPLETED,OBJECT_CAMPAIGN, SYNC_FIELD,NULL ,NULL);


        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE SOW STATUS 
        //  FROM IN-PROGRESS TO SYNC COMPLETE
        //#################################################
            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            // set sow status:
            //      attrib_1: 'sync in progress'
            //      attrib_2: 'sync completed'
            //      attrib_3: SOW
            //      attrib_4: Sync_Status__c
        number_of_chunks = getNumberOfChuncks(sow_size,Oblix_Utils.MAX_SOWS_PER_CONTEXT);

        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS, Oblix_Utils.JOB_STATUS_SYNC_COMPLETED,OBJECT_SOW, SYNC_FIELD, NULL,NULL);




        //#################################################
        //  ADD JOB COMPONENT FOR SETTING THE SOW STATUS 
        //  FROM CAMPAIGN SYNC REQUIRED TO SYNC COMPLETE 
        //#################################################

            // job component attribute list
            //      attrib_1: initial status
            //      attrib_2: status to be
            //      attrib_3: sObject type
            //      attrib_4: field to use for checking sync
            //      attrib_5: field to use for locking campaign of next FY

            // set sow status:
            //      attrib_1: 'campaign sync required'
            //      attrib_2: 'sync completed'
            //      attrib_3: SOW
            //      attrib_4: Sync_Status__c

        number_of_chunks = getNumberOfChuncks(total_campaigns,Oblix_Utils.MAX_CAMPAIGNS_PER_CONTEXT);
        addJobComponent(number_of_chunks,Oblix_Utils.JOB_PROCESS_SET_STATUS, Oblix_Utils.MAX_SOWS_PER_CONTEXT
            , Oblix_Utils.SOW_STATUS_CAMPAIGN_SYNC_REQUIRED, Oblix_Utils.JOB_STATUS_SYNC_COMPLETED, OBJECT_SOW, SYNC_FIELD, NULL, NULL);



        addEvent('\nsow_size: ' + sow_size + '\ntotal_attachments: ' + total_attachments + '\ntotal_campaigns: ' + total_campaigns + '\ntotal_assets: ' + total_assets,NULL);
        addEvent(EVENT_ADD,NULL);
    }


    public Iterable<JobComponent> start(Database.BatchableContext BC) {
        
        // set job is running to block workflows updating campaigns
        updateJobRunningCustomSetting(true);
        sync_job = this;
        return sync_job.list_job_components;
    }

    public void execute(Database.BatchableContext BC, List<JobComponent> list_scope) {
        
        sync_job = this;

        //system.debug('## this is: ' + this);
        //process_result = '';
        for (JobComponent scope : list_scope){


            if (sync_job.job_has_error){

                addEvent('ERROR OCCURED ABORTING JOB!',NULL);
                
        		finalise();
                // update the job status 
                //finaliseBatchJob();

                // abort the job
                system.abortJob(BC.getJobId());
            }
            else{
            	
	            Oblix_SyncBatchJob.addEvent('EXECUTING PROCESS: ' + scope.process_name + ' - CHUNK#: ' + scope.chunk_number + ' - QUERY LIMIT: ' + scope.query_limit
	                    + ' - ATTRIB_1: ' + scope.attrib_1 + ' - ATTRIB_2: ' + scope.attrib_2 + ' - ATTRIB_3: ' + scope.attrib_3
	                    + ' - ATTRIB_4: ' + scope.attrib_4 + ' - ATTRIB_5: ' + scope.attrib_5 + ' - ATTRIB_6: ' + scope.attrib_6,NULL);

                Oblix_SOWRolloverLogic.processStep(scope);
            }
        }

    }
    
    public void finish(Database.BatchableContext BC) {
        sync_job = this;
        addEvent(EVENT_ADD,NULL);
        addEvent('completed sync batch job',NULL);
        addEvent(EVENT_ADD,NULL);
        finalise();
    }

    private void finalise(){

        // set job running back to false to allow workflows working again
        updateJobRunningCustomSetting(false);
        
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
        public String attrib_6;

        public JobComponent(String process_name, Integer query_limit, Integer chunk_number, String attrib_1
            , String attrib_2, String attrib_3, String attrib_4, String attrib_5, String attrib_6){

            this.process_name = process_name;
            this.query_limit = query_limit;
            this.chunk_number = chunk_number;
            this.attrib_1 = attrib_1;
            this.attrib_2 = attrib_2;
            this.attrib_3 = attrib_3;
            this.attrib_4 = attrib_4;
            this.attrib_5 = attrib_5;
            this.attrib_6 = attrib_6;
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


	public void updateJobRunningCustomSetting(boolean new_value){

		Oblix_Job_Orchestration__c job_is_running = Oblix_Job_Orchestration__c.getOrgDefaults();
		job_is_running.Job_Is_Running__c = new_value;

		update job_is_running;

    }
}