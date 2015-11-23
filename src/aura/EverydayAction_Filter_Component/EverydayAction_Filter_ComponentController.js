({
	getThemes1 : function(component, event, helper) {
         //component.set("v.temp","All Themes");
        //Boosting Wellbeing
         //component.set("v.previous","All Theme");
        var action=component.get("c.getThemes");
        action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    if(response.getReturnValue()!=''){
                        var items=response.getReturnValue();
                      // alert(items.length); 
                     component.set("v.Themes", response.getReturnValue());
                    
                         
                       
                   }
                }
                });
            $A.enqueueAction(action);
		
	},
    applyfilter : function(component, event, helper) {
        var chk=component.find("chkbx").get("v.value");
       // var chkvalue=chk.get("v.value");
        alert(chk);
        if(chkvalue){
            var val=component.find("themeName");
            var name= val.get("v.value")   ;
            alert(name);
                                   
           
        }
    },
    
   
    
    applyFilter : function(component, event, helper) {
          var filtername=component.get("v.temp");
          
        var filtername=component.get("v.temp");
       
       
        var activeEvent=$A.get("e.c:EverydayAction_FilterEvent");
         //var filtername1='theme';
        activeEvent.setParams({"selectedfilter":filtername});
        activeEvent.fire();
       
        
    },
    filterCancel : function(component, event, helper) {
        
        var previousfilter=component.get("v.previous");
        //alert(previousfilter);
        //.setParams({"theme" : themename});
        var filterEvent=$A.get("e.c:EverydayAction_Filter_Cancel_Event");
        filterEvent.setParams ({"previousFilter":previousfilter});
        filterEvent.fire();
    },
    
    activeFilter : function(component, event, helper){
       var theme=event.getParam("theme"); 
   
        component.set("v.temp",theme);
      
    }
    

})