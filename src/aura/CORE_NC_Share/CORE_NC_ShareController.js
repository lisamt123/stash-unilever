({
    //On page load set the form component informations
	init : function(component, event, helper) {      
        var mailSubject = encodeURIComponent(component.get("v.NewsDetail.Name"))+': '+component.get("v.NewsDetail.SharepointURL");
		component.set("v.mailSubjectDetail",mailSubject);
        
        var newsArticle = component.get("v.NewsDetail");
        var newsType = component.get("v.NewsType");
        var displayMessage;
        if(newsType=="GlobalNews") {
            displayMessage="News Centre article that may interest you";
            component.set("v.MailSubject",displayMessage);
        } else if(newsType=="PaulsBlog") {
            displayMessage="Pauls Blog article that may interest you";
            component.set("v.MailSubject",displayMessage);
        } else {
            displayMessage="News article that may interest you";
            component.set("v.MailSubject",displayMessage);
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