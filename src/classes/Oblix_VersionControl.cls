global with sharing class Oblix_VersionControl implements Schedulable {

	//private Id sowid;

    //private static final String CLONE_SUFFIX = ' - Open for Updates';
    //private static final String ORIGINAL_SUFFIX = ' - Approved version';
    //private static final String CLONE_SUFFIX = ' (Live)';
    //private static final String ORIGINAL_SUFFIX = ' (Approved)';


    global void execute(SchedulableContext SC) {
            
        //List<Marketing_SOW__c> sows = [SELECT Id, Active__c,Agency_Contact__c,Agency_Name__c,Agency_SOW_Approver_Name__c,Approval_Submitter__c,BB_or_BD__c,
        //                                    BigOblixProductCategory__c,Brand_Name__c,Currency__c,Financial_Year__c,MarketingSOWParent__c,Name,OblixBrand__c,
        //                                    OblixSOWOverallTotal__c,OblixTotalCampaignCalculatedTotalFee__c,OblixTotalNumberofbasics__c,OblixTotalNumberofprojects__c,
        //                                    OblixTotalOtherItemsFees__c,Oblix_AgencyEstimate__c,Oblix_Current_FY_Total__c,Oblix_TotalCampaignAdjustment__c,
        //                                    OwnerId,Percentage_of_Total_Fee_Campaign_Fees__c,Percentage_of_Total_Fee_Non_Campaign__c,RecordTypeId,SmallProductCategory__c
        //                                    ,SOW_Creator_is_Approver__c,SOW_Status__c,Total_Campaigns_This_FY__c,Total_Campaign_Fee_Agency__c,Total_Campaign_Fee__c,
        //                                    Type_of_SOW__c,Unilever_Lead__c,Unilever_SOW_Approver_Name__c
        //                            FROM Marketing_SOW__c WHERE Marked_for_cloning__c = true];

        //for (Marketing_SOW__c sow : sows) {
        //    copySOW(sow);
        //}


        checkAndInitialiseBatchJob();

    }

    public static void checkAndInitialiseBatchJob(){

        // if there is no other batch job currently running and we have some records to process
        // then initiate the batch job

        Set<string> set_async_status = new Set<string>{'Queued','Processing','Preparing','Holding'};
        Integer running_job = [SELECT count() From AsyncApexJob WHERE  ApexClass.Name = 'Oblix_SyncBatchJob' AND JobType = 'BatchApex' AND Status in: set_async_status];

        if (running_job == 0){
            // how many SOWs require Cloning? 
            Integer sow_requested_clone_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED];

            // how many SOWs require Sync? 
            Integer sow_requested_sync_size = [SELECT count() FROM Marketing_SOW__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

            // how many campaigns require sync?
            Integer campaign_requested_sync_size = [SELECT count() FROM Oblix_SOW_Projects__c WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED];

            system.debug('### total sow_requested_clone_size: ' + sow_requested_clone_size + ' - sow_requested_sync_size: '
                + sow_requested_sync_size + ' - campaign_requested_sync_size' + campaign_requested_sync_size);

            if (sow_requested_clone_size >0 || sow_requested_sync_size>0 || campaign_requested_sync_size> 0){

                system.debug('### starting the batch job');

                Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);
                Database.executeBatch(job_process_batch,1);
            }    
        }
    }

    // check if there is an existing batch job running and don't do anything
    // Check if there are any SOW/Campaign which need to be rolled-over
    //call the batch job to process

	//public Oblix_VersionControl(Id pSowId) {
	//	sowid = pSowId;
	//}


    /////*******************************************************************************
    ////* @author       Slavko Skular
    ////* @date         2016-04-06
    ////* @description  create a copy of the approvd SOW. This can be made a future
    ////                method if required (depending on number of campaigns, assets
    ////                and non-campaign items)
    ////********************************************************************************/
    //public void copySOW(Marketing_SOW__c sow){

    //    // clone SOW

    //    Marketing_SOW__c sowClone;
    //    Savepoint sp;

    //    try{

    //        sp = Database.setSavepoint();

    //        /*Marketing_SOW__c sow = [SELECT Id, Active__c,Agency_Contact__c,Agency_Name__c,Agency_SOW_Approver_Name__c,Approval_Submitter__c,BB_or_BD__c,
    //                                        BigOblixProductCategory__c,Brand_Name__c,Currency__c,Financial_Year__c,MarketingSOWParent__c,Name,OblixBrand__c,
    //                                        OblixSOWOverallTotal__c,OblixTotalCampaignCalculatedTotalFee__c,OblixTotalNumberofbasics__c,OblixTotalNumberofprojects__c,
    //                                        OblixTotalOtherItemsFees__c,Oblix_AgencyEstimate__c,Oblix_Current_FY_Total__c,Oblix_TotalCampaignAdjustment__c,
    //                                        OwnerId,Percentage_of_Total_Fee_Campaign_Fees__c,Percentage_of_Total_Fee_Non_Campaign__c,RecordTypeId,SmallProductCategory__c
    //                                        ,SOW_Creator_is_Approver__c,SOW_Status__c,Total_Campaigns_This_FY__c,Total_Campaign_Fee_Agency__c,Total_Campaign_Fee__c,
    //                                        Type_of_SOW__c,Unilever_Lead__c,Unilever_SOW_Approver_Name__c 
    //                                FROM Marketing_SOW__c WHERE Id =: sowId];*/

    //        sowClone = sow.clone(false, true, false, false);
    //        //sowClone.OwnerId = sow.OwnerId;
    //        //sowClone.OwnerId = UserInfo.getUserId();
    //        //sowClone.OwnerId = sow.Clone_Owner__c;
    //        sowClone.SOW_Status__c = Oblix_Utils.SOW_STATUS_OPEN_FOR_UPDATES;
    //        sowClone.Approved_version__c = sow.Id;
    //        sowClone.Name += CLONE_SUFFIX;

    //        insert sowClone;


    //        //Update original

    //        sow.Marked_for_cloning__c = false;
    //        sow.Cloning_failed__c = false;
    //        sow.Name += ORIGINAL_SUFFIX;
    //        update sow;



    //        // clone campaigns

    //        List<Oblix_SOW_Projects__c> master_campaigns = [SELECT Id,Stage_Projected_CFY__c, Stage_Completed_CFY__c, Agency_Percentage_of_Fees_to_this_FY__c,Asset_Deliverables__c,BET_first_release__c,Brand_Led_Growth__c,Budget_Burnt_to_date__c,Campaign_Countries__c,Campaign_Fees_Total__c
    //                ,Campaign_Hub_Summary__c,Campaign_Idea__c,Campaign_Points__c,Campaign_Score__c,Campaign_Splits_Total__c,Campaign_Status__c,Campaign_Total_Adjustment__c,Campaign_Total_Fees__c, First_3_selected_countries__c
    //                ,Completed_Stage__c,Date_for_Assets_to_be_in_BET__c,Description__c,Enforce_Trigger_Update__c,Fees_To_Be_Paid_Next_Financial_Year__c,Final_release__c,Financial_Year__c,First_Air_Date__c
    //                ,Innovation_Projects__c,IsDeleted,Is_this_High_Risk__c,Is_type_of_item_usually_poduced_by_this__c,Jobs_to_be_Done__c,List_Preview_Markets__c,Live_date_Asset_delivery__c,Live_Date__c
    //                ,Name,Number_of_Agency_Hub_Splits__c,Number_of_Markets_for_Preview__c,Number_of_Previews__c,OblixClonedFromParentProject__c,OblixProjectSplitPercentage_Comment__c,OblixRegion__c
    //                ,Oblix_ProjectBoxNumber__c,Other_Kinds_of_Research__c,Overall_Project_Complete__c,Percentage_of_Fee_for_Next_FY__c,Percentage_of_Fee_for_this_FY__c,Platform__c,Preview_Date__c
    //                ,Production_Completion_Date__c,Projected_Stage__c,ProjectTotalAssetscore__c,Project_Completion_Date__c,Project_Finish_Date__c,Project_Priority__c,Project_Scale_1__c,Project_Scale_2__c
    //                ,Project_Stage__c,Project_Start_Date__c,Region__c,Selected_Countries__c,Should_legal_review_this_project__c,Start_of_TV_production__c,Stimulus_Requirements__c,Timescale_Notes__c
    //                ,Total_Adapt_Fees__c,Total_Asset_Deliverables__c,Total_Digital_Fee__c,Total_Fees_for_Project__c,Total_Locations__c,Total_Project_Score__c,Total_Value_Driver__c,Value_To_BePaid_Manual_Override__c
    //                ,Value_to_be_paid_in_Current_FY__c, (SELECT Actual_Delivery_Date__c,Additional_Description__c,Agency_Projects__c,Asset_Description__c,Asset_name__c,Asset_Picklist__c,Asset_Scoring_Number__c, Description__c
    //                ,Asset_Title__c,Asset_Total_Score__c,Asset_Type__c,Calculator_Question__c,Category__c,Channels__c,FULL_Description__c,Location__c,Name,OblixClonedFromParentAsset__c,Option_Name__c,Quantity__c
    //                ,RecordTypeId,Sub_Category__c,SystemModstamp,Target_Delivery_Date__c,MDM_id__c,Asset_Score__c FROM Agency_Project_Assets__r)
    //                , (SELECT Enforce_Trigger_Update__c,Name,OblixCountry__c,Percentage__c,Project_Splits__c FROM Marketing_SOW_Project_Splits__r) 
    //                FROM Oblix_SOW_Projects__c WHERE Financial_Year__c = : sow.Id];

    //        Map<Id, Oblix_SOW_Projects__c> map_master_cloned_campaigns = new Map<Id, Oblix_SOW_Projects__c>();

    //        List<Oblix_SOW_Projects__c> liso_cloned_campaigns = new List<Oblix_SOW_Projects__c>();
    //        for(Oblix_SOW_Projects__c master_campaign : master_campaigns){
    //            Oblix_SOW_Projects__c cloned_project = master_campaign.clone(false,true,false,false);
    //            cloned_project.Name +=  clone_suffix;
    //            cloned_project.Financial_Year__c = sowClone.Id;
    //            map_master_cloned_campaigns.put(master_campaign.Id, cloned_project);
    //        }

    //        insert map_master_cloned_campaigns.values();




    //        // clone campaign assets

    //        List<Oblix_Project_Assets__c> li_clone_assets_to_insert = new List<Oblix_Project_Assets__c>();

    //        for(Oblix_SOW_Projects__c master_campaign : master_campaigns){
    //            for(Oblix_Project_Assets__c master_asset : master_campaign.Agency_Project_Assets__r){
    //                Oblix_Project_Assets__c cloned_asset = master_asset.clone(false,true,false,false);
    //                cloned_asset.Agency_Projects__c = map_master_cloned_campaigns.get(master_campaign.Id).Id;
    //                li_clone_assets_to_insert.add(cloned_asset);
    //            }
    //        }

    //        insert li_clone_assets_to_insert;




    //        // clone hub splits

    //        List<Oblix_Marketing_SOW_Project_Splits__c> li_cloned_hubs_to_insert = new List<Oblix_Marketing_SOW_Project_Splits__c>();

    //        for(Oblix_SOW_Projects__c master_campaign : master_campaigns){
    //            for (Oblix_Marketing_SOW_Project_Splits__c master_hub : master_campaign.Marketing_SOW_Project_Splits__r){
    //                Oblix_Marketing_SOW_Project_Splits__c cloned_hub = master_hub.clone(false,true,false,false);
    //                cloned_hub.Project_Splits__c = map_master_cloned_campaigns.get(master_campaign.Id).Id;
    //                li_cloned_hubs_to_insert.add(cloned_hub);
    //            }
    //        }

    //        insert li_cloned_hubs_to_insert;




    //        // clone non-campaign items

    //        List<Marketing_Basics__c> li_clone_non_campaigns_to_insert = new List<Marketing_Basics__c>();

    //        List<Marketing_Basics__c> master_non_campaigns = [SELECT Activities__c,Activity_Fee_Agency__c,Agency_Department__c,Agency__c,Description__c,Financial_Year_old__c,
    //                                            Financial_Year__c,FTE__c,Hourly_Rate_Agency__c,Id,Name,Non_Campaign_Key__c,Non_campaign_title__c,
    //                                            No_of_Hours_Required__c,OblixCountry__c,OblixOtherItemFee__c,Oblix_FTE_Real_Price__c,Oblix_Hourly_Rate__c,
    //                                            Oblix_SOWMarketing__c,Order__c,Other_Activities__c,RecordTypeId,Resource_Fee_Agency__c,Role_Title__c, OblixCountry__r.Name
    //                                        FROM Marketing_Basics__c WHERE Oblix_SOWMarketing__c =: sow.Id];

    //        for(Marketing_Basics__c master_non_campaign : master_non_campaigns){
    //            Marketing_Basics__c cloned_non_campaign = master_non_campaign.clone(false,true,false,false);
    //            cloned_non_campaign.Oblix_SOWMarketing__c = sowClone.Id;
    //            System.debug('### sow.Id: ' + sow.Id);
    //            System.debug('### cloneSow.Id: ' + sowClone.Id);
    //            if (master_non_campaign.Non_Campaign_Key__c != null) {
    //                cloned_non_campaign.Non_Campaign_Key__c = master_non_campaign.Non_Campaign_Key__c.replace(sow.Id, sowClone.Id);
    //            } else {
    //                cloned_non_campaign.Non_Campaign_Key__c = sowClone.Id + master_non_campaign.Activities__c;
    //                cloned_non_campaign.Non_Campaign_Key__c += master_non_campaign.OblixCountry__r == null ? '' : master_non_campaign.OblixCountry__r.Name;
    //                cloned_non_campaign.Non_Campaign_Key__c += master_non_campaign.Agency_Department__c + master_non_campaign.Role_Title__c;
    //            }
    //            li_clone_non_campaigns_to_insert.add(cloned_non_campaign);
    //        }

    //        insert li_clone_non_campaigns_to_insert;


    //        // clone attachments

    //        //List<Attachment> master_attachments = [SELECT Id FROM Attachment WHERE ParentId =: sow.Id];

    //        //for(Attachment master_attachment : master_attachments){
    //        //    cloneAttachment(master_attachment.Id, sowClone.Id);
    //        //}

    //    } catch (Exception e){
    //        // on any error, roll back all changes so no loose SOWs are left in the system
    //        System.debug(e);
    //        System.debug(e.getStackTraceString());
    //        Database.rollback(sp);

    //        sow.Cloning_failed__c = true;
    //        update sow;

    //    }

    //}

    //@future
    //private static void cloneAttachment(Id attachmentId, Id newParentId){

    //    Attachment master_attachment = [SELECT Body,ContentType,Description,Id,IsPrivate,Name,OwnerId,ParentId FROM Attachment WHERE Id =: attachmentId];

    //    Attachment clone_attachment = master_attachment.clone(false, true, false, false);
    //    clone_attachment.ParentId = newParentId;

    //    insert clone_attachment;

    //}


    public static void scheduleJobs() {
        System.schedule('Clone SOW Job 1', '0 1 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 2', '0 2 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 3', '0 3 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 4', '0 4 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 5', '0 5 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 6', '0 6 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 7', '0 7 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 8', '0 8 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 9', '0 9 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 10', '0 10 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 11', '0 11 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 12', '0 12 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 13', '0 13 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 14', '0 14 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 15', '0 15 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 16', '0 16 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 17', '0 17 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 18', '0 18 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 19', '0 19 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 20', '0 20 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 21', '0 21 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 22', '0 22 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 23', '0 23 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 24', '0 24 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 25', '0 25 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 26', '0 26 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 27', '0 27 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 28', '0 28 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 29', '0 29 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 30', '0 30 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 31', '0 31 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 32', '0 32 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 33', '0 33 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 34', '0 34 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 35', '0 35 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 36', '0 36 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 37', '0 37 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 38', '0 38 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 39', '0 39 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 40', '0 40 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 41', '0 41 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 42', '0 42 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 43', '0 43 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 44', '0 44 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 45', '0 45 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 46', '0 46 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 47', '0 47 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 48', '0 48 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 49', '0 49 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 50', '0 50 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 51', '0 51 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 52', '0 52 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 53', '0 53 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 54', '0 54 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 55', '0 55 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 56', '0 56 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 57', '0 57 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 58', '0 58 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 59', '0 59 * * * ?', new Oblix_VersionControl());
        System.schedule('Clone SOW Job 60', '0 0 * * * ?', new Oblix_VersionControl());
    }

    public static void cancelJobs() {
        List<CronTrigger> abort_job = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE 'Clone SOW Job%'];
        for (CronTrigger t : abort_job) { //for each record
            System.abortJob(t.Id); //abort the job
        }
    }
}