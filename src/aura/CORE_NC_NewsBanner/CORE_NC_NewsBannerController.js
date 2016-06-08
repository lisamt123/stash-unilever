({
	GetNewsDetails : function(component, event, helper) {
        var newsArticle = component.get("v.newsArticle");
        var newsType = component.get("v.newsType");
        var selectEvent = $A.get("e.c:CORE_NC_SelectNewsId");
        var id=newsArticle.NewsId;
        selectEvent.setParams({"selectedNewsDetail":id,"NewsType":newsType }).fire();
        
        //var selectEvent = $A.get("e.c:selectContact");
        //selectEvent.setParams({ "contact": contact }).fire();
	}
})