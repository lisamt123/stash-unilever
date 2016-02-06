({
    getRecentNews: function(component, event, helper) {              
        var menuStyle = component.find("recentNewsSection");
        $A.util.removeClass(menuStyle, "recentNewsInActive");
        $A.util.addClass(menuStyle, "recentNewsActive");
        menuStyle = component.find("mostViewedSection");
        $A.util.removeClass(menuStyle, "viewsActive");
        $A.util.addClass(menuStyle, "viewsInActive");
        menuStyle = component.find("mostLikeSection");
        $A.util.removeClass(menuStyle, "likeActive");
        $A.util.addClass(menuStyle, "likeInActive");
        menuStyle = component.find("mostCommentSection");
        $A.util.removeClass(menuStyle, "commentActive");
        $A.util.addClass(menuStyle, "commentInActive");
        
        component.set("v.sortTypeforGlobalNews","Recent");
	},
    
    getMostViewed: function(component, event, helper) {  
        var menuStyle = component.find("recentNewsSection");
        $A.util.removeClass(menuStyle, "recentNewsActive");
        $A.util.addClass(menuStyle, "recentNewsInActive");
        menuStyle = component.find("mostViewedSection");
        $A.util.removeClass(menuStyle, "viewsInActive");
        $A.util.addClass(menuStyle, "viewsActive");
        menuStyle = component.find("mostLikeSection");
        $A.util.removeClass(menuStyle, "likeActive");
        $A.util.addClass(menuStyle, "likeInActive");
        menuStyle = component.find("mostCommentSection");
        $A.util.removeClass(menuStyle, "commentActive");
        $A.util.addClass(menuStyle, "commentInActive");
        component.set("v.sortTypeforGlobalNews","View");
	},
    
    getMostLiked: function(component, event, helper) {
        var menuStyle = component.find("recentNewsSection");
        $A.util.removeClass(menuStyle, "recentNewsActive");
        $A.util.addClass(menuStyle, "recentNewsInActive");
        menuStyle = component.find("mostViewedSection");
        $A.util.removeClass(menuStyle, "viewsActive");
        $A.util.addClass(menuStyle, "viewsInActive");
        menuStyle = component.find("mostLikeSection");
        $A.util.removeClass(menuStyle, "likeInActive");
        $A.util.addClass(menuStyle, "likeActive");
        menuStyle = component.find("mostCommentSection");
        $A.util.removeClass(menuStyle, "commentActive");
        $A.util.addClass(menuStyle, "commentInActive");
        component.set("v.sortTypeforGlobalNews","Like");
	},
    
    getMostCommented: function(component, event, helper) {
        var menuStyle = component.find("recentNewsSection");
        $A.util.removeClass(menuStyle, "recentNewsActive");
        $A.util.addClass(menuStyle, "recentNewsInActive");
        menuStyle = component.find("mostViewedSection");
        $A.util.removeClass(menuStyle, "viewsActive");
        $A.util.addClass(menuStyle, "viewsInActive");
        menuStyle = component.find("mostLikeSection");
        $A.util.removeClass(menuStyle, "likeActive");
        $A.util.addClass(menuStyle, "likeInActive");
        menuStyle = component.find("mostCommentSection");
        $A.util.removeClass(menuStyle, "commentInActive");
        $A.util.addClass(menuStyle, "commentActive");
        component.set("v.sortTypeforGlobalNews","Comment");
	},
    doInit: function(component, event, helper) {  
        var menuStyle = component.find("recentNewsSection");
        $A.util.removeClass(menuStyle, "recentNewsInActive");
        $A.util.addClass(menuStyle, "recentNewsActive");
        menuStyle = component.find("mostViewedSection");
        $A.util.removeClass(menuStyle, "viewsActive");
        $A.util.addClass(menuStyle, "viewsInActive");
        menuStyle = component.find("mostLikeSection");
        $A.util.removeClass(menuStyle, "likeActive");
        $A.util.addClass(menuStyle, "likeInActive");
        menuStyle = component.find("mostCommentSection");
        $A.util.removeClass(menuStyle, "commentActive");
        $A.util.addClass(menuStyle, "commentInActive");
        component.set("v.sortTypeforGlobalNews","Recent");
        var NewsType=component.get("v.NewsType");
        
        var action = component.get("c.getGAInfo");
		action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state == "SUCCESS") {
                if(response.getReturnValue()!=''){        			
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
                
                    ga('create', response.getReturnValue().GAId, 'auto');
                    var dimensionValue1 = NewsType;
                    var dimensionValue2 = response.getReturnValue().UserId;
                    ga('set', 'dimension1', dimensionValue1);
                    ga('set', 'dimension2', dimensionValue2);
                    ga('send', 'pageview');
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
                }
        	}                    
        });
        $A.enqueueAction(action);
        
    },
})