({
	activeFilter : function(component, event, helper) {
        var themename=component.get("v.themeName");
        var activeEvent=$A.get("e.c:EverydayAction_Active_Filter_Event");
        activeEvent.setParams({"theme" : themename});
        activeEvent.fire();
    }
})