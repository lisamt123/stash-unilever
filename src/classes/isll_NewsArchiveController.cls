public with sharing class isll_NewsArchiveController {
	
	public isll_ChatterComponentController chatterController {get;set;}
	public String newsId {get; set;}
	public Map<Id, CMS_Content__c> newsMap {get; set;}
	
	public isll_NewsArchiveController(){
		fillNewsMap();
		chatterController = new isll_ChatterComponentController();
	}
	
	public List<String> months {get; set;}
	
	// List of elements.
    public Map<String, List<CMS_Content__c>> newsByMonth
    {
        get{
        	if(newsByMonth == null){
        		fillNewsMap();
        	}
            return newsByMonth;
        }
        
        set;
    }
    
    public void fillNewsMap(){
    	Integer i = 0;
        newsByMonth = new Map<String, List<CMS_Content__c>>();
        months = new List<String>();
        newsMap = new Map<Id, CMS_Content__c>();
        
        for(CMS_ContentToCarousel__c tmp_contentToCarousel : [SELECT Id, Order__c, CMS_Content__c, CMS_Content__r.Id, CMS_Content__r.Name, CMS_Content__r.Content__c, 
        															CMS_Content__r.ThumbnailLink__c, CMS_Content__r.MediaType__c, CMS_Content__r.MediaDescription__c, 
        															CMS_Content__r.Link__c, CMS_Content__r.ThumbnailText__c, CMS_Content__r.CreatedDate 
        													FROM CMS_ContentToCarousel__c 
        													WHERE Carousel__r.Name = 'Test' AND CMS_Content__c != null ORDER BY Order__c, CreatedDate])
        {
        	//skip first 6 news, other are archived
        	if(i >= isll_Utility.notArchivedNewsAmount){
        		String month = tmp_contentToCarousel.CMS_Content__r.CreatedDate.format('yyyy, MMM');
        		if(newsByMonth.get(month) == null){
        			newsByMonth.put(month, new List<CMS_Content__c>());
        			months.add(month);
        		}
        		newsByMonth.get(month).add(tmp_contentToCarousel.CMS_Content__r);
        		newsMap.put(tmp_contentToCarousel.CMS_Content__c, tmp_contentToCarousel.CMS_Content__r);
        	}
        	i++;
        }
    }
    
    public PageReference share(){
    	CMS_Content__c content = newsMap.get(newsId);
        chatterController.shareNews(content.Link__c, content.ThumbnailText__c);
        chatterController.postText = '';
        return null;
    }
}