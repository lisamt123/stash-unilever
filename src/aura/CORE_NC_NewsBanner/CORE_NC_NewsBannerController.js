({
	GetNewsDetails : function(component, event, helper) {
        var newsArticle = component.get("v.newsArticle");
        var newsType = component.get("v.newsType");
        //console.log("contact: " + newsArticle);
        //alert(newsArticle.NewsId);
        var selectEvent = $A.get("e.c:CORE_NC_SelectNewsId");
        //alert(3);  
        var id=newsArticle.NewsId;
        //alert(4);
        //selectEvent.setParams({"selectedNewsDetail":newsArticle.NewsId }).fire();
        selectEvent.setParams({"selectedNewsDetail":id,"NewsType":newsType }).fire();
        
        //var selectEvent = $A.get("e.c:selectContact");
        //selectEvent.setParams({ "contact": contact }).fire();
	}
})