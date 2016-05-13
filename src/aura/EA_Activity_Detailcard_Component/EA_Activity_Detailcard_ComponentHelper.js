({
getAllThemeColor : function(component) {
    var action=component.get("c.getThemeColors");
    action.setCallback(this, function(response) {
        var state = response.getState();
        if (state === "SUCCESS" && response.getReturnValue()!=='') {
            var color= response.getReturnValue();
            component.set("v.themeColors", color);
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
        if (state === "SUCCESS" && response.getReturnValue()!=='') {
            var items=response.getReturnValue();
            //component.set("v.activityid",items[0].Id);
            component.set("v.activityDetail", response.getReturnValue());
        }
    });
    $A.enqueueAction(action);
},

    showTabActive:function(cmp,event,tabName){
        if(tabName === 'themes'){
            tabstyle=cmp.find("themes");
            $A.util.removeClass(tabstyle,"inactive_class");
            tabstyle=cmp.find("themes");
            $A.util.addClass(tabstyle,"active_class");
        
            tabstyle=cmp.find("myaction");
            $A.util.removeClass(tabstyle,"active_class");
            tabstyle=cmp.find("myaction");
            $A.util.addClass(tabstyle,"inactive_class");
        }
 		if(tabName === 'myaction'){
            tabstyle=cmp.find("themes");
            $A.util.removeClass(tabstyle,"active_class");
            tabstyle=cmp.find("themes");
            $A.util.addClass(tabstyle,"inactive_class");
        
            tabstyle=cmp.find("myaction");
            $A.util.removeClass(tabstyle,"inactive_class");
            tabstyle=cmp.find("myaction");
            $A.util.addClass(tabstyle,"active_class");
        }
    },
    
})