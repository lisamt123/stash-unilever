({
	getNewsDetail1:function(component, event, helper) {
        //alert(11);
        //alert(event.getParam("selectedNewsDetail"));
        
        component.set("v.NewsDetailComponent", false);
        var selected = event.getParam("selectedNewsDetail");
        var NewsType = event.getParam("NewsType");
        //var cmp=component.get("v.newsArticle");
        component.set("v.NewsId",selected);
        component.set("v.NewsType",NewsType);
        //alert(NewsType);
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", true);
        component.set("v.ChatterShareComponent", false);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", false);
    },
    backButton:function(component, event, helper) {
        //alert(3);
        var NewsType = event.getParam("NewsType");
        component.set("v.NewsType",NewsType);
        component.set("v.BaseComponent", true);
        component.set("v.NewsDetailComponent", false);
    },
    shareButton:function(component, event, helper) {
        var selected = event.getParam("NewsDetail");
        var NewsType = event.getParam("NewsType");
        //var cmp=component.get("v.newsArticle");
        component.set("v.NewsDetail",selected);
        component.set("v.NewsType",NewsType);
        
        //alert(3);
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", false);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", true);
        component.set("v.ChatterShareComponent", false);
    },
    shareCancelButton:function(component, event, helper) {
        //alert(3);
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", true);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", false);
        component.set("v.ChatterShareComponent", false);
        
        var selected = event.getParam("NewsId");
        var NewsType = event.getParam("NewsType");
        
        //alert(selected);
        //alert(NewsType);
        component.set("v.NewsId",selected);
        component.set("v.NewsType",NewsType);
    },
    displayFilter:function(component, event, helper) {
        //alert(event.getParam("displayFilterPage"));
        console.log('------------main---------------'+event.getParam("selectedFilter"));        
        console.log('------------main---------------'+event.getParam("displayFilterPage"));
        var selectedFilter = event.getParam("selectedFilter");
        component.set("v.CurrentFilterType",selectedFilter);
        if(event.getParam("displayFilterPage")==true){
            component.set("v.BaseComponent", false);
            component.set("v.FilterComponent", true); 
            
        } else {
        	component.set("v.NewsType","GlobalNews");
            component.set("v.BaseComponent", true);  
            component.set("v.FilterComponent", false);            
        }        
        component.set("v.NewsDetailComponent", false);
        component.set("v.ShareComponent", false);  
        component.set("v.ChatterShareComponent", false);
    },
    chatterShare:function(component, event, helper) {
        var selected = event.getParam("NewsDetail");
        var NewsType = event.getParam("NewsType");
        //var cmp=component.get("v.newsArticle");
        component.set("v.NewsDetail",selected);
        component.set("v.NewsType",NewsType);
        
        //alert(3);
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", false);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", false);
        component.set("v.ChatterShareComponent", true);
    }
})