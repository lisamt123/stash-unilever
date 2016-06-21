({
    doInit: function(component, event, helper) {
        var action = component.get("c.getAutoPopulatedValues_UnileverReport");
        action.setCallback(this, function(a) {
            var responseData = a.getReturnValue();
           //component.set("v.objGetAgentDataResponse", responseData);
          // console.log("objGetAgentDataResponse==>" + JSON.stringify(component.get("v.objGetAgentDataResponse")));
            component.set("v.clusterList",responseData.clusterList);
            component.set("v.countryList",responseData.countryList);
            component.set("v.allCountryList", responseData.countryList);
            component.set("v.reportingOnList",responseData.reportingOnPicklistValues);
        });
        $A.enqueueAction(action);
        
        helper.getCompetitorReportDetails(component, event, helper);
        
        var actionIds = component.get("c.getfiterDataIds");
        actionIds.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            console.log("global id ==>"+responseId.GlobalClusterId);
            console.log("otherComp id ==>"+responseId.OtherCompetitorBrandId);
            console.log("UnileverRecord id ==>"+responseId.UnileverRecordTypeId);
            console.log("CompetitorRecord id ==>"+responseId.CompetitorRecordTypeId);
            
            component.set("v.globalClusterId",responseId.GlobalClusterId);
			component.set("v.unileverRecordTypeId",responseId.UnileverRecordTypeId);
            component.set("v.competitorRecordTypeId",responseId.CompetitorRecordTypeId);
        });
        
        $A.enqueueAction(actionIds);
     
        
      var actionUserPref = component.get("c.getUserPreference");
        actionUserPref.setCallback(this, function(a) {
            var responeSavedFilter=a.getReturnValue();
           console.log("saved Filter Values==>" + JSON.stringify(responeSavedFilter));
            console.log("ReportTypeID==>"+responeSavedFilter.RecordTypeId__c);
           component.set("v.objgetSavedFilterData",responeSavedFilter);
            component.set("v.savedRecordType",responeSavedFilter.RecordTypeId__c);
            if($A.util.isUndefined(responeSavedFilter.RecordTypeId__c)){
                console.log("reportType==>>all");
                helper.allFilterData(component, event, helper);
            }else{
               helper.savedFilterData(component, event, helper);
            }
            
        });
        $A.enqueueAction(actionUserPref);
      
	},
    
    onSelectChangeView : function(component, event, helper) {
        var filterRecordType = component.find("reportType").get("v.value");
        component.set("v.filterRecordType", filterRecordType);
    },
    
    onSelectChangeCountry : function(component, event, helper) {
        helper.getRelatedCountryList(component, event, helper);
    },
    
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        console.log("Event Handled");
        var recordId = event.getParam("sObjectId");
        var sObjAttributeName=event.getParam("sObjAttributeFieldName");
        console.log("Attribute name==>"+sObjAttributeName);
        console.log("recordId ==>"+recordId);
        if(recordId!=="null"){
        component.set("v."+sObjAttributeName, recordId);
            }
        else{
            component.set("v."+sObjAttributeName, null);
        }
    },
    
    //Handler to receive the competitor Brand change.
    handleCompetitorBrandChange: function(component, event, helper) {
        var brandId=component.get("v.competitorBrandId");
        console.log("bId in handler===>"+brandId);
        if(brandId !==null)
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
            component.find("competitorName").set("v.value","Select Competitor Name");
            component.find("category").set("v.value","Select Category");
        }
    },
 
    
    //To clear all fields of filter.
    clearFilter : function(component, event, helper) {
        var filterRecordType = component.find("reportType").get("v.value");
        component.find("reportType").set("v.value","All");
        component.set("v.filterRecordType","All");
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