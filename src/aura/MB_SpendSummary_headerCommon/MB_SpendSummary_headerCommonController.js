({
	 Devices : function(component, event, helper) {
           
            var selectEvent = $A.get("e.c:MB_BaseEvent");
         selectEvent.setParams({"MBNavigate":"MB_Devices","month":component.get("v.month")}).fire();
	},
     Usage : function(component, event, helper) {
         
        	var selectEvent = $A.get("e.c:MB_BaseEvent");
            selectEvent.setParams({"MBNavigate":"MB_Usage_Comp","month":component.get("v.month"),"deviceId":component.get("v.deviceId")}).fire();
	}
})