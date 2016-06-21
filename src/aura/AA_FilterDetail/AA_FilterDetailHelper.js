({	
    getCompetitorReportDetails: function(component, event, helper) {
        console.log("Inside get comp report details helper");
        var action = component.get("c.getSourceRetailerTopicCountry_CompetitorReport");
        action.setCallback(this, function(a) {
            var responseCompetitorData = a.getReturnValue();
            component.set("v.objGetAgentDataResponseCompetitor",responseCompetitorData);
            //console.log("complete comp data===>"+JSON.stringify(component.get("v.objGetAgentDataResponseCompetitor")));
            // component.set("v.clusterList",responseCompetitorData.clusterList);
            // component.set("v.countryList",responseCompetitorData.countryList);
            // console.log("countryList==>" + JSON.stringify(responseCompetitorData.countryList));
            // component.set("v.allCountryList", responseCompetitorData.countryList);
            component.set("v.competitorNameList",responseCompetitorData.competitorNameList);
            component.set("v.allCompetitorNameList",responseCompetitorData.competitorNameList);
            //console.log("competitorNameList==>" + JSON.stringify(responseCompetitorData.competitorNameList));
            component.set("v.categoryList",responseCompetitorData.categoryList);
            component.set("v.allCategoryList",responseCompetitorData.categoryList);
            component.set("v.topicList",responseCompetitorData.topicList);
            
        });
        $A.enqueueAction(action);
        
    },
    
    getRelatedCountryList: function(component, event, helper)  {
        console.log("inside related country list helper");
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
        if(clusterId=="Select a Cluster")
        {
            component.set("v.countryList", allCountryList) 
        }
        else
        {
            for (var ctry in allCountryList) {
                if (allCountryList.hasOwnProperty(ctry)) {
                    var ob = allCountryList[ctry];
                    var singleObj = new Object();
                    if(clusterId==ob.Cluster_Id__c)
                    {
                        console.log(clusterId +"==>"+ob.Id+"==>"+ ob.Name);
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
        console.log("Inside Helper");
        var savedFilterData=component.get("v.objgetSavedFilterData");
        component.find("reportType").set("v.value","All");
        component.set("v.filterRecordType",'');
        
        if(!$A.util.isUndefined(savedFilterData.Cluster__c)){
            console.log("Cluster is defined");
            component.find("clusterId").set("v.value",savedFilterData.Cluster__c);
            this.getRelatedCountryList(component, event, helper);
            component.find("countryId").set("v.value",savedFilterData.Country__c);
        }else{
            component.find("countryId").set("v.value",savedFilterData.Country__c);
        }
        
    },
    savedFilterData: function(component, event, helper) {
        console.log("Inside Helper 2");
        var brandName="";
        var retailerName="";
        var savedFilterData=component.get("v.objgetSavedFilterData");
        var unileverRecordId=component.get("v.unileverRecordTypeId");
        var competitorRecordId=component.get("v.competitorRecordTypeId");
        console.log("Unilever Report ID===>"+unileverRecordId);
        
        if(savedFilterData.RecordTypeId__c === unileverRecordId ){
            console.log("inside helper : Unilever");
            component.find("reportType").set("v.value","Unilever Report");
            component.set("v.filterRecordType",'Unilever Report');
            
            if(!$A.util.isUndefined(savedFilterData.Cluster__c)){
                console.log("Cluster is defined");
                component.find("clusterId").set("v.value",savedFilterData.Cluster__c);
                this.getRelatedCountryList(component, event, helper);
                component.find("countryId").set("v.value",savedFilterData.Country__c);
            }else{
                component.find("countryId").set("v.value",savedFilterData.Country__c);
            }
            
            component.find("reportingOnId").set("v.value",savedFilterData.ReportingOn__c);
            component.set("v.retailerId",savedFilterData.Retailer__c);
            // console.log("Unilever Brand Id-->"+component.get("v.unileverBrandId"));
            
            if(!$A.util.isUndefined(savedFilterData.Agent_App_Unilever_Brand__c)){
                component.set("v.unileverBrandId",savedFilterData.Agent_App_Unilever_Brand__c);
                var actionBrandName = component.get("c.getBrandName");
                actionBrandName.setParams({ "brandId" : savedFilterData.Agent_App_Unilever_Brand__c});
                actionBrandName.setCallback(this, function(a) {
                    var responseName = a.getReturnValue();
                    brandName=responseName;
                    component.set("v.savedUnileverBrandName",brandName);
                    console.log("brand Name ==>"+brandName);
                    
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
                    console.log("retailer Name ==>"+responseRetailerName);
                    
                });
                $A.enqueueAction(actionRetailerName);
            }  
        }
        
       else if(savedFilterData.RecordTypeId__c === competitorRecordId){
            console.log("inside helper : Competitor");
            component.find("reportType").set("v.value","Competitor Report");
            component.set("v.filterRecordType",'Competitor Report');
            if(!$A.util.isUndefined(savedFilterData.Cluster__c)){
                console.log("Cluster is defined");
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
                    console.log("brand Name ==>"+brandName);
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
})