@isTest
public Class PBS_WikiController_Test{
@isTest static void noDataTest()
    {
        Test.startTest();
        
        PBS_Wiki__kav objPbsWiki = new PBS_Wiki__kav();
        objPbsWiki.Title = 'Wiki Test';
        objPbsWiki.Language = 'en_US';
        objPbsWiki.UrlName = 'Wiki-Test';
        insert objPbsWiki; 
        
        objPbsWiki= [SELECT KnowledgeArticleId FROM PBS_Wiki__kav WHERE Id = :objPbsWiki.Id];    
        KbManagement.PublishingService.publishArticle(objPbsWiki.KnowledgeArticleId, true);
        
        
        Test.setCurrentPageReference(new PageReference('Page.PBS_WikiController_CC')); 
        System.currentPageReference().getParameters().put('id', objPbsWiki.Id);

        PBS_WikiController_CC pbsWiki = new PBS_WikiController_CC();
        
        Test.stopTest();
        System.assertNotEquals(null, pbsWiki, pbsWiki);
        
}
}