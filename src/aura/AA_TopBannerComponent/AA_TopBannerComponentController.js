({
    goToURL : function(component,event,helper){
        var urlEvent=$A.get("e.force:navigateToURL");
        urlEvent.setParams({"url":"/_ui/core/chatter/ui/ChatterPage"});
        urlEvent.fire();
    },
    goToCompetitorpage: function(component, event, helper) {
        var selectEvent=$A.get("e.c:AA_NavigateToPageDetail");
        selectEvent.setParams({"navigate":"AA_CompetitorFormComponent","filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
    goToUnileverForm: function(component, event, helper) {
        var selectEvent=$A.get("e.c:AA_NavigateToPageDetail");
        selectEvent.setParams({"navigate":"AA_UnileverFormComponent","filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
})