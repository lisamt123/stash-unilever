({
    getAllThemeColor : function(component) {
        var action2=component.get("c.getThemeColors");
        action2.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var color= response.getReturnValue();
                //alert(color);
                component.set("v.themeColors", color);
            }
        });
        $A.enqueueAction(action2);
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
            $A.util.addClass(tabstyle,"slds-active");
            
            tabstyle=cmp.find("myaction");
            $A.util.removeClass(tabstyle,"slds-active");
            
        }
        if(tabName === 'myaction'){
            
            tabstyle=cmp.find("myaction");
            $A.util.addClass(tabstyle,"slds-active");
            
            tabstyle=cmp.find("themes");
            $A.util.removeClass(tabstyle,"slds-active");
            
        }
    },
    
    getBoolean :function(cmp,event){
        
        var action=cmp.get("c.getbooleanvalue");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue()!=='') {
                var items=response.getReturnValue();
                //component.set("v.activityid",items[0].Id);
                cmp.set("v.booleanValue", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    } 
    
}
 
 })