({
	updateMenuIcons : function(component) {		        
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
    removeMenuIconStyles : function(component) {		        
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
        $A.util.removeClass(menuStyle, "commentActive");
        $A.util.addClass(menuStyle, "commentInActive");
	}
})