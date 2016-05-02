public without sharing class uw_BatchJobManagerController {

    public uw_BatchJobHelper helper = new uw_BatchJobHelper();
    public List<BatchJob> batchJobs = null;
    
    
    public uw_BatchJobManagerController()
    {
        if (uw_HelperMethods.isSystemAdminUser())
        {
            // all ok 
        }
        else
        {
            //ApexPages.addMessage()
        }
    }
    
    public PageReference exit()
    {
        return new PageReference('/home/home.jsp');
    }
    
    public PageReference refresh()
    {
        PageReference pr = new PageReference('/apex/BatchJobManager');
        pr.setRedirect(true);
        return pr;
    }

    public PageReference startJob()
    {
        String jobName = Apexpages.currentPage().getParameters().get('jobName');
        
        if (jobName == uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.SEND_INVITE_BATCH_JOB_ID))
        {
            helper.scheduleNextSendInviteBatchJob();
        } else {
            helper.scheduleNextSendInviteBatchJob();
        }
        
        batchJobs = null;
        
        return null;
    }
    
    public PageReference stopJob()
    {
        String jobName = Apexpages.currentPage().getParameters().get('jobName');
        system.debug('jobName: '+jobName);
        try{
            system.debug('compare with: '+uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.SEND_INVITE_BATCH_JOB_ID));

            if (jobName == uw_CustomSettingsManager.getCustomSettingStringVal(uw_CustomSettingsManager.SEND_INVITE_BATCH_JOB_ID))
            {
                system.debug('call cancel: ');
                helper.cancelSendInviteJob();
            } else {
                system.debug('call cancel without jobName: ');
                helper.cancelSendInviteJob();
            }
        }
        catch (Exception e)
        {
            Apexpages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, 'Error '+e));
        }
        
        return null;
    }
    
    public List<BatchJob> getBatchJobs()
    {
        if (batchJobs == null)
        {
            List<String> batchJobNames = new List<String>();
            
            // Need to get the batch jobs - 
            batchJobNames.add(uw_CustomSettingsManager.SEND_INVITE_BATCH_JOB_ID);
            
            List<uw_Custom_Setting__c> configs = [Select Text_Value__c, Number_Value__c, Name, Id, Description__c, Checkbox_Value__c From uw_Custom_Setting__c where Name in :batchJobNames];
        
            batchJobs = new List<BatchJob>();
            
            for (uw_Custom_Setting__c cs:configs)
            {
                BatchJob bj = new BatchJob();
                bj.id = cs.Id;
                bj.name = cs.Name;
                bj.status = cs.Text_Value__c;
                
                batchJobs.add(bj);
            }
        }
        
        return batchJobs;
    }
    
    public class BatchJob
    {
        String Id;
        String batchJobId;
        String status;
        String displayStatus;
        String name;
        public BatchJob()
        {
            
        }
        
        public String getBatchJobId()
        {
            return batchJobId;
        }
        
        public String getId()
        {
            return Id;
        }
        
        public String getStatus()
        {
            return status;
        }
        
        public String getDisplayStatus()
        {
            if (status == uw_BatchJobHelper.NOT_RUNNING)
            {
                displayStatus = 'Stopped';
            }
            else
            {
                displayStatus = 'Running';
            }
            return displayStatus;
        }
        
        public String getName()
        {
            return name;
        }
    }
    @isTest(seeAllData=true)
    public static void testBatchJobManager()
    {
        uw_BatchJobManagerController controller = new uw_BatchJobManagerController();
        List<BatchJob> jobs = controller.getBatchJobs();
        controller.exit();
        
        controller.refresh();
        
        
        for (BatchJob bj: jobs)
        {
            Apexpages.currentPage().getParameters().put('jobName',bj.Name);
            
            if (bj.getDisplayStatus() == 'Stopped')
            {
                controller.startJob();
                controller.stopJob();
            }
            else
            {
                controller.stopJob();
                controller.startJob();
            }
        }
        
        BatchJob bJob = new BatchJob();
        bJob.getBatchJobId();
        bJob.getDisplayStatus();
        bJob.status = uw_BatchJobHelper.NOT_RUNNING;
        bJob.getDisplayStatus();
        bJob.getId();
        bJob.getName();
        bJob.getStatus();
    }

}