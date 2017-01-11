({
	GetNewsDetails : function(component, event, helper) {
        var newsArticle = component.get("v.newsArticle");
        var newsType = component.get("v.newsType");
        var selectEvent = $A.get("e.c:CORE_NC_SelectNewsId");
        var id=newsArticle.NewsId;
        selectEvent.setParams({"selectedNewsDetail":id,"NewsType":newsType }).fire();
        
        //var selectEvent = $A.get("e.c:selectContact");
        //selectEvent.setParams({ "contact": contact }).fire();
	},
    
     sendSelectedTopic : function(component, event, helper) {
       var newFilterType=event.getSource();
        var topics=newFilterType.get("v.label");
         var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": topics,"displayFilterPage":true }).fire();   
          var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": topics,"displayFilterPage":false }).fire();
     
    },
})