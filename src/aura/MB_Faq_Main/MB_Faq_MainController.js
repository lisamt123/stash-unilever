({
	 getFaqListData : function(component, event, helper) {
		console.log('------------entry----------------');
        var action = component.get("c.getFaqList");
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {       
                component.set("v.faqList",response.getReturnValue());
            }   
              component.set("v.showspinner","false"); 
        });
        $A.enqueueAction(action);
	},
    gotoDevices:function(component, event, helper) {
        var backEvent=$A.get("e.c:MB_Back_Evt");
        backEvent.setParams({"month":component.get("v.CurrentMonth"),"pagename":component.get("v.Pagename")}).fire();
                                                    
    },
})