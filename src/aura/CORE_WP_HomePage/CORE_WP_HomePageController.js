({
	getWorkplaceLocationId : function(component, event, helper) { 
        console.log('------------entry----------------');
        var action = component.get("c.getCurrentUserLocation");
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {                
                var workplaceLocationInfo = response.getReturnValue();
                var destination = "markup://c:CORE_WP_WorkplaceHome"; 
                $A.componentService.newComponentAsync(this, function(view) {
                    var content = component.find("WorkplacePannel");
                    content.set("v.body", view);
                }, {
                    componentDef: destination,
                    attributes: {
                        values: {
                            workplaceLocationId: workplaceLocationInfo
                        }
                    }
                }, component);
            }        	                   
        });
        $A.enqueueAction(action);
        console.log('------------exit----------------');
	},
    navigateWithinComponent: function(component, event, helper) {         
        //event.getParam("displayWorkplaceHome");
        var destination = "markup://c:"+event.getParam("WorkplacePannelType"); 
        $A.componentService.newComponentAsync(this, function(view) {
            var content = component.find("WorkplacePannel");
            content.set("v.body", view);
        }, {
            componentDef: destination,
            attributes: {
                values: {
                    workplaceLocationId: event.getParam("selectedWrokplaceId")
                }
            }
        }, component);
    }
})