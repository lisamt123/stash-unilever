({
	getGlobalNewsMostRecent : function(component, event, helper) {
		var action = component.get("c.getGlobalNewsForMostRecent");
        var selectedFilterType = component.get("v.filterType");
        var selectedNewsType = component.get("v.NewsType");
        console.log(selectedNewsType+'------------0----------------'+component.get("v.filterType"));
        action.setParams({
			"NewsType": component.get("v.NewsType")
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
            console.log('------------0----------------'+state);
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){  
                              
                    component.set("v.showspinner",false);
                    console.log('------------1----------------'+selectedFilterType);  
                    var updatedData = []; 
                    var responseData = [];
                    if(selectedNewsType=='GlobalNews' && selectedFilterType!='Show All'){ 
                        responseData = response.getReturnValue();
                        for(var count=0;count<responseData.length;count++){
                            console.log(responseData[count]);    
                            if(selectedFilterType == responseData[count].Topics) {
                                updatedData.push(responseData[count]);
                            }
                        }
                        //console.log('------------4----------------'+updatedData.length); 
                        if(updatedData.length==0) {
                            component.set("v.ErrorMessage", true); 
                        } 
                        component.set("v.wrapper", updatedData);
                         
                    } else {
                        updatedData = response.getReturnValue(); 
                    }
                    if(response.getReturnValue().length>0) {
                        component.set("v.displayFilter", true); 
                    }
                    if(updatedData.length>0 && updatedData.length>updatedData[0].LoadMoreLimit)   {
                    	responseData = [];
                        for(var count=0;count<updatedData[0].LoadMoreLimit;count++){
                            console.log(updatedData[count]);    
                            responseData.push(updatedData[count]);
                        }
                    	component.set("v.loadMoreDisplay",true);
                    	component.set("v.NewsList", responseData);
                    	component.set("v.wrapper", updatedData);
                    } else {
                        component.set("v.NewsList",updatedData); 
                    }                   
                } else {
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
            console.log(updatedData[count]);    
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
    gotoFilter: function(component, event, helper) {
        var FilterType=component.get("v.filterType");
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": FilterType,"displayFilterPage":true }).fire();
    }
    
})