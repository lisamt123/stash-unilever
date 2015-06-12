@isTest
public with sharing class CORE_ChatterHomePageControllerTest{

    static testmethod void testHomePageFeed(){
        
        setup();
        
        Test.startTest();
        
        ChatterHomePageController chpCon= new ChatterHomePageController();
        Test.setCurrentPageReference(Page.ChatterHomePage);
        
        System.assertEquals(5, chpCon.getGroups().size());
        
        System.assertEquals(5, chpCon.getFeeds().size());
        
        System.assertEquals(6, chpCon.getFeeds().values()[0].size());
        
        Test.stopTest();

    }
   
    static testmethod void testInactiveFeed(){
        
        setup();
        
        Test.startTest();
        
        ChatterHomePageController chpCon= new ChatterHomePageController();
        Test.setCurrentPageReference(Page.ChatterHomePage);
        
        System.assertEquals(5, chpCon.getGroups().size());
        
        Home_Page_Feed__c grpFd = chpCon.getGroups()[0];
        grpFd.Active__c = false;
        update grpFd;
        
        chpCon= new ChatterHomePageController();
        
        System.assertEquals(4, chpCon.getGroups().size());
        
        
        Test.stopTest();

    }
   
    static void setup(){
        
        Map<String, List<Home_Page_Feed__c>> groups = new Map<String, List<Home_Page_Feed__c>>{};
        List<Home_Page_Feed__c> groupsList = new List<Home_Page_Feed__c>();
        
        for(integer i = 0; i< 5; i++){
            
            groupsList.add(new Home_Page_Feed__c(Type__c='Group', Display_Text__c = 'Group' + i, Sort_Order__c=i, Active__c=TRUE));
            
            List<Home_Page_Feed__c> feeds = new List<Home_Page_Feed__c>{};
            
            for(integer j = 0; j< 6; j++){
             
                 feeds.add(new Home_Page_Feed__c(Type__c = 'Feed', Display_Text__c='Feed' + j, Sort_Order__c = j,
                             Asset_Url__c = 'www.google.com', Image_URL__c = 'www.google.com', Active__c=TRUE));   
            }
            groups.put('Group'+i, feeds);
            
        }
        
        Database.insert(groupsList);
        
        for(Home_Page_Feed__c grp : groupsList){
            for(Home_Page_Feed__c feed : groups.get(grp.Display_Text__c)){
                feed.Group__c = grp.Id;
            }
            Database.insert(groups.get(grp.Display_Text__c));
        }
            
    }
}