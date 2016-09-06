({
	getThemes1 : function(component, event, helper) {
        var action=component.get("c.getThemes");
        action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS" && response.getReturnValue()!=='') {
                     var items=response.getReturnValue(); 
                     component.set("v.Themes", response.getReturnValue());
                }
                });
            $A.enqueueAction(action);
	},
    applyFilter : function(component, event, helper) {
          var filtername=component.get("v.temp");
          var filtername=component.get("v.temp"); 
          var activeEvent=$A.get("e.c:EverydayAction_FilterEvent");
           activeEvent.setParams({"selectedfilter":filtername});
           activeEvent.fire();
        },
    filterCancel : function(component, event, helper) {
        var previousfilter=component.get("v.previous");
        var filterEvent=$A.get("e.c:EverydayAction_Filter_Cancel_Event");
        filterEvent.setParams ({"previousFilter":previousfilter});
        filterEvent.fire();
    },
    activeFilter : function(component, event, helper){
       var theme=event.getParam("theme"); 
        component.set("v.temp",theme);
    }
})