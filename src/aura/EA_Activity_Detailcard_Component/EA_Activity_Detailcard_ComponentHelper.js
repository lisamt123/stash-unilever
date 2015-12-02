({
	getAllThemeColor : function(component) {
		var action=component.get("c.getThemeColors");
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=''){
                        var color= response.getReturnValue();
                        console.log(color);
                    	component.set("v.themeColors", color);
                        console.log("==="+component.get("v.themeColors")+"====");
                  
                      }  
                    }      
                });
            $A.enqueueAction(action);
	},
    getactivities1 : function(component, event, helper) {
        var aid=component.get("v.selectedactivityId");
        
        var action=component.get("c.getactivitydetail");
  		action.setParams({"ActivityID" : aid});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var items=response.getReturnValue();
                    component.set("v.activityid",items[0].Id);
                   
                    //alert(items[0].Activity_Points__c ); 
                    component.set("v.activityDetail", response.getReturnValue());
                    //alert(v.activity.Rating__c);
                    
                    
                }
            }
        });
        $A.enqueueAction(action);
	}
})