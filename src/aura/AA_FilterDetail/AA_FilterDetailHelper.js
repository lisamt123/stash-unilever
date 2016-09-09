({	
    getCompetitorReportDetails: function(component, event, helper) {
        var action = component.get("c.getSourceRetailerTopicCountry_CompetitorReport");
        action.setCallback(this, function(a) {
            var responseCompetitorData = a.getReturnValue();
            component.set("v.objGetAgentDataResponseCompetitor",responseCompetitorData);
            component.set("v.competitorNameList",responseCompetitorData.competitorNameList);
            component.set("v.allCompetitorNameList",responseCompetitorData.competitorNameList);
            component.set("v.categoryList",responseCompetitorData.categoryList);
            component.set("v.allCategoryList",responseCompetitorData.categoryList);
            component.set("v.topicList",responseCompetitorData.topicList);
        });
        $A.enqueueAction(action);
    },
    
    getRelatedCountryList: function(component, event, helper)  {
        var clusterId = component.find("clusterId").get("v.value");
        component.set("v.countryList",component.get("v.allCountryList"));
        var allCountryList =component.get("v.allCountryList");
        var newCountryList= [];
        //to enable and disable country dropdown list when Global cluster has been selected.
        if(clusterId===component.get("v.globalClusterId"))
        {
            component.set("v.check","true");
        }
        else
        {
            component.set("v.check","false");
        }
        //to display the country list based on the cluster selected
        if(clusterId==="Select a Cluster")
        {
            component.set("v.countryList", allCountryList) 
        }
        else
        {
            for (var ctry in allCountryList) {
                if (allCountryList.hasOwnProperty(ctry)) {
                    var ob = allCountryList[ctry];
                    var singleObj =[];
                    if(clusterId===ob.Cluster_Id__c)
                    {
                        singleObj.Id=ob.Id;
                        singleObj.Name=ob.Name;
                        singleObj.Cluster_Id__c=ob.Cluster_Id__c;
                        newCountryList.push(singleObj);
                    }
                }
            }
            component.set("v.countryList", newCountryList);
        }
    },
    allFilterData: function(component, event, helper) {
        var savedFilterData=component.get("v.objgetSavedFilterData");
        component.find("reportType").set("v.value","All");
        component.set("v.filterRecordType",'');
        if(!$A.util.isUndefined(savedFilterData.Cluster__c)){
            component.find("clusterId").set("v.value",savedFilterData.Cluster__c);
            this.getRelatedCountryList(component, event, helper);
            component.find("countryId").set("v.value",savedFilterData.Country__c);
        }else{
            component.find("countryId").set("v.value",savedFilterData.Country__c);
        }
    },
    savedFilterData: function(component, event, helper) {
        var brandName="";
        var retailerName="";
        var savedFilterData=component.get("v.objgetSavedFilterData");
        var unileverRecordId=component.get("v.unileverRecordTypeId");
        var competitorRecordId=component.get("v.competitorRecordTypeId");
        if(savedFilterData.RecordTypeId__c === unileverRecordId ){
            component.find("reportType").set("v.value","Unilever Report");
            component.set("v.filterRecordType",'Unilever Report');
            if(!$A.util.isUndefined(savedFilterData.Cluster__c)){
                component.find("clusterId").set("v.value",savedFilterData.Cluster__c);
                this.getRelatedCountryList(component, event, helper);
                component.find("countryId").set("v.value",savedFilterData.Country__c);
            }else{
                component.find("countryId").set("v.value",savedFilterData.Country__c);
            }
            component.find("reportingOnId").set("v.value",savedFilterData.ReportingOn__c);
            component.set("v.retailerId",savedFilterData.Retailer__c);
            if(!$A.util.isUndefined(savedFilterData.Agent_App_Unilever_Brand__c)){
                component.set("v.unileverBrandId",savedFilterData.Agent_App_Unilever_Brand__c);
                var actionBrandName = component.get("c.getBrandName");
                actionBrandName.setParams({ "brandId" : savedFilterData.Agent_App_Unilever_Brand__c});
                actionBrandName.setCallback(this, function(a) {
                    var responseName = a.getReturnValue();
                    brandName=responseName;
                    component.set("v.savedUnileverBrandName",brandName);
                });
                $A.enqueueAction(actionBrandName);
            }   
            if(!$A.util.isUndefined(savedFilterData.Retailer__c)){
                component.set("v.retailerId",savedFilterData.Retailer__c);
                var actionRetailerName = component.get("c.getRetailerName");
                actionRetailerName.setParams({ "retailerId" : savedFilterData.Retailer__c});
                actionRetailerName.setCallback(this, function(a) {
                    var responseRetailerName = a.getReturnValue();
                    retailerName=responseRetailerName;
                    component.set("v.savedRetailerName",responseRetailerName);
                });
                $A.enqueueAction(actionRetailerName);
            }  
        }
        else if(savedFilterData.RecordTypeId__c === competitorRecordId){
            component.find("reportType").set("v.value","Competitor Report");
            component.set("v.filterRecordType",'Competitor Report');
            if(!$A.util.isUndefined(savedFilterData.Cluster__c)){
                component.find("clusterId").set("v.value",savedFilterData.Cluster__c);
                this.getRelatedCountryList(component, event, helper);
                component.find("countryId").set("v.value",savedFilterData.Country__c);
            }else{
                component.find("countryId").set("v.value",savedFilterData.Country__c);
            }
            component.find("topic").set("v.value",savedFilterData.Topic__c);
            if(!$A.util.isUndefined(savedFilterData.Competitor_Brand__c)){
                component.set("v.competitorBrandId",savedFilterData.Competitor_Brand__c);
                var actionBrandName = component.get("c.getBrandName");
                actionBrandName.setParams({ "brandId" : savedFilterData.Competitor_Brand__c});
                actionBrandName.setCallback(this, function(a) {
                    var responseName = a.getReturnValue();
                    brandName=responseName;
                    component.set("v.savedCompetitorBrandName",brandName);
                    component.find("competitorName").set("v.value",savedFilterData.Competitor_Name__c);
                    component.find("category").set("v.value",savedFilterData.Category__c);
                });
                $A.enqueueAction(actionBrandName);
            }
            else{
                component.find("competitorName").set("v.value",savedFilterData.Competitor_Name__c);
                component.find("category").set("v.value",savedFilterData.Category__c);
            }
        }
    },
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
})