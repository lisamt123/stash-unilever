({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.getCafeteriaMenuDetails");
        var workPlaceId = component.get("v.workplaceLocationId");
        action.setParams({
            "workPlaceId": workPlaceId
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    component.set("v.cafeteriaMenuDetail", response.getReturnValue());	
                    console.log('---------------------'+response.getReturnValue());
                    //document.getElementById("menuDetail").style.width="100%";
                }
                else {
                    component.set("v.noDataErrorMessage", true);
                }
            }                  
        });
        $A.enqueueAction(action);
    }, 
    increseMenuDetail : function(component, event, helper) {
        var imageWidth = (parseInt((document.getElementById("menuDetail").style.width).replace('%', ''))+25)+"%";
        document.getElementById("menuDetail").style.width = imageWidth;
        console.log('---------------------'+imageWidth);
    },
    decreaseMenuDetail : function(component, event, helper) {
        var imageWidth = parseInt((document.getElementById("menuDetail").style.width).replace('%', ''));
        if(imageWidth > 100){
            document.getElementById("menuDetail").style.width = (imageWidth - 25)+"%";
        }
        console.log('----------2-----------'+document.getElementById("menuDetail").style.width);
    },
     SaveToDisk : function(component, event, helper) {
        if (!window.ActiveXObject) {
            var save = document.createElement('a');
            save.href = component.get("v.cafeteriaMenuDetail");
            save.target = '_blank';
            save.download = 'CafeteriaMenu.jpeg' || 'unknown';
            var event = document.createEvent('Event');
            event.initEvent('click', true, true);
            save.dispatchEvent(event);
            (window.URL || window.webkitURL).revokeObjectURL(save.href);  
        }
    },
    
    gotoPreviousPage: function(component, event, helper) {         
        var workplaceLocationId=component.get("v.workplaceLocationId");
        var selectEvent = $A.get("e.c:CORE_WP_WorkplaceEvent");
        selectEvent.setParams({"selectedWrokplaceId": workplaceLocationId,"WorkplacePannelType":"CORE_WP_WorkplaceHome"}).fire();
    },
})