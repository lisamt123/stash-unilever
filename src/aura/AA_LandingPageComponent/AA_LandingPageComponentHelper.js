({
    scrollToLocation : function(component, location) {
      var scroller = this.getScroller(component),
            payload = {
                time: 300,
            };
        if(typeof location === "string") {
            payload.destination = location;
        } else if(location instanceof HTMLElement) {
            payload.destination = "custom";
            payload.xcoord = location.offsetLeft;
            payload.ycoord = -location.offsetTop;
        }
        scroller.getEvent("scrollTo").setParams(payload).fire();
    },
    //THIS IS AN ABSOLUTE HACK AND MOST LIKELY WILL BREAK IN SUMMER16!
    getScroller : function(component) {
        var elem = component.getElement(),
            scroller;
        while(elem && !elem.classList.contains("centerUiScroller")) {
            elem = elem.parentElement;
        }  
        scroller = $A.componentService.getRenderingComponentForElement(elem);        
        scroller = scroller && scroller.getComponentValueProvider();
        $A.assert(scroller && scroller.isInstanceOf("ui:scroller"), 
                  "SCROLLER NOT FOUND. If this is broken, it's because this was a temporary workaround for something that will be fixed in 202.");
        return scroller;
    },
    checkMobileBrowser : function(component){
        if( /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent) ) {
            return true;	
        }else{
            return false;
        }
    },
    getAllData : function(component) {
        var actionResult = component.get("c.getRetriveAllAgentReports");
        actionResult.setParams({
            "filterType":  component.get("v.filterType"),
            "sortType":  component.get("v.sortType"),
            "limitRecords":  component.get("v.limitRecords"),
            "offSet":  component.get("v.offSet"),
            "applyFilter": component.get("v.applyFilter"),
            "clusterId":component.get("v.clusterId"),                               
            "countryId":component.get("v.countryId"),
            "unileverBrandId":component.get("v.unileverBrandId"),
            "retailerId":component.get("v.retailerId"),
            "reportingOnId":component.get("v.reportingOnId"),
            "recordType":component.get("v.recordType"),
            "competitorBrandId":component.get("v.competitorBrandId"),
            "competitorId":component.get("v.competitorId"),
            "categoryId":component.get("v.categoryId"),
            "topicId":component.get("v.topicId"),
        });
        actionResult.setCallback(this, function(a) {
            if (a.getState() === "SUCCESS") {
                var results = a.getReturnValue();
                component.set("v.objPassAgentReportsToNG", results.objAgentReportsData);
                component.set("v.totalReportCount", results.TotalAgentReportsCount);
            } else if (a.getState() === "ERROR") {
                component.set("v.objPassAgentReportsToNG", null);
            }
        });
        
        $A.enqueueAction(actionResult);			
    },    
})