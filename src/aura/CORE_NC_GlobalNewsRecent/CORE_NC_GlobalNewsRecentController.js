({
	getGlobalNewsMostRecent : function(component, event, helper) {
		var action = component.get("c.getGlobalNewsForMostRecent");
        var selectedFilterType;
        var selectedNewsType = component.get("v.NewsType");
        console.log(selectedNewsType+'------------0----------------'+component.get("v.filterType"));
        switch (component.get("v.filterType")) {
            case "showCategories":  selectedFilterType = "Categories and Brands";
                					break;
            case "showInnovation":  selectedFilterType = "Innovation";
                					break;
            case "showLeadership":  selectedFilterType = "Leadership";
                					break;
            case "showMarketplace":  selectedFilterType = "Marketplace";
                					break;
            case "showPeople":  selectedFilterType = "Our People";
                					break;
            case "showPerformance":  selectedFilterType = "Performance and Strategy";
                					break;
            case "showSustainable":  selectedFilterType = "Sustainable Living";
                					break;
            default: selectedFilterType = "all";
        }
        action.setParams({
			"NewsType": component.get("v.NewsType")
		});
        action.setCallback(this, function(response) {
        	var state = response.getState();
            console.log('------------0----------------'+state);
        	if (state === "SUCCESS") {
                if(response.getReturnValue()!=''){      
                    console.log('------------1----------------'+selectedFilterType);  
                    var updatedData = []; 
                    var responseData = [];
                    if(selectedNewsType=='GlobalNews' && selectedFilterType!='all'){ 
                        responseData = response.getReturnValue();
                        for(var count=0;count<responseData.length;count++){
                            console.log(responseData[count]);    
                            //if(selectedFilterType == responseData[count].Topics.toLowerCase())
                            if(selectedFilterType == responseData[count].Topics)
                                updatedData.push(responseData[count]);
                        }
                        //console.log('------------4----------------'+updatedData.length); 
                        if(updatedData.length==0)
                            component.set("v.ErrorMessage", true);  
                        component.set("v.wrapper", updatedData);
                    } else
                        updatedData = response.getReturnValue();                 
                    if(response.getReturnValue().length>0)
                        component.set("v.displayFilter", true);  
                    if(updatedData.length>0 && updatedData.length>updatedData[0].LoadMoreLimit)   {
                    	responseData = [];
                        for(var count=0;count<updatedData[0].LoadMoreLimit;count++){
                            console.log(updatedData[count]);    
                            responseData.push(updatedData[count]);
                        }
                    	component.set("v.loadMoreDisplay",true);
                    	component.set("v.NewsList", responseData);
                    	component.set("v.wrapper", updatedData);
                    } else
                        component.set("v.NewsList",updatedData);                    
                } else 
                    component.set("v.ErrorMessage", true);
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
        if(updatedData.length==responseData.length)
            component.set("v.loadMoreDisplay",false);
        else            
            component.set("v.loadMoreDisplay",true);
        component.set("v.NewsList", responseData);
    },
    GetRecentNewsmethod : function(component, event, helper) {
		//this.getGlobalNewsMostRecent();
		//alert('Came');
	},
    fixedBottomBar: function(component, event, helper) {
		//this.getGlobalNewsMostRecent();
		//alert('Came');
	},
    getNewsDetail1:function(component, event, helper) {
        //alert(11);
        //alert(event.getParam("selectedNewsDetail"));
        var selected = event.getParam("selectedNewsDetail");
        //var cmp=component.get("v.newsArticle");
       
        //alert(selected);
        //component.set("v.selectedNews", selected);
    },        
    gotoFilter: function(component, event, helper) {
        var FilterType=component.get("v.filterType");
        var selectEvent = $A.get("e.c:CORE_NC_FilterEvent");
        selectEvent.setParams({"selectedFilter": FilterType,"displayFilterPage":true }).fire();
    }
})