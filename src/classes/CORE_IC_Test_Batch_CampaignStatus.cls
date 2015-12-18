@isTest(seeAllData=true)
private class CORE_IC_Test_Batch_CampaignStatus {
    static testMethod void campaignUpdateMethod() {
        test.starttest();
        // The query used by the batch job.
        String query = 'SELECT id,Title,Status,StartDate,EndDate FROM IdeaTheme';
        Community tests=[SELECT Id FROM Community WHERE IsActive = True Limit 1];
        IdeaTheme ida = new IdeaTheme();
        ida.Title='Aviance Beauty Solutions12';
        ida.Status='Active';
        ida.StartDate=Date.newInstance(2020, 12, 17);
        ida.EndDate=Date.newInstance(2021, 2, 17);
        ida.Categories__c='Test';
        ida.CommunityId=tests.Id;
        insert ida;

         CORE_IC_Scheduler_ICampaignStatusUpdate myClass = new CORE_IC_Scheduler_ICampaignStatusUpdate();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
         
        IdeaTheme ida1 = [SELECT Id FROM IdeaTheme WHERE Id =: ida.Id];
        ida1.Title='Aviance Beauty Solutions123';
        ida1.Status='Active';
        ida1.StartDate=Date.newInstance(2020, 12, 15);
        ida1.EndDate=Date.newInstance(2021, 2, 17);
        ida1.Categories__c='Test';
        update ida1;
        
        CollaborationGroup grp=new CollaborationGroup();
        grp.name='IdeaTestClass';
        grp.CollaborationType='Public';
        insert grp;

        ida = new IdeaTheme();
        ida.Title='Aviance Beauty Solutions1234';
        ida.Status='Active';
        ida.StartDate=System.now();
        ida.EndDate=Date.newInstance(2021, 2, 17);
        ida.Categories__c='Test';
        ida.CommunityId=tests.Id;
        ida.Chatter_Post__c=true;
        ida.Groups_to_Post__c=grp.Id;
        ida.Idea_Theme_Title__c='Test Summary';
        insert ida;
    }
}