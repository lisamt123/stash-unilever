({
	rateLater : function(component, event, helper) {
       var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
        selectEvent.setParams({"componentName":"c:CORE_LA_Home", "isFromFeedback":true}).fire();
		
	},
   submit:function(component, event, helper) {
    var selectEvent = $A.get("e.c:CORE_LA_HandleEvent");
    selectEvent.setParams({"componentName":"c:CORE_LA_Home", "isFromFeedback":true}).fire();
		
	},
   
   
})