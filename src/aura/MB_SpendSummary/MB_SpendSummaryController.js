({
	gotoSummary_charts : function(component, event, helper) {
        var detailedTextEcent=$A.get("e.c:MB_gotoSummary_charts_Event");
        detailedTextEcent.setParams({"month":component.get("v.CurrentMonth"),"deviceName":component.get("v.deviceName"),"deviceId":component.get("v.deviceId")}).fire();
        	 
	}
})