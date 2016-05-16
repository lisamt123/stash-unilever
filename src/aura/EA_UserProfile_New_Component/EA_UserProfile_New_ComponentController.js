({doInit : function(component, event, helper) {
       var action=component.get("c.getUserDetail"); 
        action.setCallback(this, function(response) {
                var state = response.getState();
               if (state === "SUCCESS" && response.getReturnValue()!=='') {
                        var items=response.getReturnValue();
                     component.set("v.userDetail", response.getReturnValue());
                  var a=items[0].activity_points ;
                  // alert(a);
                  helper.helperMethod(component,a);
                  helper.helperforProgressbar(component,a);  
               } });
            $A.enqueueAction(action);},
        removeCSS: function(cmp, event) {
        var cmpTarget = cmp.find("dash");
        $A.util.removeClass(cmpTarget,'dashTitle');}})