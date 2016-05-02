({
	doInit : function(component, event, helper) {
		var action = component.get("c.getTrendingNews");
        action.setParams({
            NewsType: component.get("v.NewsType"),
            SortType: component.get("v.SortType")
        });
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){
                    var updatedData = response.getReturnValue();
                    var responseData = [];
                    if(updatedData.length>0 && updatedData.length>updatedData[0].LoadMoreLimit)   {
                        for(var count=0;count<updatedData[0].LoadMoreLimit;count++){
                            responseData.push(updatedData[count]);
                        }
                    	component.set("v.loadMoreDisplay",true);
                    	component.set("v.NewsList", responseData);
                    	component.set("v.wrapper", updatedData);
                    } else {
                        component.set("v.NewsList",updatedData);
                    }
                }
                else {
                    component.set("v.ErrorMessage", true);
                }
        	}
        });
        $A.enqueueAction(action);
	},
    loadMoreNewsList: function(component, event, helper) {
        var updatedData=component.get("v.wrapper");
        var currentData=component.get("v.NewsList");
        var responseData = [];
        for(var count=0; count<currentData.length+updatedData[0].LoadMoreLimit && count<updatedData.length; count++){
            responseData.push(updatedData[count]);
        }
        if(updatedData.length==responseData.length) {
            component.set("v.loadMoreDisplay",false);
        }
        else {
            component.set("v.loadMoreDisplay",true);
        }
        component.set("v.NewsList", responseData);
    },
})