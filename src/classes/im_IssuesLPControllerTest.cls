/***
Class: im_IssuesLPControllerTest
Description: test for the Issues LP Page controller, 
**/

@isTest
private class im_IssuesLPControllerTest {

    private static void initData(){
        List<im_TabSettings__c> tabSettingToInsert = new List<im_TabSettings__c>();
        im_TabSettings__c tb = new im_TabSettings__c();
        tb.Name = 'Issues introduction';
        tb.Value__c = 'TEST_intro';
        tabSettingToInsert.add(tb);

        im_TabSettings__c tb2 = new im_TabSettings__c();
        tb2.Name = 'Issues Dashboard';
        tb2.Value__c = 'TEST_dash';
        tabSettingToInsert.add(tb2);

        insert tabSettingToInsert;


        im_TabCustomLinks__c tabc = new im_TabCustomLinks__c();
        tabc.Name='Hello';
        tabc.URL__c='jfhg';
        tabc.Order__c=1;
        tabc.ExternalSite__c=true;
        insert tabc;
                
        PageReference pageRef = Page.im_IssuesLP;
        Test.setCurrentPage(pageRef);
    }

    private static testMethod void testAttributeInit() {
    initData();       
        im_IssuesLPController controller = new im_IssuesLPController();
        
        Test.startTest();
        string testgetIntroduction = controller.Introduction;
        string testgetDashboardId = controller.DashboardId;  
        Test.stopTest();
<<<<<<< HEAD
        system.assert(testgetIntroduction.contains('To Report an Issue, please use Search to check if the issue already exists.'));
=======
        system.assert(testgetIntroduction.contains('TEST_intro'),'Assert failed');
>>>>>>> develop
       }

    private static testMethod void testOpenLinkExternal() {
        initData();       
        im_IssuesLPController controller = new im_IssuesLPController();

        controller.IsSelectedLinkExternal = true;
        controller.SelectedLink = 'Google';
        
        Test.startTest();
        String nextPage = controller.OpenLink().getUrl();
        Test.stopTest();
        
        system.assertEquals('http://Google', nextPage);

    }

    private static testMethod void testOpenLinkInternal() {
        initData();       
        im_IssuesLPController controller = new im_IssuesLPController();

        controller.IsSelectedLinkExternal = false;
        controller.SelectedLink = 'aLink';
        
        Test.startTest();
        String nextPage = controller.OpenLink().getUrl();
        Test.stopTest();
        
        system.assertEquals('/aLink', nextPage);

    }

    private static testMethod void testNewIssue() {
        initData();       
        im_IssuesLPController controller = new im_IssuesLPController();
        
        Test.startTest();
        String pageRefUrl = controller.NewIssue().getUrl();
        Test.stopTest();        

        Schema.SObjectType sType = Schema.getGlobalDescribe().get('im_Issue__c');
        String issueObjPrefix = sType.getDescribe().getKeyPrefix(); 
        system.assert(pageRefUrl.contains(issueObjPrefix));

    }
}