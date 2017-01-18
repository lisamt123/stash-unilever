({
	updatePannelStyle : function(component, updateingPannel) {
		var menuStyle = component.find(component.get("v.pannelType"));
        $A.util.removeClass(menuStyle, "activeMenu");
        $A.util.addClass(menuStyle, "inactiveMenu");        
        component.set("v."+component.get("v.pannelType"),false);  
        component.set("v.pannelType",updateingPannel);
        this.setActivePannel(component);
        
	},
    setActivePannel : function(component){    
        var menuStyle = component.find(component.get("v.pannelType"));
        $A.util.removeClass(menuStyle, "inactiveMenu");
        $A.util.addClass(menuStyle, "activeMenu");
        
        component.set("v."+component.get("v.pannelType"),true);  
	}
})