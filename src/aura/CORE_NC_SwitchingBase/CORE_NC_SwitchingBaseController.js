({
    //Redirecting to new detail page
	getNewsDetailInfo:function(component, event, helper) {
        //alert(11);
        //alert(event.getParam("selectedNewsDetail"));   
        helper.scrollToLocation(component, "top");     
        
        component.set("v.NewsDetailComponent", false);
        var selected = event.getParam("selectedNewsDetail");
        var NewsType = event.getParam("NewsType");
        component.set("v.NewsId",selected);
        component.set("v.NewsType",NewsType);
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", true);
        component.set("v.ChatterShareComponent", false);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", false);
        /*$(function () {
        	$('html, body').animate({ scrollTop: 0 }, 0);
        });*/
    },
    //Go back to previous page
    backButton:function(component, event, helper) {
        var NewsType = event.getParam("NewsType");
        component.set("v.NewsType",NewsType);
        component.set("v.BaseComponent", true);
        component.set("v.NewsDetailComponent", false);
    },
    //Redirecting to Share page
    shareButton:function(component, event, helper) {   
        helper.scrollToLocation(component, "top");  
        var selected = event.getParam("NewsDetail");
        var NewsType = event.getParam("NewsType");
        component.set("v.NewsDetail",selected);
        component.set("v.NewsType",NewsType);
        
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", false);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", true);
        component.set("v.ChatterShareComponent", false);
    },
    //Redirecting to new detail page
    shareCancelButton:function(component, event, helper) {   
        helper.scrollToLocation(component, "top");  
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", true);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", false);
        component.set("v.ChatterShareComponent", false);        
        var selected = event.getParam("NewsId");
        var NewsType = event.getParam("NewsType");
        component.set("v.NewsId",selected);
        component.set("v.NewsType",NewsType);
    },
    //Redirecteding to filter page/Home Page based on the condition
    displayFilter:function(component, event, helper) {   
        helper.scrollToLocation(component, "top");  
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
    //Redirecting to Chatter share page
    chatterShare:function(component, event, helper) {   
        helper.scrollToLocation(component, "top");  
        var selected = event.getParam("NewsDetail");
        var NewsType = event.getParam("NewsType");
        component.set("v.NewsDetail",selected);
        component.set("v.NewsType",NewsType);
        
        component.set("v.BaseComponent", false);
        component.set("v.NewsDetailComponent", false);
        component.set("v.FilterComponent", false);
        component.set("v.ShareComponent", false);
        component.set("v.ChatterShareComponent", true);
    }
})