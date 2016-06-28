({
    doInit: function(component, event, helper) {
        component.set("v.contentId",null);
        component.set("v.versionId",null);
        var action = component.get("c.getAutoPopulatedValues_UnileverReport");
        action.setCallback(this, function(a) {
            var responseData = a.getReturnValue();
            component.set("v.objGetAgentDataResponse", responseData);
            component.set("v.clusterList",responseData.clusterList);
            component.set("v.countryList",responseData.countryList);
            component.set("v.allCountryList", responseData.countryList);
            component.set("v.reportingOnList",responseData.reportingOnPicklistValues);
        });
        $A.enqueueAction(action);
        var actionCluster = component.get("c.getGlobalClusterId");
        actionCluster.setCallback(this, function(a) {
            var responseId = a.getReturnValue();
            component.set("v.globalClusterId",responseId);
            component.set("v.showMap",true);
        });
        $A.enqueueAction(actionCluster);
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
    handleIdUpdate : function(component, event, helper) {
        // Get the Id from the Event
        var recordId = event.getParam("sObjectId");
        var sObjAttributeName=event.getParam("sObjAttributeFieldName");
        component.set("v."+sObjAttributeName, recordId);
    },
    handleSelectedUsers : function(component, event, helper) {
        // Get the list of the selected users
        var selectedUser=event.getParam("selectedUser");
        component.set("v.selectedUsers",selectedUser);  
    },
    cancel: function(component, event, helper) {
        var selectEvent = $A.get("e.c:AA_NavigateToPageDetail");
        selectEvent.setParams({"navigate":"AA_LandingPageComponent","filterTypeLabel":"All Reports", "filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
    },
    submitReport: function(component, event, helper) {
        var title=component.find("reportTitle");
        var titleVal=title.get("v.value");
        var cluster=component.find("clusterId");
        var clusterVal=cluster.get("v.value");
        var country=component.find("countryId");
        var countryVal=country.get("v.value");
        if(titleVal === '' && (clusterVal==="Select a Cluster" && countryVal === "Select a Country") )
        {
            title.set("v.errors", [{message:"This field is required."}]);
            cluster.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
            country.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
        }
        else if(titleVal === '')
        {
            title.set("v.errors", [{message:"This field is required."}]);
            cluster.set("v.errors", null);
            country.set("v.errors", null);
        }
            else if(clusterVal==="Select a Cluster" && countryVal === "Select a Country")
            {
                title.set("v.errors", null);
                cluster.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);
                country.set("v.errors", [{message:"This field is required.Select either cluster or country."}]);            
            }
                else{
                    title.set("v.errors", null);
                    cluster.set("v.errors", null);
                    country.set("v.errors", null);
                    var selectedUsers=component.get("v.selectedUsers");
                    //var addIds=[];
                    var userIdString="";
                    for (var sel in selectedUsers) {
                        if (selectedUsers.hasOwnProperty(sel)) {
                            var ob = selectedUsers[sel];
                            if(userIdString.length === 0)
                            {
                                userIdString=ob.Id;
                            }
                            else{
                                userIdString=userIdString+","+ob.Id;
                            }
                        }
                    } 
                    var action=component.get("c.insertAgentApp");
                    action.setParams({ "clusterId" :component.find("clusterId").get("v.value") , 
                                      "countryId" :component.find("countryId").get("v.value") ,
                                      "town":component.find("townValue").get("v.value") ,
                                      "reportName":component.find("reportTitle").get("v.value") ,
                                      "reportDescription": component.find("reportDesc").get("v.value"),
                                      "userIds": userIdString,
                                      "unileverBrandId": component.get("v.unileverBrandId"),
                                      "retailerId": component.get("v.retailerId"),
                                      "reportingOnId": component.find("reportingOnId").get("v.value"),
                                      "recordType":'Unilever',
                                      "status":'Published (Public)',
                                      "contentId": component.get("v.contentId"),
                                     });
                    action.setCallback(this, function(a) {
                        var state = a.getState();
                        if (state === "SUCCESS") {
                            var successMessage = component.find("successMessage");
                            $A.util.removeClass(successMessage, "hide-form");
                            setTimeout(function() {
                                var selectEvent = $A.get("e.c:AA_NavigateToPageDetail");
                                selectEvent.setParams({"navigate":"AA_LandingPageComponent","filterType":component.get("v.filterType"),"sortType":component.get("v.sortType"),"limitRecords":component.get("v.limitRecords"),"offSet":component.get("v.offSet"),"clusterId":component.get("v.clusterId"),"countryId":component.get("v.countryId")}).fire();
                            },5000);
                        }
                        else{
                            console.log("Record Not Saved..!");
                        }
                    });
                    $A.enqueueAction(action);
                }
    },
    handleContentVersionData:function(component,event,helper){
        component.set("v.contentId",event.getParam("cId"));    
        component.set("v.versionId",event.getParam("vId"));    
        component.set("v.attachedId",event.getParam("vId"));    
    },
    gotoMap: function(component, event, helper) {
        var showMap = component.get("v.showMap");        
        if (showMap == true) {
            component.set("v.showMap",false);
            var manualLocation=component.find("ManualLocation");
            $A.util.removeClass(manualLocation, "hide-form"); 
            component.set("v.townName",'');
            component.find("countryId").set("v.value","Select Country");
        }
        if (showMap == false){
            component.set("v.showMap",true); 
            var manualLocation=component.find("ManualLocation");
            $A.util.addClass(manualLocation, "hide-form"); 
        }                             
    },
    getLocationDetails: function(component, event, helper) {
        var latitude=event.getParam("latitude");
        var Longitude=event.getParam("longitude");
        var countryName=event.getParam("countryName");
        var townName=event.getParam("townName");
        component.set("v.latitude",latitude);
        component.set("v.longitude",Longitude);
        component.set("v.townName",townName);
        var allCountryList=component.get("v.allCountryList");
        for (var ctry in allCountryList) {
            if (allCountryList.hasOwnProperty(ctry)) {
                var ob = allCountryList[ctry];
                var singleObj =[];
                if(countryName===ob.Name)
                {
                    component.find("countryId").set("v.value",ob.Id);
                }
            }
        }
    },
})