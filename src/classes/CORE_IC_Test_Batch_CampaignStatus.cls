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
        ida.StartDate=System.now();
        ida.EndDate=System.now().addDays(10);
        ida.Categories__c='Test1';
        ida.CommunityId=tests.Id;
        insert ida;
        System.assert(ida != null);

         CORE_IC_Scheduler_ICampaignStatusUpdate myClass = new CORE_IC_Scheduler_ICampaignStatusUpdate();   
         String chron = '0 0 23 * * ?';        
         system.schedule('Test Sched', chron, myClass);
         test.stopTest();
         
        IdeaTheme ida1 = [SELECT Id FROM IdeaTheme WHERE Id =: ida.Id];
        ida1.Title='Aviance Beauty Solutions123';
        ida1.Status='Active';
        ida1.StartDate=System.now().addMinutes(2);
        ida1.EndDate=System.now().addDays(20);
        ida1.Categories__c='Test2';
        update ida1;
        
        CollaborationGroup grp=new CollaborationGroup();
        grp.name='IdeaTestClass';
        grp.CollaborationType='Public';
        insert grp;
        System.assert(grp != null);

        ida = new IdeaTheme();
        ida.Title='Aviance Beauty Solutions1234';
        ida.Status='Active';
        ida.StartDate=System.now();
        ida.EndDate=System.now().addDays(10);
        ida.Categories__c='Test3';
        ida.CommunityId=tests.Id;
        ida.Chatter_Post__c=true;
        ida.Groups_to_Post__c=grp.Id;
        ida.Idea_Theme_Title__c='Test Summary';
        insert ida;
        System.assert(ida != null);
    }
}