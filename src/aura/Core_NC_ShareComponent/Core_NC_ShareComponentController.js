({
	init : function(component, event, helper) {        
        var newsArticle = component.get("v.NewsDetail");
        var newsType = component.get("v.NewsType");
        if(newsType=="GlobalNews") component.set("v.MailSubject","News Centre article that may interest you");
        else component.set("v.MailSubject","News article that may interest you");
        /*var newsArticleTitle = newsArticle.Name;
        var newsArticleSharePointURL = newsArticle.SharepointURL;
        component.set("v.MailToBody", "mailto:Val.Ashton@unilever.com?subject=News article that may interest you&amp;body="+newsArticleTitle+": "+newsArticleSharePointURL+""); 
        var newsArticle1 = component.get("v.MailToBody");
        alert(newsArticle1);*/
	},    
    getChatterComponent:function(component, event, helper) {
        //var newsArticle1 = component.get("v.newsId");
        var newsArticle = component.get("v.NewsDetail");
        var NewsType=component.get("v.NewsType");
        
        var selectEvent = $A.get("e.c:Core_NC_ChatterShareEvent");
        selectEvent.setParams({"NewsDetail": newsArticle,"NewsType": NewsType }).fire();
        //alert(newsArticle1);
        //alert(newsArticle2.NewsId);
        //alert(newsArticle3);
    },
    
    CancelButton:function(component, event, helper) {
        //alert(1);
        var newsArticle = component.get("v.NewsDetail");
        var NewsType=component.get("v.NewsType");
        var selectEvent = $A.get("e.c:Core_ShareCancelButton");
        selectEvent.setParams({"NewsId": newsArticle.NewsId,"NewsType": NewsType }).fire();
        //alert(newsArticle.NewsId);
        //alert(2);
    },
})