({
	filterCampaignsList : function(component, campaignsList) {
        var campaignListData = component.get("v.campaignsList");
        var campaignLimit = component.get("v.campaignsList").length+component.get("v.showMoreLimit");
        for(var count=component.get("v.campaignsList").length; count<campaignLimit && count<campaignsList.length; count++){
            campaignListData.push(campaignsList[count]);
        }
        this.handleLoadMore(component,campaignsList,campaignListData);
        component.set("v.campaignsList",campaignListData);
	},
    filterCampaignsListOnLoad : function(component, campaignsList, selectedFilterType) {
        component.set("v.selectedCampaignFilter",selectedFilterType);
        if(campaignsList.length>component.get("v.showMoreLimit")) {
            var campaignsArray = [];
            for(var count=0;count<component.get("v.showMoreLimit");count++){
                campaignsArray.push(campaignsList[count]);
            }
        	this.handleLoadMore(component,campaignsList,campaignsArray);
            component.set("v.campaignsList", campaignsArray);
        } else {
            component.set("v.displayLoadMore",false);
            component.set("v.campaignsList", campaignsList);
        }  
        if(campaignsList.length==0 || campaignsList.length==null) {
            component.set("v.displayErrorMessage",true);
        }
    },
    handleLoadMore : function(component, campaignsList,campaignListData){
        if(campaignListData.length==campaignsList.length) {
            component.set("v.displayLoadMore",false);
        }
        else {
            component.set("v.displayLoadMore",true);
        }    
    }
})