public with sharing class ChatterHomePageController {
    
    Map<Home_Page_Feed__c, List<Home_Page_Feed__c>> homePageFeeds ;
    List<Home_Page_Feed__c> groups;
    
    public ChatterHomePageController(){
        
        init();
    }
    
    public List<Home_Page_Feed__c> getGroups() {
       
        return groups;
    }


    public Map<Home_Page_Feed__c,List<Home_Page_Feed__c>> getFeeds() {
        
        return homePageFeeds;
    }
    
    private void init(){
         if(homePageFeeds == null){
             groups = new List<Home_Page_Feed__c>{};
             homePageFeeds = new Map<Home_Page_Feed__c, List<Home_Page_Feed__c>>{};
             
              for(Home_Page_Feed__c hpf : [Select Display_Text__c, Asset_URL__c, (Select Display_Text__c, Sort_Order__c, Asset_URL__c,
                Image_URL__c from HomePage_Feeds__r Where Active__c=TRUE Order By Sort_Order__c ASC), Sort_Order__c from Home_Page_Feed__c 
                            where Active__c=true AND Type__c = 'Group' ORDER by Sort_Order__c ASC]){
                    
                    if(homePageFeeds.get(hpf) == null){
                        groups.add(hpf);
                        homePageFeeds.put(hpf, hpf.HomePage_Feeds__r);
                    }
                    
                    
                }
          }
         System.debug('**** HomePageFeeds **** ' + homePageFeeds);
    }

}