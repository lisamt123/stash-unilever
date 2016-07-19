global with sharing class Oblix_VersionControl implements Schedulable {

    public static String cron_job_name = 'Clone SOW Job';

    global void execute(SchedulableContext SC) {
            
        checkAndInitialiseBatchJob();

    }


    public static void checkAndInitialiseBatchJob(){

        // if there is no other batch job currently running and we have some records to process
        // S.M. 2016-06-10 and job does not require manual attention
        // then initiate the batch job
        if (!checkIsJobRunning() && !checkJobRequiresManualAttention()){
            // how many SOWs require Cloning? 
            Integer sow_requested_clone_size = [SELECT count() FROM Marketing_SOW__c 
                WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_REQUESTED OR Sync_Status__c =: Oblix_Utils.JOB_STATUS_CLONE_IN_PROGRESS];

            // how many SOWs require Sync? 
            Integer sow_requested_sync_size = [SELECT count() FROM Marketing_SOW__c 
                WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED OR Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS];

            // how many campaigns require sync?
            Integer campaign_requested_sync_size = [SELECT count() FROM Oblix_SOW_Projects__c 
                WHERE Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_REQUESTED OR Sync_Status__c =: Oblix_Utils.JOB_STATUS_SYNC_IN_PROGRESS];

            system.debug('\n\n######## To Process ######## \ntotal sow_requested_clone_size: ' + sow_requested_clone_size + '\nsow_requested_sync_size: '
                + sow_requested_sync_size + '\ncampaign_requested_sync_size: ' + campaign_requested_sync_size + '\n\n ');

            if (sow_requested_clone_size >0 || sow_requested_sync_size>0 || campaign_requested_sync_size> 0){

                system.debug('### starting the batch job');

                Oblix_SyncBatchJob job_process_batch = new Oblix_SyncBatchJob(sow_requested_clone_size,sow_requested_sync_size,campaign_requested_sync_size);
                // don't initiate the batch if this is being called from a test class
                if(!Test.isRunningTest()){
                    Database.executeBatch(job_process_batch,1);
                }
            }    
        }
    }

    public static Boolean checkIsJobRunning(){
        // if there is no other batch job currently running and we have some records to process
        // then initiate the batch job

        Set<string> set_async_status = new Set<string>{'Queued','Processing','Preparing','Holding'};
        Integer running_job = [SELECT count() From AsyncApexJob WHERE  ApexClass.Name = 'Oblix_SyncBatchJob' AND JobType = 'BatchApex' AND Status in: set_async_status];

        if (running_job == 0){
            
            return false;
        }
        else{
            return true;
        }
    }

    public static Boolean checkJobRequiresManualAttention(){

        Oblix_Job_Orchestration__c requires_manual_attention = Oblix_Job_Orchestration__c.getOrgDefaults();
        return requires_manual_attention.Requires_Manual_Attention__c;
    }

    public static void scheduleJobs() {
        //System.schedule('Clone SOW Job 1', '0 1 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 2', '0 2 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 3', '0 3 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 4', '0 4 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 5', '0 5 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 6', '0 6 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 7', '0 7 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 8', '0 8 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 9', '0 9 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 10', '0 10 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 11', '0 11 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 12', '0 12 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 13', '0 13 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 14', '0 14 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 15', '0 15 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 16', '0 16 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 17', '0 17 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 18', '0 18 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 19', '0 19 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 20', '0 20 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 21', '0 21 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 22', '0 22 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 23', '0 23 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 24', '0 24 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 25', '0 25 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 26', '0 26 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 27', '0 27 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 28', '0 28 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 29', '0 29 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 30', '0 30 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 31', '0 31 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 32', '0 32 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 33', '0 33 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 34', '0 34 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 35', '0 35 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 36', '0 36 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 37', '0 37 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 38', '0 38 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 39', '0 39 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 40', '0 40 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 41', '0 41 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 42', '0 42 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 43', '0 43 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 44', '0 44 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 45', '0 45 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 46', '0 46 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 47', '0 47 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 48', '0 48 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 49', '0 49 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 50', '0 50 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 51', '0 51 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 52', '0 52 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 53', '0 53 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 54', '0 54 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 55', '0 55 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 56', '0 56 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 57', '0 57 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 58', '0 58 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 59', '0 59 * * * ?', new Oblix_VersionControl());
        //System.schedule('Clone SOW Job 60', '0 0 * * * ?', new Oblix_VersionControl());

        for (Integer i= 0; i<60; i++){

            String job_name = cron_job_name + ' ' + i;
            String job_schedule = '0 ' + i + ' * * * ?';

            System.schedule(job_name, job_schedule, new Oblix_VersionControl());
        }
    }

    public static void cancelJobs() {
        String all_cron_job = cron_job_name+'%';
        List<CronTrigger> abort_job = [SELECT Id FROM CronTrigger WHERE CronJobDetail.Name LIKE : all_cron_job];
        for (CronTrigger t : abort_job) { //for each record
            System.abortJob(t.Id); //abort the job
        }
    }
}