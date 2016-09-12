({
	getGlobalNewsMostRecent : function(component, event, helper) {
		var action = component.get("c.getGlobalNewsForMostRecent");
        action.setParams({
			"NewsType": component.get("v.NewsType")
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
        		if(response.getReturnValue()!==''){
                    component.set("v.showspinner",false);
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
        var NewsType=component.get("v.NewsType");
        var action1 = component.get("c.getGAInfo");
		action1.setCallback(this, function(response) {
        	var state = response.getState();
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!==''){        			
                    (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;
                                             i[r]=i[r]||function(){(i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();
                                             a=s.createElement(o),m=s.getElementsByTagName(o)[0];
                                             a.async=1;
                                             a.src=g;m.parentNode.insertBefore(a,m)})(window,document,'script','//www.google-analytics.com/analytics.js','ga');
                    ga('create', response.getReturnValue().GAId, 'auto');
                    var dimensionValue1 = NewsType;
                    var dimensionValue2 = response.getReturnValue().UserId;
                    ga('set', 'dimension1', dimensionValue1);
                    ga('set', 'dimension2', dimensionValue2);
                    ga('send', 'pageview');
                }
                else {
                    component.set("v.ErrorMessageFlag", true);
                }
        	}                    
        });
        $A.enqueueAction(action1);
	},    
    loadMoreNewsList: function(component, event, helper) {
        var updatedData=component.get("v.wrapper");
        var currentData=component.get("v.NewsList");
        var responseData = [];
        for(var count=0; count<currentData.length+updatedData[0].LoadMoreLimit && count<updatedData.length; count++){
            responseData.push(updatedData[count]);
        }
        if(updatedData.length===responseData.length) {
            component.set("v.loadMoreDisplay",false);
        }
        else {
            component.set("v.loadMoreDisplay",true);
        }            
        component.set("v.NewsList", responseData);
    },
})