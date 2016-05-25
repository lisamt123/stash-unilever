({  
	doinit : function(component, event, helper) {
     /*This code is for charts and graphs*/
      helper.helperMethodforCharts(component);
    },

	MyAction : function(component, event, helper) {
		component.get("v.modelNumber");
	},
    gotoDetailesText: function(component, event, helper) {
        var monthArray=component.get("v.CurrentMonth").split(' ');
        var month=monthArray[0];
		var detailedTextEcent=$A.get("e.c:MB_Detail_text_Event");  
        detailedTextEcent.setParams({"month":month,"deviceName":component.get("v.deviceName"),"deviceId":component.get("v.deviceId")}).fire();
	}, 
    //This method redirects to previous screen
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":"MB_Devices"}).fire();
                                                    
    }
})