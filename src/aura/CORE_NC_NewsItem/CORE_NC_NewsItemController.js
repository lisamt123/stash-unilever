({
	GetNewsDetails : function(component, event, helper) {
       
        var newsArticle = component.get("v.newsArticle");
        var newsType = component.get("v.newsType");
        var selectEvent = $A.get("e.c:CORE_NC_SelectNewsId");
        var id=newsArticle.NewsId;
        selectEvent.setParams({"selectedNewsDetail":id,"NewsType":newsType }).fire();
       
	},
    //News Centre Enhancement code
    goNewPage: function(component, event, helper) {
        alert("hi");
        var newFilterType=component.get("v.newSelectedFilter");
        console.log('-----------filter----------'+newFilterType);
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": newFilterType,"displayFilterPage":false }).fire();
    }    ,
   //Change for Implementing CR Related to Topics
      sendSelectedTopic : function(component, event, helper) {
       var newFilterType=event.getSource();
        var topics=newFilterType.get("v.label");
         var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": topics,"displayFilterPage":true }).fire();   
          var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": topics,"displayFilterPage":false }).fire();
       
    },
})