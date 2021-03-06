({
    //On page load set the form component informations
	init : function(component, event, helper) {        
        var newsArticle = component.get("v.NewsDetail");
        var newsType = component.get("v.NewsType");
        if(newsType=="GlobalNews") {
            component.set("v.MailSubject","News Centre article that may interest you");
        }
        else {
            component.set("v.MailSubject","News article that may interest you");
        }
	},    
    //redirect into chatter share page
    getChatterComponent:function(component, event, helper) {
        var newsArticle = component.get("v.NewsDetail");
        var NewsType=component.get("v.NewsType");
        var selectEvent = $A.get("e.c:Core_NC_ChatterShareEvent");
        selectEvent.setParams({"NewsDetail": newsArticle,"NewsType": NewsType }).fire();
    },
    //redirect into back to news article detail page    
    CancelButton:function(component, event, helper) {
        var newsArticle = component.get("v.NewsDetail");
        var NewsType=component.get("v.NewsType");
        var selectEvent = $A.get("e.c:Core_ShareCancelButton");
        selectEvent.setParams({"NewsId": newsArticle.NewsId,"NewsType": NewsType }).fire();
    },
})