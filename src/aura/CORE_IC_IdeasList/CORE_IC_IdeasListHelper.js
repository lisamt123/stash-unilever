({
    checkSelectedFilter : function(component, selectedSortType) {
        var ideasListType ='';
        if(component.get("v.selectedFilterType")=="openCampaign"){  
            ideasListType = "v.activeIdeasList";
        } else if(component.get("v.selectedFilterType")=="closedCampaign"){
            ideasListType = "v.closedIdeasList";
        } else if(component.get("v.selectedFilterType")=="myIdeas"){
            ideasListType = "v.myUpdatesList";
        }        
        this.checkSelectedSort(component,ideasListType,selectedSortType,component.get("v.selectedFilterType"));
    },
    checkSelectedSort : function(component, ideasListType, selectedSortType, selectedFilterType) { 
        var ideasList=component.get(ideasListType);
        if(ideasList.length>0){           
            switch(selectedSortType) {
                case "latestIdea": this.sortData(ideasList,'MinutesBetween','ASC');
                                   break;
                case "mostVotedIdea": this.sortData(ideasList,'VoteCount','DESC');
                                   break;
                //case "mostCommentedIdea": this.sortData(ideasList,'CommentCount','DESC');
                default : this.sortData(ideasList,'CommentCount','DESC');
                                   break;
            }
        	component.set("v.selectedSortType",selectedSortType); 
            component.set(ideasListType,ideasList);
            this.filterIdeasListOnLoad(component,ideasList,selectedFilterType);
        } else {            
            this.setDefaultSortFilter(component,selectedSortType,selectedFilterType);
            component.set("v.displayErrorMessage",true);
        	this.hidePostAnIdea(component, ideasList);
            component.set("v.displayLoadMore",false);
        }
    }, 
    sortData : function(ideaList, value,sortOrder)
    {
        var swapped;
        do {
            swapped = false;
            for (var count = 0; count < ideaList.length - 1; count++) {
                if (ideaList[count][value] < ideaList[count + 1][value]) {
                    var temp = ideaList[count];
                    ideaList[count] = ideaList[count + 1];
                    ideaList[count + 1] = temp;
                    swapped = true;
                }
            }
        } while (swapped);         
        if(sortOrder=='ASC'){
            ideaList.reverse();
        } 
    },    
    filterIdeasListOnLoad : function(component, ideasList, selectedFilterType) {
        component.set("v.selectedFilterType",selectedFilterType);
        if(ideasList.length>component.get("v.showMoreLimit")) {
            var ideasArray = [];
            for(var count=0;count<component.get("v.showMoreLimit");count++) {
                ideasArray.push(ideasList[count]);
            }
        	this.handleLoadMoreIcon(component,ideasList,ideasArray);
            component.set("v.ideasList", ideasArray);
        } else {
            component.set("v.ideasList", ideasList); 
            component.set("v.displayLoadMore",false);
        }  
        if(ideasList.length==null || ideasList.length==0) {
            component.set("v.displayErrorMessage",true);
        }
        this.hidePostAnIdea(component, ideasList);
        console.log('------------data-------------'+ideasList);   
        console.log('------------display load more-------------'+component.get("v.displayLoadMore"));                      
        component.set("v.showspinner",false);
    },
	loadMoreIdeasHelper: function(component, campaignsList) {
        var campaignListData = component.get("v.ideasList");
        var campaignLimit = component.get("v.ideasList").length+component.get("v.showMoreLimit");
        for(var count=component.get("v.ideasList").length; count<campaignLimit && count<campaignsList.length; count++) {
            campaignListData.push(campaignsList[count]);
        }
        this.handleLoadMoreIcon(component,campaignsList,campaignListData); 
        component.set("v.ideasList",campaignListData); 
	},  
    handleLoadMoreIcon : function(component, ideasList,campaignListData){
        if(campaignListData.length==ideasList.length) {
            component.set("v.displayLoadMore",false);
        } else {
            component.set("v.displayLoadMore",true);
        }    
    },
    displayTrenddingIdeas : function(component, ideasList,selectedFilterType){
        var action = component.get("c.getIdeaList");
        action.setParams({
            "ideaLimit": "4"
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {    
                if(response.getReturnValue().IdeasOfTheWeek!=null){
                    var trendingIdeasList = response.getReturnValue().IdeasOfTheWeek;   
                    this.sortData(trendingIdeasList,'MinutesBetween','ASC');
                    component.set("v.trendingIdeasList",trendingIdeasList);
        			component.set("v.selectedSortType","trendingIdea");
					this.filterIdeasListOnLoad(component,trendingIdeasList,selectedFilterType); 
                } else {
                    helper.checkSelectedSort(component,"v.activeIdeasList","latestIdea",selectedFilterType);
					//this.filterIdeasListOnLoad(component,ideasList,selectedFilterType);  
                }   
            } else {
                helper.checkSelectedSort(component,"v.activeIdeasList","latestIdea",selectedFilterType);
            }    	                   
        });
        $A.enqueueAction(action);
    },
    hidePostAnIdea : function(component,ideasList){
        if(ideasList.length==0){
            component.set("v.displayPostIdea",true);
        } else {
            component.set("v.displayPostIdea",false);
        }
    },
    initializeDefaultValues : function(component) {        
        component.set("v.ideasList", []); 
        component.set("v.showspinner",true);   
        component.set("v.displayErrorMessage",false);
        component.set("v.showFilter",false); 
    },
    setDefaultSortFilter : function(component,selectedSortType,selectedFilterType) {  
        component.set("v.selectedSortType",selectedSortType);   
        component.set("v.selectedFilterType",selectedFilterType);
    },
    defaultOnCancel : function(component) {
        component.set("v.displayPostIdea",true);
        component.set("v.displayErrorMessage",true);  	
        component.set("v.showFilterSort",false);                          
        component.set("v.showspinner",false);
    },
})