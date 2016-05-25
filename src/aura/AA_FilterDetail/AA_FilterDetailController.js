({
    doInit: function(component, event, helper) {
        
        var action = component.get("c.getAutoPopulatedValues_UnileverReport");
        action.setCallback(this, function(a) {
            //console.log("ClusterList==>" + JSON.stringify(a.getReturnValue()));
            var responseData = a.getReturnValue();
            //component.set("v.objGetAgentDataResponse", responseData);
            //console.log("objGetAgentDataResponse==>" + JSON.stringify(component.get("v.objGetAgentDataResponse")));
            component.set("v.clusterList",responseData.clusterList);
            component.set("v.countryList",responseData.countryList);
            component.set("v.allCountryList", responseData.countryList);
        });
        $A.enqueueAction(action);
         
        var actionCluster = component.get("c.getGlobalClusterId");
        actionCluster.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            console.log("global id ==>"+responseId);
            component.set("v.globalClusterId",responseId);
        });
        $A.enqueueAction(actionCluster);
	},
    
    onSelectChangeView : function(component, event, helper) {
        var filterRecordType = component.find("reportType").get("v.value");
        component.set("v.filterRecordType", filterRecordType);
        console.log("Filter Type:"+filterRecordType);
        if(filterRecordType === 'All' || filterRecordType === 'Unilever Report'){
            var action = component.get("c.getAutoPopulatedValues_UnileverReport");
            action.setCallback(this, function(a) {
                var responseData = a.getReturnValue();
                component.set("v.objGetAgentDataResponse", responseData);
                component.set("v.clusterList",responseData.clusterList);
                component.set("v.countryList",responseData.countryList);
                //console.log("countryList==>" + JSON.stringify(responseData.countryList))
                component.set("v.allCountryList", responseData.countryList);
                component.set("v.reportingOnList",responseData.reportingOnPicklistValues);   
            }); 
        }else if(filterRecordType === 'Competitor Report'){
            var action = component.get("c.getSourceRetailerTopicCountry_CompetitorReport");
            action.setCallback(this, function(a) {
                var responseCompetitorData = a.getReturnValue();
                component.set("v.objGetAgentDataResponseCompetitor",responseCompetitorData);
                //console.log("complete comp data===>"+JSON.stringify(component.get("v.objGetAgentDataResponseCompetitor")));
                component.set("v.clusterList",responseCompetitorData.clusterList);
                component.set("v.countryList",responseCompetitorData.countryList);
                // console.log("countryList==>" + JSON.stringify(responseCompetitorData.countryList));
                component.set("v.allCountryList", responseCompetitorData.countryList);
                component.set("v.competitorNameList",responseCompetitorData.competitorNameList);
                component.set("v.allCompetitorNameList",responseCompetitorData.competitorNameList);
                //console.log("competitorNameList==>" + JSON.stringify(responseCompetitorData.competitorNameList));
                component.set("v.categoryList",responseCompetitorData.categoryList);
                component.set("v.allCategoryList",responseCompetitorData.categoryList);
                component.set("v.topicList",responseCompetitorData.topicList);
                
            });
            
        }
        $A.enqueueAction(action);
        
    },
    
    onSelectChangeCountry : function(component, event, helper) {
        
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
    
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var recordId = event.getParam("sObjectId");
        var sObjAttributeName=event.getParam("sObjAttributeFieldName");
        console.log("Attribute name==>"+sObjAttributeName);
        console.log("recordId ==>"+recordId);
        component.set("v."+sObjAttributeName, recordId);
    },
    
    //Handler to receive the competitor Brand change.
    handleCompetitorBrandChange: function(component, event, helper) {
        var brandId=component.get("v.competitorBrandId");
        console.log("bId in handler===>"+brandId);
        if(brandId !=='null')
        {
            var action = component.get("c.getCompetitorCategory");
            action.setParams({ "competitorBrand" : brandId});
            var newBrandNameList= [];
            var newCategoryList= [];
            
            action.setCallback(this, function(a) {
                var brandList = a.getReturnValue();
                component.set("v.competitorNameList", brandList.Agent_Competitor_Id__c);
                console.log("competitorNameList==>" + JSON.stringify(brandList));
                
                for(var brand in brandList){
                    if (brandList.hasOwnProperty(brand)) {
                        var ob = brandList[brand];
                        var singleName = new Object();
                        var singleCategory = new Object();
                        //console.log("competitorNameList==>"+JSON.stringify(ob.Agent_Competitor_Id__r.Name));
                        //console.log("competitorNameList==>"+JSON.stringify(ob.Category_Id__r.Name));
                        singleName.Id=ob.Agent_Competitor_Id__r.Id;
                        singleName.Name=ob.Agent_Competitor_Id__r.Name;
                        newBrandNameList.push(singleName);
                        singleCategory.Id=ob.Category_Id__r.Id;
                        singleCategory.Name=ob.Category_Id__r.Name;
                        newCategoryList.push(singleCategory);
                        
                    }
                }
                component.set("v.competitorNameList", newBrandNameList);
                component.set("v.categoryList", newCategoryList);
                
            });
            $A.enqueueAction(action);
        }        
        else
        {
            console.log("inside brandId==null condition")
            var competitorName=component.get("v.allCompetitorNameList");
            var categoryList=component.get("v.allCategoryList");
            
            component.set("v.competitorNameList", competitorName);
            component.set("v.categoryList", categoryList);
        }
    },
 
    
    //To clear all fields of filter.
    clearFilter : function(component, event, helper) {
        var filterRecordType = component.find("reportType").get("v.value");
        component.find("clusterId").set("v.value", "Select a Cluster");
        component.find("countryId").set("v.value", "Select a Country");
        component.set("v.countryList",component.get("v.allCountryList"));
        if(filterRecordType === 'Competitor Report'){
            component.find("competitorName").set("v.value", "Select Competitor Name");
            component.set("v.competitorNameList",component.get("v.allCompetitorNameList"));
                                                     
            component.find("category").set("v.value", "Select Category");
            component.set("v.categoryList",component.get("v.allCategoryList"));
                                                     
            component.find("topic").set("v.value", "Select Topic");                                      
            
             var containerCompetitor = component.find("cBrandAutoComplete");
            $A.createComponent("c:AA_AutoComplete",
                               {label:"Competitor brand", pluralLabel:"Competitor brands", placeholderValue:"E.g Tide", sObjAttributeName:"competitorBrandId", sObjectRecordType:"Competitor Brand", sObjectAPIName:"aa_Agent_App_Competitor_Brand__c"},
                               function(cmp) {
                                   containerCompetitor.set("v.body", [cmp]);
                               });
        }
        else if (filterRecordType === 'Unilever Report'){
        component.find("reportingOnId").set("v.value", "Reporting on");
            
            var containerUnilever = component.find("uBrandAutoComplete");
            $A.createComponent("c:AA_AutoComplete",
                               {label:"Unilever brand", pluralLabel:"Unilever brands", placeholderValue:"E.g Dove", sObjAttributeName:"unileverBrandId", sObjectRecordType:"Unilever Brand", sObjectAPIName:"aa_Agent_App_Competitor_Brand__c"},
                               function(cmp) {
                                   containerUnilever.set("v.body", [cmp]);
                               });
            var containerRetailer = component.find("retailerAutoComplete");
            $A.createComponent("c:AA_AutoComplete",
                               {label:"Retailer", pluralLabel:"Retailers", placeholderValue:"E.g Marks and Spencers", sObjAttributeName:"retailerId", sObjectRecordType:"null", sObjectAPIName:"aa_Agent_Retailer__c"},
                               function(cmp) {
                                   containerRetailer.set("v.body", [cmp]);
                               });
       }
        
    },
    
    //Apply Filter
    applyFilter : function(component, event, helper) {
        var reportType=component.find("reportType").get("v.value");
        var cluster=component.find("clusterId").get("v.value");
        var country=component.find("countryId").get("v.value");
        if(component.find("clusterId").get("v.value") === 'Select a Cluster'){cluster='null';}
        if(component.find("countryId").get("v.value") === 'Select a Country'){country='null';}
        var unileverBrand='';
        var retailer='';
        var reportingOn='';
        var competitorBrand='';
        var competitorName='';
        var category='';
        var topic='';
        var selectEvent = $A.get("e.c:AA_FilterEvent");
        if(reportType === 'All'){
            selectEvent.setParams({
                	"filterType":"FilteredReports",
                	"limitRecords": component.get("v.limitRecords"),
                	"offSet":component.get("v.offSet"),
                	"applyFilter":'true',
                	"sortType":component.get("v.sortType"),
                	"clusterId":cluster,
            		"countryId":country
            		}).fire();
          }
       	else if(reportType==='Unilever Report')
        {
            unileverBrand=component.get("v.unileverBrandId");
            retailer=component.get("v.retailerId");
            reportingOn=component.find("reportingOnId").get("v.value");
            
            selectEvent.setParams({
                	"filterType":"FilteredReports",
                	"limitRecords": component.get("v.limitRecords"),
                	"offSet":component.get("v.offSet"),
                	"applyFilter":'true',
                	"sortType":component.get("v.sortType"),
                	"clusterId":cluster,
            		"countryId":country,
                    "unileverBrandId":unileverBrand,
                    "retailerId":retailer,
                    "reportingOnId":reportingOn,
                	"recordType":'Unilever'
                	}).fire();
        } else {
                competitorBrand=component.get("v.competitorBrandId");
                competitorName=component.find("competitorName").get("v.value");
                category=component.find("category").get("v.value");
                topic=component.find("topic").get("v.value"); 
          	 selectEvent.setParams({
                	"filterType":"FilteredReports",
                	"limitRecords": component.get("v.limitRecords"),
                	"offSet":component.get("v.offSet"),
                	"applyFilter":'true',
                	"sortType":component.get("v.sortType"),
                	"clusterId":cluster,
            		"countryId":country,
                    "unileverBrandId":null,
                    "retailerId":null,
                    "reportingOnId":null,
                	"recordType":'Competitor',
                    "competitorBrandId":competitorBrand,
                    "competitorId":competitorName,
                    "categoryId":category,
                 	"topicId":topic,
                	}).fire();
            }
        	
         },
    cancelFilter: function(component, event, helper) {
        var selectEvent = $A.get("e.c:AA_FilterEvent");
        selectEvent.setParams({"filterType":component.get("v.filterType"),"limitRecords": component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"applyFilter":'false',"sortType":component.get("v.sortType"),"countryId":component.get("v.countryId"),"clusterId":component.get("v.clusterId")}).fire(); 
        //selectEvent.setParams({"filterType":component.get("v.filterType"),"limitRecords": component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"applyFilter":'false',"sortType":component.get("v.sortType"),"countryId":null,"clusterId":null}).fire(); 
    },
})